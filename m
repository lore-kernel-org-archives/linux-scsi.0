From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/11] lpfc 8.3.37: Fixed exhausted retry for plogi to
 nameserver.
Date: Thu, 3 Jan 2013 15:43:19 -0500
Message-ID: <1357245799.2628.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:50073 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3ACUtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:49:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed exhausted retry for plogi to nameserver.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-01-02 13:13:02.680087643 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-01-02 13:13:03.820087669 -0500
@@ -3122,6 +3122,13 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 		case IOERR_SEQUENCE_TIMEOUT:
 		case IOERR_INVALID_RPI:
+			if (cmd == ELS_CMD_PLOGI &&
+			    did == NameServer_DID) {
+				/* Continue forever if plogi to */
+				/* the nameserver fails */
+				maxretry = 0;
+				delay = 100;
+			}
 			retry = 1;
 			break;
 		}



