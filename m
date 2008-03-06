From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi_lib: Convert GFP_ATOMIC to gfp_flags
Date: Thu, 06 Mar 2008 17:37:11 +0200
Message-ID: <47D00FA7.4040404@panasas.com>
References: <20080220182604.GD27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:35581 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbYCFPiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 10:38:05 -0500
In-Reply-To: <20080220182604.GD27736@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Wed, Feb 20 2008 at 20:26 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> scsi_init_io() is already passed a gfp_mask, so we should use that
> instead of an explicit GFP_ATOMIC
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f243fc3..b81170d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1048,8 +1048,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  		goto err_exit;
>  
>  	if (blk_bidi_rq(cmd->request)) {
> -		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
> -			scsi_bidi_sdb_cache, GFP_ATOMIC);
> +		struct scsi_data_buffer *bidi_sdb;
> +		bidi_sdb = kmem_cache_zalloc(scsi_bidi_sdb_cache, gfp_mask);
>  		if (!bidi_sdb) {
>  			error = BLKPREP_DEFER;
>  			goto err_exit;
> @@ -1057,7 +1057,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  
>  		cmd->request->next_rq->special = bidi_sdb;
>  		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
> -								    GFP_ATOMIC);
> +								    gfp_mask);
>  		if (error)
>  			goto err_exit;
>  	}
> 
Sorry for the late reply. Thanks for the patch but ...

Jens does not like a second part in a compound allocation to wait. This is
because it can cause a deadlock between contenders that both grabbed half
the resource and are waiting for the second part, if they don't wait, and
release the first part at least one can continue.

Perhaps a small change to the patch would be better. (See below)

Boaz
---
From: Matthew Wilcox <willy@linux.intel.com>
Date: Thu, 6 Mar 2008 17:21:47 +0200
Subject: [PATCH] scsi_lib: Convert GFP_ATOMIC to gfp_flags

scsi_init_io() is already passed a gfp_mask, so we should use that
instead of an explicit GFP_ATOMIC

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..4d1d886 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1047,8 +1047,9 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		goto err_exit;
 
 	if (blk_bidi_rq(cmd->request)) {
-		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+		struct scsi_data_buffer *bidi_sdb;
+		bidi_sdb = kmem_cache_zalloc(scsi_bidi_sdb_cache,
+							gfp_mask & ~__GFP_WAIT);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
@@ -1056,7 +1057,7 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 		cmd->request->next_rq->special = bidi_sdb;
 		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
-								    GFP_ATOMIC);
+							gfp_mask & ~__GFP_WAIT);
 		if (error)
 			goto err_exit;
 	}
-- 
1.5.3.3

