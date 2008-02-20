From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] scsi_lib: Convert GFP_ATOMIC to gfp_flags
Date: Wed, 20 Feb 2008 11:26:05 -0700
Message-ID: <20080220182604.GD27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53202 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYBTS0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 13:26:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


scsi_init_io() is already passed a gfp_mask, so we should use that
instead of an explicit GFP_ATOMIC

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f243fc3..b81170d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1048,8 +1048,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		goto err_exit;
 
 	if (blk_bidi_rq(cmd->request)) {
-		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+		struct scsi_data_buffer *bidi_sdb;
+		bidi_sdb = kmem_cache_zalloc(scsi_bidi_sdb_cache, gfp_mask);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -1057,7 +1057,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 		cmd->request->next_rq->special = bidi_sdb;
 		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
-								    GFP_ATOMIC);
+								    gfp_mask);
 		if (error)
 			goto err_exit;
 	}

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
