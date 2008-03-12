From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Wed, 12 Mar 2008 18:09:16 +0200
Message-ID: <47D8002C.9010306@panasas.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2570 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbYCLQN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 12:13:57 -0400
In-Reply-To: <47D7FECE.1020901@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dougg@torque.net>, linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>

On Wed, Mar 12 2008 at 18:03 +0200, Michael Reed <mdr@sgi.com> wrote:
> 
> Boaz Harrosh wrote:
> 
> <snip>
> 
>> All these patches do not solve the root cause of the problem and until
>> solved, (easily) they will keep popping up.
> 
> I will ask that the correctness of the sg driver's construction of
> a scatter list also be considered here.  Is it ever correct for bi_size
> to wind up larger than the request size?  Why is rounding needed in one
> case (sg_build_indirect) but not the other (sg_link_reserve)?
> 
>> The root cause is that BLOCK_PC commands *can not* be retried in chunks. 
>> The midlayer has no way to know how to retry them. and any attempt to do so
>> will result in an illegal scsi command.
>>
>> I'm really sorry for not seeing this before. I have seen all these emails
>> and patches back and forth but they addressed such remote locations, that
>> I have not paid attention to them.
>>
>> So lets try to touch base. BLOCK_PC command can only be completed in full
>> always. In case of error or residual this should be properly reported and
>> that is all the midlayer can do. The Initiator That knows what command was
>> sent will then decide on a retry or not. In above case that will be user
>> mode.
> 
> Those who truly understand this should comment.  It makes sense to this
> novice.
> 
>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>> untested.
> 
> I can try this out and see what happens.
> 
> 
Will not compile here is a cleaner one

---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 12 Mar 2008 13:18:49 +0200
Subject: [PATCH] scsi: Always complete BLOCK_PC commands

Current code, in some IO combinations could wrongly retry
a BLOCK_PC command in chunks. This was never intended.
Fix it that BLOCK_PC will always complete atomically

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..4b8b57c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -784,14 +784,20 @@ EXPORT_SYMBOL(scsi_release_buffers);
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
 
 	/* The req and req->next_rq have not been completed */
 	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
@@ -866,15 +872,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
-- 
1.5.3.3

