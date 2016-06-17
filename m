From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Fri, 17 Jun 2016 11:57:01 +0200
Message-ID: <20160617095701.fv5wnorvisnbhcc6@c203.arch.suse.de>
References: <146611717567.26335.4769668449125772969.stgit@brunhilda>
 <146611729682.26335.17158396498682439988.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcFQJ5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2016 05:57:05 -0400
Content-Disposition: inline
In-Reply-To: <146611729682.26335.17158396498682439988.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

Hi Don/Kevin,

some comments inline (mostly stulistic nothing architectural)

On Thu, Jun 16, 2016 at 05:48:16PM -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>=20
> This initial commit contains WIP of Microsemi's smartpqi module.
>=20
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>

if this is From: Kevin it should have his S-o-b as well.

> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---

[...]

> + */
> +
> +#if !defined(_SMARTPQI_H)
> +#define _SMARTPQI_H
> +
> +#pragma pack(1)

I know GCC does understand #pragma pack() to be compatible with MSVC bu=
t please
use the kernel's __packed convention on structs you want to have packed=
=2E

> +
> +#define PQI_DEVICE_SIGNATURE	"PQI DREG"

[...]

> +	pqi_index_t	oq_ci_copy;
> +	struct task_struct *task;
> +	u16		int_msg_num;
> +};
> +

Just for clarification (sorry haven't looked up the sepecs yet) is this=
 a
queue pair or more than two queues (looks like 3 to me)?=20

> +struct pqi_queue_group {
> +	struct pqi_ctrl_info *ctrl_info;	/* backpointer */
> +	u16		iq_id[2];
> +	u16		oq_id;

[...]

> +#define RAID_CTLR_LUNID		"\0\0\0\0\0\0\0\0"
> +
> +struct pqi_scsi_dev_t {

=46or sake of consistency with the other structs "struct pqi_scsi_dev"?=
=20

> +	int	devtype;		/* as reported by INQUIRY commmand */
> +	u8	device_type;		/* as reported by */

[...]

> +
> +/* Define the PCI IDs for the controllers that we support. */
> +static const struct pci_device_id pqi_pci_id_table[] =3D {
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0110,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0600,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0601,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0602,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0603,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0650,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0651,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0652,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0653,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0654,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0655,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0700,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x0701,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0800,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0801,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0802,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0803,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0804,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0805,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0900,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0901,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0902,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0903,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0904,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0905,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.subdevice =3D 0x0906,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x1001,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x1100,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x1101,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x1102,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_VENDOR_ID_HP,
> +		.subdevice =3D 0x1150,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{
> +		.vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> +		.device =3D 0x028f,
> +		.subvendor =3D PCI_ANY_ID,
> +		.subdevice =3D PCI_ANY_ID,
> +		.class =3D 0,
> +		.class_mask =3D 0,
> +		.driver_data =3D 0
> +	},
> +	{ 0 }
> +};


The above table can be drastically reduced by using the PCI_DEVICE_SUB(=
) macro:
static const struct pci_device_id pqi_pci_id_table[] =3D {
	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x28f, PCI_VENDOR_ID_ADAPTEC2=
, 0x0110) },
	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x28f, PCI_VENDOR_ID_HP, 0x06=
00) },
	...

Also I think it makes more sense near the struct pci_driver way down, a=
s
that's the place it's actuall used.

> +MODULE_DEVICE_TABLE(pci, pqi_pci_id_table);
> +
> +static struct {
> +	atomic_t	num_requests[2];
> +	atomic_t	num_raid_bypasses;
> +	atomic_t	num_outstanding_requests[2];
> +	atomic_t	num_passthru_ioctls;
> +	atomic_t	num_heartbeat_events;
> +	atomic_t	num_all_other_events;
> +	atomic_t	num_scans;
> +	atomic_t	num_interrupts;
> +	atomic_t	num_spurious_interrupts;
> +	atomic_t	num_alloc_io_request_collisions;
> +	atomic_t	num_spans[2];
> +	atomic_t	num_interrupts_wrong_cpu;
> +} pqi_statistics =3D {
> +	.num_requests[0] =3D ATOMIC_INIT(0),
> +	.num_requests[1] =3D ATOMIC_INIT(0),
> +	.num_raid_bypasses =3D ATOMIC_INIT(0),
> +	.num_outstanding_requests[0] =3D ATOMIC_INIT(0),
> +	.num_outstanding_requests[1] =3D ATOMIC_INIT(0),
> +	.num_passthru_ioctls =3D ATOMIC_INIT(0),
> +	.num_heartbeat_events =3D ATOMIC_INIT(0),
> +	.num_all_other_events =3D ATOMIC_INIT(0),
> +	.num_scans =3D ATOMIC_INIT(0),
> +	.num_interrupts =3D ATOMIC_INIT(0),
> +	.num_spurious_interrupts =3D ATOMIC_INIT(0),
> +	.num_alloc_io_request_collisions =3D ATOMIC_INIT(0),
> +	.num_spans[0] =3D ATOMIC_INIT(0),
> +	.num_spans[1] =3D ATOMIC_INIT(0),
> +	.num_interrupts_wrong_cpu =3D ATOMIC_INIT(0),
> +};

Appart from Hannes' comments, I wonder if it really makes sense to have=
 these
statistics on a driver global basis, not per adapter?

> +
> +static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);

[...]

> +static ssize_t pqi_statistics_show(struct device *dev,
> +	struct device_attribute *attr, char *buffer)
> +{
> +	ssize_t count =3D 0;
> +	unsigned int num_raid_requests;
> +	unsigned int num_aio_requests;
> +	unsigned int num_outstanding_raid_requests =3D 0;
> +	unsigned int num_outstanding_aio_requests =3D 0;
> +	struct pqi_ctrl_info *ctrl_info;
> +	struct Scsi_Host *shost;
> +
> +	shost =3D class_to_shost(dev);
> +	ctrl_info =3D shost_to_hba(shost);
> +
> +	num_raid_requests =3D
> +		atomic_read(&pqi_statistics.num_requests[RAID_PATH]);
> +	num_aio_requests =3D atomic_read(&pqi_statistics.num_requests[AIO_P=
ATH]);
> +
> +	num_outstanding_raid_requests =3D
> +	atomic_read(&pqi_statistics.num_outstanding_requests[RAID_PATH]);
> +	num_outstanding_aio_requests =3D
> +	atomic_read(&pqi_statistics.num_outstanding_requests[AIO_PATH]);
> +
> +	if (pqi_ctrl_offline(ctrl_info))
> +		count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +			"*** CONTROLLER OFFLINE ***\n");
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"            total requests: %u\n",
> +		num_raid_requests + num_aio_requests);
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"       total RAID requests: %u\n",
> +		num_raid_requests);
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"        total AIO requests: %u\n",
> +		num_aio_requests);
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"             RAID bypasses: %u\n",
> +		atomic_read(&pqi_statistics.num_raid_bypasses));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"total outstanding requests: %u\n",
> +		num_outstanding_raid_requests + num_outstanding_aio_requests);
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		" outstanding RAID requests: %u / %u\n",
> +		num_outstanding_raid_requests,
> +		ctrl_info->num_queue_groups *
> +		(ctrl_info->num_elements_per_iq - 1));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"  outstanding AIO requests: %u / %u\n",
> +		num_outstanding_aio_requests,
> +		ctrl_info->num_queue_groups *
> +		(ctrl_info->num_elements_per_iq - 1));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"        passthrough IOCTLs: %u\n",
> +		atomic_read(&pqi_statistics.num_passthru_ioctls));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"          heartbeat events: %u\n",
> +		atomic_read(&pqi_statistics.num_heartbeat_events));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"          all other events: %u\n",
> +		atomic_read(&pqi_statistics.num_all_other_events));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"                scan count: %u\n",
> +		atomic_read(&pqi_statistics.num_scans));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"                interrupts: %u\n",
> +		atomic_read(&pqi_statistics.num_interrupts));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"       spurious interrupts: %u\n",
> +		atomic_read(&pqi_statistics.num_spurious_interrupts));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"  alloc request collisions: %u\n",
> +		atomic_read(&pqi_statistics.num_alloc_io_request_collisions));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"                RAID spans: %u\n",
> +		atomic_read(&pqi_statistics.num_spans[RAID_PATH]));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"                 AIO spans: %u\n",
> +		atomic_read(&pqi_statistics.num_spans[AIO_PATH]));
> +
> +	count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> +		"   interrupts on wrong CPU: %u\n",
> +		atomic_read(&pqi_statistics.num_interrupts_wrong_cpu));
> +
> +	return count;
> +}

Wasn't the sysfs rule one entry per file?

> +
> +static ssize_t pqi_devices_show(struct device *dev,
> +	struct device_attribute *attr, char *buffer)
> +{

[...]

> +	rc =3D pqi_build_raid_path_request(ctrl_info, &request,
> +		SA_CACHE_FLUSH, RAID_CTLR_LUNID, buffer,
> +		SA_CACHE_FLUSH_BUFFER_LENGTH, 0, &pci_direction);
> +	if (rc)
> +		goto out;
> +
> +	rc =3D pqi_submit_raid_request_synchronous(ctrl_info, &request.head=
er,
> +		0, NULL, NO_TIMEOUT);

So if this is called via the shutdown() -> pqi_shutdown() path it /may/=
 block
shutdown infinitely? I'm not shure this is what people want.

> +
> +	pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
> +		pci_direction);
> +
> +out:
> +	kfree(buffer);
> +

[...]

> +static void pqi_complete_queued_requests(struct pqi_ctrl_info *ctrl_=
info,
> +	struct pqi_scsi_dev_t *device_in_reset)
> +{
> +	unsigned int i;
> +	unsigned int path;
> +	struct pqi_queue_group *queue_group;
> +	unsigned long flags;
> +	struct pqi_io_request *io_request;
> +	struct pqi_io_request *next;
> +	struct scsi_cmnd *scmd;
> +	struct pqi_scsi_dev_t *device;
> +
> +	for (i =3D 0; i < ctrl_info->num_queue_groups; i++) {
> +		queue_group =3D &ctrl_info->queue_groups[i];
> +
> +		for (path =3D 0; path < 2; path++) {
> +			spin_lock_irqsave(&queue_group->submit_lock[path],
> +				flags);
> +
> +			list_for_each_entry_safe(io_request, next,
> +				&queue_group->request_list[path],
> +				request_list_entry) {
> +				scmd =3D io_request->scmd;
> +				if (scmd) {
> +					device =3D scmd->device->hostdata;
> +					if (device =3D=3D device_in_reset) {
> +						set_host_byte(scmd, DID_RESET);
> +						pqi_scsi_done(scmd);
> +						list_del(&io_request->
> +							request_list_entry);
> +					}
> +				}
> +			}
> +
> +			spin_unlock_irqrestore(&queue_group->submit_lock[path],
> +				flags);
> +		}

If you'd factor the inner for loop into an own small (inline) function,=
 it
could drastically improve readability here.

something like=20

static void pqi_complete_queue_group(struct pqi_queue_group *qg, struct
				     pqi_device_t *device_in_reset)
{
	unsigned int path;
	unsigned long flags;
	struct qpi_scsi_dev_t *dev;
	struct pqi_io_request *ior, *next;

	for (path =3D 0; path < 2; path++) {
		spin_lock_irqsave(&qg->submit_lock[path], flags);

		list_for_each_entry_save(ior, next, &qg->request_list[path],
					 request_list_entry) {
			scmd =3D ior->scmnd;
			if (!scmd)=20
				continue;

			device =3D scmnd->device->hostdata;
			if (dev =3D=3D device_in_reset) {
				set_host_byte(scmnd, DID_RESET);
				pqi_scsi_done(scmnd);
				list_del(&ior->request_list_entry);
			}
		}
		spin_unlock_irqresetore(&qg->submit_lock[path], flags);
	}
}

> +	}
> +}
> +

[..]

> +
> +static DEVICE_ATTR(sas_address, S_IRUGO, pqi_sas_address_show, NULL)=
;
> +static DEVICE_ATTR(ssd_smart_path_enabled, S_IRUGO,
> +	pqi_ssd_smart_path_enabled_show, NULL);
> +
> +static struct device_attribute *pqi_sdev_attrs[] =3D {
> +	&dev_attr_sas_address,
> +	&dev_attr_ssd_smart_path_enabled,
> +	NULL
> +};
> +
> +static DEVICE_ATTR(rescan, S_IWUSR, NULL, pqi_host_store_rescan);
> +static DEVICE_ATTR(stats, S_IRUGO, pqi_statistics_show, NULL);
> +static DEVICE_ATTR(devices, S_IRUGO, pqi_devices_show, NULL);
> +static DEVICE_ATTR(version, S_IRUGO, pqi_version_show, NULL);
> +static DEVICE_ATTR(pqi, S_IRUGO, pqi_info_show, NULL);
> +
> +static struct device_attribute *pqi_shost_attrs[] =3D {
> +	&dev_attr_rescan,
> +	&dev_attr_stats,
> +	&dev_attr_devices,
> +	&dev_attr_version,
> +	&dev_attr_pqi,
> +	NULL
> +};

This should be somewhere near the functions implementing the sysfs show
callbacks.

> +
> +static int pqi_change_queue_depth(struct scsi_device *sdev, int qdep=
th)
> +{
> +	struct pqi_scsi_dev_t *device =3D sdev->hostdata;

[...]

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
