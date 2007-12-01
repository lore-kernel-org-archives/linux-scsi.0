From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
Date: Sat, 1 Dec 2007 23:42:51 +0100
Message-ID: <200712012342.52134.bzolnier@gmail.com>
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:53508 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXLAWpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Dec 2007 17:45:12 -0500
Received: by ug-out-1314.google.com with SMTP id z38so2113208ugc
        for <linux-scsi@vger.kernel.org>; Sat, 01 Dec 2007 14:45:11 -0800 (PST)
In-Reply-To: <20071130.183447.82055860.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com


Hi,

On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request().
> 
> ide-cd (cdrom_newpc_intr()) has some tricky behaviors below which
> need to use blk_end_request_callback().
> Needs to:
>   1. call post_transform_command() to modify request contents

Seems like post_transform_command() call can be removed (patch below).

>   2. wait completing request until DRQ_STAT is cleared

Would be great if somebody convert cdrom_newpc_intr() to use scatterlists
also for PIO transfers (ide_pio_sector() in ide-taskfile.c should serve
as a good starting base to see how to do PIO transfers using scatterlists)
so we could get rid of partial request completions in cdrom_newpc_intr()
and just fully complete request when the transfer is done.  Shouldn't be
difficult but I guess that we can live with blk_end_request_callback() for
the time being...

> after end_that_request_first() and before end_that_request_last().
> 
> As for the second one, ide-cd will wait for the interrupt from device.
> So blk_end_request_callback() has to return without completing request
> even if no leftover in the request.
> ide-cd uses a dummy callback function, which just returns value '1',
> to tell blk_end_request_callback() about that.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

[PATCH] ide-cd: remove dead post_transform_command()

post_transform_command() call in cdrom_newpc_intr() has no effect because
it is done after the request has already been fully completed (rq->bio and
rq->data are always NULL).  It was verified to be true regardless whether
INQUIRY command is using DMA or PIO to transfer data (by using modified
Tejun Heo's test-shortsg.c utility and adding a few printk()-s to ide-cd).

This was uncovered thanks to the "blk_end_request: full I/O completion
handler (take 3)" patch series from Kiyoshi Ueda.

Cc: jens.axboe@oracle.com
Cc: bharrosh@panasas.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Kiyoshi: please rebase your patch on top of this one (I'll send
it to Linus in the next IDE update), should make your patch a bit
simpler.

Tejun: you had really good timing with posting test-shortsg.c
(it saved me some time coding user-space SG_IO tester), thanks!

 drivers/ide/ide-cd.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1650,31 +1650,6 @@ static int cdrom_write_check_ireason(ide
 	return 1;
 }
 
-static void post_transform_command(struct request *req)
-{
-	u8 *c = req->cmd;
-	char *ibuf;
-
-	if (!blk_pc_request(req))
-		return;
-
-	if (req->bio)
-		ibuf = bio_data(req->bio);
-	else
-		ibuf = req->data;
-
-	if (!ibuf)
-		return;
-
-	/*
-	 * set ansi-revision and response data as atapi
-	 */
-	if (c[0] == GPCMD_INQUIRY) {
-		ibuf[2] |= 2;
-		ibuf[3] = (ibuf[3] & 0xf0) | 2;
-	}
-}
-
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
 /*
@@ -1810,9 +1785,6 @@ static ide_startstop_t cdrom_newpc_intr(
 	return ide_started;
 
 end_request:
-	if (!rq->data_len)
-		post_transform_command(rq);
-
 	spin_lock_irqsave(&ide_lock, flags);
 	blkdev_dequeue_request(rq);
 	end_that_request_last(rq, 1);
