From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] p00002_scsi_tcq_qdepth_fix
Date: Mon, 09 Aug 2004 12:56:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4117BAD1.8050904@us.ibm.com>
References: <410FD06B.3010500@us.ibm.com> <1091814826.2421.11.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000109040803010409070408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:42692 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266805AbUHIR4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 13:56:40 -0400
In-Reply-To: <1091814826.2421.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000109040803010409070408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James,

Ran into a couple small issues with the patch. First, 
blk_queue_resize_tags wasn't getting exported, so I sent Jens a patch to 
fix this, which he has now sent upstream. Second, the comment above 
blk_queue_resize_tags says the queue_lock must be held when calling this 
routine. Attached is an updated patch that grabs the lock. Other than 
that, it looks good.

Thanks,

Brian

James Bottomley wrote:
> On Tue, 2004-08-03 at 10:50, Brian King wrote:
> 
>>Currently, it is possible to call scsi_activate_tcq with a small queue depth,
>>then later call scsi_adjust_queue_depth with a larger queue depth. This results
>>in the scsi layer having a larger queue depth than the block layer knows about.
>>This results in these additional commands being issued as untagged ops rather than
>>tagged ops. This patch changes scsi_activate_tcq to call blk_queue_init_tags with
>>the maximum supported number of tags so this cannot occur.
> 
> 
> Sorry, been away at conferences with not enough time to remember what
> went on here.
> 
> The reason it looks the way it does is historical...when the blk layer
> tcq interfaces were created, there was no way to resize the queue.  Jens
> later added resize (for me) and I forgot to incorporate it into the
> code.
> 
> Another small point is that the max number of tags can be greater than
> 256.  256 is a SPI limit only (and even the qla1280, a SPI card which
> could use the tag as its global queue index would take > 256).  The
> limit in scsi_adjust_queue_depth has long since been obsoleted by our
> dynamic command allocation.
> 
> I think the attached should work correctly (as long as it compiles...I
> coded it up on the flight home).
> 
> James
> 
> ===== drivers/scsi/scsi.c 1.145 vs edited =====
> --- 1.145/drivers/scsi/scsi.c	2004-06-19 07:38:34 -07:00
> +++ edited/drivers/scsi/scsi.c	2004-08-06 10:51:22 -07:00
> @@ -897,15 +897,15 @@
>  	 */
>  	if (tags <= 0)
>  		return;
> -	/*
> -	 * Limit max queue depth on a single lun to 256 for now.  Remember,
> -	 * we allocate a struct scsi_command for each of these and keep it
> -	 * around forever.  Too deep of a depth just wastes memory.
> -	 */
> -	if (tags > 256)
> -		return;
>  
>  	spin_lock_irqsave(&device_request_lock, flags);
> +
> +	/* Check to see if the queue is managed by the block layer
> +	 * if it is, and we fail to adjust the depth, exit */
> +	if (blk_queue_tagged(sdev->request_queue) &&
> +	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
> +		goto out;
> +
>  	sdev->queue_depth = tags;
>  	switch (tagged) {
>  		case MSG_ORDERED_TAG:
> @@ -926,6 +926,7 @@
>  			sdev->queue_depth = tags;
>  			break;
>  	}
> + out:
>  	spin_unlock_irqrestore(&device_request_lock, flags);
>  }
>  
> 
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------000109040803010409070408
Content-Type: text/plain;
 name="scsi_tcq_resize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_tcq_resize.patch"


From: James Bottomley <James.Bottomley@SteelEye.com>

On Tue, 2004-08-03 at 10:50, Brian King wrote:
> Currently, it is possible to call scsi_activate_tcq with a small queue depth,
> then later call scsi_adjust_queue_depth with a larger queue depth. This results
> in the scsi layer having a larger queue depth than the block layer knows about.
> This results in these additional commands being issued as untagged ops rather than
> tagged ops. This patch changes scsi_activate_tcq to call blk_queue_init_tags with
> the maximum supported number of tags so this cannot occur.

Sorry, been away at conferences with not enough time to remember what
went on here.

The reason it looks the way it does is historical...when the blk layer
tcq interfaces were created, there was no way to resize the queue.  Jens
later added resize (for me) and I forgot to incorporate it into the
code.

Another small point is that the max number of tags can be greater than
256.  256 is a SPI limit only (and even the qla1280, a SPI card which
could use the tag as its global queue index would take > 256).  The
limit in scsi_adjust_queue_depth has long since been obsoleted by our
dynamic command allocation.

I think the attached should work correctly (as long as it compiles...I
coded it up on the flight home).

James

===== drivers/scsi/scsi.c 1.145 vs edited =====

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/scsi.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/scsi.c~scsi_tcq_resize drivers/scsi/scsi.c
--- linux-2.6.8-rc3/drivers/scsi/scsi.c~scsi_tcq_resize	2004-08-09 11:38:20.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/scsi.c	2004-08-09 12:55:05.000000000 -0500
@@ -897,15 +897,16 @@ void scsi_adjust_queue_depth(struct scsi
 	 */
 	if (tags <= 0)
 		return;
-	/*
-	 * Limit max queue depth on a single lun to 256 for now.  Remember,
-	 * we allocate a struct scsi_command for each of these and keep it
-	 * around forever.  Too deep of a depth just wastes memory.
-	 */
-	if (tags > 256)
-		return;
 
 	spin_lock_irqsave(&device_request_lock, flags);
+	spin_lock(sdev->request_queue->queue_lock);
+
+	/* Check to see if the queue is managed by the block layer
+	 * if it is, and we fail to adjust the depth, exit */
+	if (blk_queue_tagged(sdev->request_queue) &&
+	    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
+		goto out;
+
 	sdev->queue_depth = tags;
 	switch (tagged) {
 		case MSG_ORDERED_TAG:
@@ -926,6 +927,8 @@ void scsi_adjust_queue_depth(struct scsi
 			sdev->queue_depth = tags;
 			break;
 	}
+ out:
+	spin_unlock(sdev->request_queue->queue_lock);
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
_

--------------000109040803010409070408--

