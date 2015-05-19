From: <nilesh.javali@qlogic.com>
Subject: [PATCH 2/2] bnx2i: Fix call trace while device reset
Date: Tue, 19 May 2015 05:51:58 -0400
Message-ID: <1432029118-25867-2-git-send-email-nilesh.javali@qlogic.com>
References: <1432029118-25867-1-git-send-email-nilesh.javali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37899 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267AbbESKg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 06:36:26 -0400
In-Reply-To: <1432029118-25867-1-git-send-email-nilesh.javali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: nilesh.javali@qlogic.com, giridhar.malavali@qlogic.com, QLogic-Storage-Upstream@qlogic.com

From: Nilesh Javali <nilesh.javali@qlogic.com>

The driver waits for command completion event while cleanup of task
within the frwd lock and back locks. The frwd lock was still held
which caused the call trace while issuing a device reset.
Release the frwd lock along with the back lock
to avoid waiting in the lock context.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b8a971..7289437 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1173,8 +1173,10 @@ static void bnx2i_cleanup_task(struct iscsi_task *task)
 		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);
 
 		spin_unlock_bh(&conn->session->back_lock);
+		spin_unlock_bh(&conn->session->frwd_lock);
 		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
 				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
+		spin_lock_bh(&conn->session->frwd_lock);
 		spin_lock_bh(&conn->session->back_lock);
 	}
 	bnx2i_iscsi_unmap_sg_list(task->dd_data);
-- 
1.8.2.GIT

