From: Doug Ledford <dledford@redhat.com>
Subject: [Patch] SCSI: Fix BUSY status handling in new_eh done routine
Date: Wed, 29 Oct 2003 13:05:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067450714.3112.366.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ytduxqejZoYQfGej2I46"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56076 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261270AbTJ2SGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 13:06:18 -0500
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>


--=-ytduxqejZoYQfGej2I46
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The handling of BUSY status messages is not the same between old and new
eh done functions.  The old eh code does it right.  This updates the new
eh code so that it does the same thing.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


--=-ytduxqejZoYQfGej2I46
Content-Disposition: attachment; filename=busy.patch
Content-Type: text/x-patch; name=busy.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Wed Oct 29 12:37:56 2003
+++ b/drivers/scsi/scsi_error.c	Wed Oct 29 12:37:56 2003
@@ -1044,6 +1044,7 @@
 	 */
 	switch (status_byte(SCpnt->result)) {
 	case QUEUE_FULL:
+	case BUSY:
 		/*
 		 * The case of trying to send too many commands to a tagged queueing
 		 * device.
@@ -1065,8 +1066,6 @@
 		 * Who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
-	case BUSY:
-		goto maybe_retry;
 
 	case RESERVATION_CONFLICT:
 		printk("scsi%d (%d,%d,%d) : RESERVATION CONFLICT\n", 

--=-ytduxqejZoYQfGej2I46--

