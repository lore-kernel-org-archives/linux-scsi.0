From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape: add MTWEOFI to write filemarks without flushing
 drive buffer
Date: Sun, 29 Aug 2010 18:45:37 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1008291828080.8430@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1226636430-1283096743=:8430"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs10.mail.saunalahti.fi ([195.197.172.105]:47459 "EHLO
	vs10.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0H2Pz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2010 11:55:28 -0400
Received: from saunalahti-vams (localhost [127.0.0.1])
	by vs10.mail.saunalahti.fi (Postfix) with SMTP id 3BF9F1A406A
	for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2010 18:45:54 +0300 (EEST)
Received: from gw03.mail.saunalahti.fi (gw03.mail.saunalahti.fi [195.197.172.111])
	by vs10.mail.saunalahti.fi (Postfix) with ESMTP id 2B2941A406A
	for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2010 18:45:54 +0300 (EEST)
Received: from kai.makisara.local (a91-152-41-146.elisa-laajakaista.fi [91.152.41.146])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gw03.mail.saunalahti.fi (Postfix) with ESMTP id 1F21A216612
	for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2010 18:45:53 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1226636430-1283096743=:8430
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch adds a new MTIOCTOP operation MTWEOFI that writes filemarks wi=
th
immediate bit set. This means that the drive does not flush its buffer an=
d the
next file can be started immediately. This speeds up writing in applicati=
ons
that have to write multiple small files.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---

This new feature was requested by people from CERN. They have found this
useful in a real application and are planning to use it in production.

The patch is meant for inclusion into 2.6.37. It has been tested in 2.6.3=
5 but
applies cleanly to current 2.6.36-rc2-git.

  Documentation/scsi/st.txt |   15 ++++++++++++++-
  drivers/scsi/st.c         |   15 +++++++++------
  include/linux/mtio.h      |    1 +
  3 files changed, 24 insertions(+), 7 deletions(-)

--- linux-2.6.35.4/drivers/scsi/st.c	2010-08-13 23:44:56.000000000 +0300
+++ linux-2.6.35.4.test/drivers/scsi/st.c	2010-08-29 18:40:15.356002099 +=
0300
@@ -9,7 +9,7 @@
     Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedins=
ky,
     Michael Schaefer, J"org Weule, and Eric Youngdale.

-   Copyright 1992 - 2008 Kai Makisara
+   Copyright 1992 - 2010 Kai Makisara
     email Kai.Makisara@kolumbus.fi

     Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
     Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devf=
s support
   */

-static const char *verstr =3D "20081215";
+static const char *verstr =3D "20100829";

  #include <linux/module.h>

@@ -2696,18 +2696,21 @@ static int st_int_ioctl(struct scsi_tape
  		}
  		break;
  	case MTWEOF:
+	case MTWEOFI:
  	case MTWSM:
  		if (STp->write_prot)
  			return (-EACCES);
  		cmd[0] =3D WRITE_FILEMARKS;
  		if (cmd_in =3D=3D MTWSM)
  			cmd[1] =3D 2;
+		if (cmd_in =3D=3D MTWEOFI)
+			cmd[1] |=3D 1;
  		cmd[2] =3D (arg >> 16);
  		cmd[3] =3D (arg >> 8);
  		cmd[4] =3D arg;
  		timeout =3D STp->device->request_queue->rq_timeout;
                  DEBC(
-                     if (cmd_in =3D=3D MTWEOF)
+		     if (cmd_in !=3D MTWSM)
                                 printk(ST_DEB_MSG "%s: Writing %d filema=
rks.\n", name,
  				 cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
                       else
@@ -2883,8 +2886,8 @@ static int st_int_ioctl(struct scsi_tape
  		else if (chg_eof)
  			STps->eof =3D ST_NOEOF;

-		if (cmd_in =3D=3D MTWEOF)
-			STps->rw =3D ST_IDLE;
+		if (cmd_in =3D=3D MTWEOF || cmd_in =3D=3D MTWEOFI)
+			STps->rw =3D ST_IDLE;  /* prevent automatic WEOF at close */
  	} else { /* SCSI command was not completely successful. Don't return
                      from this block without releasing the SCSI command =
block! */
  		struct st_cmdstatus *cmdstatp =3D &STp->buffer->cmdstat;
@@ -2901,7 +2904,7 @@ static int st_int_ioctl(struct scsi_tape
  		else
  			undone =3D 0;

-		if (cmd_in =3D=3D MTWEOF &&
+		if ((cmd_in =3D=3D MTWEOF || cmd_in =3D=3D MTWEOFI) &&
  		    cmdstatp->have_sense &&
  		    (cmdstatp->flags & SENSE_EOM)) {
  			if (cmdstatp->sense_hdr.sense_key =3D=3D NO_SENSE ||
--- linux-2.6.35.4/include/linux/mtio.h	2010-08-13 23:44:56.000000000 +03=
00
+++ linux-2.6.35.4.test/include/linux/mtio.h	2010-08-28 19:52:38.90266143=
4 +0300
@@ -63,6 +63,7 @@ struct	mtop {
  #define MTCOMPRESSION 32/* control compression with SCSI mode page 15 *=
/
  #define MTSETPART 33	/* Change the active tape partition */
  #define MTMKPART  34	/* Format the tape with one or two partitions */
+#define MTWEOFI	35	/* write an end-of-file record (mark) in immediate mo=
de */

  /* structure for MTIOCGET - mag tape get status command */

--- linux-2.6.35.4/Documentation/scsi/st.txt	2010-08-13 23:44:56.00000000=
0 +0300
+++ linux-2.6.35.4.test/Documentation/scsi/st.txt	2010-08-29 18:25:47.308=
002078 +0300
@@ -2,7 +2,7 @@ This file contains brief information abo
  The driver is currently maintained by Kai M=C3=A4kisara (email
  Kai.Makisara@kolumbus.fi)

-Last modified: Sun Feb 24 21:59:07 2008 by kai.makisara
+Last modified: Sun Aug 29 18:25:47 2010 by kai.makisara


  BASICS
@@ -85,6 +85,17 @@ writing and the last operation has been
  optionally written. In both cases end of data is signified by
  returning zero bytes for two consecutive reads.

+Writing filemarks without the immediate bit set in the SCSI command bloc=
k acts
+as a synchronization point, i.e., all remaining data form the drive buff=
ers is
+written to tape before the command returns. This makes sure that write e=
rrors
+are caught at that point, but this takes time. In some applications, sev=
eral
+consecutive files must be written fast. The MTWEOFI operation can be use=
d to
+write the filemarks without flushing the drive buffer. Writing filemark =
at
+close() is always flushing the drive buffers. However, if the previous
+operation is MTWEOFI, close() does not write a filemark. This can be use=
d if
+the program wants to close/open the tape device between files and wants =
to
+skip waiting.
+
  If rewind, offline, bsf, or seek is done and previous tape operation wa=
s
  write, a filemark is written before moving tape.

@@ -301,6 +312,8 @@ MTBSR   Space backward over count record
  MTFSS   Space forward over count setmarks.
  MTBSS   Space backward over count setmarks.
  MTWEOF  Write count filemarks.
+MTWEOFI	Write count filemarks with immediate bit set (i.e., does not
+	wait until data is on tape)
  MTWSM   Write count setmarks.
  MTREW   Rewind tape.
  MTOFFL  Set device off line (often rewind plus eject).
---1463811327-1226636430-1283096743=:8430--
