From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v8 03/10] md: Neither resync nor reshape while the system
 is frozen
Date: Thu, 12 Oct 2017 10:45:14 -0700
Message-ID: <20171012174514.s743dnhevbmhgn2w@kernel.org>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
 <20171010210346.14574-4-bart.vanassche@wdc.com>
 <20171010223025.tda3lx64rdmugm54@kernel.org>
 <1507678384.2815.80.camel@wdc.com>
 <20171011014830.ps3v3yxny27wv7mc@kernel.org>
 <1507742275.2477.20.camel@wdc.com>
 <20171011193221.hkwvcysv6hahsncd@kernel.org>
 <1507827540.2448.29.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751067AbdJLRpR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 13:45:17 -0400
Content-Disposition: inline
In-Reply-To: <1507827540.2448.29.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>

On Thu, Oct 12, 2017 at 04:59:01PM +0000, Bart Van Assche wrote:
> On Wed, 2017-10-11 at 12:32 -0700, Shaohua Li wrote:
> > On Wed, Oct 11, 2017 at 05:17:56PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-10-10 at 18:48 -0700, Shaohua Li wrote:
> > > > The problem is __md_stop_writes set some bit like MD_RECOVERY_FROZEN, which
> > > > will prevent md_check_recovery restarting resync/reshape. I think we need
> > > > preserve mddev->recovery in suspend prepare and restore after resume
> > > 
> > > Hello Shaohua,
> > > 
> > > As far as I can see __md_stop_writes() sets MD_RECOVERY_FROZEN and can set
> > > MD_RECOVERY_INTR. Since md_check_recovery() clears MD_RECOVERY_INTR I think
> > > it should be sufficient to save and restore the state of the
> > > MD_RECOVERY_FROZEN flag. However, when I ran the following test:
> > > * echo frozen > /sys/block/md0/md/sync_action
> > > * cat /sys/block/md0/md/sync_action
> > > * systemctl hibernate
> > > * (power on system again)
> > > * cat /sys/block/md0/md/sync_action
> > > 
> > > the output that appeared was as follows:
> > > 
> > > frozen
> > > idle 
> > > Does that mean that a hibernate or suspend followed by a resume is sufficient
> > > to clear the MD_RECOVERY_FROZEN flag for the md drivers and hence that the
> > > patch at the start of this e-mail thread does not need any further
> > > modifications?
> > 
> > Have no idea why it shows 'idle'. From my understanding, after resume, previous
> > memory is stored and MD_RECOVERY_FROZEN bit should be set. Was trying to
> > understand what happens.
> 
> Hello Shaohua,
> 
> I think a user space action causes the MD_RECOVERY_FROZEN bit to be cleared.
> After I had added a few debug statements in the md driver this is what I
> found in the system log:
> 
> Oct 12 09:38:39 kernel: action_store: storing action check
> Oct 12 09:38:39 kernel: md: data-check of RAID array md0
> Oct 12 09:38:40 systemd[1]: Starting Hibernate...
> Oct 12 09:38:40 kernel: md: md0: data-check interrupted.
> [ powered on system manually ]
> Oct 12 09:39:05 kernel: action_store: storing action check
> Oct 12 09:39:05 kernel: md: data-check of RAID array md0
> Oct 12 09:39:11 kernel: action_store: storing action idle
> Oct 12 09:39:11 kernel: md: md0: data-check interrupted.
> 
> Anyway, how about the patch below? I have verified by adding a debug pr_info()
> statement that the newly added code really clears the MD_RECOVERY_FROZEN bit.

Ok, for patch 1-3:
Reviewed-by: Shaohua Li <shli@kernel.org>

> Subject: [PATCH] md: Neither resync nor reshape while the system is frozen
> 
> Some people use the md driver on laptops and use the suspend and
> resume functionality. Since it is essential that submitting of
> new I/O requests stops before a hibernation image is created,
> interrupt the md resync and reshape actions if the system is
> being frozen. Note: the resync and reshape will restart after
> the system is resumed and a message similar to the following
> will appear in the system log:
> 
> md: md0: data-check interrupted.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/md/md.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/md.h |  8 ++++++++
>  2 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b99584e5d6b1..8b2fc750f97f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -66,6 +66,8 @@
>  #include <linux/raid/md_u.h>
>  #include <linux/slab.h>
>  #include <linux/percpu-refcount.h>
> +#include <linux/freezer.h>
> +#include <linux/suspend.h>
>  
>  #include <trace/events/block.h>
>  #include "md.h"
> @@ -7439,6 +7441,7 @@ static int md_thread(void *arg)
>  	 */
>  
>  	allow_signal(SIGKILL);
> +	set_freezable();
>  	while (!kthread_should_stop()) {
>  
>  		/* We need to wait INTERRUPTIBLE so that
> @@ -7449,7 +7452,7 @@ static int md_thread(void *arg)
>  		if (signal_pending(current))
>  			flush_signals(current);
>  
> -		wait_event_interruptible_timeout
> +		wait_event_freezable_timeout
>  			(thread->wqueue,
>  			 test_bit(THREAD_WAKEUP, &thread->flags)
>  			 || kthread_should_stop() || kthread_should_park(),
> @@ -8944,6 +8947,8 @@ static void md_stop_all_writes(void)
>  	int need_delay = 0;
>  
>  	for_each_mddev(mddev, tmp) {
> +		mddev->frozen_before_suspend =
> +			test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>  		if (mddev_trylock(mddev)) {
>  			if (mddev->pers)
>  				__md_stop_writes(mddev);
> @@ -8963,6 +8968,47 @@ static void md_stop_all_writes(void)
>  		mdelay(1000*1);
>  }
>  
> +static void md_restore_frozen_flag(void)
> +{
> +	struct list_head *tmp;
> +	struct mddev *mddev;
> +
> +	for_each_mddev(mddev, tmp) {
> +		if (mddev->frozen_before_suspend)
> +			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +		else
> +			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	}
> +}
> +
> +/*
> + * Ensure that neither resyncing nor reshaping occurs while the system is
> + * frozen.
> + */
> +static int md_notify_pm(struct notifier_block *bl, unsigned long state,
> +			void *unused)
> +{
> +	pr_debug("%s: state = %ld\n", __func__, state);
> +
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		md_stop_all_writes();
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +	case PM_POST_RESTORE:
> +		md_restore_frozen_flag();
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block md_pm_notifier = {
> +	.notifier_call	= md_notify_pm,
> +};
> +
>  static int md_notify_reboot(struct notifier_block *this,
>  			    unsigned long code, void *x)
>  {
> @@ -9009,6 +9055,7 @@ static int __init md_init(void)
>  			    md_probe, NULL, NULL);
>  
>  	register_reboot_notifier(&md_reboot_notifier);
> +	register_pm_notifier(&md_pm_notifier);
>  	raid_table_header = register_sysctl_table(raid_root_table);
>  
>  	md_geninit();
> @@ -9248,6 +9295,7 @@ static __exit void md_exit(void)
>  
>  	unregister_blkdev(MD_MAJOR,"md");
>  	unregister_blkdev(mdp_major, "mdp");
> +	unregister_pm_notifier(&md_pm_notifier);
>  	unregister_reboot_notifier(&md_reboot_notifier);
>  	unregister_sysctl_table(raid_table_header);
>  
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d8287d3cd1bf..727b3aef4d26 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -356,6 +356,14 @@ struct mddev {
>  	 */
>  	int				recovery_disabled;
>  
> +	/* Writes are stopped before hibernation, suspend and restore by
> +	 * calling md_stop_all_writes(). That function sets the
> +	 * MD_RECOVERY_FROZEN flag. The value of that flag is saved before
> +	 * writes are stopped such that it can be restored after hibernation,
> +	 * suspend or restore have finished.
> +	 */
> +	bool				frozen_before_suspend;
> +
>  	int				in_sync;	/* know to not need resync */
>  	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
>  	 * that we are never stopping an array while it is open.
