From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Issue with qla2xxx_probe_one
Date: Wed, 30 Apr 2008 07:57:04 +0900
Message-ID: <20080430075704M.fujita.tomonori@lab.ntt.co.jp>
References: <48175C3F.3000002@hp.com>
	<20080429174447.GL67096@plap4.qlogic.org>
	<48178143.2000308@hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35423 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYD2XFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 19:05:11 -0400
In-Reply-To: <48178143.2000308@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan.Brunelle@hp.com
Cc: andrew.vasquez@qlogic.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Tue, 29 Apr 2008 16:12:51 -0400
"Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:

> This is a multi-part message in MIME format.
> --------------050404010600090601000605
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: 7bit
> 
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

scsi_put_host_cmd_pool doesn't fail but I think that you are right. If
scsi_get_host_cmd_pool or scsi_pool_alloc_command in
scsi_setup_command_freelist fails, we hit the problem.


> Wouldn't the attached patch [boot tested on my previously failing
> system] be correct (and perhaps cleaner - you're not looking at the
> innards of the list data structure to determine things)?

Looks correct to me.
