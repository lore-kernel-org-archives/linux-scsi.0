From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 08/11] bnx2fc: hold tgt lock when calling
 cmd_release
Date: Tue, 26 Jul 2011 14:51:46 -0700
Message-ID: <1311717109-14077-9-git-send-email-bprakash@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2768 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab1GZVwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:07 -0400
In-Reply-To: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 797b005..7154c44 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -752,7 +752,9 @@ retry_tmf:
 	rc = bnx2fc_init_mp_req(io_req);
 	if (rc == FAILED) {
 		printk(KERN_ERR PFX "Task mgmt MP request init failed\n");
+		spin_lock_bh(&tgt->tgt_lock);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
 		goto tmf_err;
 	}
 
-- 
1.7.0.6


