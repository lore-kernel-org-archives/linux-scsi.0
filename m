From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 07:36:13 -0600
Message-ID: <20090618133613.GA19977@parisc-linux.org>
References: <4A3A2FA2.60005@gmail.com> <1245330204.4773.10.camel@mulgrave.site> <20090618131632.GZ19977@parisc-linux.org> <4A3A40C9.9020900@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52129 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbZFRNgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 09:36:11 -0400
Content-Disposition: inline
In-Reply-To: <4A3A40C9.9020900@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Roel Kluin <roel.kluin@gmail.com>, garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 18, 2009 at 04:27:37PM +0300, Boaz Harrosh wrote:
> > The (unsigned) cast is short for (unsigned int) -- it doesn't mean
> > 'cast to an unsigned version of the type that it already has'.
> > 
> > Now, in practice what happens is:
> > 
> > 6.5.7:
> > 
> > The integer promotions are performed on each of the operands. The type
> > of the result is that of the promoted left operand.
> > 
> 
> Note the left operand, not the lvalue.

Yes, but the *promoted* left operand.  Look at 6.3.1 again, and you'll
see an unsigned char is promoted to int.

> > so bval would be promoted from an unsigned char to a signed int, and
> > then shifted left by 24 bits, resulting in a potentially negative number.
> > But dc390_laststatus is an u32, so the |= converts this negative number
> > into a positive one, leading to the same answer that would have been
> > carried out in unsigned arithmetic.
> 
> It could get dangerous in 64bit integer machines if the negative number
> gets truncated to 32bit while converted. So if the bval was > 127
> and we get a 64bit signed negative number what will happen then?

For one, Linux doesn't support an ILP64 model.  I32LP64 and ILP32 are
the only two models supported.

If we assume support for I64, then the value 255 gets promoted to be a
64-bit signed integer, and then shifted left by 24 bits.  The sign bit
is way up at 63, so it doesn't become negative.

Then it'll be ORed with the u32.  The u32 gets promoted to an s64 for
the operation, the OR is done in 64-bit arithmetic, then truncated back
down to u32 for the assignment.  Again, I don't see the problem.

> > So you're right (the cast isn't needed) for the wrong reason ;-)
> 
> Are you sure. It looks we need the cast

I'm going to need to see a better argument than that before I'm convinced ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
