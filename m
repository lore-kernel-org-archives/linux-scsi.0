From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/18] scsi_dh_alua: use unaligned access macros
Date: Tue,  1 Dec 2015 10:16:52 +0100
Message-ID: <1448961418-29013-13-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbbLAJRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:11 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use 'get_unaligned_XX' and 'put_unaligned_XX' instead of
open-coding it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 03f8190..d54f42e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
@@ -152,10 +153,7 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
 		rq->cmd[1] = MI_REPORT_TARGET_PGS;
-	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
-	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
-	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
-	rq->cmd[9] = h->bufflen & 0xff;
+	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
 
 	rq->sense = h->sense;
@@ -236,8 +234,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	/* Prepare the data buffer */
 	memset(h->buff, 0, stpg_len);
 	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
-	h->buff[6] = (h->group_id >> 8) & 0xff;
-	h->buff[7] = h->group_id & 0xff;
+	put_unaligned_be16(h->group_id, &h->buff[6]);
 
 	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
 	if (!rq)
@@ -246,10 +243,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_OUT;
 	rq->cmd[1] = MO_SET_TARGET_PGS;
-	rq->cmd[6] = (stpg_len >> 24) & 0xff;
-	rq->cmd[7] = (stpg_len >> 16) & 0xff;
-	rq->cmd[8] = (stpg_len >>  8) & 0xff;
-	rq->cmd[9] = stpg_len & 0xff;
+	put_unaligned_be32(stpg_len, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
 
 	rq->sense = h->sense;
@@ -343,11 +337,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
-			h->rel_port = (d[6] << 8) + d[7];
+			h->rel_port = get_unaligned_be16(&d[6]);
 			break;
 		case 0x5:
 			/* Target port group */
-			h->group_id = (d[6] << 8) + d[7];
+			h->group_id = get_unaligned_be16(&d[6]);
 			break;
 		default:
 			break;
@@ -540,8 +534,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		return SCSI_DH_IO;
 	}
 
-	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
-		(h->buff[2] << 8) + h->buff[3] + 4;
+	len = get_unaligned_be32(&h->buff[0]) + 4;
 
 	if (len > h->bufflen) {
 		/* Resubmit with the correct length */
@@ -576,7 +569,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	     k < len;
 	     k += off, ucp += off) {
 
-		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
+		if (h->group_id == get_unaligned_be16(&ucp[2])) {
 			h->state = ucp[0] & 0x0f;
 			h->pref = ucp[0] >> 7;
 			valid_states = ucp[1];
-- 
1.8.5.6

