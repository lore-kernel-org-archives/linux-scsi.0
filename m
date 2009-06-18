From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 07:16:32 -0600
Message-ID: <20090618131632.GZ19977@parisc-linux.org>
References: <4A3A2FA2.60005@gmail.com> <1245330204.4773.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36277 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761498AbZFRNQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 09:16:30 -0400
Content-Disposition: inline
In-Reply-To: <1245330204.4773.10.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 18, 2009 at 09:03:24AM -0400, James Bottomley wrote:
> On Thu, 2009-06-18 at 14:14 +0200, Roel Kluin wrote:
> > -           dc390_laststatus |= bval << 24;
> > +           dc390_laststatus |= (unsigned)bval << 24;
> 
> bval is already u8, thus unsigned, so the cast is a nop.

Err ... I believe you're pedantically uncorrect, though right in practice.

The (unsigned) cast is short for (unsigned int) -- it doesn't mean
'cast to an unsigned version of the type that it already has'.

Now, in practice what happens is:

6.5.7:

The integer promotions are performed on each of the operands. The type
of the result is that of the promoted left operand.

so bval would be promoted from an unsigned char to a signed int, and
then shifted left by 24 bits, resulting in a potentially negative number.
But dc390_laststatus is an u32, so the |= converts this negative number
into a positive one, leading to the same answer that would have been
carried out in unsigned arithmetic.

So you're right (the cast isn't needed) for the wrong reason ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
