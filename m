From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Tue, 9 Jun 2009 22:10:50 +0900
Message-ID: <20090609221019A.fujita.tomonori@lab.ntt.co.jp>
References: <20090609194338S.fujita.tomonori@lab.ntt.co.jp>
	<4A2E4D4F.90901@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41911 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZFINLA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jun 2009 09:11:00 -0400
In-Reply-To: <4A2E4D4F.90901@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, 09 Jun 2009 14:53:51 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/09/2009 01:44 PM, FUJITA Tomonori wrote:
> > This reverts commit 1cd96c242a829d52f7a5ae98f554ca9775429685.
> > 
> > commit 1cd96c242a829d52f7a5ae98f554ca9775429685
> > Author: Boaz Harrosh <bharrosh@panasas.com>
> > Date:   Tue Mar 24 12:35:07 2009 +0100
> > 
> >     block: WARN in __blk_put_request() for potential bio leak
> > 
> >     Put a WARN_ON in __blk_put_request if it is about to
> >     leak bio(s). This is a serious bug that can happen in error
> >     handling code paths.
> > 
> >     For this to work I have fixed a couple of places in block/ where
> >     request->bio != NULL ownership was not honored. And a small cleanup
> >     at sg_io() while at it.
> > 
> > 
> > With 2.6.30-rc, BSG SMP requests get the following warnings:
> > 
> > WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()
> > 
> > However, this is false. There is no bio leak wrt BSG SMP
> > requests. Probably the better fix is calling blk_end_request_all() in
> > the BSG SMP path.
> > 
> > blk_end_request_all() is not very useful for the BSG SMP path (we call
> > it to just unlink rq->bio) however calling blk_end_request_all() in
> > all bio users is consistent.
> > 
> > blk_end_request_all() is not available in 2.6.30-rc so seems that the
> > simplest fix is removing WARN_ON for now.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Please do not revert. This is the point of all this.
> 
> If there is no leak, You should NULL out the req->bio
> for now, and for 2.6.31 change the code to do 
> blk_end_request_all(). That's what blk_end_request does,
> since you are doing your own completion then set req->bio
> to null after you're done. (And before put_request)
> 
> This stuff is good for error paths to catch leaks, please
> leave it?

Has this your good stuff found any bio leak bugs in mainline? In
addition, breaking working code is not a proper development style.

Anyway, setting req->bio in bsg works. Either is fine by me.


Jens, can you please send either patch to Linus now?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: setting rq->bio to NULL

Due to commit 1cd96c242a829d52f7a5ae98f554ca9775429685 ("block: WARN
in __blk_put_request() for potential bio leak"), BSG SMP requests get
the false warnings:

WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()

This sets rq->bio to NULL to avoid that false warnings.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 206060e..dd81be4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -315,6 +315,7 @@ out:
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
+		next_rq->bio = NULL;
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -448,6 +449,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->dout_resid = rq->data_len;
 		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
+		rq->next_rq->bio = NULL;
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
 		hdr->din_resid = rq->data_len;
@@ -466,6 +468,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	blk_rq_unmap_user(bio);
 	if (rq->cmd != rq->__cmd)
 		kfree(rq->cmd);
+	rq->bio = NULL;
 	blk_put_request(rq);
 
 	return ret;
-- 
1.5.6.5

