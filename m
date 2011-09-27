From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] target: simplify target_parse_naa_6h_vendor_specific()
Date: Tue, 27 Sep 2011 13:48:44 +0300
Message-ID: <CAHp75Vdp6MpUQKeg1LM3Gn+R21ZfV66dg9Q78QUj=BVLM0t1DQ@mail.gmail.com>
References: <1316413492.3622.91.camel@haakon2.linux-iscsi.org>
	<9d522de8482ec20816be2b68b2d37ab8406f6876.1316419814.git.andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <9d522de8482ec20816be2b68b2d37ab8406f6876.1316419814.git.andriy.shevchenko@linux.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2011 at 11:11 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> =C2=A0drivers/target/target_core_cdb.c | =C2=A0 30 +++++++++++++-----=
------------
> =C2=A01 files changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target=
_core_cdb.c
> index f04d4ef..b796115 100644
> --- a/drivers/target/target_core_cdb.c
> +++ b/drivers/target/target_core_cdb.c
> @@ -24,7 +24,6 @@
> =C2=A0*/
>
> =C2=A0#include <linux/kernel.h>
> -#include <linux/ctype.h>
> =C2=A0#include <asm/unaligned.h>
> =C2=A0#include <scsi/scsi.h>
>
> @@ -156,11 +155,12 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsi=
gned char *buf)
> =C2=A0}
>
> =C2=A0static void
> -target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned =
char *buf_off)
> +target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned =
char *buf)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char *p =3D &dev->se_sub_dev->t10=
_wwn.unit_serial[0];
> - =C2=A0 =C2=A0 =C2=A0 unsigned char *buf =3D buf_off;
> - =C2=A0 =C2=A0 =C2=A0 int cnt =3D 0, next =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 int cnt;
> + =C2=A0 =C2=A0 =C2=A0 bool next =3D true;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Generate up to 36 bits of VENDOR SPECIF=
IC IDENTIFIER starting on
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * byte 3 bit 3-0 for NAA IEEE Registered =
Extended DESIGNATOR field
> @@ -169,20 +169,16 @@ target_parse_naa_6h_vendor_specific(struct se_d=
evice *dev, unsigned char *buf_of
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * NUMBER set via vpd_unit_serial in targe=
t_core_configfs.c to ensure
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * per device uniqeness.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 while (*p !=3D '\0') {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cnt >=3D 13)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!isxdigit(*p))=
 {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p++;
> + =C2=A0 =C2=A0 =C2=A0 for (cnt =3D 0; *p && cnt < 13; next =3D !next=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int val =3D hex_to=
_bin(*p++);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (val < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (next !=3D 0) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt++] |=3D hex_to_bin(*p++);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 next =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt] =3D hex_to_bin(*p++) << 4;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 next =3D 1;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (next)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt++] |=3D val;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 buf[cnt] =3D val << 4;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0}
>

Nicholas, any comment on this?

--=20
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe target-devel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
