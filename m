From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: 2.4.26 panic: scsi_unjam_host: Miscount of number of failed commands
Date: Thu, 13 May 2004 12:33:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04May13.123307edt.332203@cyborg.cybernetics.com>
References: <04May12.145146edt.332177@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:16398 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264297AbUEMQdS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 12:33:18 -0400
In-Reply-To: <04May12.145146edt.332177@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patch fixes the problem for me.  Does it look correct?

Anthony J. Battersby
Cybernetics

--- linux-2.4.26-vanilla/drivers/scsi/scsi_error.c	Wed Apr 14 09:05:31 2004
+++ linux-2.4.26-scsi/drivers/scsi/scsi_error.c	Thu May 13 12:28:36 2004
@@ -1363,6 +1363,7 @@
 
 	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {
 		for (SCpnt = SDpnt->device_queue; SCpnt; SCpnt = SCpnt->next) {
+		      recheck_sense_valid:
 			if (SCpnt->state != SCSI_STATE_FAILED || scsi_sense_valid(SCpnt)) {
 				continue;
 			}
@@ -1399,7 +1400,8 @@
 			SCpnt->state = NEEDS_RETRY;
 			rtn = scsi_eh_retry_command(SCpnt);
 			if (rtn != SUCCESS) {
-				continue;
+				SCpnt->state = SCSI_STATE_FAILED;
+				goto recheck_sense_valid;
 			}
 			/*
 			 * We eventually hand this one back to the top level.

