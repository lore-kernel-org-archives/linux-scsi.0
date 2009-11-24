From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 22/22] zfcp: Remove flag ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP
Date: Tue, 24 Nov 2009 16:54:18 +0100
Message-ID: <20091124160139.237606000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44310 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbZKXQBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:34 -0500
Content-Disposition: inline; filename=722-zfcp-remove-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The flag ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP is never set and hence can
be removed. This is a leftover from the time when zfcp had to decide
whether the target supports a "logical unit reset" or not. Nowadays,
the SCSI midlayer calls the eh_device_reset_handler or the
eh_target_reset_handler and zfcp simply maps this to a "logical unit
reset" or a "target reset".

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    1 -
 drivers/s390/scsi/zfcp_scsi.c |    3 ---
 2 files changed, 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:36:57.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:37:04.000000000 +0100
@@ -111,7 +111,6 @@
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
 #define ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED       0x00000080
 #define ZFCP_STATUS_FSFREQ_TMFUNCFAILED         0x00000200
-#define ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP        0x00000400
 #define ZFCP_STATUS_FSFREQ_DISMISSED            0x00001000
 
 /************************* STRUCTURE DEFINITIONS *****************************/
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:37:01.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:37:04.000000000 +0100
@@ -264,9 +264,6 @@ static int zfcp_task_mgmt_function(struc
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
 		zfcp_dbf_scsi_devreset("fail", tm_flags, unit, scpnt);
 		retval = FAILED;
-	} else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP) {
-		zfcp_dbf_scsi_devreset("nsup", tm_flags, unit, scpnt);
-		retval = FAILED;
 	} else
 		zfcp_dbf_scsi_devreset("okay", tm_flags, unit, scpnt);
 

