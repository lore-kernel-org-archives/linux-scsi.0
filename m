From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [RESUBMIT PATCH 2/4] bnx2fc: scsi_dma_unmap() not invoked on IO
 completions
Date: Fri, 27 May 2011 11:47:26 -0700
Message-ID: <1306522048-23893-3-git-send-email-bprakash@broadcom.com>
References: <1306522048-23893-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1669 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1E0Srk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 14:47:40 -0400
In-Reply-To: <1306522048-23893-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Do not set io_req->sc_cmd to NULL until bnx2fc_unmap_sg_list() is called to
enable it to unmap the DMA mappings.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index b5b5c34..454c72c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1734,7 +1734,6 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
 		return;
 	}
-	io_req->sc_cmd = NULL;
 
 	if (io_req->on_active_queue) {
 		list_del_init(&io_req->link);
@@ -1754,6 +1753,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	}
 
 	bnx2fc_unmap_sg_list(io_req);
+	io_req->sc_cmd = NULL;
 
 	switch (io_req->fcp_status) {
 	case FC_GOOD:
-- 
1.7.0.6


