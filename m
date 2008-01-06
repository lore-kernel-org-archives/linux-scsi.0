From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 14/33][SCSI] fd_mcs: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:04:01 +0100 (MET)
Message-ID: <20080106030401.30002.19860.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53921 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYAFDEN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:04:13 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning).


diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 8335b60..5feb9f2 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -184,7 +184,7 @@ struct fd_hostdata {
 	int _bios_major;
 	int _bios_minor;
 	volatile int _in_command;
-	Scsi_Cmnd *_current_SC;
+	struct scsi_cmnd *_current_SC;
 	enum chip_type _chip;
 	int _adapter_mask;
 	int _fifo_count;	/* Number of 512 byte blocks before INTR */
@@ -1089,7 +1089,7 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
 	return 0;
 }
 
-static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int fd_mcs_queue(struct scsi_cmnd *SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1138,7 +1138,7 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 }
 
 #if DEBUG_ABORT || DEBUG_RESET
-static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
+static void fd_mcs_print_info(struct scsi_cmnd *SCpnt)
 {
 	unsigned int imr;
 	unsigned int irr;
@@ -1207,7 +1207,7 @@ static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 }
 #endif
 
-static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
+static int fd_mcs_abort(struct scsi_cmnd *SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1243,7 +1243,8 @@ static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
+static int fd_mcs_bus_reset(struct scsi_cmnd *SCpnt)
+{
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 
