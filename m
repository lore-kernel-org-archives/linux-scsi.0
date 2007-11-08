From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [SCSI] aic7xxx: Fix warnings with CONFIG_PM=n
Date: Thu, 8 Nov 2007 15:58:34 -0800
Message-ID: <20071108155834.7751f2f6.randy.dunlap@oracle.com>
References: <1194563028-19364-1-git-send-email-frank@lichtenheld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet02.oracle.com ([148.87.113.119]:58983 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbXKICPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 21:15:34 -0500
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id lA90Ek7o014590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Nov 2007 17:14:47 -0700
In-Reply-To: <1194563028-19364-1-git-send-email-frank@lichtenheld.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Lichtenheld <frank@lichtenheld.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, trivial@kernel.org

On Fri,  9 Nov 2007 00:03:48 +0100 Frank Lichtenheld wrote:

> Fixes the following warnings:
>   CC [M]  drivers/scsi/aic7xxx/aic79xx_osm_pci.o
> drivers/scsi/aic7xxx/aic79xx_osm_pci.c:101: warning: =E2=80=98ahd_lin=
ux_pci_dev_suspend=E2=80=99 defined but not used
> drivers/scsi/aic7xxx/aic79xx_osm_pci.c:121: warning: =E2=80=98ahd_lin=
ux_pci_dev_resume=E2=80=99 defined but not used
>=20
>   CC [M]  drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
> drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:148: warning: =E2=80=98ahc_lin=
ux_pci_dev_suspend=E2=80=99 defined but not used
> drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:166: warning: =E2=80=98ahc_lin=
ux_pci_dev_resume=E2=80=99 defined but not used
>=20
> Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
> ---
>  drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    4 ++++
>  drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)

Hi,
The preferred method of fixing this type of warning is to
(warning, not a full patch here):

a.  change the struct pci_driver not to use #ifdef CONFIG_PM/#endif;
instead, it always says:

	.suspend	=3D ahd_linux_pci_dev_suspend,
	.resume		=3D ahd_linux_pci_dev_resume,

and those pointers are built depending on CONFIG_PM like so:

#ifdef CONFIG_PM
	... functions as they are now ...
#else
#define ahd_linux_pci_dev_suspend	NULL
#define ahd_linux_pci_dev_resume	NULL
#endif

so the ifdef/endif blocks are localized to one place in each driver.


> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/ai=
c7xxx/aic79xx_osm_pci.c
> index 66f0259..36d7618 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> @@ -50,8 +50,10 @@ static int	ahd_linux_pci_reserve_io_regions(struct=
 ahd_softc *ahd,
>  static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
>  						 u_long *bus_addr,
>  						 uint8_t __iomem **maddr);
> +#ifdef CONFIG_PM
>  static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_messag=
e_t mesg);
>  static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
> +#endif
>  static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
> =20
>  /* Define the macro locally since it's different for different class=
 of chips.
> @@ -96,6 +98,7 @@ static struct pci_driver aic79xx_pci_driver =3D {
>  	.id_table	=3D ahd_linux_pci_id_table
>  };
> =20
> +#ifdef CONFIG_PM
>  static int
>  ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
>  {
> @@ -139,6 +142,7 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
> =20
>  	return rc;
>  }
> +#endif
> =20
>  static void
>  ahd_linux_pci_dev_remove(struct pci_dev *pdev)
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/ai=
c7xxx/aic7xxx_osm_pci.c
> index 4488946..212c2c8 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> @@ -49,8 +49,10 @@ static int	ahc_linux_pci_reserve_io_region(struct =
ahc_softc *ahc,
>  static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
>  						 u_long *bus_addr,
>  						 uint8_t __iomem **maddr);
> +#ifdef CONFIG_PM
>  static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_messag=
e_t mesg);
>  static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
> +#endif
>  static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
> =20
>  /* Define the macro locally since it's different for different class=
 of chips.
> @@ -143,6 +145,7 @@ static struct pci_driver aic7xxx_pci_driver =3D {
>  	.id_table	=3D ahc_linux_pci_id_table
>  };
> =20
> +#ifdef CONFIG_PM
>  static int
>  ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
>  {
> @@ -182,6 +185,7 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
> =20
>  	return (ahc_resume(ahc));
>  }
> +#endif
> =20
>  static void
>  ahc_linux_pci_dev_remove(struct pci_dev *pdev)
> --=20


---
~Randy
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
