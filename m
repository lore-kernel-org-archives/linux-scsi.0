From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 18 Jul 2013 23:34:20 -0700
Message-ID: <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
References: <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
	 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
	 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
	 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
	 <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
	 <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
	 <51E83E32.9050306@cs.wisc.edu>
	 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-07-18 at 18:03 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-18 at 18:30 -0600, Jens Axboe wrote:
> > On Thu, Jul 18 2013, Nicholas A. Bellinger wrote:
> > > On Thu, 2013-07-18 at 13:12 -0600, Mike Christie wrote:
> > > > On 07/18/2013 12:51 PM, Nicholas A. Bellinger wrote:

<SNIP>

> > > <nod>, just noticed the blk_queue_bounce() in blk_rq_map_kern().  
> > > 
> > > Not sure why this doesn't seem to be doing what it's supposed to for
> > > libata just yet..
> > 
> > How are you make the request from the bio? It'd be pretty trivial to
> > ensure that it gets bounced properly... blk_mq_execute_rq() assumes a
> > fully complete request, so it wont bounce anything.
> > 
> 
> From what I gather for REQ_TYPE_BLOCK_PC, scsi_execute() ->
> blk_rq_map_kern() -> blk_rq_append_bio() -> blk_rq_bio_prep() is what
> does the request setup from the bios returned by bio_[copy,map]_kern()
> in blk_rq_map_kern() code.
> 
> blk_queue_bounce() is called immediately after blk_rq_append_bio() here,
> which AFAICT looks like it's doing the correct thing for scsi-mq..
> 
> What is strange here is that libata-scsi.c CDB emulation code is doing
> the same stuff for both INQUIRY (that seems to be OK) and READ_CAPACITY
> (that is returning zeros), which makes me think that something else is
> going on..
> 
> Alexander, where you able to re-test using sdev->sdev_mq_reg.queue_depth
> = 1 in scsi_mq_alloc_queue()..?
> 

So after a bit more hacking tonight it appears the explicit setting of
dma_alignment by libata (sdev->sector_size - 1) is what is making
blk_rq_map_kern() invoke blk_copy_kern() instead of blk_map_kern(), and
triggering this scsi-mq specific bug with libata.  I'm able to confirm
with QEMU IDE emulation the bug is occurring only after INQUIRY and
before READ_CAPACITY, as reported by Alexander.

Below is a quick hack to skip this setting in ata_scsi_dev_config() for
blk-mq, and leaves the default dma_alignment=0x03 for REQ_TYPE_BLOCK_PC
requests as initially set by scsi-core in scsi_init_request_queue().

Also included is the change for using queue_depth = min(SHT->can_queue,
SHT->cmd_per_lun) during scsi-mq request_queue initialization, along
with a very basic ata_piix conversion for testing purposes.

With these three changes in place, I'm able to register a single 1GB
ata_piix LUN using QEMU IDE emulation, and successfully run simple fio
writeverify tests with blocksize=4k @ queue_depth=1.

Obviously this is not a proper bugfix for unaligned blk_copy_kern() with
scsi-mq + REQ_TYPE_BLOCK_PC case, but should be enough to at least get
libata LUN scanning to work.  Need to take a deeper look at the problem
here..

Alexander, care to give this work-around a shot on your bare-metal setup
using ata_piix..?

--nab

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9a8a674..ac05cd6 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1066,6 +1066,8 @@ static u8 piix_vmw_bmdma_status(struct ata_port *ap)
 
 static struct scsi_host_template piix_sht = {
        ATA_BMDMA_SHT(DRV_NAME),
+       .scsi_mq        = true,
+       .queuecommand_mq = ata_scsi_queuecmd,
 };
 
 static struct ata_port_operations piix_sata_ops = {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0101af5..191bc15 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1144,7 +1144,11 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
                        "sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
                        sdev->sector_size);
 
-       blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
+       if (!q->mq_ops) {
+               blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
+       } else {
+               printk("Skipping dma_alignment for libata w/ scsi-mq\n");
+       }
 
        if (dev->flags & ATA_DFLAG_AN)
                set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
index ca6ff67..81b2633 100644
--- a/drivers/scsi/scsi-mq.c
+++ b/drivers/scsi/scsi-mq.c
@@ -199,11 +199,11 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
        int i, j;
 
        sdev->sdev_mq_reg.ops = &scsi_mq_ops;
-       sdev->sdev_mq_reg.queue_depth = sdev->queue_depth;
+       sdev->sdev_mq_reg.queue_depth = min((short)sh->hostt->can_queue,
+                                           sh->hostt->cmd_per_lun);
        sdev->sdev_mq_reg.cmd_size = sizeof(struct scsi_cmnd) + sh->hostt->cmd_size;
        sdev->sdev_mq_reg.numa_node = NUMA_NO_NODE;
        sdev->sdev_mq_reg.nr_hw_queues = 1;
-       sdev->sdev_mq_reg.queue_depth = 64;
        sdev->sdev_mq_reg.flags = BLK_MQ_F_SHOULD_MERGE;
 
        printk("Calling blk_mq_init_queue: scsi_mq_ops: %p, queue_depth: %d,"

