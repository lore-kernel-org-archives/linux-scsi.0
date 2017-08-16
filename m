From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 10:43:24 -0700
Message-ID: <20170816174324.29276-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For an unknown reason this patch causes the boot process to hang on
PowerPC systems:

sd 0:2:0:0: [sda] 272646144 512-byte logical blocks: (140 GB/130 GiB)
sd 0:2:0:0: [sda] 4096-byte physical blocks
sd 0:2:0:0: [sda] Write Protect is off
INFO: task swapper/5:1 blocked for more than 120 seconds.
      Not tainted 4.13.0-rc4-next-20170810-autotest #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
swapper/5       D 9936     1      0 0x00000800
Call Trace:
[c0000007f8483a10] [c0000007f8483a80] 0xc0000007f8483a80 (unreliable)
[c0000007f8483be0] [c00000000001b358] __switch_to+0x2e8/0x430
[c0000007f8483c40] [c0000000009d134c] __schedule+0x38c/0xaf0
[c0000007f8483d20] [c0000000009d1af0] schedule+0x40/0xb0
[c0000007f8483d50] [c000000000110bd4] async_synchronize_cookie_domain+0xd4/0x150
[c0000007f8483dc0] [c00000000000d8f8] kernel_init+0x28/0x140
[c0000007f8483e30] [c00000000000bc60] ret_from_kernel_thread+0x5c/0x7c

Hence revert commit 270065e92c31.

Fixes: commit 270065e92c31 ("scsi: scsi-mq: Always unprepare before requeuing a request")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7e92818e6597..e57c80d4648d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -44,8 +44,6 @@ static struct kmem_cache *scsi_sense_cache;
 static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
 
-static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd);
-
 static inline struct kmem_cache *
 scsi_select_sense_cache(bool unchecked_isa_dma)
 {
@@ -142,12 +140,6 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 
-	if (cmd->request->rq_flags & RQF_DONTPREP) {
-		cmd->request->rq_flags &= ~RQF_DONTPREP;
-		scsi_mq_uninit_cmd(cmd);
-	} else {
-		WARN_ON_ONCE(true);
-	}
 	blk_mq_requeue_request(cmd->request, true);
 	put_device(&sdev->sdev_gendev);
 }
@@ -985,6 +977,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * A new command will be prepared and issued.
 		 */
 		if (q->mq_ops) {
+			cmd->request->rq_flags &= ~RQF_DONTPREP;
+			scsi_mq_uninit_cmd(cmd);
 			scsi_mq_requeue_cmd(cmd);
 		} else {
 			scsi_release_buffers(cmd);
-- 
2.14.0
