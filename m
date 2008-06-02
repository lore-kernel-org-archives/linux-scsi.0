From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 5/6] scsi: sr avoids useless buffer allocation
Date: Mon,  2 Jun 2008 15:57:31 +0900
Message-ID: <1212389852-1277-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

blk_rq_map_kern can handle the stack buffers correctly (avoid DMA
from/to the stack buffers by using the bounce buffer) so we don't need
to complicate the code by allocating just 8 bytes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sr.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..c53701e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -670,24 +670,20 @@ fail:
 static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
-	unsigned char *buffer;
+	unsigned char buffer[8];
 	int the_result, retries = 3;
 	int sector_size;
 	struct request_queue *queue;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
-	if (!buffer)
-		goto Enomem;
-
 	do {
 		cmd[0] = READ_CAPACITY;
 		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, 8, NULL, SR_TIMEOUT,
-					      MAX_RETRIES);
+					      buffer, sizeof(buffer), NULL,
+					      SR_TIMEOUT, MAX_RETRIES);
 
 		retries--;
 
@@ -742,14 +738,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 
 	queue = cd->device->request_queue;
 	blk_queue_hardsect_size(queue, sector_size);
-out:
-	kfree(buffer);
-	return;
 
-Enomem:
-	cd->capacity = 0x1fffff;
-	cd->device->sector_size = 2048;	/* A guess, just in case */
-	goto out;
+	return;
 }
 
 static void get_capabilities(struct scsi_cd *cd)
-- 
1.5.4.2

