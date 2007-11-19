From: Tejun Heo <htejun@gmail.com>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Tue, 20 Nov 2007 01:51:12 +0900
Message-ID: <4741BF00.7020906@gmail.com>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>	 <473E6E62.9090309@rtr.ca>	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>	 <473F15E1.5030601@rtr.ca>	 <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>	 <473F4724.6010107@rtr.ca>	 <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>	 <47404CFC.7050405@rtr.ca>	 <8202f4270711181114w67632260la995daf65f507313@mail.gmail.com>	 <47409872.3060500@rtr.ca> <8202f4270711181429x13782fc4x4db3568607f7f23e@mail.gmail.com> <4740C59F.50709@rtr.ca> <4741BC6F.3010100@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:47034 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbXKSQvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 11:51:18 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1470369rvb
        for <linux-scsi@vger.kernel.org>; Mon, 19 Nov 2007 08:51:18 -0800 (PST)
In-Reply-To: <4741BC6F.3010100@katalix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Cc: Mark Lord <liml@rtr.ca>, Fajun Chen <fajunchen@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

James Chapman wrote:
> Mark Lord wrote:
>> One way to deal with it in an embedded device, is to force the
>> application that's generating the I/O to self-throttle.
>> Or modify the device driver to self-throttle.
> 
> Does disk access have to be so interrupt driven? Could disk interrupt
> handling be done in a softirq/kthread like the networking guys deal with
> network device interrupts? This would prevent the system from
> live-locking when it is being bombarded with disk IO events. It doesn't
> seem right that the disk IO subsystem can cause interrupt live-lock on
> relatively slow CPUs...
> 
>> You may want to find an embedded Linux consultant to help out
>> with this situation if it's beyond your expertise.
> 
> Check out the rtlinux patch, which pushes all interrupt handling out to
> per-cpu kernel threads (irqd). The kernel scheduler then regains control
> of what runs when.
> 
> Another option is to change your ATA driver to do interrupt processing
> at task level using a workqueue or similar.

SFF ATA controllers are peculiar in that...

1. it doesn't have reliable IRQ pending bit.

2. it doesn't have reliable IRQ mask bit.

3. some controllers tank the machine completely if status or data
register is accessed differently than the chip likes.

So, it's not like we're all dickheads.  We know it's good to take those
out of irq handler.  The hardware just isn't very forgiving and I bet
you'll get obscure machine lockups if the RT kernel arbitrarily pushes
ATA PIO data transfers into kernel threads.

I think doing what IDE has been doing (disabling IRQ from interrupt
controller) is the way to go.

-- 
tejun
