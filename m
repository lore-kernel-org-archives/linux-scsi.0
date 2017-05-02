From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Tue, 2 May 2017 10:43:30 -0700
Message-ID: <20170502174330.13146-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Scott Bauer <scott.bauer@intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes the following KASAN complaint:

==================================================================
BUG: KASAN: use-after-free in scsi_exit_rq+0xf3/0x120 at addr ffff8802b7fedf00
Read of size 1 by task rcuos/5/53
CPU: 7 PID: 53 Comm: rcuos/6 Not tainted 4.11.0-rc5+ #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0 ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Call Trace:
 dump_stack+0x63/0x8f
 kasan_object_err+0x21/0x70
 kasan_report.part.1+0x231/0x500
 __asan_report_load1_noabort+0x2e/0x30
 scsi_exit_rq+0xf3/0x120
 free_request_size+0x44/0x60
 mempool_destroy.part.6+0x9b/0x150
 mempool_destroy+0x13/0x20
 blk_exit_rl+0x36/0x40
 blkg_free+0x146/0x200
 __blkg_release_rcu+0x121/0x220
 rcu_nocb_kthread+0x61f/0xca0
 kthread+0x298/0x390
 ret_from_fork+0x2c/0x40
Object at ffff8802b7fedd80, in cache kmalloc-2048 size: 2048
Allocated:
PID = 3992
 save_stack_trace+0x1b/0x20
 save_stack+0x46/0xd0
 kasan_kmalloc+0xad/0xe0
 __kmalloc+0x134/0x220
 scsi_host_alloc+0x6b/0x11c0
 0xffffffffc101d94a
 driver_probe_device+0x49e/0xc60
 __device_attach_driver+0x1d3/0x2a0
 bus_for_each_drv+0x11a/0x1d0
 __device_attach+0x1e1/0x2c0
 device_initial_probe+0x13/0x20
 bus_probe_device+0x19b/0x240
 device_add+0x86d/0x1450
 device_register+0x1a/0x20
 0xffffffffc10270ce
 0xffffffffc1048a62
 do_one_initcall+0xa7/0x250
 do_init_module+0x1d0/0x55d
 load_module+0x7c9f/0x9850
 SYSC_finit_module+0x189/0x1c0
 SyS_finit_module+0xe/0x10
 entry_SYSCALL_64_fastpath+0x1a/0xa9
Freed:
PID = 4128
 save_stack_trace+0x1b/0x20
 save_stack+0x46/0xd0
 kasan_slab_free+0x71/0xb0
 kfree+0x8d/0x1b0
 scsi_host_dev_release+0x2cb/0x430
 device_release+0x76/0x1e0
 kobject_release+0x107/0x370
 kobject_put+0x56/0xb0
 put_device+0x17/0x20
 scsi_host_put+0x15/0x20
 0xffffffffc101fcd7
 device_release_driver_internal+0x26a/0x4e0
 device_release_driver+0x12/0x20
 bus_remove_device+0x2d0/0x590
 device_del+0x55b/0x920
 device_unregister+0x1a/0xa0
 0xffffffffc101e0ca
 0xffffffffc102fccc
 SyS_delete_module+0x334/0x3e0
 entry_SYSCALL_64_fastpath+0x1a/0xa9
Memory state around the buggy address:
 ffff8802b7fede00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8802b7fede80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8802b7fedf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8802b7fedf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8802b7fee000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Reported-by: Scott Bauer <scott.bauer@intel.com>
Fixes: e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Scott Bauer <scott.bauer@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 15c9fe766071..d698364df072 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2095,11 +2095,14 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	struct Scsi_Host *shost = q->rq_alloc_data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
+	if (!scsi_host_get(shost))
+		goto fail;
+
 	memset(cmd, 0, sizeof(*cmd));
 
 	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
-		goto fail;
+		goto put;
 	cmd->req.sense = cmd->sense_buffer;
 
 	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
@@ -2112,6 +2115,8 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 
 fail_free_sense:
 	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+put:
+	scsi_host_put(shost);
 fail:
 	return -ENOMEM;
 }
@@ -2124,6 +2129,7 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 	if (cmd->prot_sdb)
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
 	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+	scsi_host_put(shost);
 }
 
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
-- 
2.12.2
