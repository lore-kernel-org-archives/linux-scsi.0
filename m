From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: panic while doing lots of IO on lpfc
Date: Fri, 10 Oct 2008 12:33:18 +1100
Message-ID: <200810101233.18726.nickpiggin@yahoo.com.au>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31477 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758908AbYJIOd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2008 10:33:29 -0400
In-Reply-To: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Friday 10 October 2008 01:24, Meelis Roos wrote:
> I'm using 2.6.27-rc9 on an amd64 machine and tested a FC storage device
> here. ext3 on FC SCSI disk, served by Sun T3, Emulex LP8000 HBA.
>
> The specific test was
> cat somelargefile somelargefile | dd bs=1M of=/file/on/FC/volume
>
> (the dd there was a relict from a simpler test).
>
> The cat + dd results in bad page state + hang, with either Aiee or
> without. This is repeatable here. If there is any way of helping to
> debug it, I can do it - the system is not in production.
>
> Bad page state in process 'dd'
> page:ffffe200005130c0 flags:0x4000000000000009 mapping:0000000000000000
> mapcount:0 count:0
> Trying to fix it up, but a reboot is needed

Tried to lock a free page. Is the address of the page always the same,
and the first bit in flags always set after each reboot? Does the
machine pass a memtest?

It could be that someone actually tried to lock the page, though...
You could try putting a BUG_ON(!page_count(page)) at the start of
the trylock_page function.

Some more messages might provide more clues.

Thanks,
Nick

> Backtrace:
> Pid: 6395, comm: dd Not tainted 2.6.27-rc9 #1
> Call Trace:
>  [<ffffffff8027c6c6>] bad_page+0x66/0xa0
>  [<ffffffff8027df8d>] get_page_from_freelist+0x57d/0x5b0
>  [<ffffffff8027e397>] __alloc_pages_internal+0xe7/0x4b0
>  [<ffffffff8027771d>] find_get_page+0x9d/0xc0
>  [<ffffffff80277dbf>] __grab_cache_page+0x6f/0xc0
>  [<ffffffff8030ad8e>] ext3_write_begin+0xae/0x1e0
>  [<ffffffff80278c7b>] generic_file_buffered_write+0x1cb/0x780
>  [<ffffffff8031580d>] __ext3_journal_stop+0x2d/0x60
>  [<ffffffff802796f8>] __generic_file_aio_write_nolock+0x278/0x470
>  [<ffffffff802c1a9e>] mnt_want_write+0x6e/0xe0
>  [<ffffffff802c1b99>] mnt_drop_write+0x89/0x1a0
>  [<ffffffff8027a1c4>] generic_file_aio_write+0x64/0xe0
>  [<ffffffff80307783>] ext3_file_write+0x23/0xd0
>  [<ffffffff802a4e9b>] do_sync_write+0xdb/0x120
>  [<ffffffff802268d4>] do_page_fault+0x344/0x9e0
>  [<ffffffff80250ba0>] autoremove_wake_function+0x0/0x30
>  [<ffffffff802a597b>] vfs_write+0xcb/0x190
>  [<ffffffff802a5b43>] sys_write+0x53/0xa0
>  [<ffffffff8020c4ab>] system_call_fastpath+0x16/0x1b
>
> Second hang was similar but dmesg was not saved, it hung before.
