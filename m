From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] handle NO_SENSE in sd
Date: Mon, 31 May 2004 13:48:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531114851.GA16060@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24236 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264160AbUEaLsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 07:48:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Original patch from
http://marc.theaimsgroup.com/?l=linux-scsi&m=107428662718579&w=2
reworked to according to James' suggestion to handle NO_SENSE the same
as RECOVERED_ERROR.


--- 1.148/drivers/scsi/sd.c	2004-04-30 11:55:42 +02:00
+++ edited/drivers/scsi/sd.c	2004-05-31 12:53:01 +02:00
@@ -762,11 +762,11 @@
 				good_bytes = 0;
 			break;
 
-		case RECOVERED_ERROR:
+		case RECOVERED_ERROR: /* an error occurred, but it recovered */
+		case NO_SENSE: /* LLDD got sense data */
 			/*
-			 * An error occurred, but it recovered.  Inform the
-			 * user, but make sure that it's not treated as a
-			 * hard error.
+			 * Inform the user, but make sure that it's not treated
+			 * as a hard error.
 			 */
 			print_sense("sd", SCpnt);
 			SCpnt->result = 0;
===== include/linux/ide.h 1.116 vs edited =====
