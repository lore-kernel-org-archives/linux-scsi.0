From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC PATCH-mm] scsi: use unaligned endian helpers rather than
 byteshifting
Date: Wed, 03 Dec 2008 12:27:48 -0800
Message-ID: <1228336068.5412.83.camel@brick>
References: <1228333043.5412.35.camel@brick>
	 <20081203201505.GE25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:56995 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031AbYLCU1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 15:27:51 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1545594ywe.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2008 12:27:50 -0800 (PST)
In-Reply-To: <20081203201505.GE25548@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-12-03 at 13:15 -0700, Matthew Wilcox wrote:
> On Wed, Dec 03, 2008 at 11:37:23AM -0800, Harvey Harrison wrote:
> > Depends on the unaligned access work in -mm.  Just so you can see what the
> > transition would look like.  See in particular the READ/WRITE6 bits
> > as just reading the full 32 bits and masking ends up being better on
> > lots of arches. (x86/powerpc/SH at least)
> 
> >  		case WRITE_6:
> >  		case READ_6:
> > -			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
> > -			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
> > +			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[0]) & 0x1fffff;
> >  			break;
> 
> That may well generate better code, but I have a hard time convincing
> myself that it's correct.  This badly needs to be abstracted into
> something *THAT MAKES SENSE FOR SCSI*.
> 
> James, if I resend my patches that introduce scsi_get_u24() et al, will
> you apply them?  I'm tired of having to nack all the crazy patches that
> Harvey keeps sending.
> 

Pardon me?  How could I have done this better:

1) I went through the work to create a common API the whole kernel can
use.
2) I hooked up ~20 arches and let arches provide optimized versions
where they can.
3) Mine generates better code than what is already there
4) I made it exist for the aligned cases too in case you know it's
aligned

Then, when I send an RFC you call it crazy?

If anything I made it a whole lot goddamn easier on _YOU_
to get you scsi patches to generate good code as these endian helpers
are now available on every arch.  You're fucking welcome by the way.

I also went through the kernel and removed a bunch of private endian
wrappers and got them through maintainers, who, by and large, were
happy to use the common infrastructure....other than scsi for some
reason I cannot for the life of me understand.

So add a private scsi helper if you want, I'm not standing in your way
but if anything, I think you are crazy one here.

Harvey

