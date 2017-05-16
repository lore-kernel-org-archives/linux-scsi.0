From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC] scsi: generate uevent for SCSI sense code
Date: Tue, 16 May 2017 19:00:52 +0200
Message-ID: <20170516170052.GA14268@bblock-ThinkPad-W530>
References: <20170504005013.2865393-1-songliubraving@fb.com>
 <20170504005013.2865393-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751845AbdEPRBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 May 2017 13:01:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4GGwr6X090583
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 13:01:02 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ag13p8wwr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 13:01:01 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 16 May 2017 18:01:00 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4GH0vCF39190574
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 17:00:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C8A54C044
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 17:59:41 +0100 (BST)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F26FD4C04A
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 17:59:40 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.96])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 17:59:40 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20170504005013.2865393-2-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk

Hello,

On Wed, May 03, 2017 at 05:50:13PM -0700, Song Liu wrote:
> This patch adds capability for SCSI layer to generate uevent for SCSI
> sense code. The feature is gated by CONFIG_SCSI_SENSE_UEVENT.
>
> We can configure which sense keys generate uevent for each device
> through sysfs entry sense_event_filter. For example, the following
> enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
> on scsi drive sdc:
>
>     echo 0x000c > /sys/block/sdc/device/sense_event_filter
>

I know its an RFC, but the user-interface definitely needs better
documentation. You also don't mention the 'wildcard' you document in the
code below.

Would there be any public tooling for this, when it gets in?

There is already some events we can generate.. for example when the
host-mapping changed, but I am not aware of any tooling that would ever
make use of them (although, this probably would even be vert useful).
And in the end that seems like dead-code for me. But maybe thats just me
not knowing the tooling.

>
> Here is an example output captured by udevadm:
>
> KERNEL[1214.945358] change   /devices/pci0000:00/XXXXXXX
> ACTION=change
> DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/XXXXXXX
> DEVTYPE=scsi_device
> DRIVER=sd
> LBA=0
> MODALIAS=scsi:t-0x00
> SDEV_UA=SCSI_SENSE
> SENSE_CODE=3/11/14
> SEQNUM=4536
> SIZE=4096
> SUBSYSTEM=scsi
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/scsi/Kconfig       | 14 +++++++++++
>  drivers/scsi/scsi_error.c  | 26 ++++++++++++++++++++
>  drivers/scsi/scsi_lib.c    | 27 +++++++++++++++++++--
>  drivers/scsi/scsi_sysfs.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_device.h | 26 +++++++++++++++++++-
>  5 files changed, 150 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 3c52867..4f7f211 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -237,6 +237,20 @@ config SCSI_LOGGING
>  	  there should be no noticeable performance impact as long as you have
>  	  logging turned off.
>
> +config SCSI_SENSE_UEVENT
> +	bool "SCSI sense code logging"
> +	depends on SCSI
> +	default n
> +	---help---
> +	  This turns on uevent for SCSI sense code.
> +
> +	  You can configure which sense keys generate uevent for each device
> +	  through sysfs entry sense_event_filter. For example, the following
> +	  enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
> +	  on scsi drive sdc:
> +
> +	  echo 0x000c > /sys/block/sdc/device/sense_event_filter
> +
>  config SCSI_SCAN_ASYNC
>  	bool "Asynchronous SCSI scanning"
>  	depends on SCSI
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d70c67c..eda150e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -426,6 +426,31 @@ static void scsi_report_sense(struct scsi_device *sdev,
>  	}
>  }
>
> +/*
> + * generate uevent when receiving sense code from device
> + */
> +static void scsi_send_sense_uevent(struct scsi_device *sdev,
> +				   struct scsi_cmnd *scmd,
> +				   struct scsi_sense_hdr *sshdr)
> +{
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +	struct scsi_event *evt;
> +
> +	if (!test_bit(sshdr->sense_key & 0xf,
> +		      &sdev->sense_event_filter))
> +		return;
> +	evt = sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
> +	if (!evt)
> +		return;
> +
> +	evt->sense_evt_data.lba = scsi_get_lba(scmd);
> +	evt->sense_evt_data.size = blk_rq_bytes(scmd->request);
> +	memcpy(&evt->sense_evt_data.sshdr, sshdr,
> +	       sizeof(struct scsi_sense_hdr));
> +	sdev_evt_send(sdev, evt);
> +#endif
> +}
> +

So when I turn this CONFIG_ off, do I get all kinds of warning about
unused variables?

>  /**
>   * scsi_check_sense - Examine scsi cmd sense
>   * @scmd:	Cmd to have sense checked.
> @@ -446,6 +471,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>  		return FAILED;	/* no valid sense data */
>
>  	scsi_report_sense(sdev, &sshdr);
> +	scsi_send_sense_uevent(sdev, scmd, &sshdr);
>
>  	if (scsi_sense_is_deferred(&sshdr))
>  		return NEEDS_RETRY;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 95f963b..1095f27 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2656,8 +2656,9 @@ EXPORT_SYMBOL(scsi_device_set_state);
>   */
>  static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  {
> -	int idx = 0;
> -	char *envp[3];
> +	int idx = 0, i;
> +	char *envp[5];	/* SDEV_EVT_SCSI_SENSE needs most entries (4) */
> +	int free_envp = -1;
>
>  	switch (evt->evt_type) {
>  	case SDEV_EVT_MEDIA_CHANGE:
> @@ -2682,6 +2683,23 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
>  		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
>  		break;
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +	case SDEV_EVT_SCSI_SENSE:
> +		envp[idx++] = "SDEV_UA=SCSI_SENSE";
> +		for (i = idx; i < idx + 3; ++i) {
> +			envp[i] = kzalloc(32, GFP_ATOMIC);

Why try so hard with GFP_ATOMIC? This is run in its own work-item and AFAIK
there is no need to be so strict here.

> +			if (!envp[i])
> +				break;

The error-handling seems a bit optimistic. Especially when your write on
the pointers afterwards.

> +			free_envp = i;
> +		}
> +		snprintf(envp[idx++], 32, "LBA=%lu", evt->sense_evt_data.lba);
> +		snprintf(envp[idx++], 32, "SIZE=%d", evt->sense_evt_data.size);
> +		snprintf(envp[idx++], 32, "SENSE_CODE=%1x/%02x/%02x",
> +			 evt->sense_evt_data.sshdr.sense_key,
> +			 evt->sense_evt_data.sshdr.asc,
> +			 evt->sense_evt_data.sshdr.ascq);
> +		break;

How do you get to this 3x'32'? Seems like quite some waste when we talk
about frequent events.

> +#endif
>  	default:
>  		/* do nothing */
>  		break;
> @@ -2690,6 +2708,10 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  	envp[idx++] = NULL;
>
>  	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
> +
> +	/* no need to free envp[0], so start with i = 1 */
> +	for (i = 1 ; i < free_envp; ++i)
> +		kfree(envp[i]);
>  }
>
>  /**
> @@ -2786,6 +2808,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
>  	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
>  	case SDEV_EVT_LUN_CHANGE_REPORTED:
>  	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
> +	case SDEV_EVT_SCSI_SENSE:
>  	default:
>  		/* do nothing */
>  		break;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 82dfe07..cfc7380 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1072,6 +1072,63 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
>  		   sdev_show_queue_ramp_up_period,
>  		   sdev_store_queue_ramp_up_period);
>
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +
> +/*
> + * SCSI sense key could be 0x00 - 0x08, 0x0a, 0x0b, 0x0d, 0x0e, so the
> + * mask is 0x6dff.
> + */
> +#define SCSI_SENSE_EVENT_FILTER_MASK	0x6dff

Why omit 0x09? Its vendor specific, but that doesn't mean no-one ever
will use it? Well, I don't know a real-life example, but anyway, doesn't
hurt IMO.

Also SPC-4 specifies 0x0F.

> +
> +static ssize_t
> +sdev_show_sense_event_filter(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	struct scsi_device *sdev;
> +
> +	sdev = to_scsi_device(dev);
> +	return snprintf(buf, 20, "0x%04lx\n",
> +			(sdev->sense_event_filter &
> +			 SCSI_SENSE_EVENT_FILTER_MASK));
> +}
> +
> +static ssize_t
> +sdev_store_sense_event_filter(struct device *dev,
> +			      struct device_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned long filter;
> +	int i;
> +
> +	if (buf[0] == '0' && buf[1] == 'x') {
> +		if (kstrtoul(buf + 2, 16, &filter))
> +			return -EINVAL;
> +	} else
> +		if (kstrtoul(buf, 10, &filter))
> +			return -EINVAL;

Why the manual parsing? AFAIK kstrtoul can do that already, if you pass
0 as second argument.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
> +
> +	/*
> +	 * Accurate mask for all sense keys is 0x6dff. However, we allow
> +	 * user to enable event for all sense keys by echoing 0xffff
> +	 */
> +	if ((filter & 0xffff) != filter)
> +		return -EINVAL;
> +
> +	for (i = 0; i < 15; i++)
> +		if (filter & SCSI_SENSE_EVENT_FILTER_MASK  & (1 << i))
> +			set_bit(i, &sdev->sense_event_filter);
> +		else
> +			clear_bit(i, &sdev->sense_event_filter);
> +	return count;
> +}
> +
> +static DEVICE_ATTR(sense_event_filter, 0644,
> +		   sdev_show_sense_event_filter,
> +		   sdev_store_sense_event_filter);
> +#endif
> +
>  static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
>  					 struct attribute *attr, int i)
>  {
> @@ -1142,6 +1199,9 @@ static struct attribute *scsi_sdev_attrs[] = {
>  	&dev_attr_preferred_path.attr,
>  #endif
>  	&dev_attr_queue_ramp_up_period.attr,
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +	&dev_attr_sense_event_filter.attr,
> +#endif
>  	REF_EVT(media_change),
>  	REF_EVT(inquiry_change_reported),
>  	REF_EVT(capacity_change_reported),
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 05641ae..d160bd7 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -64,13 +64,23 @@ enum scsi_device_event {
>  	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
>  	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
>  	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
> +	SDEV_EVT_SCSI_SENSE,
>
>  	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
> -	SDEV_EVT_LAST		= SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,
> +	SDEV_EVT_LAST		= SDEV_EVT_SCSI_SENSE,
>
>  	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
>  };
>
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +/* data for for SDEV_EVT_SCSI_SENSE */
> +struct scsi_sense_uevent_data {
> +	sector_t		lba;	/* LBA from the scsi command */
> +	int			size;	/* size of the request */
> +	struct scsi_sense_hdr	sshdr;
> +};
> +#endif
> +
>  struct scsi_event {
>  	enum scsi_device_event	evt_type;
>  	struct list_head	node;
> @@ -78,6 +88,11 @@ struct scsi_event {
>  	/* put union of data structures, for non-simple event types,
>  	 * here
>  	 */
> +	union {
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +		struct scsi_sense_uevent_data sense_evt_data;
> +#endif
> +	};
>  };
>
>  struct scsi_device {
> @@ -197,6 +212,15 @@ struct scsi_device {
>  	atomic_t iodone_cnt;
>  	atomic_t ioerr_cnt;
>
> +#ifdef CONFIG_SCSI_SENSE_UEVENT
> +	/*
> +	 * filter of sense code uevent
> +	 * setting bit X (0x00 - 0x0e) of sense_event_filter enables
> +	 * uevent for sense key X
> +	 */
> +	unsigned long		sense_event_filter;
> +#endif
> +
>  	struct device		sdev_gendev,
>  				sdev_dev;
>
> --
> 2.9.3
>

--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
