From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH v4 5/7] scsi-ml: adds queue_depth ramp up code
Date: Fri, 23 Oct 2009 15:53:26 +0200
Message-ID: <20091023135325.GA21018@schmichrtp.de.ibm.com>
References: <20091016004700.22451.42962.stgit@vifc.jf.intel.com> <20091022224627.20122.78013.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:49565 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZJWNxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 09:53:50 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n9NDrd6D517420
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 13:53:44 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9NDrT553264550
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 14:53:29 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9NDrSp1000787
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 14:53:28 +0100
Content-Disposition: inline
In-Reply-To: <20091022224627.20122.78013.stgit@vifc.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

On Thu, Oct 22, 2009 at 03:46:33PM -0700, Vasu Dev wrote:
> Current FC HBA queue_depth ramp up code depends on last queue
> full time. The sdev already  has last_queue_full_time field to
> track last queue full time but stored value is truncated by
> last four bits.
> 
> So this patch updates last_queue_full_time without truncating
> last 4 bits to store full value and then updates its only
> current usages in scsi_track_queue_full to ignore last four bits
> to keep current usages same while also use this field
> in added ramp up code.
> 
> Adds scsi_handle_queue_ramp_up to ramp up queue_depth on
> successful completion of IO. The scsi_handle_queue_ramp_up will
> do ramp up on all luns of a target, just same as ramp down done
> on all luns on a target.
> 
> The ramp up is skipped in case the change_queue_depth is not
> supported by LLD or already reached to added max_queue_depth.
> 
> Updates added max_queue_depth on every new update to default
> queue_depth value.
> 
> The ramp up is also skipped if lapsed time since either last
> queue ramp up or down is less than LLD specified
> queue_ramp_up_period.
> 
> Adds queue_ramp_up_period to sysfs but only if change_queue_depth
> is supported since ramp up and queue_ramp_up_period is needed only
> in case change_queue_depth is supported first.
> 
> Initializes queue_ramp_up_period to 120HZ jiffies as initial
> default value, it is same as used in existing lpfc and qla2xxx.
> 
> -v2
>  Combined all ramp code into this single patch.
> 
> -v3
>  Moves max_queue_depth initialization after slave_configure is
> called from after slave_alloc calling done. Also adjusted
> max_queue_depth check to skip ramp up if current queue_depth
> is >= max_queue_depth.
> 
> -v4
>  Changes sdev->queue_ramp_up_period unit to ms when using sysfs i/f
> to store or show its value.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>

The patch looks good. I also ran a brief test on s390 again.

Acked-and-tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>

> ---
> 
>  drivers/scsi/scsi.c        |   10 ++++++++--
>  drivers/scsi/scsi_error.c  |   38 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_scan.c   |    3 +++
>  drivers/scsi/scsi_sysfs.c  |   41 +++++++++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_device.h |    9 ++++++---
>  5 files changed, 94 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index dd098ca..a60da55 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -940,10 +940,16 @@ EXPORT_SYMBOL(scsi_adjust_queue_depth);
>   */
>  int scsi_track_queue_full(struct scsi_device *sdev, int depth)
>  {
> -	if ((jiffies >> 4) == sdev->last_queue_full_time)
> +
> +	/*
> +	 * Don't let QUEUE_FULLs on the same
> +	 * jiffies count, they could all be from
> +	 * same event.
> +	 */
> +	if ((jiffies >> 4) == (sdev->last_queue_full_time >> 4))
>  		return 0;
> 
> -	sdev->last_queue_full_time = (jiffies >> 4);
> +	sdev->last_queue_full_time = jiffies;
>  	if (sdev->last_queue_full_depth != depth) {
>  		sdev->last_queue_full_count = 1;
>  		sdev->last_queue_full_depth = depth;
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 7b1e20f..08ed506 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -331,6 +331,42 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  	}
>  }
> 
> +static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
> +{
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	struct scsi_device *tmp_sdev;
> +
> +	if (!sht->change_queue_depth ||
> +	    sdev->queue_depth >= sdev->max_queue_depth)
> +		return;
> +
> +	if (time_before(jiffies,
> +	    sdev->last_queue_ramp_up + sdev->queue_ramp_up_period))
> +		return;
> +
> +	if (time_before(jiffies,
> +	    sdev->last_queue_full_time + sdev->queue_ramp_up_period))
> +		return;
> +
> +	/*
> +	 * Walk all devices of a target and do
> +	 * ramp up on them.
> +	 */
> +	shost_for_each_device(tmp_sdev, sdev->host) {
> +		if (tmp_sdev->channel != sdev->channel ||
> +		    tmp_sdev->id != sdev->id ||
> +		    tmp_sdev->queue_depth == sdev->max_queue_depth)
> +			continue;
> +		/*
> +		 * call back into LLD to increase queue_depth by one
> +		 * with ramp up reason code.
> +		 */
> +		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
> +					SCSI_QDEPTH_RAMP_UP);
> +		sdev->last_queue_ramp_up = jiffies;
> +	}
> +}
> +
>  static void scsi_handle_queue_full(struct scsi_device *sdev)
>  {
>  	struct scsi_host_template *sht = sdev->host->hostt;
> @@ -393,6 +429,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
>  	 */
>  	switch (status_byte(scmd->result)) {
>  	case GOOD:
> +		scsi_handle_queue_ramp_up(scmd->device);
>  	case COMMAND_TERMINATED:
>  		return SUCCESS;
>  	case CHECK_CONDITION:
> @@ -1425,6 +1462,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  		 */
>  		return ADD_TO_MLQUEUE;
>  	case GOOD:
> +		scsi_handle_queue_ramp_up(scmd->device);
>  	case COMMAND_TERMINATED:
>  		return SUCCESS;
>  	case TASK_ABORTED:
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index cb6338f..2847a86 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -251,6 +251,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	sdev->model = scsi_null_device_strs;
>  	sdev->rev = scsi_null_device_strs;
>  	sdev->host = shost;
> +	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>  	sdev->id = starget->id;
>  	sdev->lun = lun;
>  	sdev->channel = starget->channel;
> @@ -940,6 +941,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  		}
>  	}
> 
> +	sdev->max_queue_depth = sdev->queue_depth;
> +
>  	/*
>  	 * Ok, the device is now all set up, we can
>  	 * register it and tell the rest of the kernel
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 4c59336..3a9e805 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -771,6 +771,8 @@ sdev_store_queue_depth_rw(struct device *dev, struct device_attribute *attr,
>  	if (retval < 0)
>  		return retval;
> 
> +	sdev->max_queue_depth = sdev->queue_depth;
> +
>  	return count;
>  }
> 
> @@ -779,6 +781,37 @@ static struct device_attribute sdev_attr_queue_depth_rw =
>  	       sdev_store_queue_depth_rw);
> 
>  static ssize_t
> +sdev_show_queue_ramp_up_period(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	struct scsi_device *sdev;
> +	sdev = to_scsi_device(dev);
> +	return snprintf(buf, 20, "%u\n",
> +			jiffies_to_msecs(sdev->queue_ramp_up_period));
> +}
> +
> +static ssize_t
> +sdev_store_queue_ramp_up_period(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned long period;
> +
> +	if (strict_strtoul(buf, 10, &period))
> +		return -EINVAL;
> +
> +	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
> +	return period;
> +}
> +
> +static struct device_attribute sdev_attr_queue_ramp_up_period =
> +	__ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
> +	       sdev_show_queue_ramp_up_period,
> +	       sdev_store_queue_ramp_up_period);
> +
> +static ssize_t
>  sdev_store_queue_type_rw(struct device *dev, struct device_attribute *attr,
>  			 const char *buf, size_t count)
>  {
> @@ -870,8 +903,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	get_device(&sdev->sdev_gendev);
> 
>  	/* create queue files, which may be writable, depending on the host */
> -	if (sdev->host->hostt->change_queue_depth)
> -		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
> +	if (sdev->host->hostt->change_queue_depth) {
> +		error = device_create_file(&sdev->sdev_gendev,
> +					   &sdev_attr_queue_depth_rw);
> +		error = device_create_file(&sdev->sdev_gendev,
> +					   &sdev_attr_queue_ramp_up_period);
> +	}
>  	else
>  		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
>  	if (error) {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 9af48cb..92c4c3b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -81,11 +81,14 @@ struct scsi_device {
>  	struct list_head starved_entry;
>  	struct scsi_cmnd *current_cmnd;	/* currently active command */
>  	unsigned short queue_depth;	/* How deep of a queue we want */
> +	unsigned short max_queue_depth;	/* max queue depth */
>  	unsigned short last_queue_full_depth; /* These two are used by */
>  	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
> -	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same
> -					   jiffie count on our counter, they
> -					   could all be from the same event. */
> +	unsigned long last_queue_full_time;	/* last queue full time */
> +	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
> +#define SCSI_DEFAULT_RAMP_UP_PERIOD	(120 * HZ)
> +
> +	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
> 
>  	unsigned int id, lun, channel;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
