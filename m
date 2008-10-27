From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 12:18:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271212130.2296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40702 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751092AbYJ0QSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 12:18:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?ISO-8859-1?Q?=D6rjan_Nordlund?= <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1154) fixes a problem in scsi_probe_lun(): The function
doesn't check whether the device has actually sent back any INQUIRY
data!  The patch adds a test to see if the result buffer is still
empty after the command has been executed.

This enables the Thecus N2050 storage device to work.  The firmware on
that device starts up strangely; it sends no data in response to the
initial INQUIRY, and it sends the INQUIRY information in response to
the followup REQUEST SENSE!  But after that it works better, so
retrying the INQUIRY is enough to get it going.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This should get into 2.6.28.


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -602,6 +602,13 @@ static int scsi_probe_lun(struct scsi_de
 				    (sshdr.ascq == 0))
 					continue;
 			}
+		} else {
+			/*
+			 * Additional Length and Vendor fields missing
+			 * probably means nothing was transferred.  Try again.
+			 */
+			if (inq_result[4] == 0 && inq_result[8] == 0)
+				continue;
 		}
 		break;
 	}

