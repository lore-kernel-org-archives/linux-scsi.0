From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 13:06:03 +0900
Message-ID: <11379891632150-git-send-email-htejun@gmail.com>
References: <11379891632102-git-send-email-htejun@gmail.com>
Reply-To: Tejun Heo <htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.207]:34175 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751400AbWAWEGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 23:06:12 -0500
Received: by xproxy.gmail.com with SMTP id i30so583235wxd
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jan 2006 20:06:11 -0800 (PST)
In-Reply-To: <11379891632102-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: taejun@hotmail.com
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Export two SCSI EH command handling functions.  To be used by libata EH.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

James, this patch is a part of libata-EH related updates.  After the
update, libata EH uses functions exported from this patch to retry or
complete failed commands.

 drivers/scsi/scsi_error.c |    7 ++++---
 include/scsi/scsi_eh.h    |    3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

296dd6345057f576a875e6a140f0fd11e2b1d54f
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a2333d2..6bac3d2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -584,8 +584,7 @@ static int scsi_request_sense(struct scs
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  **/
-static void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
-			       struct list_head *done_q)
+void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
 	scmd->eh_eflags = 0;
@@ -597,6 +596,7 @@ static void scsi_eh_finish_cmd(struct sc
 	scsi_setup_cmd_retry(scmd);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
+EXPORT_SYMBOL(scsi_eh_finish_cmd);
 
 /**
  * scsi_eh_get_sense - Get device sense data.
@@ -1425,7 +1425,7 @@ static void scsi_eh_ready_devs(struct Sc
  * @done_q:	list_head of processed commands.
  *
  **/
-static void scsi_eh_flush_done_q(struct list_head *done_q)
+void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
@@ -1454,6 +1454,7 @@ static void scsi_eh_flush_done_q(struct 
 		}
 	}
 }
+EXPORT_SYMBOL(scsi_eh_flush_done_q);
 
 /**
  * scsi_unjam_host - Attempt to fix a host which has a cmd that failed.
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index fabd879..d160880 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -35,6 +35,9 @@ static inline int scsi_sense_valid(struc
 }
 
 
+extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
+			       struct list_head *done_q);
+extern void scsi_eh_flush_done_q(struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
-- 
1.0.8


