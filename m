From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] definitive abstraction of the mode_sense commands
Date: 23 Jun 2003 23:31:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056429111.2887.173.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-b4I5km03k05w28uHlTpn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:2054 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265656AbTFXERo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 00:17:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>


--=-b4I5km03k05w28uHlTpn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The attached is an extension of the previous abstraction patch so that
one of the returns is now a command size independent view of the mode
sense header.  Thus it should now be easy to process even non DBD mode
sense commands whatever command size is chosen by the device.

James


--=-b4I5km03k05w28uHlTpn
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1408  -> 1.1409=20
#	include/scsi/scsi_device.h	1.1     -> 1.2   =20
#	   drivers/scsi/sr.c	1.82    -> 1.83  =20
#	drivers/scsi/scsi_syms.c	1.40    -> 1.41  =20
#	drivers/scsi/scsi_lib.c	1.95    -> 1.96  =20
#	   drivers/scsi/sd.c	1.123   -> 1.124 =20
#	include/scsi/scsi_request.h	1.1     -> 1.2   =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/23	jejb@raven.il.steeleye.com	1.1409
# SCSI: abstract mode_sense 6 and 10 out completely
#=20
# Move the mode_sense request routines to a central location and make
# all block device consumers use it.  Also abstract the header as
# part of the return to hide the 6/10 differences.
#=20
# Note: Requestors of the Block Descriptors now must pay attention
# to the longlba flag
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Jun 23 23:30:02 2003
+++ b/drivers/scsi/scsi_lib.c	Mon Jun 23 23:30:02 2003
@@ -1336,3 +1336,126 @@
 		kmem_cache_destroy(sgp->slab);
 	}
 }
+/**	scsi_do_mode_sense - issue a mode sense, falling back from 10 to=20
+ *		six bytes if necessary.
+ *	@SRpnt:	SCSI request to fill in with the MODE_SENSE
+ *	@dbd:	set if mode sense will allow block descriptors to be returned
+ *	@modepage: mode page being requested
+ *	@buffer: request buffer (may not be smaller than eight bytes)
+ *	@len:	length of request buffer.
+ *	@timeout: command timeout
+ *	@retries: number of retries before failing
+ *	@data: returns a structure abstracting the mode header data
+ *
+ *	Returns zero if unsuccessful, or the header offset (either 4
+ *	or 8 depending on whether a six or ten byte command was
+ *	issued) if successful.
+ **/
+int
+scsi_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
+		   unsigned char *buffer, int len, int timeout, int retries,
+		   struct scsi_mode_data *data) {
+	unsigned char cmd[12];
+	int use_10_for_ms;
+	int header_length;
+
+	memset(data, 0, sizeof(*data));
+	memset(&cmd[0], 0, 12);
+	cmd[1] =3D dbd ? 0x08: 0;
+	cmd[2] =3D modepage;
+
+ retry:
+	use_10_for_ms =3D SRpnt->sr_device->use_10_for_ms;
+
+	if (use_10_for_ms) {
+		if (len < 8)
+			len =3D 8;
+
+		cmd[0] =3D MODE_SENSE_10;
+		cmd[8] =3D len;
+		header_length =3D 8;
+	} else {
+		if (len < 4)
+			len =3D 4;
+
+		cmd[0] =3D MODE_SENSE;
+		cmd[4] =3D len;
+		header_length =3D 4;
+	}
+
+	SRpnt->sr_cmd_len =3D 0;
+	SRpnt->sr_sense_buffer[0] =3D 0;
+	SRpnt->sr_sense_buffer[2] =3D 0;
+	SRpnt->sr_data_direction =3D SCSI_DATA_READ;
+
+	memset((void *) buffer, 0, len);
+
+	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
+		      len, timeout, retries);
+
+	/* This code looks awful: what it's doing is making sure an
+	 * ILLEGAL REQUEST sense return identifies the actual command
+	 * byte as the problem.  MODE_SENSE commands can return
+	 * ILLEGAL REQUEST if the code page isn't supported */
+	if (use_10_for_ms && ! scsi_status_is_good(SRpnt->sr_result) &&
+	    (driver_byte(SRpnt->sr_result) & DRIVER_SENSE) &&
+	    SRpnt->sr_sense_buffer[2] =3D=3D ILLEGAL_REQUEST &&
+	    (SRpnt->sr_sense_buffer[4] & 0x40) =3D=3D 0x40 &&
+	    SRpnt->sr_sense_buffer[5] =3D=3D 0 &&
+	    SRpnt->sr_sense_buffer[6] =3D=3D 0 ) {
+		SRpnt->sr_device->use_10_for_ms =3D 0;
+		goto retry;
+	}
+
+	if(scsi_status_is_good(SRpnt->sr_result)) {
+		data->header_length =3D header_length;
+		if(use_10_for_ms) {
+			data->length =3D buffer[0]*256 + buffer[1];
+			data->medium_type =3D buffer[2];
+			data->device_specific =3D buffer[3];
+			data->longlba =3D buffer[4] & 0x01;
+			data->block_descriptor_length =3D buffer[6]*256
+				+ buffer[7];
+		} else {
+			data->length =3D buffer[0];
+			data->medium_type =3D buffer[1];
+			data->device_specific =3D buffer[3];
+			data->block_descriptor_length =3D buffer[4];
+		}
+	}
+
+	return SRpnt->sr_result;
+}
+
+/**	scsi_mode_sense - issue a mode sense, falling back from 10 to=20
+ *		six bytes if necessary.
+ *	@sdev:	scsi device to send command to.
+ *	@dbd:	set if mode sense will allow block descriptors to be returned
+ *	@modepage: mode page being requested
+ *	@buffer: request buffer (may not be smaller than eight bytes)
+ *	@len:	length of request buffer.
+ *	@timeout: command timeout
+ *	@retries: number of retries before failing
+ *
+ *	Returns zero if unsuccessful, or the header offset (either 4
+ *	or 8 depending on whether a six or ten byte command was
+ *	issued) if successful.
+ **/
+int
+scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+		unsigned char *buffer, int len, int timeout, int retries,
+		struct scsi_mode_data *data)
+{
+	struct scsi_request *sreq =3D scsi_allocate_request(sdev);
+	int ret;
+
+	if (!sreq)
+		return 0;
+
+	ret =3D scsi_do_mode_sense(sreq, dbd, modepage, buffer, len,
+				 timeout, retries, data);
+
+	scsi_release_request(sreq);
+
+	return ret;
+}
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Mon Jun 23 23:30:02 2003
+++ b/drivers/scsi/scsi_syms.c	Mon Jun 23 23:30:02 2003
@@ -86,6 +86,9 @@
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_set_device_offline);
=20
+EXPORT_SYMBOL(scsi_do_mode_sense);
+EXPORT_SYMBOL(scsi_mode_sense);
+
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
  */
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Mon Jun 23 23:30:02 2003
+++ b/drivers/scsi/sd.c	Mon Jun 23 23:30:02 2003
@@ -1062,40 +1062,12 @@
 }
=20
 /* called with buffer of length 512 */
-static int
+static inline int
 sd_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
-		 unsigned char *buffer, int len) {
-	unsigned char cmd[12];
-
-	memset((void *) &cmd[0], 0, 12);
-	cmd[1] =3D dbd;
-	cmd[2] =3D modepage;
-
-	if (SRpnt->sr_device->use_10_for_ms) {
-		if (len < 8)
-			len =3D 8;
-
-		cmd[0] =3D MODE_SENSE_10;
-		cmd[8] =3D len;
-	} else {
-		if (len < 4)
-			len =3D 4;
-
-		cmd[0] =3D MODE_SENSE;
-		cmd[4] =3D len;
-	}
-
-	SRpnt->sr_cmd_len =3D 0;
-	SRpnt->sr_sense_buffer[0] =3D 0;
-	SRpnt->sr_sense_buffer[2] =3D 0;
-	SRpnt->sr_data_direction =3D SCSI_DATA_READ;
-
-	memset((void *) buffer, 0, len);
-
-	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-		      len, SD_TIMEOUT, SD_MAX_RETRIES);
-
-	return SRpnt->sr_result;
+		 unsigned char *buffer, int len, struct scsi_mode_data *data)
+{
+	return scsi_do_mode_sense(SRpnt, dbd, modepage, buffer, len,
+				  SD_TIMEOUT, SD_MAX_RETRIES, data);
 }
=20
 /*
@@ -1106,33 +1078,34 @@
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int res;
+	struct scsi_mode_data data;
=20
 	/*
 	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 	 * We have to start carefully: some devices hang if we ask
 	 * for more than is available.
 	 */
-	res =3D sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4);
+	res =3D sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
=20
 	/*
 	 * Second attempt: ask for page 0
 	 * When only page 0 is implemented, a request for page 3F may return
 	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
 	 */
-	if (res)
-		res =3D sd_do_mode_sense(SRpnt, 0, 0, buffer, 4);
+	if (!scsi_status_is_good(res))
+		res =3D sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
=20
 	/*
 	 * Third attempt: ask 255 bytes, as we did earlier.
 	 */
-	if (res)
-		res =3D sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255);
+	if (!scsi_status_is_good(res))
+		res =3D sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
=20
-	if (res) {
+	if (!scsi_status_is_good(res)) {
 		printk(KERN_WARNING
 		       "%s: test WP failed, assume Write Enabled\n", diskname);
 	} else {
-		sdkp->write_prot =3D ((buffer[2] & 0x80) !=3D 0);
+		sdkp->write_prot =3D ((data.device_specific & 0x80) !=3D 0);
 		printk(KERN_NOTICE "%s: Write Protect is %s\n", diskname,
 		       sdkp->write_prot ? "on" : "off");
 		printk(KERN_DEBUG "%s: Mode Sense: %02x %02x %02x %02x\n",
@@ -1151,41 +1124,43 @@
=20
 	const int dbd =3D 0x08;	   /* DBD */
 	const int modepage =3D 0x08; /* current values, cache page */
+	struct scsi_mode_data data;
+
=20
 	/* cautiously ask */
-	res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4);
+	res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
=20
-	if (res =3D=3D 0) {
+	if (scsi_status_is_good(res)) {
 		/* that went OK, now ask for the proper length */
-		len =3D buffer[0] + 1;
+		len =3D data.length;
 		if (len > 128)
 			len =3D 128;
-		res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len);
+		res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
+				       len, &data);
 	}
=20
-	if (res =3D=3D 0 && buffer[3] + 6 < len) {
+	if (scsi_status_is_good(res)) {
 		const char *types[] =3D {
 			"write through", "none", "write back",
 			"write back, no read (daft)"
 		};
 		int ct =3D 0;
-		int offset =3D buffer[3] + 4; /* start of mode page */
+		int offset =3D data.header_length +
+			data.block_descriptor_length + 2;
=20
-		sdkp->WCE =3D ((buffer[offset + 2] & 0x04) !=3D 0);
-		sdkp->RCD =3D ((buffer[offset + 2] & 0x01) !=3D 0);
+		sdkp->WCE =3D ((buffer[offset] & 0x04) !=3D 0);
+		sdkp->RCD =3D ((buffer[offset] & 0x01) !=3D 0);
=20
 		ct =3D  sdkp->RCD + 2*sdkp->WCE;
=20
 		printk(KERN_NOTICE "SCSI device %s: drive cache: %s\n",
 		       diskname, types[ct]);
 	} else {
-		if (res =3D=3D 0 ||
-		    (status_byte(res) =3D=3D CHECK_CONDITION
-		     && (SRpnt->sr_sense_buffer[0] & 0x70) =3D=3D 0x70
+		if ((SRpnt->sr_sense_buffer[0] & 0x70) =3D=3D 0x70
 		     && (SRpnt->sr_sense_buffer[2] & 0x0f) =3D=3D ILLEGAL_REQUEST
 		     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
 		     && SRpnt->sr_sense_buffer[12] =3D=3D 0x24
-		     && SRpnt->sr_sense_buffer[13] =3D=3D 0x00)) {
+		     && SRpnt->sr_sense_buffer[13] =3D=3D 0x00) {
 			printk(KERN_NOTICE "%s: cache data unavailable\n",
 			       diskname);
 		} else {
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Mon Jun 23 23:30:02 2003
+++ b/drivers/scsi/sr.c	Mon Jun 23 23:30:02 2003
@@ -660,9 +660,9 @@
=20
 static void get_capabilities(struct scsi_cd *cd)
 {
-	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
 	int rc, n;
+	struct scsi_mode_data data;
=20
 	static char *loadmech[] =3D
 	{
@@ -681,18 +681,10 @@
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
 	}
-	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
-	cgc.cmd[0] =3D MODE_SENSE;
-	cgc.cmd[2] =3D 0x2a;
-	cgc.cmd[4] =3D 128;
-	cgc.buffer =3D buffer;
-	cgc.buflen =3D 128;
-	cgc.quiet =3D 1;
-	cgc.data_direction =3D SCSI_DATA_READ;
-	cgc.timeout =3D SR_TIMEOUT;
-	rc =3D sr_do_ioctl(cd, &cgc);
+	rc =3D scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
+			     SR_TIMEOUT, 3, &data);
=20
-	if (rc) {
+	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed =3D 1;
 		cd->cdi.mask |=3D (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
@@ -702,7 +694,7 @@
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
 	}
-	n =3D buffer[3] + 4;
+	n =3D data.header_length + data.block_descriptor_length;
 	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known =3D 1;
 	cd->readcd_cdda =3D buffer[n + 5] & 0x01;
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Mon Jun 23 23:30:02 2003
+++ b/include/scsi/scsi_device.h	Mon Jun 23 23:30:02 2003
@@ -103,4 +103,9 @@
=20
 extern int scsi_set_medium_removal(struct scsi_device *, char);
=20
+struct scsi_mode_data;
+extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage=
,
+			   unsigned char *buffer, int len, int timeout,
+			   int retries, struct scsi_mode_data *data);
+
 #endif /* _SCSI_SCSI_DEVICE_H */
diff -Nru a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- a/include/scsi/scsi_request.h	Mon Jun 23 23:30:02 2003
+++ b/include/scsi/scsi_request.h	Mon Jun 23 23:30:02 2003
@@ -55,4 +55,19 @@
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
=20
+struct scsi_mode_data {
+	__u16	length;
+	__u16	block_descriptor_length;
+	__u8	medium_type;
+	__u8	device_specific;
+	__u8	header_length;
+	__u8	longlba:1;
+};
+
+extern int scsi_do_mode_sense(struct scsi_request *SRpnt, int dbd,
+			      int modepage, unsigned char *buffer, int len,
+			      int timeout, int retries,
+			      struct scsi_mode_data *data);
+
+
 #endif /* _SCSI_SCSI_REQUEST_H */

--=-b4I5km03k05w28uHlTpn--

