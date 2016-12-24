From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 10/10] qla2xxx: Disable Out-of-order processing by default in Firmware
Date: Fri, 23 Dec 2016 18:06:14 -0800
Message-ID: <1482545174-811-11-git-send-email-himanshu.madhani@cavium.com>
References: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Out of order(OOO) processing requires initiator, switch
and target to support OOO. In today¹s environment, none
of the switches support OOO. OOO requires extra buffer
space which affect performance. By turning ON this feature
in QLogic's FW, it delays error recovery because droped
frame is treated as out of order frame. We¹re turning OFF
this option of speed up error recovery.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5e4248f..9c6cb75 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6578,9 +6578,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		return;
 	}
 
-	/* out-of-order frames reassembly */
-	nv->firmware_options_3 |= BIT_6|BIT_9;
-
 	if (ha->tgt.enable_class_2) {
 		if (vha->flags.init_done)
 			fc_host_supported_classes(vha->host) =
@@ -6682,9 +6679,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		return;
 	}
 
-	/* out-of-order frames reassembly */
-	nv->firmware_options_3 |= BIT_6|BIT_9;
-
 	if (ha->tgt.enable_class_2) {
 		if (vha->flags.init_done)
 			fc_host_supported_classes(vha->host) =
-- 
1.8.3.1
