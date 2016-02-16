From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] [SCSI] dpt_i2o: fix build warning
Date: Tue, 16 Feb 2016 10:17:06 +0100
Message-ID: <20160216091706.GH18134@c203.arch.suse.de>
References: <1455611856-7009-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455611856-7009-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 16, 2016 at 02:07:36PM +0530, Sudip Mukherjee wrote:
> We were getting build warning about:
> drivers/scsi/dpt_i2o.c:183:29: warning: =E2=80=98dptids=E2=80=99 defi=
ned but not used
>=20
> dptids[] is only used in the MODULE_DEVICE_TABLE so when MODULE is no=
t
> defined then dptids[] becomes unused.

Nah. Care to make a proper pci driver from it instead of plastering yet
another #ifdef in?

>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/scsi/dpt_i2o.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index d4cda5e..21c8d21 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -180,11 +180,14 @@ static u8 adpt_read_blink_led(adpt_hba* host)
>   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>   */
> =20
> +#ifdef MODULE
>  static struct pci_device_id dptids[] =3D {
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_=
ID,},
>  	{ 0, }
>  };
> +#endif
> +
>  MODULE_DEVICE_TABLE(pci,dptids);
> =20
>  static int adpt_detect(struct scsi_host_template* sht)
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
