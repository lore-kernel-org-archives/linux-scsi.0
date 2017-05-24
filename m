From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/31] scmd_eh_abort_handler(): Add a comment
Date: Tue, 23 May 2017 17:33:55 -0700
Message-ID: <20170524003420.5381-7-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53630 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760495AbdEXAea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 20:34:30 -0400
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

After the patch that introduced this function was posted on the
linux-scsi mailing list an explanation was posted why this patch
is correct. Since that explanation contains important information,
add a summary of it above the code that explanation applies to.
See also http://www.spinics.net/lists/linux-scsi/msg106326.html.

References: e494f6a72839 ("[SCSI] improve eh timeout handler")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ac3196420435..19cafa3efb17 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -116,6 +116,12 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
+ *
+ * Note: this function must be called only for a command that has timed out.
+ * Because the block layer sets REQ_ATOM_COMPLETE before it calls
+ * scsi_times_out(), any .scsi_done() calls from the LLD for commands that
+ * have timed out do not have any effect. Hence it is safe to call
+ * scsi_finish_command() from this function.
  */
 void
 scmd_eh_abort_handler(struct work_struct *work)
-- 
2.12.2
