From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 04 Jun 2003 12:01:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054742495.1674.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6si+mPYZ6zfY+7iceTfv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:54023 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263487AbTFDPsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2003 11:48:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>


--=-6si+mPYZ6zfY+7iceTfv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

It has been pointed out by the USB people that the mid-layer doesn't
obey its own online flag.

The attached patch should fix this.  However, there are a few caveats to
offlining (read that as devices should still be prepared to process
commands).

1. Any special command will still be accepted (that's a command either
via the SCSI_IOCTL_SEND_COMMAND, or an internally generated command).
2. Outstanding already processed commands in the queue (i.e. commands
which have already been through the upper layer drivers but needed
requeuing for some reason like QUEUE_FULL or device busy).

I'm willing to consider changing 2., it just requires more speciallised
logic to distinguish between a command that has been prepared by the
upper level drivers and a command sent via 1.

However, not that LLDs may not assume they will receive no commands just
because scsi_device->online is zero.

James


--=-6si+mPYZ6zfY+7iceTfv
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.92 vs edited =3D=3D=3D=3D=3D
--- 1.92/drivers/scsi/scsi_lib.c	Mon May 26 05:50:43 2003
+++ edited/drivers/scsi/scsi_lib.c	Wed Jun  4 11:43:01 2003
@@ -945,6 +945,18 @@
 			cmd =3D req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 		/*
+		 * Just check to see if the device is online.  If
+		 * it isn't, we refuse to process ordinary commands
+		 * (we will allow specials just in case someone needs
+		 * to send a command to an offline device without bringing
+		 * it back online)
+		 */
+		if(!sdev->online) {
+			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
+			       sdev->host->host_no, sdev->id, sdev->lun);
+			return BLKPREP_KILL;
+		}
+		/*
 		 * Now try and find a command block that we can use.
 		 */
 		if (!req->special) {

--=-6si+mPYZ6zfY+7iceTfv--

