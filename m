From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: sr.c use unaligned access helpers
Date: Tue, 7 Oct 2008 13:37:11 -0600
Message-ID: <20081007193711.GK25780@parisc-linux.org>
References: <1223081173.6778.4.camel@brick> <20081007121025.GY19428@kernel.dk> <48EB53C2.6050101@panasas.com> <20081007122531.fbe3c6b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57496 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYJGTh2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 15:37:28 -0400
Content-Disposition: inline
In-Reply-To: <20081007122531.fbe3c6b8.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, jens.axboe@oracle.com, harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Oct 07, 2008 at 12:25:31PM -0700, Andrew Morton wrote:
> On Tue, 07 Oct 2008 14:19:14 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> > I feel the opposite. That is: put_unaligned_be32(block, SCpnt->cmnd + 2);
> > is much more readable for me. Coming from the spec, I'm looking for a __b32
> > at offset CDB+2 and not: "SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;"
> > At offset CDB+4 the 2nd-or-3rd? order byte of "block".
> > 
> > And for BE systems it's a gain. So please DO
> 
> Yeah.  For neophytes it's a good change.  This:
> 
> 	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
> 	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
> 	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
> 	SCpnt->cmnd[5] = (unsigned char) block & 0xff;
> 
> is "wtf is that doing?", whereas this:
> 
> 	put_unaligned_be32(block, SCpnt->cmnd + 2);
> 
> is "ah, I know what that's doing".

And scsi_put_u32(block, SCpnt->cmnd + 2); is even more obvious.  You
don't even need to know that SCSI is a big-endian protocol that way,
just that the u32 is being written in the appropriate way for SCSI
(see also ntohl et al).

Also, SCSI needs to be able to read/write 'u24' quantities, which is
potentially an ambiguous thing if you consider it in terms of
byteswapping.  I don't think we want a put_unaligned_be24() function,
but we do want a scsi_put_u24().

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
