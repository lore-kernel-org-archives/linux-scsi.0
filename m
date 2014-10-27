From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/2] scsi: TUR path is down after adapter gets reset in multipath configuration(scsi_error.c)
Date: Mon, 27 Oct 2014 13:01:48 -0500
Message-ID: <20141027180346.868651777@linux.vnet.ibm.com>
References: <20141027180147.030955587@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58162 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752280AbaJ0SHZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 14:07:25 -0400
Content-Disposition: inline; filename=allow_restart1
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

After an ipr adapter gets reset, all disk array devices require a start
unit command to be issued to them before they will accept commands. So,
with the SCSI EH change, we now end up in a scenario with dual ipr
adapters where the TUR getting issued from the health checker returns
with a Not Ready response and since SCSI EH no longer triggers the Start
Unit in this scenario, the path never recovers.

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
