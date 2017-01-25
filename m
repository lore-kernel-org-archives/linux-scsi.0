From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] SCSI core: Fix WRITE SAME handling
Date: Tue, 24 Jan 2017 17:21:08 -0800
Message-ID: <5bedd463-8f55-4506-0593-fd0040c47a17@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:32845
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750966AbdAYBVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 20:21:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch avoids that sending a WRITE SAME command to the iSCSI
initiator triggers the following:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
TARGET_CORE[iSCSI]: Expected Transfer Length: 260096 does not match SCSI CDB Length: 512 for SAM Opcode: 0x41
IP: iscsi_tcp_segment_done+0x20b/0x310 [libiscsi_tcp]

Oops: 0000 [#1] SMP
Modules linked in: target_core_user uio target_core_iblock target_core_file iscsi_target_mod target_core_mod netconsole configfs crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper virtio_console virtio_rng virtio_balloon serio_raw i2c_piix4 acpi_cpufreq button iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext4 jbd2 mbcache virtio_blk virtio_net psmouse floppy drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm virtio_pci
CPU: 2 PID: 5 Comm: kworker/u8:0 Not tainted 4.10.0-rc5-debug+ #3
Workqueue: iscsi_q_0 iscsi_xmitworker [libiscsi]
RIP: 0010:iscsi_tcp_segment_done+0x20b/0x310 [libiscsi_tcp]
Call Trace:
 iscsi_sw_tcp_xmit_segment+0x84/0x120 [iscsi_tcp]
 iscsi_sw_tcp_pdu_xmit+0x51/0x180 [iscsi_tcp]
 iscsi_tcp_task_xmit+0xb3/0x290 [libiscsi_tcp]
 iscsi_xmit_task+0x4e/0xc0 [libiscsi]
 iscsi_xmitworker+0x243/0x330 [libiscsi]
 process_one_work+0x1d8/0x4b0
 worker_thread+0x49/0x4a0
 kthread+0x102/0x140

Fixes: f80de881d8df ("sd: remove __data_len hack for WRITE SAME")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@fb.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/scsi_lib.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e141af9c..004f17042081 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1000,6 +1000,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 }
 
+static u64 sg_data_length(struct sg_table *sg_table)
+{
+	struct scatterlist *sg;
+	int i;
+	u64 len = 0;
+
+	for_each_sg(sg_table->sgl, sg, sg_table->nents, i)
+		len += sg->length;
+
+	return len;
+}
+
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 {
 	int count;
@@ -1018,7 +1030,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
-	sdb->length = blk_rq_payload_bytes(req);
+	sdb->length = sg_data_length(&sdb->table);
 	return BLKPREP_OK;
 }
 
-- 
2.11.0

