From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error path
 (was: Re: scsi: unify the error handling of the prep functions)
Date: Tue, 6 Jul 2010 09:59:58 -0400
Message-ID: <20100706135958.GA10772@redhat.com>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
 <20100705134529.GA18645@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0GFOAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 10:00:16 -0400
Content-Disposition: inline
In-Reply-To: <20100705134529.GA18645@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jaxboe@fusionio.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

On Mon, Jul 05 2010 at  9:45am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jul 05 2010 at 12:00am -0400,
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This can be applied to the block's for-2.6.36.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] scsi: unify the error handling of the prep functions
> > 
> > This unifies the error handling of the prep functions (and fix the
> > leak of a page allocated for discard in the case of BLKPREP_KILL or
> > BLK_PREP_DEFER).
> > 
> > The error handling of the prep path is very messy. Some errors are
> > handled in the prep functions while some are in scsi_prep_return().
> > 
> > Let's handle all the errors in scsi_prep_return().
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> This patch addresses the discard page leak too (scsi_prep_error calls
> scsi_unprep_request which calls blk_unprep_request).
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Hi,

Your unified error handling forces a BLKPREP_KILL or BLKPREP_DEFER
return from scsi_setup_discard_cmnd to depend on prep cleanup even
though BLKPREP_OK was not returned.  And this works, but it runs counter
to the rules James previously shared: http://lkml.org/lkml/2010/7/1/512

"The rules are pretty clear:  Unprep is only called if the request gets
prepped ... that means you have to return BLKPREP_OK.  Defer or kill
assume there's no teardown to do, so the allocation (if it took place)
must be reversed before returning them."

All this being said, I'm OK with your patch (as my ack implies) but I
can see that it will take the request prep error handling in a direction
James may prefer to avoid.

Here is a minimalist patch that 1) removes the discard request's page
leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
is a priority, introducing additional error path code sharing/cleanup is
secondary and can come later.

=
From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error path

Currently, a discard request's page will not get cleaned up in the
scsi_setup_discard_cmnd error path.  A scsi_setup_discard_cmnd return
other than BLKPREP_OK will not cause a discard request to get completely
cleaned up (scsi_prep_return will not set REQ_DONTPREP unless BLKPREP_OK
was returned).

This fix eliminates the leak while preserving the rule that:
Unprep is only called if the request gets prepped (meaning a return
BLKPREP_OK).  Defer or kill assume there's no teardown to do, so any
allocation must be reversed before returning them.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/sd.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0994ab6..08e08bd 100644
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
+	if (rq->cmd_flags & REQ_DISCARD) {
 		__free_page(virt_to_page(rq->buffer));
+		rq->buffer = NULL;
+	}
 }
 
 /**
