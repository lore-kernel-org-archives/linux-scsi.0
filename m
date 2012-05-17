From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] pm8001: support HDA (flashless) mode (take 3)
Date: Thu, 17 May 2012 09:12:27 +0800
Message-ID: <0730D1E5D85045B2B496033C92ABA57F@usish.com.cn>
References: <9D3C8933-99C4-45AD-A046-C393A2071F3A@xyratex.com> <6C34E1B4-8631-4CB3-8A8A-B075968F65E6@xyratex.com> <405BE55790F03349A85344435F25B01C06D80942@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <64D0B2A6-A27A-4651-A6F5-CBEC924FB1D2@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:39013 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2EQBMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 21:12:36 -0400
In-Reply-To: <64D0B2A6-A27A-4651-A6F5-CBEC924FB1D2@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, 'Kamaljit Singh' <Kamaljit_Singh@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

Hi James,

No see this patch going into your tree yet, could you consider to inclu=
de
this patch into your tree for mainline.

Jack

> - Take 3 actually moved the file references to
> /lib/firmware/pm8001/*img.bin :-)
> - I have contacted PMC, eventually driven to marketing last year, aft=
er a
few
> conference calls, crickets (they said they would get back to me) afte=
r
they
> understood we wanted these files to be placed on the Linux Firmware
Repository.
> We (Xyratex) were willing to act as PMC's agent for deployment; their
concern
> was getting technical support requests regarding the Firmware directl=
y
from
> the un-washed Customers rather than through the OEMs deploying the ch=
ips
on
> their platforms. I countered with a suggestion of a carefully worded
License
> File in association with the images. I will 'ping' them and see if we=
 can
> escalate this today.
>=20
> -- Mark
>=20
> On May 4, 2012, at 2:16 PM, Kamaljit Singh wrote:
>=20
> > Mark,
> >
> > My comments are at a technical level only.  For IP issues please
consider
> talking to the PMC Marketing team.
> >
> > To avoid potential conflicts across firmware files of other PMC pro=
ducts
you
> may want to create a driver specific directory under /lib/firmware.
> > Additionally, I noticed that /lib/firmware has company specific
directories.
> So here are some suggestions.
> >
> > #1: /lib/firmware/pmcs/pm8001/*.bin.
> > #2: /lib/firmware/pm8001/*.bin.
> >
> >
> > Thanks,
> >
> > Kamaljit Singh
> >
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mark Salyzyn
> > Sent: Friday, May 04, 2012 4:33 AM
> > To: linux-scsi@vger.kernel.org
> > Cc: Mark Salyzyn; Jack Wang; James Bottomley; lindar_liu; =D3=DA=B0=
=AE=BB=AA;
john_gong
> > Subject: [PATCH] pm8001: support HDA (flashless) mode (take 3)
> >
> > Third time IS the charm :-)
> >
> > The pm8001 can be delivered as a standalone product with
flash-programmed
> > firmware images, or without the flash present requiring the driver =
to
upload
> > the images into the chip's RAM and then run. This is called flashle=
ss
HDA
> mode.
> >
> > We add support for this firmware upload in the enclosed patch. We t=
ry
some
> > basic initialization checks of the Firmware, and if it appears dead=
, we
make
> > the assumption the adapter must in-fact be halted in this HDA mode.=
 The
> > Firmware images themselves have not been cleared for open-release b=
y
PMC,
> but
> > they are available in OpenSolaris <hint hint>. PMC's rationalizatio=
n for
not
> > wanting an open-release of the Firmware Images is that they do not =
want
to
> > take support calls except from paying OEMs (such as Xyratex) that a=
re
> embedding
> > PMC product into the motherboards and thus may have a tested combin=
ation
of
> > Firmware and Hardware. Please respect this sentiment. Images are
expected
> in:
> >
> > /lib/firmware/aap1img.bin
> > /lib/firmware/ilaimg.bin
> > /lib/firmware/iopimg.bin
> > /lib/firmware/istrimg.bin
> >
> > using the exact same naming convention as PMC and in OpenSolaris (a=
nd
its
> > followon children) for these image files.
> >
> > Take 2 of the patch, added manifests MAIN_HDA_FLAGS_FORCE_HDA and
> > MAIN_HDA_FLAGS_HDA_FW to check against the bit value of .hda_mode_f=
lag
> > if the SEEPROM is forcing HDA flashless mode.
> >
> > Take 3 of the patch, added hot-plug reset operations, dropped some
> > unnecessary but inert duplicated operations and dropped the firmwar=
e
> > images down one level into /lib/firmware/pm8001/ directory.
> >
> > Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
> > Review-by: Jack Wang <jack_wang@usish.com>
> > Cc: James Bottomley <JBottomley@parallels.com>
> > Cc: lindar_liu@usish.com
> > Cc: crystal_yu@usish.com
> > Cc: john_gong@usish.com
> >
> > drivers/scsi/pm8001/pm8001_hwi.c  |  582
> +++++++++++++++++++++++++++++++++++---
> > drivers/scsi/pm8001/pm8001_hwi.h  |   40 ++
> > drivers/scsi/pm8001/pm8001_init.c |   36 ++
> > drivers/scsi/pm8001/pm8001_sas.h  |    3
> > 4 files changed, 616 insertions(+), 45 deletions(-)
> >
>=20
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No fur=
ther
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and del=
ete
it.
> You may not use, copy, disclose or rely on the information contained =
in
it.
>=20
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. W=
hile
we
> have taken reasonable precautions to ensure that this email is free o=
f
viruses,
> Xyratex does not accept liability for the presence of any computer vi=
ruses
in
> this email, nor for any losses caused as a result of viruses.
>=20
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>=20
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) =
Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limite=
d
> registered in Japan.
> _____________________________________________________________________=
_
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
