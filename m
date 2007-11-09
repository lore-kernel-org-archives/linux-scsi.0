From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH alternative] [SCSI] aic7xxx: Fix warnings with
 CONFIG_PM=n
Date: Fri, 9 Nov 2007 08:17:51 -0800
Message-ID: <20071109081751.9438e82d.randy.dunlap@oracle.com>
References: <4733A715.70008@oracle.com>
	<1194594944-14277-1-git-send-email-frank@lichtenheld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:38656 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXKIQS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 11:18:58 -0500
In-Reply-To: <1194594944-14277-1-git-send-email-frank@lichtenheld.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Lichtenheld <frank@lichtenheld.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Fri,  9 Nov 2007 08:55:44 +0100 Frank Lichtenheld wrote:

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
> Reorder code as suggested by Randy Dunlap to minimize
> needed #ifdefs
>=20
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>

Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

with one nit:

Warning: trailing whitespace in line 174 of drivers/scsi/aic7xxx/aic7xx=
x_osm_pci.c
Warning: trailing whitespace in lines 131,132 of drivers/scsi/aic7xxx/a=
ic79xx_osm_pci.c

> ---
>  drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   25 +++++++++++++---------=
---
>  drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   25 +++++++++++++---------=
---
>  2 files changed, 26 insertions(+), 24 deletions(-)
>=20
>  > But "ideally" the functions would be defined before the           =
      =20
>  > struct pci_driver data, so the prototypes for them could be remove=
d.
>=20
>  Hmm, I'm a bit sceptical about the reordering, but here you go.
>  Choose whatever you like.
>=20
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/ai=
c7xxx/aic79xx_osm_pci.c
> index 66f0259..f6dbd3e 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> @@ -50,8 +50,6 @@ static int	ahd_linux_pci_reserve_io_regions(struct =
ahd_softc *ahd,
>  static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
>  						 u_long *bus_addr,
>  						 uint8_t __iomem **maddr);
> -static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_messag=
e_t mesg);
> -static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
>  static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
> =20
>  /* Define the macro locally since it's different for different class=
 of chips.
> @@ -85,17 +83,7 @@ static struct pci_device_id ahd_linux_pci_id_table=
[] =3D {
> =20
>  MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
> =20
> -static struct pci_driver aic79xx_pci_driver =3D {
> -	.name		=3D "aic79xx",
> -	.probe		=3D ahd_linux_pci_dev_probe,
>  #ifdef CONFIG_PM
> -	.suspend	=3D ahd_linux_pci_dev_suspend,
> -	.resume		=3D ahd_linux_pci_dev_resume,
> -#endif
> -	.remove		=3D ahd_linux_pci_dev_remove,
> -	.id_table	=3D ahd_linux_pci_id_table
> -};
> -
>  static int
>  ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
>  {
> @@ -139,6 +127,19 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
> =20
>  	return rc;
>  }
> +#else
> +#define ahd_linux_pci_dev_suspend     NULL                          =
                                                                       =
               =20
> +#define ahd_linux_pci_dev_resume      NULL=20
> +#endif
> +
> +static struct pci_driver aic79xx_pci_driver =3D {
> +	.name		=3D "aic79xx",
> +	.probe		=3D ahd_linux_pci_dev_probe,
> +	.suspend	=3D ahd_linux_pci_dev_suspend,
> +	.resume		=3D ahd_linux_pci_dev_resume,
> +	.remove		=3D ahd_linux_pci_dev_remove,
> +	.id_table	=3D ahd_linux_pci_id_table
> +};
> =20
>  static void
>  ahd_linux_pci_dev_remove(struct pci_dev *pdev)
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/ai=
c7xxx/aic7xxx_osm_pci.c
> index 4488946..ab53189 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> @@ -49,8 +49,6 @@ static int	ahc_linux_pci_reserve_io_region(struct a=
hc_softc *ahc,
>  static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
>  						 u_long *bus_addr,
>  						 uint8_t __iomem **maddr);
> -static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_messag=
e_t mesg);
> -static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
>  static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
> =20
>  /* Define the macro locally since it's different for different class=
 of chips.
> @@ -132,17 +130,7 @@ static struct pci_device_id ahc_linux_pci_id_tab=
le[] =3D {
> =20
>  MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
> =20
> -static struct pci_driver aic7xxx_pci_driver =3D {
> -	.name		=3D "aic7xxx",
> -	.probe		=3D ahc_linux_pci_dev_probe,
>  #ifdef CONFIG_PM
> -	.suspend	=3D ahc_linux_pci_dev_suspend,
> -	.resume		=3D ahc_linux_pci_dev_resume,
> -#endif
> -	.remove		=3D ahc_linux_pci_dev_remove,
> -	.id_table	=3D ahc_linux_pci_id_table
> -};
> -
>  static int
>  ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
>  {
> @@ -182,6 +170,19 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
> =20
>  	return (ahc_resume(ahc));
>  }
> +#else
> +#define ahc_linux_pci_dev_suspend     NULL                          =
                                                                       =
              =20
> +#define ahc_linux_pci_dev_resume      NULL
> +#endif
> +
> +static struct pci_driver aic7xxx_pci_driver =3D {
> +	.name		=3D "aic7xxx",
> +	.probe		=3D ahc_linux_pci_dev_probe,
> +	.suspend	=3D ahc_linux_pci_dev_suspend,
> +	.resume		=3D ahc_linux_pci_dev_resume,
> +	.remove		=3D ahc_linux_pci_dev_remove,
> +	.id_table	=3D ahc_linux_pci_id_table
> +};
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
