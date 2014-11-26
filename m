From: Tim Small <tim@seoss.co.uk>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Wed, 26 Nov 2014 20:34:20 +0000
Message-ID: <5476394C.3050606@seoss.co.uk>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20141125162620.GA31478@infradead.org> <5474AE9B.40104@fb.com> <5475F2DD.9030906@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:42936 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbaKZUeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 15:34:37 -0500
In-Reply-To: <5475F2DD.9030906@seoss.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
Cc: tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On 26/11/14 15:33, Tim Small wrote:
> I decided to exercise the eject code path a bit more by triggering
> simultaneous eject commands on all 11 optical drives in my test box,
> followed by simultaneous close-tray commands, repeatedly.
...
>
> Unfortunately running these tests did eventually make all further
> attempts to open /dev/sr* block on my test box.
>
> I've stared at the code for a while, but not making any headway
> currently, except that a blocking blk_execute_rq (called by
> test_unit_ready) is then causing all over cdrom open/close calls to
> block (because sr_mutex is held by sr_block_open(), and in turn calls
> check_disk_change... scsi_test_unit_ready).
>
> How do I work out why blk_execute_rq is blocking?
>
> # ps -l 3779 2383 3780
> F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY        TIME CMD
> 1 D     0  2383     2  0  80   0 -     0 blk_ex ?          0:00 [kworker/1:2]
> 0 D     0  3779  1034  0  80   0 -  1057 blk_ex pts/0      0:00 eject -t /dev/sr7
> 0 D     0  3780  1034  0  80   0 -     0 sr_blo pts/0      0:00 [eject]
>
>
>
> /proc/3779/stack-[<ffffffff812e47cb>] blk_execute_rq+0x16b/0x210
> /proc/3779/stack-[<ffffffffa0291cb1>] scsi_execute+0x141/0x1f0 [scsi_mod]
> /proc/3779/stack-[<ffffffffa0293e1e>] scsi_execute_req_flags+0x8e/0x100 [scsi_mod]

> /proc/2383/stack-[<ffffffff812e47cb>] blk_execute_rq+0x16b/0x210
> /proc/2383/stack-[<ffffffffa0291cb1>] scsi_execute+0x141/0x1f0 [scsi_mod]
> /proc/2383/stack-[<ffffffffa0293e1e>] scsi_execute_req_flags+0x8e/0x100 [scsi_mod]
> /proc/2383/stack-[<ffffffffa02944f3>] scsi_test_unit_ready+0x83/0x130 [scsi_mod]

An extra data point, the drive is showing busy:

# cat /sys/block/sr7/device/device_busy
1

I was wondering if this might be an unrelated bug in the drive or host
adaptor driver?

This device is attached to an old PCI card using pata_pdc2027x, and has
an old firmware version, so I'm going to try and change both of those
things and try again.

Tim.
