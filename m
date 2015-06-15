From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 10/20] [SCSI] mpt3sas: Add branding string support for
 OEM's HBA
Date: Mon, 15 Jun 2015 11:46:54 +0200
Message-ID: <20150615094654.GA5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-11-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbbFOJrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 05:47:02 -0400
Content-Disposition: inline
In-Reply-To: <1434102153-38581-11-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:22PM +0530, Sreekanth Reddy wrote:
> Added the following Dell branding to the mpt3sas driver.
>=20
> "VendorID"   "DeviceID"  "SubsystemVendor ID"  "SubsystemDevice ID"  =
Dell Branding String
> 0x1000        0x0097          0x1028                 0x1F46          =
  DELL 12Gbps HBA
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 36 +++++++++++++++++++++++++++=
+++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
>  2 files changed, 47 insertions(+)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index 6739c0a..db362cb 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2345,6 +2345,41 @@ _base_display_intel_branding(struct MPT3SAS_AD=
APTER *ioc)
> =20
> =20
>  /**
> + * _base_display_dell_branding - Display branding string
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +static void
> +_base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	if (ioc->pdev->subsystem_vendor !=3D PCI_VENDOR_ID_DELL)
> +		return;
> +
> +	switch (ioc->pdev->device) {
> +	case MPI25_MFGPAGE_DEVID_SAS3008:
> +		switch (ioc->pdev->subsystem_device) {
> +		case MPT3SAS_DELL_12G_HBA_SSDID:
> +			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +				MPT3SAS_DELL_12G_HBA_BRANDING);
> +			break;
> +		default:
> +			pr_info(MPT3SAS_FMT
> +			   "Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
> +			   ioc->pdev->subsystem_device);
> +			break;
> +		}
> +		break;
> +	default:
> +		pr_info(MPT3SAS_FMT
> +			"Dell 12Gbps HBA: Subsystem ID: 0x%X\n", ioc->name,
> +			ioc->pdev->subsystem_device);
> +		break;
> +	}
> +}
> +
> +
> +/**
>   * _base_display_ioc_capabilities - Disply IOC's capabilities.
>   * @ioc: per adapter object
>   *
> @@ -2374,6 +2409,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_A=
DAPTER *ioc)
>  	    bios_version & 0x000000FF);
> =20
>  	_base_display_intel_branding(ioc);
> +	_base_display_dell_branding(ioc);
> =20
>  	pr_info(MPT3SAS_FMT "Protocol=3D(", ioc->name);
> =20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> index 2318ef8..c4780c7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -152,6 +152,17 @@
>  #define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
> =20
>  /*
> + * Dell HBA branding
> + */
> +#define MPT3SAS_DELL_12G_HBA_BRANDING       \
> +	"Dell 12Gbps HBA"
> +
> +/*
> + * Dell HBA SSDIDs
> + */
> +#define MPT3SAS_DELL_12G_HBA_SSDID	0x1F46
> +
> +/*
>   * status bits for ioc->diag_buffer_status
>   */
>  #define MPT3_DIAG_BUFFER_IS_REGISTERED	(0x01)
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This might be something you might consider re-organizing for your code-=
base
merge as well, as it leads to a lot of code duplication the more OEMs y=
ou have.

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
