From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 10/18] bnx2fc: Do not reuse the fcoe connection id
 immediately
Date: Thu, 4 Aug 2011 17:38:44 -0700
Message-ID: <1312504732-4572-11-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4917 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab1HEAjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:11 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

CFC_DELETE is issued 2 secs after CONN_TERM is completed. If the session is
uploaded and offloaded immediately, it has to wait for the connection id to be
available.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index d5311b5..3d28fbe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -624,7 +624,6 @@ static void bnx2fc_free_conn_id(struct bnx2fc_hba *hba, u32 conn_id)
 	/* called with hba mutex held */
 	spin_lock_bh(&hba->hba_lock);
 	hba->tgt_ofld_list[conn_id] = NULL;
-	hba->next_conn_id = conn_id;
 	spin_unlock_bh(&hba->hba_lock);
 }
 
-- 
1.7.0.6


