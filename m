From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [janitor] (3/5) ncr53c8x: use kernel.h min/max
Date: Tue, 27 Apr 2004 11:04:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427110406.470e8f32.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59625 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264257AbUD0SOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 14:14:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


From: Michael Veeck <michael.veeck@gmx.net>
Subject: [Kernel-janitors] [PATCH] drivers/scsi/53c* MIN/MAX removal


Patch (against 2.6.6-rc1) removes unnecessary min/max macros and changes
calls to use kernel.h macros instead.


 drivers/scsi/ncr53c8xx.c      |    6 +++---
 drivers/scsi/sym53c8xx_comm.h |    5 +----
 2 files changed, 4 insertions(+), 7 deletions(-)


Index: linux-266-rc2-kj1/drivers/scsi/ncr53c8xx.c
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/ncr53c8xx.c	2004-04-03 19:36:54.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/ncr53c8xx.c	2004-04-22 22:32:08.000000000 -0700
@@ -307,7 +307,7 @@ typedef u32 tagmap_t;
 **    The maximum number of segments a transfer is split into.
 **    We support up to 127 segments for both read and write.
 **    The data scripts are broken into 2 sub-scripts.
-**    80 (MAX_SCATTERL) segments are moved from a sub-script 
+**    80 (MAX_SCATTERL) segments are moved from a sub-script
 **    in on-chip RAM. This makes data transfers shorter than 
 **    80k (assuming 1k fs) as fast as possible.
 */
@@ -4542,7 +4542,7 @@ static int ncr_queue_command (ncb_p np, 
 	/*
 	**	command
 	*/
-	memcpy(cp->cdb_buf, cmd->cmnd, MIN(cmd->cmd_len, sizeof(cp->cdb_buf)));
+	memcpy(cp->cdb_buf, cmd->cmnd, min_t(int, cmd->cmd_len, sizeof(cp->cdb_buf)));
 	cp->phys.cmd.addr		= cpu_to_scr(CCB_PHYS (cp, cdb_buf[0]));
 	cp->phys.cmd.size		= cpu_to_scr(cmd->cmd_len);
 
@@ -5172,7 +5172,7 @@ void ncr_complete (ncb_p np, ccb_p cp)
 		**	Copy back sense data to caller's buffer.
 		*/
 		memcpy(cmd->sense_buffer, cp->sense_buf,
-		       MIN(sizeof(cmd->sense_buffer), sizeof(cp->sense_buf)));
+		       min(sizeof(cmd->sense_buffer), sizeof(cp->sense_buf)));
 
 		if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
 			u_char * p = (u_char*) & cmd->sense_buffer;
Index: linux-266-rc2-kj1/drivers/scsi/sym53c8xx_comm.h
===================================================================
--- linux-266-rc2-kj1.orig/drivers/scsi/sym53c8xx_comm.h	2004-04-03 19:37:23.000000000 -0800
+++ linux-266-rc2-kj1/drivers/scsi/sym53c8xx_comm.h	2004-04-22 22:32:08.000000000 -0700
@@ -59,12 +59,9 @@
 **	sym53c8xx and ncr53c8xx drivers should share.
 **	The sharing will be achieved in a further version  
 **	of the driver bundle. For now, only the ncr53c8xx 
-**	driver includes	this file.
+**	driver includes this file.
 */
 
-#define MIN(a,b)        (((a) < (b)) ? (a) : (b))
-#define MAX(a,b)        (((a) > (b)) ? (a) : (b))
-
 /*==========================================================
 **
 **	Hmmm... What complex some PCI-HOST bridges actually 


--
