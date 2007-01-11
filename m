From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 3/3] blk_end_request: caller change
Date: Thu, 11 Jan 2007 09:34:31 +0100
Message-ID: <20070111083430.GD11203@kernel.dk>
References: <20070110.180859.78702215.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:20385 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030227AbXAKIdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 03:33:49 -0500
Content-Disposition: inline
In-Reply-To: <20070110.180859.78702215.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Wed, Jan 10 2007, Kiyoshi Ueda wrote:
> +static int end_request_callback(void *arg)
> +{
> +	struct request *req = (struct request *)arg;
> +
> +	add_disk_randomness(req->rq_disk);
> +	blkdev_dequeue_request(req);
> +
> +	return 0;
> +}

This is bad, don't pass void * around.

> +static int cdrom_newpc_intr_dma_callback(void *arg)
> +{
> +	void **argv = (void **)arg;
> +	struct request *rq = (struct request *)*argv++;
> +	ide_drive_t *drive = (ide_drive_t *)argv++;
> +	spinlock_t *ide_lock = (spinlock_t *)argv;
> +
> +	rq->data_len = 0;
> +
> +	cdrom_newpc_intr_callback_common(rq, drive, ide_lock);
> +
> +	return 0;
> +}

And this is why, down right horrible. The callback should be correctly
typed, pass down a request pointer ALWAYS.

-- 
Jens Axboe

