From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 08/10] scsi: Generate uevents on certain unit
 attention codes
Date: Fri, 02 Aug 2013 10:06:12 -0700
Message-ID: <1375463172.2062.28.camel@dabdike.int.hansenpartnership.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
	 <1375390659-12495-9-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43498 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab3HBRGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 13:06:13 -0400
In-Reply-To: <1375390659-12495-9-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-08-01 at 16:57 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> Generate a uevent when the following Unit Attention ASC/ASCQ
> codes are received:
> 
>     2A/01  MODE PARAMETERS CHANGED
>     2A/09  CAPACITY DATA HAS CHANGED
>     38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
>     3F/03  INQUIRY DATA HAS CHANGED
>     3F/0E  REPORTED LUNS DATA HAS CHANGED
> 
> Log kernel messages when the following Unit Attention ASC/ASCQ
> codes are received that are not as specific as those above:
> 
>     2A/xx  PARAMETERS CHANGED
>     3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED
> 
> Added logic to set expecting_cc_ua for other LUNs on SPC-3 devices
> after REPORTED LUNS DATA HAS CHANGED is received, so that duplicate
> uevents are not generated, and clear expecting_cc_ua when a
> REPORT LUNS command completes, in accordance with the SPC-3
> specification regarding reporting of the 3F 0E ASC/ASCQ UA.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_error.c  | 118 +++++++++++++++++++++++++++++++++++++--------
>  drivers/scsi/scsi_lib.c    |  42 ++++++++++++++--
>  drivers/scsi/scsi_sysfs.c  |  10 ++++
>  include/scsi/scsi_device.h |  11 ++++-
>  4 files changed, 156 insertions(+), 25 deletions(-)

In general, this looks good.  Just a few points below, and I think it
can go in.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 96707a6..227041a 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -222,6 +222,86 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>  }
>  #endif
>  
> + /**
> + * scsi_report_lun_change - Set flag on all *other* devices on the same target
> + *                          to indicate that a UNIT ATTENTION is expected.
> + *                          Only do this for SPC-3 devices, however.
> + * @sdev:	Device reporting the UNIT ATTENTION
> + */
> +static void scsi_report_lun_change(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_device *tmp_sdev;
> +
> +	if (sdev->scsi_level == SCSI_SPC_3)

Why the SPC3 check?  We have SPC2 targets that use report luns and
presumably work as well.

> +		shost_for_each_device(tmp_sdev, shost) {
> +			if (tmp_sdev->channel == sdev->channel &&
> +			    tmp_sdev->id == sdev->id &&
> +			    tmp_sdev != sdev)

This should be starget_for_each_device calling a function rather than
hand rolling.

> +				tmp_sdev->expecting_cc_ua = 1;

Even with a restricted target loop, this is a bit messy (I think it's my
fault: I did ask you to reuse the existing mechanism, but now I see it,
a separate mechanism that functions the same way on the target looks a
lot cleaner) .  It looks like a struct scsi_target
expecting_lun_change:1 flag would work better in this case?  You'd set
it in the target at first sight, check it in scsi_report_sense() and
clear it on successful REPORT_LUNS command.  There's no need to lock it
because operations on a u32 are atomic and we're going to get slop
around this and the possibility of extra events anyway.

> +		}
> +}
> +
> +/**
> + * scsi_report_sense - Examine scsi sense information and log messages for
> + *		       certain conditions, also issue uevents for some of them.
> + * @sshdr:	sshdr to be examined
> + */
> +static void scsi_report_sense(struct scsi_device *sdev,
> +			      struct scsi_sense_hdr *sshdr)
> +{
> +	enum scsi_device_event evt_type = SDEV_EVT_MAXBITS;	/* i.e. none */
> +	unsigned long flags;
> +
> +	if (sshdr->sense_key == UNIT_ATTENTION) {
> +		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
> +			evt_type = SDEV_EVT_INQUIRY_CHANGE_REPORTED;
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Inquiry data has changed");
> +		} else if (sshdr->asc == 0x3f && sshdr->ascq == 0x0e) {
> +			evt_type = SDEV_EVT_LUN_CHANGE_REPORTED;
> +			scsi_report_lun_change(sdev);
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "LUN assignments on this target have "
> +				    "changed. The Linux SCSI layer does not "
> +				    "automatically remap LUN assignments.\n");
> +		} else if (sshdr->asc == 0x3f)
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "operating parameters on this target have "
> +				    "changed. The Linux SCSI layer does not "
> +				    "automatically adjust these parameters.\n");
> +
> +		if (sshdr->asc == 0x38 && sshdr->ascq == 0x07) {
> +			evt_type = SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED;
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Warning! Received an indication that the "
> +				    "LUN reached a thin provisioning soft "
> +				    "threshold.\n");
> +		}
> +
> +		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
> +			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Mode parameters changed");
> +		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
> +			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Capacity data has changed");
> +		} else if (sshdr->asc == 0x2a)
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "Parameters changed");
> +	}
> +
> +	if (evt_type != SDEV_EVT_MAXBITS) {
> +		spin_lock_irqsave(&sdev->list_lock, flags);
> +		set_bit(evt_type, sdev->pending_events);
> +		spin_unlock_irqrestore(&sdev->list_lock, flags);

This is a bitmap: bitmaps can be processed locklessly, just use
test_and_clear_bit in the consumer.

> +		schedule_work(&sdev->event_work);
> +	}
> +}
> +
>  /**
>   * scsi_check_sense - Examine scsi cmd sense
>   * @scmd:	Cmd to have sense checked.
> @@ -241,6 +321,8 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  	if (! scsi_command_normalize_sense(scmd, &sshdr))
>  		return FAILED;	/* no valid sense data */
>  
> +	scsi_report_sense(sdev, &sshdr);
> +
>  	if (scsi_sense_is_deferred(&sshdr))
>  		return NEEDS_RETRY;
>  
> @@ -291,7 +373,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  		 * if we are expecting a cc/ua because of a bus reset that we
>  		 * performed, treat this just as a retry.  otherwise this is
>  		 * information that we should pass up to the upper-level driver
> -		 * so that we can deal with it there.
> +		 * so that we can deal with it there.  we might also expect a
> +		 * cc/ua if another LUN on the target reported a UA with
> +		 * ASC/ASCQ of 3F 0E - REPORTED LUNS DATA HAS CHANGED.
>  		 */
>  		if (scmd->device->expecting_cc_ua) {
>  			/*
> @@ -318,26 +402,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  		if (scmd->device->allow_restart &&
>  		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
>  			return FAILED;
> -
> -		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
> -			scmd_printk(KERN_WARNING, scmd,
> -				    "Warning! Received an indication that the "
> -				    "LUN assignments on this target have "
> -				    "changed. The Linux SCSI layer does not "
> -				    "automatically remap LUN assignments.\n");
> -		else if (sshdr.asc == 0x3f)
> -			scmd_printk(KERN_WARNING, scmd,
> -				    "Warning! Received an indication that the "
> -				    "operating parameters on this target have "
> -				    "changed. The Linux SCSI layer does not "
> -				    "automatically adjust these parameters.\n");
> -
> -		if (sshdr.asc == 0x38 && sshdr.ascq == 0x07)
> -			scmd_printk(KERN_WARNING, scmd,
> -				    "Warning! Received an indication that the "
> -				    "LUN reached a thin provisioning soft "
> -				    "threshold.\n");
> -
>  		/*
>  		 * Pass the UA upwards for a determination in the completion
>  		 * functions.
> @@ -1414,6 +1478,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   */
>  int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  {
> +	struct scsi_device *sdev;
>  	int rtn;
>  
>  	/*
> @@ -1544,9 +1609,20 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  		 * Reset expecting_cc_ua for all commands except INQUIRY and
>  		 * REPORT LUNS, because if we didn't get a UA on this command
>  		 * as expected, then we don't want to suppress a subsequent one.
> +		 *
> +		 * A successful REPORT LUNS should reset expecting_cc_ua for
> +		 * REPORTED LUNS DATA HAS CHANGED on all LUNs on the target.
> +		 * (In general, we do not get a REPORT LUNS on the same LUN that
> +		 * originally reported the REPORTED LUNS DATA HAS CHANGED UA.)
>  		 */
>  		if (scmd->cmnd[0] != INQUIRY && scmd->cmnd[0] != REPORT_LUNS)
>  			scmd->device->expecting_cc_ua = 0;
> +		else if (scmd->cmnd[0] == REPORT_LUNS)
> +			shost_for_each_device(sdev, scmd->device->host) {
> +				if (sdev->channel == scmd->device->channel &&
> +				    sdev->id == scmd->device->id)

starget_for_each_device(), but switching to a target flag makes this
entire loop go away.

> +					sdev->expecting_cc_ua = 0;
> +			}
>  		scsi_handle_queue_ramp_up(scmd->device);
>  	case COMMAND_TERMINATED:
>  		return SUCCESS;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f871ecf..1dd107f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2181,12 +2181,28 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  {
>  	int idx = 0;
>  	char *envp[2];
> +	int target = 0;
>  
>  	switch (evt->evt_type) {
>  	case SDEV_EVT_MEDIA_CHANGE:
>  		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
>  		break;
> -
> +	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
> +		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
> +		break;
> +	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> +		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
> +		break;
> +	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
> +	       envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
> +		break;
> +	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
> +		envp[idx++] = "SDEV_UA=MODE_PARAMETERS_CHANGED";
> +		break;
> +	case SDEV_EVT_LUN_CHANGE_REPORTED:
> +		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
> +		target = 1;
> +		break;
>  	default:
>  		/* do nothing */
>  		break;
> @@ -2194,7 +2210,11 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  
>  	envp[idx++] = NULL;
>  
> -	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
> +	if (target)
> +		kobject_uevent_env(&sdev->sdev_target->dev.kobj, KOBJ_CHANGE,
> +				   envp);
> +	else
> +		kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
>  }
>  
>  /**
> @@ -2207,14 +2227,25 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
>  void scsi_evt_work(struct work_struct *work)
>  {
>  	struct scsi_device *sdev;
> +	unsigned long flags;
> +	DECLARE_BITMAP(tmp_events, SDEV_EVT_MAXBITS);
> +	enum scsi_device_event evt_type;
>  	LIST_HEAD(event_list);
>  
>  	sdev = container_of(work, struct scsi_device, event_work);
>  
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	memcpy(tmp_events, sdev->pending_events, sizeof(sdev->pending_events));
> +	memset(sdev->pending_events, 0, sizeof(sdev->pending_events));
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +
> +	for (evt_type = SDEV_EVT_FIRST; evt_type <= SDEV_EVT_LAST; evt_type++)
> +		if (test_bit(evt_type, tmp_events))
> +			sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
> +
>  	while (1) {
>  		struct scsi_event *evt;
>  		struct list_head *this, *tmp;
> -		unsigned long flags;
>  
>  		spin_lock_irqsave(&sdev->list_lock, flags);
>  		list_splice_init(&sdev->event_list, &event_list);
> @@ -2280,6 +2311,11 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
>  	/* evt_type-specific initialization, if any */
>  	switch (evt_type) {
>  	case SDEV_EVT_MEDIA_CHANGE:
> +	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
> +	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> +	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
> +	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
> +	case SDEV_EVT_LUN_CHANGE_REPORTED:
>  	default:
>  		/* do nothing */
>  		break;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 34f7580..d5d86b2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -710,6 +710,11 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
>  #define REF_EVT(name) &dev_attr_evt_##name.attr
>  
>  DECLARE_EVT(media_change, MEDIA_CHANGE)
> +DECLARE_EVT(inquiry_change_reported, INQUIRY_CHANGE_REPORTED)
> +DECLARE_EVT(capacity_change_reported, CAPACITY_CHANGE_REPORTED)
> +DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
> +DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
> +DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
>  
>  /* Default template for device attributes.  May NOT be modified */
>  static struct attribute *scsi_sdev_attrs[] = {
> @@ -729,6 +734,11 @@ static struct attribute *scsi_sdev_attrs[] = {
>  	&dev_attr_ioerr_cnt.attr,
>  	&dev_attr_modalias.attr,
>  	REF_EVT(media_change),
> +	REF_EVT(inquiry_change_reported),
> +	REF_EVT(capacity_change_reported),
> +	REF_EVT(soft_threshold_reached),
> +	REF_EVT(mode_parameter_change_reported),
> +	REF_EVT(lun_change_reported),

This last one should be a property of the target attributes, shouldn't
it?  Otherwise the listener receives and event on the target and has to
go fishing around trying to find the one LUN we set the flag on.

Either we keep the flag on the sdev and send the event from the sdev or
we move the flag to the target and send the event from the target.

>  	NULL
>  };
>  
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6efb2e1..0a79f0c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -51,8 +51,16 @@ enum scsi_device_state {
>  
>  enum scsi_device_event {
>  	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
> +	SDEV_EVT_INQUIRY_CHANGE_REPORTED	= 2,	/* UA reported */
> +	SDEV_EVT_CAPACITY_CHANGE_REPORTED	= 3,	/* UA reported */
> +	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED	= 4,  /* UA reported */
> +	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED	= 5,	/* UA reported */
> +
> +	SDEV_EVT_LUN_CHANGE_REPORTED	= 6,	/* UA reported */

You don't need to explicitly number an enumeration.  The point is the
compiler does it for you so we can't screw up and add something with the
same number twice.

James

> +
> +	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
> +	SDEV_EVT_LAST		= SDEV_EVT_LUN_CHANGE_REPORTED,
>  
> -	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
>  	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
>  };
>  
> @@ -154,6 +162,7 @@ struct scsi_device {
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
> +	DECLARE_BITMAP(pending_events, SDEV_EVT_MAXBITS); /* pending events */
>  	struct list_head event_list;	/* asserted events */
>  	struct work_struct event_work;
>  



