From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: support HDA (flashless) mode (take 3)
Date: Fri, 4 May 2012 14:27:50 -0400
Message-ID: <64D0B2A6-A27A-4651-A6F5-CBEC924FB1D2@xyratex.com>
References: <9D3C8933-99C4-45AD-A046-C393A2071F3A@xyratex.com> <6C34E1B4-8631-4CB3-8A8A-B075968F65E6@xyratex.com> <405BE55790F03349A85344435F25B01C06D80942@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:33017 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752952Ab2EDS15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 14:27:57 -0400
In-Reply-To: <405BE55790F03349A85344435F25B01C06D80942@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamaljit Singh <Kamaljit_Singh@pmc-sierra.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>, James Bottomley <JBottomley@parallels.com>, lindar_liu <lindar_liu@usish.com>, =?utf-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>, john_gong <john_gong@usish.com>

- Take 3 actually moved the file references to /lib/firmware/pm8001/*im=
g.bin :-)
- I have contacted PMC, eventually driven to marketing last year, after=
 a few conference calls, crickets (they said they would get back to me)=
 after they understood we wanted these files to be placed on the Linux =
=46irmware Repository. We (Xyratex) were willing to act as PMC's agent =
for deployment; their concern was getting technical support requests re=
garding the Firmware directly from the un-washed Customers rather than =
through the OEMs deploying the chips on their platforms. I countered wi=
th a suggestion of a carefully worded License File in association with =
the images. I will 'ping' them and see if we can escalate this today.

-- Mark

On May 4, 2012, at 2:16 PM, Kamaljit Singh wrote:

> Mark,
>=20
> My comments are at a technical level only.  For IP issues please cons=
ider talking to the PMC Marketing team.
>=20
> To avoid potential conflicts across firmware files of other PMC produ=
cts you may want to create a driver specific directory under /lib/firmw=
are. =20
> Additionally, I noticed that /lib/firmware has company specific direc=
tories.  So here are some suggestions.
>=20
> #1: /lib/firmware/pmcs/pm8001/*.bin.
> #2: /lib/firmware/pm8001/*.bin.
>=20
>=20
> Thanks,
>=20
> Kamaljit Singh
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Mark Salyzyn
> Sent: Friday, May 04, 2012 4:33 AM
> To: linux-scsi@vger.kernel.org
> Cc: Mark Salyzyn; Jack Wang; James Bottomley; lindar_liu; =E4=BA=8E=E7=
=88=B1=E5=8D=8E; john_gong
> Subject: [PATCH] pm8001: support HDA (flashless) mode (take 3)
>=20
> Third time IS the charm :-)
>=20
> The pm8001 can be delivered as a standalone product with flash-progra=
mmed
> firmware images, or without the flash present requiring the driver to=
 upload
> the images into the chip's RAM and then run. This is called flashless=
 HDA mode.
>=20
> We add support for this firmware upload in the enclosed patch. We try=
 some
> basic initialization checks of the Firmware, and if it appears dead, =
we make
> the assumption the adapter must in-fact be halted in this HDA mode. T=
he
> Firmware images themselves have not been cleared for open-release by =
PMC, but
> they are available in OpenSolaris <hint hint>. PMC's rationalization =
for not
> wanting an open-release of the Firmware Images is that they do not wa=
nt to
> take support calls except from paying OEMs (such as Xyratex) that are=
 embedding
> PMC product into the motherboards and thus may have a tested combinat=
ion of
> Firmware and Hardware. Please respect this sentiment. Images are expe=
cted in:
>=20
> /lib/firmware/aap1img.bin
> /lib/firmware/ilaimg.bin
> /lib/firmware/iopimg.bin
> /lib/firmware/istrimg.bin
>=20
> using the exact same naming convention as PMC and in OpenSolaris (and=
 its
> followon children) for these image files.
>=20
> Take 2 of the patch, added manifests MAIN_HDA_FLAGS_FORCE_HDA and
> MAIN_HDA_FLAGS_HDA_FW to check against the bit value of .hda_mode_fla=
g
> if the SEEPROM is forcing HDA flashless mode.
>=20
> Take 3 of the patch, added hot-plug reset operations, dropped some
> unnecessary but inert duplicated operations and dropped the firmware
> images down one level into /lib/firmware/pm8001/ directory.
>=20
> Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
> Review-by: Jack Wang <jack_wang@usish.com>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: lindar_liu@usish.com
> Cc: crystal_yu@usish.com
> Cc: john_gong@usish.com
>=20
> drivers/scsi/pm8001/pm8001_hwi.c  |  582 ++++++++++++++++++++++++++++=
+++++++---
> drivers/scsi/pm8001/pm8001_hwi.h  |   40 ++
> drivers/scsi/pm8001/pm8001_init.c |   36 ++
> drivers/scsi/pm8001/pm8001_sas.h  |    3=20
> 4 files changed, 616 insertions(+), 45 deletions(-)
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
