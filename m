From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/8] scsi: take the DMA max mapping size into account
Date: Mon, 22 Jul 2019 07:40:20 +0000
Message-ID: <BYAPR04MB58168CBFF8B691DF33C73DDBE7C40@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-3-hch@lst.de>
 <5d143a03-edd5-5878-780b-45d87313a813@acm.org>
 <CACVXFVMWM3xg6EEyoyNjkLPv=8+wQKiHj6erMS_gGX25f-Ot4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Bart van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2019/07/22 15:01, Ming Lei wrote:=0A=
> On Tue, Jun 18, 2019 at 4:57 AM Bart Van Assche <bvanassche@acm.org> wrot=
e:=0A=
>>=0A=
>> On 6/17/19 5:19 AM, Christoph Hellwig wrote:=0A=
>>> We need to limit the devices max_sectors to what the DMA mapping=0A=
>>> implementation can support.  If not we risk running out of swiotlb=0A=
>>> buffers easily.=0A=
>>>=0A=
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
>>> ---=0A=
>>>   drivers/scsi/scsi_lib.c | 2 ++=0A=
>>>   1 file changed, 2 insertions(+)=0A=
>>>=0A=
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
>>> index d333bb6b1c59..f233bfd84cd7 100644=0A=
>>> --- a/drivers/scsi/scsi_lib.c=0A=
>>> +++ b/drivers/scsi/scsi_lib.c=0A=
>>> @@ -1768,6 +1768,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, s=
truct request_queue *q)=0A=
>>>               blk_queue_max_integrity_segments(q, shost->sg_prot_tables=
ize);=0A=
>>>       }=0A=
>>>=0A=
>>> +     shost->max_sectors =3D min_t(unsigned int, shost->max_sectors,=0A=
>>> +                     dma_max_mapping_size(dev) << SECTOR_SHIFT);=0A=
>>>       blk_queue_max_hw_sectors(q, shost->max_sectors);=0A=
>>>       if (shost->unchecked_isa_dma)=0A=
>>>               blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);=0A=
>>=0A=
>> Does dma_max_mapping_size() return a value in bytes? Is=0A=
>> shost->max_sectors a number of sectors? If so, are you sure that "<<=0A=
>> SECTOR_SHIFT" is the proper conversion? Shouldn't that be ">>=0A=
>> SECTOR_SHIFT" instead?=0A=
> =0A=
> Now the patch has been committed, '<< SECTOR_SHIFT' needs to be fixed.=0A=
> =0A=
> Also the following kernel oops is triggered on qemu, and looks=0A=
> device->dma_mask is NULL.=0A=
=0A=
Just hit the exact same problem using tcmu-runner (ZBC file handler) on bar=
e=0A=
metal (no QEMU). dev->dma_mask is NULL. No problem with real disks though.=
=0A=
=0A=
> =0A=
> [    5.826483] scsi host0: Virtio SCSI HBA=0A=
> [    5.829302] st: Version 20160209, fixed bufsize 32768, s/g segs 256=0A=
> [    5.831042] SCSI Media Changer driver v0.25=0A=
> [    5.832491] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
> [    5.833332] BUG: KASAN: null-ptr-deref in=0A=
> dma_direct_max_mapping_size+0x30/0x94=0A=
> [    5.833332] Read of size 8 at addr 0000000000000000 by task kworker/u1=
7:0/7=0A=
> [    5.835506] nvme nvme0: pci function 0000:00:07.0=0A=
> [    5.833332]=0A=
> [    5.833332] CPU: 2 PID: 7 Comm: kworker/u17:0 Not tainted 5.3.0-rc1 #1=
328=0A=
> [    5.836999] ahci 0000:00:1f.2: version 3.0=0A=
> [    5.833332] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),=0A=
> BIOS ?-20180724_192412-buildhw-07.phx4=0A=
> [    5.833332] Workqueue: events_unbound async_run_entry_fn=0A=
> [    5.833332] Call Trace:=0A=
> [    5.833332]  dump_stack+0x6f/0x9d=0A=
> [    5.833332]  ? dma_direct_max_mapping_size+0x30/0x94=0A=
> [    5.833332]  __kasan_report+0x161/0x189=0A=
> [    5.833332]  ? dma_direct_max_mapping_size+0x30/0x94=0A=
> [    5.833332]  kasan_report+0xe/0x12=0A=
> [    5.833332]  dma_direct_max_mapping_size+0x30/0x94=0A=
> [    5.833332]  __scsi_init_queue+0xd8/0x1f3=0A=
> [    5.833332]  scsi_mq_alloc_queue+0x62/0x89=0A=
> [    5.833332]  scsi_alloc_sdev+0x38c/0x479=0A=
> [    5.833332]  scsi_probe_and_add_lun+0x22d/0x1093=0A=
> [    5.833332]  ? kobject_set_name_vargs+0xa4/0xb2=0A=
> [    5.833332]  ? mutex_lock+0x88/0xc4=0A=
> [    5.833332]  ? scsi_free_host_dev+0x4a/0x4a=0A=
> [    5.833332]  ? _raw_spin_lock_irqsave+0x8c/0xde=0A=
> [    5.833332]  ? _raw_write_unlock_irqrestore+0x23/0x23=0A=
> [    5.833332]  ? ata_tdev_match+0x22/0x45=0A=
> [    5.833332]  ? attribute_container_add_device+0x160/0x17e=0A=
> [    5.833332]  ? rpm_resume+0x26a/0x7c0=0A=
> [    5.833332]  ? kobject_get+0x12/0x43=0A=
> [    5.833332]  ? rpm_put_suppliers+0x7e/0x7e=0A=
> [    5.833332]  ? _raw_spin_lock_irqsave+0x8c/0xde=0A=
> [    5.833332]  ? _raw_write_unlock_irqrestore+0x23/0x23=0A=
> [    5.833332]  ? scsi_target_destroy+0x135/0x135=0A=
> [    5.833332]  __scsi_scan_target+0x14b/0x6aa=0A=
> [    5.833332]  ? pvclock_clocksource_read+0xc0/0x14e=0A=
> [    5.833332]  ? scsi_add_device+0x20/0x20=0A=
> [    5.833332]  ? rpm_resume+0x1ae/0x7c0=0A=
> [    5.833332]  ? rpm_put_suppliers+0x7e/0x7e=0A=
> [    5.833332]  ? _raw_spin_lock_irqsave+0x8c/0xde=0A=
> [    5.833332]  ? _raw_write_unlock_irqrestore+0x23/0x23=0A=
> [    5.833332]  ? pick_next_task_fair+0x976/0xa3d=0A=
> [    5.833332]  ? mutex_lock+0x88/0xc4=0A=
> [    5.833332]  scsi_scan_channel+0x76/0x9e=0A=
> [    5.833332]  scsi_scan_host_selected+0x131/0x176=0A=
> [    5.833332]  ? scsi_scan_host+0x241/0x241=0A=
> [    5.833332]  do_scan_async+0x27/0x219=0A=
> [    5.833332]  ? scsi_scan_host+0x241/0x241=0A=
> [    5.833332]  async_run_entry_fn+0xdc/0x23d=0A=
> [    5.833332]  process_one_work+0x327/0x539=0A=
> [    5.833332]  worker_thread+0x330/0x492=0A=
> [    5.833332]  ? rescuer_thread+0x41f/0x41f=0A=
> [    5.833332]  kthread+0x1c6/0x1d5=0A=
> [    5.833332]  ? kthread_park+0xd3/0xd3=0A=
> [    5.833332]  ret_from_fork+0x1f/0x30=0A=
> [    5.833332] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
> =0A=
> =0A=
> =0A=
> Thanks,=0A=
> Ming Lei=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
