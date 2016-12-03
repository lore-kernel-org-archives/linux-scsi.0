From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
Date: Sat, 3 Dec 2016 00:36:32 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1941807694@avsrvexchmbx1.microsemi.net>
References: <1480674973-118250-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0064.outbound.protection.outlook.com ([104.47.34.64]:6864
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753080AbcLCAgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 19:36:47 -0500
In-Reply-To: <1480674973-118250-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, December 02, 2016 4:36 AM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Don Brace; linux-
> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
> Subject: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
>=20
> EXTERNAL EMAIL
>=20
>=20
> Older SmartArray controllers (eg SmartArray 64xx) do
> not support the extended REPORT PHYS command, so
> fallback to use the legacy version here.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 216c137..3783ef6 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3640,8 +3640,32 @@ static int hpsa_scsi_do_report_luns(struct
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
 8;
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

Acked-by: Don Brace <don.brace@microsemi.com>

Note: there has been zero testing on our end of these ancient controllers w=
ith the hpsa driver.
While it might work there is no official support from either us or HPE on t=
his configuration.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation



