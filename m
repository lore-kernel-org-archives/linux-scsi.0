From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] fix for scsi_unjam_host: Miscount of number of failed commands
Date: Mon, 1 Nov 2004 16:26:12 -0500
Message-ID: <04Nov1.162549est.333220@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:51984 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S320879AbUKAVfC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 16:35:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

This is a resend of http://marc.theaimsgroup.com/?l=linux-scsi&m=108438814301446&w=2

This patch fixes a panic "scsi_unjam_host: Miscount of number of failed
commands".  This panic happens only under very specific circumstances:

1) A command fails with check condition
2) The low-level driver doesn't auto-retrieve the sense data
3) The sense key is "not ready" and ASC/ASCQ indicate the unit is becoming
ready
4) A retry of the command fails in the same way

Please apply.

diff -urN linux-2.4.28-pre3-vanilla/drivers/scsi/scsi_error.c linux-2.4.28-pre3-asp/drivers/scsi/scsi_error.c
--- linux-2.4.28-pre3-vanilla/drivers/scsi/scsi_error.c	Tue Sep 28 15:57:31 2004
+++ linux-2.4.28-pre3-asp/drivers/scsi/scsi_error.c	Tue Sep 28 16:09:06 2004
@@ -1366,6 +1366,7 @@
 
 	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {
 		for (SCpnt = SDpnt->device_queue; SCpnt; SCpnt = SCpnt->next) {
+		      recheck_sense_valid:
 			if (SCpnt->state != SCSI_STATE_FAILED || scsi_sense_valid(SCpnt)) {
 				continue;
 			}
@@ -1402,7 +1403,8 @@
 			SCpnt->state = NEEDS_RETRY;
 			rtn = scsi_eh_retry_command(SCpnt);
 			if (rtn != SUCCESS) {
-				continue;
+				SCpnt->state = SCSI_STATE_FAILED;
+				goto recheck_sense_valid;
 			}
 			/*
 			 * We eventually hand this one back to the top level.


Anthony J. Battersby
Cybernetics

