From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape: write filemark before rewind etc. when writing
Date: Tue, 22 Feb 2005 22:10:29 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502222200220.6519@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="2831155969-1840576107-1109103029=:6519"
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:51707 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261190AbVBVUJa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 15:09:30 -0500
Received: from kai.makisara.local ([84.230.129.65])
          by fep02-app.kolumbus.fi with ESMTP
          id <20050222200929.YCRG8756.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2005 22:09:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--2831155969-1840576107-1109103029=:6519
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

The patch at the end of this message modifies the st write semantics in 
the following way: write a filemark before rewind, offline, or seek if the 
previous operation was write.

This semantics is specified on the man pages of some Unices and some 
software (e.g., cpio) seems to assume this. The change makes sure that the 
last file on the tape is properly terminated with a filemark and reading the 
file does not fail at the end.

The patch is against 2.6.11-rc4 + the descriptor based sense data patch I 
sent to linux-scsi on Feb 13.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-rc4-k1/drivers/scsi/st.c	2005-02-13 22:42:48.000000000 +0200
+++ linux-2.6.11-rc4-k2/drivers/scsi/st.c	2005-02-20 22:22:51.000000000 +0200
@@ -2727,6 +2727,8 @@ static int st_int_ioctl(struct scsi_tape
 		else if (chg_eof)
 			STps->eof = ST_NOEOF;
 
+		if (cmd_in == MTWEOF)
+			STps->rw = ST_IDLE;
 	} else { /* SCSI command was not completely successful. Don't return
                     from this block without releasing the SCSI command block! */
 		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
@@ -3235,6 +3237,17 @@ static int st_ioctl(struct inode *inode,
 				retval = i;
 				goto out;
 			}
+			if (STps->rw == ST_WRITING &&
+			    (mtc.mt_op == MTREW || mtc.mt_op == MTOFFL ||
+			     mtc.mt_op == MTSEEK)) {
+				i = st_int_ioctl(STp, MTWEOF, 1);
+				if (i < 0) {
+					retval = i;
+					goto out;
+				}
+				STps->rw = ST_IDLE;
+			     }
+
 		} else {
 			/*
 			 * If there was a bus reset, block further access
--- linux-2.6.11-rc4-k1/Documentation/scsi/st.txt	2004-04-04 15:34:34.000000000 +0300
+++ linux-2.6.11-rc4-k2/Documentation/scsi/st.txt	2005-02-20 22:28:27.000000000 +0200
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai Mäkisara (email
 Kai.Makisara@kolumbus.fi)
 
-Last modified: Wed Feb 25 14:09:08 2004 by makisara
+Last modified: Sun Feb 20 22:28:27 2005 by kai.makisara
 
 
 BASICS
@@ -85,6 +85,9 @@ writing and the last operation has been 
 optionally written. In both cases end of data is signified by
 returning zero bytes for two consecutive reads.
 
+If the rewind, offline, or seek is done and previous tape operation was write,
+a filemark is written before moving tape.
+
 The compile options are defined in the file linux/drivers/scsi/st_options.h.
 
 4. If the open option O_NONBLOCK is used, open succeeds even if the
--2831155969-1840576107-1109103029=:6519--
