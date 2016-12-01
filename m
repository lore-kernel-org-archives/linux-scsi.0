From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
Date: Thu, 1 Dec 2016 21:50:13 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194180126E@avsrvexchmbx1.microsemi.net>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
 <1479454369-100281-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0066.outbound.protection.outlook.com ([104.47.33.66]:56896
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755255AbcLAVu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 16:50:27 -0500
In-Reply-To: <1479454369-100281-3-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Martin Wilck <martin.wilck@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, November 18, 2016 1:33 AM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Don Brace; Martin Wilck; linux-
> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
> Subject: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
>=20
> EXTERNAL EMAIL
>=20
>=20
> Older SmartArray controller do not support the extended REPORT PHYS
> command, so fallback to use the legacy version here.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 488e17c..3d89f74 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3628,8 +3628,32 @@ static int hpsa_scsi_do_report_luns(struct
> ctlr_info *h, int logical,
>  static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
>                 struct ReportExtendedLUNdata *buf, int bufsize)
>  {
> -       return hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
> -                                               HPSA_REPORT_PHYS_EXTENDED=
);
> +       int rc;
> +       struct ReportLUNdata *lbuf;
> +
> +       rc =3D hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
> +                                     HPSA_REPORT_PHYS_EXTENDED);
> +       if (!rc || !hpsa_allow_any)
> +               return rc;
> +
> +       /* REPORT PHYS EXTENDED is not supported */
> +       lbuf =3D kzalloc(sizeof(*lbuf), GFP_KERNEL);
> +       if (!lbuf)
> +               return -ENOMEM;
> +
> +       rc =3D hpsa_scsi_do_report_luns(h, 0, lbuf, sizeof(*lbuf), 0);
> +       if (!rc) {
> +               int i;
> +               u32 nphys;
> +
> +               /* Copy ReportLUNdata header */
> +               memcpy(buf, lbuf, 8);
> +               nphys =3D be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) /=
 24;
> +               for (i =3D 0; i < nphys; i++)
> +                       memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);
> +       }
> +       kfree(lbuf);
> +       return rc;
>  }
>=20
>  static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *h,
> --
> 1.8.5.6

For a non-extended REPORT_PHYS, the buffer size is 8, so the divisor needs =
to be 8.
REPORT_PHYS_EXTENDED has been around a long time, which controller and fw a=
re you testing this on so I can
Also run some tests.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation




