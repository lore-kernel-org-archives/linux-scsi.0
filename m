From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 14:53:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271452540.2296-100000@iolanthe.rowland.org>
References: <1225128573.5146.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751603AbYJ0Sxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 14:53:48 -0400
In-Reply-To: <1225128573.5146.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?ISO-8859-1?Q?=D6rjan?= Nordlund <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1154b) fixes a problem in scsi_probe_lun(): The function
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

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -602,6 +602,14 @@ static int scsi_probe_lun(struct scsi_de
 				    (sshdr.ascq == 0))
 					continue;
 			}
+		} else {
+			/*
+			 * If the first four bytes are all 0 then probably
+			 * nothing was transferred.  Try again.
+			 */
+			if ((inq_result[0] | inq_result[1] |
+					inq_result[2] | inq_result[3]) == 0)
+				continue;
 		}
 		break;
 	}

