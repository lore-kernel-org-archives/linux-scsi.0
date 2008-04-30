From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Issue with qla2xxx_probe_one
Date: Tue, 29 Apr 2008 19:39:54 -0500
Message-ID: <1209515994.4448.25.camel@localhost.localdomain>
References: <48175C3F.3000002@hp.com>
	 <20080429174447.GL67096@plap4.qlogic.org>  <48178143.2000308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33230 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbYD3D0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 23:26:52 -0400
In-Reply-To: <48178143.2000308@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Tue, 2008-04-29 at 16:12 -0400, Alan D. Brunelle wrote:
> Andrew Vasquez wrote:
> > On Tue, 29 Apr 2008, Alan D. Brunelle wrote:
> >
> >> I /think/ that there is an issue with this routine /if/ the firmware
> >> images are not loaded properly - on a 16-way ia64 box I am starting to
> >> see this with an up-stream kernel (Jens Axboe's origin/io-cpu-affinity
> >> branch). In any event, it looks to me that :
> >>
> >>         if (qla2x00_initialize_adapter(ha)) {
> >>                 qla_printk(KERN_WARNING, ha,
> >>                     "Failed to initialize adapter\n");
> >>
> >>                 DEBUG2(printk("scsi(%ld): Failed to initialize
> adapter - "
> >>                     "Adapter flags %x.\n",
> >>                     ha->host_no, ha->device_flags));
> >>
> >>                 ret = -ENODEV;
> >>                 goto probe_failed;
> >>         }
> >>
> >> skips around:
> >>
> >>         ret = scsi_add_host(host, &pdev->dev);
> >>
> >> which is needed to properly initialize the freelist (via:
> >> scsi_setup_command_freelist).
> >
> > Wasn't something like this posted recently to linux-scsi:
> >
> > http://lkml.org/lkml/2008/4/27/333
> >
> > this is sitting in scsi-misc-2.6.git:
> >
> > [SCSI] bug fix for free list handling
> >
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a79cbe1aa5dd695f0ee012ecde1ff88b1192e326
> >
> > which I gather will be pushed soon...
> 
> My apologies for not having seeing that.
> 
> But after looking at it, doesn't it still have a hole?
> 
> o  scsi_setup_command_freelist initializes the free_list list.
> 
> o  It then invokes scsi_get_host_cmd_pool, if this fails there is no
> need to invoke scsi_put_host_cmd_pool (it wasn't gotten).
> 
> o  If scsi_get_host_cmd_pool succeeds but scsi_pool_alloc_command fails,
> it will (correctly) invoke scsi_put_host_cmd_pool.
> 
> However, if either of scsi_get_host_cmd_pool or scsi_put_host_cmd_pool
> happens to fail, we'll end up in scsi_destroy_command_freelist - and
> since the free_list was initialized, the while loop will be bypassed,
> but scsi_put_host_cmd_pool will be invoked an extra time. And this is
> badness, right?
> 
> Wouldn't the attached patch [boot tested on my previously failing
> system] be correct (and perhaps cleaner - you're not looking at the
> innards of the list data structure to determine things)?

Yes, that looks like a better fix.  I tidied up your change log, because
it's helpful to identify the original problem commit, but otherwise
applied it unchanged.

Thanks,

James


