From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: iomapping a big endian area
Date: Tue, 05 Apr 2005 09:05:15 -0500
Message-ID: <1112709915.5764.4.camel@mulgrave>
References: <1112475134.5786.29.camel@mulgrave>
	 <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
	 <20050402183805.20a0cf49.davem@davemloft.net>
	 <20050403031000.GC24234@parcelfarce.linux.theplanet.co.uk>
	 <1112499639.5786.34.camel@mulgrave>
	 <20050405084219.A21615@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29314 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261749AbVDEOGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 10:06:12 -0400
In-Reply-To: <20050405084219.A21615@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-04-05 at 08:42 +0100, Russell King wrote:
> Not so.  There are two different styles of big endian.  (Lets just face
> it, BE is fucked in the head anyway...)
> 
> physical bus:	31...24	23...16	15...8	7...0
> 
> BE version 1 (word invariant)
>   byte access	byte 0	byte 1	byte 2	byte 3
>   word access	31-24	23-16	15-8	7-0
> 
> BE version 2 (byte invariant)
>   byte access	byte 3	byte 2	byte 1	byte 0
>   word access	7-0	15-8	23-16	31-24

These are just representations of the same thing.  However, I did
deliberately elect not to try to solve this problem in the accessors.  I
know all about the register relayout, because 53c700 has to do that on
parisc.

However, I don't think it's the job of the io accessors to remap the
register locations (primarily because the remapping depends on the
documentation:  a chip that's documented as BE on BE has no remapping
required.  Hoever, the same chip on LE would need this).


> And guess which architecture implements *both* of these...  Grumble.

We have this in parisc too ...

James


