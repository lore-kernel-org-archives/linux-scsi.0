From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/16] lpfc 8.3.35: Fixed messages for misconfigured port
 errors
Date: Sat, 29 Sep 2012 11:31:41 -0400
Message-ID: <1348932701.23909.30.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35024 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2I2PhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:37:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed messages for misconfigured port errors to be consistent for
 all OS platforms (108240)


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:40.048153996 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:44.140154085 -0400
@@ -3783,14 +3783,18 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba
 	case LPFC_SLI_EVENT_STATUS_VALID:
 		return; /* no message if the sfp is okay */
 	case LPFC_SLI_EVENT_STATUS_NOT_PRESENT:
-		sprintf(message, "Not installed");
+		sprintf(message, "Optics faulted/incorrectly installed/not " \
+				"installed - Reseat optics, if issue not "
+				"resolved, replace.");
 		break;
 	case LPFC_SLI_EVENT_STATUS_WRONG_TYPE:
 		sprintf(message,
-			"Optics of two types installed");
+			"Optics of two types installed - Remove one optic or " \
+			"install matching pair of optics.");
 		break;
 	case LPFC_SLI_EVENT_STATUS_UNSUPPORTED:
-		sprintf(message, "Incompatible optics");
+		sprintf(message, "Incompatible optics - Replace with " \
+				"compatible optics for card to function.");
 		break;
 	default:
 		/* firmware is reporting a status we don't know about */



