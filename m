From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [patch] [SCSI] scsi_pm: passing wrong pointer to resume()
Date: Sat, 19 May 2012 11:38:21 +0800
Message-ID: <20120519033821.GA2425@localhost.localdomain>
References: <20120518140827.GA1584@elgon.mountain>
 <2FB252790F768E479D722B6F9B6D68C4B03E50@SCYBEXDAG02.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ESDic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 23:38:32 -0400
Content-Disposition: inline
In-Reply-To: <2FB252790F768E479D722B6F9B6D68C4B03E50@SCYBEXDAG02.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

> From: Dan Carpenter [dan.carpenter@oracle.com]
> To: James E.J. Bottomley; Lu, Aaron
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-=
janitors@vger.kernel.org; Alan Stern
> Subject: [patch] [SCSI] scsi_pm: passing wrong pointer to resume()
>=20
> This gets caught by GCC:
> drivers/scsi/scsi_pm.c:30:5: warning: passing argument 1 of
>         =E2=80=98scsi_device_resume=E2=80=99 from incompatible pointe=
r type
>         [enabled by default]

Thanks for pointing this out.
I've posted v2 the other day and James is aware of this already:
http://marc.info/?l=3Dlinux-scsi&m=3D133706440112890&w=3D2

>=20
> It probably would have been caught in testing as well, but it's on an
> error path.

I'm dealing with such error so developed this patch. But there are othe=
r
changes too in my code, so I prepared this patch in another clean repo
and made the mistake, sorry for not testing it before submit.=20

-Aaron

>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I haven't tested this.  :/  Sorry for that.
>=20
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 9bd2c41..d4201de 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -27,7 +27,7 @@ static int scsi_dev_type_suspend(struct device *dev=
, pm_message_t msg)
>                 if (drv && drv->suspend) {
>                         err =3D drv->suspend(dev, msg);
>                         if (err)
> -                               scsi_device_resume(dev);
> +                               scsi_device_resume(to_scsi_device(dev=
));
>                 }
>         }
>         dev_dbg(dev, "scsi suspend: %d\n", err);
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
