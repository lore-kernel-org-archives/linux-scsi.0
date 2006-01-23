From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 23:52:12 +0900
Message-ID: <20060123145212.GA1595@htj.dyndns.org>
References: <11379893762140-git-send-email-htejun@gmail.com> <11379893764141-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11379893764141-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, albertcc@tw.ibm.com, hch@infradead.org, arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org

[PATCH] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()

Export two SCSI EH command handling functions.  To be used by libata EH.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

Respin of the patch with EXPORT_SYMBOL_GPL.

Index: work1/drivers/scsi/scsi_error.c
===================================================================
--- work1.orig/drivers/scsi/scsi_error.c	2006-01-23 23:48:55.000000000 +0900
+++ work1/drivers/scsi/scsi_error.c	2006-01-23 23:49:32.000000000 +0900
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
+EXPORT_SYMBOL_GPL(scsi_eh_finish_cmd);
 
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
+EXPORT_SYMBOL_GPL(scsi_eh_flush_done_q);
 
 /**
  * scsi_unjam_host - Attempt to fix a host which has a cmd that failed.
Index: work1/include/scsi/scsi_eh.h
===================================================================
--- work1.orig/include/scsi/scsi_eh.h	2006-01-23 23:48:55.000000000 +0900
+++ work1/include/scsi/scsi_eh.h	2006-01-23 23:49:02.000000000 +0900
@@ -35,6 +35,9 @@ static inline int scsi_sense_valid(struc
 }
 
 
+extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
+			       struct list_head *done_q);
+extern void scsi_eh_flush_done_q(struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
