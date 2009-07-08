From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Thu, 9 Jul 2009 08:49:34 +0900
Message-ID: <20090709084839G.fujita.tomonori@lab.ntt.co.jp>
References: <1247069178.5973.6.camel@desktop>
	<1247071445.4159.214.camel@mulgrave.site>
	<20090708165728.GU23611@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60525 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZGHXuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 19:50:21 -0400
In-Reply-To: <20090708165728.GU23611@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: James.Bottomley@HansenPartnership.com, dwalker@fifo99.com, maciej.rutecki@gmail.com, akpm@linux-foundation.org, tarkan.erimer@turknet.net.tr, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 8 Jul 2009 18:57:28 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Jul 08 2009, James Bottomley wrote:
> > On Wed, 2009-07-08 at 09:06 -0700, Daniel Walker wrote:
> > > On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
> > > > 
> > > > You might also try this patch from martin petersen:  it will print out
> > > > the actual command that's causing the problems ... that might give a
> > > > clue.
> > > > 
> > > > James
> > > 
> > > On the bugzilla entry ,
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13727
> > > 
> > > Thomas Meyer indicated it was (possibly) the following commit,
> > > 
> > > 018e0446890661504783f92388ecce7138c1566d
> > > 
> > > I added Jens to the CC ..
> > 
> > So thats:
> > 
> > commit 018e0446890661504783f92388ecce7138c1566d
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Fri Jun 26 16:27:10 2009 +0200
> > 
> >     block: get rid of queue-private command filter
> > 
> > What this tends to suggest is that the command filter was blocking some
> > type of command sent from user space which is causing the problem, and
> > now we're letting it through.  Restoring the command filter will work
> > around the problem, but the root cause should be finding and fixing
> > whatever is issuing the commands in the first place.
> 
> There should be no functional change, since the filters were all the
> same. Perhaps blk_scsi_ioctl_init() isn't being run, a good start would
> be to stick a printk() in there and verify that it's actually being
> executed. I've been tricked by __init before.

I can't find where you call blk_scsi_ioctl_init(). I've attached a fix
(not tested).

Jens, I'm not sure that I saw the above patch on any mailing list. If
you merged the patch without sending any mailing list, please don't do
that.


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: call blk_scsi_ioctl_init()

Currently, blk_scsi_ioctl_init() is not called so
blk_default_cmd_filter isn't initalized. Some commands are not blocked
wrongly.

This fixes a regression introduced:

commit 018e0446890661504783f92388ecce7138c1566d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 26 16:27:10 2009 +0200

    block: get rid of queue-private command filter

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f0e0ce0..e5b1001 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -680,3 +680,4 @@ int __init blk_scsi_ioctl_init(void)
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
 	return 0;
 }
+fs_initcall(blk_scsi_ioctl_init);
-- 
1.6.0.6

