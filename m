From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: iomapping a big endian area
Date: Tue, 5 Apr 2005 08:42:19 +0100
Message-ID: <20050405084219.A21615@flint.arm.linux.org.uk>
References: <1112475134.5786.29.camel@mulgrave> <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk> <20050402183805.20a0cf49.davem@davemloft.net> <20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk> <1112499639.5786.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:54796 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S261600AbVDEHm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 03:42:29 -0400
Content-Disposition: inline
In-Reply-To: <1112499639.5786.34.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 02, 2005 at 09:40:39PM -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sat, Apr 02, 2005 at 09:40:39PM -0600, James Bottomley wrote:
> On Sun, 2005-04-03 at 04:10 +0100, Matthew Wilcox wrote:
> > > SPARC64 can do it in the PTEs, but we just use raw physical
> > > addresses in our I/O accessors, and in those load/store instructions
> > > we can specify the endianness.
> > 
> > Ah right.  So you'd prefer an ioread8be() interface?
> 
> Actually, ioread8be is unnecessary, but I was planning to add
> ioread16/ioread32 and iowritexx be on be variants (equivalent to
> _raw_readw et al.)

Not so.  There are two different styles of big endian.  (Lets just face
it, BE is fucked in the head anyway...)

physical bus:	31...24	23...16	15...8	7...0

BE version 1 (word invariant)
  byte access	byte 0	byte 1	byte 2	byte 3
  word access	31-24	23-16	15-8	7-0

BE version 2 (byte invariant)
  byte access	byte 3	byte 2	byte 1	byte 0
  word access	7-0	15-8	23-16	31-24

Depending on this and how your devices are wired up to such a bus, you
may need to swap bytes in a word access, or munge the byte/half word
address itself.

And guess which architecture implements *both* of these...  Grumble.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
