From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 4/6] scsi_error: fix invalid setting of host byte
Date: Wed,  4 Jun 2014 13:34:57 +0200
Message-ID: <1401881699-1456-5-git-send-email-pbonzini@redhat.com>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com, Ulrich Obergfell <uobergfe@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
already found that the command has completed in the device, causing
the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
this happens, ORing DID_TIME_OUT into the host byte will corrupt
the result field and initiate an unwanted command retry.

Fix this by using set_host_byte instead, following the model of
commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.

Cc: stable@vger.kernel.org
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
[Fix all instances according to review comments. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: fix all occurrences [Bart] except one
	v2->v3: really fix all occurrences [Bart]

 drivers/scsi/scsi_error.c | 6 +++---
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7aa7879..8e7a0f8d4f52 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
@@ -167,7 +167,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 			scmd_printk(KERN_WARNING, scmd,
 				    "scmd %p terminate "
 				    "aborted command\n", scmd));
-		scmd->result |= DID_TIME_OUT << 16;
+		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
 }
@@ -291,7 +291,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		if (scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
-	scmd->result |= DID_TIME_OUT << 16;
+	set_host_byte(scmd, DID_TIME_OUT);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
@@ -1776,7 +1776,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		break;
 	case DID_ABORT:
 		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			return SUCCESS;
 		}
 	case DID_NO_CONNECT:
-- 
1.8.3.1
