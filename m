From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/5]  qla2xxx: TCQ fixes
Date: Mon, 12 Jul 2004 07:05:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712140558.GA6961@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:408 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263467AbUGLVR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:17:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1867 04/07/12 09:38:28 andrew.vasquez@apc.qlogic.com +2 -0
  Correct usage of tag-command-queueing methods:
  
  o Properly call scsi_activate_tcq() rather than
    scsi_adjust_queue_depth().
  o Properly retrieve tag message from command via
    scsi_populate_tag_msg().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_iocb.c |   16 +++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-07-12 09:54:49 -07:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-07-12 09:54:49 -07:00
@@ -22,6 +22,8 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 
+#include <scsi/scsi_tcq.h>
+
 static inline uint16_t qla2x00_get_cmd_direction(struct scsi_cmnd *cmd);
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
 static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
@@ -337,6 +339,7 @@
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	device_reg_t	*reg;
+	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -415,14 +418,17 @@
 	cmd_pkt->lun = cpu_to_le16(fclun->lun);
 
 	/* Update tagged queuing modifier */
-	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
-	if (cmd->device->tagged_supported) {
-		switch (cmd->tag) {
-		case HEAD_OF_QUEUE_TAG:
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case MSG_SIMPLE_TAG:
+			cmd_pkt->control_flags =
+			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
+			break;
+		case MSG_HEAD_TAG:
 			cmd_pkt->control_flags =
 			    __constant_cpu_to_le16(CF_HEAD_TAG);
 			break;
-		case ORDERED_QUEUE_TAG:
+		case MSG_ORDERED_TAG:
 			cmd_pkt->control_flags =
 			    __constant_cpu_to_le16(CF_ORDERED_TAG);
 			break;
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:54:49 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:54:49 -07:00
@@ -1784,7 +1784,7 @@
 
 		ql2xmaxqdepth = queue_depth;
 
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+		scsi_activate_tcq(sdev, queue_depth);
 
 		qla_printk(KERN_INFO, ha,
 		    "scsi(%d:%d:%d:%d): Enabled tagged queuing, queue "
