From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Wed, 18 Jun 2008 07:49:53 +0900
Message-ID: <20080618075435S.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com>
	<20080618051447L.fujita.tomonori@lab.ntt.co.jp>
	<48583074.8010909@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41653 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbYFQWuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 18:50:21 -0400
In-Reply-To: <48583074.8010909@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pjones@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dgilbert@interlog.com

On Tue, 17 Jun 2008 17:45:24 -0400
Peter Jones <pjones@redhat.com> wrote:

> FUJITA Tomonori wrote:
> 
> > Well, this changes sg behaviour since sg's allow_ops filter has a
> > access permission different from blk_verify_command filter's.
>  >
> > I guess that the first thing you need to do is that figuring out a
> > proper access permission for each command, which sg maintainer, etc
> > can agree. It's pretty hard and that's the reason why this patch has
> > not been merged for years, I think.
> 
> I don't think this logic is sound.
> 
> The patch makes it so distros (and individuals, if they're so inclined) 
> can configure the filter correctly for whatever hardware is present, 
> regardless of the kernel's ideas of which commands are correct.  It 
> leaves intact the defaults from the current list used by SG_IO and bsg 
> (and maybe some other interfaces?), which most programs have been using 
> for quite some time.
> 
> If anything, sg is overdue with converting to using the same command 
> filter as other direct-scsi-command mechanisms.  sg_allow_access() is 
> really not something we should be keeping.

Seems that there is some confusion in the interfaces.

We have theree interfaces; scsi_ioctl, bsg, and sg, which let us to
execute SCSI commands from the userland.

All the interfaces support SG_IO (and they also support their own
method). But only scsi_ioctl and bsg use blk_verify_command and sg has
the own permission table.
