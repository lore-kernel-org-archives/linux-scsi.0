From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Wed, 12 Mar 2008 12:46:57 +0200
Message-ID: <47D7B4A1.6020909@panasas.com>
References: <47D7035F.5000700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:58112 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYCLKrc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 06:47:32 -0400
In-Reply-To: <47D7035F.5000700@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>

On Wed, Mar 12 2008 at 0:10 +0200, Michael Reed <mdr@sgi.com> wrote:
> Note: description below applies to 2.6.24 as that's what was used to
> isolate the problem being described.  There are comments at the end
> with regard to 2.6.25-rc4-git3.  The below email thread directly 
> applies to this bug/patch.
> 
> http://marc.info/?l=linux-scsi&m=120222578814366&w=2
> 
> --
> 
> While performing raid reset testing using 2.6.24, every once in the
> while I noticed that one of the raid's management tools would not exit.
> I tracked this down to it waiting on an inquiry command's completion.
> 
> An infinite loop occurs because there is an occasional inquiry
> command submitted to the host driver with the associated bio
> having a bi_size field of 512 when the inquiry command's transfer
> length is 255.  This "enlarged" bi_size field causes the completion
> handler to re-issue the inquiry command because there are "leftovers"
> following the completion.
> 
> scsi_finish_command() calls scsi_io_completion() with
> good_bytes equal to cmd->request_bufflen.
> 
> scsi_io_completion() sets req->data_len to the residual provided
> by the LLDD.
> 
> scsi_io_completion() calls scsi_end_request() with the good_bytes
> value of 255.
> 
> scsi_end_request() calls end_that_request_chunk() which calls
> __end_that_request_first() which uses bio->bi_size as the size of
> the request.  As bi_size is larger than the number of bytes (nr_bytes)
> being completed, it returns "1" indicating that there wasn't enough
> data to finish the request.
> 
> scsi_end_request() then calls scsi_requeue_command() to resubmit and
> fetch that data which wasn't received.  This results in the
> command being reissued using the residual value returned by
> the driver as the request_bufflen for the next command.
> 
> This repeats itself until the residual is zero and bi_size is
> non-zero at which point the command gets reissued with a 
> request_bufflen of zero and sc_data_direction of DMA_NONE.
> The subsequent completions are retried infinitely because
> bi_size is still non-zero.
> 
> What drove me crazy is that this didn't happen with every inquiry
> command issued by the application.  It was very infrequent.
> I finally tracked it down to the sg driver.
> 
> sg_ioctl() calls sg_new_write() which calls sg_common_write()
> which calls sg_start_req().
> 
> sg_start_req() either calls sg_link_reserve() or sg_build_indirect()
> to set up the data transfer.  The call to sg_build_indirect()
> ROUNDS UP THE REQUEST SIZE to a sector boundary, and this is what
> causes the infinite loop.
> 
> I tried removing the round up statement in sg_build_indirect()
> and forcing sg_start_req() to always call sg_build_indirect()
> to test the change and the infinite loop did not occur.
> 
> To me, it seems that if sg_link_reserve() has no need to round up
> to a sector boundary then sg_build_indirect() should also not need
> to round up the request length.
> 
> I've included a patch (against 2.6.25-rc4-git3) which removes the
> rounding in sg_build_indirect() for your comments.
> 
> I then tried my test case with 2.6.25-rc4-git3 and it didn't happen.
> I noticed the change in the routine scsi_req_map_sg() which
> deletes a line which incremented the "data_len" variable at the start
> of the for_each_sg() loop.  This was also a line which I examined in 6.5.24.
> But, I noticed comments about sg indicating that it "sends a scatterlist
> that is larger than the data_len it wants transferred for certain
> IO sizes", and as that appeared to be what was happening, I went in
> search of what was up with sg.
> 
> So, will the below patch break anything?
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
<snip>

All these patches do not solve the root cause of the problem and until
solved, (easily) they will keep popping up.
The root cause is that BLOCK_PC commands *can not* be retried in chunks. 
The midlayer has no way to know how to retry them. and any attempt to do so
will result in an illegal scsi command.

I'm really sorry for not seeing this before. I have seen all these emails
and patches back and forth but they addressed such remote locations, that
I have not paid attention to them.

So lets try to touch base. BLOCK_PC command can only be completed in full
always. In case of error or residual this should be properly reported and
that is all the midlayer can do. The Initiator That knows what command was
sent will then decide on a retry or not. In above case that will be user
mode.

Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
untested.
---
git-diff --stat -p
 drivers/scsi/scsi_lib.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..e5d05c6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -784,17 +784,24 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * in req->data_len and req->next_rq->data_len. The upper-layer driver can
  * decide what to do with this information.
  */
-void scsi_end_bidi_request(struct scsi_cmnd *cmd)
+static void scsi_end_blk_request(struct scsi_cmnd *cmd)
 {
 	struct request *req = cmd->request;
 	unsigned int dlen = req->data_len;
-	unsigned int next_dlen = req->next_rq->data_len;
+	unsigned int next_dlen;
 
-	req->data_len = scsi_out(cmd)->resid;
-	req->next_rq->data_len = scsi_in(cmd)->resid;
+	if (blk_bidi_rq(req)) {
+		next_dlen = req->next_rq->data_len;
+		req->data_len = scsi_out(cmd)->resid;
+		req->next_rq->data_len = scsi_in(cmd)->resid;
+	} else {
+		next_dlen = 0;
+		req->data_len = scsi_get_resid(cmd);
+	}
 
-	/* The req and req->next_rq have not been completed */
-	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
+	if (blk_end_bidi_request(req, 0, dlen, next_dlen))
+		/* The req and req->next_rq have not been completed */
+		BUG_ON();
 
 	scsi_release_buffers(cmd);
 
@@ -866,15 +873,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
-		if (scsi_bidi_cmnd(cmd)) {
-			/* will also release_buffers */
-			scsi_end_bidi_request(cmd);
-			return;
-		}
-		req->data_len = scsi_get_resid(cmd);
+		/* will also release_buffers */
+		scsi_end_blk_request(cmd);
+		return;
 	}
 
-	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
 	scsi_release_buffers(cmd);
 
 	/*







