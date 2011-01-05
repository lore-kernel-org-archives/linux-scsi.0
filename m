From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 3/8] BNX2I: Added handling for unsupported iSCSI offload
 hba
Date: Wed, 5 Jan 2011 12:44:22 -0800
Message-ID: <1294260267-17413-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2885 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1AEUl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:58 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The hba will now be unregistered and freed when iSCSI offload
is not supported by the NIC.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 72a7b2d..6afaa34 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -161,6 +161,21 @@ void bnx2i_start(void *handle)
 	struct bnx2i_hba *hba = handle;
 	int i = HZ;
 
+	if (!hba->cnic->max_iscsi_conn) {
+		printk(KERN_ALERT "bnx2i: dev %s does not support "
+			"iSCSI\n", hba->netdev->name);
+
+		if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
+			mutex_lock(&bnx2i_dev_lock);
+			list_del_init(&hba->link);
+			adapter_count--;
+			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
+			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
+			mutex_unlock(&bnx2i_dev_lock);
+			bnx2i_free_hba(hba);
+		}
+		return;
+	}
 	bnx2i_send_fw_iscsi_init_msg(hba);
 	while (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state) && i--)
 		msleep(BNX2I_INIT_POLL_TIME);
-- 
1.7.0.5


