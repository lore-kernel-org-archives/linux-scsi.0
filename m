From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 3/3]  bnx2i convert bnx2i_dev_lock to mutex type
Date: Tue, 23 Jun 2009 18:11:19 -0700
Message-ID: <1245805879.9829.53.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1999 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZFXBLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 21:11:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com

>From 22c9b5e01185f4c9eae11ca9a80cf774aa1897ea Mon Sep 17 00:00:00 2001
From: Anil Veerabhadrappa <anilgv@broadcom.com>
Date: Tue, 23 Jun 2009 14:07:40 -0700
Subject: [PATCH]     bnx2i - convert bnx2i_dev_lock to mutex

    * convert bnx2i_dev_lock to type mutex from rwlock_t because
          cnic->register_device() can sleep for various reasons including
          memory allocation, waiting for ISCSI_INIT completion and while
          acquiring mutex lock, cnic_lock

    Cc: Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   54 ++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 2aeeeee..fd78540 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -17,8 +17,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.0.1d"
-#define DRV_MODULE_RELDATE	"Mar 25, 2009"
+#define DRV_MODULE_VERSION	"2.0.1e"
+#define DRV_MODULE_RELDATE	"June 22, 2009"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
@@ -30,7 +30,7 @@ MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709 iSCSI Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-static DEFINE_RWLOCK(bnx2i_dev_lock);
+static DEFINE_MUTEX(bnx2i_dev_lock);
 
 unsigned int event_coal_div = 1;
 module_param(event_coal_div, int, 0664);
@@ -99,14 +99,14 @@ struct bnx2i_hba *get_adapter_list_head(void)
 	if (!adapter_count)
 		goto hba_not_found;
 
-	read_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	list_for_each_entry(tmp_hba, &adapter_list, link) {
 		if (tmp_hba->cnic && tmp_hba->cnic->cm_select_dev) {
 			hba = tmp_hba;
 			break;
 		}
 	}
-	read_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 hba_not_found:
 	return hba;
 }
@@ -121,14 +121,14 @@ struct bnx2i_hba *bnx2i_find_hba_for_cnic(struct cnic_dev *cnic)
 {
 	struct bnx2i_hba *hba, *temp;
 
-	read_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	list_for_each_entry_safe(hba, temp, &adapter_list, link) {
 		if (hba->cnic == cnic) {
-			read_unlock(&bnx2i_dev_lock);
+			mutex_unlock(&bnx2i_dev_lock);
 			return hba;
 		}
 	}
-	read_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 	return NULL;
 }
 
@@ -206,10 +206,10 @@ void bnx2i_reg_dev_all(void)
 {
 	struct bnx2i_hba *hba, *temp;
 
-	read_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	list_for_each_entry_safe(hba, temp, &adapter_list, link)
 		bnx2i_register_device(hba);
-	read_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 }
 
 
@@ -246,10 +246,10 @@ void bnx2i_unreg_dev_all(void)
 {
 	struct bnx2i_hba *hba, *temp;
 
-	read_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	list_for_each_entry_safe(hba, temp, &adapter_list, link)
 		bnx2i_unreg_one_device(hba);
-	read_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 }
 
 
@@ -258,19 +258,21 @@ void bnx2i_unreg_dev_all(void)
  * @hba:	bnx2i adapter instance
  * @cnic:	cnic device handle
  *
- * Global resource lock and host adapter lock is held during critical sections
- *	below. This routine is called from cnic_register_driver() context and
- *	work horse thread which does majority of device specific initialization
+ * Global resource lock is held during critical sections below. This routine is
+ *	called from either cnic_register_driver() or device hot plug context and
+ *	and does majority of device specific initialization
  */
 static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 {
 	int rc;
 
-	read_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
 	if (!rc) {
 		hba->age++;
 		set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
+		list_add_tail(&hba->link, &adapter_list);
+		adapter_count++;
 	} else if (rc == -EBUSY) 	/* duplicate registration */
 		printk(KERN_ALERT "bnx2i, duplicate registration"
 				  "hba=%p, cnic=%p\n", hba, cnic);
@@ -280,14 +282,8 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 		printk(KERN_ERR "bnx2i, invalid type %d\n", CNIC_ULP_ISCSI);
 	else
 		printk(KERN_ERR "bnx2i dev reg, unknown error, %d\n", rc);
-	read_unlock(&bnx2i_dev_lock);
 
-	if (!rc) {
-		write_lock(&bnx2i_dev_lock);
-		list_add_tail(&hba->link, &adapter_list);
-		adapter_count++;
-		write_unlock(&bnx2i_dev_lock);
-	}
+	mutex_unlock(&bnx2i_dev_lock);
 
 	return rc;
 }
@@ -337,7 +333,7 @@ void bnx2i_ulp_exit(struct cnic_dev *dev)
 				 "found, dev 0x%p\n", dev);
 		return;
 	}
-	write_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	list_del_init(&hba->link);
 	adapter_count--;
 
@@ -345,7 +341,7 @@ void bnx2i_ulp_exit(struct cnic_dev *dev)
 		hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
 		clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 	}
-	write_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 
 	bnx2i_free_hba(hba);
 }
@@ -367,6 +363,8 @@ static int __init bnx2i_mod_init(void)
 	if (!is_power_of_2(sq_size))
 		sq_size = roundup_pow_of_two(sq_size);
 
+	mutex_init(&bnx2i_dev_lock);
+
 	bnx2i_scsi_xport_template =
 			iscsi_register_transport(&bnx2i_iscsi_transport);
 	if (!bnx2i_scsi_xport_template) {
@@ -402,7 +400,7 @@ static void __exit bnx2i_mod_exit(void)
 {
 	struct bnx2i_hba *hba;
 
-	write_lock(&bnx2i_dev_lock);
+	mutex_lock(&bnx2i_dev_lock);
 	while (!list_empty(&adapter_list)) {
 		hba = list_entry(adapter_list.next, struct bnx2i_hba, link);
 		list_del(&hba->link);
@@ -413,11 +411,9 @@ static void __exit bnx2i_mod_exit(void)
 			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 		}
 
-		write_unlock(&bnx2i_dev_lock);
 		bnx2i_free_hba(hba);
-		write_lock(&bnx2i_dev_lock);
 	}
-	write_unlock(&bnx2i_dev_lock);
+	mutex_unlock(&bnx2i_dev_lock);
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
-- 
1.5.4.3




