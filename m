From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi_transport_sas: add function to get SAS endpoint
 address
Date: Tue, 15 Dec 2015 11:17:15 +0100
Message-ID: <566FE8AB.1090701@suse.de>
References: <1449688206.2226.30.camel@HansenPartnership.com>
 <1449688415.2226.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbbLOKRR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 05:17:17 -0500
In-Reply-To: <1449688415.2226.34.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 12/09/2015 08:13 PM, James Bottomley wrote:
> For a device known to be SAS connected, this will return the endpoint
> address.  This is useful for getting the SAS address of SATA devices.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>
> ---
>   drivers/scsi/scsi_transport_sas.c |   14 ++++++++++++++
>   include/scsi/scsi_transport_sas.h |    1 +
>   2 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_tr=
ansport_sas.c
> index b17f763..80520e2 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -383,6 +383,20 @@ void sas_remove_host(struct Scsi_Host *shost)
>   EXPORT_SYMBOL(sas_remove_host);
>
>   /**
> + * sas_get_address - return the SAS address of the device
> + * @sdev: scsi device
> + *
> + * Returns the SAS address of the scsi device
> + */
> +u64 sas_get_address(struct scsi_device *sdev)
> +{
> +	struct sas_end_device *rdev =3D sas_sdev_to_rdev(sdev);
> +
> +	return rdev->rphy.identify.sas_address;
> +}
> +EXPORT_SYMBOL(sas_get_address);
> +
> +/**
>    * sas_tlr_supported - checking TLR bit in vpd 0x90
>    * @sdev: scsi device struct
>    *
> diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_tr=
ansport_sas.h
> index a8fdd10..13c0b2b 100644
> --- a/include/scsi/scsi_transport_sas.h
> +++ b/include/scsi/scsi_transport_sas.h
> @@ -189,6 +189,7 @@ extern int sas_phy_add(struct sas_phy *);
>   extern void sas_phy_delete(struct sas_phy *);
>   extern int scsi_is_sas_phy(const struct device *);
>
> +u64 sas_get_address(struct scsi_device *);
>   unsigned int sas_tlr_supported(struct scsi_device *);
>   unsigned int sas_is_tlr_enabled(struct scsi_device *);
>   void sas_disable_tlr(struct scsi_device *);
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
