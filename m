From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [RFC PATCH] consolidate SCSI-2 command lun setting
Date: Tue, 15 Oct 2002 09:55:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015095502.A25647@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e35.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9FGt8Qu068530
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 12:55:09 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9FGt7Eq085770
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 10:55:08 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g9FGt5v08386
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 09:55:05 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9FGt2w25781
	for linux-scsi@vger.kernel.org; Tue, 15 Oct 2002 09:55:02 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch consolidates the setting of the LUN in byte 1 of the SCSI
command block for SCSI-2 and lower devices.

This is needed for multi-path IO (some devices can actually have different
LUN values for each path), but is also a clean up of the code.

The scsi_error.c retry code does not use scsi_request_fn(), so it
must still set the LUN value.

sg.c was able to inhibit setting the value, this removes that capability -
if it is really needed it can be black listed in the device_list[]
flags, or sg could set a similiar flag.

This is patched against the latest bk (as of some time on Oct 14), and
patches clean against the snapshots/patch-2.5.42-bk2 (there are a bunch
of sr changes in the latest bk).

 drivers/scsi/osst.c       |    2 --
 drivers/scsi/scsi_error.c |    2 +-
 drivers/scsi/scsi_ioctl.c |   16 ++++------------
 drivers/scsi/scsi_lib.c   |    8 ++++++++
 drivers/scsi/sd.c         |   22 +++++-----------------
 drivers/scsi/sg.c         |    4 ----
 drivers/scsi/sr.c         |   17 ++---------------
 drivers/scsi/sr_ioctl.c   |   20 +-------------------
 drivers/scsi/sr_vendor.c  |   18 +++---------------
 drivers/scsi/st.c         |    2 --
 include/scsi/sg.h         |    2 +-
 11 files changed, 25 insertions(+), 88 deletions(-)

diff -Nru a/drivers/scsi/osst.c b/drivers/scsi/osst.c
--- a/drivers/scsi/osst.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/osst.c	Tue Oct 15 09:46:06 2002
@@ -322,8 +322,6 @@
 		}
 	}
 
-        if (SRpnt->sr_device->scsi_level <= SCSI_2)
-                cmd[1] |= (SRpnt->sr_device->lun << 5) & 0xe0;
         init_completion(&STp->wait);
 	SRpnt->sr_use_sg = (bytes > (STp->buffer)->sg[0].length) ?
 				    (STp->buffer)->use_sg : 0;
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/scsi_error.c	Tue Oct 15 09:46:06 2002
@@ -1419,7 +1419,7 @@
 	}
 
 	sreq->sr_cmnd[0] = ALLOW_MEDIUM_REMOVAL;
-	sreq->sr_cmnd[1] = (sdev->scsi_level <= SCSI_2) ? (sdev->lun << 5) : 0;
+	sreq->sr_cmnd[1] = 0;
 	sreq->sr_cmnd[2] = 0;
 	sreq->sr_cmnd[3] = 0;
 	sreq->sr_cmnd[4] = SCSI_REMOVAL_PREVENT;
diff -Nru a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Tue Oct 15 09:46:07 2002
+++ b/drivers/scsi/scsi_ioctl.c	Tue Oct 15 09:46:07 2002
@@ -160,7 +160,7 @@
 	       return 0;
 
 	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
-	scsi_cmd[1] = (dev->scsi_level <= SCSI_2) ? (dev->lun << 5) : 0;
+	scsi_cmd[1] = 0;
 	scsi_cmd[2] = 0;
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = state;
@@ -297,12 +297,6 @@
 	if(copy_from_user(buf, cmd_in + cmdlen, inlen))
 		goto error;
 
-	/*
-	 * Set the lun field to the correct value.
-	 */
-	if (dev->scsi_level <= SCSI_2)
-		cmd[1] = (cmd[1] & 0x1f) | (dev->lun << 5);
-
 	switch (opcode) {
 	case FORMAT_UNIT:
 		timeout = FORMAT_UNIT_TIMEOUT;
@@ -416,7 +410,6 @@
 int scsi_ioctl(Scsi_Device * dev, int cmd, void *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
-	char cmd_byte1;
 
 	/* No idea how this happens.... */
 	if (!dev)
@@ -431,7 +424,6 @@
 	if (!scsi_block_when_processing_errors(dev)) {
 		return -ENODEV;
 	}
-	cmd_byte1 = (dev->scsi_level <= SCSI_2) ? (dev->lun << 5) : 0;
 
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
@@ -484,7 +476,7 @@
 		return scsi_set_medium_removal(dev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		scsi_cmd[0] = TEST_UNIT_READY;
-		scsi_cmd[1] = cmd_byte1;
+		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 0;
 		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
@@ -492,7 +484,7 @@
 		break;
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] = START_STOP;
-		scsi_cmd[1] = cmd_byte1;
+		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 1;
 		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
@@ -500,7 +492,7 @@
 		break;
 	case SCSI_IOCTL_STOP_UNIT:
 		scsi_cmd[0] = START_STOP;
-		scsi_cmd[1] = cmd_byte1;
+		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 0;
 		return ioctl_internal_command((Scsi_Device *) dev, scsi_cmd,
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/scsi_lib.c	Tue Oct 15 09:46:06 2002
@@ -972,6 +972,14 @@
 				continue;
 			}
 		}
+		/* 
+		 * If SCSI-2 or lower, store the LUN value in cmnd.
+		 */
+		if (SDpnt->scsi_level <= SCSI_2)
+			SCpnt->cmnd[1] = (SCpnt->cmnd[1] & 0x1f) |
+				(SCpnt->lun << 5 & 0xe0);
+
+
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Tue Oct 15 09:46:07 2002
+++ b/drivers/scsi/sd.c	Tue Oct 15 09:46:07 2002
@@ -402,8 +402,7 @@
 		nbuff, (rq_data_dir(SCpnt->request) == WRITE) ? 
 		"writing" : "reading", this_count, SCpnt->request->nr_sectors));
 
-	SCpnt->cmnd[1] = (SCpnt->device->scsi_level <= SCSI_2) ?
-			 ((SCpnt->lun << 5) & 0xe0) : 0;
+	SCpnt->cmnd[1] = 0;
 
 	if (((this_count > 0xff) || (block > 0x1fffff)) || SCpnt->device->ten) {
 		if (this_count > 0xffff)
@@ -815,9 +814,7 @@
 
 		while (retries < 3) {
 			cmd[0] = TEST_UNIT_READY;
-			cmd[1] = (sdp->scsi_level <= SCSI_2) ?
-				((sdp->lun << 5) & 0xe0) : 0;
-			memset((void *) &cmd[2], 0, 8);
+			memset((void *) &cmd[1], 0, 9);
 
 			SRpnt->sr_cmd_len = 0;
 			SRpnt->sr_sense_buffer[0] = 0;
@@ -851,9 +848,7 @@
 				printk(KERN_NOTICE "%s: Spinning up disk...",
 				       diskname);
 				cmd[0] = START_STOP;
-				cmd[1] = (sdp->scsi_level <= SCSI_2) ?
-					((sdp->lun << 5) & 0xe0) : 0;
-				cmd[1] |= 1;	/* Return immediately */
+				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
 				SRpnt->sr_cmd_len = 0;
@@ -894,7 +889,6 @@
 		   Scsi_Request *SRpnt, unsigned char *buffer) {
 
 	unsigned char cmd[10];
-	Scsi_Device *sdp = sdkp->device;
 	int the_result, retries;
 
 	retries = 3;
@@ -902,9 +896,7 @@
 
 		memset((void *) &cmd[0], 0, 10);
 		cmd[0] = MODE_SENSE;
-		cmd[1] = (sdp->scsi_level <= SCSI_2) ?
-			 ((sdp->lun << 5) & 0xe0) : 0;
-		cmd[1] |= 0x08;	/* DBD */
+		cmd[1] = 0x08;	/* DBD */
 		cmd[2] = 0x08;	/* current values, cache page */
 		cmd[4] = 128;	/* allocation length */
 
@@ -968,9 +960,7 @@
 	retries = 3;
 	do {
 		cmd[0] = READ_CAPACITY;
-		cmd[1] = (sdp->scsi_level <= SCSI_2) ?
-			((sdp->lun << 5) & 0xe0) : 0;
-		memset((void *) &cmd[2], 0, 8);
+		memset((void *) &cmd[1], 0, 9);
 		memset((void *) buffer, 0, 8);
 
 		SRpnt->sr_cmd_len = 0;
@@ -1090,7 +1080,6 @@
 
 	memset((void *) &cmd[0], 0, 8);
 	cmd[0] = MODE_SENSE;
-	cmd[1] = (sdp->scsi_level <= SCSI_2) ? ((sdp->lun << 5) & 0xe0) : 0;
 	cmd[2] = modepage;
 	cmd[4] = len;
 
@@ -1612,7 +1601,6 @@
 		unsigned char cmd[10] = { 0 };
 
 		cmd[0] = SYNCHRONIZE_CACHE;
-		cmd[1] = SDpnt->scsi_level <= SCSI_2 ? (SDpnt->lun << 5) & 0xe0 : 0;
 		/* leave the rest of the command zero to indicate 
 		 * flush everything */
 		scsi_wait_req(SRpnt, (void *)cmd, NULL, 0,
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/sg.c	Tue Oct 15 09:46:06 2002
@@ -705,10 +705,6 @@
 	SRpnt->sr_request->rq_dev = sdp->i_rdev;
 	SRpnt->sr_sense_buffer[0] = 0;
 	SRpnt->sr_cmd_len = hp->cmd_len;
-	if (!(hp->flags & SG_FLAG_LUN_INHIBIT)) {
-		if (sdp->device->scsi_level <= SCSI_2)
-			cmnd[1] = (cmnd[1] & 0x1f) | (sdp->device->lun << 5);
-	}
 	SRpnt->sr_use_sg = srp->data.k_use_sg;
 	SRpnt->sr_sglist_len = srp->data.sglist_len;
 	SRpnt->sr_bufflen = srp->data.bufflen;
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/sr.c	Tue Oct 15 09:46:06 2002
@@ -336,9 +336,7 @@
 		   (rq_data_dir(SCpnt->request) == WRITE) ? "writing" : "reading",
 				 this_count, SCpnt->request->nr_sectors));
 
-	SCpnt->cmnd[1] = (SCpnt->device->scsi_level <= SCSI_2) ?
-			 ((SCpnt->lun << 5) & 0xe0) : 0;
-
+	SCpnt->cmnd[1] = 0;
 	block = (unsigned int)SCpnt->request->sector / (s_size >> 9);
 
 	if (this_count > 0xffff)
@@ -486,9 +484,7 @@
 
 	do {
 		cmd[0] = READ_CAPACITY;
-		cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-			 ((cd->device->lun << 5) & 0xe0) : 0;
-		memset((void *) &cmd[2], 0, 8);
+		memset((void *) &cmd[1], 0, 9);
 		SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;	/* Mark as really busy */
 		SRpnt->sr_cmd_len = 0;
 
@@ -599,8 +595,6 @@
 	}
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = MODE_SENSE;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     ((cd->device->lun << 5) & 0xe0) : 0;
 	cgc.cmd[2] = 0x2a;
 	cgc.cmd[4] = 128;
 	cgc.buffer = buffer;
@@ -678,13 +672,6 @@
  */
 static int sr_packet(struct cdrom_device_info *cdi, struct cdrom_generic_command *cgc)
 {
-	Scsi_CD *cd = cdi->handle;
-	Scsi_Device *device = cd->device;
-	
-	/* set the LUN */
-	if (device->scsi_level <= SCSI_2)
-		cgc->cmd[1] |= device->lun << 5;
-
 	if (cgc->timeout <= 0)
 		cgc->timeout = IOCTL_TIMEOUT;
 
diff -Nru a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/sr_ioctl.c	Tue Oct 15 09:46:06 2002
@@ -200,8 +200,6 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     ((cd->device->lun) << 5) : 0;
 	cgc.quiet = 1;
 	cgc.data_direction = SCSI_DATA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
@@ -215,8 +213,6 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_START_STOP_UNIT;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     ((cd->device->lun) << 5) : 0;
 	cgc.cmd[4] = (pos == 0) ? 0x03 /* close */ : 0x02 /* eject */ ;
 	cgc.data_direction = SCSI_DATA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
@@ -293,8 +289,6 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_READ_SUBCHANNEL;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     ((cd->device->lun) << 5) : 0;
 	cgc.cmd[2] = 0x40;	/* I do want the subchannel info */
 	cgc.cmd[3] = 0x02;	/* Give me medium catalog number info */
 	cgc.cmd[8] = 24;
@@ -327,8 +321,6 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_SET_SPEED;	/* SET CD SPEED */
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     ((cd->device->lun) << 5) : 0;
 	cgc.cmd[2] = (speed >> 8) & 0xff;	/* MSB for speed (in kbytes/sec) */
 	cgc.cmd[3] = speed & 0xff;	/* LSB */
 	cgc.data_direction = SCSI_DATA_NONE;
@@ -361,8 +353,6 @@
 			struct cdrom_tochdr *tochdr = (struct cdrom_tochdr *) arg;
 
 			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
-			cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-				     ((cd->device->lun) << 5) : 0;
 			cgc.cmd[8] = 12;		/* LSB of length */
 			cgc.buffer = buffer;
 			cgc.buflen = 12;
@@ -382,8 +372,6 @@
 			struct cdrom_tocentry *tocentry = (struct cdrom_tocentry *) arg;
 
 			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
-			cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-				     ((cd->device->lun) << 5) : 0;
 			cgc.cmd[1] |= (tocentry->cdte_format == CDROM_MSF) ? 0x02 : 0;
 			cgc.cmd[6] = tocentry->cdte_track;
 			cgc.cmd[8] = 12;		/* LSB of length */
@@ -411,8 +399,6 @@
 		struct cdrom_ti* ti = (struct cdrom_ti*)arg;
 
 		cgc.cmd[0] = GPCMD_PLAYAUDIO_TI;
-		cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-			     (cd->device->lun << 5) : 0;
 		cgc.cmd[4] = ti->cdti_trk0;
 		cgc.cmd[5] = ti->cdti_ind0;
 		cgc.cmd[7] = ti->cdti_trk1;
@@ -463,9 +449,7 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_READ_CD;	/* READ_CD */
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     (cd->device->lun << 5) : 0;
-	cgc.cmd[1] |= ((format & 7) << 2);
+	cgc.cmd[1] = ((format & 7) << 2);
 	cgc.cmd[2] = (unsigned char) (lba >> 24) & 0xff;
 	cgc.cmd[3] = (unsigned char) (lba >> 16) & 0xff;
 	cgc.cmd[4] = (unsigned char) (lba >> 8) & 0xff;
@@ -521,8 +505,6 @@
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = GPCMD_READ_10;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     (cd->device->lun << 5) : 0;
 	cgc.cmd[2] = (unsigned char) (lba >> 24) & 0xff;
 	cgc.cmd[3] = (unsigned char) (lba >> 16) & 0xff;
 	cgc.cmd[4] = (unsigned char) (lba >> 8) & 0xff;
diff -Nru a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
--- a/drivers/scsi/sr_vendor.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/sr_vendor.c	Tue Oct 15 09:46:06 2002
@@ -124,9 +124,7 @@
 #endif
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.cmd[0] = MODE_SELECT;
-	cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-		     (cd->device->lun << 5) : 0;
-	cgc.cmd[1] |= (1 << 4);
+	cgc.cmd[1] = (1 << 4);
 	cgc.cmd[4] = 12;
 	modesel = (struct ccs_modesel_head *) buffer;
 	memset(modesel, 0, sizeof(*modesel));
@@ -180,8 +178,6 @@
 
 	case VENDOR_SCSI3:
 		cgc.cmd[0] = READ_TOC;
-		cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-			     (cd->device->lun << 5) : 0;
 		cgc.cmd[8] = 12;
 		cgc.cmd[9] = 0x40;
 		cgc.buffer = buffer;
@@ -210,9 +206,7 @@
 	case VENDOR_NEC:{
 			unsigned long min, sec, frame;
 			cgc.cmd[0] = 0xde;
-			cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-				     (cd->device->lun << 5) : 0;
-			cgc.cmd[1] |= 0x03;
+			cgc.cmd[1] = 0x03;
 			cgc.cmd[2] = 0xb0;
 			cgc.buffer = buffer;
 			cgc.buflen = 0x16;
@@ -242,9 +236,7 @@
 			/* we request some disc information (is it a XA-CD ?,
 			 * where starts the last session ?) */
 			cgc.cmd[0] = 0xc7;
-			cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-				     (cd->device->lun << 5) : 0;
-			cgc.cmd[1] |= 0x03;
+			cgc.cmd[1] = 0x03;
 			cgc.buffer = buffer;
 			cgc.buflen = 4;
 			cgc.quiet = 1;
@@ -272,8 +264,6 @@
 
 	case VENDOR_WRITER:
 		cgc.cmd[0] = READ_TOC;
-		cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-			     (cd->device->lun << 5) : 0;
 		cgc.cmd[8] = 0x04;
 		cgc.cmd[9] = 0x40;
 		cgc.buffer = buffer;
@@ -291,8 +281,6 @@
 			break;
 		}
 		cgc.cmd[0] = READ_TOC;	/* Read TOC */
-		cgc.cmd[1] = (cd->device->scsi_level <= SCSI_2) ?
-			     (cd->device->lun << 5) : 0;
 		cgc.cmd[6] = rc & 0x7f;	/* number of last session */
 		cgc.cmd[8] = 0x0c;
 		cgc.cmd[9] = 0x40;
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Tue Oct 15 09:46:06 2002
+++ b/drivers/scsi/st.c	Tue Oct 15 09:46:06 2002
@@ -379,8 +379,6 @@
 		}
 	}
 
-	if (SRpnt->sr_device->scsi_level <= SCSI_2)
-		cmd[1] |= (SRpnt->sr_device->lun << 5) & 0xe0;
 	init_completion(&STp->wait);
 	SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
 	if (SRpnt->sr_use_sg) {
diff -Nru a/include/scsi/sg.h b/include/scsi/sg.h
--- a/include/scsi/sg.h	Tue Oct 15 09:46:06 2002
+++ b/include/scsi/sg.h	Tue Oct 15 09:46:06 2002
@@ -130,7 +130,7 @@
 
 /* following flag values can be "or"-ed together */
 #define SG_FLAG_DIRECT_IO 1     /* default is indirect IO */
-#define SG_FLAG_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
+#define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
