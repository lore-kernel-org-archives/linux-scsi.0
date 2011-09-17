From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH-v2] target: Skip non hex characters for VPD=0x83 NAA IEEE
 Registered Extended
Date: Sat, 17 Sep 2011 13:13:43 +0300
Message-ID: <CAHp75VdOjKV_1fBzEsdbmgjo2X-18aKJrMx8ak9+7So1-SLyzQ@mail.gmail.com>
References: <1316202082-17974-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47195 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1IQKNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2011 06:13:44 -0400
In-Reply-To: <1316202082-17974-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <jbottomley@parallels.com>

On Fri, Sep 16, 2011 at 10:41 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds target_parse_naa_6h_vendor_specific() to address a bu=
g where the
> conversion of PRODUCT SERIAL NUMBER to use hex2bin() in target_emulat=
e_evpd_83()
> was not doing proper isxdigit() checking. =C2=A0This conversion of th=
e vpd_unit_serial
> configifs attribute is done while generating a VPD=3D0x83 NAA IEEE Re=
gistered
> Extended DESIGNATOR format's 100 bits of unique VENDOR SPECIFIC IDENT=
IFIER +
> VENDOR SPECIFIC IDENTIFIER EXTENSION area.
>
> This patch allows vpd_unit_serial (VPD=3D0x80) and the T10 Vendor ID =
DESIGNATOR
> format (VPD=3D0x83) to continue to use free-form variable length ASCI=
I values,
> and now skips any non hex characters for fixed length NAA IEEE Regist=
ered Extended
> DESIGNATOR format (VPD=3D0x83) requring the binary conversion.
>
> This was originally reported by Martin after the v3.1-rc1 change to u=
se hex2bin()
> in commit 11650b859681e03fdbf26277fcfc5f1f62186703 where the use of n=
on hex
> characters in vpd_unit_serial generated different values than the ori=
ginal
> v3.0 internal hex -> binary code. =C2=A0This v3.1 change caused a pro=
blem with
> filesystems who write a NAA DESIGNATOR onto it's ondisk metadata, and=
 this patch
> will (again) change existing values to ensure that non hex characters=
 are not
> included in the fixed length NAA DESIGNATOR.
>
> Note this patch still expects vpd_unit_serial to be set via existing =
userspace
> methods of uuid generation, and does not do strict formatting via con=
figfs input.
>
> The original bug report and thread can be found here:
>
> NAA breakage
> http://www.spinics.net/lists/target-devel/msg00477.html
>
> The v3.1-rc1 formatting of VPD=3D0x83 w/o this patch:
>
> VPD INQUIRY: Device Identification page
> =C2=A0Designation descriptor number 1, descriptor length: 20
> =C2=A0 =C2=A0designator_type: NAA, =C2=A0code_set: Binary
> =C2=A0 =C2=A0associated with the addressed logical unit
> =C2=A0 =C2=A0 =C2=A0NAA 6, IEEE Company_id: 0x1405
> =C2=A0 =C2=A0 =C2=A0Vendor Specific Identifier: 0xffde35ebf
> =C2=A0 =C2=A0 =C2=A0Vendor Specific Identifier Extension: 0x3092f498f=
fa820f9
> =C2=A0 =C2=A0 =C2=A0[0x6001405ffde35ebf3092f498ffa820f9]
> =C2=A0Designation descriptor number 2, descriptor length: 56
> =C2=A0 =C2=A0designator_type: T10 vendor identification, =C2=A0code_s=
et: ASCII
> =C2=A0 =C2=A0associated with the addressed logical unit
> =C2=A0 =C2=A0 =C2=A0vendor id: LIO-ORG
> =C2=A0 =C2=A0 =C2=A0vendor specific: IBLOCK:ffde35ec-3092-4980-a820-9=
17636ca54f1
>
> The v3.1-final formatting of VPD=3D0x83 w/ this patch:
>
> VPD INQUIRY: Device Identification page
> =C2=A0Designation descriptor number 1, descriptor length: 20
> =C2=A0 =C2=A0designator_type: NAA, =C2=A0code_set: Binary
> =C2=A0 =C2=A0associated with the addressed logical unit
> =C2=A0 =C2=A0 =C2=A0NAA 6, IEEE Company_id: 0x1405
> =C2=A0 =C2=A0 =C2=A0Vendor Specific Identifier: 0xffde35ec3
> =C2=A0 =C2=A0 =C2=A0Vendor Specific Identifier Extension: 0x924980a82=
091763
> =C2=A0 =C2=A0 =C2=A0[0x6001405ffde35ec30924980a82091763]
> =C2=A0Designation descriptor number 2, descriptor length: 56
> =C2=A0 =C2=A0designator_type: T10 vendor identification, =C2=A0code_s=
et: ASCII
> =C2=A0 =C2=A0associated with the addressed logical unit
> =C2=A0 =C2=A0 =C2=A0vendor id: LIO-ORG
> =C2=A0 =C2=A0 =C2=A0vendor specific: IBLOCK:ffde35ec-3092-4980-a820-9=
17636ca54f1
>
> (v2: Fix parsing code to dereference + check for string terminator in=
stead
> =C2=A0 =C2=A0 of null pointer to ensure a zeroed payload for vpd_unit=
_serial less
> =C2=A0 =C2=A0 than 100 bits of NAA DESIGNATOR VENDOR SPECIFIC area. =C2=
=A0Also, remove
> =C2=A0 =C2=A0 the unnecessary bitwise assignment)
>
> Reported-by: Martin Svec <martin.svec@zoner.cz>
> Cc: Martin Svec <martin.svec@zoner.cz>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: James Bottomley <jbottomley@parallels.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> =C2=A0drivers/target/target_core_cdb.c | =C2=A0 35 ++++++++++++++++++=
+++++++++++++++--
> =C2=A01 files changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target=
_core_cdb.c
> index 89ae923..f04d4ef 100644
> --- a/drivers/target/target_core_cdb.c
> +++ b/drivers/target/target_core_cdb.c
> @@ -24,6 +24,7 @@
> =C2=A0*/
>
> =C2=A0#include <linux/kernel.h>
> +#include <linux/ctype.h>
> =C2=A0#include <asm/unaligned.h>
> =C2=A0#include <scsi/scsi.h>
>
> @@ -154,6 +155,37 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsig=
ned char *buf)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> +static void
> +target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned =
char *buf_off)
> +{
> + =C2=A0 =C2=A0 =C2=A0 unsigned char *p =3D &dev->se_sub_dev->t10_wwn=
=2Eunit_serial[0];
> + =C2=A0 =C2=A0 =C2=A0 unsigned char *buf =3D buf_off;
> + =C2=A0 =C2=A0 =C2=A0 int cnt =3D 0, next =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Generate up to 36 bits of VENDOR SPECI=
=46IC IDENTIFIER starting on
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* byte 3 bit 3-0 for NAA IEEE Registered=
 Extended DESIGNATOR field
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* format, followed by 64 bits of VENDOR =
SPECIFIC IDENTIFIER EXTENSION
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* to complete the payload. =C2=A0These a=
re based from VPD=3D0x80 PRODUCT SERIAL
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* NUMBER set via vpd_unit_serial in targ=
et_core_configfs.c to ensure
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* per device uniqeness.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 while (*p !=3D '\0') {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cnt >=3D 13)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!isxdigit(*p))=
 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (next !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt++] |=3D hex_to_bin(*p++);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 next =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt] =3D hex_to_bin(*p++) << 4;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 next =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
May be I am late, but I think the above code looks a bit complicated.

Why not do the function like this:

static void
target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned cha=
r *buf)
{
       unsigned char *p =3D &dev->se_sub_dev->t10_wwn.unit_serial[0];
       int cnt;
       bool next =3D true;

       for (cnt =3D 0; *p && cnt < 13; next =3D !next) {
               int val =3D hex_to_bin(*p++);

               if (val < 0)
                       continue;

               if (next)
                       buf[cnt++] |=3D val;
               else
                       buf[cnt] =3D val << 4;
       }
}


--=20
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
