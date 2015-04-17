From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 07/43] hpsa: allow lockup detected to be viewed via
 sysfs
Date: Fri, 17 Apr 2015 15:04:00 +0200
Message-ID: <553104C0.1080606@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134719.30238.80651.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbDQNEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:04:02 -0400
In-Reply-To: <20150416134719.30238.80651.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> expose a detected lockup via sysfs
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 68238dd..adc0ad3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -351,6 +351,20 @@ static int check_for_busy(struct ctlr_info *h, s=
truct CommandList *c)
>  	return 1;
>  }
> =20
> +static u32 lockup_detected(struct ctlr_info *h);
> +static ssize_t host_show_lockup_detected(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int ld;
> +	struct ctlr_info *h;
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +
> +	h =3D shost_to_hba(shost);
> +	ld =3D lockup_detected(h);
> +
> +	return sprintf(buf, "ld=3D%d\n", ld);
> +}
> +
>  static ssize_t host_store_hp_ssd_smart_path_status(struct device *de=
v,
>  					 struct device_attribute *attr,
>  					 const char *buf, size_t count)
> @@ -698,12 +712,15 @@ static DEVICE_ATTR(transport_mode, S_IRUGO,
>  	host_show_transport_mode, NULL);
>  static DEVICE_ATTR(resettable, S_IRUGO,
>  	host_show_resettable, NULL);
> +static DEVICE_ATTR(lockup_detected, S_IRUGO,
> +	host_show_lockup_detected, NULL);
> =20
>  static struct device_attribute *hpsa_sdev_attrs[] =3D {
>  	&dev_attr_raid_level,
>  	&dev_attr_lunid,
>  	&dev_attr_unique_id,
>  	&dev_attr_hp_ssd_smart_path_enabled,
> +	&dev_attr_lockup_detected,
>  	NULL,
>  };
> =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
