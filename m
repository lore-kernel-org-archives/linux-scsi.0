From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take
	3)
Date: Mon, 03 Dec 2007 17:52:12 -0500 (EST)
Message-ID: <20071203.175212.52162634.k-ueda@ct.jp.nec.com>
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com>
	<200712012342.52134.bzolnier@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200712012342.52134.bzolnier@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bzolnier@gmail.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Hi Bartlomiej,

On Sat, 1 Dec 2007 23:42:51 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> > This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request().
> > 
> > ide-cd (cdrom_newpc_intr()) has some tricky behaviors below which
> > need to use blk_end_request_callback().
> > Needs to:
> >   1. call post_transform_command() to modify request contents
> 
> Seems like post_transform_command() call can be removed (patch below).
> 
> >   2. wait completing request until DRQ_STAT is cleared
> 
> Would be great if somebody convert cdrom_newpc_intr() to use scatterlists
> also for PIO transfers (ide_pio_sector() in ide-taskfile.c should serve
> as a good starting base to see how to do PIO transfers using scatterlists)
> so we could get rid of partial request completions in cdrom_newpc_intr()
> and just fully complete request when the transfer is done.  Shouldn't be
> difficult but I guess that we can live with blk_end_request_callback() for
> the time being...
> 
> > after end_that_request_first() and before end_that_request_last().
> > 
> > As for the second one, ide-cd will wait for the interrupt from device.
> > So blk_end_request_callback() has to return without completing request
> > even if no leftover in the request.
> > ide-cd uses a dummy callback function, which just returns value '1',
> > to tell blk_end_request_callback() about that.
> > 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> 
> [PATCH] ide-cd: remove dead post_transform_command()
> 
> post_transform_command() call in cdrom_newpc_intr() has no effect because
> it is done after the request has already been fully completed (rq->bio and
> rq->data are always NULL).  It was verified to be true regardless whether
> INQUIRY command is using DMA or PIO to transfer data (by using modified
> Tejun Heo's test-shortsg.c utility and adding a few printk()-s to ide-cd).
> 
> This was uncovered thanks to the "blk_end_request: full I/O completion
> handler (take 3)" patch series from Kiyoshi Ueda.
> 
> Cc: jens.axboe@oracle.com
> Cc: bharrosh@panasas.com
> Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Kiyoshi: please rebase your patch on top of this one (I'll send
> it to Linus in the next IDE update), should make your patch a bit
> simpler.
> 
> Tejun: you had really good timing with posting test-shortsg.c
> (it saved me some time coding user-space SG_IO tester), thanks!
> 
>  drivers/ide/ide-cd.c |   28 ----------------------------
>  1 file changed, 28 deletions(-)
> 
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1650,31 +1650,6 @@ static int cdrom_write_check_ireason(ide
>  	return 1;
>  }
>  
> -static void post_transform_command(struct request *req)
> -{
> -	u8 *c = req->cmd;
> -	char *ibuf;
> -
> -	if (!blk_pc_request(req))
> -		return;
> -
> -	if (req->bio)
> -		ibuf = bio_data(req->bio);
> -	else
> -		ibuf = req->data;
> -
> -	if (!ibuf)
> -		return;
> -
> -	/*
> -	 * set ansi-revision and response data as atapi
> -	 */
> -	if (c[0] == GPCMD_INQUIRY) {
> -		ibuf[2] |= 2;
> -		ibuf[3] = (ibuf[3] & 0xf0) | 2;
> -	}
> -}
> -
>  typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
>  
>  /*
> @@ -1810,9 +1785,6 @@ static ide_startstop_t cdrom_newpc_intr(
>  	return ide_started;
>  
>  end_request:
> -	if (!rq->data_len)
> -		post_transform_command(rq);
> -
>  	spin_lock_irqsave(&ide_lock, flags);
>  	blkdev_dequeue_request(rq);
>  	end_that_request_last(rq, 1);

Thank you for the comments.
I rebased my patch on top of 2.6.24-rc3-mm2 + the patch to remove
post_transform_command().

As a result, one callback function for DMA mode has been removed.
What do you think about the patch below?



Subject: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)


This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request
interfaces.

In PIO mode, ide-cd (cdrom_newpc_intr()) needs to defer
end_that_request_last() until the device clears DRQ_STAT and raises
an interrupt after end_that_request_first().
So blk_end_request() has to return without completing request
even if no leftover in the request.

ide-cd uses blk_end_request_callback() and a dummy callback function,
which just returns value '1', to tell blk_end_request_callback()
about that.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 14 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/ide/ide-cd.c
+++ 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
@@ -1644,6 +1644,17 @@ static int cdrom_write_check_ireason(ide
 	return 1;
 }
 
+/*
+ * Called from blk_end_request_callback() after the data of the request
+ * is completed and before the request is completed.
+ * By returning value '1', blk_end_request_callback() returns immediately
+ * without completing the request.
+ */
+static int cdrom_newpc_intr_dummy_cb(struct request *rq)
+{
+	return 1;
+}
+
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
 /*
@@ -1682,9 +1693,13 @@ static ide_startstop_t cdrom_newpc_intr(
 			return ide_error(drive, "dma error", stat);
 		}
 
-		end_that_request_chunk(rq, 1, rq->data_len);
-		rq->data_len = 0;
-		goto end_request;
+		spin_lock_irqsave(&ide_lock, flags);
+		if (__blk_end_request(rq, 1, rq->data_len))
+			BUG();
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		return ide_stopped;
 	}
 
 	/*
@@ -1702,8 +1717,15 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * If DRQ is clear, the command has completed.
 	 */
-	if ((stat & DRQ_STAT) == 0)
-		goto end_request;
+	if ((stat & DRQ_STAT) == 0) {
+		spin_lock_irqsave(&ide_lock, flags);
+		if (__blk_end_request(rq, 1, 0))
+			BUG();
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		return ide_stopped;
+	}
 
 	/*
 	 * check which way to transfer data
@@ -1756,7 +1778,14 @@ static ide_startstop_t cdrom_newpc_intr(
 		rq->data_len -= blen;
 
 		if (rq->bio)
-			end_that_request_chunk(rq, 1, blen);
+			/*
+	 		 * The request can't be completed until DRQ is cleared.
+			 * So complete the data, but don't complete the request
+			 * using the dummy function for the callback feature
+			 * of blk_end_request_callback().
+			 */
+			blk_end_request_callback(rq, 1, blen,
+						 cdrom_newpc_intr_dummy_cb);
 		else
 			rq->data += blen;
 	}
@@ -1777,14 +1806,6 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, NULL);
 	return ide_started;
-
-end_request:
-	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
-	end_that_request_last(rq, 1);
-	HWGROUP(drive)->rq = NULL;
-	spin_unlock_irqrestore(&ide_lock, flags);
-	return ide_stopped;
 }
 
 static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)

Thanks,
Kiyoshi Ueda
