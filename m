From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape fixes: sense descriptor init, bsf->weof, blkno,
 debugging
Date: Mon, 7 Mar 2005 22:12:59 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0503072211060.6862@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="2831155969-182967974-1110226379=:6862"
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:17065 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261748AbVCGULo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 15:11:44 -0500
Received: from kai.makisara.local ([193.229.226.111])
          by fep02-app.kolumbus.fi with ESMTP
          id <20050307201142.XOOJ8756.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2005 22:11:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--2831155969-182967974-1110226379=:6862
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

The patch at the end of this message applies to 2.6.11 + st descriptor sense
patch + st auto eof patch (i.e., st patches currently in scsi-misc-2.6). The
patch fixes the following problems:

- the sense descriptor is cleared before filling
- BSF and BSFM are added to the commands causing automatic writing of filemark
  if the previous operation was write (tar expects this)
- the block number is set to unknown (-1) if spacing forward ends at BLANK CHECK
- debugging printout of spacing counts fixed to work also with 64-bit systems

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-k1/drivers/scsi/st.c	2005-03-07 19:38:45.000000000 +0200
+++ linux-2.6.11-k2/drivers/scsi/st.c	2005-03-07 21:59:24.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050213";
+static char *verstr = "20050307";
 
 #include <linux/module.h>
 
@@ -268,6 +268,7 @@ static void st_analyze_sense(struct scsi
 	const u8 *ucp;
 	const u8 *sense = SRpnt->sr_sense_buffer;
 
+	memset(s, 0, sizeof(struct st_cmdstatus));
 	s->have_sense = scsi_request_normalize_sense(SRpnt, &s->sense_hdr);
 
 	if (s->have_sense) {
@@ -287,8 +288,6 @@ static void st_analyze_sense(struct scsi
 			ucp = scsi_sense_desc_find(sense, SCSI_SENSE_BUFFERSIZE, 4);
 			s->flags = ucp ? (ucp[3] & 0xe0) : 0;
 			break;
-		default:
-			s->flags = 0;
 		}
 	}
 }
@@ -306,7 +305,7 @@ static int st_chk_result(struct scsi_tap
 	if (!result)
 		return 0;
 
-		cmdstatp = &STp->buffer->cmdstat;
+	cmdstatp = &STp->buffer->cmdstat;
 	st_analyze_sense(STp->buffer->last_SRpnt, cmdstatp);
 
 	if (cmdstatp->have_sense)
@@ -2407,6 +2406,22 @@ static int do_load_unload(struct scsi_ta
 	return retval;
 }
 

+#if DEBUG
+#define ST_DEB_FORWARD  0
+#define ST_DEB_BACKWARD 1
+static void deb_space_print(char *name, int direction, char *units, unsigned char *cmd)
+{
+	s32 sc;
+
+	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
+	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
+	if (direction)
+		sc = -sc;
+	printk(ST_DEB_MSG "%s: Spacing tape %s over %d %s.\n", name,
+	       direction ? "backward" : "forward", sc, units);
+}
+#endif
+
 
 /* Internal ioctl function */
 static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned long arg)
@@ -2445,8 +2460,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(printk(ST_DEB_MSG "%s: Spacing tape forward over %d filemarks.\n",
-			    name, cmd[2] * 65536 + cmd[3] * 256 + cmd[4]));
+                DEBC(deb_space_print(name, ST_DEB_FORWARD, "filemarks", cmd);)
 		if (fileno >= 0)
 			fileno += arg;
 		blkno = 0;
@@ -2461,14 +2475,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(
-                     if (cmd[2] & 0x80)
-                     	ltmp = 0xff000000;
-                     ltmp = ltmp | (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
-                     printk(ST_DEB_MSG
-                            "%s: Spacing tape backward over %ld filemarks.\n",
-                            name, (-ltmp));
-		)
+                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "filemarks", cmd);)
 		if (fileno >= 0)
 			fileno -= arg;
 		blkno = (-1);	/* We can't know the block number */
@@ -2480,8 +2487,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(printk(ST_DEB_MSG "%s: Spacing tape forward %d blocks.\n", name,
-			       cmd[2] * 65536 + cmd[3] * 256 + cmd[4]));
+                DEBC(deb_space_print(name, ST_DEB_FORWARD, "blocks", cmd);)
 		if (blkno >= 0)
 			blkno += arg;
 		at_sm &= (arg == 0);
@@ -2493,13 +2499,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(
-                     if (cmd[2] & 0x80)
-                          ltmp = 0xff000000;
-                     ltmp = ltmp | (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
-                     printk(ST_DEB_MSG
-                            "%s: Spacing tape backward %ld blocks.\n", name, (-ltmp));
-		)
+                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "blocks", cmd);)
 		if (blkno >= 0)
 			blkno -= arg;
 		at_sm &= (arg == 0);
@@ -2510,8 +2510,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(printk(ST_DEB_MSG "%s: Spacing tape forward %d setmarks.\n", name,
-                            cmd[2] * 65536 + cmd[3] * 256 + cmd[4]));
+                DEBC(deb_space_print(name, ST_DEB_FORWARD, "setmarks", cmd);)
 		if (arg != 0) {
 			blkno = fileno = (-1);
 			at_sm = 1;
@@ -2524,13 +2523,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(
-                     if (cmd[2] & 0x80)
-				ltmp = 0xff000000;
-                     ltmp = ltmp | (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
-                     printk(ST_DEB_MSG "%s: Spacing tape backward %ld setmarks.\n",
-                            name, (-ltmp));
-		)
+                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "setmarks", cmd);)
 		if (arg != 0) {
 			blkno = fileno = (-1);
 			at_sm = 1;
@@ -2600,7 +2593,7 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[1] = 3;
                 DEBC(printk(ST_DEB_MSG "%s: Spacing to end of recorded medium.\n",
                             name));
-		blkno = 0;
+		blkno = -1;
 		at_sm = 0;
 		break;
 	case MTERASE:
@@ -2761,7 +2754,7 @@ static int st_int_ioctl(struct scsi_tape
 				STps->drv_file = fileno - undone;
 			else
 				STps->drv_file = fileno;
-			STps->drv_block = 0;
+			STps->drv_block = -1;
 			STps->eof = ST_NOEOF;
 		} else if ((cmd_in == MTBSF) || (cmd_in == MTBSFM)) {
 			if (arg > 0 && undone < 0)  /* Some drives get this wrong */
@@ -3239,12 +3232,15 @@ static int st_ioctl(struct inode *inode,
 			}
 			if (STps->rw == ST_WRITING &&
 			    (mtc.mt_op == MTREW || mtc.mt_op == MTOFFL ||
-			     mtc.mt_op == MTSEEK)) {
+			     mtc.mt_op == MTSEEK ||
+			     mtc.mt_op == MTBSF || mtc.mt_op == MTBSFM)) {
 				i = st_int_ioctl(STp, MTWEOF, 1);
 				if (i < 0) {
 					retval = i;
 					goto out;
 				}
+				if (mtc.mt_op == MTBSF || mtc.mt_op == MTBSFM)
+					mtc.mt_count++;
 				STps->rw = ST_IDLE;
 			     }
 
--- linux-2.6.11-k1/Documentation/scsi/st.txt	2005-03-07 19:38:45.000000000 +0200
+++ linux-2.6.11-k2/Documentation/scsi/st.txt	2005-03-07 21:14:44.000000000 +0200
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai Mäkisara (email
 Kai.Makisara@kolumbus.fi)
 
-Last modified: Sun Feb 20 22:28:27 2005 by kai.makisara
+Last modified: Mon Mar  7 21:14:44 2005 by kai.makisara
 
 
 BASICS
@@ -85,8 +85,8 @@ writing and the last operation has been 
 optionally written. In both cases end of data is signified by
 returning zero bytes for two consecutive reads.
 
-If the rewind, offline, or seek is done and previous tape operation was write,
-a filemark is written before moving tape.
+If rewind, offline, bsf, or seek is done and previous tape operation was
+write, a filemark is written before moving tape.
 
 The compile options are defined in the file linux/drivers/scsi/st_options.h.
 
--2831155969-182967974-1110226379=:6862--
