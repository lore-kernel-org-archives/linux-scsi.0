From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 16/18] scsi: export 'device_id' to sysfs
Date: Tue, 24 Nov 2015 13:17:32 +0100
Message-ID: <1448367452.2877.25.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbbKXMRd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:33 -0500
In-Reply-To: <1447081703-110552-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Use scsi_vpd_lun_id() to export the device id to sysfs.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_sysfs.c | 17 +++++++++++++++++
> =C2=A01 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7b41b2c..aaa38c2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -903,6 +903,22 @@ sdev_show_function(queue_depth, "%d\n");
> =C2=A0static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR,
> sdev_show_queue_depth,
> =C2=A0		=C2=A0=C2=A0=C2=A0sdev_store_queue_depth);
> =C2=A0
> +static ssize_t
> +sdev_show_device_id(struct device *dev, struct device_attribute
> *attr,
> +		=C2=A0=C2=A0=C2=A0=C2=A0char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	ssize_t count;
> +
> +	count =3D scsi_vpd_lun_id(sdev, buf, PAGE_SIZE);
> +	if (count > 0) {
> +		buf[count] =3D '\n';
> +		count++;
> +	}
> +	return count;
> +}
> +static DEVICE_ATTR(device_id, S_IRUGO, sdev_show_device_id, NULL);
> +
> =C2=A0#ifdef CONFIG_SCSI_DH
> =C2=A0static ssize_t
> =C2=A0sdev_show_dh_state(struct device *dev, struct device_attribute
> *attr,
> @@ -1026,6 +1042,7 @@ static struct attribute *scsi_sdev_attrs[] =3D =
{
> =C2=A0	&dev_attr_modalias.attr,
> =C2=A0	&dev_attr_queue_depth.attr,
> =C2=A0	&dev_attr_queue_type.attr,
> +	&dev_attr_device_id.attr,
> =C2=A0#ifdef CONFIG_SCSI_DH
> =C2=A0	&dev_attr_dh_state.attr,
> =C2=A0#endif

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
