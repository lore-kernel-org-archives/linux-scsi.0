From: Dexuan-Linux Cui <dexuan.linux@gmail.com>
Subject: Re: [PATCH 2/8] scsi: take the DMA max mapping size into account
Date: Sun, 21 Jul 2019 23:18:51 -0700
Message-ID: <CAA42JLY4zWnCEMXbR+NNbixjOyKfnMqQ0ujJdP5_gus_tu88Jw@mail.gmail.com>
References: <20190617122000.22181-1-hch@lst.de> <20190617122000.22181-3-hch@lst.de>
 <5d143a03-edd5-5878-780b-45d87313a813@acm.org> <CACVXFVMWM3xg6EEyoyNjkLPv=8+wQKiHj6erMS_gGX25f-Ot4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMWM3xg6EEyoyNjkLPv=8+wQKiHj6erMS_gGX25f-Ot4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dexuan Cui <decui@microsoft.com>, v-lide@microsoft.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 21, 2019 at 11:01 PM Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Tue, Jun 18, 2019 at 4:57 AM Bart Van Assche <bvanassche@acm.org> wrote:
> >
> > On 6/17/19 5:19 AM, Christoph Hellwig wrote:
> > > We need to limit the devices max_sectors to what the DMA mapping
> > > implementation can support.  If not we risk running out of swiotlb
> > > buffers easily.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >   drivers/scsi/scsi_lib.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index d333bb6b1c59..f233bfd84cd7 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -1768,6 +1768,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
> > >               blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
> > >       }
> > >
> > > +     shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> > > +                     dma_max_mapping_size(dev) << SECTOR_SHIFT);
> > >       blk_queue_max_hw_sectors(q, shost->max_sectors);
> > >       if (shost->unchecked_isa_dma)
> > >               blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
> >
> > Does dma_max_mapping_size() return a value in bytes? Is
> > shost->max_sectors a number of sectors? If so, are you sure that "<<
> > SECTOR_SHIFT" is the proper conversion? Shouldn't that be ">>
> > SECTOR_SHIFT" instead?
>
> Now the patch has been committed, '<< SECTOR_SHIFT' needs to be fixed.
>
> Also the following kernel oops is triggered on qemu, and looks
> device->dma_mask is NULL.
>
> Ming Lei

FYI: we also see the panic with a Linux kernel 5.2.0-next-20190719
running on Hyper-V:

[    7.429053] RIP: 0010:dma_direct_max_mapping_size+0x26/0x80
[    7.429053] Code: 0f b6 c0 c3 0f 1f 44 00 00 55 48 89 e5 41 54 53
48 89 fb e8 4c 14 00 00 84 c0 74 45 48 8b 83 28 02 00 00 4c 8b a3 38
02 00 00 <48> 8b 00 48 85 c0 74 0c 4d 85 e4 74 36 49 39 c4 4c 0f 47 e0
48 89
[    7.429053] RSP: 0018:ffffc1d5005efbc0 EFLAGS: 00010202
[    7.429053] RAX: 0000000000000000 RBX: ffff9cf86d24c428 RCX: 0000000000000000
[    7.429053] RDX: ffff9cf86d12dd00 RSI: 0000000000000200 RDI: ffff9cf86d24c428
[    7.429053] RBP: ffffc1d5005efbd0 R08: ffff9cf86fcaf0e0 R09: ffff9cf86e0072c0
[    7.429053] R10: ffffc1d5005efa70 R11: 00000000000301a0 R12: 0000000000000000
[    7.429053] R13: ffff9cf86d24c428 R14: 0000000000000400 R15: ffff9cf825cff000
[    7.429053] FS:  0000000000000000(0000) GS:ffff9cf86fc80000(0000)
knlGS:0000000000000000
[    7.429053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.429053] CR2: 0000000000000000 CR3: 00000003c700a001 CR4: 00000000003606e0
[    7.456569] NET: Registered protocol family 17
[    7.429053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.469803] Key type dns_resolver registered
[    7.429053] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    7.429053] Call Trace:
[    7.429053]  dma_max_mapping_size+0x39/0x50
[    7.429053]  __scsi_init_queue+0x7f/0x140
[    7.429053]  scsi_mq_alloc_queue+0x38/0x60
[    7.429053]  scsi_alloc_sdev+0x1da/0x2b0
[    7.429053]  scsi_probe_and_add_lun+0x471/0xe60
[    7.429053]  __scsi_scan_target+0xfc/0x610
[    7.429053]  scsi_scan_channel+0x66/0xa0
[    7.429053]  scsi_scan_host_selected+0xf3/0x160
[    7.429053]  do_scsi_scan_host+0x93/0xa0
[    7.429053]  do_scan_async+0x1c/0x190
[    7.429053]  async_run_entry_fn+0x3c/0x150
[    7.429053]  process_one_work+0x1f7/0x3f0
[    7.429053]  worker_thread+0x34/0x400
[    7.429053]  kthread+0x121/0x140
[    7.429053]  ret_from_fork+0x35/0x40
[    7.429053] Modules linked in:
[    7.429053] CR2: 0000000000000000
[    7.766122] BUG: kernel NULL pointer dereference, address: 0000000000000000

Thanks,
-- Dexuan
