From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Thu, 1 Dec 2005 20:21:57 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.veritas.com ([143.127.12.110]:33311 "EHLO gold.veritas.com")
	by vger.kernel.org with ESMTP id S932438AbVLAUWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 15:22:23 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (3309 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EhuwB-0001EnC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 12:21:51 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051201195657.GB7236@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 1 Dec 2005, Ryan Richter wrote:
> On Thu, Dec 01, 2005 at 11:38:20AM -0800, Linus Torvalds wrote:
> > > >
> > > >  Bad page state at free_hot_cold_page (in process 'taper', page ffff81000260b6f8)
> > > > flags:0x010000000000000c mapping:ffff8100355f1dd8 mapcount:2 count:0
> > > > Backtrace:
> > 
> > Ryan, can you test 2.6.15-rc4 and report what it does?
> > 
> > The "Bad page state" messages may (should) remain, but the crashes should 
> > be gone and the machine should hopefully continue functioning fine. And, 
> > perhaps more importantly, you should hopefully have a _new_ message about 
> > incomplete pfn mappings that should help pinpoint which driver causes 
> > this..

But we already know which driver does this: drivers/scsi/st.c.

> Will do, I plan to take this machine down Saturday to run memtest86 for
> a while (just to be sure - 2/3 of the RAM is new, but I should be seeing
> machine checks if that were the problem, no?) so I'll boot this after that.

Nick and I had already been looking at drivers/scsi/{sg.c,st.c},
brought there by __put_page in sg.c's peculiar sg_rb_correct4mmap,
which we'd like to remove.  But that's irrelevant to your pain, except...

One extract from the patches I'd like to send Doug and Kai for 2.6.15
or 2.6.16 is this below: since the incomplete get_user_pages path omits
to reset res, but has already released all the pages, it will result in
premature freeing of user pages, and behaviour just like you've seen.

Though I'd have thought incomplete get_user_pages was an exceptional
case, and a bit surprised you'd encounter it.  Perhaps there's some
other premature freeing in the driver, and this instance has nothing
whatever to do with it.

If the problem were easily reproducible, it'd be great if you could
try this patch; but I think you've said it's not :-(

Hugh

--- 2.6.14/drivers/scsi/st.c	2005-10-28 01:02:08.000000000 +0100
+++ linux/drivers/scsi/st.c	2005-12-01 20:06:02.000000000 +0000
@@ -4511,6 +4511,7 @@ static int sgl_map_user_pages(struct sca
 	if (res > 0) {
 		for (j=0; j < res; j++)
 			page_cache_release(pages[j]);
+		res = 0;
 	}
 	kfree(pages);
 	return res;
