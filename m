From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: enhance firmware event log retrieval
Date: Thu, 19 Jan 2012 08:46:01 -0500
Message-ID: <4D0DDF70-3926-4CDC-ACA8-E2C02005CFA5@xyratex.com>
References: <97204CD5-5C4D-4E62-ADD4-CE51AB11C460@xyratex.com> <30B08FEC5E894494BBDA33881AB0E955@usish.com.cn>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:38881 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754835Ab2ASNqJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 08:46:09 -0500
In-Reply-To: <30B08FEC5E894494BBDA33881AB0E955@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'crystal_yu' <crystal_yu@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'James Bottomley' <JBottomley@parallels.com>

The user that needed this was PMC engineering, you see they needed the event log, along with their proprietary <sigh> forensics, to debug a failure on the SAS bus and report that back to us. The test was their satisfaction when they provided a response to the trouble request with an accurate portrayal of the root cause.

My unit test (more than a year ago) was to run a system for a day with a high event level, fiddling cables, then pull the events, watching for the boundary condition (stutter of the last entry). Content was otherwise opaque to me.

ToDo is to add a 'write' to the node to reset the outgoing pointer and to add a string describing the events as part of the numerical data; but there is no impetuous for that right now.

Sincerely -- Mark Salyzyn

On Jan 19, 2012, at 2:37 AM, Jack Wang wrote:

>> The pm8001 driver event log currently only reports the current firmware
> event
>> log index and the first entry (if log has not wrapped). The enclosed patch
>> enhances the event log retrieved to sequentially return all un-retrieved
>> entries until hitting the last, from then on reporting the last entry. The
>> format has been changed in a parseable fashion reporting some of the
> interpreted
>> fields; the entry sequence number can be used to determine the boundary
>> condition when the last entry is retrieved.
>> 
>> Formerly, when the logging level is changed at runtime, it does not
> transmit
>> the updated level to the firmware. We also added a set of insmod
> parameters
>> so that the logging level may be set at initialization time.
>> 
> [Jack Wang] Patch is welcome.
>> As this disrupts backward compatibility, we look forward to community
> comments.
>> Also, once an earlier log entry is retrieved, it is the expectation of the
>> logging/forensic program(?) to record them as they can not be retrieved
> again.
>> Please keep in mind that the first event log entry as previously reported
> by
>> the existing code becomes somewhat moot if new entries form.
>> 
> [Jack Wang] I wonder what user need this function? How do you test this
> function?
> 
>> Signed-off-by: mark_salyzyn@xyratex.com
>> Cc: jack_wang@usish.com
>> Cc: JBottomley@parallels.com
>> Cc: crystal_yu@usish.com
>> Cc: john_gong@usish.com
>> Cc: lindar_liu <lindar_liu@usish.com>
> 
> [Jack Wang] 
> Acked-by: Jack Wang <jack_wang@usish.com>
> Thanks.
> 
>> 
>> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
>> b/drivers/scsi/pm8001/pm8001_ctl.c
>> index 45bc197..3fe3d93 100644
>> --- a/drivers/scsi/pm8001/pm8001_ctl.c
>> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
>> @@ -228,46 +228,140 @@ static ssize_t
> pm8001_ctl_logging_level_store(struct
>> device *cdev,
>> 		return -EINVAL;
>> 
>> 	pm8001_ha->logging_level = val;
>> +	pm8001_update_main_config_table(pm8001_ha);
>> 	return strlen(buf);
>> }
>> 
>> static DEVICE_ATTR(logging_level, S_IRUGO | S_IWUSR,
>> 	pm8001_ctl_logging_level_show, pm8001_ctl_logging_level_store);
>> +
>> /**
>> - * pm8001_ctl_aap_log_show - aap1 event log
>> + * pm8001_readlog - generic routine to read a single event log entry
>> + * @header: a pointer to the event log base header
>> + * @entry: a pointer to copy the latest event log into
>> + * @consumer_index: a current local index pointing to the last oldest
> entry
>> + *                  retrieved. Automatically incremented and wrapped.
>> + * @return: A copied entry content and a status. Status return of zero
> means
>> + *          more entries available, and the consumer index is incremented
> and
>> + *          wrapped. A positive status return means last entry, the
> consumer
>> + *          index may be incremented depending of approached or at the
> last
>> + *          entry. Status can also return a negative error code. It is
> the
>> + *          responsibility of the caller to confirm the validity of the
> copied
>> + *          event information.
>> + */
>> +int pm8001_readlog(
>> +	struct eventlog_header *header,
>> +	struct eventlog_entry *entry,
>> +	u32 *consumer_index)
>> +{
>> +	unsigned maximum_index;
>> +	unsigned producer_index;
>> +
>> +	/* Validity of header */
>> +	if ((header->offset != sizeof(*header)) ||
>> +	    (header->entry_size != sizeof(*entry)) ||
>> +	    ((header->signature != EVENTLOG_HEADER_SIGNATURE_AAP1) &&
>> +	     (header->signature != EVENTLOG_HEADER_SIGNATURE_IOP)))
>> +		return -EINVAL;
>> +	/* Validity of hardware indexii */
>> +	maximum_index = header->size / sizeof(*entry);
>> +	if ((maximum_index <= header->producer_index) ||
>> +	    (maximum_index <= header->consumer_index))
>> +		return -EINVAL;
>> +	producer_index = header->producer_index;
>> +	if (producer_index == 0)
>> +		producer_index = maximum_index - 1;
>> +	else
>> +		--producer_index;
>> +	/* Validity of current consumer index */
>> +	if (((producer_index < header->consumer_index) ?
>> +	     ((producer_index < *consumer_index) &&
>> +	      (*consumer_index < header->consumer_index)) :
>> +	     ((producer_index < *consumer_index) ||
>> +	      (*consumer_index < header->consumer_index))) ||
>> +	    (*consumer_index >= maximum_index))
>> +		*consumer_index = header->consumer_index;
>> +	*entry = ((struct eventlog_entry *)(header + 1))[*consumer_index];
>> +	if (*consumer_index != producer_index) {
>> +		++(*consumer_index);
>> +		if (*consumer_index >= maximum_index)
>> +			*consumer_index = 0;
>> +		/* More entries? */
>> +		return *consumer_index == producer_index;
>> +	}
>> +	return 2; /* Already at Last Entry */
>> +}
>> +
>> +/**
>> + * pm8001_validlog - generic routine to validate a single event log entry
>> + * @entry: a pointer to the event log entry
>> + * @return: zero if not valid
>> + */
>> +static inline int pm8001_validlog(struct eventlog_entry *entry)
>> +{
>> +	return ((entry->size <= (sizeof(entry->log) /
> sizeof(entry->log[0]))) &&
>> +		((entry->timestamp_upper != 0) ||
>> +		 (entry->timestamp_lower != 0)));
>> +}
>> +
>> +/**
>> + * pm8001_ctl_log_show - event log
>>  * @cdev: pointer to embedded class device
>>  * @buf: the buffer returned
>> + * @ind: The region index (AAP1 or IOP)
>>  *
>>  * A sysfs 'read-only' shost attribute.
>>  */
>> -static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
>> -	struct device_attribute *attr, char *buf)
>> +static ssize_t pm8001_ctl_log_show(struct device *cdev, char *buf, int
> ind)
>> {
>> 	struct Scsi_Host *shost = class_to_shost(cdev);
>> 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>> 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>> +	struct eventlog_entry entry;
>> +	char *str = buf;
>> 	int i;
>> -#define AAP1_MEMMAP(r, c) \
>> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32
> \
>> -	+ (c)))
>> 
>> -	char *str = buf;
>> -	int max = 2;
>> -	for (i = 0; i < max; i++) {
>> -		str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x
> 0x%08x"
>> -			       "0x%08x 0x%08x\n",
>> -			       AAP1_MEMMAP(i, 0),
>> -			       AAP1_MEMMAP(i, 4),
>> -			       AAP1_MEMMAP(i, 8),
>> -			       AAP1_MEMMAP(i, 12),
>> -			       AAP1_MEMMAP(i, 16),
>> -			       AAP1_MEMMAP(i, 20),
>> -			       AAP1_MEMMAP(i, 24),
>> -			       AAP1_MEMMAP(i, 28));
>> +	memset(&entry, 0, sizeof(entry));
>> +	do {
>> +		i = pm8001_readlog(
>> +			(struct eventlog_header *)(
>> +				pm8001_ha->memoryMap.region[ind].virt_ptr),
>> +			&entry,
>> +			(ind == AAP1) ?
>> +				&pm8001_ha->aap1_consumer :
>> +				&pm8001_ha->iop_consumer);
>> +	} while ((i == 0) && !pm8001_validlog(&entry));
>> +	if ((i >= 0) && pm8001_validlog(&entry)) {
>> +		u32 *lp;
>> +		unsigned long long timestamp =
>> +			(((unsigned long long)entry.timestamp_upper) << 32)
> |
>> +			entry.timestamp_lower;
>> +		str += snprintf(str, PAGE_SIZE - (str - buf),
>> +			"%u %llu.%09llu %u",
>> +			entry.severity,
>> +			timestamp / (1000000000 / 8),
>> +			(timestamp % (1000000000 / 8)) * 8,
>> +			entry.sequence);
>> +		for (lp = entry.log, i = entry.size; i > 0; --i)
>> +			str += snprintf(str, PAGE_SIZE - (str - buf),
>> +				" 0x%08x", *(lp++));
>> +		str += snprintf(str, PAGE_SIZE - (str - buf), "\n");
>> 	}
>> -
>> 	return str - buf;
>> }
>> +
>> +/**
>> + * pm8001_ctl_aap_log_show - aap1 event log
>> + * @cdev: pointer to embedded class device
>> + * @buf: the buffer returned
>> + *
>> + * A sysfs 'read-only' shost attribute.
>> + */
>> +static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
>> +	struct device_attribute *attr, char *buf)
>> +{
>> +	return pm8001_ctl_log_show(cdev, buf, AAP1);
>> +}
>> static DEVICE_ATTR(aap_log, S_IRUGO, pm8001_ctl_aap_log_show, NULL);
>> /**
>>  * pm8001_ctl_aap_log_show - IOP event log
>> @@ -279,29 +373,7 @@ static DEVICE_ATTR(aap_log, S_IRUGO,
>> pm8001_ctl_aap_log_show, NULL);
>> static ssize_t pm8001_ctl_iop_log_show(struct device *cdev,
>> 	struct device_attribute *attr, char *buf)
>> {
>> -	struct Scsi_Host *shost = class_to_shost(cdev);
>> -	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>> -	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>> -#define IOP_MEMMAP(r, c) \
>> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[IOP].virt_ptr + (r) * 32
> \
>> -	+ (c)))
>> -	int i;
>> -	char *str = buf;
>> -	int max = 2;
>> -	for (i = 0; i < max; i++) {
>> -		str += sprintf(str, "0x%08x 0x%08x 0x%08x 0x%08x 0x%08x
> 0x%08x"
>> -			       "0x%08x 0x%08x\n",
>> -			       IOP_MEMMAP(i, 0),
>> -			       IOP_MEMMAP(i, 4),
>> -			       IOP_MEMMAP(i, 8),
>> -			       IOP_MEMMAP(i, 12),
>> -			       IOP_MEMMAP(i, 16),
>> -			       IOP_MEMMAP(i, 20),
>> -			       IOP_MEMMAP(i, 24),
>> -			       IOP_MEMMAP(i, 28));
>> -	}
>> -
>> -	return str - buf;
>> +	return pm8001_ctl_log_show(cdev, buf, IOP);
>> }
>> static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
>> 
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
>> b/drivers/scsi/pm8001/pm8001_hwi.c
>> index b7b92f7..b3bd781 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -250,8 +250,8 @@ init_default_table_values(struct pm8001_hba_info
>> *pm8001_ha)
>>  * update_main_config_table - update the main default table to the HBA.
>>  * @pm8001_ha: our hba card information
>>  */
>> -static void __devinit
>> -update_main_config_table(struct pm8001_hba_info *pm8001_ha)
>> +void
>> +pm8001_update_main_config_table(struct pm8001_hba_info *pm8001_ha)
>> {
>> 	void __iomem *address = pm8001_ha->main_cfg_tbl_addr;
>> 	pm8001_mw32(address, 0x24,
>> @@ -603,7 +603,7 @@ static int __devinit pm8001_chip_init(struct
>> pm8001_hba_info *pm8001_ha)
>> 	read_inbnd_queue_table(pm8001_ha);
>> 	read_outbnd_queue_table(pm8001_ha);
>> 	/* update main config table ,inbound table and outbound table */
>> -	update_main_config_table(pm8001_ha);
>> +	pm8001_update_main_config_table(pm8001_ha);
>> 	update_inbnd_queue_table(pm8001_ha, 0);
>> 	update_outbnd_queue_table(pm8001_ha, 0);
>> 	mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c
>> b/drivers/scsi/pm8001/pm8001_init.c
>> index c21a216..c638da4 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -48,6 +48,8 @@ static const struct pm8001_chip_info pm8001_chips[] = {
>> 	[chip_8001] = {  8, &pm8001_8001_dispatch,},
>> };
>> static int pm8001_id;
>> +static int pm8001_logging_level = PM8001_FAIL_LOGGING;
>> +static int pm8001_logging_size = PM8001_EVENT_LOG_SIZE;
>> 
>> LIST_HEAD(hba_list);
>> 
>> @@ -212,16 +214,19 @@ static int __devinit pm8001_alloc(struct
> pm8001_hba_info
>> *pm8001_ha)
>> 	pm8001_ha->tags = kzalloc(PM8001_MAX_CCB, GFP_KERNEL);
>> 	if (!pm8001_ha->tags)
>> 		goto err_out;
>> +	pm8001_logging_size = ((pm8001_logging_size + 31) / 32) * 32;
>> +	if (pm8001_logging_size < 64)
>> +		pm8001_logging_size = 64;
>> 	/* MPI Memory region 1 for AAP Event Log for fw */
>> 	pm8001_ha->memoryMap.region[AAP1].num_elements = 1;
>> -	pm8001_ha->memoryMap.region[AAP1].element_size =
>> PM8001_EVENT_LOG_SIZE;
>> -	pm8001_ha->memoryMap.region[AAP1].total_len = PM8001_EVENT_LOG_SIZE;
>> +	pm8001_ha->memoryMap.region[AAP1].element_size =
> pm8001_logging_size;
>> +	pm8001_ha->memoryMap.region[AAP1].total_len = pm8001_logging_size;
>> 	pm8001_ha->memoryMap.region[AAP1].alignment = 32;
>> 
>> 	/* MPI Memory region 2 for IOP Event Log for fw */
>> 	pm8001_ha->memoryMap.region[IOP].num_elements = 1;
>> -	pm8001_ha->memoryMap.region[IOP].element_size =
> PM8001_EVENT_LOG_SIZE;
>> -	pm8001_ha->memoryMap.region[IOP].total_len = PM8001_EVENT_LOG_SIZE;
>> +	pm8001_ha->memoryMap.region[IOP].element_size = pm8001_logging_size;
>> +	pm8001_ha->memoryMap.region[IOP].total_len = pm8001_logging_size;
>> 	pm8001_ha->memoryMap.region[IOP].alignment = 32;
>> 
>> 	/* MPI Memory region 3 for consumer Index of inbound queues */
>> @@ -242,7 +247,7 @@ static int __devinit pm8001_alloc(struct
> pm8001_hba_info
>> *pm8001_ha)
>> 	pm8001_ha->memoryMap.region[IB].total_len = 256 * 64;
>> 	pm8001_ha->memoryMap.region[IB].alignment = 64;
>> 
>> -	/* MPI Memory region 6 inbound queues */
>> +	/* MPI Memory region 6 outbound queues */
>> 	pm8001_ha->memoryMap.region[OB].num_elements = 256;
>> 	pm8001_ha->memoryMap.region[OB].element_size = 64;
>> 	pm8001_ha->memoryMap.region[OB].total_len = 256 * 64;
>> @@ -381,7 +386,7 @@ pm8001_pci_alloc(struct pci_dev *pdev, u32 chip_id,
> struct
>> Scsi_Host *shost)
>> 	pm8001_ha->sas = sha;
>> 	pm8001_ha->shost = shost;
>> 	pm8001_ha->id = pm8001_id++;
>> -	pm8001_ha->logging_level = 0x01;
>> +	pm8001_ha->logging_level = pm8001_logging_level;
>> 	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
>> #ifdef PM8001_USE_TASKLET
>> 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
>> @@ -614,8 +619,8 @@ intx:
>>  * @ent: pci device id
>>  *
>>  * This function is the main initialization function, when register a new
>> - * pci driver it is invoked, all struct an hardware initilization should
> be
>> done
>> - * here, also, register interrupt
>> + * pci driver it is invoked, all struct and hardware initialization
> should
>> be
>> + * done here, also, register interrupt
>>  */
>> static int __devinit pm8001_pci_probe(struct pci_dev *pdev,
>> 	const struct pci_device_id *ent)
>> @@ -899,6 +904,9 @@ static void __exit pm8001_exit(void)
>> 	destroy_workqueue(pm8001_wq);
>> }
>> 
>> +module_param(pm8001_logging_level, int, 0);
>> +module_param_named(logging_size, pm8001_logging_size, int,
>> S_IRUGO|S_IWUSR);
>> +MODULE_PARM_DESC(logging_size, "Event logging buffer size");
>> module_init(pm8001_init);
>> module_exit(pm8001_exit);
>> 
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.h
>> b/drivers/scsi/pm8001/pm8001_sas.h
>> index 93959fe..84d3170 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>> @@ -336,6 +336,29 @@ struct outbound_queue_table {
>> 	__le32			producer_index;
>> 	u32			consumer_idx;
>> };
>> +struct eventlog_header {
>> +	__le32			signature;
>> +#define EVENTLOG_HEADER_SIGNATURE_AAP1 0x1234AAAA
>> +#define EVENTLOG_HEADER_SIGNATURE_IOP 0x5678CCCC
>> +	__le32			offset; /* sizeof(eventlog_header) */
>> +	u32			reserved1;
>> +	__le32			size;
>> +	u32			reserved2;
>> +	__le32			consumer_index;
>> +	__le32			producer_index;
>> +	__le32			entry_size;
>> +};
>> +struct eventlog_entry {
>> +	u8			size:3;
>> +	u8			reserved1:5;
>> +	u8			reserved2[2];
>> +	u8			reserved:4;
>> +	u8			severity:4;
>> +	__le32			timestamp_upper;
>> +	__le32			timestamp_lower;
>> +	__le32			sequence;
>> +	__le32			log[4];
>> +};
>> struct pm8001_hba_memspace {
>> 	void __iomem  		*memvirtaddr;
>> 	u64			membase;
>> @@ -383,6 +406,9 @@ struct pm8001_hba_info {
>> 	u32			logging_level;
>> 	u32			fw_status;
>> 	const struct firmware 	*fw_image;
>> +	/* Local consumer indexes in support of sysfs event log node */
>> +	u32			aap1_consumer;
>> +	u32			iop_consumer;
>> };
>> 
>> struct pm8001_work {
>> @@ -488,6 +514,11 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void
>> **virt_addr,
>> 	dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,
>> 	u32 mem_size, u32 align);
>> 
>> +void pm8001_update_main_config_table(struct pm8001_hba_info *pm8001_ha);
>> +int pm8001_readlog(
>> +	struct eventlog_header *header,
>> +	struct eventlog_entry *entry,
>> +	u32 *consumer_index);
>> 
>> /* ctl shared API */
>> extern struct device_attribute *pm8001_host_attrs[];

