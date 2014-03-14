From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Date: Fri, 14 Mar 2014 21:06:22 +0530
Message-ID: <20140314153622.GA7947@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:5408
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbaCNPko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 11:40:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com

A new mpt2sas driver module parameter 'disable_eedp' is added to Disable
EEDP support. By default DIF support is enabled in the driver and
this module parameter would allow users to turn it off.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    9 ++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   47 +++++++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ed810fb..7355b28 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -440,13 +440,16 @@ _base_sas_ioc_info(struct MPT2SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 ****************************************************************************/
 
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		desc = "eedp guard error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp guard error";
 		break;
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		desc = "eedp ref tag error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp ref tag error";
 		break;
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		desc = "eedp app tag error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp app tag error";
 		break;
 
 /****************************************************************************
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1f2ac3a..61b02ee 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -842,6 +842,7 @@ struct MPT2SAS_ADAPTER {
 	u32		ioc_reset_count;
 	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	u32             non_operational_loop;
+	u8      disable_eedp_support;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7f0af4f..d502728 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -127,6 +127,11 @@ static int disable_discovery = -1;
 module_param(disable_discovery, int, 0);
 MODULE_PARM_DESC(disable_discovery, " disable discovery ");
 
+/* Enable or disable EEDP support */
+static int disable_eedp;
+module_param(disable_eedp, uint, 0);
+MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");
+
 /* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
 static int prot_mask = 0;
 module_param(prot_mask, int, 0);
@@ -4031,7 +4036,8 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
-	_scsih_setup_eedp(scmd, mpi_request);
+	if (!ioc->disable_eedp_support)
+		_scsih_setup_eedp(scmd, mpi_request);
 	if (scmd->cmd_len == 32)
 		mpi_control |= 4 << MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT;
 	mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
@@ -4196,14 +4202,20 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		desc_ioc_state = "scsi ext terminated";
 		break;
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		desc_ioc_state = "eedp guard error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp guard error";
+			break;
+		}
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		desc_ioc_state = "eedp ref tag error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp ref tag error";
+			break;
+		}
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		desc_ioc_state = "eedp app tag error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp app tag error";
+			break;
+		}
 	default:
 		desc_ioc_state = "unknown";
 		break;
@@ -4625,8 +4637,10 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		_scsih_eedp_error_handling(scmd, ioc_status);
-		break;
+		if (!ioc->disable_eedp_support) {
+			_scsih_eedp_error_handling(scmd, ioc_status);
+			break;
+		}
 	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI2_IOCSTATUS_INVALID_FUNCTION:
 	case MPI2_IOCSTATUS_INVALID_SGL:
@@ -8213,15 +8227,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_add_shost_fail;
 	}
 
-	/* register EEDP capabilities with SCSI layer */
-	if (prot_mask)
-		scsi_host_set_prot(shost, prot_mask);
-	else
-		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	ioc->disable_eedp_support = disable_eedp;
+	if (!ioc->disable_eedp_support) {
+		/* register EEDP capabilities with SCSI layer */
+		if (prot_mask)
+			scsi_host_set_prot(shost, prot_mask);
+		else
+			scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 				   | SHOST_DIF_TYPE2_PROTECTION
 				   | SHOST_DIF_TYPE3_PROTECTION);
 
-	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+	}
 
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
-- 
1.7.1

