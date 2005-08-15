From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Kernel driver for Adaptec S-ATA 1420SA
Date: Mon, 15 Aug 2005 08:29:08 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F017089A4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:35994 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932297AbVHOMbz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 08:31:55 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, sinister@sinister.cz
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mauelshagen@redhat.com

Partially true regarding RAID cards. We publish sources for all our pro=
cessor based RAID cards (dpt_i2o, aacraid). For the HostRAID cards, the=
 RAID stack is in the driver, we publish the binaries for the one-piece=
 drivers. We released a GPL driver for the HostRAID card as a raw drive=
r + Enhanced md replacement.

As for the chips, depending on which card model, the silicon used for t=
he interface chips could be Adaptec, or it could be from another OEM. T=
here is not much to a SATA chip, remember PATA is but a 74374 latch and=
 the SATA chips simply serialize the same interface. In the case of the=
 1420SA, the SATA core is on Adaptec Silicon (AIC8130), but your guess =
is as good as mine with regards to where that SATA core originated from=
=2E

As for the ata driver, 1420SA has its PCI RAID class bit turned on, ide=
ally you would want to turn that bit off before attaching the raw (none=
-RAID) driver to it. I have yet to get a response back from the H/W or =
BIOS folks about how this can be done; I could not find a 'RAID' tunabl=
e in the add-on BIOS. I expect that the intent was not to compete in th=
e raw SATA environment...

And, when the card has the PCI RAID class bit turned on, this should tr=
igger support for handling the RAID metadata on the drives. The META da=
ta, and support for HostRAID cards, was published in Justin Gibbs emd r=
elease last year. Sadly, in the time it took his team to produce that e=
nhancement to the md product, Linux releases had switched from md to dm=
 and that effort was lost and a new effort has not been started since J=
ustin left Adaptec immediately after the rejection on the RAID list.

The publication of the meta data support has yet to be absorbed by the =
dm or dmraid tools.

Sincerely -- Mark Salyzyn
-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of James Bottomley
Sent: Friday, August 12, 2005 6:02 PM
To: sinister@sinister.cz
Cc: SCSI Mailing List
Subject: Re: Kernel driver for Adaptec S-ATA 1420SA

On Fri, 2005-08-12 at 19:36 +0200, sinister@sinister.cz wrote:
> I bought the Adaptec S-ATA II-1420SA controller but I have a problem=20
> with this type.
> I use the Linux Slackware 10.1 with the Linux Kernel 2.6.12-4 but I=20
> didn=B4t find any driver for this S-ATA controller.
> I don't need RAID but I need a 4x S-ATA port.

Adaptec only publishes binary drivers for it's SATA RAID cards.

The rumour is that Adaptec doesn't make the SATA chips in these, but
OEM's them and then adds Adaptec softraid on top, so theoretically one
of the in-kernel SATA drivers might be able to attach to the OEM chip.
Your best bet would be to ask Adaptec support about it.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
