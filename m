From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Mon, 15 Apr 2002 14:40:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204152040.g3FKed982111@aslan.scsiguy.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Mon, 11 Mar 2002 12:55:23 MST."
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

Marcelo,

Looking at the latest version of your tree via bitkeeper, it
seems that the wrong patch has been applied to sd.c.  In its
current state, the disk driver will fail to act upon any sense
data returned by the low level controller.  The following patch
restores correct behavior.

--
Justin

===== sd.c 1.21 vs edited =====
--- 1.21/drivers/scsi/sd.c	Fri Apr  5 09:19:03 2002
+++ edited/sd.c	Mon Apr 15 14:32:51 2002
@@ -621,7 +621,7 @@
 
 	/* An error occurred */
 	if (driver_byte(result) != 0 && 	/* An error occured */
-	    SCpnt->sense_buffer[0] != 0xF0) {	/* Sense data is valid */
+	    SCpnt->sense_buffer[0] == 0xF0) {	/* Sense data is valid */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
 			error_sector = (SCpnt->sense_buffer[3] << 24) |
