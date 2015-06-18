From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/20] [SCSI] mpt3sas: Remove redundancy code while
 freeing the controller resources.
Date: Thu, 18 Jun 2015 12:08:48 +0200
Message-ID: <20150618100848.GC12717@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-5-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-5-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:16PM +0530, Sreekanth Reddy wrote:
> Removed the redundancy code while freeing the controller resources.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++------=
----------
>  1 file changed, 32 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index ce57320..32b86bf 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1798,6 +1798,36 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>  }
> =20
>  /**
> + * mpt3sas_base_unmap_resources - free controller resources
> + * @ioc: per adapter object
> + */
> +void
> +mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct pci_dev *pdev =3D ioc->pdev;
> +
> +	dexitprintk(ioc, printk(MPT3SAS_FMT "%s\n",
> +		ioc->name, __func__));
> +
> +	_base_free_irq(ioc);
> +	_base_disable_msix(ioc);
> +
> +	if (ioc->msix96_vector)
> +		kfree(ioc->replyPostRegisterIndex);
> +
> +	if (ioc->chip_phys) {
> +		iounmap(ioc->chip);
> +		ioc->chip_phys =3D 0;
> +	}
> +
> +	if (pci_is_enabled(pdev)) {
> +		pci_release_selected_regions(ioc->pdev, ioc->bars);
> +		pci_disable_pcie_error_reporting(pdev);
> +		pci_disable_device(pdev);
> +	}
> +}
> +
> +/**
>   * mpt3sas_base_map_resources - map in controller resources (io/irq/=
memap)
>   * @ioc: per adapter object
>   *
> @@ -1925,14 +1955,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAP=
TER *ioc)
>  	return 0;
> =20
>   out_fail:
> -	if (ioc->chip_phys)
> -		iounmap(ioc->chip);
> -	ioc->chip_phys =3D 0;
> -	pci_release_selected_regions(ioc->pdev, ioc->bars);
> -	pci_disable_pcie_error_reporting(pdev);
> -	pci_disable_device(pdev);
> -	if (ioc->msix96_vector)
> -		kfree(ioc->replyPostRegisterIndex);
> +	mpt3sas_base_unmap_resources(ioc);
>  	return r;
>  }
> =20
> @@ -4667,8 +4690,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPT=
ER *ioc, int sleep_flag)
>  void
>  mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
>  {
> -	struct pci_dev *pdev =3D ioc->pdev;
> -
>  	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>  	    __func__));
> =20
> @@ -4679,21 +4700,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADA=
PTER *ioc)
>  		ioc->shost_recovery =3D 0;
>  	}
> =20
> -	_base_free_irq(ioc);
> -	_base_disable_msix(ioc);
> -
> -	if (ioc->msix96_vector)
> -		kfree(ioc->replyPostRegisterIndex);
> -
> -	if (ioc->chip_phys && ioc->chip)
> -		iounmap(ioc->chip);
> -	ioc->chip_phys =3D 0;
> -
> -	if (pci_is_enabled(pdev)) {
> -		pci_release_selected_regions(ioc->pdev, ioc->bars);
> -		pci_disable_pcie_error_reporting(pdev);
> -		pci_disable_device(pdev);
> -	}
> +	mpt3sas_base_unmap_resources(ioc);
>  	return;
>  }
> =20
> --=20
> 2.0.2
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
