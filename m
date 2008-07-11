From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] SCSI Tape: Remove bogus memset
Date: Fri, 11 Jul 2008 15:06:40 +0300 (EEST)
Message-ID: <alpine.LNX.1.10.0807111505410.5811@kai.makisara.local>
References: <alpine.LNX.1.10.0807111503540.5811@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-39659870-1215778003=:5811"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39000 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYGKMQy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 08:16:54 -0400
In-Reply-To: <alpine.LNX.1.10.0807111503540.5811@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-39659870-1215778003=:5811
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Mike Christie noticed a bogus memset. It can be removed as dead code sinc=
e the
number of bytes in the driver buffer in fixed block mode is always a mult=
iple
of the tape block size.

Signed-off-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
---
The patch is for 2.6.27 (against 2.6.26-rc9).

 drivers/scsi/st.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ccaf1ac..1986ebc 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -630,7 +630,7 @@ static int cross_eof(struct scsi_tape * STp, int forw=
ard)
 /* Flush the write buffer (never need to write if variable blocksize). *=
/
 static int st_flush_write_buffer(struct scsi_tape * STp)
 {
-	int offset, transfer, blks;
+	int transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
@@ -643,14 +643,10 @@ static int st_flush_write_buffer(struct scsi_tape *=
 STp)
 	result =3D 0;
 	if (STp->dirty =3D=3D 1) {
=20
-		offset =3D (STp->buffer)->buffer_bytes;
-		transfer =3D ((offset + STp->block_size - 1) /
-			    STp->block_size) * STp->block_size;
+		transfer =3D STp->buffer->buffer_bytes;
                 DEBC(printk(ST_DEB_MSG "%s: Flushing %d bytes.\n",
                                tape_name(STp), transfer));
=20
-		memset((STp->buffer)->b_data + offset, 0, transfer - offset);
-
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] =3D WRITE_6;
 		cmd[1] =3D 1;
--=20
1.5.4.3

--8323584-39659870-1215778003=:5811--
