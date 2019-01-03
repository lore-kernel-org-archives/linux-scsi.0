From: Randall Huang <ihhuang@abmail.org>
Subject: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Thu,  3 Jan 2019 17:19:35 +0800
Message-ID: <20190103091935.380-1-huangrandall@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: huangrandall@google.com
List-Id: linux-scsi@vger.kernel.org

In SPC-3, WRITE(10)/(16) support grouping function.
Let's associate bio write hint with group number for
enabling StreamID or Turbo Write feature.

Bug: 120900381
Change-Id: I565c8e0c1d10e17a23e73f2a02c1adbd198b04b3
Signed-off-by: Randall Huang <huangrandall@google.com>
---
 drivers/scsi/sd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b49cb67617e..831c0c81ffb9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1201,7 +1201,11 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		SCpnt->cmnd[11] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[12] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
-		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
+		if (rq_data_dir(rq) == WRITE) {
+			SCpnt->cmnd[14] = rq->bio->bi_write_hint & 0x3f;
+		} else
+			SCpnt->cmnd[14] = 0;
+		SCpnt->cmnd[15] = 0;
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
 		   scsi_device_protection(SCpnt->device) ||
 		   SCpnt->device->use_10_for_rw) {
@@ -1211,9 +1215,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
 		SCpnt->cmnd[5] = (unsigned char) block & 0xff;
-		SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
+		if (rq_data_dir(rq) == WRITE) {
+			SCpnt->cmnd[6] = rq->bio->bi_write_hint & 0x1f;
+		} else
+			SCpnt->cmnd[6] = 0;
 		SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
+		SCpnt->cmnd[9] = 0;
 	} else {
 		if (unlikely(rq->cmd_flags & REQ_FUA)) {
 			/*
-- 
2.20.1.415.g653613c723-goog
