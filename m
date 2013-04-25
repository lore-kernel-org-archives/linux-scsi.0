From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH/for-next 3/3] iser-target: Add special case for early ISCSI_OP_SCSI_CMD exception handling
Date: Thu, 25 Apr 2013 07:40:31 +0000
Message-ID: <1366875631-18795-4-git-send-email-nab@linux-iscsi.org>
References: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

During early ISCSI_OP_SCSI_CMD exception handling with non GOOD status, the
TX thread context in isert_response_queue() needs to post IB_WR_SEND via
isert_put_response() when processing ISTATE_SEND_STATUS.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1a150ef..41712f0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1947,6 +1947,13 @@ isert_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
 	case ISTATE_SEND_REJECT:
 		ret = isert_put_reject(cmd, conn);
 		break;
+	case ISTATE_SEND_STATUS:
+		/*
+		 * Special case for sending non GOOD SCSI status from TX thread
+		 * context during pre se_cmd excecution failure.
+		 */
+		ret = isert_put_response(conn, cmd);
+		break;
 	default:
 		pr_err("Unknown response state: 0x%02x\n", state);
 		ret = -EINVAL;
-- 
1.7.2.5
