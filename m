From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] SCSI Tape: Move buffer pointer back when data could not
 be written.
Date: Fri, 11 Jul 2008 15:05:25 +0300 (EEST)
Message-ID: <alpine.LNX.1.10.0807111503540.5811@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-774952337-1215777927=:5811"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56474 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYGKMQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 08:16:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-774952337-1215777927=:5811
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Move buffer pointer back when data could not be written. Bug found by Mik=
e Christie.

Signed-off-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
---
The patch is for 2.6.27 (against 2.6.26-rc9).

 drivers/scsi/st.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6e5a5bb..ccaf1ac 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs=
 support
  */
=20
-static const char *verstr =3D "20080224";
+static const char *verstr =3D "20080504";
=20
 #include <linux/module.h>
=20
@@ -1663,6 +1663,7 @@ st_write(struct file *filp, const char __user *buf,=
 size_t count, loff_t * ppos)
 				if (undone <=3D do_count) {
 					/* Only data from this write is not written */
 					count +=3D undone;
+					b_point -=3D undone;
 					do_count -=3D undone;
 					if (STp->block_size)
 						blks =3D (transfer - undone) / STp->block_size;
--=20
1.5.4.3
--8323584-774952337-1215777927=:5811--
