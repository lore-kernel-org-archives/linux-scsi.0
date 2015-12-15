From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_transport_sas: add is_sas_attached() function
Date: Tue, 15 Dec 2015 11:16:37 +0100
Message-ID: <566FE885.4070204@suse.de>
References: <1449688206.2226.30.camel@HansenPartnership.com>
 <1449688323.2226.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbbLOKQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 05:16:39 -0500
In-Reply-To: <1449688323.2226.32.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 12/09/2015 08:12 PM, James Bottomley wrote:
> Adds a function designed to be callable any time (regardless of
> whether the transport attributes are configured or not) which returns
> true if the device is attached over a SAS transport.  The design of
> this function is that transport specific functions can be embedded
> within a
>
> if (is_sas_attached(sdev)) {
> 	...
> }
>
> which would be compiled out (and thus eliminate the symbols) if SAS i=
s
> not configured.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>
> ---
>   drivers/scsi/scsi_transport_sas.c |   16 ++++++++++++++++
>   include/scsi/scsi_transport_sas.h |    9 +++++++++
>   2 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_tr=
ansport_sas.c
> index 30d26e3..b17f763 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -341,6 +341,22 @@ static int do_sas_phy_delete(struct device *dev,=
 void *data)
>   }
>
>   /**
> + * is_sas_attached - check if device is SAS attached
> + * @sdev: scsi device to check
> + *
> + * returns true if the device is SAS attached
> + */
> +int is_sas_attached(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost =3D sdev->host;
> +
> +	return shost->transportt->host_attrs.ac.class =3D=3D
> +		&sas_host_class.class;
> +}
> +EXPORT_SYMBOL(is_sas_attached);
> +
> +
> +/**
>    * sas_remove_children  -  tear down a devices SAS data structures
>    * @dev:	device belonging to the sas object
>    *
> diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_tr=
ansport_sas.h
> index 0bd71e2..a8fdd10 100644
> --- a/include/scsi/scsi_transport_sas.h
> +++ b/include/scsi/scsi_transport_sas.h
> @@ -10,6 +10,15 @@ struct scsi_transport_template;
>   struct sas_rphy;
>   struct request;
>
> +#if !IS_ENABLED(CONFIG_SCSI_SAS_ATTRS)
> +static inline int is_sas_attached(struct scsi_device *sdev)
> +{
> +	return 0;
> +}
> +#else
> +extern int is_sas_attached(struct scsi_device *sdev);
> +#endif
> +
>   static inline int sas_protocol_ata(enum sas_protocol proto)
>   {
>   	return ((proto & SAS_PROTOCOL_SATA) ||
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
