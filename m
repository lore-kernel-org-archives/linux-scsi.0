From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 23 Jun 2008 11:04:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806231054540.2556-100000@iolanthe.rowland.org>
References: <1213999774.3443.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48071 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754889AbYFWPEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 11:04:52 -0400
In-Reply-To: <1213999774.3443.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>, Peter Teoh <htmldeveloper@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Jun 2008, James Bottomley wrote:

> Yes, thanks.  It's a bit nasty from a security point of view, since the
> leaking data apparently belonged to a different command.  Wouldn't a
> better fix (and a more secure one) be to clear from the end of the valid
> data to the end of the buffer?

Here's the promised patch.  Maciej and Peter, please try it out.

Alan Stern


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

