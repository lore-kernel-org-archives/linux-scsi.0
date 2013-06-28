From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Jun 2013 09:14:54 +0200
Message-ID: <51CD37EE.4000803@suse.de>
References: <1370862713-41323-1-git-send-email-hare@suse.de>  <1370862713-41323-8-git-send-email-hare@suse.de> <1372343589.3871.406.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3F1HPC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 03:15:02 -0400
In-Reply-To: <1372343589.3871.406.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/27/2013 04:33 PM, Ewan Milne wrote:
> The eh_deadline changes allow for a significant improvement
> in multipath failover time.  It works very well in our testing.
> I do have a few corrections, see below:
>=20
> On Mon, 2013-06-10 at 13:11 +0200, Hannes Reinecke wrote:
>> This patchs adds an 'eh_deadline' attribute to the scsi
>> host which limits the overall runtime of the SCSI EH.
>> When a command is failed the start time of the EH is stored
>> in 'last_reset'. If the overall runtime of the SCSI EH is longer
>> than last_reset + eh_deadline, the EH is short-circuited and
>> falls through to issue a host reset only.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/hosts.c      |   7 +++
>>  drivers/scsi/scsi_error.c | 142 +++++++++++++++++++++++++++++++++++=
++++++++---
>>  drivers/scsi/scsi_sysfs.c |  37 ++++++++++++
>>  include/scsi/scsi_host.h  |   2 +-
>>  4 files changed, 180 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index df0c3c7..c8d828f 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -316,6 +316,12 @@ static void scsi_host_dev_release(struct device=
 *dev)
>>  	kfree(shost);
>>  }
>> =20
>> +static unsigned int shost_eh_deadline;
>> +
>> +module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_=
IWUSR);
>> +MODULE_PARM_DESC(eh_deadline,
>> +		 "SCSI EH deadline in seconds (should be between 1 and 2^32-1)");
>> +
>>  static struct device_type scsi_host_type =3D {
>>  	.name =3D		"scsi_host",
>>  	.release =3D	scsi_host_dev_release,
>> @@ -388,6 +394,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_ho=
st_template *sht, int privsize)
>>  	shost->unchecked_isa_dma =3D sht->unchecked_isa_dma;
>>  	shost->use_clustering =3D sht->use_clustering;
>>  	shost->ordered_tag =3D sht->ordered_tag;
>> +	shost->eh_deadline =3D shost_eh_deadline;
>=20
> This should be shost->eh_deadline =3D shost_eh_deadline * HZ; since t=
he
> parameter is specified in seconds.
>=20
Yes, correct. Will be fixed with the next round.

[ .. ]
>> @@ -232,6 +272,9 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int=
 eh_flag)
>>  		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
>>  			goto out_unlock;
>> =20
>> +	if (sdev->eh_deadline && !shost->last_reset)
>> +		shost->last_reset =3D jiffies;
>> +
>=20
> I think this is supposed to be if (shost->eh_deadline ...
>=20
No. ->last_reset is set to the time the first command timeout/failure.

->last_reset + ->eh_deadline will give you the expiry time.

[ .. ]
>> @@ -1143,11 +1198,22 @@ static int scsi_eh_test_devices(struct list_=
head *cmd_list,
>>  	struct scsi_cmnd *scmd, *next;
>>  	struct scsi_device *sdev;
>>  	int finish_cmds;
>> +	unsigned long flags;
>> =20
>>  	while (!list_empty(cmd_list)) {
>>  		scmd =3D list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
>>  		sdev =3D scmd->device;
>> =20
>> +		if (!try_stu) {
>> +			spin_lock_irqsave(sdev->host->host_lock, flags);
>> +			if (scsi_host_eh_deadline(sdev->host)) {
>> +				spin_unlock_irqrestore(sdev->host->host_lock,
>> +						       flags);
>=20
> I think a list_splice_init(cmd_list, work_q); is needed here, otherwi=
se
> scmds that are still on the cmd_list will be orphaned.  There should
> also be a SCSI_LOG_ERROR_RECOVERY() as was done in other places.
>=20
Yes. Will be fixed with the next round.

>> +				break;
>> +			}
>> +			spin_unlock_irqrestore(sdev->host->host_lock, flags);
>> +		}
>> +
>>  		finish_cmds =3D !scsi_device_online(scmd->device) ||
>>  			(try_stu && !scsi_eh_try_stu(scmd) &&
>>  			 !scsi_eh_tur(scmd)) ||
>> @@ -1183,14 +1249,26 @@ static int scsi_eh_abort_cmds(struct list_he=
ad *work_q,
>>  	struct scsi_cmnd *scmd, *next;
>>  	LIST_HEAD(check_list);
>>  	int rtn;
>> +	struct Scsi_Host *shost;
>> +	unsigned long flags;
>> =20
>>  	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>>  		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
>>  			continue;
>> +		shost =3D scmd->device->host;
>> +		spin_lock_irqsave(shost->host_lock, flags);
>> +		if (scsi_host_eh_deadline(shost)) {
>> +			spin_unlock_irqrestore(shost->host_lock, flags);
>=20
> I think a list_splice_init(&check_list, work_q); is needed here,
> otherwise scmds that are on the check_list will be orphaned.
>=20
Yes. Will be fixed with the next round.

[ .. ]
>> @@ -1364,6 +1462,19 @@ static int scsi_eh_target_reset(struct Scsi_H=
ost *shost,
>>  		struct scsi_cmnd *next, *scmd;
>>  		int rtn;
>>  		unsigned int id;
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(shost->host_lock, flags);
>> +		if (scsi_host_eh_deadline(shost)) {
>> +			spin_unlock_irqrestore(shost->host_lock, flags);
>> +			/* push back on work queue for further processing */
>=20
> I think a list_splice_init(&check_list, work_q); is needed here,
> otherwise scmds that are on the check_list will be orphaned.
>=20
I already did so; will be fixed with the next round.

>> +			list_splice_init(&tmp_list, work_q);
>> +			SCSI_LOG_ERROR_RECOVERY(3,
>> +				shost_printk(KERN_INFO, shost,
>> +					    "skip %s, eh timeout\n", __func__));
>> +			return list_empty(work_q);
>> +		}
>> +		spin_unlock_irqrestore(shost->host_lock, flags);
>> =20
>>  		scmd =3D list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
>>  		id =3D scmd_id(scmd);
>> @@ -1408,6 +1519,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host =
*shost,
>>  	LIST_HEAD(check_list);
>>  	unsigned int channel;
>>  	int rtn;
>> +	unsigned long flags;
>> =20
>>  	/*
>>  	 * we really want to loop over the various channels, and do this o=
n
>> @@ -1417,6 +1529,16 @@ static int scsi_eh_bus_reset(struct Scsi_Host=
 *shost,
>>  	 */
>> =20
>>  	for (channel =3D 0; channel <=3D shost->max_channel; channel++) {
>> +		spin_lock_irqsave(shost->host_lock, flags);
>> +		if (scsi_host_eh_deadline(shost)) {
>> +			spin_unlock_irqrestore(shost->host_lock, flags);
>=20
> I think a list_splice_init(&check_list, work_q); is needed here,
> otherwise scmds that are on the check_list will be orphaned.
>=20
Yes, will be fixed.

>> +			SCSI_LOG_ERROR_RECOVERY(3,
>> +				shost_printk(KERN_INFO, shost,
>> +					    "skip %s, eh timeout\n", __func__));
>> +			return list_empty(work_q);
>> +		}
>> +		spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>>  		chan_scmd =3D NULL;
>>  		list_for_each_entry(scmd, work_q, eh_entry) {
>>  			if (channel =3D=3D scmd_channel(scmd)) {
>> @@ -1822,8 +1944,9 @@ static void scsi_restart_operations(struct Scs=
i_Host *shost)
>>  	 * will be requests for character device operations, and also for
>>  	 * ioctls to queued block devices.
>>  	 */
>> -	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n=
",
>> -					  __func__));
>> +	SCSI_LOG_ERROR_RECOVERY(3,
>> +		printk("scsi_eh_%d waking up host to restart\n",
>> +		       shost->host_no));
>> =20
>>  	spin_lock_irqsave(shost->host_lock, flags);
>>  	if (scsi_host_set_state(shost, SHOST_RUNNING))
>> @@ -1950,6 +2073,10 @@ static void scsi_unjam_host(struct Scsi_Host =
*shost)
>>  		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
>>  			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
>> =20
>> +	spin_lock_irqsave(shost->host_lock, flags);
>> +	if (sdev->eh_deadline)
>=20
> I think this is supposed to be if (shost->eh_deadline ...
>=20
Of course.

>> +		shost->last_reset =3D 0;
>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>>  	scsi_eh_flush_done_q(&eh_done_q);
>>  }
>> =20
>> @@ -1976,7 +2103,7 @@ int scsi_error_handler(void *data)
>>  		if ((shost->host_failed =3D=3D 0 && shost->host_eh_scheduled =3D=3D=
 0) ||
>>  		    shost->host_failed !=3D shost->host_busy) {
>>  			SCSI_LOG_ERROR_RECOVERY(1,
>> -				printk("Error handler scsi_eh_%d sleeping\n",
>> +				printk("scsi_eh_%d: sleeping\n",
>>  					shost->host_no));
>>  			schedule();
>>  			continue;
>> @@ -1984,8 +2111,9 @@ int scsi_error_handler(void *data)
>> =20
>>  		__set_current_state(TASK_RUNNING);
>>  		SCSI_LOG_ERROR_RECOVERY(1,
>> -			printk("Error handler scsi_eh_%d waking up\n",
>> -				shost->host_no));
>> +			printk("scsi_eh_%d: waking up %d/%d/%d\n",
>> +			       shost->host_no, shost->host_eh_scheduled,
>> +			       shost->host_failed, shost->host_busy));
>> =20
>>  		/*
>>  		 * We have a host that is failing for some reason.  Figure out
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index af64c1c..3c1742f 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -281,6 +281,42 @@ exit_store_host_reset:
>> =20
>>  static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
>> =20
>> +static ssize_t
>> +show_shost_eh_deadline(struct device *dev,
>> +		      struct device_attribute *attr, char *buf)
>> +{
>> +	struct Scsi_Host *shost =3D class_to_shost(dev);
>> +
>> +	return sprintf(buf, "%d\n", shost->eh_deadline);
>=20
> I think that the attribute should be specified in seconds, so
> this should be shost->eh_deadline / HZ.
>=20
Already did so.

>> +}
>> +
>> +static ssize_t
>> +store_shost_eh_deadline(struct device *dev, struct device_attribute=
 *attr,
>> +		const char *buf, size_t count)
>> +{
>> +	struct Scsi_Host *shost =3D class_to_shost(dev);
>> +	int ret =3D -EINVAL;
>> +	int timeout;
>> +	unsigned long flags;
>> +
>> +	if (shost->transportt->eh_strategy_handler)
>> +		return ret;
>> +
>> +	if (sscanf(buf, "%d\n", &timeout) =3D=3D 1) {
>> +		spin_lock_irqsave(shost->host_lock, flags);
>> +		if (scsi_host_in_recovery(shost))
>> +			ret =3D -EBUSY;
>> +		else {
>> +			shost->eh_deadline =3D timeout;
>=20
> I think the deadline should be specified in seconds, so this
> should be shost->eh_deadline =3D timeout * HZ;
>=20
Same here.

>> +			ret =3D count;
>> +		}
>> +		spin_unlock_irqrestore(shost->host_lock, flags);
>> +	}
>> +	return ret;
>> +}
>> +
>> +static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_de=
adline, store_shost_eh_deadline);
>> +
>>  shost_rd_attr(unique_id, "%u\n");
>>  shost_rd_attr(host_busy, "%hu\n");
>>  shost_rd_attr(cmd_per_lun, "%hd\n");
>> @@ -308,6 +344,7 @@ static struct attribute *scsi_sysfs_shost_attrs[=
] =3D {
>>  	&dev_attr_prot_capabilities.attr,
>>  	&dev_attr_prot_guard_type.attr,
>>  	&dev_attr_host_reset.attr,
>> +	&dev_attr_eh_deadline.attr,
>>  	NULL
>>  };
>> =20
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 7552435..ca87486 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -598,7 +598,7 @@ struct Scsi_Host {
>>  	unsigned int host_eh_scheduled;    /* EH scheduled without command=
 */
>>     =20
>>  	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et =
al. */
>> -	int resetting; /* if set, it means that last_reset is a valid valu=
e */
>> +	int eh_deadline; /* Deadline for EH runtime */
>>  	unsigned long last_reset;
>> =20
>>  	/*
>=20
>=20

Thanks for the review.

I'll be sending out a next round of patches.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
