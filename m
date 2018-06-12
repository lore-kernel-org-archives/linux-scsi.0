From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: RE: [PATCH] scsi: bnx2i: add error handling for ioremap_nocache
Date: Tue, 12 Jun 2018 07:50:42 +0000
Message-ID: <MW2PR07MB404280BA7B708DE79A5A07C4E37F0@MW2PR07MB4042.namprd07.prod.outlook.com>
References: <1528773180-37120-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528773180-37120-1-git-send-email-jiazhouyang09@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Zhouyang Jia <jiazhouyang09@gmail.com>
> Sent: Tuesday, June 12, 2018 8:43 AM
> Cc: Zhouyang Jia <jiazhouyang09@gmail.com>; Dept-Eng QLogic Storage
> Upstream <QLogic-Storage-Upstream@cavium.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com=
>;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: bnx2i: add error handling for ioremap_nocache
>=20
> When ioremap_nocache fails, the lack of error-handling code may cause
> unexpected results.
>=20
> This patch adds error-handling code after calling ioremap_nocache.
>=20
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c index
> 8f03a86..e9e669a 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -2727,6 +2727,8 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint
> *ep)
>  					      BNX2X_DOORBELL_PCI_BAR);
>  		reg_off =3D (1 << BNX2X_DB_SHIFT) * (cid_num & 0x1FFFF);
>  		ep->qp.ctx_base =3D ioremap_nocache(reg_base + reg_off, 4);
> +		if (!ep->qp.ctx_base)
> +			return -ENOMEM;
>  		goto arm_cq;
>  	}
>=20
> --
> 2.7.4

Thanks,

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
