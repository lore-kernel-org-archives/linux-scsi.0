From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Tue, 6 Dec 2005 20:31:43 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512062025230.28217@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
 <20051202180326.GB7634@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
 <20051202194447.GA7679@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512022037230.6058@goblin.wat.veritas.com>
 <20051206160815.GC11560@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:59687 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S1030210AbVLFUcb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2005 15:32:31 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (3046 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EjjTP-0001JTC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Tue, 6 Dec 2005 12:31:39 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051206160815.GC11560@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 6 Dec 2005, Ryan Richter wrote:

> Another crash during last night's backup:
> 
> Bad page state at free_hot_cold_page (in process 'taper', page ffff810002410cc0)
> flags:0x010000000000000c mapping:ffff81017d5beb70 mapcount:2 count:0
> Bad page state at free_hot_cold_page (in process 'taper', page ffff810002410cc0)
> flags:0x010000000000081c mapping:ffff810064cd6910 mapcount:0 count:0
> Kernel BUG at include/linux/mm.h:341
> Pid: 11402, comm: taper Tainted: G    B 2.6.14.3 #1
> RIP: 0010:[<ffffffff802b904d>] <ffffffff802b904d>{sgl_unmap_user_pages+93}
> Kernel BUG at mm/rmap.c:487
> Pid: 11402, comm: taper Tainted: G    B 2.6.14.3 #1
> RIP: 0010:[<ffffffff8016f437>] <ffffffff8016f437>{page_remove_rmap+39}
> Bad page state at prep_new_page (in process 'dumper', page ffff810002410cc0)
> flags:0x010000000000001c mapping:0000000000000000 mapcount:-1 count:0
> general protection fault: 0000 [3] SMP 
> Pid: 1303, comm: kjournald Tainted: G    B 2.6.14.3 #1
> RIP: 0010:[<ffffffff8015fdfa>] <ffffffff8015fdfa>{cache_alloc_refill+330}
>  NMI Watchdog detected LOCKUP on CPU 1
> Pid: 918, comm: md0_raid5 Tainted: G    B 2.6.14.3 #1
> RIP: 0010:[<ffffffff8038385b>] <ffffffff8038385b>{.text.lock.spinlock+116}

Thanks for the further report.  And you had my st.c patch in along
with 2.6.14.3, but it still happened, very much like before (except the
latter errors, general protection fault onwards - but once we get into
using one page for two uses at the same time, anything can go wrong).

I've been staring and thinking, but no inspiration yet.

Hugh
