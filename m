From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 11:12:48 -0400
Message-ID: <46AA0B70.9060108@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58618 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760891AbXG0PMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 11:12:49 -0400
In-Reply-To: <20070727150420.GL21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 27, 2007 at 10:57:16AM -0400, Jeff Garzik wrote:
>> Matthew Wilcox wrote:
>>> On Fri, Jul 27, 2007 at 10:49:17AM -0400, Jeff Garzik wrote:
>>>> I thought you had multiple scsi hosts per board?  Thus multiple scsi 
>>>> hosts per interrupt?
>>> Right.  We'll request the interrupt twice, each time with a different
>>> scsi_host.
>> ewwwwww.  That's, um, broken :)
>>
>> I presume request_irq() will fail on non-ISA for subsequent calls, and 
>> your interrupt handler gets called -twice- for every single interrupt.
> 
> I don't have any of these boards, so I may be labouring under a false
> apprehension here.  It seems that PCI cards with multiple hosts are
> actually one host per function (ie just like sym2, and dissimilar to
> aic7xyz).  With EISA, we set IRQF_SHARED, so we can request the same
> interrupt twice, each time with a different Scsi_Host.  I think the VLB
> card is probably stuffed -- need to set IRQF_SHARED for that case.

We need an ancient-hardware expert here.  To say the least, this is 
abuse of request_irq() and highly irregular.  I wound not count on this 
highly unusual behavior working at all.

At the very least, it violates the Principle of Least Surprise and IMO 
should not be done this way at all.

Yuck, yuck, yuck.  It's a high-overhead, highly fragile hack that no one 
else would ever do.

Note I never said 'NAK' with any patches, but I have to NAK this change.

	Jeff



