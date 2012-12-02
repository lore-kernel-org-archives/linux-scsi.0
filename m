From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 11/13] Make scsi_remove_host() wait until error
 handling finished
Date: Sun, 2 Dec 2012 05:51:30 -0800
Message-ID: <20121202135130.GL15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60923.3080207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59507 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2LBNvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:51:36 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1332794pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:51:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60923.3080207@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Wed, Nov 28, 2012 at 01:52:51PM +0100, Bart Van Assche wrote:
> A SCSI LLD may start cleaning up host resources as soon as
> scsi_remove_host() returns. These host resources may be needed by
> the LLD in an implementation of one of the eh_* functions. So if
> one of the eh_* functions is in progress when scsi_remove_host()
> is invoked, wait until the eh_* function has finished. Also, do
> not invoke any of the eh_* functions after scsi_remove_host() has
> started.

Nice catch.

>  /**
> + * scsi_begin_eh - start host-related error handling
> + *
> + * Must be called before invoking any of the scsi_host_template.eh_* functions
> + * to avoid that scsi_remove_host() returns while one of these callback
> + * functions is in progress.
> + *
> + * Returns true if invoking the eh_* function is allowed and false if not.
> + * If this function returns true then scsi_end_eh() must be called eventually.
> + *
> + * Note: scsi_send_eh_cmnd() calls do not have to be protected by a
> + * scsi_begin_eh() / scsi_end_eh() pair since these operate on an unfinished
> + * block layer request. Since scsi_remove_host() waits until all SCSI devices
> + * have been removed and since blk_cleanup_queue() is invoked during SCSI
> + * device removal scsi_remove_host() won't finish while a scsi_send_eh_cmnd()
> + * call is in progress.
> + */
> +static bool scsi_begin_eh(struct Scsi_Host *host)
> +{
> +	bool res;
> +
> +	spin_lock_irq(host->host_lock);
> +	res = scsi_host_scan_allowed(host);
> +	if (res) {
> +		WARN_ON_ONCE(host->eh_active < 0 || host->eh_active > 1);
> +		host->eh_active++;
> +	}
> +	spin_unlock_irq(host->host_lock);
> +
> +	return res;
> +}

No biggie but I find it somewhat unusual to use bool success/failure
return for a function named scsi_begin_eh().  0/-errno would be more
conventional.  People do use bool return for get/acquite type
operations but it's a bit unusual to do that for begin().  Plus, the
code would actually be simpler with -errno failure, right?

	if (scsi_begin_eh(host))
		return FAST_IO_FAIL;

	/* no change */

	scsi_end_eh(host);
	return rtn;

Thanks.

-- 
tejun
