From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] zfcp: fix sense_buffer access bug
Date: Sun, 27 Jan 2008 12:41:50 +0900
Message-ID: <20080127124124H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34929 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbYA0DmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 22:42:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: christof.schmitt@de.ibm.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

The commit de25deb18016f66dcdede165d07654559bb332bc changed
scsi_cmnd.sense_buffer from a static array to a dynamically allocated
buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index fe57941..a9a147d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -4224,10 +4224,10 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
 
 		ZFCP_LOG_TRACE("%i bytes sense data provided by FCP\n",
 			       fcp_rsp_iu->fcp_sns_len);
-		memcpy(&scpnt->sense_buffer,
+		memcpy(scpnt->sense_buffer,
 		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE,
-			      (void *) &scpnt->sense_buffer, sns_len);
+			      (void *)scpnt->sense_buffer, sns_len);
 	}
 
 	/* check for overrun */
-- 
1.5.3.4

