From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scmd_eh_abort_handler(): Add a comment
Date: Mon, 12 Feb 2018 10:38:05 -0800
Message-ID: <20180212183805.23579-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:60902 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbeBLSiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 13:38:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

After the patch that introduced this function was posted on the
linux-scsi mailing list an explanation was posted why this patch
is correct. Since that explanation contains important information,
add a summary of it above the code that explanation applies to.
See also http://www.spinics.net/lists/linux-scsi/msg106326.html.

References: e494f6a72839 ("[SCSI] improved eh timeout handler")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d042915ce895..96f988a7efda 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -117,6 +117,12 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
+ *
+ * Note: this function must be called only for a command that has timed out.
+ * Because the block layer marks a request as complete before it calls
+ * scsi_times_out(), a .scsi_done() call from the LLD for a command that has
+ * timed out do not have any effect. Hence it is safe to call
+ * scsi_finish_command() from this function.
  */
 void
 scmd_eh_abort_handler(struct work_struct *work)
-- 
2.16.1
