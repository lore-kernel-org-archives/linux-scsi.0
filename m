From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/6] zfcp: Fix evaluation of port handles in abort handler
Date: Thu, 20 Dec 2007 12:30:23 +0100
Message-ID: <20071220113232.594627000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:3588 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbXLTLcf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:35 -0500
Content-Disposition: inline; filename=808-zfcp-handles.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

According to the FSF spec, word 0 (bytes 0-3) has the handle
specified with the abort command and word 1 (bytes 4-7) has the
handle for the command to be aborted. Fix the if statements
that try to compare those.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:16:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:03.000000000 +0100
@@ -1164,8 +1164,8 @@ zfcp_fsf_abort_fcp_command_handler(struc
 {
 	int retval = -EINVAL;
 	struct zfcp_unit *unit;
-	unsigned char status_qual =
-	    new_fsf_req->qtcb->header.fsf_status_qual.word[0];
+	union fsf_status_qual *fsf_stat_qual =
+		&new_fsf_req->qtcb->header.fsf_status_qual;
 
 	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
 		/* do not set ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED */
@@ -1178,7 +1178,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 	switch (new_fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		if (status_qual >> 4 != status_qual % 0xf) {
+		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
 					 "fsf_s_phand_nv0");
 			/*
@@ -1207,8 +1207,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		break;
 
 	case FSF_LUN_HANDLE_NOT_VALID:
-		if (status_qual >> 4 != status_qual % 0xf) {
-			/* 2 */
+		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
 					 "fsf_s_lhand_nv0");
 			/*

-- 
