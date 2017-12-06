From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Wed, 6 Dec 2017 09:16:43 +0800
Message-ID: <20171206011641.GA26512@ming.t460p>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
 <20171205003809.1705-2-bart.vanassche@wdc.com>
 <20171205011536.GC8365@ming.t460p>
 <1512439190.2739.0.camel@wdc.com>
 <20171205050008.GA9989@ming.t460p>
 <1512490952.2660.18.camel@wdc.com>
 <20171205163824.GB23788@ming.t460p>
 <1512492229.3019.25.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753308AbdLFBQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Dec 2017 20:16:58 -0500
Content-Disposition: inline
In-Reply-To: <1512492229.3019.25.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Tue, Dec 05, 2017 at 08:43:49AM -0800, James Bottomley wrote:
> On Wed, 2017-12-06 at 00:38 +0800, Ming Lei wrote:
> > On Tue, Dec 05, 2017 at 04:22:33PM +0000, Bart Van Assche wrote:
> > > 
> > > On Tue, 2017-12-05 at 13:00 +0800, Ming Lei wrote:
> > > > 
> > > > No, do not mix two different things in one patch, especially the
> > > > fix part need to be backported to stable.
> > > > 
> > > > The fix part should aim at V4.15, and the other part can be a
> > > > V4.16 stuff.
> > > 
> > > Does this mean that you do not plan to post a v5 of your patch and
> > > that you want me to rework this patch series? I can do that.
> > 
> > I believe V4 has been OK for merge, actually the only concern from
> > James is that 'set the cmnd to NULL *before* calling free so we
> > narrow the race window.', but that isn't required as I explained,
> > even though you don't do that in this patch too.
> > 
> > 	https://marc.info/?t=151030464300003&r=1&w=2
> > 
> > I will work on V5 if Martin/James thinks it is needed.
> 
> I don't buy that it isn't needed.  The point (and the pattern) is for a
> destructive action set the signal *before* you execute the action not
> after.  The reason should be obvious: if you set it after you invite a
> race where the check says OK but the object has gone.  Even if the race

Even you do that, the race is still highly likely there:

1) mempool_free() can be much quicker than scsi_show_rq() because it is
a local free, and scsi_show_rq() can be run from remote CPU wrt. the
allocated 'cmd->cmnd', and access to remote NUMA node should be slower
than mempool_free(), so use-after-free is triggered.

2) any preemption or local IRQ in scsi_show_rq() can make it touch
a freed buffer, and sd_uninit_command() is run from irq context.

3) no any barrier is applied, so the actual write can be reordered
in sd_uninit_command()

So setting the cmd->cmnd as NULL before mempool_free() can't avoid
the use-after-free, scsi_show_rq() has to survive that, then
do we really need to add the unnecessary change in sd_uninit_command()?

Not mention the change will make the debug info disappear too early, is
that what we need?

> is highly unlikely, the pattern point still holds.


-- 
Ming
