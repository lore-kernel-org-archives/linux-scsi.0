From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 12/20] mpt2sas: Added new info messages for IR and Expander events.
Date: Wed, 23 Sep 2009 17:31:01 +0530
Message-ID: <20090923120101.GQ6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:44380 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbZIWMYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:24:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) for the MPI2_EVENT_IR_OPERATION_STATUS event, add support to print
"background init" or "make data consistent" for debugging purposes.  If the
RAIDOperation is set to a value not defined, then don't print anything

(2) for the MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE event, add support to print
"expander reduced functionality" and "expander reduced functionality
complete", which are new events.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d241769..7ac8ac6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4279,6 +4279,12 @@ _scsih_sas_device_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 	case MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION:
 		reason_str = "internal async notification";
 		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_EXPANDER_REDUCED_FUNCTIONALITY:
+		reason_str = "expander reduced functionality";
+		break;
+	case MPI2_EVENT_SAS_DEV_STAT_RC_CMP_EXPANDER_REDUCED_FUNCTIONALITY:
+		reason_str = "expander reduced functionality complete";
+		break;
 	default:
 		reason_str = "unknown reason";
 		break;
@@ -5062,11 +5068,17 @@ _scsih_sas_ir_operation_status_event_debug(struct MPT2SAS_ADAPTER *ioc,
 	case MPI2_EVENT_IR_RAIDOP_CONSISTENCY_CHECK:
 		reason_str = "consistency check";
 		break;
-	default:
-		reason_str = "unknown reason";
+	case MPI2_EVENT_IR_RAIDOP_BACKGROUND_INIT:
+		reason_str = "background init";
+		break;
+	case MPI2_EVENT_IR_RAIDOP_MAKE_DATA_CONSISTENT:
+		reason_str = "make data consistent";
 		break;
 	}
 
+	if (!reason_str)
+		return;
+
 	printk(MPT2SAS_INFO_FMT "raid operational status: (%s)"
 	    "\thandle(0x%04x), percent complete(%d)\n",
 	    ioc->name, reason_str,
