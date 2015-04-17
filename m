From: Torsten Luettgert <ml-lkml@enda.eu>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
 746650160
Date: Fri, 17 Apr 2015 15:55:14 +0200
Message-ID: <20150417155514.5587ece2@goldlack.schiller106>
References: <20150408183333.493607a3@goldlack.schiller106>
	<20150413174105.GA14988@lst.de>
	<20150413202829.580e3801@goldlack.schiller106>
	<20150417153116.5f97e007@goldlack.schiller106>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150417153116.5f97e007@goldlack.schiller106>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 Apr 2015 15:31:16 +0200
Torsten Luettgert <ml-lkml@enda.eu> wrote:

> On Mon, 13 Apr 2015 20:28:29 +0200
> Torsten Luettgert <ml-lkml@enda.eu> wrote:
> 
> Right now, I'm trying the problematic release, compiled with a newer
> gcc (4.9.2-6 from Fedora, while using 4.4.7-11 from rhel6
> before). It has only been running a few hours yet, so I can't tell if
> it's good.

Ok, forget that, it just crashed.

Regards,
Torsten

> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018 IP: [<ffffffff8134d3c8>]
> swiotlb_unmap_sg_attrs+0x28/0x70 PGD 0 
> Oops: 0000 [#1] SMP 
> Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich mfd_core
> usb_storage CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 3.16.0-74665016086615bbaa3fa6f83af410a0a4e029ee+ #1 Hardware name:
> Supermicro X8DTT/X8DTT, BIOS 2.1c       04/22/2014 task:
> ffffffff81c16500 ti: ffffffff81c00000 task.ti: ffffffff81c00000 RIP:
> 0010:[<ffffffff8134d3c8>]  [<ffffffff8134d3c8>]
> swiotlb_unmap_sg_attrs+0x28/0x70 RSP: 0018:ffff88063fc03e20  EFLAGS:
> 00010002 RAX: ffff880c20567098 RBX: 0000000000000000 RCX:
> 0000000000000002 RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> ffff880c20567098 RBP: ffff88063fc03e48 R08: 0000000000000000 R09:
> ffffffff8134d3a0 R10: 0000000000000000 R11: 00000000000007eb R12:
> 0000000000000000 R13: 0000000000000002 R14: 0000000000000001 R15:
> ffff880c20567098 FS:  0000000000000000(0000)
> GS:ffff88063fc00000(0000) knlGS:0000000000000000 CS:  0010 DS: 0000
> ES: 0000 CR0: 000000008005003b CR2: 0000000000000018 CR3:
> 0000000001c11000 CR4: 00000000000027e0 Stack: ffff880c1eae0718
> ffff880c1eae4c70 ffff880c1f8c858c 00000000000000e4 00000000000000e4
> ffff88063fc03e58 ffffffff8147975e ffff88063fc03ea8 ffffffff81486135
> 0000000000000046 ffff880613c6d050 ffff88063fc03f48 Call Trace:
>  <IRQ> 
>  [<ffffffff8147975e>] scsi_dma_unmap+0x5e/0x80
>  [<ffffffff81486135>] twl_interrupt+0x425/0x750
>  [<ffffffff810f6139>] handle_irq_event_percpu+0x39/0x1b0
>  [<ffffffff810f62e7>] handle_irq_event+0x37/0x60
>  [<ffffffff810f95f8>] handle_fasteoi_irq+0x78/0x150
>  [<ffffffff8104fc64>] handle_irq+0x84/0x150
>  [<ffffffff810c0f6a>] ? atomic_notifier_call_chain+0x1a/0x20
>  [<ffffffff81778d5d>] do_IRQ+0x4d/0xe0
>  [<ffffffff817772ea>] common_interrupt+0x6a/0x6a
>  <EOI> 
>  [<ffffffff815e28a6>] ? cpuidle_enter_state+0x46/0xb0
>  [<ffffffff815e29f7>] cpuidle_enter+0x17/0x20
>  [<ffffffff810e12e9>] cpu_startup_entry+0x2b9/0x3e0
>  [<ffffffff81765887>] rest_init+0x77/0x80
>  [<ffffffff81d85e94>] start_kernel+0x41d/0x42a
>  [<ffffffff81d85495>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81d85588>] x86_64_start_kernel+0xf1/0xf4
> Code: 44 00 00 55 83 f9 03 48 89 e5 41 57 41 56 41 55 41 89 cd 41 54
> 53 74 4b 45 31 e4 85 d2 49 89 ff 48 89 f3 41 89 d6 7e 29 0f 1f 00
> <8b> 53 18 48 8b 73 10 44 89 e9 4c 89 ff 41 83 c4 01 e8 82 ff ff
> RIP [<ffffffff8134d3c8>] swiotlb_unmap_sg_attrs+0x28/0x70
>  RSP <ffff88063fc03e20>
> CR2: 0000000000000018
> ---[ end trace 3eba978c8cc1c24a ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> Shutting down cpus with NMI
> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> Rebooting in 10 seconds..
