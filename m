From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] [SCSI] Fix block queue and elevator memory leak in
 scsi_alloc_sdev
Date: Thu, 3 Nov 2011 08:56:22 +1100
Message-ID: <20111103085622.2cde66ea@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


When looking at memory consumption issues I noticed quite a
lot of memory in the kmalloc-2048 bucket:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
  6561   6471  98%    2.30K    243       27     15552K kmalloc-2048

Over 15MB. slub debug shows that cfq is responsible for almost
all of it:

# sort -nr /sys/kernel/slab/kmalloc-2048/alloc_calls
6402 .cfq_init_queue+0xec/0x460 age=43423/43564/43655 pid=1 cpus=4,11,13

In scsi_alloc_sdev we do scsi_alloc_queue but if slave_alloc
fails we don't free it with scsi_free_queue.

The patch below fixes the issue:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
   135     72  53%    2.30K      5       27       320K kmalloc-2048

# cat /sys/kernel/slab/kmalloc-2048/alloc_calls
3 .cfq_init_queue+0xec/0x460 age=3811/3876/3925 pid=1 cpus=4,11,13

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44e8ca3..72273a0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -322,6 +322,7 @@ out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_dev);
+	scsi_free_queue(sdev->request_queue);
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
