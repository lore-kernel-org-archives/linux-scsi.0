From: Jens Schmalzing <jens.schmalzing@physik.uni-muenchen.de>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: 16 Sep 2004 20:34:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <hhllfat64h.fsf@theorie.physik.uni-muenchen.de>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de>
	<20040916141323.GL642@parcelfarce.linux.theplanet.co.uk>
	<hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de>
	<20040916153142.GM642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alsvidh.mathematik.uni-muenchen.de ([129.187.111.42]:16768 "EHLO
	alsvidh.theorie.physik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S268262AbUIPSek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2004 14:34:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org

Hi,

Matthew Wilcox writes:

> > It outputs a "can't map PCI MMIO region" and does nothing at all.

> Interesting.  This can only happen if ioremap() returns NULL.

Sorry.  I got the message completely wrong.  I really was:

| PCI: Enabling device 0000:00:0c.0 (0000 -> 0003)
| sym.0.12.0: MMIO base address disabled.

> lspci -v of that device would be interesting to see.

| 0000:00:0c.0 SCSI storage controller: LSI Logic / Symbios Logic 53c81=
0 (rev 02)
|         Flags: bus master, medium devsel, latency 128, IRQ 13
|         I/O ports at 1000 [size=3D256]
|         [virtual] Memory at c0000000 (32-bit, non-prefetchable) [size=
=3D256]

> > CONFIG_SCSI_SYM53C8XX_2=3Dm
> > CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
> > CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
> > CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
> > # CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

> Those are good config options.

So I used them for a test kernel, built from kernel-source-2.6.8 and
your little debugging patch applied.  What happened is this:

| map 0xc4000000 length 128 returned 0xf4000000

and the kernel initialized the SCSI controller correctly - as I could
verify, this is due to the backported patch from 2.6.9-rc2 that Hollis
Blanchard sent here earlier in Bug#271852.  So that problem will be
solved in the next revision.

Thanks for your time and help.

Regards, Jens.

--=20
J'qbpbe, le m'en fquz pe j'qbpbe!
Le veux aimeb et mqubib panz je p=E9zqbpbe je djuz tqtaj!
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
