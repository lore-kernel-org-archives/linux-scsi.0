From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 17/17] sym53c8xx: Remove sym_xpt_async_sent_bdr
Date: Fri,  5 Oct 2007 15:55:14 -0400
Message-ID: <11916141152209-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40310 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

This function just printed a message to the user; move the print to its
only caller, and turn it into an starget_printk.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    8 --------
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    3 ++-
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4c7b8a6..74300dd 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -163,14 +163,6 @@ void sym_xpt_async_bus_reset(struct sym_hcb *np)
 }
 
 /*
- *  Tell the SCSI layer about a BUS DEVICE RESET message sent.
- */
-void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target)
-{
-	printf_notice("%s: TARGET %d has been reset.\n", sym_name(np), target);
-}
-
-/*
  *  Choose the more appropriate CAM status if 
  *  the IO encountered an extended error.
  */
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index e5bd0af..567fbe0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -263,7 +263,6 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb);
 #define sym_print_addr(cmd, arg...) dev_info(&cmd->device->sdev_gendev , ## arg)
 void sym_xpt_async_bus_reset(struct sym_hcb *np);
-void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct Scsi_Host *);
 void sym_dump_registers(struct Scsi_Host *);
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 3cf1209..463f119 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3543,7 +3543,8 @@ static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 		 *  If we sent a BDR, make upper layer aware of that.
  		 */
 		if (np->abrt_msg[0] == M_RESET)
-			sym_xpt_async_sent_bdr(np, target);
+			starget_printk(KERN_NOTICE, starget,
+							"has been reset\n");
 		break;
 	}
 
-- 
1.4.4.2

