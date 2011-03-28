From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/4] bnx2fc: scsi_dma_unmap() not invoked on IO
 completions
Date: Mon, 28 Mar 2011 16:12:55 -0700
Message-ID: <1301353975.6312.51.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3614 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1C1XNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2011 19:13:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, mchan@broadcom.com

Do not set io_req->sc_cmd to NULL until bnx2fc_unmap_sg_list() is called to
enable it to unmap the DMA mappings.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index d3fc302..96013a9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1728,7 +1728,6 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
 		return;
 	}
-	io_req->sc_cmd = NULL;
 
 	if (io_req->on_active_queue) {
 		list_del_init(&io_req->link);
@@ -1748,6 +1747,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	}
 
 	bnx2fc_unmap_sg_list(io_req);
+	io_req->sc_cmd = NULL;
 
 	switch (io_req->fcp_status) {
 	case FC_GOOD:
-- 
1.7.0.6




