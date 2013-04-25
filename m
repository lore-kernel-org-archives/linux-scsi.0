From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH/for-next 1/3] iscsi-target: Fix solicited NopIN handling with RDMAExtentions=No
Date: Thu, 25 Apr 2013 07:40:29 +0000
Message-ID: <1366875631-18795-2-git-send-email-nab@linux-iscsi.org>
References: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patches fixes a regression with solicited NopIN handling
in traditional iSCSI code introduced during TX immediate queue
refactoring for v3.10 for-next code.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0148cc3..5eee9b7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3762,12 +3762,6 @@ check_rsp_state:
 		break;
 	case ISTATE_SEND_NOPIN:
 		ret = iscsit_send_nopin(cmd, conn);
-		if (!ret) {
-			spin_lock_bh(&cmd->istate_lock);
-			cmd->i_state = ISTATE_SENT_STATUS;
-			spin_unlock_bh(&cmd->istate_lock);
-			return 0;
-		}
 		break;
 	case ISTATE_SEND_REJECT:
 		ret = iscsit_send_reject(cmd, conn);
-- 
1.7.2.5
