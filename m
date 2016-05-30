From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: fix sleep in invalid context
Date: Mon, 30 May 2016 14:19:07 -0400
Message-ID: <1464632347-8621-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59329 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161330AbcE3STP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 14:19:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com

In this post: http://www.spinics.net/lists/linux-scsi/msg97124.html
the author shows some kernel infrastructure complaining about a
sleep in an invalid context. For calls to fetch memory when
processing SCSI commands, reviewers often propose non GFP_ATOMIC
variants; reality dictates otherwise. Fix memory allocation for
response to REPORT LUNS command.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0f9ba41..b85c5dc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3331,13 +3331,12 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 	tlun_cnt = lun_cnt + wlun_cnt;
 
 	rlen = (tlun_cnt * sizeof(struct scsi_lun)) + 8;
-	arr = vmalloc(rlen);
+	arr = kzalloc(rlen, GFP_ATOMIC);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
 		return check_condition_result;
 	}
-	memset(arr, 0, rlen);
 	pr_debug("select_report %d luns = %d wluns = %d no_lun0 %d\n",
 		 select_report, lun_cnt, wlun_cnt, sdebug_no_lun_0);
 
@@ -3355,7 +3354,7 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 	put_unaligned_be32(rlen - 8, &arr[0]);
 
 	res = fill_from_dev_buffer(scp, arr, rlen);
-	vfree(arr);
+	kfree(arr);
 	return res;
 }
 
-- 
2.7.4

