From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 20/23] scsi: Add 'access_state' attribute
Date: Thu, 11 Feb 2016 15:33:27 -0500
Message-ID: <1455222807.22112.336.camel@localhost.localdomain>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
	 <1454942086-128704-21-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbcBKUd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2016 15:33:28 -0500
In-Reply-To: <1454942086-128704-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
> Add an 'access_state' attribute to struct scsi_device to
> display the asymmetric LUN access state.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c   |  1 +
>  drivers/scsi/scsi_sysfs.c  | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h |  1 +
>  include/scsi/scsi_proto.h  | 13 ++++++++++++
>  4 files changed, 64 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 97074c9..5bf3945 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	sdev->lun = lun;
>  	sdev->channel = starget->channel;
>  	sdev->sdev_state = SDEV_CREATED;
> +	sdev->access_state = SCSI_ACCESS_STATE_UNKNOWN;
>  	INIT_LIST_HEAD(&sdev->siblings);
>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>  	INIT_LIST_HEAD(&sdev->cmd_list);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 4f18a85..8d154ed 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -81,6 +81,34 @@ const char *scsi_host_state_name(enum scsi_host_state state)
>  	return name;
>  }
>  
> +static const struct {
> +	enum scsi_access_state	value;
> +	char			*name;
> +} sdev_access_states[] = {
> +	{ SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
> +	{ SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
> +	{ SCSI_ACCESS_STATE_STANDBY, "standby" },
> +	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
> +	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
> +	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
> +	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
> +	{ SCSI_ACCESS_STATE_UNKNOWN, "unknown" },
> +};
> +
> +const char *scsi_access_state_name(enum scsi_access_state state)
> +{
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
>  static int check_set(unsigned long long *val, char *src)
>  {
>  	char *last;
> @@ -973,6 +1001,26 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
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
> +	enum scsi_access_state access_state;
> +	bool pref = false;
> +
> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
> +		pref = true;
> +
> +	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);

I personally think it is a mistake to stick an extra bit in the
top of a variable declared as an enum like this.  It opens up
the possibility of subtle bugs if someone changes the code in
the future and does not take care to preserve your extra bit.

> +
> +	return snprintf(buf, 32, "%s%s\n",
> +			scsi_access_state_name(access_state),
> +			pref ? " preferred" : "");
> +}
> +static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
>  #endif
>  
>  static ssize_t
> @@ -1047,6 +1095,7 @@ static struct attribute *scsi_sdev_attrs[] = {
>  	&dev_attr_wwid.attr,
>  #ifdef CONFIG_SCSI_DH
>  	&dev_attr_dh_state.attr,
> +	&dev_attr_access_state.attr,
>  #endif
>  	&dev_attr_queue_ramp_up_period.attr,
>  	REF_EVT(media_change),
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 4af2b24..af16a0d 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -201,6 +201,7 @@ struct scsi_device {
>  	struct scsi_device_handler *handler;
>  	void			*handler_data;
>  
> +	enum scsi_access_state	access_state;
>  	enum scsi_device_state sdev_state;
>  	unsigned long		sdev_data[0];
>  } __attribute__((aligned(sizeof(unsigned long))));
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index a9fbf1b..80e85e7 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -277,5 +277,18 @@ struct scsi_lun {
>  	__u8 scsi_lun[8];
>  };
>  
> +/* SPC asymmetric access states */
> +enum scsi_access_state {
> +	SCSI_ACCESS_STATE_OPTIMAL = 0,
> +	SCSI_ACCESS_STATE_ACTIVE,
> +	SCSI_ACCESS_STATE_STANDBY,
> +	SCSI_ACCESS_STATE_UNAVAILABLE,
> +	SCSI_ACCESS_STATE_LBA,
> +	SCSI_ACCESS_STATE_OFFLINE = 0xe,
> +	SCSI_ACCESS_STATE_TRANSITIONING = 0xf,
> +	SCSI_ACCESS_STATE_UNKNOWN = 0x70,
> +};

Given that these values are defined by the T10 spec and their values
matter, I think it would be prudent to assign specific values to each
enum constant, rather than just let the compiler do that.

> +#define SCSI_ACCESS_STATE_MASK 0x0f
> +#define SCSI_ACCESS_STATE_PREFERRED 0x80
>  
>  #endif /* _SCSI_PROTO_H_ */

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


