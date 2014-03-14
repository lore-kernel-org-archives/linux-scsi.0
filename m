From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 1/9][SCSI]mpt3sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Date: Fri, 14 Mar 2014 21:39:58 +0530
Message-ID: <20140314160958.GA8350@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:31405
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755798AbaCNQO1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 12:14:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com

A new mpt3sas driver module parameter 'disable_eedp' is added to Disable
EEDP support. By default DIF support is enabled in the driver and
this module parameter would allow users to turn it off.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   38 ++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   45 ++++++++++++++++++++++-----------
 3 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..d46956e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -429,13 +429,16 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
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
@@ -2429,21 +2432,22 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->ir_firmware)
 		mpt3sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
 		    &ioc->manu_pg10);
-
-	/*
-	 * Ensure correct T10 PI operation if vendor left EEDPTagMode
-	 * flag unset in NVDATA.
-	 */
-	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
-	if (ioc->manu_pg11.EEDPTagMode == 0) {
-		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
-		    ioc->name);
-		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-		ioc->manu_pg11.EEDPTagMode |= 0x1;
-		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
-		    &ioc->manu_pg11);
+	if (!ioc->disable_eedp_support) {
+		/*
+		 * Ensure correct T10 PI operation if vendor left EEDPTagMode
+		 * flag unset in NVDATA.
+		 */
+		mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply,
+							&ioc->manu_pg11);
+		if (ioc->manu_pg11.EEDPTagMode == 0) {
+			pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
+			ioc->name);
+			ioc->manu_pg11.EEDPTagMode &= ~0x3;
+			ioc->manu_pg11.EEDPTagMode |= 0x1;
+			mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
+			    &ioc->manu_pg11);
+		}
 	}
-
 	mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
 	mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0ebf5d9..b1494ce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -791,6 +791,7 @@ struct MPT3SAS_ADAPTER {
 	u32		event_context;
 	void		*event_log;
 	u32		event_masks[MPI2_EVENT_NOTIFY_EVENTMASK_WORDS];
+	u8              disable_eedp_support;
 
 	/* static config pages */
 	struct mpt3sas_facts facts;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..1056cbf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -116,7 +116,10 @@ static int max_lun = MPT3SAS_MAX_LUN;
 module_param(max_lun, int, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
-
+/* Enable or disable EEDP support */
+static int disable_eedp;
+module_param(disable_eedp, uint, 0);
+MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");
 
 
 /* diag_buffer_enable is bitwise
@@ -3614,7 +3617,8 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
-	_scsih_setup_eedp(ioc, scmd, mpi_request);
+	if (!ioc->disable_eedp_support)
+		_scsih_setup_eedp(ioc, scmd, mpi_request);
 
 	if (scmd->cmd_len == 32)
 		mpi_control |= 4 << MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT;
@@ -3769,14 +3773,21 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
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
+
 	default:
 		desc_ioc_state = "unknown";
 		break;
@@ -4191,8 +4202,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+	if (!ioc->disable_eedp_support) {
 		_scsih_eedp_error_handling(scmd, ioc_status);
 		break;
+	}
 
 	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI2_IOCSTATUS_INVALID_FUNCTION:
@@ -7814,16 +7827,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_add_shost_fail;
 	}
 
-	/* register EEDP capabilities with SCSI layer */
-	if (prot_mask > 0)
-		scsi_host_set_prot(shost, prot_mask);
-	else
-		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	ioc->disable_eedp_support = disable_eedp;
+	if (!ioc->disable_eedp_support) {
+		/* register EEDP capabilities with SCSI layer */
+		if (prot_mask > 0)
+			scsi_host_set_prot(shost, prot_mask);
+		else
+			scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 				   | SHOST_DIF_TYPE2_PROTECTION
 				   | SHOST_DIF_TYPE3_PROTECTION);
 
-	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
-
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+	}
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event%d", ioc->id);
-- 
1.7.1

