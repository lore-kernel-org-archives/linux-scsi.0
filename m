From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_error: fix scsi_eh_lock_door() documentation
Date: Sun, 17 May 2009 09:30:48 -0500
Message-ID: <1242570648.11755.7.camel@mulgrave.int.hansenpartnership.com>
References: <200905162126.22659.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38330 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbZEQOar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 May 2009 10:30:47 -0400
In-Reply-To: <200905162126.22659.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-05-16 at 21:26 +0200, Bartlomiej Zolnierkiewicz wrote:
> Nowadays eh_lock_door_done() uses blk_get_request() instead of
> scsi_allocate_request().

I appreciate any attempt to clean up the rather parlous state of our
documentation.  However, unfortunately, this isn't a simple search and
replace job ... what you've done here is transform an obviously
incorrect set of statements into a more plausible but still incorrect
set of statements.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> on top of linux-next
> 
>  drivers/scsi/scsi_error.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: b/drivers/scsi/scsi_error.c
> ===================================================================
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1451,7 +1451,7 @@ static void eh_lock_door_done(struct req
>   * @sdev:	SCSI device to prevent medium removal
>   *
>   * Locking:
> - * 	We must be called from process context; scsi_allocate_request()
> + * 	We must be called from process context; blk_get_request()
>   * 	may sleep.

Actually, it may or may not depending upon what the user tells it in the
gfp argument, so the best course here is to kill everything after the
semicolon.

>   * Notes:
> @@ -1459,11 +1459,11 @@ static void eh_lock_door_done(struct req
>   * 	head of the devices request queue, and continue.
>   *
>   * Bugs:
> - * 	scsi_allocate_request() may sleep waiting for existing requests to
> + * 	blk_get_request() may sleep waiting for existing requests to
>   * 	be processed.  However, since we haven't kicked off any request
>   * 	processing for this host, this may deadlock.

May have been true for scsi_allocate_request, certainly untrue for
blk_get_request, since we've gone to great pains to eliminate these
problems.

> - *	If scsi_allocate_request() fails for what ever reason, we
> + *	If blk_get_request() fails for what ever reason, we
>   *	completely forget to lock the door.

Misleading, since blk_get_request() cannot fail given the gfp flags
we're using.

So the correct way to fix all of this (including a code change to
prevent the spurious null check on blk_get_request() return) is below.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..a2a47c3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1451,28 +1451,21 @@ static void eh_lock_door_done(struct request *req, int uptodate)
  * @sdev:	SCSI device to prevent medium removal
  *
  * Locking:
- * 	We must be called from process context; scsi_allocate_request()
- * 	may sleep.
+ * 	We must be called from process context.
  *
  * Notes:
  * 	We queue up an asynchronous "ALLOW MEDIUM REMOVAL" request on the
  * 	head of the devices request queue, and continue.
- *
- * Bugs:
- * 	scsi_allocate_request() may sleep waiting for existing requests to
- * 	be processed.  However, since we haven't kicked off any request
- * 	processing for this host, this may deadlock.
- *
- *	If scsi_allocate_request() fails for what ever reason, we
- *	completely forget to lock the door.
  */
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct request *req;
 
+	/*
+	 * blk_get_request with GFP_KERNEL (__GFP_WAIT) sleeps until a
+	 * request becomes available
+	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
-	if (!req)
-		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;


