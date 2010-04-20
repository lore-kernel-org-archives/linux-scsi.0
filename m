From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: [PATCH] Re: SYNCHRONIZE_CACHE from sd_preppare_flush does not have retries.!
Date: Tue, 20 Apr 2010 16:54:04 +0200
Message-ID: <201004201654.04934.bs_lists@aakef.fastmail.fm>
References: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com> <201004192117.15625.bs_lists@aakef.fastmail.fm> <1C9608B8A4CD534FB19C7C7543CBB249021C7719CF@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36166 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718Ab0DTOyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2010 10:54:09 -0400
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB249021C7719CF@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday 20 April 2010, Desai, Kashyap wrote:
> > > > > all block device flushes or is this more device specific? I was
> > > > > thinking that we may want to create a sysfs interface under the
> >
> > block
> >
> > > > > dirs and have blk-sysfs.c and blk-barrier.c handle this.
> >
> > queue_flush
> >
> > > > > could set the timeout and retries that is set by some new files
> >
> > under
> >
> > > > > /sys/block/sdX/queue/ ?
> 
> Thanks a lot for your comments.
> 
> This is very close to my understanding. I feel this is more close to block
>  layer and I am almost agreeing with your thought. I tried to understand
>  why upstream does not have retries at queue_flush()/sd_prepare_flush() ???
>  It looks like there is not specific reason. If I am wrong can someone
>  explain is there any specific reason not to set rq->retries in
>  sd_prepare_flush?

I don't understand why we should need another queue timeout, when we 
already have a device timeout that is used as queue timeout?
Below is an updated patch. And I think as of commit 
242f9dcb8ba6f68fcd217a119a7648a4f69290e9 ("block: unify request 
timeout handling") using struct request_queue->rq_timeout is correct.

What I really wonder about, if we shouldn't add a scsi sysfs entry 
to set a default timeout? In some environments (e.g. ib_srp with a 
large number of LUNs through an IB switch) scanning the those devices 
can be slow and besides that many of those device scan functions 
use SD_TIMEOUT, we also have not set timeouts using udev already, 
as udev will only be called once the scan is over...



[SCSI] Use user defined timeouts for SYNCHRONIZE_CACHE

Switch to adjustable timeout value for scsi SYNCHRONIZE_CACHE commands.
We have been running into problems with fixed values on troublesome devices.

Update: add SD_MAX_RETRIES in sd_prepare_flush()

Patch originally written for Q-Leap, but DDN needs it as well.


Signed-off-by: Bernd Schubert <bschubert@ddn.com>


---
 drivers/scsi/sd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-git/drivers/scsi/sd.c
===================================================================
--- linux-git.orig/drivers/scsi/sd.c
+++ linux-git/drivers/scsi/sd.c
@@ -1020,7 +1020,8 @@ static int sd_sync_cache(struct scsi_dis
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+				       sdp->request_queue->rq_timeout,
+				       SD_MAX_RETRIES, NULL);
 		if (res == 0)
 			break;
 	}
@@ -1039,7 +1040,8 @@ static int sd_sync_cache(struct scsi_dis
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = q->rq_timeout;
+	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }

