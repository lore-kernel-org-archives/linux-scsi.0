From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: eata fails to load on post 4.2 kernels
Date: Mon, 7 Sep 2015 11:06:26 +0800
Message-ID: <55ECFF32.9030902@linux.intel.com>
References: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net>
 <55EC019F.4010209@internode.on.net> <55EC2567.8000100@internode.on.net>
 <55ECA291.1060103@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:56899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbbIGDG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 23:06:28 -0400
In-Reply-To: <55ECA291.1060103@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, tglx@linutronix.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2015/9/7 4:31, Arthur Marsh wrote:
> Arthur Marsh wrote on 06/09/15 21:07:
>> Arthur Marsh wrote on 06/09/15 18:34:
>>> Arthur Marsh wrote on 06/09/15 15:58:
>>>> Hi, I'm seeing the following on post 4.2 kernels, am currently
>>>> bisecting
>>>> to find where it started:
>>
>> First kernel in the bisection that worked without needing irqpoll:
>>
>> [   73.751482] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
>> [   73.776711] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
>> [   73.802005] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n,
>> ip:n, ep:n, pp:y.
>> [   73.829175] EATA0: 2.0C, PCI 0xd890, IRQ 17, BMST, SG 122, MB 64.
>> [   73.855552] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
>> [   73.881125] EATA0: SCSI channel 0 enabled, host target ID 7.
> 
> After a git bisect, I get:
> 
> git bisect good
> 991de2e59090e55c65a7f59a049142e3c480f7bd is the first bad commit
> commit 991de2e59090e55c65a7f59a049142e3c480f7bd
> Author: Jiang Liu <jiang.liu@linux.intel.com>
> Date:   Wed Jun 10 16:54:59 2015 +0800
> 
>     PCI, x86: Implement pcibios_alloc_irq() and pcibios_free_irq()
> 
>     To support IOAPIC hotplug, we need to allocate PCI IRQ resources on
> demand
>     and free them when not used anymore.
> 
>     Implement pcibios_alloc_irq() and pcibios_free_irq() to dynamically
>     allocate and free PCI IRQs.
> 
>     Remove mp_should_keep_irq(), which is no longer used.
> 
>     [bhelgaas: changelog]
>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> :040000 040000 765e2d5232d53247ec260b34b51589c3bccb36ae
> f680234a27685e94b1a35ae2a7218f8eafa9071a M      arch
> :040000 040000 d55a682bcde72682e883365e88ad1df6186fd54d
> f82c470a04a6845fcf5e0aa934512c75628f798d M      drivers
> 
> I'm happy to supply more details if needed.
Hi Arthur,
	Thanks for reporting this. It seems to be an irq misrouting
issue. Could you please help to provide:
1) full dmesg with the latest code
2) full dmesg and /proc/interrupts with the latest code and
   kernel parameter "irqpoll" specified
Thanks!
Gerry
> 
> Regards,
> 
> Arthur.
> 
> 
