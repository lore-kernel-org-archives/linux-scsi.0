From: Brian King <brking@us.ibm.com>
Subject: [PATCH] p00002_scsi_tcq_qdepth_fix
Date: Tue, 03 Aug 2004 12:50:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410FD06B.3010500@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060702050607030806000703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:11254 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266774AbUHCRui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 13:50:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060702050607030806000703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060702050607030806000703
Content-Type: text/plain;
 name="p00002_scsi_tcq_qdepth_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="p00002_scsi_tcq_qdepth_fix.patch"


Currently, it is possible to call scsi_activate_tcq with a small queue depth,
then later call scsi_adjust_queue_depth with a larger queue depth. This results
in the scsi layer having a larger queue depth than the block layer knows about.
This results in these additional commands being issued as untagged ops rather than
tagged ops. This patch changes scsi_activate_tcq to call blk_queue_init_tags with
the maximum supported number of tags so this cannot occur.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc2-bjking1/drivers/scsi/scsi.c     |    2 +-
 linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/scsi/scsi_tcq.h~scsi_tcq_qdepth_fix include/scsi/scsi_tcq.h
--- linux-2.6.8-rc2/include/scsi/scsi_tcq.h~scsi_tcq_qdepth_fix	2004-08-03 11:06:42.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/include/scsi/scsi_tcq.h	2004-08-03 11:08:00.000000000 -0500
@@ -11,7 +11,7 @@
 #define MSG_ORDERED_TAG	0x22
 
 #define SCSI_NO_TAG	(-1)    /* identify no tag in use */
-
+#define SCSI_MAX_TAGS	256
 
 /**
  * scsi_activate_tcq - turn on tag command queueing
@@ -30,7 +30,7 @@ static inline void scsi_activate_tcq(str
         if (sdev->tagged_supported) {
 		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 		if (!blk_queue_tagged(sdev->request_queue))
-			blk_queue_init_tags(sdev->request_queue, depth, NULL);
+			blk_queue_init_tags(sdev->request_queue, SCSI_MAX_TAGS, NULL);
 		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
         }
diff -puN drivers/scsi/scsi.c~scsi_tcq_qdepth_fix drivers/scsi/scsi.c
--- linux-2.6.8-rc2/drivers/scsi/scsi.c~scsi_tcq_qdepth_fix	2004-08-03 11:07:16.000000000 -0500
+++ linux-2.6.8-rc2-bjking1/drivers/scsi/scsi.c	2004-08-03 11:08:28.000000000 -0500
@@ -902,7 +902,7 @@ void scsi_adjust_queue_depth(struct scsi
 	 * we allocate a struct scsi_command for each of these and keep it
 	 * around forever.  Too deep of a depth just wastes memory.
 	 */
-	if (tags > 256)
+	if (tags > SCSI_MAX_TAGS)
 		return;
 
 	spin_lock_irqsave(&device_request_lock, flags);
_

--------------060702050607030806000703--

