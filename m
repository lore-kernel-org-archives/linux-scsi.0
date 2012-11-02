From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] sd: fix crash when UA received on DIF enabled device
Date: Fri,  2 Nov 2012 09:38:34 -0400
Message-ID: <1351863514-12745-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2KBNig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2012 09:38:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA2DcZi3000705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 2 Nov 2012 09:38:35 -0400
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id qA2DcZmT007508
	for <linux-scsi@vger.kernel.org>; Fri, 2 Nov 2012 09:38:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

sd_prep_fn will allocate a larger CDB for the command via mempool_alloc
for devices using DIF type 2 protection.  This CDB was being freed
in sd_done, which results in a kernel crash if the command is retried
due to a UNIT ATTENTION.  This change moves the code to free the larger
CDB into sd_unprep_fn instead, which is invoked after the request is
complete.

It is no longer necessary to call scsi_print_command separately for
this case as the ->cmnd will no longer be NULL in the normal code path.

Also removed conditional test for DIF type 2 when freeing the larger
CDB because the protection_type could have been changed via sysfs while
the command was executing.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..00a366a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -658,10 +658,17 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
+	struct scsi_cmnd *SCpnt = rq->special;
+
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
 		rq->buffer = NULL;
 	}
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 }
 
 /**
@@ -1525,21 +1532,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
-
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 
-- 
1.7.11.7

