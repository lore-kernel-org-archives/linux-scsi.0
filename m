From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel
	2.9.1-rc1-bk1 trough rc2-bk12
Date: 02 Oct 2004 11:49:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096732158.2169.13.camel@mulgrave>
References: <13842.1096472870@www69.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:29156
	"EHLO redscar") by vger.kernel.org with ESMTP id S266835AbUJBPtW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 11:49:22 -0400
In-Reply-To: <13842.1096472870@www69.gmx.net>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Stohr <Alexander.Stohr@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Wed, 2004-09-29 at 11:47, Alexander Stohr wrote:
> in the beginning it merely looks like this:
>   kernel: st0: Incorrect block size.

I think this is the key to the problem.  It looks like some sort of tape
error.

> then it changed slightly to this:
>   kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
>   kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 

These are normal messages printed during sym2 negotiation.  The way it
does negotiation changed recently, so these became more prevalent

Kai, could you look into this?

When I haul an old DAT tape out of the cupboard and attach it to a
sym1010, it all seems to work until I try to manipulate the block size,
so

dd of=/dev/nst0 if=linux-2.6.8.tar.gz

works just fine ... I can read and write to the tape

dd of=/dev/nst0 if=linux-2.6.8.tar.gz obs=16k

fails with the kernel message

st0: Write not multiple of tape block size.

And then I start to get errors from the tape device.

It looks like the block size setting has been broken somehow.

James


