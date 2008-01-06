From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 31/33][SCSI] sym53c416: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:28 +0100 (MET)
Message-ID: <20080106030528.30002.71404.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54052 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYAFDFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:40 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 90cee94..689408a 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -225,7 +225,7 @@ static host hosts[MAXHOSTS] = {
 
 static int host_index = 0;
 static char info[120];
-static Scsi_Cmnd *current_command = NULL;
+static struct scsi_cmnd *current_command = NULL;
 static int fastpio = 1;
 
 static int probeaddrs[] = {0x200, 0x220, 0x240, 0};
@@ -748,7 +748,7 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
 	return info;
 }
 
-int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+int sym53c416_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	int base;
 	unsigned long flags = 0;
@@ -775,7 +775,7 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	return 0;
 }
 
-static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
+static int sym53c416_host_reset(struct scsi_cmnd *SCpnt)
 {
 	int base;
 	int scsi_id = -1;	
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
index 77860d0..a6a89fd 100644
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -25,8 +25,8 @@
 static int sym53c416_detect(struct scsi_host_template *);
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
-static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int sym53c416_host_reset(Scsi_Cmnd *);
+static int sym53c416_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int sym53c416_host_reset(struct scsi_cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static void sym53c416_setup(char *str, int *ints);
