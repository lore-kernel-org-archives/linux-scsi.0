From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: erase invalid data returned by device
Date: Tue, 24 Jun 2008 14:03:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
References: <804dabb00806232109k32437d04jeed373b7d38abdb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750713AbYFXSDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2008 14:03:17 -0400
In-Reply-To: <804dabb00806232109k32437d04jeed373b7d38abdb3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1108) fixes a problem that can occur with certain USB
mass-storage devices: They return invalid data together with a residue
indicating that the data should be ignored.  Rather than leave the
invalid data in a transfer buffer, where it can get misinterpreted,
the patch clears the invalid portion of the buffer.

This solves a problem (wrong write-protect setting detected) reported
by Maciej Rutecki and Peter Teoh.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Peter Teoh <htmldeveloper@gmail.com>

---

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sde
 	 */
 	blk_execute_rq(req->q, NULL, req, 1);
 
+	/*
+	 * Some devices (USB mass-storage in particular) may transfer
+	 * garbage data together with a residue indicating that the data
+	 * is invalid.  Prevent the garbage from being misinterpreted
+	 * and prevent security leaks by zeroing out the excess data.
+	 */
+	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
+		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
+
 	ret = req->errors;
  out:
 	blk_put_request(req);

