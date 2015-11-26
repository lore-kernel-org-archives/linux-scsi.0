From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH] scsi: rescan VPD attributes
Date: Thu, 26 Nov 2015 08:50:15 +0100
Message-ID: <1448524215.2877.81.camel@suse.com>
References: <1447071868-8509-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbbKZHuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 02:50:17 -0500
In-Reply-To: <1447071868-8509-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.Petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>

On Mon, 2015-11-09 at 13:24 +0100, Hannes Reinecke wrote:
> The VPD page information might change, so we need to be able to
> update it. This patch implements a VPD page rescan whenever
> the 'rescan' sysfs attribute is triggered.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0| 20 +++++++++++++++++---
> =C2=A0drivers/scsi/scsi_scan.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A04 ++++
> =C2=A0drivers/scsi/scsi_sysfs.c=C2=A0=C2=A0|=C2=A0=C2=A08 ++++++--
> =C2=A0drivers/scsi/ses.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 12 +++++++++---
> =C2=A0include/scsi/scsi_device.h |=C2=A0=C2=A05 +++--
> =C2=A05 files changed, 39 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 207d6a7..2e4ef56 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -803,7 +803,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
> =C2=A0	int vpd_len =3D SCSI_VPD_PG_LEN;
> =C2=A0	int pg80_supported =3D 0;
> =C2=A0	int pg83_supported =3D 0;
> -	unsigned char *vpd_buf;
> +	unsigned char __rcu *vpd_buf, *orig_vpd_buf =3D NULL;
> =C2=A0
> =C2=A0	if (sdev->skip_vpd_pages)
> =C2=A0		return;
> @@ -849,8 +849,16 @@ retry_pg80:
> =C2=A0			kfree(vpd_buf);
> =C2=A0			goto retry_pg80;
> =C2=A0		}
> +		mutex_lock(&sdev->inquiry_mutex);
> +		orig_vpd_buf =3D sdev->vpd_pg80;
> =C2=A0		sdev->vpd_pg80_len =3D result;
> -		sdev->vpd_pg80 =3D vpd_buf;
> +		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
> +		mutex_unlock(&sdev->inquiry_mutex);
> +		synchronize_rcu();
> +		if (orig_vpd_buf) {
> +			kfree(orig_vpd_buf);
> +			orig_vpd_buf =3D NULL;
> +		}
> =C2=A0		vpd_len =3D SCSI_VPD_PG_LEN;
> =C2=A0	}
> =C2=A0
> @@ -870,8 +878,14 @@ retry_pg83:
> =C2=A0			kfree(vpd_buf);
> =C2=A0			goto retry_pg83;
> =C2=A0		}
> +		mutex_lock(&sdev->inquiry_mutex);
> +		orig_vpd_buf =3D sdev->vpd_pg83;
> =C2=A0		sdev->vpd_pg83_len =3D result;
> -		sdev->vpd_pg83 =3D vpd_buf;
> +		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
> +		mutex_unlock(&sdev->inquiry_mutex);
> +		synchronize_rcu();
> +		if (orig_vpd_buf)
> +			kfree(orig_vpd_buf);
> =C2=A0	}
> =C2=A0}
> =C2=A0
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3b3dfef..7e0820f 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -236,6 +236,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
> =C2=A0	INIT_LIST_HEAD(&sdev->starved_entry);
> =C2=A0	INIT_LIST_HEAD(&sdev->event_list);
> =C2=A0	spin_lock_init(&sdev->list_lock);
> +	mutex_init(&sdev->inquiry_mutex);
> =C2=A0	INIT_WORK(&sdev->event_work, scsi_evt_thread);
> =C2=A0	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
> =C2=A0
> @@ -1517,6 +1518,9 @@ EXPORT_SYMBOL(scsi_add_device);
> =C2=A0void scsi_rescan_device(struct device *dev)
> =C2=A0{
> =C2=A0	device_lock(dev);
> +
> +	scsi_attach_vpd(to_scsi_device(dev));
> +
> =C2=A0	if (dev->driver && try_module_get(dev->driver->owner)) {
> =C2=A0		struct scsi_driver *drv =3D to_scsi_driver(dev->driver);
> =C2=A0
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fdcf0ab..f021423 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -758,11 +758,15 @@ show_vpd_##_page(struct file *filp, struct kobj=
ect
> *kobj,	\
> =C2=A0{									\
> =C2=A0	struct device *dev =3D container_of(kobj, struct device, kobj)=
;=09
> \
> =C2=A0	struct scsi_device *sdev =3D to_scsi_device(dev);		=09
> \
> +	int ret;							\
> =C2=A0	if (!sdev->vpd_##_page)					=09
> \
> =C2=A0		return -EINVAL;					=09
> \
> -	return memory_read_from_buffer(buf, count, &off,		\
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sdev->vpd_##_page,		\
> +	rcu_read_lock();						\
> +	ret =3D memory_read_from_buffer(buf, count, &off,		=09
> \
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rcu_dereference(sdev->vpd_##=
_page), \
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sdev->vpd_##_page=
##_len);	\
> +	rcu_read_unlock();						\
> +	return ret;						\
> =C2=A0}									\
> =C2=A0static struct bin_attribute dev_attr_vpd_##_page =3D {		\
> =C2=A0	.attr =3D	{.name =3D __stringify(vpd_##_page), .mode =3D S_IRU=
GO },
> 	\
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index dcb0d76..e234da7 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -554,17 +554,22 @@ static void ses_match_to_enclosure(struct
> enclosure_device *edev,
> =C2=A0				=C2=A0=C2=A0=C2=A0struct scsi_device *sdev)
> =C2=A0{
> =C2=A0	unsigned char *desc;
> +	unsigned char __rcu *vpd_pg83;
> =C2=A0	struct efd efd =3D {
> =C2=A0		.addr =3D 0,
> =C2=A0	};
> =C2=A0
> =C2=A0	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.par=
ent),
> 0);
> =C2=A0
> -	if (!sdev->vpd_pg83_len)
> +	rcu_read_lock();
> +	vpd_pg83 =3D rcu_dereference(sdev->vpd_pg83);
> +	if (!vpd_pg83) {
> +		rcu_read_unlock();
> =C2=A0		return;
> +	}
> =C2=A0
> -	desc =3D sdev->vpd_pg83 + 4;
> -	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +	desc =3D vpd_pg83 + 4;
> +	while (desc < vpd_pg83 + sdev->vpd_pg83_len) {
> =C2=A0		enum scsi_protocol proto =3D desc[0] >> 4;
> =C2=A0		u8 code_set =3D desc[0] & 0x0f;
> =C2=A0		u8 piv =3D desc[1] & 0x80;
> @@ -578,6 +583,7 @@ static void ses_match_to_enclosure(struct
> enclosure_device *edev,
> =C2=A0
> =C2=A0		desc +=3D len + 4;
> =C2=A0	}
> +	rcu_read_unlock();
> =C2=A0	if (efd.addr) {
> =C2=A0		efd.dev =3D &sdev->sdev_gendev;
> =C2=A0
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index fe89d7c..bde4077 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -109,6 +109,7 @@ struct scsi_device {
> =C2=A0	char type;
> =C2=A0	char scsi_level;
> =C2=A0	char inq_periph_qual;	/* PQ from INQUIRY data */=09
> +	struct mutex inquiry_mutex;
> =C2=A0	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
> =C2=A0	unsigned char * inquiry;	/* INQUIRY response data */
> =C2=A0	const char * vendor;		/* [back_compat] point into
> 'inquiry' ... */
> @@ -117,9 +118,9 @@ struct scsi_device {
> =C2=A0
> =C2=A0#define SCSI_VPD_PG_LEN=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0255
> =C2=A0	int vpd_pg83_len;
> -	unsigned char *vpd_pg83;
> +	unsigned char __rcu *vpd_pg83;
> =C2=A0	int vpd_pg80_len;
> -	unsigned char *vpd_pg80;
> +	unsigned char __rcu *vpd_pg80;
> =C2=A0	unsigned char current_tag;	/* current tag */
> =C2=A0	struct scsi_target=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*sdev_ta=
rget;=C2=A0=C2=A0=C2=A0/* used only for single_lun
> */
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
