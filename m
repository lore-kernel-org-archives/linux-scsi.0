From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Sat, 15 Nov 2003 22:48:28 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311152233110.2142-100000@poirot.grange>
References: <20031103091451.A25391@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58553 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262068AbTKOVuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Nov 2003 16:50:12 -0500
In-Reply-To: <20031103091451.A25391@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

Hello

So, since that last email I was spending a couple of hours practically
every day, trying to fix tmscsim in 2.6. It turned to be A LOT more work,
than with AM53C974, a lot more difficult, and it still doesn't work. The
problem I am currently having, is the following: initialisation and
several first commands seem to complete fine, but then I get an Oops,
because dma_map_page is called with direction == DMA_NONE. Below is
attached a log with debugging turned on and an Oops. So, the question,
under which conditions can there be a command with direction NONE issued?
I see, it comes from the elevator, from the block layer, but what does
this mean? What is wrong?

Thanks
Guennadi
---
Guennadi Liakhovetski

DC390(0): IO_PORT=7100,IRQ=b
DC390_init: No EEPROM found! Trying default settings ...
DC390: Used defaults: AdaptID=7, SpeedIdx=0 (10.0 MHz), DevMode=0x1f, AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
DC390: pSH = c1772000, Index 00,<6>DC390: Adapter index 0, ID 7, IO 0x00007100, IRQ 0x0b

DC390: pACB = c17721b4, pDCBmap = c17721f0, pSRB_array = c1772288
DC390: ACB size= 1074, DCB size=   30, SRB size=   50
DC390: 1 adapters found
scsi0 : Tekram DC390/AM53C974 V2.0f 2000-12-20
DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=0)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: We were just reset and don't accept commands yet!
DC390: Insert pSRB c1772288 cmd 0 to Waiting
DC390: Debug: Waiting queue woken up by timer!
DC390: Remove SRB c1772288 from head of Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (00,00000000), SRB c1772288, pid 0
DC390: INQUIRY: result: 00000000
DC390: Remove SRB c1772288 from Going
DC390: Free SRB c1772288
  Vendor:           Model:                   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 00
DC390: Queue Cmd=12,Tgt=1,LUN=0 (pid=1)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 1
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=12,Tgt=2,LUN=0 (pid=2)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 2
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=12,Tgt=3,LUN=0 (pid=3)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 3
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=12,Tgt=4,LUN=0 (pid=4)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 4
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=12,Tgt=5,LUN=0 (pid=5)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 5
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=12,Tgt=6,LUN=0 (pid=6)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
DC390: Append SRB c1772288 to Going
DISC, SRBdone (ff,00000000), SRB c1772288, pid 6
DC390: INQUIRY: result: 00010000
DC390: Free SRB c1772288
DC390: Queue Cmd=00,Tgt=0,LUN=0 (pid=7)
DC390: Get Free SRB c1772288
DC390: Free SRB w/o Waiting
------------[ cut here ]------------
kernel BUG at include/asm/dma-mapping.h:53!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c01ecd2e>]    Not tainted
EFLAGS: 00010046
EIP is at dc390_BuildSRB+0xda/0x17c
eax: c1027fd8   ebx: c1776ce0   ecx: c1000000   edx: c0fffe00
esi: 00000e00   edi: c1772288   ebp: c17e5dac   esp: c17e5d98
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 1, threadinfo=c17e4000 task=c17d38c0)
Stack: c1772288 c01e4e34 c17721b4 c0117133 c1772288 c17e5dd0 c01ed203 c1776ce0
       c10407a0 c1772288 00000293 c1776ce0 c1772000 c10407a0 c17e5df0 c01e4c5f
       c1776ce0 c01e4e34 c1776ce0 c1078400 c1772000 00000000 c17e5e0c c01e9a4c
Call Trace:
 [<c01e4e34>] scsi_done+0x0/0x68
 [<c0117133>] printk+0x107/0x118
 [<c01ed203>] DC390_queue_command+0x2e7/0x2fc
 [<c01e4c5f>] scsi_dispatch_cmd+0x1d3/0x244
 [<c01e4e34>] scsi_done+0x0/0x68
 [<c01e9a4c>] scsi_request_fn+0x258/0x2c8
 [<c01cd099>] blk_insert_request+0x81/0x90
 [<c01e89d4>] scsi_insert_special_req+0x24/0x2c
 [<c01e8adf>] scsi_do_req+0x67/0x74
 [<c01e8ba3>] scsi_wait_req+0x67/0x98
 [<c01e8aec>] scsi_wait_done+0x0/0x50
 [<c01f26fe>] sd_spinup_disk+0xa2/0x26c
 [<c01f302f>] sd_revalidate_disk+0xc7/0x130
 [<c01f3257>] sd_probe+0x1bf/0x270
 [<c01c9992>] bus_match+0x32/0x58
 [<c01c9a88>] driver_attach+0x44/0x8c
 [<c01c9cee>] bus_add_driver+0x72/0x90
 [<c01ca07a>] driver_register+0x36/0x3c
 [<c01eb97b>] scsi_register_driver+0x13/0x18
 [<c02f57b6>] init_sd+0x56/0x70
 [<c02e468d>] do_initcalls+0x39/0x94
 [<c010505c>] init+0x0/0xe4
 [<c02e4704>] do_basic_setup+0x1c/0x28
 [<c0105079>] init+0x1d/0xe4
 [<c010505c>] init+0x0/0xe4
 [<c0107209>] kernel_thread_helper+0x5/0xc

Code: 0f 0b 35 00 0e 8f 28 c0 29 c8 8d 04 40 89 c2 c1 e2 04 01 d0
 <0>Kernel panic: Attempted to kill init!

