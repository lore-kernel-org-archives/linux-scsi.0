From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] st: clear ILI if Medium Error
Date: Mon, 18 Apr 2016 08:47:18 +0300 (EEST)
Message-ID: <alpine.LSU.2.20.1604180843100.1620@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811327-424700388-1460958445=:1620"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:50241 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcDRFzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 01:55:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mlombard@redhat.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-424700388-1460958445=:1620
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Some drives set the ILI flag together with MEDIUM ERROR
sense code. Clear the ILI flag in this case so that the
medium error will be handled. The problem was reported by
Maurizio Lombardi.

Signed-off-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>
---
 drivers/scsi/st.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/st.c	2016-04-17 21:22:15.671897001 +0300
+++ b/drivers/scsi/st.c	2016-04-17 22:25:39.234321293 +0300
@@ -1974,9 +1974,12 @@ static long read_tape(struct scsi_tape *
 					transfer =3D (int)cmdstatp->uremainder64;
 				else
 					transfer =3D 0;
-				if (STp->block_size =3D=3D 0 &&
-				    cmdstatp->sense_hdr.sense_key =3D=3D MEDIUM_ERROR)
-					transfer =3D bytes;
+				if (cmdstatp->sense_hdr.sense_key =3D=3D MEDIUM_ERROR) {
+					if (STp->block_size =3D=3D 0)
+						transfer =3D bytes;
+					/* Some drives set ILI with MEDIUM ERROR */
+					cmdstatp->flags &=3D ~SENSE_ILI;
+				}
=20
 				if (cmdstatp->flags & SENSE_ILI) {	/* ILI */
 					if (STp->block_size =3D=3D 0 &&
---1463811327-424700388-1460958445=:1620--
