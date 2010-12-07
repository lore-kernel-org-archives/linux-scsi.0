From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Tue, 07 Dec 2010 09:57:01 -0600
Message-ID: <1291737421.17668.5.camel@mulgrave.site>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-12-08 at 00:31 +0900, Namhyung Kim wrote:
> Annotate dptids as '__used' to fix following warning:
>=20
>   CC      drivers/scsi/dpt_i2o.o
> drivers/scsi/dpt_i2o.c:183: warning: =E2=80=98dptids=E2=80=99 defined=
 but not used
>=20
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
> ---
>  drivers/scsi/dpt_i2o.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index cffcb10..b276077 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -180,7 +180,7 @@ static u8 adpt_read_blink_led(adpt_hba* host)
>   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>   */
> =20
> -static struct pci_device_id dptids[] =3D {
> +static struct pci_device_id dptids[] __used =3D {
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_=
ID,},
>  	{ 0, }

Um so this is definitely used in the MODULE_DEVICE_TABLE just below.

I deduce you have some type of config which causes that to be a nop
(say !CONFIG_MODULE)?  In which case, surely the correct fix is in
module.h?

James
