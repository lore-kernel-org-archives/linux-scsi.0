From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 21 Apr 2003 11:20:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050942042.2269.3.camel@mulgrave>
References: <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030420143351.C20891@one-eyed-alien.net>
	<20030420143546.D20891@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XUE+kw6z3nH+mrgqEV7J"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:7431 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261605AbTDUQJI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 12:09:08 -0400
In-Reply-To: <20030420143546.D20891@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--=-XUE+kw6z3nH+mrgqEV7J
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2003-04-20 at 16:35, Matthew Dharm wrote:
> On Sun, Apr 20, 2003 at 02:33:51PM -0700, Matthew Dharm wrote:
> > I've tested this, and it works well.  Linus, if you'll take this I've got
> > several more patches -- ones to make usb-storage use this to cut some
> > undesireable commands, and one to fix up the INQUIRY probing in scsi_scan.c
> > to be compatible with the filter code.
> 
> Here is my patch to the SCSI scanning code.  Basically, if the first
> INQUIRY for 36 bytes works, but a later one fails because of the filter, we
> should still accept the device.
> 
> Linus, please apply.  I'll push the usb-storage patches via Greg K-H once
> these are accepted.

Actually, I'm not very keen about the levels of nested inquiry in this. 
How about the attached instead?

James


--=-XUE+kw6z3nH+mrgqEV7J
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/scsi_scan.c 1.77 vs edited =3D=3D=3D=3D=3D
--- 1.77/drivers/scsi/scsi_scan.c	Sun Apr 20 18:21:18 2003
+++ edited/drivers/scsi/scsi_scan.c	Mon Apr 21 11:17:20 2003
@@ -1001,6 +1001,7 @@
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int possible_inq_resp_len;
=20
+ repeat_inquiry:
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
 			" channel %d id %d lun %d\n", sdev->host->host_no,
 			sdev->channel, sdev->id, sdev->lun));
@@ -1067,8 +1068,14 @@
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
 				" %s with code 0x%x\n", sreq->sr_result ?
 				"failed" : "successful", sreq->sr_result));
-		if (sreq->sr_result)
-			return;
+		if (sreq->sr_result) {
+			/* if the longer inquiry has failed, flag the device
+			 * as only accepting 36 byte inquiries and retry the
+			 * 36 byte inquiry */
+			printk(KERN_INFO "scsi scan: %d byte inquiry failed with code %d.  Cons=
ider BLIST_INQUIRY_36 for this device\n", sreq->sr_result);
+			*bflags |=3D BLIST_INQUIRY_36;
+			goto repeat_inquiry;
+		}
=20
 		/*
 		 * The INQUIRY can change, this means the length can change.

--=-XUE+kw6z3nH+mrgqEV7J--

