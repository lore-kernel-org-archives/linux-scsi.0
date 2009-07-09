From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Thu, 9 Jul 2009 17:08:51 +0900
Message-ID: <20090709170727S.fujita.tomonori@lab.ntt.co.jp>
References: <20090708165728.GU23611@kernel.dk>
	<20090709084839G.fujita.tomonori@lab.ntt.co.jp>
	<20090709075004.GH23611@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51473 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZGIIJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 04:09:32 -0400
In-Reply-To: <20090709075004.GH23611@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, dwalker@fifo99.com, maciej.rutecki@gmail.com, akpm@linux-foundation.org, tarkan.erimer@turknet.net.tr, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 9 Jul 2009 09:50:04 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jul 09 2009, FUJITA Tomonori wrote:
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] block: call blk_scsi_ioctl_init()
> > 
> > Currently, blk_scsi_ioctl_init() is not called so
> > blk_default_cmd_filter isn't initalized. Some commands are not blocked
> > wrongly.
> > 
> > This fixes a regression introduced:
> > 
> > commit 018e0446890661504783f92388ecce7138c1566d
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Fri Jun 26 16:27:10 2009 +0200
> > 
> >     block: get rid of queue-private command filter
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/scsi_ioctl.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> > index f0e0ce0..e5b1001 100644
> > --- a/block/scsi_ioctl.c
> > +++ b/block/scsi_ioctl.c
> > @@ -680,3 +680,4 @@ int __init blk_scsi_ioctl_init(void)
> >  	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
> >  	return 0;
> >  }
> > +fs_initcall(blk_scsi_ioctl_init);
> > -- 
> > 1.6.0.6
> 
> You beat me to it, it was the missing call as I suspected. This
> works, I verified it myself. Applied to for-linus, going upstream
> soon.

I really hope that you become more serious about not causing such
incident; breaking mainline kernel by merging your trivial patch after
-rc1 (even without sending the patch to any mailing list). You broke
mainline in the exact same way just months ago (the commit
1e42807918d17e8c93bf14fbb74be84b141334c1 in 2.6.29-rc7).


Thanks,
