From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch] aic79xx hostraid support
Date: Mon, 23 Aug 2004 09:45:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4129F4E2.10103@adaptec.com>
References: <20040821133214.GA28890@devserv.devel.redhat.com> <20040821142245.GA9151@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33922 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264260AbUHWNpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 09:45:14 -0400
In-Reply-To: <20040821142245.GA9151@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org

Those patches are from the more recent versions of the AIC drivers,
from Justin's website, verbatim but somehow reworked to compile for older
versions of the drivers.

Please don't claim that you wrote it or as your own work.

I've been sent _several_ such patches privately for review.
This seems to be a version of one.

Also, those patches do no allow one to disable probing for
HostRAID drivers, which some users of Linux prefer.

		Luben

Arjan van de Ven wrote:
> On Sat, Aug 21, 2004 at 04:22:06PM +0200, Arjan van de Ven wrote:
>  > Hi,
>  >
>  > Below is a patch ported to 2.6.8 by John A. Hull (john_hull@dell.com) 
> to add
>  > support for the aic79xx hostraid family support. Please consider.
> 
> 
> since AHD_HOSTRAID_BOARD wasn't actually used... a more minimal patch:
> 
> diff -purN linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_osm_pci.c 
> linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> --- linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_osm_pci.c  2004-08-14 
> 07:36:33.000000000 +0200
> +++ linux/drivers/scsi/aic7xxx/aic79xx_osm_pci.c        2004-08-21 
> 15:27:18.902556250 +0200
> @@ -64,6 +64,10 @@ static struct pci_device_id ahd_linux_pc
>                 0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>                 PCI_CLASS_STORAGE_SCSI << 8, 0xFFFF00, 0
>         },
> +       {
> +               0x9005, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> +               PCI_CLASS_STORAGE_RAID << 8, 0xFFFF00, 0
> +       },
>         { 0 }
>  };
>  
> diff -purN linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_pci.c 
> linux/drivers/scsi/aic7xxx/aic79xx_pci.c
> --- linux-2.6.8/drivers/scsi/aic7xxx/aic79xx_pci.c      2004-08-14 
> 07:36:57.000000000 +0200
> +++ linux/drivers/scsi/aic7xxx/aic79xx_pci.c    2004-08-21 
> 15:27:18.903556130 +0200
> @@ -65,10 +65,10 @@ ahd_compose_id(u_int device, u_int vendo
>  }
>  
>  #define ID_ALL_MASK                    0xFFFFFFFFFFFFFFFFull
> -#define ID_ALL_IROC_MASK               0xFFFFFF7FFFFFFFFFull
> +#define ID_ALL_IROC_MASK               0xFF7FFFFFFFFFFFFFull
>  #define ID_DEV_VENDOR_MASK             0xFFFFFFFF00000000ull
>  #define ID_9005_GENERIC_MASK           0xFFF0FFFF00000000ull
> -#define ID_9005_GENERIC_IROC_MASK      0xFFF0FF7F00000000ull
> +#define ID_9005_GENERIC_IROC_MASK      0xFF70FFFF00000000ull
>  
>  #define ID_AIC7901                     0x800F9005FFFF9005ull
>  #define ID_AHA_29320A                  0x8000900500609005ull
> @@ -92,6 +92,8 @@ ahd_compose_id(u_int device, u_int vendo
>  #define ID_AIC7902_PCI_REV_B0          0x10
>  #define SUBID_HP                       0x0E11
>  
> +#define DEVID_9005_HOSTRAID(id) ((id) & 0x80)
> +
>  #define DEVID_9005_TYPE(id) ((id) & 0xF)
>  #define                DEVID_9005_TYPE_HBA             0x0     /* 
> Standard Card */
>  #define                DEVID_9005_TYPE_HBA_2EXT        0x1     /* 2 
> External Ports */
> @@ -134,18 +136,18 @@ struct ahd_pci_identity ahd_pci_ident_ta
>                 "Adaptec 29320ALP Ultra320 SCSI adapter",
>                 ahd_aic7901_setup
>         },
> -       /* aic7901A based controllers */
> +       /* aic7902 based controllers */
>         {
>                 ID_AHA_29320,
>                 ID_ALL_MASK,
>                 "Adaptec 29320 Ultra320 SCSI adapter",
> -               ahd_aic7901A_setup
> +               ahd_aic7902_setup
>         },
>         {
>                 ID_AHA_29320B,
>                 ID_ALL_MASK,
>                 "Adaptec 29320B Ultra320 SCSI adapter",
> -               ahd_aic7901A_setup
> +               ahd_aic7902_setup
>         },
>         {
>                 ID_AHA_29320LP,
> @@ -153,7 +155,6 @@ struct ahd_pci_identity ahd_pci_ident_ta
>                 "Adaptec 29320LP Ultra320 SCSI adapter",
>                 ahd_aic7901A_setup
>         },
> -       /* aic7902 based controllers */
>         {
>                 ID_AHA_39320,
>                 ID_ALL_MASK,
> @@ -196,22 +197,10 @@ struct ahd_pci_identity ahd_pci_ident_ta
>                 "Adaptec (HP OEM) 39320D Ultra320 SCSI adapter",
>                 ahd_aic7902_setup
>         },
> -       {
> -               ID_AHA_29320,
> -               ID_ALL_MASK,
> -               "Adaptec 29320 Ultra320 SCSI adapter",
> -               ahd_aic7902_setup
> -       },
> -       {
> -               ID_AHA_29320B,
> -               ID_ALL_MASK,
> -               "Adaptec 29320B Ultra320 SCSI adapter",
> -               ahd_aic7902_setup
> -       },
>         /* Generic chip probes for devices we don't know 'exactly' */
>         {
> -               ID_AIC7901 & ID_DEV_VENDOR_MASK,
> -               ID_DEV_VENDOR_MASK,
> +               ID_AIC7901 & ID_9005_GENERIC_MASK,
> +               ID_9005_GENERIC_MASK,
>                 "Adaptec AIC7901 Ultra320 SCSI adapter",
>                 ahd_aic7901_setup
>         },
> @@ -294,6 +283,12 @@ ahd_find_pci_device(ahd_dev_softc_t pci)
>                                  subdevice,
>                                  subvendor);
>  
> +       /*
> +        * Controllers, mask out the IROC/HostRAID bit
> +        */
> +      
> +       full_id &= ID_ALL_IROC_MASK;
> +
>         for (i = 0; i < ahd_num_pci_devs; i++) {
>                 entry = &ahd_pci_ident_table[i];
>                 if (entry->full_id == (full_id & entry->id_mask)) {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

