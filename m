From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v8 03/10] md: Neither resync nor reshape while the system
 is frozen
Date: Tue, 10 Oct 2017 18:48:30 -0700
Message-ID: <20171011014830.ps3v3yxny27wv7mc@kernel.org>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
 <20171010210346.14574-4-bart.vanassche@wdc.com>
 <20171010223025.tda3lx64rdmugm54@kernel.org>
 <1507678384.2815.80.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507678384.2815.80.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2017 at 11:33:06PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 15:30 -0700, Shaohua Li wrote:
> > On Tue, Oct 10, 2017 at 02:03:39PM -0700, Bart Van Assche wrote:
> > > Some people use the md driver on laptops and use the suspend and
> > > resume functionality. Since it is essential that submitting of
> > > new I/O requests stops before a hibernation image is created,
> > > interrupt the md resync and reshape actions if the system is
> > > being frozen. Note: the resync and reshape will restart after
> > > the system is resumed and a message similar to the following
> > > will appear in the system log:
> > > 
> > > md: md0: data-check interrupted.
> > 
> > Where do we restart resync and reshape?
> 
> Hello Shaohua,
> 
> My understanding of the md driver is as follows:
> - Before any write occurs, md_write_start() is called. That function clears
>   mddev->safemode and checks mddev->in_sync. If that variable is set, it is
>   cleared and md_write_start() wakes up mddev->thread and waits until the
>   superblock has been written to disk.
> - All mddev->thread implementations call md_check_recovery(). That function
>   updates the superblock by calling md_update_sb() if needed.
>   md_check_recovery() also starts a resync thread if the array is not in
>   sync. See also the comment block above md_check_recovery().
> - md_do_sync() performs the resync. If it completes successfully the
>   "in_sync" state is set (set_in_sync()). If it is interrupted the "in_sync"
>   state is not modified.
> - super_90_sync() sets the MD_SB_CLEAN flag in the on-disk superblock if the
>   "in_sync" flag is set.
> 
> In other words: if the array is in sync the MD_SB_CLEAN flag is set in the
> on-disk superblock. If a resync is needed that flag is not set. The
> MD_SB_CLEAN flag is checked when the superblock is loaded. If that flag is
> not set a resync is started.

The problem is __md_stop_writes set some bit like MD_RECOVERY_FROZEN, which
will prevent md_check_recovery restarting resync/reshape. I think we need
preserve mddev->recovery in suspend prepare and restore after resume

Thanks,
Shaohua
