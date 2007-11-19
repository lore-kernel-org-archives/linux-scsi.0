From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Mon, 19 Nov 2007 17:17:41 +0000
Message-ID: <20071119171741.5571321d@the-village.bc.nu>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>
	<473E6E62.9090309@rtr.ca>
	<8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>
	<473F15E1.5030601@rtr.ca>
	<8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>
	<473F4724.6010107@rtr.ca>
	<8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>
	<47404CFC.7050405@rtr.ca>
	<8202f4270711181114w67632260la995daf65f507313@mail.gmail.com>
	<47409872.3060500@rtr.ca>
	<8202f4270711181429x13782fc4x4db3568607f7f23e@mail.gmail.com>
	<4740C59F.50709@rtr.ca>
	<4741BC6F.3010100@katalix.com>
	<4741BF00.7020906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37793 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741AbXKSRT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 12:19:56 -0500
In-Reply-To: <4741BF00.7020906@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Chapman <jchapman@katalix.com>, Mark Lord <liml@rtr.ca>, Fajun Chen <fajunchen@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

> SFF ATA controllers are peculiar in that...
> 
> 1. it doesn't have reliable IRQ pending bit.
> 
> 2. it doesn't have reliable IRQ mask bit.
> 
> 3. some controllers tank the machine completely if status or data
> register is accessed differently than the chip likes.

And 4. which is a killer for a lot of RT users

An I/O cycle to a taskfile style controller generally goes at ISA type
speed down the wire to the drive and back again. The CPU is stalled for
this and there is nothing we can do about it.

> 
> So, it's not like we're all dickheads.  We know it's good to take those
> out of irq handler.  The hardware just isn't very forgiving and I bet
> you'll get obscure machine lockups if the RT kernel arbitrarily pushes
> ATA PIO data transfers into kernel threads.
> 
> I think doing what IDE has been doing (disabling IRQ from interrupt
> controller) is the way to go.

Agreed - at which point RT or otherwise you can push it out. If you need
to do serious (sub 1mS) ATA then also go get a non SFF controller.

Alan
