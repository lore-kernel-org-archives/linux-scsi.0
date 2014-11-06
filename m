From: wenxiong@linux.vnet.ibm.com
Subject: [ V3 PATCH 1/2] scsi: call device handler for failed TUR command
Date: Thu, 06 Nov 2014 15:11:22 -0600
Message-ID: <20141106211336.166586194@linux.vnet.ibm.com>
References: <20141106211121.526781033@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58317 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750963AbaKFVRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 16:17:15 -0500
Content-Disposition: inline; filename=allow_restart1
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Multipath devices using the TUR path checker need to see the sense
code for a failed TUR command in their device handler.  Since commit
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/
drivers/scsi/scsi_error.c?id=14216561e164671ce147458653b1fea06a
we always return success for mid layer issued TUR commands before
calling the device handler, which stopped the TUR path checker from working.

Move the call to the device handler check sense method before the early
return for TUR commands to give the device handler a chance to intercept
them.

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/drivers/scsi/scsi_error.c
===================================================================
--- a/drivers/scsi/scsi_error.c	2014-10-23 12:54:16.000000000 -0500
+++ b/drivers/scsi/scsi_error.c	2014-10-23 12:57:44.642078988 -0500
@@ -459,14 +459,6 @@ static int scsi_check_sense(struct scsi_
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
-		/*
-		 * nasty: for mid-layer issued TURs, we need to return the
-		 * actual sense data without any recovery attempt.  For eh
-		 * issued ones, we need to try to recover and interpret
-		 */
-		return SUCCESS;
-
 	scsi_report_sense(sdev, &sshdr);
 
 	if (scsi_sense_is_deferred(&sshdr))
@@ -482,6 +474,14 @@ static int scsi_check_sense(struct scsi_
 		/* handler does not care. Drop down to default handling */
 	}
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.

-- 
