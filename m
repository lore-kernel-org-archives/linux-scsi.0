From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 1/3] bnx2i remove not so useful global variable
 bnx2i_reg_devices
Date: Tue, 23 Jun 2009 18:11:00 -0700
Message-ID: <1245805860.9829.50.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4349 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZFXBLH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 21:11:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com

>From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17 00:00:00 2001
From: Anil Veerabhadrappa <anilgv@broadcom.com>
Date: Tue, 23 Jun 2009 13:56:29 -0700
Subject: [PATCH]     bnx2i - remove global variable bnx2i_reg_devices

    * Removed bnx2i_reg_devices as this counter is not really
      used in a meaningful way

    Cc: Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index ae4b2d5..269192d 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -15,7 +15,6 @@
 
 static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
-static int bnx2i_reg_device;
 
 #define DRV_MODULE_NAME		"bnx2i"
 #define DRV_MODULE_VERSION	"2.0.1d"
@@ -193,10 +192,6 @@ void bnx2i_register_device(struct bnx2i_hba *hba)
 
 	hba->cnic->register_device(hba->cnic, CNIC_ULP_ISCSI, hba);
 
-	spin_lock(&hba->lock);
-	bnx2i_reg_device++;
-	spin_unlock(&hba->lock);
-
 	set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 }
 
@@ -234,10 +229,6 @@ static void bnx2i_unreg_one_device(struct bnx2i_hba *hba)
 
 	hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
 
-	spin_lock(&hba->lock);
-	bnx2i_reg_device--;
-	spin_unlock(&hba->lock);
-
 	/* ep_disconnect could come before NETDEV_DOWN, driver won't
 	 * see NETDEV_DOWN as it already unregistered itself.
 	 */
@@ -276,16 +267,12 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 	int rc;
 
 	read_lock(&bnx2i_dev_lock);
-	if (bnx2i_reg_device &&
-	    !test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
+	if (!test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
 		rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
 		if (rc)		/* duplicate registration */
 			printk(KERN_ERR "bnx2i- dev reg failed\n");
 
-		spin_lock(&hba->lock);
-		bnx2i_reg_device++;
 		hba->age++;
-		spin_unlock(&hba->lock);
 
 		set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
 	}
@@ -350,10 +337,6 @@ void bnx2i_ulp_exit(struct cnic_dev *dev)
 	if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
 		hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
 		clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-
-		spin_lock(&hba->lock);
-		bnx2i_reg_device--;
-		spin_unlock(&hba->lock);
 	}
 	write_unlock(&bnx2i_dev_lock);
 
@@ -421,7 +404,6 @@ static void __exit bnx2i_mod_exit(void)
 		if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
 			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
 			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-			bnx2i_reg_device--;
 		}
 
 		write_unlock(&bnx2i_dev_lock);
-- 
1.5.4.3




