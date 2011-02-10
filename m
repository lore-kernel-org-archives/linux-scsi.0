From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/06] mptfusion: (New Feature)Support SAS2.0 Devices with SAS1.0 Controllers
Date: Thu, 10 Feb 2011 11:50:39 +0530
Message-ID: <20110210062029.GC31424@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:34686 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1BJHHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 02:07:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


SAS1.0 Controller was not able to detect SAS2.0 Expanders due to Link RATE detection was
limited to 1.5 Gbps and 3.0 Gbps for SAS1 controllers. Added detection for 6.0 Gbps link.
Now, user can mix-up 6.0 Gpbs links with SAS1.0 controller.

e.a SAS1.0 HBA <----> SAS2.0 Expander <------> SAS2.0 Expander <--------> SAS1.0 Drive.
 

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 013c7d8..22027e7 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2593,6 +2593,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
 #define MPI_SAS_IOUNIT0_RATE_SATA_OOB_COMPLETE              (0x03)
 #define MPI_SAS_IOUNIT0_RATE_1_5                            (0x08)
 #define MPI_SAS_IOUNIT0_RATE_3_0                            (0x09)
+#define MPI_SAS_IOUNIT0_RATE_6_0                            (0x0A)
 
 /* see mpi_sas.h for values for SAS IO Unit Page 0 ControllerPhyDeviceInfo values */
 
diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index 8faa4fa..fd62228 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -841,6 +841,7 @@ typedef struct _EVENT_DATA_SAS_PHY_LINK_STATUS
 #define MPI_EVENT_SAS_PLS_LR_RATE_SATA_OOB_COMPLETE         (0x03)
 #define MPI_EVENT_SAS_PLS_LR_RATE_1_5                       (0x08)
 #define MPI_EVENT_SAS_PLS_LR_RATE_3_0                       (0x09)
+#define MPI_EVENT_SAS_PLS_LR_RATE_6_0                       (0x0A)
 
 /* SAS Discovery Event data */
 
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 3e57b61..49f1d92 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7418,7 +7418,12 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 		case MPI_EVENT_SAS_PLS_LR_RATE_3_0:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
 			   "SAS PHY Link Status: Phy=%d:"
-			   " Rate 3.0 Gpbs",PhyNumber);
+			   " Rate 3.0 Gbps",PhyNumber);
+			break;
+		case MPI_EVENT_SAS_PLS_LR_RATE_6_0:
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
+			   " Rate 6.0 Gbps",PhyNumber);
 			break;
 		default:
 			snprintf(evStr, EVENT_DESCR_STR_SZ,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 482e97f..1f3e570 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3065,6 +3065,9 @@ static int mptsas_probe_one_phy(struct device *dev,
 	case MPI_SAS_IOUNIT0_RATE_3_0:
 		phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
+	case MPI_SAS_IOUNIT0_RATE_6_0:
+		phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
+		break;
 	case MPI_SAS_IOUNIT0_RATE_SATA_OOB_COMPLETE:
 	case MPI_SAS_IOUNIT0_RATE_UNKNOWN:
 	default:
@@ -3693,7 +3696,8 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 	}
 
 	if (link_rate == MPI_SAS_IOUNIT0_RATE_1_5 ||
-	    link_rate == MPI_SAS_IOUNIT0_RATE_3_0) {
+	    link_rate == MPI_SAS_IOUNIT0_RATE_3_0 ||
+	    link_rate == MPI_SAS_IOUNIT0_RATE_6_0) {
 
 		if (!port_info) {
 			if (ioc->old_sas_discovery_protocal) {
