From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Mon, 15 May 2006 03:25:15 -0400
Message-ID: <44682CDB.9080804@garzik.org>
References: <200605122209.k4CM95oW014664@mail.hypersurf.com>	 <041901c677e7$fdd9fbf0$1200a8c0@GMM> <1147676215.3121.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:25009 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751214AbWEOHZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 03:25:23 -0400
In-Reply-To: <1147676215.3121.2.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2006-05-15 at 14:22 +0800, HighPoint Linux Team wrote:
>> Could you give more explanation about pci posting flush? When (and why) do we need it?
> 
> pci posting is where the chipset internally delays (posts) writes (as
> done by writel and such) to see if more writes will come that can then
> be combined into one burst. While in practice these queues are finite
> (and often have a timeout) it's bad practice to depend on that. The
> simplest way to flush out this posting is to do a (dummy) readl() from
> the same device. (alternative is to do dma from the device to ram, but
> readl() is a lot easier ;)
> 
>> In an old posting (http://lkml.org/lkml/2003/5/8/278) said pci posting flush is unnecessary - is it correct?
> 
> no not really, not as a general statement.

ACK.

Generally speaking, readl() is the best way to ensure that all writes 
have been flushed across various layers of PCI bridges, etc.

It is particularly important to get this right if you are issuing a 
delay (i.e. udelay) after a write.  If the write is not guaranteed to be 
flushed at the time the delay begins, then you are no longer truly 
delaying for the time requested.

	Jeff



