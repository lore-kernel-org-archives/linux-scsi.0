From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix for memory leak in scsi_prep_fn
Date: 28 Jan 2003 12:32:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043778768.2991.74.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-I3r3FAjVhviFdUtBdGAb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA02212
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 10:32:50 -0800
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>


--=-I3r3FAjVhviFdUtBdGAb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



This should fix the memory leak Russell King spotted if command
initialisation fails in the request prep function.

The patch is against the scsi-combined-2.5 bkbits.net repository.

James


--=-I3r3FAjVhviFdUtBdGAb
Content-Description: 
Content-Disposition: inline; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.63 vs edited =3D=3D=3D=3D=3D
--- 1.63/drivers/scsi/scsi_lib.c	Tue Jan 28 10:19:35 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Jan 28 12:29:45 2003
@@ -796,6 +796,8 @@
 	struct Scsi_Device_Template *STpnt;
 	Scsi_Cmnd *SCpnt;
 	Scsi_Device *SDpnt;
+	int ret;
+
=20
 	SDpnt =3D (Scsi_Device *) q->queuedata;
 	BUG_ON(!SDpnt);
@@ -862,8 +864,6 @@
 	 */
=20
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
-		int ret;
-
 		/*
 		 * This will do a couple of things:
 		 *  1) Fill in the actual SCSI command.
@@ -884,19 +884,27 @@
 		 * required).
 		 */
 		if ((ret =3D scsi_init_io(SCpnt)))
-			return ret;
+			goto fail_release_cmd;
 	=09
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
 		if (!STpnt->init_command(SCpnt)) {
-			scsi_release_buffers(SCpnt);
-			return BLKPREP_KILL;
+			ret =3D BLKPREP_KILL;
+			goto fail_release_buffers;
 		}
 	}
 	/* The request is now prepped, no need to come back here */
 	req->flags |=3D REQ_DONTPREP;
 	return BLKPREP_OK;
+
+ fail_release_buffers:
+	scsi_release_buffers(SCpnt);
+
+ fail_release_cmd:
+	scsi_put_command(SCpnt);
+
+	return ret;
 }
=20
 /*

--=-I3r3FAjVhviFdUtBdGAb--

