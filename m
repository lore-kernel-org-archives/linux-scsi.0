From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH][RELEASE] megaraid 2.10.2 Driver
Date: Tue, 23 Mar 2004 00:45:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040323004543.GP25059@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E570230C77B@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32158 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261728AbUCWAps
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 19:45:48 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C77B@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Mon, Mar 22, 2004 at 07:02:39PM -0500, Bagalkote, Sreenivas wrote:
> >>For upstream, this should just be CONFIG_COMPAT I presume.
> 
> For 2.6 kernels, this would be just CONFIG_COMPAT. Or have I
> misunderstood your comment?
> 
> >>I don't see how this construct will work in all cases.  Hence my 
> >>CONFIG_COMPAT command above.
> 
> We saw the need for ioctl compatibility in __x86_64__ cases so far.
> What other cases will this not work in?

I don't think you understand how CONFIG_COMPAT works.  x86-64 defines it
when it wants it:

config COMPAT
        bool
        depends on IA32_EMULATION
        default y

just like every other architecture.  Just use
#ifdef CONFIG_COMPAT
	... 32bit compat code ...
#endif

and everything will be fine.  Please don't introduce this stupid
unnecessary LSI_CONFIG_COMPAT.  That just makes people say "what the
fuck are they doing?".

> >>Bug -- always set dma mask.  Do not conditionally _not_ call 
> >>pci_set_dma_mask(), for the 64-bit case.
> 
> The code does not __not__ call pci_set_dma_mask() conditionally.
> It is always calling with either 64-bit or 32-bit mask.
> 
> >>ummmm what???    uxferaddr is u32.  why are you casting it to a pointer?
> 
> Both copy_to_user and copy_from_user take pointers, don't they?

So you can only copy to the bottom 4GB of user address space?  That
seems like a recipe for disaster.  Particularly on ia64.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
