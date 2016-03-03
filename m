From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mvumi: fix build warning
Date: Thu, 3 Mar 2016 14:28:37 +0100
Message-ID: <20160303132837.GM25301@c203.arch.suse.de>
References: <1457010413-12809-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457010413-12809-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 03, 2016 at 06:36:53PM +0530, Sudip Mukherjee wrote:
> While building tilepro allmodconfig we were getting build warning:
> drivers/scsi/mvumi.c:2632:12: warning: 'mvumi_suspend' defined but no=
t used
> drivers/scsi/mvumi.c:2651:12: warning: 'mvumi_resume' defined but not=
 used
>=20
> mvumi_suspend() and mvumi_resume() are only used when CONFIG_PM is
> defined as mentioned in the mvumi_pci_driver.=09
>=20
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/scsi/mvumi.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 02360de..d9d0736 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -2629,6 +2629,7 @@ static void mvumi_shutdown(struct pci_dev *pdev=
)
>  	mvumi_flush_cache(mhba);
>  }
> =20
> +#ifdef CONFIG_PM
>  static int mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	struct mvumi_hba *mhba =3D NULL;
> @@ -2716,6 +2717,7 @@ fail:
> =20
>  	return ret;
>  }
> +#endif
> =20
>  static struct pci_driver mvumi_pci_driver =3D {
> =20
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There was a patch from Arnd earlier this day addressing this as well wi=
th a
__maybe_unused. You might want to have a look at this one
https://lkml.org/lkml/2016/3/2/497

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
