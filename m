From: Anton Blanchard <anton@samba.org>
Subject: Re: Emulex lpfcdriver v8.0.2 available
Date: Tue, 8 Jun 2004 17:19:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608071939.GA32129@krispykreme>
References: <3356669BBE90C448AD4645C843E2BF28034F9421@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44953 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S264881AbUFHHXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 03:23:30 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9421@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


Hi James,

We scored the following oops on the lpfcdriver-2.6-8.0.3 driver.
lpfc_delay_done hits a NULL pointer. It looks like clkData is not
initialised:

        list_del((struct list_head *)clkData);

I noticed you use casts all over the place in list functions, why not just
pass in &clkData->list?

Anton

NIP: C0000000002D2A40 XER: 0000000020000000 LR: C000000000060AE0
REGS: c00000000ffffb40 TRAP: 0300   Not tainted  (2.6.7-rc2)
MSR: 9000000000001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 0000000000000000, DSISR: 0000000042000000
TASK: c00000000066e840[0] 'swapper' THREAD: c000000000500000 CPU: 0
GPR00: 0000000000200200 C00000000FFFFDC0 C000000000832EB0 C00000203873E838
GPR04: C00000203873E800 C0000000009EDF00 0000000000000000 C000001FFF976000
GPR08: 0000000000000000 0000000000100100 0000000000000000 9000000000009032
GPR12: C000000000687FC0 C000000000504000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: C000000000503A00 000000C1000000D5 0000000000000000 0000000000000096
GPR28: C00000000FFFFEC0 C00000000FFFC000 C000000000693818 C000000000C6FF00
NIP [c0000000002d2a40] .lpfc_delay_done+0xa8/0xec
LR [c000000000060ae0] .run_timer_softirq+0x1bc/0x308
Call Trace:
[c000000000084374] .wb_timer_fn+0x20/0x6c (unreliable)
[c000000000060ae0] .run_timer_softirq+0x1bc/0x308
[c00000000005b774] .__do_softirq+0xa8/0x16c
[c000000000016b80] .call_do_softirq+0x14/0x24
[c00000000001102c] .do_softirq+0x90/0xa0
[c0000000000141a8] .timer_interrupt+0x3a4/0x47c
[c00000000000a2b4] Decrementer_common+0xb4/0x100
--- Exception: 901 at .default_idle+0x64/0xac
    LR = .default_idle+0xa4/0xac
