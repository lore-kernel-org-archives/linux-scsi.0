From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] mpt2sas: make global symbols unique
Date: Sun, 15 Mar 2009 21:37:18 -0600
Message-ID: <20090316033715.GA5065@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:45315 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbZCPRQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 13:16:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

The ioc_list global symbol is already used in 1st generation mpt fusion drivers, so this patch makes it unique in the 2nd generation driver.  I've checked the entire sources, and I don't see any other global system missing the mpt2sas_xxx prefix.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 11fc17f..6945ff4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -68,11 +68,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"00.100.11.15"
+#define MPT2SAS_DRIVER_VERSION		"00.100.11.16"
 #define MPT2SAS_MAJOR_VERSION		00
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		11
-#define MPT2SAS_RELEASE_VERSION		15
+#define MPT2SAS_RELEASE_VERSION		16
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
@@ -647,7 +647,7 @@ typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
 
 
 /* base shared API */
-extern struct list_head ioc_list;
+extern struct list_head mpt2sas_ioc_list;
 
 int mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc);
 void mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 4fbe3f8..2d4f85c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -355,7 +355,7 @@ _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp)
 {
 	struct MPT2SAS_ADAPTER *ioc;
 
-	list_for_each_entry(ioc, &ioc_list, list) {
+	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
 		if (ioc->id != ioc_number)
 			continue;
 		*iocpp = ioc;
@@ -439,7 +439,7 @@ _ctl_poll(struct file *filep, poll_table *wait)
 
 	poll_wait(filep, &ctl_poll_wait, wait);
 
-	list_for_each_entry(ioc, &ioc_list, list) {
+	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
 		if (ioc->aen_event_read_flag)
 			return POLLIN | POLLRDNORM;
 	}
@@ -2497,7 +2497,7 @@ mpt2sas_ctl_exit(void)
 	struct MPT2SAS_ADAPTER *ioc;
 	int i;
 
-	list_for_each_entry(ioc, &ioc_list, list) {
+	list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
 
 		/* free memory associated to diag buffers */
 		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 50865a8..0c463c4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -68,10 +68,9 @@ static void _scsih_expander_node_remove(struct MPT2SAS_ADAPTER *ioc,
 static void _firmware_event_work(struct work_struct *work);
 
 /* global parameters */
-LIST_HEAD(ioc_list);
+LIST_HEAD(mpt2sas_ioc_list);
 
 /* local parameters */
-static u32 logging_level;
 static u8 scsi_io_cb_idx = -1;
 static u8 tm_cb_idx = -1;
 static u8 ctl_cb_idx = -1;
@@ -81,6 +80,7 @@ static u8 config_cb_idx = -1;
 static int mpt_ids;
 
 /* command line options */
+static u32 logging_level;
 MODULE_PARM_DESC(logging_level, " bits for enabling additional logging info "
     "(default=0)");
 
@@ -211,7 +211,7 @@ scsih_set_debug_level(const char *val, struct kernel_param *kp)
 		return ret;
 
 	printk(KERN_INFO "setting logging_level(0x%08x)\n", logging_level);
-	list_for_each_entry(ioc, &ioc_list, list)
+	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
 		ioc->logging_level = logging_level;
 	return 0;
 }
@@ -5464,7 +5464,7 @@ scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc = shost_priv(shost);
 	memset(ioc, 0, sizeof(struct MPT2SAS_ADAPTER));
 	INIT_LIST_HEAD(&ioc->list);
-	list_add_tail(&ioc->list, &ioc_list);
+	list_add_tail(&ioc->list, &mpt2sas_ioc_list);
 	ioc->shost = shost;
 	ioc->id = mpt_ids++;
 	sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
