From: Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Dec 21
Date: Fri, 23 Dec 2011 21:13:34 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au> <20111221151503.4d78f94f.akpm@linux-foundation.org> <20111222150836.af172886.akpm@linux-foundation.org> <20111222232036.GP17084@google.com> <20111222152427.c944c747.akpm@linux-foundation.org>
 <20111222233843.GR17084@google.com> <20111222154427.89b245c7.akpm@linux-foundation.org> <20111222234639.GS17084@google.com> <20111223004244.GU17084@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1LXFNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Dec 2011 00:13:46 -0500
Received: by iaeh11 with SMTP id h11so16087745iae.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2011 21:13:46 -0800 (PST)
In-Reply-To: <20111223004244.GU17084@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org, x86@kernel.org

On Thu, 22 Dec 2011, Tejun Heo wrote:
> On Thu, Dec 22, 2011 at 03:46:39PM -0800, Tejun Heo wrote:
> > On Thu, Dec 22, 2011 at 03:44:27PM -0800, Andrew Morton wrote:
> > > > Weird, I can't reproduce the problem on block/for-3.3/core.  Trying
> > > > linux-next... hmmm, it works there too.
> > > 
> > > This machine is next to my desk, about 50 yards from your cube ;)
> > 
> > Heh, physical access feels like such distant concept.  :)
> > 
> > I'll test with the config and if I still can't reproduce it, play with
> > your machine.
> 
> Couldn't reproduce it on block/for-3.3 or next & you were already
> gone.  Is anyone else seeing this?

Twice today, on ThinkPad T420s running 3.2.0-rc6-next-20111222.
I haven't seen it at all under heavy load, but twice when simply
rebuilding the kernel - I think both times it hung with
"LD whatever/built-in.o" the last line on screen.

I had (a variant of) kdb in, here's the stack it gave me, but I think
I've got a bug in there which has missed out a number of stackframes:
so don't waste time puzzling over any anomalies in it, but there's
enough to suggest it's the same as Andrew was seeing.

ffff880013ac2100    28524    28522   1*  D  ffff880013ac2538  sh
RSP              RIP              Function (args)
ffff88004165f820 ffffffff814e559a _raw_spin_unlock_irq+0x31
ffff88004165f858 ffffffff811d2867 get_request_wait+0xab
ffff88004165f8b8 ffffffff811cfb75 elv_merge+0xa0
ffff88004165fd18 ffffffff810ca90c do_writepages+0x1f
ffff88004165fd28 ffffffff810c2671 __filemap_fdatawrite_range+0x4e
ffff88004165fd68 ffffffff810c2e92 filemap_flush+0x17
ffff88004165fd78 ffffffff8116533e ext4_alloc_da_blocks+0x28
ffff88004165fd88 ffffffff81160f6a ext4_release_file+0x2e
ffff88004165fdb8 ffffffff811077d4 __fput+0x107
ffff88004165fe08 ffffffff81107899 fput+0x15
ffff88004165fe18 ffffffff81104037 filp_close+0x6b
ffff88004165fe48 ffffffff81056b47 close_files+0x16a
ffff88004165fea8 ffffffff81057f31 put_files_struct+0x21
ffff88004165fed8 ffffffff81058107 exit_files+0x46
ffff88004165ff08 ffffffff81058648 do_exit+0x20e
ffff88004165ff48 ffffffff810588d1 do_group_exit+0x7d
ffff88004165ff78 ffffffff8105890e sys_exit_group+0x12

I interrupted a few more times, yes, once or twice I caught it
in some cfq io_context business: didn't take much notice because
I thought I'd saved the stack to log, but it hasn't appeared in my
/var/log/messages after reboot.  Once or twice there was another
sh running on another cpu, showing a very similar stack.

Hugh
