From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/4] BNX2I: Modified to skip CNIC registration if iSCSI
 is not supported
Date: Tue, 21 Jun 2011 09:49:52 -0700
Message-ID: <1308674994-4694-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3355 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1FUQuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2011 12:50:11 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The init routine will now examine the cnic->max_iscsi_conn variable
before registering to CNIC during ulp_init.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 0f7fb14..28bfa9e 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -172,21 +172,14 @@ void bnx2i_start(void *handle)
 	struct bnx2i_hba *hba = handle;
 	int i = HZ;
 
-	if (!hba->cnic->max_iscsi_conn) {
-		printk(KERN_ALERT "bnx2i: dev %s does not support "
-			"iSCSI\n", hba->netdev->name);
+	/*
+	 * We should never register devices that don't support iSCSI
+	 * (see bnx2i_init_one), so something is wrong if we try to
+	 * start a iSCSI adapter on hardware with 0 supported iSCSI
+	 * connections
+	 */
+	BUG_ON(!hba->cnic->max_iscsi_conn);
 
-		if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
-			mutex_lock(&bnx2i_dev_lock);
-			list_del_init(&hba->link);
-			adapter_count--;
-			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
-			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-			mutex_unlock(&bnx2i_dev_lock);
-			bnx2i_free_hba(hba);
-		}
-		return;
-	}
 	bnx2i_send_fw_iscsi_init_msg(hba);
 	while (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state) && i--)
 		msleep(BNX2I_INIT_POLL_TIME);
@@ -290,6 +283,13 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 	int rc;
 
 	mutex_lock(&bnx2i_dev_lock);
+	if (!cnic->max_iscsi_conn) {
+		printk(KERN_ALERT "bnx2i: dev %s does not support "
+			"iSCSI\n", hba->netdev->name);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
 	hba->cnic = cnic;
 	rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
 	if (!rc) {
@@ -307,6 +307,7 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 	else
 		printk(KERN_ERR "bnx2i dev reg, unknown error, %d\n", rc);
 
+out:
 	mutex_unlock(&bnx2i_dev_lock);
 
 	return rc;
-- 
1.7.0.5


