From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: storage: reuse definitions from scsi.h header file
Date: Thu, 07 Oct 2010 14:46:15 +0200
Message-ID: <b1c00282f3bd2ae950f081aec444ee15e99b6629.1286455365.git.m.nazarewicz@samsung.com>
References: <20100929004609.GA4689@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13877 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760435Ab0JGMoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 08:44:16 -0400
In-reply-to: <20100929004609.GA4689@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Michal Nazarewicz <mina86@mina86.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

From: Michal Nazarewicz <mina86@mina86.com>

This commit changes storage_common.h, file_storage.c and
f_mass_storage.c to use definitions of SCSI commands from
scsi/scsi.h file instead of redefining the commands in
storage_common.c.

scsi/scsi.h header file was missing READ_FORMAT_CAPACITIES and
READ_HEADER so this commit also add those to the header.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/f_mass_storage.c |   72 +++++++++++++++++-----------------
 drivers/usb/gadget/file_storage.c   |   74 +++++++++++++++++-----------------
 drivers/usb/gadget/storage_common.c |   34 +---------------
 include/scsi/scsi.h                 |    2 +
 4 files changed, 77 insertions(+), 105 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 44e5ffe..838286b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -741,7 +741,7 @@ static int do_read(struct fsg_common *common)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	if (common->cmnd[0] == SC_READ_6)
+	if (common->cmnd[0] == READ_6)
 		lba = get_unaligned_be24(&common->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&common->cmnd[2]);
@@ -879,7 +879,7 @@ static int do_write(struct fsg_common *common)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	if (common->cmnd[0] == SC_WRITE_6)
+	if (common->cmnd[0] == WRITE_6)
 		lba = get_unaligned_be24(&common->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&common->cmnd[2]);
@@ -1186,7 +1186,7 @@ static int do_inquiry(struct fsg_common *common, struct fsg_buffhd *bh)
 		return 36;
 	}
 
-	buf[0] = curlun->cdrom ? TYPE_CDROM : TYPE_DISK;
+	buf[0] = curlun->cdrom ? TYPE_ROM : TYPE_DISK;
 	buf[1] = curlun->removable ? 0x80 : 0;
 	buf[2] = 2;		/* ANSI SCSI level 2 */
 	buf[3] = 2;		/* SCSI-2 INQUIRY data format */
@@ -1353,11 +1353,11 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	 * The only variable value is the WriteProtect bit.  We will fill in
 	 * the mode data length later. */
 	memset(buf, 0, 8);
-	if (mscmnd == SC_MODE_SENSE_6) {
+	if (mscmnd == MODE_SENSE) {
 		buf[2] = (curlun->ro ? 0x80 : 0x00);		/* WP, DPOFUA */
 		buf += 4;
 		limit = 255;
-	} else {			/* SC_MODE_SENSE_10 */
+	} else {			/* MODE_SENSE_10 */
 		buf[3] = (curlun->ro ? 0x80 : 0x00);		/* WP, DPOFUA */
 		buf += 8;
 		limit = 65535;		/* Should really be FSG_BUFLEN */
@@ -1397,7 +1397,7 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	}
 
 	/*  Store the mode data length */
-	if (mscmnd == SC_MODE_SENSE_6)
+	if (mscmnd == MODE_SENSE)
 		buf0[0] = len - 1;
 	else
 		put_unaligned_be16(len - 2, buf0);
@@ -1886,7 +1886,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	if (common->lun >= 0 && common->lun < common->nluns) {
 		curlun = &common->luns[common->lun];
 		common->curlun = curlun;
-		if (common->cmnd[0] != SC_REQUEST_SENSE) {
+		if (common->cmnd[0] != REQUEST_SENSE) {
 			curlun->sense_data = SS_NO_SENSE;
 			curlun->sense_data_info = 0;
 			curlun->info_valid = 0;
@@ -1898,8 +1898,8 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 
 		/* INQUIRY and REQUEST SENSE commands are explicitly allowed
 		 * to use unsupported LUNs; all others may not. */
-		if (common->cmnd[0] != SC_INQUIRY &&
-		    common->cmnd[0] != SC_REQUEST_SENSE) {
+		if (common->cmnd[0] != INQUIRY &&
+		    common->cmnd[0] != REQUEST_SENSE) {
 			DBG(common, "unsupported LUN %d\n", common->lun);
 			return -EINVAL;
 		}
@@ -1908,8 +1908,8 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	/* If a unit attention condition exists, only INQUIRY and
 	 * REQUEST SENSE commands are allowed; anything else must fail. */
 	if (curlun && curlun->unit_attention_data != SS_NO_SENSE &&
-			common->cmnd[0] != SC_INQUIRY &&
-			common->cmnd[0] != SC_REQUEST_SENSE) {
+			common->cmnd[0] != INQUIRY &&
+			common->cmnd[0] != REQUEST_SENSE) {
 		curlun->sense_data = curlun->unit_attention_data;
 		curlun->unit_attention_data = SS_NO_SENSE;
 		return -EINVAL;
@@ -1960,7 +1960,7 @@ static int do_scsi_command(struct fsg_common *common)
 	down_read(&common->filesem);	/* We're using the backing file */
 	switch (common->cmnd[0]) {
 
-	case SC_INQUIRY:
+	case INQUIRY:
 		common->data_size_from_cmnd = common->cmnd[4];
 		reply = check_command(common, 6, DATA_DIR_TO_HOST,
 				      (1<<4), 0,
@@ -1969,7 +1969,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_inquiry(common, bh);
 		break;
 
-	case SC_MODE_SELECT_6:
+	case MODE_SELECT:
 		common->data_size_from_cmnd = common->cmnd[4];
 		reply = check_command(common, 6, DATA_DIR_FROM_HOST,
 				      (1<<1) | (1<<4), 0,
@@ -1978,7 +1978,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_mode_select(common, bh);
 		break;
 
-	case SC_MODE_SELECT_10:
+	case MODE_SELECT_10:
 		common->data_size_from_cmnd =
 			get_unaligned_be16(&common->cmnd[7]);
 		reply = check_command(common, 10, DATA_DIR_FROM_HOST,
@@ -1988,7 +1988,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_mode_select(common, bh);
 		break;
 
-	case SC_MODE_SENSE_6:
+	case MODE_SENSE:
 		common->data_size_from_cmnd = common->cmnd[4];
 		reply = check_command(common, 6, DATA_DIR_TO_HOST,
 				      (1<<1) | (1<<2) | (1<<4), 0,
@@ -1997,7 +1997,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_mode_sense(common, bh);
 		break;
 
-	case SC_MODE_SENSE_10:
+	case MODE_SENSE_10:
 		common->data_size_from_cmnd =
 			get_unaligned_be16(&common->cmnd[7]);
 		reply = check_command(common, 10, DATA_DIR_TO_HOST,
@@ -2007,7 +2007,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_mode_sense(common, bh);
 		break;
 
-	case SC_PREVENT_ALLOW_MEDIUM_REMOVAL:
+	case ALLOW_MEDIUM_REMOVAL:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 6, DATA_DIR_NONE,
 				      (1<<4), 0,
@@ -2016,7 +2016,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_prevent_allow(common);
 		break;
 
-	case SC_READ_6:
+	case READ_6:
 		i = common->cmnd[4];
 		common->data_size_from_cmnd = (i == 0 ? 256 : i) << 9;
 		reply = check_command(common, 6, DATA_DIR_TO_HOST,
@@ -2026,7 +2026,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read(common);
 		break;
 
-	case SC_READ_10:
+	case READ_10:
 		common->data_size_from_cmnd =
 				get_unaligned_be16(&common->cmnd[7]) << 9;
 		reply = check_command(common, 10, DATA_DIR_TO_HOST,
@@ -2036,7 +2036,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read(common);
 		break;
 
-	case SC_READ_12:
+	case READ_12:
 		common->data_size_from_cmnd =
 				get_unaligned_be32(&common->cmnd[6]) << 9;
 		reply = check_command(common, 12, DATA_DIR_TO_HOST,
@@ -2046,7 +2046,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read(common);
 		break;
 
-	case SC_READ_CAPACITY:
+	case READ_CAPACITY:
 		common->data_size_from_cmnd = 8;
 		reply = check_command(common, 10, DATA_DIR_TO_HOST,
 				      (0xf<<2) | (1<<8), 1,
@@ -2055,7 +2055,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read_capacity(common, bh);
 		break;
 
-	case SC_READ_HEADER:
+	case READ_HEADER:
 		if (!common->curlun || !common->curlun->cdrom)
 			goto unknown_cmnd;
 		common->data_size_from_cmnd =
@@ -2067,7 +2067,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read_header(common, bh);
 		break;
 
-	case SC_READ_TOC:
+	case READ_TOC:
 		if (!common->curlun || !common->curlun->cdrom)
 			goto unknown_cmnd;
 		common->data_size_from_cmnd =
@@ -2079,7 +2079,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read_toc(common, bh);
 		break;
 
-	case SC_READ_FORMAT_CAPACITIES:
+	case READ_FORMAT_CAPACITIES:
 		common->data_size_from_cmnd =
 			get_unaligned_be16(&common->cmnd[7]);
 		reply = check_command(common, 10, DATA_DIR_TO_HOST,
@@ -2089,7 +2089,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_read_format_capacities(common, bh);
 		break;
 
-	case SC_REQUEST_SENSE:
+	case REQUEST_SENSE:
 		common->data_size_from_cmnd = common->cmnd[4];
 		reply = check_command(common, 6, DATA_DIR_TO_HOST,
 				      (1<<4), 0,
@@ -2098,7 +2098,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_request_sense(common, bh);
 		break;
 
-	case SC_START_STOP_UNIT:
+	case START_STOP:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 6, DATA_DIR_NONE,
 				      (1<<1) | (1<<4), 0,
@@ -2107,7 +2107,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_start_stop(common);
 		break;
 
-	case SC_SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 10, DATA_DIR_NONE,
 				      (0xf<<2) | (3<<7), 1,
@@ -2116,7 +2116,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_synchronize_cache(common);
 		break;
 
-	case SC_TEST_UNIT_READY:
+	case TEST_UNIT_READY:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 6, DATA_DIR_NONE,
 				0, 1,
@@ -2125,7 +2125,7 @@ static int do_scsi_command(struct fsg_common *common)
 
 	/* Although optional, this command is used by MS-Windows.  We
 	 * support a minimal version: BytChk must be 0. */
-	case SC_VERIFY:
+	case VERIFY:
 		common->data_size_from_cmnd = 0;
 		reply = check_command(common, 10, DATA_DIR_NONE,
 				      (1<<1) | (0xf<<2) | (3<<7), 1,
@@ -2134,7 +2134,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_verify(common);
 		break;
 
-	case SC_WRITE_6:
+	case WRITE_6:
 		i = common->cmnd[4];
 		common->data_size_from_cmnd = (i == 0 ? 256 : i) << 9;
 		reply = check_command(common, 6, DATA_DIR_FROM_HOST,
@@ -2144,7 +2144,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_write(common);
 		break;
 
-	case SC_WRITE_10:
+	case WRITE_10:
 		common->data_size_from_cmnd =
 				get_unaligned_be16(&common->cmnd[7]) << 9;
 		reply = check_command(common, 10, DATA_DIR_FROM_HOST,
@@ -2154,7 +2154,7 @@ static int do_scsi_command(struct fsg_common *common)
 			reply = do_write(common);
 		break;
 
-	case SC_WRITE_12:
+	case WRITE_12:
 		common->data_size_from_cmnd =
 				get_unaligned_be32(&common->cmnd[6]) << 9;
 		reply = check_command(common, 12, DATA_DIR_FROM_HOST,
@@ -2168,10 +2168,10 @@ static int do_scsi_command(struct fsg_common *common)
 	 * They don't mean much in this setting.  It's left as an exercise
 	 * for anyone interested to implement RESERVE and RELEASE in terms
 	 * of Posix locks. */
-	case SC_FORMAT_UNIT:
-	case SC_RELEASE:
-	case SC_RESERVE:
-	case SC_SEND_DIAGNOSTIC:
+	case FORMAT_UNIT:
+	case RELEASE:
+	case RESERVE:
+	case SEND_DIAGNOSTIC:
 		/* Fall through */
 
 	default:
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index ce437f5..d4fdf65 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -783,7 +783,7 @@ static void received_cbi_adsc(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct usb_request	*req = fsg->ep0req;
 	static u8		cbi_reset_cmnd[6] = {
-			SC_SEND_DIAGNOSTIC, 4, 0xff, 0xff, 0xff, 0xff};
+			SEND_DIAGNOSTIC, 4, 0xff, 0xff, 0xff, 0xff};
 
 	/* Error in command transfer? */
 	if (req->status || req->length != req->actual ||
@@ -1135,7 +1135,7 @@ static int do_read(struct fsg_dev *fsg)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	if (fsg->cmnd[0] == SC_READ_6)
+	if (fsg->cmnd[0] == READ_6)
 		lba = get_unaligned_be24(&fsg->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&fsg->cmnd[2]);
@@ -1270,7 +1270,7 @@ static int do_write(struct fsg_dev *fsg)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	if (fsg->cmnd[0] == SC_WRITE_6)
+	if (fsg->cmnd[0] == WRITE_6)
 		lba = get_unaligned_be24(&fsg->cmnd[1]);
 	else {
 		lba = get_unaligned_be32(&fsg->cmnd[2]);
@@ -1578,7 +1578,7 @@ static int do_inquiry(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	}
 
 	memset(buf, 0, 8);
-	buf[0] = (mod_data.cdrom ? TYPE_CDROM : TYPE_DISK);
+	buf[0] = (mod_data.cdrom ? TYPE_ROM : TYPE_DISK);
 	if (mod_data.removable)
 		buf[1] = 0x80;
 	buf[2] = 2;		// ANSI SCSI level 2
@@ -1747,11 +1747,11 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	 * The only variable value is the WriteProtect bit.  We will fill in
 	 * the mode data length later. */
 	memset(buf, 0, 8);
-	if (mscmnd == SC_MODE_SENSE_6) {
+	if (mscmnd == MODE_SENSE) {
 		buf[2] = (curlun->ro ? 0x80 : 0x00);		// WP, DPOFUA
 		buf += 4;
 		limit = 255;
-	} else {			// SC_MODE_SENSE_10
+	} else {			// MODE_SENSE_10
 		buf[3] = (curlun->ro ? 0x80 : 0x00);		// WP, DPOFUA
 		buf += 8;
 		limit = 65535;		// Should really be mod_data.buflen
@@ -1791,7 +1791,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	}
 
 	/*  Store the mode data length */
-	if (mscmnd == SC_MODE_SENSE_6)
+	if (mscmnd == MODE_SENSE)
 		buf0[0] = len - 1;
 	else
 		put_unaligned_be16(len - 2, buf0);
@@ -2316,7 +2316,7 @@ static int check_command(struct fsg_dev *fsg, int cmnd_size,
 	/* Check the LUN */
 	if (fsg->lun >= 0 && fsg->lun < fsg->nluns) {
 		fsg->curlun = curlun = &fsg->luns[fsg->lun];
-		if (fsg->cmnd[0] != SC_REQUEST_SENSE) {
+		if (fsg->cmnd[0] != REQUEST_SENSE) {
 			curlun->sense_data = SS_NO_SENSE;
 			curlun->sense_data_info = 0;
 			curlun->info_valid = 0;
@@ -2327,8 +2327,8 @@ static int check_command(struct fsg_dev *fsg, int cmnd_size,
 
 		/* INQUIRY and REQUEST SENSE commands are explicitly allowed
 		 * to use unsupported LUNs; all others may not. */
-		if (fsg->cmnd[0] != SC_INQUIRY &&
-				fsg->cmnd[0] != SC_REQUEST_SENSE) {
+		if (fsg->cmnd[0] != INQUIRY &&
+				fsg->cmnd[0] != REQUEST_SENSE) {
 			DBG(fsg, "unsupported LUN %d\n", fsg->lun);
 			return -EINVAL;
 		}
@@ -2337,8 +2337,8 @@ static int check_command(struct fsg_dev *fsg, int cmnd_size,
 	/* If a unit attention condition exists, only INQUIRY and
 	 * REQUEST SENSE commands are allowed; anything else must fail. */
 	if (curlun && curlun->unit_attention_data != SS_NO_SENSE &&
-			fsg->cmnd[0] != SC_INQUIRY &&
-			fsg->cmnd[0] != SC_REQUEST_SENSE) {
+			fsg->cmnd[0] != INQUIRY &&
+			fsg->cmnd[0] != REQUEST_SENSE) {
 		curlun->sense_data = curlun->unit_attention_data;
 		curlun->unit_attention_data = SS_NO_SENSE;
 		return -EINVAL;
@@ -2388,7 +2388,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 	down_read(&fsg->filesem);	// We're using the backing file
 	switch (fsg->cmnd[0]) {
 
-	case SC_INQUIRY:
+	case INQUIRY:
 		fsg->data_size_from_cmnd = fsg->cmnd[4];
 		if ((reply = check_command(fsg, 6, DATA_DIR_TO_HOST,
 				(1<<4), 0,
@@ -2396,7 +2396,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_inquiry(fsg, bh);
 		break;
 
-	case SC_MODE_SELECT_6:
+	case MODE_SELECT:
 		fsg->data_size_from_cmnd = fsg->cmnd[4];
 		if ((reply = check_command(fsg, 6, DATA_DIR_FROM_HOST,
 				(1<<1) | (1<<4), 0,
@@ -2404,7 +2404,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_mode_select(fsg, bh);
 		break;
 
-	case SC_MODE_SELECT_10:
+	case MODE_SELECT_10:
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (3<<7), 0,
@@ -2412,7 +2412,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_mode_select(fsg, bh);
 		break;
 
-	case SC_MODE_SENSE_6:
+	case MODE_SENSE:
 		fsg->data_size_from_cmnd = fsg->cmnd[4];
 		if ((reply = check_command(fsg, 6, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (1<<4), 0,
@@ -2420,7 +2420,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_mode_sense(fsg, bh);
 		break;
 
-	case SC_MODE_SENSE_10:
+	case MODE_SENSE_10:
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (3<<7), 0,
@@ -2428,7 +2428,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_mode_sense(fsg, bh);
 		break;
 
-	case SC_PREVENT_ALLOW_MEDIUM_REMOVAL:
+	case ALLOW_MEDIUM_REMOVAL:
 		fsg->data_size_from_cmnd = 0;
 		if ((reply = check_command(fsg, 6, DATA_DIR_NONE,
 				(1<<4), 0,
@@ -2436,7 +2436,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_prevent_allow(fsg);
 		break;
 
-	case SC_READ_6:
+	case READ_6:
 		i = fsg->cmnd[4];
 		fsg->data_size_from_cmnd = (i == 0 ? 256 : i) << 9;
 		if ((reply = check_command(fsg, 6, DATA_DIR_TO_HOST,
@@ -2445,7 +2445,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read(fsg);
 		break;
 
-	case SC_READ_10:
+	case READ_10:
 		fsg->data_size_from_cmnd =
 				get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
@@ -2454,7 +2454,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read(fsg);
 		break;
 
-	case SC_READ_12:
+	case READ_12:
 		fsg->data_size_from_cmnd =
 				get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_TO_HOST,
@@ -2463,7 +2463,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read(fsg);
 		break;
 
-	case SC_READ_CAPACITY:
+	case READ_CAPACITY:
 		fsg->data_size_from_cmnd = 8;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(0xf<<2) | (1<<8), 1,
@@ -2471,7 +2471,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read_capacity(fsg, bh);
 		break;
 
-	case SC_READ_HEADER:
+	case READ_HEADER:
 		if (!mod_data.cdrom)
 			goto unknown_cmnd;
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
@@ -2481,7 +2481,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read_header(fsg, bh);
 		break;
 
-	case SC_READ_TOC:
+	case READ_TOC:
 		if (!mod_data.cdrom)
 			goto unknown_cmnd;
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
@@ -2491,7 +2491,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read_toc(fsg, bh);
 		break;
 
-	case SC_READ_FORMAT_CAPACITIES:
+	case READ_FORMAT_CAPACITIES:
 		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7), 1,
@@ -2499,7 +2499,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_read_format_capacities(fsg, bh);
 		break;
 
-	case SC_REQUEST_SENSE:
+	case REQUEST_SENSE:
 		fsg->data_size_from_cmnd = fsg->cmnd[4];
 		if ((reply = check_command(fsg, 6, DATA_DIR_TO_HOST,
 				(1<<4), 0,
@@ -2507,7 +2507,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_request_sense(fsg, bh);
 		break;
 
-	case SC_START_STOP_UNIT:
+	case START_STOP:
 		fsg->data_size_from_cmnd = 0;
 		if ((reply = check_command(fsg, 6, DATA_DIR_NONE,
 				(1<<1) | (1<<4), 0,
@@ -2515,7 +2515,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_start_stop(fsg);
 		break;
 
-	case SC_SYNCHRONIZE_CACHE:
+	case SYNCHRONIZE_CACHE:
 		fsg->data_size_from_cmnd = 0;
 		if ((reply = check_command(fsg, 10, DATA_DIR_NONE,
 				(0xf<<2) | (3<<7), 1,
@@ -2523,7 +2523,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_synchronize_cache(fsg);
 		break;
 
-	case SC_TEST_UNIT_READY:
+	case TEST_UNIT_READY:
 		fsg->data_size_from_cmnd = 0;
 		reply = check_command(fsg, 6, DATA_DIR_NONE,
 				0, 1,
@@ -2532,7 +2532,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 
 	/* Although optional, this command is used by MS-Windows.  We
 	 * support a minimal version: BytChk must be 0. */
-	case SC_VERIFY:
+	case VERIFY:
 		fsg->data_size_from_cmnd = 0;
 		if ((reply = check_command(fsg, 10, DATA_DIR_NONE,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
@@ -2540,7 +2540,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_verify(fsg);
 		break;
 
-	case SC_WRITE_6:
+	case WRITE_6:
 		i = fsg->cmnd[4];
 		fsg->data_size_from_cmnd = (i == 0 ? 256 : i) << 9;
 		if ((reply = check_command(fsg, 6, DATA_DIR_FROM_HOST,
@@ -2549,7 +2549,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_write(fsg);
 		break;
 
-	case SC_WRITE_10:
+	case WRITE_10:
 		fsg->data_size_from_cmnd =
 				get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
@@ -2558,7 +2558,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 			reply = do_write(fsg);
 		break;
 
-	case SC_WRITE_12:
+	case WRITE_12:
 		fsg->data_size_from_cmnd =
 				get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_FROM_HOST,
@@ -2571,10 +2571,10 @@ static int do_scsi_command(struct fsg_dev *fsg)
 	 * They don't mean much in this setting.  It's left as an exercise
 	 * for anyone interested to implement RESERVE and RELEASE in terms
 	 * of Posix locks. */
-	case SC_FORMAT_UNIT:
-	case SC_RELEASE:
-	case SC_RESERVE:
-	case SC_SEND_DIAGNOSTIC:
+	case FORMAT_UNIT:
+	case RELEASE:
+	case RESERVE:
+	case SEND_DIAGNOSTIC:
 		// Fall through
 
 	default:
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 0a7df3d..3b513ba 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -53,8 +53,9 @@
  */
 
 
-#include <asm/unaligned.h>
 #include <linux/usb/storage.h>
+#include <scsi/scsi.h>
+#include <asm/unaligned.h>
 
 
 /*
@@ -153,10 +154,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-/* SCSI device types */
-#define TYPE_DISK	0x00
-#define TYPE_CDROM	0x05
-
 /* Bulk-only data structures */
 
 /* Command Block Wrapper */
@@ -208,33 +205,6 @@ struct interrupt_data {
 /* Length of a SCSI Command Data Block */
 #define MAX_COMMAND_SIZE	16
 
-/* SCSI commands that we recognize */
-#define SC_FORMAT_UNIT			0x04
-#define SC_INQUIRY			0x12
-#define SC_MODE_SELECT_6		0x15
-#define SC_MODE_SELECT_10		0x55
-#define SC_MODE_SENSE_6			0x1a
-#define SC_MODE_SENSE_10		0x5a
-#define SC_PREVENT_ALLOW_MEDIUM_REMOVAL	0x1e
-#define SC_READ_6			0x08
-#define SC_READ_10			0x28
-#define SC_READ_12			0xa8
-#define SC_READ_CAPACITY		0x25
-#define SC_READ_FORMAT_CAPACITIES	0x23
-#define SC_READ_HEADER			0x44
-#define SC_READ_TOC			0x43
-#define SC_RELEASE			0x17
-#define SC_REQUEST_SENSE		0x03
-#define SC_RESERVE			0x16
-#define SC_SEND_DIAGNOSTIC		0x1d
-#define SC_START_STOP_UNIT		0x1b
-#define SC_SYNCHRONIZE_CACHE		0x35
-#define SC_TEST_UNIT_READY		0x00
-#define SC_VERIFY			0x2f
-#define SC_WRITE_6			0x0a
-#define SC_WRITE_10			0x2a
-#define SC_WRITE_12			0xaa
-
 /* SCSI Sense Key/Additional Sense Code/ASC Qualifier values */
 #define SS_NO_SENSE				0
 #define SS_COMMUNICATION_FAILURE		0x040800
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d63533a..216af85 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -73,6 +73,7 @@ struct scsi_cmnd;
 #define SEND_DIAGNOSTIC       0x1d
 #define ALLOW_MEDIUM_REMOVAL  0x1e
 
+#define READ_FORMAT_CAPACITIES 0x23
 #define SET_WINDOW            0x24
 #define READ_CAPACITY         0x25
 #define READ_10               0x28
@@ -102,6 +103,7 @@ struct scsi_cmnd;
 #define WRITE_SAME            0x41
 #define UNMAP		      0x42
 #define READ_TOC              0x43
+#define READ_HEADER           0x44
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
 #define XDWRITEREAD_10        0x53
-- 
1.7.1

