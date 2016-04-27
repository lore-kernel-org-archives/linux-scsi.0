From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 09/10] aacraid: Fix for KDUMP driver hang
Date: Wed, 27 Apr 2016 11:29:43 +0200
Message-ID: <20160427092943.GF2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063237.28402.20267.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcD0J3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 05:29:53 -0400
Content-Disposition: inline
In-Reply-To: <20160426063237.28402.20267.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com

On Mon, Apr 25, 2016 at 11:32:37PM -0700, Raghava Aditya Renukunta wrot=
e:
> When KDUMP is triggered the driver first talks to the firmware in INT=
X
> mode, but the adapter firmware is still in MSIX mode. Therefore the f=
irst
> driver command hangs since the driver is waiting for an INTX response=
 and
> firmware gives a MSIX response. If when the OS is installed on a RAID
> drive created by the adapter KDUMP will hang since the driver does no=
t
> receive a response in sync mode.
>=20
> Fixed by: Change the firmware to INTX mode if it is in MSIX mode befo=
re
> sending the first sync command.
> Cc: stable@vger.kernel.org
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@micr=
osemi.com>
> ---
>  drivers/scsi/aacraid/aacraid.h  |    1 +
>  drivers/scsi/aacraid/comminit.c |   24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index b70f3eb..0ba8f61 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -29,6 +29,7 @@ enum {
>  #define AAC_INT_MODE_MSI		(1<<1)
>  #define AAC_INT_MODE_AIF		(1<<2)
>  #define AAC_INT_MODE_SYNC		(1<<3)
> +#define AAC_INT_MODE_MSIX		(1<<16)
> =20
>  #define AAC_INT_ENABLE_TYPE1_INTX	0xfffffffb
>  #define AAC_INT_ENABLE_TYPE1_MSIX	0xfffffffa
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/c=
omminit.c
> index 50d521a..341ea32 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -37,6 +37,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/delay.h>
>  #include <linux/completion.h>
>  #include <linux/mm.h>
>  #include <scsi/scsi_host.h>
> @@ -47,6 +48,20 @@ struct aac_common aac_config =3D {
>  	.irq_mod =3D 1
>  };
> =20
> +static inline int aac_is_msix_mode(struct aac_dev *dev)
> +{
> +	u32 status;
> +
> +	status =3D src_readl(dev, MUnit.OMR);
> +	return (status & AAC_INT_MODE_MSIX);
> +}
> +
> +static inline void aac_change_to_intx(struct aac_dev *dev)
> +{
> +	aac_src_access_devreg(dev, AAC_DISABLE_MSIX);
> +	aac_src_access_devreg(dev, AAC_ENABLE_INTX);

I don't know your adpater firmware, but isn't it possible to loose inte=
rrupts
this way or do they get queued?=20

> +}
> +
>  static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsi=
gned long commsize, unsigned long commalign)
>  {
>  	unsigned char *base;
> @@ -414,6 +429,15 @@ struct aac_dev *aac_init_adapter(struct aac_dev =
*dev)
>  	dev->comm_interface =3D AAC_COMM_PRODUCER;
>  	dev->raw_io_interface =3D dev->raw_io_64 =3D 0;
> =20
> +
> +	/*
> +	 * Enable INTX mode, if not done already Enabled
> +	 */
> +	if (aac_is_msix_mode(dev)) {
> +		aac_change_to_intx(dev);
> +		dev_info(&dev->pdev->dev, "Changed firmware to INTX mode");
> +	}
> +
>  	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
>  		0, 0, 0, 0, 0, 0,
>  		status+0, status+1, status+2, status+3, NULL)) &&
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
