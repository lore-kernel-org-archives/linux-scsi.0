From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: scsi-mq WIP updated to v3.13-rc3
Date: Mon, 23 Dec 2013 11:03:41 -0800
Message-ID: <1387825421.5567.169.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Folks,

Just a heads up that scsi-mq alpha code has been updated to v3.13-rc3
using the freshly upstreamed blk-mq logic.  The working branch is
available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git scsi-mq

The changelog since the last v3.12-rc3 rev includes:

   - Use Scsi_Host to check for can_queue + cmd_per_lun
   - Add explicit struct scsi_cmnd memset in scsi_mq_alloc_queue()
   - Add support for cmd->prot_sdb pre-allocation
   - Add support for cmd->mq_prot_sgl pre-allocation
   - Honor request_queue->dma_drain_size in scsi_mq_queue_rq (Jianpeng Ma)
   - Drop unnecessary QUEUE_FLAG_NONROT in scsi_mq_alloc_queue (Jianpeng Ma)
   - Add bio_integrity setup to blk_mq_make_request
   - Pre-allocation of sg tables based on host sg_tablesize (Jianpeng Ma)
   - Pre-allocation of protection sg tables based on host sg_tablesize
   - Updates for DIF prot_sdb->table.sgl pre-allocation in scsi_init_io
   - Acquire q->sysfs_lock for elevator_init (Fengguang)
   - Only reference scsi_cmd_to_driver with valid req->rq_disk in
     scsi_finish_command()

Also, basic DIF functionality is now working!  Here's a quick snippet of
DIF TYPE1 in action using scsi_debug dif=1 dix=1:

[   34.331249] scsi_debug_init: dif_storep 16777216 bytes @ ffffc90001459000
[   34.338588] scsi_debug: host protection DIF1 DIX1
[   34.339490] scsi6 : scsi_debug, version 1.82 [20100324], dev_size_mb=1024, opts=0x0
[   34.341026] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff8163e760, queue_depth: 64, cmd_size: 304 SCSI cmd_size: 0
[   34.343031] blk-mq: CPU -> queue map
[   34.343689]   CPU 0 -> Queue 0
[   34.344322]   CPU 1 -> Queue 0
[   34.344869]   CPU 2 -> Queue 0
[   34.345422]   CPU 3 -> Queue 0
[   34.346005] Performing sc map setup on q: ffff880030180000 hctx: ffff880034e3de00 i: 0
[   34.348146] scsi_mq_alloc_queue() complete >>>>>>>>>>>>>>>>>>>>>>>>>>>
[   34.349393] scsi 6:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[   34.351013] sd 6:0:0:0: Attached scsi generic sg1 type 0
[   34.352067] sd 6:0:0:0: [sda] Enabling DIF Type 1 protection
[   34.352075] sd 6:0:0:0: [sda] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
[   34.360115] sd 6:0:0:0: [sda] Write Protect is off
[   34.363006] sd 6:0:0:0: [sda] Mode Sense: 73 00 10 08
[   34.372176] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   34.416255]  sda: unknown partition table
[   34.419315] sd 6:0:0:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection
[   34.423194] sd 6:0:0:0: [sda] DIF application tag size 2
[   34.444172] sd 6:0:0:0: [sda] Attached SCSI disk
[   68.554153] scsi_mq: sc: ffff880030198568 SCSI CDB: : 0x00
[   68.554164] scsi_mq: scsi_bufflen: 0 rq->cmd_len: 6
[   68.554178] scsi_mq_end_request: sc: ffff880030198568 sc->tag: 48 error: 0
[   68.554243] Entering sd_dif_type1_generate >>>>>>>>>>>>>>>
[   68.554264] TYPE1 Generate: sector: 0 sdt->guard_tag: 0xdfcc sdt->app_tag: 0x0000 sdt->ref_tag: 0
[   68.554281] TYPE1 Generate: sector: 1 sdt->guard_tag: 0xd693 sdt->app_tag: 0x0000 sdt->ref_tag: 1
[   68.554297] TYPE1 Generate: sector: 2 sdt->guard_tag: 0xd8ea sdt->app_tag: 0x0000 sdt->ref_tag: 2
[   68.554309] TYPE1 Generate: sector: 3 sdt->guard_tag: 0x64a3 sdt->app_tag: 0x0000 sdt->ref_tag: 3
[   68.554322] TYPE1 Generate: sector: 4 sdt->guard_tag: 0xd194 sdt->app_tag: 0x0000 sdt->ref_tag: 4
[   68.554334] TYPE1 Generate: sector: 5 sdt->guard_tag: 0x0c30 sdt->app_tag: 0x0000 sdt->ref_tag: 5
[   68.554346] TYPE1 Generate: sector: 6 sdt->guard_tag: 0xcbff sdt->app_tag: 0x0000 sdt->ref_tag: 6
[   68.554359] TYPE1 Generate: sector: 7 sdt->guard_tag: 0x5c4e sdt->app_tag: 0x0000 sdt->ref_tag: 7
[   68.554384] scsi_mq: sc: ffff880030198568 SCSI CDB: : 0x2a
[   68.554389] scsi_mq: scsi_bufflen: 4096 rq->cmd_len: 16
[   68.554396] Enering prot_verify_write sector: 8 ei_lba: 0
[   68.554402] WRITE sector: 0 sdt->guard_tag: 0xdfcc sdt->app_tag: 0x0000 sdt->ref_tag: 0
[   68.554414] WRITE sector: 1 sdt->guard_tag: 0xd693 sdt->app_tag: 0x0000 sdt->ref_tag: 1
[   68.554427] WRITE sector: 2 sdt->guard_tag: 0xd8ea sdt->app_tag: 0x0000 sdt->ref_tag: 2
[   68.554439] WRITE sector: 3 sdt->guard_tag: 0x64a3 sdt->app_tag: 0x0000 sdt->ref_tag: 3
[   68.554451] WRITE sector: 4 sdt->guard_tag: 0xd194 sdt->app_tag: 0x0000 sdt->ref_tag: 4
[   68.554463] WRITE sector: 5 sdt->guard_tag: 0x0c30 sdt->app_tag: 0x0000 sdt->ref_tag: 5
[   68.554475] WRITE sector: 6 sdt->guard_tag: 0xcbff sdt->app_tag: 0x0000 sdt->ref_tag: 6
[   68.554488] WRITE sector: 7 sdt->guard_tag: 0x5c4e sdt->app_tag: 0x0000 sdt->ref_tag: 7

<SNIP>

[   68.572734] scsi_mq: sc: ffff880030198568 SCSI CDB: : 0x28
[   68.572741] scsi_mq: scsi_bufflen: 4096 rq->cmd_len: 16
[   68.572750] Entering prot_verify_read: sector: 8 ei_lba: 0
[   68.572758] READ sector: 0 sdt->guard_tag: 0xdfcc sdt->app_tag: 0x0000 sdt->ref_tag: 0
[   68.572774] READ sector: 1 sdt->guard_tag: 0xd693 sdt->app_tag: 0x0000 sdt->ref_tag: 1
[   68.572786] READ sector: 2 sdt->guard_tag: 0xd8ea sdt->app_tag: 0x0000 sdt->ref_tag: 2
[   68.572799] READ sector: 3 sdt->guard_tag: 0x64a3 sdt->app_tag: 0x0000 sdt->ref_tag: 3
[   68.572811] READ sector: 4 sdt->guard_tag: 0xd194 sdt->app_tag: 0x0000 sdt->ref_tag: 4
[   68.572823] READ sector: 5 sdt->guard_tag: 0x0c30 sdt->app_tag: 0x0000 sdt->ref_tag: 5
[   68.572835] READ sector: 6 sdt->guard_tag: 0xcbff sdt->app_tag: 0x0000 sdt->ref_tag: 6
[   68.572847] READ sector: 7 sdt->guard_tag: 0x5c4e sdt->app_tag: 0x0000 sdt->ref_tag: 7
[   68.576195] scsi_mq_end_request: sc: ffff880030198568 sc->tag: 48 error: 0
[   68.576383] TYPE1 Verify sector: 0 sdt->guard_tag: 0xdfcc sdt->app_tag: 0x0000 sdt->ref_tag: 0
[   68.576397] TYPE1 Verify sector: 1 sdt->guard_tag: 0xd693 sdt->app_tag: 0x0000 sdt->ref_tag: 1
[   68.576409] TYPE1 Verify sector: 2 sdt->guard_tag: 0xd8ea sdt->app_tag: 0x0000 sdt->ref_tag: 2
[   68.576422] TYPE1 Verify sector: 3 sdt->guard_tag: 0x64a3 sdt->app_tag: 0x0000 sdt->ref_tag: 3
[   68.576434] TYPE1 Verify sector: 4 sdt->guard_tag: 0xd194 sdt->app_tag: 0x0000 sdt->ref_tag: 4
[   68.576446] TYPE1 Verify sector: 5 sdt->guard_tag: 0x0c30 sdt->app_tag: 0x0000 sdt->ref_tag: 5
[   68.576458] TYPE1 Verify sector: 6 sdt->guard_tag: 0xcbff sdt->app_tag: 0x0000 sdt->ref_tag: 6
[   68.576490] TYPE1 Verify sector: 7 sdt->guard_tag: 0x5c4e sdt->app_tag: 0x0000 sdt->ref_tag: 7


So now with some of the lower-hanging bugs out of the way, I'll next be
focusing identifying outstanding TODO items over the holidays for those
who are interested in contributing in 2014.

Enjoy.

--nab
