From: David Miller <davem@davemloft.net>
Subject: Re: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 21 Aug 2006 12:31:42 -0700 (PDT)
Message-ID: <20060821.123142.08327833.davem@davemloft.net>
References: <20060821104357.GH11651@stusta.de>
	<20060821105344.GA28759@infradead.org>
	<20060821192215.GL11651@stusta.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:39841
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S1750890AbWHUTb2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:31:28 -0400
In-Reply-To: <20060821192215.GL11651@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk@stusta.de
Cc: hch@infradead.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 21 Aug 2006 21:22:15 +0200

> On Mon, Aug 21, 2006 at 11:53:44AM +0100, Christoph Hellwig wrote:
> > On Mon, Aug 21, 2006 at 12:43:57PM +0200, Adrian Bunk wrote:
> > > This patch contains the following cleanups:
> > > - #include <linux/irq.h> for getting the prototypes of
> > >   {dis,en}able_irq()
> > 
> > nothing outside of arch code must ever include <linux/irq.h>
> 
> Why?
> It sounds rather strange that non-arch code should use asm headers.

It's an unfortunate side effect of how the generic IRQ layer was done.

The linux/irq.h head should only be used on platforms that make use of
the generic IRQ layer.

asm/irq.h is what should be included by drivers and the like that want
the IRQ interfaces.

I'm not saying this is a good situation, it's just the way it is.
