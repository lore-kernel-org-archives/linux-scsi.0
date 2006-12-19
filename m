From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Tue, 19 Dec 2006 15:02:59 +0100
Message-ID: <20061219140258.GR5010@kernel.dk>
References: <20061216001753F.fujita.tomonori@lab.ntt.co.jp> <20061215185704.GZ5010@kernel.dk> <200612191355.kBJDtIWk000664@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:24385 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbWLSOBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 09:01:16 -0500
Content-Disposition: inline
In-Reply-To: <200612191355.kBJDtIWk000664@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Tue, Dec 19 2006, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH 0/3] SG v4 support
> Date: Fri, 15 Dec 2006 19:57:05 +0100
> 
> > On Sat, Dec 16 2006, FUJITA Tomonori wrote:
> > > The following patches add SG v4 support to bsg. They are over Jens'
> > > bsg branch.
> > > 
> > > I just replaced bsg's SG v3 support with SG v4 and haven't added
> > > anything new yet. So it can only handle SCSI commands.
> > 
> > Good start! Just one comment before I look over this and merge it - I'd
> > prefer keeping this out of sg.c. One of the problems we have right now
> > are dual pieces of code for sg v3, and I think it would be silly to
> > continue down this path. Lets keep sg.c as a legacy sg v3 interface
> > (it'll be the only one except SG_IO in the block layer), and let bsg
> > take sg v4 and forward.
> 
> Yeah, that's what I want to do.
> 
> 
> > There's really zero gain in having it in two places.
> > 
> > IOW, put the sg v4 structure in bsg.h.
> 
> That's fine by me. I put the sg v4 structure in sg.h simply I thought
> bsg.h is for kernel space and some user-space programs need to include
> sg.h for some old ioctl stuff even if they use only sg v4.

Ah ok, bsg.h is just a generic header, there's no reason it cannot
contain user-mapped bits as well.

> > > I've uploaded simple programs to just read/write by using SG v4:
> > > 
> > > http://www.kernel.org/pub/linux/kernel/people/tomo/sg4/
> > 
> > Great!
> > 
> > I'll get this reviewed and merged as soon as I can, probably monday.
> 
> Thanks. The patchset is on the top of the two minor patches:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265732083&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265731963&w=2
> 
> The latter needs small modifications if you will change
> blk_rq_unmap_user interface.

I'll rebase the bsg tree as soon as Linus pulls the for-linus branch,
which has a number of SG_IO related changes and fixes. Ah I'll just
rebase bsg now and send you a note, then please resend the pending
patches against that and I'll include it.

-- 
Jens Axboe

