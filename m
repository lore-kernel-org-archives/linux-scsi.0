From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 04/18] bnx2fc: Remove erroneous kref_get on IO
 request
Date: Thu, 4 Aug 2011 17:38:38 -0700
Message-ID: <1312504732-4572-5-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4920 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1HEAjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:08 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

During sequence cleanup, an additional reference for an IO has been
taken. Because of this, the IO is never released into the free list.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 6cc3789..cb1791c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1251,7 +1251,6 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnp_req,
 			seq_clnp_req->xid);
 		goto free_cb_arg;
 	}
-	kref_get(&orig_io_req->refcount);
 
 	spin_unlock_bh(&tgt->tgt_lock);
 	rc = bnx2fc_send_srr(orig_io_req, offset, r_ctl);
-- 
1.7.0.6


