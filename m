From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel
	2.9.1-rc1-bk1 trough rc2-bk12
Date: 02 Oct 2004 17:50:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096753860.4371.9.camel@mulgrave>
References: <13842.1096472870@www69.gmx.net>
	<1096732158.2169.13.camel@mulgrave>
	<Pine.LNX.4.58.0410022246140.1977@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:40577
	"EHLO redscar") by vger.kernel.org with ESMTP id S267556AbUJBVvD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 17:51:03 -0400
In-Reply-To: <Pine.LNX.4.58.0410022246140.1977@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Alexander Stohr <Alexander.Stohr@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com

On Sat, 2004-10-02 at 16:25, Kai Makisara wrote:
> (I had to use linux-2.6.9-rc2.tar.bz2 instead of linux-2.6.8.tar.gz 
> because the latter had odd byte count. The drive is on wide bus and 
> sym53c8xx_2 can't do odd transfers on a wide bus. This is a bug that some 
> people call a feature. dmesg shows there messages:
> sym0:5:0:extraneous data discarded.
> sym0:5:0:ODD transfer in DATA OUT phase.
> sym0:5:0:COMMAND FAILED (87 0 9).

Yes, I think this is a disagreement over the standards meaning of IGNORE
WIDE RESIDUE between the device and the sym2 driver.

When requesting an odd byte transfer on a wide bus, the sym2 driver
apparently always expects ignore wide residue for the last byte used to
pad the transfer to the bus size.  However, the standards say that if
the last byte is not a discardable pad but legitimate data, the device
doesn't have to send an IGNORE WIDE RESIDUE message (it may discard the
byte at its option, but if it wishes to keep it, the lack of the msg
indicates that the last byte contains valid data).

> I would like to have a little more details. In order to see this message, 
> the tape drive should have been in fixed block mode. By default dd uses 
> write() size of 512 bytes. The size of linux-2.6.8.tar.gz is 44678561 
> bytes. This is not divisible by 512 and this means that the last write of 
> dd is not 512 bytes and the write fails in foxed block mode (it fails in 
> my tests). Could you give the exact command sequence leading to the error 
> and the result from 'mt status' before this sequence?

OK, help me out a little here.  To set the tape to fixed block mode, I
should do a mt setblk?  OK, will try to reproduce.

> Whatever I have tested now, I have not managed to get any messages from 
> sym53c8xx_2 (except the odd transfer error but that is transient).

Same for my tapes...but the DAT is old and narrow bus.

James


