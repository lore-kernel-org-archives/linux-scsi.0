From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: 05 Feb 2003 09:59:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044460782.1773.39.camel@mulgrave>
References: <20030204162326.A30755@lst.de>
	<20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
	<20030204091955.A24785@beaverton.ibm.com>
	<1044383605.2014.23.camel@mulgrave> <20030204202935.A325@lst.de>
	<1044399797.3484.15.camel@mulgrave>
	<20030204172505.A28812@beaverton.ibm.com>
	<1044410039.3485.61.camel@mulgrave>
	<20030204211516.A30419@beaverton.ibm.com>
	<1044458540.1807.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-dQRZv/gRDQwSt19CYhCz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA11039
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 07:59:49 -0800
In-Reply-To: <1044458540.1807.19.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-dQRZv/gRDQwSt19CYhCz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The patches to block after prepping the command are attached.

James


--=-dQRZv/gRDQwSt19CYhCz
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D ./scsi_lib.c 1.65 vs edited =3D=3D=3D=3D=3D
--- 1.65/drivers/scsi/scsi_lib.c	Tue Feb  4 14:19:00 2003
+++ edited/./scsi_lib.c	Wed Feb  5 09:45:45 2003
@@ -814,8 +814,6 @@
 		SRpnt =3D (Scsi_Request *) req->special;
 	=09
 		if (SRpnt->sr_magic =3D=3D SCSI_REQ_MAGIC) {
-			if (SDpnt->device_busy >=3D SDpnt->queue_depth)
-				return BLKPREP_DEFER;
 			SCpnt =3D scsi_get_command(SRpnt->sr_device, GFP_ATOMIC);
 			if (!SCpnt)
 				return BLKPREP_DEFER;
@@ -827,8 +825,6 @@
 		 * Now try and find a command block that we can use.
 		 */
 		if (!req->special) {
-			if (SDpnt->device_busy >=3D SDpnt->queue_depth)
-				return BLKPREP_DEFER;
 			SCpnt =3D scsi_get_command(SDpnt, GFP_ATOMIC);
 			if (unlikely(!SCpnt))
 				return BLKPREP_DEFER;
@@ -950,6 +946,9 @@
 		 * lower down.
 		 */
 		req =3D elv_next_request(q);
+
+		if (SDpnt->device_busy >=3D SDpnt->queue_depth)
+			break;
=20
 		if(SHpnt->host_busy =3D=3D 0 && SHpnt->host_blocked) {
 			/* unblock after host_blocked iterates to zero */

--=-dQRZv/gRDQwSt19CYhCz--

