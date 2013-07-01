From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi: Set hostbyte status in scsi_check_sense()
Date: Mon,  1 Jul 2013 15:16:24 +0200
Message-ID: <1372684586-41829-3-git-send-email-hare@suse.de>
References: <1372684586-41829-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3GANQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 09:16:34 -0400
In-Reply-To: <1372684586-41829-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We should be modifying the host_byte status in scsi_check_sense()
directly; this saves us to introduce a special return code for
each and every condition.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 21 +++++++--------------
 include/scsi/scsi.h       |  1 -
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 84369f2..e5cb162 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -248,7 +248,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  * @scmd:	Cmd to have sense checked.
  *
  * Return value:
- *	SUCCESS or FAILED or NEEDS_RETRY or TARGET_ERROR
+ *	SUCCESS or FAILED or NEEDS_RETRY or ADD_TO_MLQUEUE
  *
  * Notes:
  *	When a deferred error is detected the current command has
@@ -379,13 +379,15 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	case MISCOMPARE:
 	case BLANK_CHECK:
 	case DATA_PROTECT:
-		return TARGET_ERROR;
+		set_host_byte(scmd, DID_TARGET_FAILURE);
+		return SUCCESS;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			return TARGET_ERROR;
+			set_host_byte(scmd, DID_TARGET_FAILURE);
+			return SUCCESS;
 		}
 		return NEEDS_RETRY;
 
@@ -393,14 +395,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
 		else
-			return TARGET_ERROR;
+			set_host_byte(scmd, DID_TARGET_FAILURE);
 
 	case ILLEGAL_REQUEST:
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
 		    sshdr.asc == 0x26) { /* Parameter value invalid */
-			return TARGET_ERROR;
+			set_host_byte(scmd, DID_TARGET_FAILURE);
 		}
 		return SUCCESS;
 
@@ -863,7 +865,6 @@ retry:
 		case SUCCESS:
 		case NEEDS_RETRY:
 		case FAILED:
-		case TARGET_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
 			rtn = NEEDS_RETRY;
@@ -1690,14 +1691,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
-		else if (rtn == TARGET_ERROR) {
-			/*
-			 * Need to modify host byte to signal a
-			 * permanent target failure
-			 */
-			set_host_byte(scmd, DID_TARGET_FAILURE);
-			rtn = SUCCESS;
-		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..07d4bd916 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -481,7 +481,6 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
 #define FAST_IO_FAIL	0x2009
-#define TARGET_ERROR    0x200A
 
 /*
  * Midlevel queue return values.
-- 
1.7.12.4

