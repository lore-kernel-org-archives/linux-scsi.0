From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC PATCH-mm] scsi: use unaligned endian helpers rather than byteshifting
Date: Wed, 3 Dec 2008 13:15:06 -0700
Message-ID: <20081203201505.GE25548@parisc-linux.org>
References: <1228333043.5412.35.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44524 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbYLCUPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 15:15:07 -0500
Content-Disposition: inline
In-Reply-To: <1228333043.5412.35.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Dec 03, 2008 at 11:37:23AM -0800, Harvey Harrison wrote:
> Depends on the unaligned access work in -mm.  Just so you can see what the
> transition would look like.  See in particular the READ/WRITE6 bits
> as just reading the full 32 bits and masking ends up being better on
> lots of arches. (x86/powerpc/SH at least)

>  		case WRITE_6:
>  		case READ_6:
> -			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
> -			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
> +			lba = load_be32_noalign((__be32 *)&scsicmd->cmnd[0]) & 0x1fffff;
>  			break;

That may well generate better code, but I have a hard time convincing
myself that it's correct.  This badly needs to be abstracted into
something *THAT MAKES SENSE FOR SCSI*.

James, if I resend my patches that introduce scsi_get_u24() et al, will
you apply them?  I'm tired of having to nack all the crazy patches that
Harvey keeps sending.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
