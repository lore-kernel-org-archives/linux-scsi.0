From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 04/10] qla2xxx: Reset reserved field in firmware options to 0.
Date: Fri, 23 Dec 2016 18:06:08 -0800
Message-ID: <1482545174-811-5-git-send-email-himanshu.madhani@cavium.com>
References: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

During NVRAM initialization in target mode, reset reserved
fields in firmware options to Zero (BIT 15)

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b9c559c..369d62f2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6539,6 +6539,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 		/* Disable Full Login after LIP */
 		nv->host_p &= cpu_to_le32(~BIT_10);
+
+		/*
+		 * clear BIT 15 explicitly as we have seen at least
+		 * a couple of instances where this was set and this
+		 * was causing the firmware to not be initialized.
+		 */
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_15);
 		/* Enable target PRLI control */
 		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
 	} else {
@@ -6623,11 +6630,17 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		/* Disable ini mode, if requested */
 		if (!qla_ini_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
-
 		/* Disable Full Login after LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_9);
+		/*
+		 * clear BIT 15 explicitly as we have seen at
+		 * least a couple of instances where this was set
+		 * and this was causing the firmware to not be
+		 * initialized.
+		 */
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_15);
 		if (ql2xtgt_tape_enable)
 			/* Enable FC tape support */
 			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
-- 
1.8.3.1
