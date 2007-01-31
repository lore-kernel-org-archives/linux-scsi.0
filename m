From: Mark Lord <liml@rtr.ca>
Subject: [PATCH] RESEND scsi_lib.c: continue after MEDIUM_ERROR
Date: Tue, 30 Jan 2007 20:12:11 -0500
Message-ID: <200701302012.11891.liml@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200701301947.08478.liml@rtr.ca>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

=46ixed for 80-columns, and copying linux-scsi this time.

In ancient kernels, the SCSI disk code used to continue after
encountering a MEDIUM_ERROR. =A0It would "complete" the good
sectors before the error, fail the bad sector/block, and then
continue with the rest of the request.

Kernels since about 2.6.16 or so have been broken in this regard.
They "complete" the good sectors before the error,
and then fail the entire remaining portions of the request.

This is very risky behaviour, as a request is often a merge
of several bios, and just because one application hits a bad sector
is no reason to pretend that (for example) an adjacent directly lookup =
also failed.

This patch fixes the behaviour to be similar to what we had originally.

When a bad sector is encounted, SCSI will now work around it again,
failing *only* the bad sector itself.

Signed-off-by: =A0Mark Lord <mlord@pobox.com>
---
--- old/drivers/scsi/scsi_lib.c	2007-01-30 20:06:15.000000000 -0500
+++ linux/drivers/scsi/scsi_lib.c	2007-01-30 20:06:59.000000000 -0500
@@ -865,6 +865,13 @@
 	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
+		case MEDIUM_ERROR:
+			/* Bad sector. Fail it, and continue on with the rest */
+			if (scsi_end_request(cmd, 0,
+					cmd->device->sector_size, 1) =3D=3D NULL) {
+				cmd->retries =3D 0;	/* go around again.. */
+				return;
+			}
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
 				/* Detected disc change.  Set a bit
