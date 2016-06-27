From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V3 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Mon, 27 Jun 2016 21:12:11 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916380165@avsrvexchmbx1.microsemi.net>
References: <146611717567.26335.4769668449125772969.stgit@brunhilda>
 <146611729682.26335.17158396498682439988.stgit@brunhilda>
 <20160617095701.fv5wnorvisnbhcc6@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0074.outbound.protection.outlook.com ([207.46.100.74]:59456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751673AbcF0V1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2016 17:27:41 -0400
In-Reply-To: <20160617095701.fv5wnorvisnbhcc6@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Friday, June 17, 2016 4:57 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott B=
enesh;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V3 1/2] smartpqi: initial commit of Microsemi sma=
rtpqi
> driver
>=20
> EXTERNAL EMAIL
>=20
>=20
> Hi Don/Kevin,
>=20
> some comments inline (mostly stulistic nothing architectural)
>=20
> On Thu, Jun 16, 2016 at 05:48:16PM -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@microsemi.com>
> >
> > This initial commit contains WIP of Microsemi's smartpqi module.
> >
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
>=20
> if this is From: Kevin it should have his S-o-b as well.
>=20
> > Signed-off-by: Don Brace <don.brace@microsemi.com>

Done

> > ---
>=20
> [...]
>=20
> > + */
> > +
> > +#if !defined(_SMARTPQI_H)
> > +#define _SMARTPQI_H
> > +
> > +#pragma pack(1)
>=20
> I know GCC does understand #pragma pack() to be compatible with MSVC
> but please
> use the kernel's __packed convention on structs you want to have pack=
ed.
>=20

We prefer to leave this "as is" for these reasons:

We do not use __packed on other Microsemi Linux drivers.

There's not consistency in the usage of __packed. Just a quick survey o=
f the kernel source reveals at least four styles:

Syntax #1:

struct xxx {
=2E
} __packed;

Syntax #2:

struct __packed xxx {
=2E
};

Syntax #3:
struct xxx {
=2E
} __attribute__((__packed__));

Syntax #4:

struct __attribute__((__packed__)) xxx {
=2E
};


> > +
> > +#define PQI_DEVICE_SIGNATURE "PQI DREG"
>=20
> [...]
>=20
> > +     pqi_index_t     oq_ci_copy;
> > +     struct task_struct *task;
> > +     u16             int_msg_num;
> > +};
> > +
>=20
> Just for clarification (sorry haven't looked up the sepecs yet) is th=
is a
> queue pair or more than two queues (looks like 3 to me)?
>=20

There are 3 queues


> > +struct pqi_queue_group {
> > +     struct pqi_ctrl_info *ctrl_info;        /* backpointer */
> > +     u16             iq_id[2];
> > +     u16             oq_id;
>=20
> [...]
>=20
> > +#define RAID_CTLR_LUNID              "\0\0\0\0\0\0\0\0"
> > +
> > +struct pqi_scsi_dev_t {
>=20
> For sake of consistency with the other structs "struct pqi_scsi_dev"?

Done

>=20
> > +     int     devtype;                /* as reported by INQUIRY com=
mmand */
> > +     u8      device_type;            /* as reported by */
>=20
> [...]
>=20
> > +
> > +/* Define the PCI IDs for the controllers that we support. */
> > +static const struct pci_device_id pqi_pci_id_table[] =3D {
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0110,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0600,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0601,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0602,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0603,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0650,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0651,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0652,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0653,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0654,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0655,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0700,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x0701,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0800,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0801,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0802,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0803,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0804,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0805,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0900,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0901,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0902,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0903,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0904,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0905,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .subdevice =3D 0x0906,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x1001,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x1100,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x1101,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x1102,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_VENDOR_ID_HP,
> > +             .subdevice =3D 0x1150,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     {
> > +             .vendor =3D PCI_VENDOR_ID_ADAPTEC2,
> > +             .device =3D 0x028f,
> > +             .subvendor =3D PCI_ANY_ID,
> > +             .subdevice =3D PCI_ANY_ID,
> > +             .class =3D 0,
> > +             .class_mask =3D 0,
> > +             .driver_data =3D 0
> > +     },
> > +     { 0 }
> > +};
>=20
>=20
> The above table can be drastically reduced by using the PCI_DEVICE_SU=
B()
> macro:
> static const struct pci_device_id pqi_pci_id_table[] =3D {
>         { PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x28f,
> PCI_VENDOR_ID_ADAPTEC2, 0x0110) },
>         { PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x28f,
> PCI_VENDOR_ID_HP, 0x0600) },
>         ...
>=20
> Also I think it makes more sense near the struct pci_driver way down,=
 as
> that's the place it's actuall used.

Both done.

>=20
> > +MODULE_DEVICE_TABLE(pci, pqi_pci_id_table);
> > +
> > +static struct {
> > +     atomic_t        num_requests[2];
> > +     atomic_t        num_raid_bypasses;
> > +     atomic_t        num_outstanding_requests[2];
> > +     atomic_t        num_passthru_ioctls;
> > +     atomic_t        num_heartbeat_events;
> > +     atomic_t        num_all_other_events;
> > +     atomic_t        num_scans;
> > +     atomic_t        num_interrupts;
> > +     atomic_t        num_spurious_interrupts;
> > +     atomic_t        num_alloc_io_request_collisions;
> > +     atomic_t        num_spans[2];
> > +     atomic_t        num_interrupts_wrong_cpu;
> > +} pqi_statistics =3D {
> > +     .num_requests[0] =3D ATOMIC_INIT(0),
> > +     .num_requests[1] =3D ATOMIC_INIT(0),
> > +     .num_raid_bypasses =3D ATOMIC_INIT(0),
> > +     .num_outstanding_requests[0] =3D ATOMIC_INIT(0),
> > +     .num_outstanding_requests[1] =3D ATOMIC_INIT(0),
> > +     .num_passthru_ioctls =3D ATOMIC_INIT(0),
> > +     .num_heartbeat_events =3D ATOMIC_INIT(0),
> > +     .num_all_other_events =3D ATOMIC_INIT(0),
> > +     .num_scans =3D ATOMIC_INIT(0),
> > +     .num_interrupts =3D ATOMIC_INIT(0),
> > +     .num_spurious_interrupts =3D ATOMIC_INIT(0),
> > +     .num_alloc_io_request_collisions =3D ATOMIC_INIT(0),
> > +     .num_spans[0] =3D ATOMIC_INIT(0),
> > +     .num_spans[1] =3D ATOMIC_INIT(0),
> > +     .num_interrupts_wrong_cpu =3D ATOMIC_INIT(0),
> > +};
>=20
> Appart from Hannes' comments, I wonder if it really makes sense to ha=
ve
> these
> statistics on a driver global basis, not per adapter?
>=20

We removed the statistics


> > +
> > +static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)=
;
>=20
> [...]
>=20
> > +static ssize_t pqi_statistics_show(struct device *dev,
> > +     struct device_attribute *attr, char *buffer)
> > +{
> > +     ssize_t count =3D 0;
> > +     unsigned int num_raid_requests;
> > +     unsigned int num_aio_requests;
> > +     unsigned int num_outstanding_raid_requests =3D 0;
> > +     unsigned int num_outstanding_aio_requests =3D 0;
> > +     struct pqi_ctrl_info *ctrl_info;
> > +     struct Scsi_Host *shost;
> > +
> > +     shost =3D class_to_shost(dev);
> > +     ctrl_info =3D shost_to_hba(shost);
> > +
> > +     num_raid_requests =3D
> > +             atomic_read(&pqi_statistics.num_requests[RAID_PATH]);
> > +     num_aio_requests =3D
> atomic_read(&pqi_statistics.num_requests[AIO_PATH]);
> > +
> > +     num_outstanding_raid_requests =3D
> > +     atomic_read(&pqi_statistics.num_outstanding_requests[RAID_PAT=
H]);
> > +     num_outstanding_aio_requests =3D
> > +     atomic_read(&pqi_statistics.num_outstanding_requests[AIO_PATH=
]);
> > +
> > +     if (pqi_ctrl_offline(ctrl_info))
> > +             count +=3D snprintf(buffer + count, PAGE_SIZE - count=
,
> > +                     "*** CONTROLLER OFFLINE ***\n");
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "            total requests: %u\n",
> > +             num_raid_requests + num_aio_requests);
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "       total RAID requests: %u\n",
> > +             num_raid_requests);
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "        total AIO requests: %u\n",
> > +             num_aio_requests);
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "             RAID bypasses: %u\n",
> > +             atomic_read(&pqi_statistics.num_raid_bypasses));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "total outstanding requests: %u\n",
> > +             num_outstanding_raid_requests +
> num_outstanding_aio_requests);
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             " outstanding RAID requests: %u / %u\n",
> > +             num_outstanding_raid_requests,
> > +             ctrl_info->num_queue_groups *
> > +             (ctrl_info->num_elements_per_iq - 1));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "  outstanding AIO requests: %u / %u\n",
> > +             num_outstanding_aio_requests,
> > +             ctrl_info->num_queue_groups *
> > +             (ctrl_info->num_elements_per_iq - 1));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "        passthrough IOCTLs: %u\n",
> > +             atomic_read(&pqi_statistics.num_passthru_ioctls));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "          heartbeat events: %u\n",
> > +             atomic_read(&pqi_statistics.num_heartbeat_events));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "          all other events: %u\n",
> > +             atomic_read(&pqi_statistics.num_all_other_events));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "                scan count: %u\n",
> > +             atomic_read(&pqi_statistics.num_scans));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "                interrupts: %u\n",
> > +             atomic_read(&pqi_statistics.num_interrupts));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "       spurious interrupts: %u\n",
> > +             atomic_read(&pqi_statistics.num_spurious_interrupts))=
;
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "  alloc request collisions: %u\n",
> > +             atomic_read(&pqi_statistics.num_alloc_io_request_coll=
isions));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "                RAID spans: %u\n",
> > +             atomic_read(&pqi_statistics.num_spans[RAID_PATH]));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "                 AIO spans: %u\n",
> > +             atomic_read(&pqi_statistics.num_spans[AIO_PATH]));
> > +
> > +     count +=3D snprintf(buffer + count, PAGE_SIZE - count,
> > +             "   interrupts on wrong CPU: %u\n",
> > +             atomic_read(&pqi_statistics.num_interrupts_wrong_cpu)=
);
> > +
> > +     return count;
> > +}
>=20
> Wasn't the sysfs rule one entry per file?

We removed this code.

>=20
> > +
> > +static ssize_t pqi_devices_show(struct device *dev,
> > +     struct device_attribute *attr, char *buffer)
> > +{
>=20
> [...]
>=20
> > +     rc =3D pqi_build_raid_path_request(ctrl_info, &request,
> > +             SA_CACHE_FLUSH, RAID_CTLR_LUNID, buffer,
> > +             SA_CACHE_FLUSH_BUFFER_LENGTH, 0, &pci_direction);
> > +     if (rc)
> > +             goto out;
> > +
> > +     rc =3D pqi_submit_raid_request_synchronous(ctrl_info, &reques=
t.header,
> > +             0, NULL, NO_TIMEOUT);
>=20
> So if this is called via the shutdown() -> pqi_shutdown() path it /ma=
y/ block
> shutdown infinitely? I'm not shure this is what people want.

A timeout has been added.

>=20
> > +
> > +     pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
> > +             pci_direction);
> > +
> > +out:
> > +     kfree(buffer);
> > +
>=20
> [...]
>=20
> > +static void pqi_complete_queued_requests(struct pqi_ctrl_info *ctr=
l_info,
> > +     struct pqi_scsi_dev_t *device_in_reset)
> > +{
> > +     unsigned int i;
> > +     unsigned int path;
> > +     struct pqi_queue_group *queue_group;
> > +     unsigned long flags;
> > +     struct pqi_io_request *io_request;
> > +     struct pqi_io_request *next;
> > +     struct scsi_cmnd *scmd;
> > +     struct pqi_scsi_dev_t *device;
> > +
> > +     for (i =3D 0; i < ctrl_info->num_queue_groups; i++) {
> > +             queue_group =3D &ctrl_info->queue_groups[i];
> > +
> > +             for (path =3D 0; path < 2; path++) {
> > +                     spin_lock_irqsave(&queue_group->submit_lock[p=
ath],
> > +                             flags);
> > +
> > +                     list_for_each_entry_safe(io_request, next,
> > +                             &queue_group->request_list[path],
> > +                             request_list_entry) {
> > +                             scmd =3D io_request->scmd;
> > +                             if (scmd) {
> > +                                     device =3D scmd->device->host=
data;
> > +                                     if (device =3D=3D device_in_r=
eset) {
> > +                                             set_host_byte(scmd, D=
ID_RESET);
> > +                                             pqi_scsi_done(scmd);
> > +                                             list_del(&io_request-=
>
> > +                                                     request_list_=
entry);
> > +                                     }
> > +                             }
> > +                     }
> > +
> > +                     spin_unlock_irqrestore(&queue_group->submit_l=
ock[path],
> > +                             flags);
> > +             }
>=20
> If you'd factor the inner for loop into an own small (inline) functio=
n, it
> could drastically improve readability here.
>=20
> something like
>=20
> static void pqi_complete_queue_group(struct pqi_queue_group *qg, stru=
ct
>                                      pqi_device_t *device_in_reset)
> {
>         unsigned int path;
>         unsigned long flags;
>         struct qpi_scsi_dev_t *dev;
>         struct pqi_io_request *ior, *next;
>=20
>         for (path =3D 0; path < 2; path++) {
>                 spin_lock_irqsave(&qg->submit_lock[path], flags);
>=20
>                 list_for_each_entry_save(ior, next, &qg->request_list=
[path],
>                                          request_list_entry) {
>                         scmd =3D ior->scmnd;
>                         if (!scmd)
>                                 continue;
>=20
>                         device =3D scmnd->device->hostdata;
>                         if (dev =3D=3D device_in_reset) {
>                                 set_host_byte(scmnd, DID_RESET);
>                                 pqi_scsi_done(scmnd);
>                                 list_del(&ior->request_list_entry);
>                         }
>                 }
>                 spin_unlock_irqresetore(&qg->submit_lock[path], flags=
);
>         }
> }
>=20
> > +     }
> > +}
> > +
>=20
> [..]
>=20

Done

> > +
> > +static DEVICE_ATTR(sas_address, S_IRUGO, pqi_sas_address_show, NUL=
L);
> > +static DEVICE_ATTR(ssd_smart_path_enabled, S_IRUGO,
> > +     pqi_ssd_smart_path_enabled_show, NULL);
> > +
> > +static struct device_attribute *pqi_sdev_attrs[] =3D {
> > +     &dev_attr_sas_address,
> > +     &dev_attr_ssd_smart_path_enabled,
> > +     NULL
> > +};
> > +
> > +static DEVICE_ATTR(rescan, S_IWUSR, NULL, pqi_host_store_rescan);
> > +static DEVICE_ATTR(stats, S_IRUGO, pqi_statistics_show, NULL);
> > +static DEVICE_ATTR(devices, S_IRUGO, pqi_devices_show, NULL);
> > +static DEVICE_ATTR(version, S_IRUGO, pqi_version_show, NULL);
> > +static DEVICE_ATTR(pqi, S_IRUGO, pqi_info_show, NULL);
> > +
> > +static struct device_attribute *pqi_shost_attrs[] =3D {
> > +     &dev_attr_rescan,
> > +     &dev_attr_stats,
> > +     &dev_attr_devices,
> > +     &dev_attr_version,
> > +     &dev_attr_pqi,
> > +     NULL
> > +};
>=20
> This should be somewhere near the functions implementing the sysfs sh=
ow
> callbacks.
>=20
> > +
> > +static int pqi_change_queue_depth(struct scsi_device *sdev, int qd=
epth)
> > +{
> > +     struct pqi_scsi_dev_t *device =3D sdev->hostdata;
>=20
> [...]
>=20

Done


> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
