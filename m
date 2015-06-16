From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 6/9] [SCSI] aacraid: Reset irq affinity hints before
 releasing irq
Date: Tue, 16 Jun 2015 13:40:17 +0200
Message-ID: <20150616114017.GD2883@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbbFPLkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2015 07:40:20 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:28PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Description:
>         Reset irq affinity hints before releasing IRQ
>         Removed duplicate code of IRQ acquire/release
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/aacraid.h |   2 +
>  drivers/scsi/aacraid/commsup.c | 113 ++++++++++++++++++++++++++++++-=
----------
>  drivers/scsi/aacraid/src.c     |  48 ++---------------
>  3 files changed, 88 insertions(+), 75 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index e54f597..7b95227 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2110,6 +2110,8 @@ static inline unsigned int cap_to_cyls(sector_t=
 capacity, unsigned divisor)
>  #define AAC_OWNER_ERROR_HANDLER	0x103
>  #define AAC_OWNER_FIRMWARE	0x106
> =20
> +int aac_acquire_irq(struct aac_dev *dev);
> +void aac_free_irq(struct aac_dev *dev);
>  const char *aac_driverinfo(struct Scsi_Host *);
>  struct fib *aac_fib_alloc(struct aac_dev *dev);
>  int aac_fib_setup(struct aac_dev *dev);
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/co=
mmsup.c
> index 4da5749..a1f90fe 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1270,13 +1270,12 @@ retry_next:
>  static int _aac_reset_adapter(struct aac_dev *aac, int forced)
>  {
>  	int index, quirks;
> -	int retval, i;
> +	int retval;
>  	struct Scsi_Host *host;
>  	struct scsi_device *dev;
>  	struct scsi_cmnd *command;
>  	struct scsi_cmnd *command_list;
>  	int jafo =3D 0;
> -	int cpu;
> =20
>  	/*
>  	 * Assumptions:
> @@ -1339,35 +1338,7 @@ static int _aac_reset_adapter(struct aac_dev *=
aac, int forced)
>  	aac->comm_phys =3D 0;
>  	kfree(aac->queues);
>  	aac->queues =3D NULL;
> -	cpu =3D cpumask_first(cpu_online_mask);
> -	if (aac->pdev->device =3D=3D PMC_DEVICE_S6 ||
> -	    aac->pdev->device =3D=3D PMC_DEVICE_S7 ||
> -	    aac->pdev->device =3D=3D PMC_DEVICE_S8 ||
> -	    aac->pdev->device =3D=3D PMC_DEVICE_S9) {
> -		if (aac->max_msix > 1) {
> -			for (i =3D 0; i < aac->max_msix; i++) {
> -				if (irq_set_affinity_hint(
> -				    aac->msixentry[i].vector,
> -				    NULL)) {
> -					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\=
n",
> -						aac->name,
> -						aac->id,
> -						cpu);
> -				}
> -				cpu =3D cpumask_next(cpu,
> -						cpu_online_mask);
> -				free_irq(aac->msixentry[i].vector,
> -					 &(aac->aac_msix[i]));
> -			}
> -			pci_disable_msix(aac->pdev);
> -		} else {
> -			free_irq(aac->pdev->irq, &(aac->aac_msix[0]));
> -		}
> -	} else {
> -		free_irq(aac->pdev->irq, aac);
> -	}
> -	if (aac->msi)
> -		pci_disable_msi(aac->pdev);
> +	aac_free_irq(aac);
>  	kfree(aac->fsa_dev);
>  	aac->fsa_dev =3D NULL;
>  	quirks =3D aac_get_driver_ident(index)->quirks;
> @@ -1978,3 +1949,83 @@ int aac_command_thread(void *data)
>  	dev->aif_thread =3D 0;
>  	return 0;
>  }
> +
> +int aac_acquire_irq(struct aac_dev *dev)
> +{
> +	int i;
> +	int j;
> +	int ret =3D 0;
> +	int cpu;
> +
> +	cpu =3D cpumask_first(cpu_online_mask);
> +	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
> +		for (i =3D 0; i < dev->max_msix; i++) {
> +			dev->aac_msix[i].vector_no =3D i;
> +			dev->aac_msix[i].dev =3D dev;
> +			if (request_irq(dev->msixentry[i].vector,
> +					dev->a_ops.adapter_intr,
> +					0, "aacraid", &(dev->aac_msix[i]))) {
> +				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
> +						dev->name, dev->id, i);
> +				for (j =3D 0 ; j < i ; j++)
> +					free_irq(dev->msixentry[j].vector,
> +						 &(dev->aac_msix[j]));
> +				pci_disable_msix(dev->pdev);
> +				ret =3D -1;
> +			}
> +			if (irq_set_affinity_hint(dev->msixentry[i].vector,
> +							get_cpu_mask(cpu))) {
> +				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
> +					    dev->name, dev->id, cpu);
> +			}
> +			cpu =3D cpumask_next(cpu, cpu_online_mask);
> +		}
> +	} else {
> +		dev->aac_msix[0].vector_no =3D 0;
> +		dev->aac_msix[0].dev =3D dev;
> +
> +		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> +			IRQF_SHARED, "aacraid",
> +			&(dev->aac_msix[0])) < 0) {
> +			if (dev->msi)
> +				pci_disable_msi(dev->pdev);
> +			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
> +					dev->name, dev->id);
> +			ret =3D -1;
> +		}
> +	}
> +	return ret;
> +}
> +
> +void aac_free_irq(struct aac_dev *dev)
> +{
> +	int i;
> +	int cpu;
> +
> +	cpu =3D cpumask_first(cpu_online_mask);
> +	if (dev->pdev->device =3D=3D PMC_DEVICE_S6 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S9) {
> +		if (dev->max_msix > 1) {
> +			for (i =3D 0; i < dev->max_msix; i++) {
> +				if (irq_set_affinity_hint(
> +					dev->msixentry[i].vector, NULL)) {
> +					printk(KERN_ERR "%s%d: Failed to reset IRQ affinity for cpu %d\=
n",
> +					    dev->name, dev->id, cpu);
> +				}
> +				cpu =3D cpumask_next(cpu, cpu_online_mask);
> +				free_irq(dev->msixentry[i].vector,
> +						&(dev->aac_msix[i]));
> +			}
> +		} else {
> +			free_irq(dev->pdev->irq, &(dev->aac_msix[0]));
> +		}
> +	} else {
> +		free_irq(dev->pdev->irq, dev);
> +	}
> +	if (dev->msi)
> +		pci_disable_msi(dev->pdev);
> +	else if (dev->max_msix > 1)
> +		pci_disable_msix(dev->pdev);
> +}
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 1409a0b..2aa34ea 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -798,9 +798,7 @@ int aac_srcv_init(struct aac_dev *dev)
>  	unsigned long status;
>  	int restart =3D 0;
>  	int instance =3D dev->id;
> -	int i, j;
>  	const char *name =3D dev->name;
> -	int cpu;
> =20
>  	dev->a_ops.adapter_ioremap =3D aac_srcv_ioremap;
>  	dev->a_ops.adapter_comm =3D aac_src_select_comm;
> @@ -918,48 +916,10 @@ int aac_srcv_init(struct aac_dev *dev)
>  		goto error_iounmap;
>  	if (dev->msi_enabled)
>  		aac_src_access_devreg(dev, AAC_ENABLE_MSIX);
> -	if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) {
> -		cpu =3D cpumask_first(cpu_online_mask);
> -		for (i =3D 0; i < dev->max_msix; i++) {
> -			dev->aac_msix[i].vector_no =3D i;
> -			dev->aac_msix[i].dev =3D dev;
> -
> -			if (request_irq(dev->msixentry[i].vector,
> -					dev->a_ops.adapter_intr,
> -					0,
> -					"aacraid",
> -					&(dev->aac_msix[i]))) {
> -				printk(KERN_ERR "%s%d: Failed to register IRQ for vector %d.\n",
> -						name, instance, i);
> -				for (j =3D 0 ; j < i ; j++)
> -					free_irq(dev->msixentry[j].vector,
> -						 &(dev->aac_msix[j]));
> -				pci_disable_msix(dev->pdev);
> -				goto error_iounmap;
> -			}
> -			if (irq_set_affinity_hint(
> -			   dev->msixentry[i].vector,
> -			   get_cpu_mask(cpu))) {
> -				printk(KERN_ERR "%s%d: Failed to set IRQ affinity for cpu %d\n",
> -						name, instance, cpu);
> -			}
> -			cpu =3D cpumask_next(cpu, cpu_online_mask);
> -		}
> -	} else {
> -		dev->aac_msix[0].vector_no =3D 0;
> -		dev->aac_msix[0].dev =3D dev;
> -
> -		if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> -				IRQF_SHARED,
> -				"aacraid",
> -				&(dev->aac_msix[0])) < 0) {
> -			if (dev->msi)
> -				pci_disable_msi(dev->pdev);
> -			printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
> -					name, instance);
> -			goto error_iounmap;
> -		}
> -	}
> +
> +	if (aac_acquire_irq(dev))
> +		goto error_iounmap;
> +
>  	dev->dbg_base =3D dev->base_start;
>  	dev->dbg_base_mapped =3D dev->base;
>  	dev->dbg_size =3D dev->base_size;
> --=20
> 1.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
