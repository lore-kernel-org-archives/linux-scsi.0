From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: iomapping a big endian area
Date: Tue, 5 Apr 2005 19:55:06 +0100
Message-ID: <20050405195506.A16617@flint.arm.linux.org.uk>
References: <1112475134.5786.29.camel@mulgrave> <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk> <20050402183805.20a0cf49.davem@davemloft.net> <20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk> <1112499639.5786.34.camel@mulgrave> <20050405084219.A21615@flint.arm.linux.org.uk> <1112709915.5764.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261892AbVDETAU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1112709915.5764.4.camel@mulgrave>; from James.Bottomley@SteelEye.com on Tue, Apr 05, 2005 at 09:05:15AM -0500
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2005 at 09:05:15AM -0500, James Bottomley wrote:
> On Tue, 2005-04-05 at 08:42 +0100, Russell King wrote:
> > Not so.  There are two different styles of big endian.  (Lets just face
> > it, BE is fucked in the head anyway...)
> > 
> > physical bus:	31...24	23...16	15...8	7...0
> > 
> > BE version 1 (word invariant)
> >   byte access	byte 0	byte 1	byte 2	byte 3
> >   word access	31-24	23-16	15-8	7-0
> > 
> > BE version 2 (byte invariant)
> >   byte access	byte 3	byte 2	byte 1	byte 0
> >   word access	7-0	15-8	23-16	31-24
> 
> These are just representations of the same thing.  However, I did
> deliberately elect not to try to solve this problem in the accessors.  I
> know all about the register relayout, because 53c700 has to do that on
> parisc.

They aren't.  On some of our platforms, we have to exclusive-or the address
for byte accesses with 3 to convert to the right endian-ness.

Sure, from the point of view of which byte each byte of a word represents,
it's true that they're indentical.  But as far as the hardware is concerned,
they're definitely different.

See the Intel IXP platforms for an example.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
