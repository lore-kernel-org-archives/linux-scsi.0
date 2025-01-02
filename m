Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0376D1494C2;
	Thu,  2 Jan 2025 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735790799; cv=none; b=FtjjkzinWfgYzTxTFzAiKmAiienAVScowfg6m2GKKKAFkhqIDYur+AB8saix+M28Xva9cFiq/uETK8jyVqKVFxr8elPhvWV5DA0aIP6fwvKpQXWItehUJWS/UG2HHAk+VQlb67HlvK+nmKczcO4KzDT1Ys7zAU/F/sQZmtX0Zaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735790799; c=relaxed/simple;
	bh=Yo7DKW63ImneN9BmI6CKAS0RorOk00phbTxdnFBsDsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8A0wbDfuV2pFmOrzWME1X3Moo1+WfGXIGy3j+qqDuCpOBVHjDe6aWQShxoZqOcpnGjcmNu91wOOOjmPlj4+czQs0rLejlQXZ/CNNRLpoXEPN1gjaGkz88w0Fd1ZuSNuhKm2m6m1KXsTpgHj6oU48uePA0cbpL1aJrZkOVoPTIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dMNZe5ql; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dMNZe5ql"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iMLpK7U9WYHmx0iT1T9KJlpKXJYaEu7HU7H6KfDU588=; b=dMNZe5qlfMN+VDuQTbBhmp+4Bv
	QrKPAHI3LFcSRnmBoLSL+g/BDLPFLYYPw/kwlIkqCnrz4LaogbA9VD8hbFlqKG12C2acEd0cuTkb/
	MCs4WtPL+VPdiIKQJ/+vqZcNmXsMcKAv9T0lf4eAYE1ecfv/CFrylrt2KA2Z42Ta9irR5fRjQZOR6
	XHV+FVYBI6PTpDE9/vcoFdkn3/FoIvM5LDVW4QWYwIBpj9BFe+z9KFFwqRhTn0ejfRES70jY62/EE
	i9wlIg07in6ehPSfcIUhasxRZOg9P23V3pm2h3wbbXPrqTwZF9J5dzAmXMYeRlStCZdGikHnohD/0
	p9j7Q+Sw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tTCTZ-0000000Eyaj-2SUV;
	Thu, 02 Jan 2025 04:06:25 +0000
Date: Thu, 2 Jan 2025 04:06:25 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jerry <jerrydeng079@163.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] mm: fix dead-loop bug
Message-ID: <Z3YQwcX8SpJbcVAD@casper.infradead.org>
References: <20250101132148.126393-1-jerrydeng079@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250101132148.126393-1-jerrydeng079@163.com>

On Wed, Jan 01, 2025 at 09:21:48PM +0800, Jerry wrote:
> KERNEL-5.10.232.generic_perform_write()->balance_dirty_pages_ratelimited()->        

Can you reproduce this with a kernel that's newer than four years old?

> balance_dirty_pages() At this point,if the block device removed, 
> the process  may trapped in a dead loop.and the memory of the bdi 
> device hass also been released.

I think this is a block layer bug, not an MM bug.  Devices shouldn't
go away while the MM is still writing to them.

> Insert a USB flash and directly writing to device node.
> Remove the USB flash while writing, and the writing process 
> may trapped in a dead loop.
> 
> user code:
> 
> int fd = open("/dev/sda", O_RDWR);
> char *p = malloc(0x1000000);
> memset(p, 0xa, 0x1000000);
> for(int i=0; i<100; i++) {
> 
> 
> 	write(fd, p, 0x1000000);
> 
> 
> }
> return;
> 
> ISSUE 1: Dead loop may occr here.
> CALL trace:
> 
> schedule_timeout()
> 
> io_schedule_timeout()
> 
> balance_dirty_pages()
> 
> balance_dirty_pages_ratelimited()
> 
> balance_dirty_pages_ratelimited)
> 
> ISSUE 2 , BDI&WB memory illegal .
> void balance_dirty_pages_ratelimited(struct address_space *mapping)
> {
> 	struct inode *inode = mapping->host;
> 	struct backing_dev_info *bdi = inode_to_bdi(inode);
> 	struct bdi_writeback *wb = NULL;
> 	int ratelimit;
> 	.....
> 
> }
> BDI&WB memory belong to SCSI device. If the USB flash remove, 
> The BDI&WB memeory released by below process:
> 
> bdi_unregister()
> 
> del_gendisk()
> 
> sd_remove()
> 
> __device_release_driver()
> 
> device_release_driver()
> 
> bus_remove_device()
> 
> device_del()
> 
> __scsi_remove_deice()
> 
> scsi_forget_host()
> 
> scsi_remove_host()
> 
> usb_stor_disconnect()
> 
> ...
> 
> usb_unbind_initerface()
> 
> usb_disable_device()
> 
> usb_disconnect()
> 
> Signed-off-by: Jerry <jerrydeng079@163.com>
> ---
>  mm/backing-dev.c    |  1 +
>  mm/filemap.c        |  6 ++++-
>  mm/page-writeback.c | 56 ++++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 56 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index dd08ab928..0b86bd980 100755
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -878,6 +878,7 @@ void bdi_unregister(struct backing_dev_info *bdi)
>  	/* make sure nobody finds us on the bdi_list anymore */
>  	bdi_remove_from_list(bdi);
>  	wb_shutdown(&bdi->wb);
> +	wake_up(&(bdi->wb_waitq));
>  	cgwb_bdi_unregister(bdi);
>  
>  	/*
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3b0d8c6dd..48424240f 100755
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3300,6 +3300,7 @@ ssize_t generic_perform_write(struct file *file,
>  	long status = 0;
>  	ssize_t written = 0;
>  	unsigned int flags = 0;
> +	errseq_t err = 0;
>  
>  	do {
>  		struct page *page;
> @@ -3368,8 +3369,11 @@ ssize_t generic_perform_write(struct file *file,
>  		}
>  		pos += copied;
>  		written += copied;
> -
> +		
>  		balance_dirty_pages_ratelimited(mapping);
> +		err = errseq_check(&mapping->wb_err, 0);
> +		if (err)
> +			return err;
>  	} while (iov_iter_count(i));
>  
>  	return written ? written : status;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index b2c916474..001dd0c5e 100755
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -146,6 +146,13 @@ struct dirty_throttle_control {
>  	unsigned long		pos_ratio;
>  };
>  
> +struct bdi_wq_callback_entry {
> +	struct task_struct *tsk;
> +	struct wait_queue_entry  wq_entry;
> +	int bdi_unregister;
> +};
> +
> +
>  /*
>   * Length of period for aging writeout fractions of bdis. This is an
>   * arbitrarily chosen number. The longer the period, the slower fractions will
> @@ -1567,6 +1574,22 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
>  	}
>  }
>  
> +
> +static int wake_up_bdi_waitq(wait_queue_entry_t *wait, unsigned int mode,
> +				int sync, void *key)
> +{
> +
> +	struct bdi_wq_callback_entry *bwce =
> +		container_of(wait, struct bdi_wq_callback_entry, wq_entry);
> +
> +	bwce->bdi_unregister = 1;
> +	if (bwce->tsk)
> +		wake_up_process(bwce->tsk);
> +
> +	return 0;
> +}
> +
> +
>  /*
>   * balance_dirty_pages() must be called by processes which are generating dirty
>   * data.  It looks at the number of dirty pages in the machine and will force
> @@ -1574,7 +1597,7 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
>   * If we're over `background_thresh' then the writeback threads are woken to
>   * perform some writeout.
>   */
> -static void balance_dirty_pages(struct bdi_writeback *wb,
> +static int balance_dirty_pages(struct bdi_writeback *wb,
>  				unsigned long pages_dirtied)
>  {
>  	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
> @@ -1595,7 +1618,15 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  	struct backing_dev_info *bdi = wb->bdi;
>  	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
>  	unsigned long start_time = jiffies;
> +	struct bdi_wq_callback_entry bwce = {NULL};
> +	int ret = 0;
>  
> +	if (!test_bit(WB_registered, &wb->state))
> +		return -EIO;
> +	
> +	init_waitqueue_func_entry(&(bwce.wq_entry), wake_up_bdi_waitq);
> +	bwce.tsk = current;
> +	add_wait_queue(&(bdi->wb_waitq), &(bwce.wq_entry));
>  	for (;;) {
>  		unsigned long now = jiffies;
>  		unsigned long dirty, thresh, bg_thresh;
> @@ -1816,6 +1847,11 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  		wb->dirty_sleep = now;
>  		io_schedule_timeout(pause);
>  
> +		/* bid is unregister NULL, all bdi memory is illegal */
> +		if (bwce.bdi_unregister) {
> +			ret = -EIO;
> +			break;
> +		}
>  		current->dirty_paused_when = now + pause;
>  		current->nr_dirtied = 0;
>  		current->nr_dirtied_pause = nr_dirtied_pause;
> @@ -1844,11 +1880,14 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  			break;
>  	}
>  
> +	if (bwce.bdi_unregister == 0)
> +		remove_wait_queue(&(bdi->wb_waitq), &(bwce.wq_entry));
> +	
>  	if (!dirty_exceeded && wb->dirty_exceeded)
>  		wb->dirty_exceeded = 0;
>  
>  	if (writeback_in_progress(wb))
> -		return;
> +		return ret;
>  
>  	/*
>  	 * In laptop mode, we wait until hitting the higher threshold before
> @@ -1859,10 +1898,12 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  	 * background_thresh, to keep the amount of dirty memory low.
>  	 */
>  	if (laptop_mode)
> -		return;
> +		return ret;
>  
>  	if (nr_reclaimable > gdtc->bg_thresh)
>  		wb_start_background_writeback(wb);
> +
> +	return ret;
>  }
>  
>  static DEFINE_PER_CPU(int, bdp_ratelimits);
> @@ -1944,9 +1985,12 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
>  	}
>  	preempt_enable();
>  
> -	if (unlikely(current->nr_dirtied >= ratelimit))
> -		balance_dirty_pages(wb, current->nr_dirtied);
> -
> +	if (unlikely(current->nr_dirtied >= ratelimit)) {
> +	
> +		if (balance_dirty_pages(wb, current->nr_dirtied) < 0)
> +			errseq_set(&(mapping->wb_err), -EIO);
> +	}
> +	
>  	wb_put(wb);
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
> -- 
> 2.43.0
> 
> 
