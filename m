From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH 1/6] scsi: Add 'access_state' and 'preferred_path'
 attribute
Date: Tue, 1 Mar 2016 07:08:40 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4453A465@G4W3219.americas.hpqcorp.net>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
 <1456808143-88932-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:12292 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbcCAHJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2016 02:09:39 -0500
In-Reply-To: <1456808143-88932-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

in https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt

it says:

- show() must not use snprintf() when formatting the value to be
  returned to user space. If you can guarantee that an overflow
  will never happen you can use sprintf() otherwise you must use
  scnprintf().

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Tuesday, March 01, 2016 3:56 PM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; Ewan Milne; Bart van Assche; James Bottomley; linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 1/6] scsi: Add 'access_state' and 'preferred_path' attribute
> 
> Add an 'access_state' field to struct scsi_device and display them in sysfs as
> 'access_state' and 'preferred_path' attribute.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c  | 74
> ++++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h |  1 +
>  include/scsi/scsi_proto.h  | 12 ++++++++
>  3 files changed, 87 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c index
> d8b275b..b6a1af8 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -81,6 +81,33 @@ const char *scsi_host_state_name(enum
> scsi_host_state state)
>  	return name;
>  }
> 
> +static const struct {
> +	unsigned char	value;
> +	char		*name;
> +} sdev_access_states[] = {
> +	{ SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
> +	{ SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
> +	{ SCSI_ACCESS_STATE_STANDBY, "standby" },
> +	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
> +	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
> +	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
> +	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" }, };
> +
> +const char *scsi_access_state_name(unsigned char state) {
> +	int i;
> +	char *name = NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(sdev_access_states); i++) {
> +		if (sdev_access_states[i].value == state) {
> +			name = sdev_access_states[i].name;
> +			break;
> +		}
> +	}
> +	return name;
> +}
> +
>  static int check_set(unsigned long long *val, char *src)  {
>  	char *last;
> @@ -973,6 +1000,43 @@ sdev_store_dh_state(struct device *dev, struct
> device_attribute *attr,
> 
>  static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
>  		   sdev_store_dh_state);
> +
> +static ssize_t
> +sdev_show_access_state(struct device *dev,
> +		       struct device_attribute *attr,
> +		       char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned char access_state;
> +	const char *access_state_name;
> +
> +	if (!sdev->handler)
> +		return -EINVAL;
> +
> +	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
> +	access_state_name = scsi_access_state_name(access_state);
> +
> +	return snprintf(buf, 32, "%s\n",
> +			access_state_name ? access_state_name :
> "unknown"); } static
> +DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
> +
> +static ssize_t
> +sdev_show_preferred_path(struct device *dev,
> +			 struct device_attribute *attr,
> +			 char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	if (!sdev->handler)
> +		return -EINVAL;
> +
> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
> +		return snprintf(buf,2, "1\n");
> +	else
> +		return snprintf(buf, 2, "0\n");
> +}
> +static DEVICE_ATTR(preferred_path, S_IRUGO,
> sdev_show_preferred_path,
> +NULL);
>  #endif
> 
>  static ssize_t
> @@ -1020,6 +1084,14 @@ static umode_t scsi_sdev_attr_is_visible(struct
> kobject *kobj,
>  	    !sdev->host->hostt->change_queue_depth)
>  		return 0;
> 
> +#ifdef CONFIG_SCSI_DH
> +	if (attr == &dev_attr_access_state.attr &&
> +	    !sdev->handler)
> +		return 0;
> +	if (attr == &dev_attr_preferred_path.attr &&
> +	    !sdev->handler)
> +		return 0;
> +#endif
>  	return attr->mode;
>  }
> 
> @@ -1069,6 +1141,8 @@ static struct attribute *scsi_sdev_attrs[] = {
>  	&dev_attr_wwid.attr,
>  #ifdef CONFIG_SCSI_DH
>  	&dev_attr_dh_state.attr,
> +	&dev_attr_access_state.attr,
> +	&dev_attr_preferred_path.attr,
>  #endif
>  	&dev_attr_queue_ramp_up_period.attr,
>  	REF_EVT(media_change),
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h index
> 4af2b24..c067019 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -201,6 +201,7 @@ struct scsi_device {
>  	struct scsi_device_handler *handler;
>  	void			*handler_data;
> 
> +	unsigned char		access_state;
>  	enum scsi_device_state sdev_state;
>  	unsigned long		sdev_data[0];
>  } __attribute__((aligned(sizeof(unsigned long)))); diff --git
> a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h index
> a9fbf1b..c2ae21c 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -277,5 +277,17 @@ struct scsi_lun {
>  	__u8 scsi_lun[8];
>  };
> 
> +/* SPC asymmetric access states */
> +#define SCSI_ACCESS_STATE_OPTIMAL     0x00
> +#define SCSI_ACCESS_STATE_ACTIVE      0x01
> +#define SCSI_ACCESS_STATE_STANDBY     0x02
> +#define SCSI_ACCESS_STATE_UNAVAILABLE 0x03
> +#define SCSI_ACCESS_STATE_LBA         0x04
> +#define SCSI_ACCESS_STATE_OFFLINE     0x0e
> +#define SCSI_ACCESS_STATE_TRANSITIONING 0x0f
> +
> +/* Values for REPORT TARGET GROUP STATES */
> +#define SCSI_ACCESS_STATE_MASK        0x0f
> +#define SCSI_ACCESS_STATE_PREFERRED   0x80
> 
>  #endif /* _SCSI_PROTO_H_ */
> --
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
