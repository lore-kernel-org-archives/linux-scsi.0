From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Sun, 2 Dec 2012 05:45:15 -0800
Message-ID: <20121202134515.GJ15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B608C1.6080803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32929 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNpV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:45:21 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1331254pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:45:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B608C1.6080803@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Wed, Nov 28, 2012 at 01:51:13PM +0100, Bart Van Assche wrote:
> SCSI LLDs may start cleaning up host resources needed by their
> queuecommand() callback as soon as scsi_remove_host() finished.
> Hence scsi_remove_host() must wait until blk_cleanup_queue() for
> all devices associated with the host has finished. That avoids
> that queuecommand() gets invoked after scsi_remove_host()
> finished. Also, avoid adding new SCSI devices after
> scsi_remove_host() started.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/hosts.c      |   30 ++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_priv.h  |    1 +
>  drivers/scsi/scsi_sysfs.c |    1 +
>  include/scsi/scsi_host.h  |    1 +
>  4 files changed, 33 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6ae16cd..7bd944e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -150,12 +150,31 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
>  }
>  EXPORT_SYMBOL(scsi_host_set_state);
>  
> +/* Return true if and only if scsi_remove_host() is allowed to finish. */
> +static bool __scsi_remove_host_done(struct Scsi_Host *shost)
> +{
> +	lockdep_assert_held(shost->host_lock);
> +
> +	return list_empty(&shost->__devices);
> +}

This is a preference thing but I usually find this type of trivial
wrappers more obfuscating than actually helpful.  Dunno what James's
preference is tho.

> +/* Test whether scsi_remove_host() may finish, and if so, wake it up. */
> +void __scsi_check_remove_host_done(struct Scsi_Host *shost)
> +{
> +	lockdep_assert_held(shost->host_lock);
> +
> +	if (__scsi_remove_host_done(shost))
> +		wake_up(&shost->remove_host);
> +}

Why the __ prefix?  It's not like they have different
external/internal versions.

This being an one-time thing.  Using completion could be simpler.  e.g.

scsi_check_no_device_left()
{
	if (list_empty(__devices))
		complete(host->no_device_left);
}

scsi_remove_host()
{
	blah blah;
	scsi_check_remove_host_done();
	wait_for_completion(&host->no_device_left);
	blah blah;
}

Thanks.

-- 
tejun
