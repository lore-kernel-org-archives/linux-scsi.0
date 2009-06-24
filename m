From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 2/3] bnx2i bug fix to handle error conditions in
 bnx2i_init_one
Date: Tue, 23 Jun 2009 18:11:10 -0700
Message-ID: <1245805870.9829.51.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4349 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZFXBLQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 21:11:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com

>From 7d401ec6aa1330c314ab3d4bf4dad1e646b3f8dc Mon Sep 17 00:00:00 2001
From: Anil Veerabhadrappa <anilgv@broadcom.com>
Date: Tue, 23 Jun 2009 14:04:23 -0700
Subject: [PATCH]     bnx2i - bug fixes in bnx2i_init_one to handle error conditions

    * Fixed bnx2i_init_one() to properly handle return code of
        cnic->register_device() and propagate it back to the caller
    * No need to check for BNX2I_CNIC_REGISTERED, because unless
      the adapter is added to adapter_list it will not be registered
      in ep_connect context

    Cc: Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 269192d..2aeeeee 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -267,22 +267,29 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 	int rc;
 
 	read_lock(&bnx2i_dev_lock);
-	if (!test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
-		rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
-		if (rc)		/* duplicate registration */
-			printk(KERN_ERR "bnx2i- dev reg failed\n");
-
+	rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
+	if (!rc) {
 		hba->age++;
-
 		set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-	}
+	} else if (rc == -EBUSY) 	/* duplicate registration */
+		printk(KERN_ALERT "bnx2i, duplicate registration"
+				  "hba=%p, cnic=%p\n", hba, cnic);
+	else if (rc == -EAGAIN)
+		printk(KERN_ERR "bnx2i, driver not registered\n");
+	else if (rc == -EINVAL)
+		printk(KERN_ERR "bnx2i, invalid type %d\n", CNIC_ULP_ISCSI);
+	else
+		printk(KERN_ERR "bnx2i dev reg, unknown error, %d\n", rc);
 	read_unlock(&bnx2i_dev_lock);
 
-	write_lock(&bnx2i_dev_lock);
-	list_add_tail(&hba->link, &adapter_list);
-	adapter_count++;
-	write_unlock(&bnx2i_dev_lock);
-	return 0;
+	if (!rc) {
+		write_lock(&bnx2i_dev_lock);
+		list_add_tail(&hba->link, &adapter_list);
+		adapter_count++;
+		write_unlock(&bnx2i_dev_lock);
+	}
+
+	return rc;
 }
 
 
-- 
1.5.4.3




