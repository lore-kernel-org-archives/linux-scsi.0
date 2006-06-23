From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core: Allow QUIESCE -> CANCEL sdev transition
Date: Fri, 23 Jun 2006 14:25:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0606231422030.6478-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:32264 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751891AbWFWSZf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 14:25:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

We have to be able to remove SCSI devices even when they are suspended, so 
QUIESCE -> CANCEL must be a legal state transition.  This patch (as727) 
adds the transition to the state machine.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -2124,6 +2124,7 @@ scsi_device_set_state(struct scsi_device
 		switch (oldstate) {
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
+		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_BLOCK:
 			break;

