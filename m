From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error
 path (was: Re: scsi: unify the error handling of the prep functions)
Date: Thu, 8 Jul 2010 13:17:47 +0900
Message-ID: <20100708131726C.fujita.tomonori@lab.ntt.co.jp>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
	<20100705134529.GA18645@redhat.com>
	<20100706135958.GA10772@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60449 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0GHESS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 00:18:18 -0400
In-Reply-To: <20100706135958.GA10772@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: snitzer@redhat.com, jaxboe@fusionio.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

On Tue, 6 Jul 2010 09:59:58 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Here is a minimalist patch that 1) removes the discard request's page
> leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
> is a priority, introducing additional error path code sharing/cleanup is
> secondary and can come later.

This patch doesn't work. I hit kernel oops since now this patch frees
a discard page twice.

If scsi_init_io hits BLKPREP_DEFER (e.g. due to scsi_init_sgtable),
scsi_setup_blk_pc_cmnd calls scsi_unprep_request. So sd_unprep_fn
frees a page. Then, scsi_setup_discard_cmnd frees the same page again.


I talked to James on irc, he prefers to strictly apply the rule that
we should unprep on only the requests that got prepped.

So we need to remove scsi_unprep_request in scsi_init_io error
path. The following patch solves all the issues (hopefully).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: fix discard page leak

We leak a page allocated for discard on some error conditions
(e.g. scsi_prep_state_check returns BLKPREP_DEFER in
scsi_setup_blk_pc_cmnd).

We unprep on requests that weren't prepped in the error path of
scsi_init_io. It makes the error path to clean up scsi commands messy.

Let's strictly apply the rule that we can't unprep on a request that
wasn't prepped.

Calling just scsi_put_command() in the error path of scsi_init_io() is
enough. We don't set REQ_DONTPREP yet.

scsi_setup_discard_cmnd can safely free a page on the error case with
the above rule.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |    7 ++-----
 drivers/scsi/sd.c       |   10 ++++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ee83619..b8de389 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1011,11 +1011,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 err_exit:
 	scsi_release_buffers(cmd);
-	if (error == BLKPREP_KILL)
-		scsi_put_command(cmd);
-	else /* BLKPREP_DEFER */
-		scsi_unprep_request(cmd->request);
-
+	scsi_put_command(cmd);
+	cmd->request->special = NULL;
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0994ab6..1d0c4b7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -468,6 +468,10 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	blk_add_request_payload(rq, page, len);
 	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 	rq->buffer = page_address(page);
+	if (ret != BLKPREP_OK) {
+		__free_page(page);
+		rq->buffer = NULL;
+	}
 	return ret;
 }
 
@@ -485,8 +489,10 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
-		__free_page(virt_to_page(rq->buffer));
+	if (rq->cmd_flags & REQ_DISCARD) {
+		free_page((unsigned long)rq->buffer);
+		rq->buffer = NULL;
+	}
 }
 
 /**
-- 
1.6.5

