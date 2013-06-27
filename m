From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Thu, 27 Jun 2013 10:33:09 -0400
Message-ID: <1372343589.3871.406.camel@localhost.localdomain>
References: <1370862713-41323-1-git-send-email-hare@suse.de>
	 <1370862713-41323-8-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3F0Odv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jun 2013 10:33:51 -0400
In-Reply-To: <1370862713-41323-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

The eh_deadline changes allow for a significant improvement
in multipath failover time.  It works very well in our testing.
I do have a few corrections, see below:

On Mon, 2013-06-10 at 13:11 +0200, Hannes Reinecke wrote:
> This patchs adds an 'eh_deadline' attribute to the scsi
> host which limits the overall runtime of the SCSI EH.
> When a command is failed the start time of the EH is stored
> in 'last_reset'. If the overall runtime of the SCSI EH is longer
> than last_reset + eh_deadline, the EH is short-circuited and
> falls through to issue a host reset only.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/hosts.c      |   7 +++
>  drivers/scsi/scsi_error.c | 142 +++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/scsi_sysfs.c |  37 ++++++++++++
>  include/scsi/scsi_host.h  |   2 +-
>  4 files changed, 180 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index df0c3c7..c8d828f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -316,6 +316,12 @@ static void scsi_host_dev_release(struct device *dev)
>  	kfree(shost);
>  }
>  
> +static unsigned int shost_eh_deadline;
> +
> +module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(eh_deadline,
> +		 "SCSI EH deadline in seconds (should be between 1 and 2^32-1)");
> +
>  static struct device_type scsi_host_type = {
>  	.name =		"scsi_host",
>  	.release =	scsi_host_dev_release,
> @@ -388,6 +394,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> +	shost->eh_deadline = shost_eh_deadline;

This should be shost->eh_deadline = shost_eh_deadline * HZ; since the
parameter is specified in seconds.

>  
>  	if (sht->supported_mode == MODE_UNKNOWN)
>  		/* means we didn't set it ... default to INITIATOR */
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 467cb3c..cf30475 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -91,6 +91,31 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>  }
>  EXPORT_SYMBOL_GPL(scsi_schedule_eh);
>  
> +static int sdev_eh_deadline(struct Scsi_Host *shost,
> +			   unsigned long eh_start)
> +{
> +	if (!shost->eh_deadline)
> +		return 0;
> +
> +	if (shost->last_reset != 0 &&
> +	    time_before(shost->last_reset, eh_start))
> +		eh_start = shost->last_reset;
> +
> +	if (time_before(jiffies,
> +			eh_start + shost->eh_deadline))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int scsi_host_eh_deadline(struct Scsi_Host *shost)
> +{
> +	if (!shost->last_reset)
> +		return 0;
> +
> +	return sdev_eh_deadline(shost, shost->last_reset);
> +}
> +
>  /**
>   * scsi_eh_abort_handler - Handle command aborts
>   * @work:	sdev on which commands should be aborted.
> @@ -102,13 +127,15 @@ scsi_eh_abort_handler(struct work_struct *work)
>  		container_of(work, struct scsi_device, abort_work);
>  	struct scsi_cmnd *scmd, *tmp;
>  	LIST_HEAD(abort_list);
> -	unsigned long flags;
> +	unsigned long flags, eh_start;
>  	int rtn;
>  
>  	spin_lock_irqsave(&sdev->list_lock, flags);
>  	list_splice_init(&sdev->eh_abort_list, &abort_list);
>  	spin_unlock_irqrestore(&sdev->list_lock, flags);
>  
> +	eh_start = jiffies;
> +
>  	list_for_each_entry_safe(scmd, tmp, &abort_list, eh_entry) {
>  		list_del_init(&scmd->eh_entry);
>  		if (sdev->sdev_state == SDEV_CANCEL) {
> @@ -119,6 +146,13 @@ scsi_eh_abort_handler(struct work_struct *work)
>  			scsi_finish_command(scmd);
>  			continue;
>  		}
> +		if (sdev_eh_deadline(sdev->host, eh_start)) {
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				scmd_printk(KERN_INFO, scmd,
> +					     "eh timeout, not aborting\n"));
> +			list_move_tail(&scmd->eh_entry, &abort_list);
> +			goto start_eh;
> +		}
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_INFO, scmd,
>  				    "aborting command %p\n", scmd));
> @@ -151,6 +185,12 @@ scsi_eh_abort_handler(struct work_struct *work)
>  		return;
>  
>  start_eh:
> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	if (sdev->host->eh_deadline &&
> +	    (!sdev->host->last_reset ||
> +	     time_before(eh_start, sdev->host->last_reset)))
> +		sdev->host->last_reset = eh_start;
> +	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>  	list_for_each_entry_safe(scmd, tmp, &abort_list, eh_entry) {
>  		scmd->result |= DID_TIME_OUT << 16;
>  		if (!scsi_eh_scmd_add(scmd, 0)) {
> @@ -232,6 +272,9 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>  		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
>  			goto out_unlock;
>  
> +	if (sdev->eh_deadline && !shost->last_reset)
> +		shost->last_reset = jiffies;
> +

I think this is supposed to be if (shost->eh_deadline ...

>  	ret = 1;
>  	scmd->eh_eflags |= eh_flag;
>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
> @@ -1052,13 +1095,25 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  		      struct list_head *done_q)
>  {
>  	struct scsi_cmnd *scmd, *next;
> +	struct Scsi_Host *shost;
>  	int rtn;
> +	unsigned long flags;
>  
>  	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>  		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
>  		    SCSI_SENSE_VALID(scmd))
>  			continue;
>  
> +		shost = scmd->device->host;
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			break;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
>  						  "%s: requesting sense\n",
>  						  current->comm));
> @@ -1143,11 +1198,22 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
>  	struct scsi_cmnd *scmd, *next;
>  	struct scsi_device *sdev;
>  	int finish_cmds;
> +	unsigned long flags;
>  
>  	while (!list_empty(cmd_list)) {
>  		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
>  		sdev = scmd->device;
>  
> +		if (!try_stu) {
> +			spin_lock_irqsave(sdev->host->host_lock, flags);
> +			if (scsi_host_eh_deadline(sdev->host)) {
> +				spin_unlock_irqrestore(sdev->host->host_lock,
> +						       flags);

I think a list_splice_init(cmd_list, work_q); is needed here, otherwise
scmds that are still on the cmd_list will be orphaned.  There should
also be a SCSI_LOG_ERROR_RECOVERY() as was done in other places.

> +				break;
> +			}
> +			spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +		}
> +
>  		finish_cmds = !scsi_device_online(scmd->device) ||
>  			(try_stu && !scsi_eh_try_stu(scmd) &&
>  			 !scsi_eh_tur(scmd)) ||
> @@ -1183,14 +1249,26 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
>  	struct scsi_cmnd *scmd, *next;
>  	LIST_HEAD(check_list);
>  	int rtn;
> +	struct Scsi_Host *shost;
> +	unsigned long flags;
>  
>  	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>  		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
>  			continue;
> +		shost = scmd->device->host;
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);

I think a list_splice_init(&check_list, work_q); is needed here,
otherwise scmds that are on the check_list will be orphaned.

> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			return 1;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
>  						  "0x%p\n", current->comm,
>  						  scmd));
> -		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
> +		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
>  		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
>  			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
>  			if (rtn == FAST_IO_FAIL)
> @@ -1248,8 +1326,18 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
>  {
>  	struct scsi_cmnd *scmd, *stu_scmd, *next;
>  	struct scsi_device *sdev;
> +	unsigned long flags;
>  
>  	shost_for_each_device(sdev, shost) {
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			break;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  		stu_scmd = NULL;
>  		list_for_each_entry(scmd, work_q, eh_entry)
>  			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
> @@ -1302,9 +1390,19 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>  {
>  	struct scsi_cmnd *scmd, *bdr_scmd, *next;
>  	struct scsi_device *sdev;
> +	unsigned long flags;
>  	int rtn;
>  
>  	shost_for_each_device(sdev, shost) {
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			break;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  		bdr_scmd = NULL;
>  		list_for_each_entry(scmd, work_q, eh_entry)
>  			if (scmd->device == sdev) {
> @@ -1364,6 +1462,19 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>  		struct scsi_cmnd *next, *scmd;
>  		int rtn;
>  		unsigned int id;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			/* push back on work queue for further processing */

I think a list_splice_init(&check_list, work_q); is needed here,
otherwise scmds that are on the check_list will be orphaned.

> +			list_splice_init(&tmp_list, work_q);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			return list_empty(work_q);
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
>  		id = scmd_id(scmd);
> @@ -1408,6 +1519,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>  	LIST_HEAD(check_list);
>  	unsigned int channel;
>  	int rtn;
> +	unsigned long flags;
>  
>  	/*
>  	 * we really want to loop over the various channels, and do this on
> @@ -1417,6 +1529,16 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>  	 */
>  
>  	for (channel = 0; channel <= shost->max_channel; channel++) {
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_eh_deadline(shost)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);

I think a list_splice_init(&check_list, work_q); is needed here,
otherwise scmds that are on the check_list will be orphaned.

> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				shost_printk(KERN_INFO, shost,
> +					    "skip %s, eh timeout\n", __func__));
> +			return list_empty(work_q);
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +
>  		chan_scmd = NULL;
>  		list_for_each_entry(scmd, work_q, eh_entry) {
>  			if (channel == scmd_channel(scmd)) {
> @@ -1822,8 +1944,9 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
>  	 * will be requests for character device operations, and also for
>  	 * ioctls to queued block devices.
>  	 */
> -	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
> -					  __func__));
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		printk("scsi_eh_%d waking up host to restart\n",
> +		       shost->host_no));
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	if (scsi_host_set_state(shost, SHOST_RUNNING))
> @@ -1950,6 +2073,10 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
>  		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
>  			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
>  
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	if (sdev->eh_deadline)

I think this is supposed to be if (shost->eh_deadline ...

> +		shost->last_reset = 0;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>  	scsi_eh_flush_done_q(&eh_done_q);
>  }
>  
> @@ -1976,7 +2103,7 @@ int scsi_error_handler(void *data)
>  		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
>  		    shost->host_failed != shost->host_busy) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
> -				printk("Error handler scsi_eh_%d sleeping\n",
> +				printk("scsi_eh_%d: sleeping\n",
>  					shost->host_no));
>  			schedule();
>  			continue;
> @@ -1984,8 +2111,9 @@ int scsi_error_handler(void *data)
>  
>  		__set_current_state(TASK_RUNNING);
>  		SCSI_LOG_ERROR_RECOVERY(1,
> -			printk("Error handler scsi_eh_%d waking up\n",
> -				shost->host_no));
> +			printk("scsi_eh_%d: waking up %d/%d/%d\n",
> +			       shost->host_no, shost->host_eh_scheduled,
> +			       shost->host_failed, shost->host_busy));
>  
>  		/*
>  		 * We have a host that is failing for some reason.  Figure out
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index af64c1c..3c1742f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -281,6 +281,42 @@ exit_store_host_reset:
>  
>  static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
>  
> +static ssize_t
> +show_shost_eh_deadline(struct device *dev,
> +		      struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +
> +	return sprintf(buf, "%d\n", shost->eh_deadline);

I think that the attribute should be specified in seconds, so
this should be shost->eh_deadline / HZ.

> +}
> +
> +static ssize_t
> +store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	int ret = -EINVAL;
> +	int timeout;
> +	unsigned long flags;
> +
> +	if (shost->transportt->eh_strategy_handler)
> +		return ret;
> +
> +	if (sscanf(buf, "%d\n", &timeout) == 1) {
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		if (scsi_host_in_recovery(shost))
> +			ret = -EBUSY;
> +		else {
> +			shost->eh_deadline = timeout;

I think the deadline should be specified in seconds, so this
should be shost->eh_deadline = timeout * HZ;

> +			ret = count;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +	}
> +	return ret;
> +}
> +
> +static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
> +
>  shost_rd_attr(unique_id, "%u\n");
>  shost_rd_attr(host_busy, "%hu\n");
>  shost_rd_attr(cmd_per_lun, "%hd\n");
> @@ -308,6 +344,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>  	&dev_attr_prot_capabilities.attr,
>  	&dev_attr_prot_guard_type.attr,
>  	&dev_attr_host_reset.attr,
> +	&dev_attr_eh_deadline.attr,
>  	NULL
>  };
>  
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7552435..ca87486 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -598,7 +598,7 @@ struct Scsi_Host {
>  	unsigned int host_eh_scheduled;    /* EH scheduled without command */
>      
>  	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
> -	int resetting; /* if set, it means that last_reset is a valid value */
> +	int eh_deadline; /* Deadline for EH runtime */
>  	unsigned long last_reset;
>  
>  	/*


