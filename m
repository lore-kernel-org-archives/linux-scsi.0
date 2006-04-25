From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels
	2.6.X
Date: Tue, 25 Apr 2006 16:48:30 -0500
Message-ID: <1146001711.3529.58.camel@mulgrave.il.steeleye.com>
References: <200604241029.14932.gustavo@compunauta.com>
	 <200604241712.26445.gustavo@compunauta.com>
	 <444DBD0D.9010309@s5r6.in-berlin.de>
	 <200604251641.54084.gustavo@compunauta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751324AbWDYVsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 17:48:50 -0400
In-Reply-To: <200604251641.54084.gustavo@compunauta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gustavo Guillermo =?ISO-8859-1?Q?P=E9rez?= <gustavo@compunauta.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Tue, 2006-04-25 at 16:41 -0500, Gustavo Guillermo P=C3=A9rez wrote:
> Yes I have 3 diferent bridges, with 5 diferent DVDRW from pioneer oth=
er Drives=20
> I've tested with this same USB-IDE Bridges works without this problem=
=2E
> I've tried the flag BLACK_XXX for non tagged queue for this drive but=
 with no=20
> results.
>=20
> {"PIONEER", "DVD-RW  DVR-110D", NULL, BLIST_RETRY_HWERROR | BLIST_NOT=
Q}

OK ... My best guess has to be that this device accepted and completed
the command but is still processing it on the medium, hence the return.
Try the attached; I think it makes for these cases.  I could be
persuaded to drop format and reconstruction in progress, because those
can be *very* long operations.

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7b0f9a3..764a8b3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1067,16 +1067,29 @@ void scsi_io_completion(struct scsi_cmnd
 			break;
 		case NOT_READY:
 			/*
-			 * If the device is in the process of becoming ready,
-			 * retry.
+			 * If the device is in the process of becoming
+			 * ready, or has a temporary blockage, retry.
 			 */
-			if (sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x01) {
-				scsi_requeue_command(q, cmd);
-				return;
+			if (sshdr.asc =3D=3D 0x04) {
+				switch (sshdr.ascq) {
+				case 0x01: /* becoming ready */
+				case 0x04: /* format in progress */
+				case 0x05: /* rebuild in progress */
+				case 0x06: /* recalculation in progress */
+				case 0x07: /* operation in progress */
+				case 0x08: /* Long write in progress */
+				case 0x09: /* self test in progress */
+					scsi_requeue_command(q, cmd);
+					return;
+				default:
+					break;
+				}
 			}
-			if (!(req->flags & REQ_QUIET))
+			if (!(req->flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
-					   "Device not ready.\n");
+					   "Device not ready: ");
+				scsi_print_sense_hdr("", &sshdr);
+			}
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
