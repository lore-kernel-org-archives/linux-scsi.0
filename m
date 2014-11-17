From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] zfcp: bring back unit sysfs attributes for automatic
 LUN scan
Date: Mon, 17 Nov 2014 14:34:55 +0100
Message-ID: <5469F97F.7050909@suse.de>
References: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com> <1415887188-40233-3-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaKQNe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 08:34:57 -0500
In-Reply-To: <1415887188-40233-3-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On 11/13/2014 02:59 PM, Steffen Maier wrote:
> Through sysfs attributes, zfcp unit objects
> provide a trigger for manual LUN recovery
> and export information for problem determination.
>=20
> With commit
> f8210e34887e1feb977a9b6b8caa086855af40c9
> "[SCSI] zfcp: Allow midlayer to scan for LUNs when running in NPIV mo=
de"
> and when attaching SCSI devices through this new optional method,
> no more zfcp unit objects are allocated for such SCSI devices.
> Hence, the above-mentioned trigger and information were missing.
>=20
> The information and context is located in SCSI transport device data =
since
> b62a8d9b45b971a67a0f8413338c230e3117dff5
> "[SCSI] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit=
"
> 57c237731b92fadc7d44824276313ec330b1989b
> "[SCSI] zfcp: Add zfcp private struct as SCSI device driver data"
> Hence, introduce the trigger and the information unconditionally
> for all SCSI devices attached through zfcp.
>=20
> We prefix the attribute names with 'zfcp_' to prevent collisions and
> to avoid mix-ups such as with the common 'state' attribute.
>=20
> Since some of the new attribute views do not need zfcp_port
> in the ZFCP_DEFINE_SCSI_ATTR helper macro, remove zfcp_port
> to avoid compiler warnings on unused variable.
> It's easy to open code the conversion from zfcp_scsi_dev to zfcp_port
> for the two already existing attributes hba_id and wwpn.
>=20
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_sysfs.c | 52 ++++++++++++++++++++++++++++++++=
+++++++---
>  1 file changed, 49 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_=
sysfs.c
> index 6b66412..a488c09 100644
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c
> @@ -437,16 +437,15 @@ static ssize_t zfcp_sysfs_scsi_##_name##_show(s=
truct device *dev,	\
>  {                                                                   =
     \
>  	struct scsi_device *sdev =3D to_scsi_device(dev);			 \
>  	struct zfcp_scsi_dev *zfcp_sdev =3D sdev_to_zfcp(sdev);		 \
> -	struct zfcp_port *port =3D zfcp_sdev->port;			 \
>  									 \
>  	return sprintf(buf, _format, _value);                            \
>  }                                                                   =
     \
>  static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, N=
ULL);
> =20
>  ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
> -		      dev_name(&port->adapter->ccw_device->dev));
> +		      dev_name(&zfcp_sdev->port->adapter->ccw_device->dev));
>  ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n",
> -		      (unsigned long long) port->wwpn);
> +		      (unsigned long long) zfcp_sdev->port->wwpn);
> =20
>  static ssize_t zfcp_sysfs_scsi_fcp_lun_show(struct device *dev,
>  					    struct device_attribute *attr,
> @@ -458,6 +457,49 @@ static ssize_t zfcp_sysfs_scsi_fcp_lun_show(stru=
ct device *dev,
>  }
>  static DEVICE_ATTR(fcp_lun, S_IRUGO, zfcp_sysfs_scsi_fcp_lun_show, N=
ULL);
> =20
> +ZFCP_DEFINE_SCSI_ATTR(zfcp_access_denied, "%d\n",
> +		      (atomic_read(&zfcp_sdev->status) &
> +		       ZFCP_STATUS_COMMON_ACCESS_DENIED) !=3D 0);
> +
> +static ssize_t zfcp_sysfs_scsi_zfcp_failed_show(struct device *dev,
> +					   struct device_attribute *attr,
> +					   char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	unsigned int status =3D atomic_read(&sdev_to_zfcp(sdev)->status);
> +	unsigned int failed =3D status & ZFCP_STATUS_COMMON_ERP_FAILED ? 1 =
: 0;
> +
> +	return sprintf(buf, "%d\n", failed);
> +}
> +
> +static ssize_t zfcp_sysfs_scsi_zfcp_failed_store(struct device *dev,
> +					    struct device_attribute *attr,
> +					    const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	unsigned long val;
> +
> +	if (kstrtoul(buf, 0, &val) || val !=3D 0)
> +		return -EINVAL;
> +
> +	zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
> +	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
> +			    "syufai3");
> +	zfcp_erp_wait(sdev_to_zfcp(sdev)->port->adapter);
> +
> +	return count;
> +}
> +static DEVICE_ATTR(zfcp_failed, S_IWUSR | S_IRUGO,
> +		   zfcp_sysfs_scsi_zfcp_failed_show,
> +		   zfcp_sysfs_scsi_zfcp_failed_store);
> +
> +ZFCP_DEFINE_SCSI_ATTR(zfcp_in_recovery, "%d\n",
> +		      (atomic_read(&zfcp_sdev->status) &
> +		       ZFCP_STATUS_COMMON_ERP_INUSE) !=3D 0);
> +
> +ZFCP_DEFINE_SCSI_ATTR(zfcp_status, "0x%08x\n",
> +		      atomic_read(&zfcp_sdev->status));
> +
>  struct device_attribute *zfcp_sysfs_sdev_attrs[] =3D {
>  	&dev_attr_fcp_lun,
>  	&dev_attr_wwpn,
> @@ -465,6 +507,10 @@ struct device_attribute *zfcp_sysfs_sdev_attrs[]=
 =3D {
>  	&dev_attr_read_latency,
>  	&dev_attr_write_latency,
>  	&dev_attr_cmd_latency,
> +	&dev_attr_zfcp_access_denied,
> +	&dev_attr_zfcp_failed,
> +	&dev_attr_zfcp_in_recovery,
> +	&dev_attr_zfcp_status,
>  	NULL
>  };
> =20
>=20
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
