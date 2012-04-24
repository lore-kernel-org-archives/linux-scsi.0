From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [v2 PATCH 3/4] bnx2fc: cleanup task management IO when it times
 out.
Date: Tue, 24 Apr 2012 15:26:03 -0700
Message-ID: <1335306364-31449-4-git-send-email-bprakash@broadcom.com>
References: <1335306364-31449-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2105 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338Ab2DXW0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 18:26:16 -0400
In-Reply-To: <1335306364-31449-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When the task management IO times out, or a flush operation is performed while
task management IO is pending, driver is not cleaning up the IO. This patch
cleans up the IO for the above cases.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c  |   16 +++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |   10 ++++++++++
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4843b42..27074ee 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -810,8 +810,22 @@ retry_tmf:
 	spin_lock_bh(&tgt->tgt_lock);
 
 	io_req->wait_for_comp = 0;
-	if (!(test_bit(BNX2FC_FLAG_TM_COMPL, &io_req->req_flags)))
+	if (!(test_bit(BNX2FC_FLAG_TM_COMPL, &io_req->req_flags))) {
 		set_bit(BNX2FC_FLAG_TM_TIMEOUT, &io_req->req_flags);
+		if (io_req->on_tmf_queue) {
+			list_del_init(&io_req->link);
+			io_req->on_tmf_queue = 0;
+		}
+		io_req->wait_for_comp = 1;
+		bnx2fc_initiate_cleanup(io_req);
+		spin_unlock_bh(&tgt->tgt_lock);
+		rc = wait_for_completion_timeout(&io_req->tm_done,
+						 BNX2FC_FW_TIMEOUT);
+		spin_lock_bh(&tgt->tgt_lock);
+		io_req->wait_for_comp = 0;
+		if (!rc)
+			kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	}
 
 	spin_unlock_bh(&tgt->tgt_lock);
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index d3ee231..082a25c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -185,6 +185,16 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
 		BUG_ON(rc);
 	}
 
+	list_for_each_safe(list, tmp, &tgt->active_tm_queue) {
+		i++;
+		io_req = (struct bnx2fc_cmd *)list;
+		list_del_init(&io_req->link);
+		io_req->on_tmf_queue = 0;
+		BNX2FC_IO_DBG(io_req, "tm_queue cleanup\n");
+		if (io_req->wait_for_comp)
+			complete(&io_req->tm_done);
+	}
+
 	list_for_each_safe(list, tmp, &tgt->els_queue) {
 		i++;
 		io_req = (struct bnx2fc_cmd *)list;
-- 
1.7.0.6


