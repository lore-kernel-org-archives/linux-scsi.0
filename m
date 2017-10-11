From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v8 03/10] md: Neither resync nor reshape while the system
 is frozen
Date: Wed, 11 Oct 2017 12:32:21 -0700
Message-ID: <20171011193221.hkwvcysv6hahsncd@kernel.org>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
 <20171010210346.14574-4-bart.vanassche@wdc.com>
 <20171010223025.tda3lx64rdmugm54@kernel.org>
 <1507678384.2815.80.camel@wdc.com>
 <20171011014830.ps3v3yxny27wv7mc@kernel.org>
 <1507742275.2477.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507742275.2477.20.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 11, 2017 at 05:17:56PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 18:48 -0700, Shaohua Li wrote:
> > The problem is __md_stop_writes set some bit like MD_RECOVERY_FROZEN, which
> > will prevent md_check_recovery restarting resync/reshape. I think we need
> > preserve mddev->recovery in suspend prepare and restore after resume
> 
> Hello Shaohua,
> 
> As far as I can see __md_stop_writes() sets MD_RECOVERY_FROZEN and can set
> MD_RECOVERY_INTR. Since md_check_recovery() clears MD_RECOVERY_INTR I think
> it should be sufficient to save and restore the state of the
> MD_RECOVERY_FROZEN flag. However, when I ran the following test:
> * echo frozen > /sys/block/md0/md/sync_action
> * cat /sys/block/md0/md/sync_action
> * systemctl hibernate
> * (power on system again)
> * cat /sys/block/md0/md/sync_action
> 
> the output that appeared was as follows:
> 
> frozen
> idle 
> Does that mean that a hibernate or suspend followed by a resume is sufficient
> to clear the MD_RECOVERY_FROZEN flag for the md drivers and hence that the
> patch at the start of this e-mail thread does not need any further
> modifications?

Have no idea why it shows 'idle'. From my understanding, after resume, previous
memory is stored and MD_RECOVERY_FROZEN bit should be set. Was trying to
understand what happens.

Thanks,
Shaohua
