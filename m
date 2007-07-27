From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 10:57:16 -0400
Message-ID: <46AA07CC.9090004@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58499 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXG0O5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:57:18 -0400
In-Reply-To: <20070727145336.GK21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 27, 2007 at 10:49:17AM -0400, Jeff Garzik wrote:
>> Matthew Wilcox wrote:
>>> Pass the Scsi_Host to the interrupt handler, rather than polling all
>>> hosts for each interrupt.
>>> Return IRQ_NONE if we didn't handle this interrupt
>>> Don't set the IRQF_DISABLED flag; this is not a fast-executing interrupt
>>> handler.
>>>
>>> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
>> hrm.
>>
>> I thought you had multiple scsi hosts per board?  Thus multiple scsi 
>> hosts per interrupt?
> 
> Right.  We'll request the interrupt twice, each time with a different
> scsi_host.

ewwwwww.  That's, um, broken :)

I presume request_irq() will fail on non-ISA for subsequent calls, and 
your interrupt handler gets called -twice- for every single interrupt.




