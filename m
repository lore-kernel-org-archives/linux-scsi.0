From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel 2.9.1-rc1-bk1
 trough rc2-bk12
Date: Sat, 2 Oct 2004 23:25:30 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0410022246140.1977@kai.makisara.local>
References: <13842.1096472870@www69.gmx.net> <1096732158.2169.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:56688 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S267543AbUJBUZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 16:25:32 -0400
In-Reply-To: <1096732158.2169.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Stohr <Alexander.Stohr@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com

On Sat, 2 Oct 2004, James Bottomley wrote:

> On Wed, 2004-09-29 at 11:47, Alexander Stohr wrote:
> > in the beginning it merely looks like this:
> >   kernel: st0: Incorrect block size.
> 
> I think this is the key to the problem.  It looks like some sort of tape
> error.
> 
This is a user error but a normal situation with tapes. The drive is in 
fixed block mode and it encounters a block that is of different size. 
Sense data is returned with the ILI bit set.

I tested this with the following commands:

mt seblk 0
dd of=/dev/nst0 if=linux-2.6.9-rc2.tar.bz2
mt rewi
mt setblk 512
dd if=/dev/nst0 of=pup

dmesg shows the warning about incorrect block size but everything works 
fine. This is with HP C5713A DDS-4 dat and Sym53c1010. The kernel is 
2.6.9-rc3. Note that this kernel contains the spi fixes that fix the 
negotiation problems. Before these fixes my tape drives could not 
negotiate correct speeds (but worked in spite of that, although with 
non-optimal speed).

(I had to use linux-2.6.9-rc2.tar.bz2 instead of linux-2.6.8.tar.gz 
because the latter had odd byte count. The drive is on wide bus and 
sym53c8xx_2 can't do odd transfers on a wide bus. This is a bug that some 
people call a feature. dmesg shows there messages:
sym0:5:0:extraneous data discarded.
sym0:5:0:ODD transfer in DATA OUT phase.
sym0:5:0:COMMAND FAILED (87 0 9).
)

> > then it changed slightly to this:
> >   kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
> >   kernel: sym1:4:0:phase change 6-7 9@37d30f84 resid=6. 
> 
> These are normal messages printed during sym2 negotiation.  The way it
> does negotiation changed recently, so these became more prevalent
> 
> Kai, could you look into this?
> 
> When I haul an old DAT tape out of the cupboard and attach it to a
> sym1010, it all seems to work until I try to manipulate the block size,
> so
> 
You have not manipulated the tape block size but the write() and read() 
byte counts from dd. In variable block mode these are the same as tape 
block size but in fixed block mode they are not the same thing.

> dd of=/dev/nst0 if=linux-2.6.8.tar.gz
> 
> works just fine ... I can read and write to the tape
> 
> dd of=/dev/nst0 if=linux-2.6.8.tar.gz obs=16k
> 
> fails with the kernel message
> 
> st0: Write not multiple of tape block size.
> 
I would like to have a little more details. In order to see this message, 
the tape drive should have been in fixed block mode. By default dd uses 
write() size of 512 bytes. The size of linux-2.6.8.tar.gz is 44678561 
bytes. This is not divisible by 512 and this means that the last write of 
dd is not 512 bytes and the write fails in foxed block mode (it fails in 
my tests). Could you give the exact command sequence leading to the error 
and the result from 'mt status' before this sequence?

Whatever I have tested now, I have not managed to get any messages from 
sym53c8xx_2 (except the odd transfer error but that is transient).

-- 
Kai
