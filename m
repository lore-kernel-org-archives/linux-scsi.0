From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 17 Jul 2003 07:44:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058453043.4638.2.camel@markh1.pdx.osdl.net>
References: <20030716132036.GB833@suse.de>
	 <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de>
	 <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de>
	 <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de>
	 <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
	 <3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	 <3F168846.90902@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57516 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271459AbTGQO3T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 10:29:19 -0400
In-Reply-To: <3F168846.90902@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-17 at 04:28, Nick Piggin wrote:
> Jens Axboe wrote:
> 
> >On Thu, Jul 17 2003, Nick Piggin wrote:
> >
> 
> snip
> 
> >>
> >>Jens, this is exactly right. Would you be OK with this? Everyone else?
> >>
> >
> >I'm happy with it.
> >
> 
> OK, Mark, please try the following patch in combination with Jens'
> previous. Untested due to not being able to exercise the requeue
> path, so it might blow up.
> 
> ______________________________________________________________________
I added Jens' and your patch and got this when I did a mkfs on an
aacraid disk:


Script started on Thu 17 Jul 2003 07:40:20 AM PDT
[Enter `^Ec?' for help]

[root@dev8-002 root]# ------------[ cut here ]------------
kernel BUG at drivers/block/as-iosched.c:984!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c02e1c2b>]    Not tainted
EFLAGS: 00010046
EIP is at as_remove_queued_request+0xdb/0x120
eax: 00000000   ebx: f6b3ad7c   ecx: 00000000   edx: f1f7234c
esi: edeb3004   edi: f0ed8004   ebp: c3f9fdc0   esp: c3f9fda0
ds: 007b   es: 007b   ss: 0068
Process ksoftirqd/0 (pid: 3, threadinfo=c3f9e000 task=c3fda000)
Stack: c02e118b edeb3004 00000000 00000000 00000000 edeb3004 f6b3ad7c 00000000 
       c3f9fde4 c02e1ef2 f0ed8004 edb87004 f13bc240 00000003 edeb3004 00000000 
       f6b3ad7c c3f9fe08 c02e20e8 edeb3004 f6b3ad7c 00000001 f8a3234a edeb3004 
Call Trace:
 [<c02e118b>] as_find_next_arq+0x4b/0x80
 [<c02e1ef2>] as_move_to_dispatch+0x92/0x140
 [<c02e20e8>] as_dispatch_request+0x148/0x280
 [<f8a3234a>] aac_queuecommand+0x1a/0x30 [aacraid]
 [<c02e2258>] as_next_request+0x38/0x50
 [<c02d86a6>] elv_next_request+0x16/0x110
 [<c031afbe>] scsi_request_fn+0x3e/0x430
 [<c02da35e>] blk_run_queue+0x3e/0xa0
 [<c031a3ca>] scsi_run_queue+0xca/0x1a0
 [<c031a631>] scsi_end_request+0xc1/0x110
 [<c031a98b>] scsi_io_completion+0x14b/0x470
 [<c03cf0b5>] ip_rcv+0x365/0x4a8
 [<c032b979>] sd_rw_intr+0x59/0x240
 [<c0315e94>] scsi_finish_command+0x74/0xb0
 [<c0315db8>] scsi_softirq+0xb8/0xe0
 [<c0127dd7>] do_softirq+0xe7/0xf0
 [<c0128375>] ksoftirqd+0xd5/0x100
 [<c01282a0>] ksoftirqd+0x0/0x100
 [<c01074e9>] kernel_thread_helper+0x5/0xc

Code: 0f 0b d8 03 cb 60 46 c0 e9 56 ff ff ff c7 44 24 0c d5 03 00 
 <0>Kernel panic: Fatal exception in interrupt
In interrupt handler - not syncing

Script done on Thu 17 Jul 2003 07:41:16 AM PDT

-- 
Mark Haverkamp <markh@osdl.org>

