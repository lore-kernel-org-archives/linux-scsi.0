From: Henne <henne@nachtwindheim.de>
Subject: [PATCH 1/5] a2091: Scsi_Cmnd to struct scsi_cmnd convertion
Date: Tue, 12 Sep 2006 20:26:04 +0200
Message-ID: <4506FBBC.2040300@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server6.greatnet.de ([83.133.96.26]:60140 "EHLO
	server6.greatnet.de") by vger.kernel.org with ESMTP
	id S1030339AbWILS0K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 14:26:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Chenges obsolete typedef'd Scsi_Cmnd into struct scsi_cmnd.
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

diff -ruN linux-2.6/drivers/scsi/a2091.c devel/drivers/scsi/a2091.c
--- linux-2.6/drivers/scsi/a2091.c	2006-08-01 01:31:43.000000000 +0200
+++ devel/drivers/scsi/a2091.c	2006-09-12 19:47:21.000000000 +0200
@@ -40,7 +40,7 @@
     return IRQ_HANDLED;
 }
 
-static int dma_setup (Scsi_Cmnd *cmd, int dir_in)
+static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
     unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
     unsigned long addr = virt_to_bus(cmd->SCp.ptr);
@@ -115,7 +115,7 @@
     return 0;
 }
 
-static void dma_stop (struct Scsi_Host *instance, Scsi_Cmnd *SCpnt, 
+static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		      int status)
 {
     /* disable SCSI interrupts */
@@ -217,7 +217,7 @@
     return num_a2091;
 }
 
-static int a2091_bus_reset(Scsi_Cmnd *cmd)
+static int a2091_bus_reset(struct scsi_cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
 
diff -ruN linux-2.6/drivers/scsi/a2091.h devel/drivers/scsi/a2091.h
--- linux-2.6/drivers/scsi/a2091.h	2006-08-01 01:31:43.000000000 +0200
+++ devel/drivers/scsi/a2091.h	2006-09-12 19:46:36.000000000 +0200
@@ -14,9 +14,9 @@
 int a2091_detect(struct scsi_host_template *);
 int a2091_release(struct Scsi_Host *);
 const char *wd33c93_info(void);
-int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-int wd33c93_abort(Scsi_Cmnd *);
-int wd33c93_reset(Scsi_Cmnd *, unsigned int);
+int wd33c93_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+int wd33c93_abort(struct scsi_cmnd *);
+int wd33c93_reset(struct scsi_cmnd *, unsigned int);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2


