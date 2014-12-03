From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] scsi: remove ->change_queue_type method
Date: Wed, 03 Dec 2014 14:32:04 +0100
Message-ID: <547F10D4.60605@suse.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLCNcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 08:32:06 -0500
In-Reply-To: <1416839781-26988-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/2014 03:36 PM, Christoph Hellwig wrote:
> Since we got rid of ordered tag support in 2010 the prime use case of
> switching on and off ordered tags has been obsolete.  The other funct=
ion
> of enabling/dsiabling tagging entirely has only been correctly implem=
ented
> by the 53c700 driver and isn't generally useful.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c  |  1 -
>  drivers/scsi/53c700.c                | 35 --------------------------=
---------
>  drivers/scsi/aic94xx/aic94xx_init.c  |  1 -
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c    |  1 -
>  drivers/scsi/esas2r/esas2r_main.c    |  1 -
>  drivers/scsi/fcoe/fcoe.c             |  1 -
>  drivers/scsi/fnic/fnic_main.c        |  1 -
>  drivers/scsi/ibmvscsi/ibmvfc.c       |  1 -
>  drivers/scsi/ipr.c                   | 25 -------------------------
>  drivers/scsi/isci/init.c             |  1 -
>  drivers/scsi/libsas/sas_scsi_host.c  |  8 --------
>  drivers/scsi/lpfc/lpfc_scsi.c        |  2 --
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 -
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 -
>  drivers/scsi/mvsas/mv_init.c         |  1 -
>  drivers/scsi/pm8001/pm8001_init.c    |  1 -
>  drivers/scsi/pmcraid.c               |  1 -
>  drivers/scsi/qla2xxx/qla_os.c        |  1 -
>  drivers/scsi/scsi.c                  | 16 ----------------
>  drivers/scsi/scsi_debug.c            | 27 --------------------------=
-
>  drivers/scsi/scsi_sysfs.c            | 30 ++++----------------------=
----
>  drivers/target/loopback/tcm_loop.c   |  1 -
>  include/scsi/libsas.h                |  1 -
>  include/scsi/scsi_host.h             | 13 -------------
>  include/scsi/scsi_tcq.h              |  3 ---
>  25 files changed, 4 insertions(+), 171 deletions(-)
>=20

[ .. ]

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 1cb64a8..1ac38e7 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -738,30 +738,12 @@ store_queue_type_field(struct device *dev, stru=
ct device_attribute *attr,
>  		       const char *buf, size_t count)
>  {
>  	struct scsi_device *sdev =3D to_scsi_device(dev);
> -	struct scsi_host_template *sht =3D sdev->host->hostt;
> -	int tag_type =3D 0, retval;
> -	int prev_tag_type =3D scsi_get_tag_type(sdev);
> -
> -	if (!sdev->tagged_supported || !sht->change_queue_type)
> -		return -EINVAL;
> =20
> -	/*
> -	 * We're never issueing order tags these days, but allow the value
> -	 * for backwards compatibility.
> -	 */
> -	if (strncmp(buf, "ordered", 7) =3D=3D 0 ||
> -	    strncmp(buf, "simple", 6) =3D=3D 0)
> -		tag_type =3D MSG_SIMPLE_TAG;
> -	else if (strncmp(buf, "none", 4) !=3D 0)
> +	if (!sdev->tagged_supported)
>  		return -EINVAL;
> -
> -	if (tag_type =3D=3D prev_tag_type)
> -		return count;
> -
> -	retval =3D sht->change_queue_type(sdev, tag_type);
> -	if (retval < 0)
> -		return retval;
> -
> +	=09
> +	sdev_printk(KERN_INFO, sdev,
> +		    "ignoring write to deprecated queue_type attribute");
>  	return count;
>  }
> =20
> @@ -938,10 +920,6 @@ static umode_t scsi_sdev_attr_is_visible(struct =
kobject *kobj,
>  	    !sdev->host->hostt->change_queue_depth)
>  		return 0;
> =20
> -	if (attr =3D=3D &dev_attr_queue_type.attr &&
> -	    !sdev->host->hostt->change_queue_type)
> -		return S_IRUGO;
> -
>  	return attr->mode;
>  }
> =20
Why not setting the attribute to S_IRUGO always and drop the 'store'
method altogether?

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
