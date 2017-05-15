From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] scsi: generate uevent for SCSI sense code
Date: Mon, 15 May 2017 08:04:34 +0200
Message-ID: <54b76bb9-8279-dc71-2c08-661eb3c4512f@suse.de>
References: <20170504005013.2865393-1-songliubraving@fb.com>
 <20170504005013.2865393-2-songliubraving@fb.com>
 <54323B49-47CF-403A-970E-F94EDE2E0558@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752184AbdEOGEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 02:04:37 -0400
In-Reply-To: <54323B49-47CF-403A-970E-F94EDE2E0558@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On 05/12/2017 09:02 PM, Song Liu wrote:
> 
>> On May 3, 2017, at 5:50 PM, Song Liu <songliubraving@fb.com> wrote:
>>
>> This patch adds capability for SCSI layer to generate uevent for SCSI
>> sense code. The feature is gated by CONFIG_SCSI_SENSE_UEVENT.
>>
>> We can configure which sense keys generate uevent for each device
>> through sysfs entry sense_event_filter. For example, the following
>> enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
>> on scsi drive sdc:
>>
>>    echo 0x000c > /sys/block/sdc/device/sense_event_filter
>>
>> Here is an example output captured by udevadm:
>>
>> KERNEL[1214.945358] change   /devices/pci0000:00/XXXXXXX
>> ACTION=change
>> DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/XXXXXXX
>> DEVTYPE=scsi_device
>> DRIVER=sd
>> LBA=0
>> MODALIAS=scsi:t-0x00
>> SDEV_UA=SCSI_SENSE
>> SENSE_CODE=3/11/14
>> SEQNUM=4536
>> SIZE=4096
>> SUBSYSTEM=scsi
>>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/scsi/Kconfig       | 14 +++++++++++
>> drivers/scsi/scsi_error.c  | 26 ++++++++++++++++++++
>> drivers/scsi/scsi_lib.c    | 27 +++++++++++++++++++--
>> drivers/scsi/scsi_sysfs.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++++
>> include/scsi/scsi_device.h | 26 +++++++++++++++++++-
>> 5 files changed, 150 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 3c52867..4f7f211 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -237,6 +237,20 @@ config SCSI_LOGGING
>> 	  there should be no noticeable performance impact as long as you have
>> 	  logging turned off.
>>
>> +config SCSI_SENSE_UEVENT
>> +	bool "SCSI sense code logging"
>> +	depends on SCSI
>> +	default n
>> +	---help---
>> +	  This turns on uevent for SCSI sense code.
>> +
>> +	  You can configure which sense keys generate uevent for each device
>> +	  through sysfs entry sense_event_filter. For example, the following
>> +	  enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
>> +	  on scsi drive sdc:
>> +
>> +	  echo 0x000c > /sys/block/sdc/device/sense_event_filter
>> +
>> config SCSI_SCAN_ASYNC
>> 	bool "Asynchronous SCSI scanning"
>> 	depends on SCSI
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index d70c67c..eda150e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -426,6 +426,31 @@ static void scsi_report_sense(struct scsi_device *sdev,
>> 	}
>> }
>>
>> +/*
>> + * generate uevent when receiving sense code from device
>> + */
>> +static void scsi_send_sense_uevent(struct scsi_device *sdev,
>> +				   struct scsi_cmnd *scmd,
>> +				   struct scsi_sense_hdr *sshdr)
>> +{
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +	struct scsi_event *evt;
>> +
>> +	if (!test_bit(sshdr->sense_key & 0xf,
>> +		      &sdev->sense_event_filter))
>> +		return;
>> +	evt = sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
>> +	if (!evt)
>> +		return;
>> +
>> +	evt->sense_evt_data.lba = scsi_get_lba(scmd);
>> +	evt->sense_evt_data.size = blk_rq_bytes(scmd->request);
>> +	memcpy(&evt->sense_evt_data.sshdr, sshdr,
>> +	       sizeof(struct scsi_sense_hdr));
>> +	sdev_evt_send(sdev, evt);
>> +#endif
>> +}
>> +
>> /**
>>  * scsi_check_sense - Examine scsi cmd sense
>>  * @scmd:	Cmd to have sense checked.
>> @@ -446,6 +471,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>> 		return FAILED;	/* no valid sense data */
>>
>> 	scsi_report_sense(sdev, &sshdr);
>> +	scsi_send_sense_uevent(sdev, scmd, &sshdr);
>>
>> 	if (scsi_sense_is_deferred(&sshdr))
>> 		return NEEDS_RETRY;
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 95f963b..1095f27 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2656,8 +2656,9 @@ EXPORT_SYMBOL(scsi_device_set_state);
>>  */
>> static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>> {
>> -	int idx = 0;
>> -	char *envp[3];
>> +	int idx = 0, i;
>> +	char *envp[5];	/* SDEV_EVT_SCSI_SENSE needs most entries (4) */
>> +	int free_envp = -1;
>>
>> 	switch (evt->evt_type) {
>> 	case SDEV_EVT_MEDIA_CHANGE:
>> @@ -2682,6 +2683,23 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>> 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
>> 		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
>> 		break;
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +	case SDEV_EVT_SCSI_SENSE:
>> +		envp[idx++] = "SDEV_UA=SCSI_SENSE";
>> +		for (i = idx; i < idx + 3; ++i) {
>> +			envp[i] = kzalloc(32, GFP_ATOMIC);
>> +			if (!envp[i])
>> +				break;
>> +			free_envp = i;
>> +		}
>> +		snprintf(envp[idx++], 32, "LBA=%lu", evt->sense_evt_data.lba);
>> +		snprintf(envp[idx++], 32, "SIZE=%d", evt->sense_evt_data.size);
>> +		snprintf(envp[idx++], 32, "SENSE_CODE=%1x/%02x/%02x",
>> +			 evt->sense_evt_data.sshdr.sense_key,
>> +			 evt->sense_evt_data.sshdr.asc,
>> +			 evt->sense_evt_data.sshdr.ascq);
>> +		break;
>> +#endif
>> 	default:
>> 		/* do nothing */
>> 		break;
>> @@ -2690,6 +2708,10 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>> 	envp[idx++] = NULL;
>>
>> 	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
>> +
>> +	/* no need to free envp[0], so start with i = 1 */
>> +	for (i = 1 ; i < free_envp; ++i)
>> +		kfree(envp[i]);
>> }
>>
This can't be right; you're just allocating envp starting from 'idx',
but free up all of them.

>> /**
>> @@ -2786,6 +2808,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
>> 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
>> 	case SDEV_EVT_LUN_CHANGE_REPORTED:
>> 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
>> +	case SDEV_EVT_SCSI_SENSE:
>> 	default:
>> 		/* do nothing */
>> 		break;
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 82dfe07..cfc7380 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1072,6 +1072,63 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
>> 		   sdev_show_queue_ramp_up_period,
>> 		   sdev_store_queue_ramp_up_period);
>>
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +
>> +/*
>> + * SCSI sense key could be 0x00 - 0x08, 0x0a, 0x0b, 0x0d, 0x0e, so the
>> + * mask is 0x6dff.
>> + */
>> +#define SCSI_SENSE_EVENT_FILTER_MASK	0x6dff
>> +
>> +static ssize_t
>> +sdev_show_sense_event_filter(struct device *dev,
>> +			     struct device_attribute *attr,
>> +			     char *buf)
>> +{
>> +	struct scsi_device *sdev;
>> +
>> +	sdev = to_scsi_device(dev);
>> +	return snprintf(buf, 20, "0x%04lx\n",
>> +			(sdev->sense_event_filter &
>> +			 SCSI_SENSE_EVENT_FILTER_MASK));
>> +}
>> +
>> +static ssize_t
>> +sdev_store_sense_event_filter(struct device *dev,
>> +			      struct device_attribute *attr,
>> +			      const char *buf, size_t count)
>> +{
>> +	struct scsi_device *sdev = to_scsi_device(dev);
>> +	unsigned long filter;
>> +	int i;
>> +
>> +	if (buf[0] == '0' && buf[1] == 'x') {
>> +		if (kstrtoul(buf + 2, 16, &filter))
>> +			return -EINVAL;
>> +	} else
>> +		if (kstrtoul(buf, 10, &filter))
>> +			return -EINVAL;
>> +
>> +	/*
>> +	 * Accurate mask for all sense keys is 0x6dff. However, we allow
>> +	 * user to enable event for all sense keys by echoing 0xffff
>> +	 */
>> +	if ((filter & 0xffff) != filter)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < 15; i++)
>> +		if (filter & SCSI_SENSE_EVENT_FILTER_MASK  & (1 << i))
>> +			set_bit(i, &sdev->sense_event_filter);
>> +		else
>> +			clear_bit(i, &sdev->sense_event_filter);
>> +	return count;
>> +}
>> +
>> +static DEVICE_ATTR(sense_event_filter, 0644,
>> +		   sdev_show_sense_event_filter,
>> +		   sdev_store_sense_event_filter);
>> +#endif
>> +
>> static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
>> 					 struct attribute *attr, int i)
>> {
>> @@ -1142,6 +1199,9 @@ static struct attribute *scsi_sdev_attrs[] = {
>> 	&dev_attr_preferred_path.attr,
>> #endif
>> 	&dev_attr_queue_ramp_up_period.attr,
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +	&dev_attr_sense_event_filter.attr,
>> +#endif
>> 	REF_EVT(media_change),
>> 	REF_EVT(inquiry_change_reported),
>> 	REF_EVT(capacity_change_reported),
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 05641ae..d160bd7 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -64,13 +64,23 @@ enum scsi_device_event {
>> 	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
>> 	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
>> 	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
>> +	SDEV_EVT_SCSI_SENSE,
>>
>> 	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
>> -	SDEV_EVT_LAST		= SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,
>> +	SDEV_EVT_LAST		= SDEV_EVT_SCSI_SENSE,
>>
>> 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
>> };
>>
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +/* data for for SDEV_EVT_SCSI_SENSE */
>> +struct scsi_sense_uevent_data {
>> +	sector_t		lba;	/* LBA from the scsi command */
>> +	int			size;	/* size of the request */
>> +	struct scsi_sense_hdr	sshdr;
>> +};
>> +#endif
>> +
>> struct scsi_event {
>> 	enum scsi_device_event	evt_type;
>> 	struct list_head	node;
>> @@ -78,6 +88,11 @@ struct scsi_event {
>> 	/* put union of data structures, for non-simple event types,
>> 	 * here
>> 	 */
>> +	union {
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +		struct scsi_sense_uevent_data sense_evt_data;
>> +#endif
>> +	};
>> };
>>
>> struct scsi_device {
>> @@ -197,6 +212,15 @@ struct scsi_device {
>> 	atomic_t iodone_cnt;
>> 	atomic_t ioerr_cnt;
>>
>> +#ifdef CONFIG_SCSI_SENSE_UEVENT
>> +	/*
>> +	 * filter of sense code uevent
>> +	 * setting bit X (0x00 - 0x0e) of sense_event_filter enables
>> +	 * uevent for sense key X
>> +	 */
>> +	unsigned long		sense_event_filter;
>> +#endif
>> +
>> 	struct device		sdev_gendev,
>> 				sdev_dev;
>>
>> -- 
>> 2.9.3
> 
In general I like the idea; however, the 'filter' thingie is somewhat
odd. I could somewhat buy into the idea of filtering for sense keys, but
then I would have expected to use the 'sense_event_filter' as a bitmap
of allowed sense keys.
With your current design you can only filter for one specific sense key,
_and_ you leave the remaining bits of the sense_event_filter variable
unused.
So either turn it into a bitmap and allow for several sense keys to be
filtered, or treat it as mask for the _entire_ sense, but then you'd
need for ASC and ASCQ, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
