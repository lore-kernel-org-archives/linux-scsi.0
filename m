From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Tue, 11 Feb 2014 09:32:11 +0100
Message-ID: <52F9E00B.7070707@suse.de>
References: <1392030699-105348-1-git-send-email-hare@suse.de> <52F91535.4010905@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaBKIcN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 03:32:13 -0500
In-Reply-To: <52F91535.4010905@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 02/10/2014 07:06 PM, Jeremy Linton wrote:
> On 2/10/2014 5:11 AM, Hannes Reinecke wrote:
>> EVPD page 0x83 is used to uniquely identify the device. So instead o=
f
>> having each and every program issue a separate SG_IO call to retriev=
e this
>> information it does make far more sense to display it in sysfs.
>=20
> Tested-by: Jeremy Linton <jlinton@tributary.com>
>=20
> 	So, I just ran it in 3.14-rc2. No OOPS, that is good. It even surviv=
ed
> probing a SPC-2 device without a page 0x83.
>=20
> I tested it with a fairly narrow set of devices, a couple IBM librari=
es with
> LTO/359x and a VTL.
>=20
> I did notice this on an old IBM raid adapter running in the machine
>=20
> cat: ident_lun_scsi_name: Invalid argument
>=20
> (that came from this device)
> sg_inq --page=3D0x83 --hex /dev/sg2
> VPD INQUIRY, page code=3D0x83:
>  00     00 83 00 48 01 03 00 08  50 01 0b 90 00 12 1d 90    ...H....P=
=2E......
>  10     61 93 00 08 50 01 0b 90  00 12 1d 8e 61 94 00 04    a...P....=
=2E..a...
>  20     00 00 00 01 61 a3 00 08  50 01 0b 90 00 12 1d 8d    ....a...P=
=2E......
>  30     63 a8 00 18 6e 61 61 2e  35 30 30 31 30 42 39 30    c...naa.5=
0010B90
>  40     30 30 31 32 31 44 38 44  00 00 00 00                00121D8D.=
=2E..
>=20
Yeah, correct. The selection algorithm is a tad flawed. I'll be
fixing it up.

> And there may be a couple descriptors missing here and there. For exa=
mple
> 3592E05 is missing the total port count (I think).
>=20
> VPD INQUIRY, page code=3D0x83:
>  00     01 83 00 5c 02 01 00 24  49 42 4d 20 20 20 20 20    ...\...$I=
BM
>  10     30 33 35 39 32 45 30 35  20 20 20 20 20 20 20 20    03592E05
>  20     30 30 30 30 30 37 38 33  36 33 32 33 01 03 00 08    000007836=
323....
>  30     50 05 07 63 02 41 0c 2c  01 13 00 08 50 05 07 63    P..c.A.,.=
=2E..P..c
>  40     02 81 0c 2c 01 14 00 04  00 00 00 02 01 23 00 08    ...,.....=
=2E...#..
>  50     50 05 07 63 02 41 0c 2c  01 24 00 04 00 00 00 01    P..c.A.,.=
$......
>=20
> /sys/class/scsi_tape/nst14/device # ls ident_*
> ident_lun_naa  ident_lun_t10  ident_port_naa  ident_port_relport  ide=
nt_target_naa
>=20
Well, yes, it does, as the missing ident is this:
01 24 00 04 00 00 00 01

Which decodes as 'Association: Target', 'Designator: Relative target
port identifier', and is not defined as per spec
(and it doesn't make sense to boot).

As you might've seen I've included only the valid/defined
association/designator combinations in the patch.

>=20
>=20
>=20
> This almost seems like a case where exporting the raw 0x83 data may b=
e better...
>=20
Hmm. I'd rather have the actual strings in sysfs; the whole idea of
this patch was to have strings in sysfs which can be read directly.
Having a binary blob only requires you to have yet another tool for
parsing that data.

And for XCOPY we need the descriptor anyway, so at one point we need
to parse this.

But OTOH there's no reason why we _shouldn't_ export it to sysfs
directly. So let's do both.

>=20
> Also, as I stated previously, my personal bias is to include the page=
 0x80
> serial number data for tape devices as well. That seems to be the mos=
t
> reliable. Mostly because a lot of the VTLs now just give you the same
> wwnn/wwpn in 0x83 for multiple LUNs. Meaning you can't uniquely ident=
ify the
> device over different physical ports.
>=20
The problem with page 0x80 is that (per spec) it's vendor-defined.
So there is no guarantee for it to be unique in any sense.
Which makes it rather impractical for normal use.

Hence we typically rely on page 0x83 to identify a device, be it for
udev or multipath.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
