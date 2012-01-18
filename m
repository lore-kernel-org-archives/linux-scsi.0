From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/07] lpfc 8.3.29: BSG and User interface fixes
Date: Wed, 18 Jan 2012 16:23:48 -0500
Message-ID: <1326921829.32733.10.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:32996 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993Ab2ARVYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 16:24:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

BSG and User interface fixes:

- Fix driver processing an els command using 16Gb FC Adapter (126345)
- Change SLI4 FC port internal loopback to inner internal (126409)
- Fix bug with driver dump command type 4 using 16Gb FC Adapter (126406)
- Create character device to take a reference on the driver (126082)


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c  |   14 +++++++++++---
 lpfc_hw.h   |    4 +++-
 lpfc_init.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_sli.c  |    2 +-
 4 files changed, 63 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2012-01-18 11:32:20.000000000 -0500
@@ -589,7 +589,10 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	}
 	cmdiocbq->iocb.un.elsreq64.bdl.bdeSize =
 		(request_nseg + reply_nseg) * sizeof(struct ulp_bde64);
-	cmdiocbq->iocb.ulpContext = rpi;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		cmdiocbq->iocb.ulpContext = phba->sli4_hba.rpi_ids[rpi];
+	else
+		cmdiocbq->iocb.ulpContext = rpi;
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->context1 = NULL;
 	cmdiocbq->context2 = NULL;
@@ -1768,7 +1771,7 @@ lpfc_sli4_bsg_set_internal_loopback(stru
 	bf_set(lpfc_mbx_set_diag_state_link_type,
 	       &link_diag_loopback->u.req, phba->sli4_hba.lnk_info.lnk_tp);
 	bf_set(lpfc_mbx_set_diag_lpbk_type, &link_diag_loopback->u.req,
-	       LPFC_DIAG_LOOPBACK_TYPE_SERDES);
+	       LPFC_DIAG_LOOPBACK_TYPE_INTERNAL);
 
 	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, LPFC_MBOX_TMO);
 	if ((mbxstatus != MBX_SUCCESS) || (pmboxq->u.mb.mbxStatus)) {
@@ -4556,7 +4559,12 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 							+ sizeof(MAILBOX_t));
 		}
 	} else if (phba->sli_rev == LPFC_SLI_REV4) {
-		if (pmb->mbxCommand == MBX_DUMP_MEMORY) {
+		/* Let type 4 (well known data) through because the data is
+		 * returned in varwords[4-8]
+		 * otherwise check the recieve length and fetch the buffer addr
+		 */
+		if ((pmb->mbxCommand == MBX_DUMP_MEMORY) &&
+			(pmb->un.varDmp.type != DMP_WELL_KNOWN)) {
 			/* rebuild the command for sli4 using our own buffers
 			* like we do for biu diags
 			*/
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2012-01-18 11:32:20.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -2567,6 +2567,8 @@ typedef struct {
 
 #define  DMP_MEM_REG             0x1
 #define  DMP_NV_PARAMS           0x2
+#define  DMP_LMSD                0x3 /* Link Module Serial Data */
+#define  DMP_WELL_KNOWN          0x4
 
 #define  DMP_REGION_VPD          0xe
 #define  DMP_VPD_SIZE            0x400  /* maximum amount of VPD */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-01-18 11:32:20.000000000 -0500
@@ -32,6 +32,7 @@
 #include <linux/aer.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
+#include <linux/miscdevice.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -10012,6 +10013,36 @@ lpfc_io_resume(struct pci_dev *pdev)
 	return;
 }
 
+/**
+ * lpfc_mgmt_open - method called when 'lpfcmgmt' is opened from userspace
+ * @inode: pointer to the inode representing the lpfcmgmt device
+ * @filep: pointer to the file representing the open lpfcmgmt device
+ *
+ * This routine puts a reference count on the lpfc module whenever the
+ * character device is opened
+ **/
+static int
+lpfc_mgmt_open(struct inode *inode, struct file *filep)
+{
+	try_module_get(THIS_MODULE);
+	return 0;
+}
+
+/**
+ * lpfc_mgmt_release - method called when 'lpfcmgmt' is closed in userspace
+ * @inode: pointer to the inode representing the lpfcmgmt device
+ * @filep: pointer to the file representing the open lpfcmgmt device
+ *
+ * This routine removes a reference count from the lpfc module when the
+ * character device is closed
+ **/
+static int
+lpfc_mgmt_release(struct inode *inode, struct file *filep)
+{
+	module_put(THIS_MODULE);
+	return 0;
+}
+
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
@@ -10124,6 +10155,17 @@ static struct pci_driver lpfc_driver = {
 	.err_handler    = &lpfc_err_handler,
 };
 
+static const struct file_operations lpfc_mgmt_fop = {
+	.open = lpfc_mgmt_open,
+	.release = lpfc_mgmt_release,
+};
+
+static struct miscdevice lpfc_mgmt_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "lpfcmgmt",
+	.fops = &lpfc_mgmt_fop,
+};
+
 /**
  * lpfc_init - lpfc module initialization routine
  *
@@ -10144,6 +10186,11 @@ lpfc_init(void)
 	printk(LPFC_MODULE_DESC "\n");
 	printk(LPFC_COPYRIGHT "\n");
 
+	error = misc_register(&lpfc_mgmt_dev);
+	if (error)
+		printk(KERN_ERR "Could not register lpfcmgmt device, "
+			"misc_register returned with status %d", error);
+
 	if (lpfc_enable_npiv) {
 		lpfc_transport_functions.vport_create = lpfc_vport_create;
 		lpfc_transport_functions.vport_delete = lpfc_vport_delete;
@@ -10180,6 +10227,7 @@ lpfc_init(void)
 static void __exit
 lpfc_exit(void)
 {
+	misc_deregister(&lpfc_mgmt_dev);
 	pci_unregister_driver(&lpfc_driver);
 	fc_release_transport(lpfc_transport_template);
 	if (lpfc_enable_npiv)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-01-18 11:32:20.000000000 -0500
@@ -7763,7 +7763,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 					phba->vpi_ids[phba->pport->vpi]);
-			} else if (iocbq->context1) {
+			} else if (pcmd && iocbq->context1) {
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
 					phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);



