From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: qlogic lockdep warning
Date: Thu, 21 Jan 2010 09:22:39 +0100
Message-ID: <1264062159.4283.1125.camel@laptop>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0AUIW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2010 03:22:57 -0500
In-Reply-To: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@hansenpartnership.com>, James.Bottomley@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Wed, 2010-01-20 at 17:10 -0800, Yinghai Lu wrote:

> [   77.962879] ------------[ cut here ]------------
> [   77.965784] WARNING: at kernel/lockdep.c:2332
> trace_hardirqs_on_caller+0xc6/0x14b()
> [   77.977492] Hardware name: Sun
> [   77.979485] Modules linked in:
> [   77.994337] Pid: 0, comm: swapper Not tainted
> 2.6.33-rc4-tip-yh-03949-g3a8e3f5-dirty #64
> [   78.000120] Call Trace:
> [   78.013298]  <IRQ>  [<ffffffff81076b54>] warn_slowpath_common+0x7c/0x94
> [   78.017746]  [<ffffffff81cd712c>] ? _raw_spin_unlock_irq+0x30/0x36
> [   78.035171]  [<ffffffff81076b80>] warn_slowpath_null+0x14/0x16
> [   78.040152]  [<ffffffff810a2ae8>] trace_hardirqs_on_caller+0xc6/0x14b
> [   78.055400]  [<ffffffff810a2b7a>] trace_hardirqs_on+0xd/0xf
> [   78.058951]  [<ffffffff81cd712c>] _raw_spin_unlock_irq+0x30/0x36
> [   78.074889]  [<ffffffff816461ef>] qla24xx_msix_default+0x243/0x281
> [   78.091598]  [<ffffffff810a5752>] ? __lock_release+0xa5/0xae
> [   78.096799]  [<ffffffff810c02ae>] handle_IRQ_event+0x53/0x113
> [   78.111568]  [<ffffffff810c2061>] handle_edge_irq+0xf3/0x13b
> [   78.116255]  [<ffffffff81035109>] handle_irq+0x24/0x2f
> [   78.132063]  [<ffffffff81cdc4b4>] do_IRQ+0x5c/0xc3
> [   78.134684]  [<ffffffff81cd7393>] ret_from_intr+0x0/0xf
> [   78.137903]  <EOI>  [<ffffffff81039a56>] ? mwait_idle+0xaf/0xbb
> [   78.155674]  [<ffffffff81039a4d>] ? mwait_idle+0xa6/0xbb
> [   78.158600]  [<ffffffff81031c7c>] cpu_idle+0x61/0xa1
> [   78.174333]  [<ffffffff81c85d7a>] rest_init+0x7e/0x80
> [   78.178122]  [<ffffffff82832d1f>] start_kernel+0x316/0x31d
> [   78.193623]  [<ffffffff82832297>] x86_64_start_reservations+0xa7/0xab
> [   78.198924]  [<ffffffff8283237f>] x86_64_start_kernel+0xe4/0xeb
> [   78.214540] ---[ end trace be4529f30a2e4ef5 ]---

It appears the thing tries to enable IRQs from within an IRQ handler,
naughty.

