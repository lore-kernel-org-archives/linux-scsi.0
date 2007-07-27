From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 09:04:21 -0600
Message-ID: <20070727150420.GL21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36894 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbXG0PEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 11:04:21 -0400
Content-Disposition: inline
In-Reply-To: <46AA07CC.9090004@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:57:16AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >On Fri, Jul 27, 2007 at 10:49:17AM -0400, Jeff Garzik wrote:
> >>I thought you had multiple scsi hosts per board?  Thus multiple scsi 
> >>hosts per interrupt?
> >
> >Right.  We'll request the interrupt twice, each time with a different
> >scsi_host.
> 
> ewwwwww.  That's, um, broken :)
> 
> I presume request_irq() will fail on non-ISA for subsequent calls, and 
> your interrupt handler gets called -twice- for every single interrupt.

I don't have any of these boards, so I may be labouring under a false
apprehension here.  It seems that PCI cards with multiple hosts are
actually one host per function (ie just like sym2, and dissimilar to
aic7xyz).  With EISA, we set IRQF_SHARED, so we can request the same
interrupt twice, each time with a different Scsi_Host.  I think the VLB
card is probably stuffed -- need to set IRQF_SHARED for that case.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
