From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Revert "sd: remove __data_len hack for WRITE SAME"
Date: Wed, 25 Jan 2017 13:43:56 -0800
Message-ID: <48f53712-569e-d5c3-7269-d0eeb481f8ee@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0061.outbound.protection.outlook.com ([104.47.32.61]:59978
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752393AbdAYVoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 16:44:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch reverts commit f80de881d8df and avoids that sending a
WRITE SAME command to the iSCSI initiator triggers the following:

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
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/sd.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0b09638fa39b..6e6d4a41613f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -836,6 +836,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	struct bio *bio = rq->bio;
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	int ret;
 
 	if (sdkp->device->no_write_same)
@@ -868,7 +869,21 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	cmd->transfersize = sdp->sector_size;
 	cmd->allowed = SD_MAX_RETRIES;
-	return scsi_init_io(cmd);
+
+	/*
+	 * For WRITE SAME the data transferred via the DATA OUT buffer is
+	 * different from the amount of data actually written to the target.
+	 *
+	 * We set up __data_len to the amount of data transferred via the
+	 * DATA OUT buffer so that blk_rq_map_sg sets up the proper S/G list
+	 * to transfer a single sector of data first, but then reset it to
+	 * the amount of data to be written right after so that the I/O path
+	 * knows how much to actually write.
+	 */
+	rq->__data_len = sdp->sector_size;
+	ret = scsi_init_io(cmd);
+	rq->__data_len = nr_bytes;
+	return ret;
 }
 
 static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
-- 
2.11.0

