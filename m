From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] definitive abstraction of the mode_sense commands
Date: 24 Jun 2003 12:58:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056477523.2085.170.camel@mulgrave>
References: <1056429111.2887.173.camel@mulgrave>
	<3EF80775.9020105@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-85PO1I/Kw3DeKroTi8C8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:31750 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262262AbTFXRpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 13:45:07 -0400
In-Reply-To: <3EF80775.9020105@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-85PO1I/Kw3DeKroTi8C8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I fixed your comments (I did have DBD's meaning reversed when I first
made the patch---I fixed it all except for the comment).

I also added the ability to pass LLBAA in the dbd part.

Plus some coding style fixes that certain persons noticed.

James


--=-85PO1I/Kw3DeKroTi8C8
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1408  -> 1.1414=20
#	include/scsi/scsi_device.h	1.1     -> 1.3   =20
#	   drivers/scsi/sr.c	1.82    -> 1.83  =20
#	drivers/scsi/scsi_syms.c	1.40    -> 1.42  =20
#	drivers/scsi/scsi_lib.c	1.95    -> 1.99  =20
#	   drivers/scsi/sd.c	1.123   -> 1.126 =20
#	include/scsi/scsi_request.h	1.1     -> 1.3   =20
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
# 03/06/24	jejb@raven.il.steeleye.com	1.1410
# Fix hch comments
# --------------------------------------------
# 03/06/24	jejb@raven.il.steeleye.com	1.1411
# Fix up export symbols
# --------------------------------------------
# 03/06/24	jejb@raven.il.steeleye.com	1.1412
# More fix ups
# --------------------------------------------
# 03/06/24	jejb@raven.il.steeleye.com	1.1413
# Minor fixes
# --------------------------------------------
# 03/06/24	jejb@raven.il.steeleye.com	1.1414
# More fixes
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Tue Jun 24 12:55:16 2003
+++ b/drivers/scsi/scsi_lib.c	Tue Jun 24 12:55:16 2003
@@ -1336,3 +1336,127 @@
 		kmem_cache_destroy(sgp->slab);
 	}
 }
+/**
+ *	__scsi_mode_sense - issue a mode sense, falling back from 10 to=20
+ *		six bytes if necessary.
+ *	@sreq:	SCSI request to fill in with the MODE_SENSE
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
+__scsi_mode_sense(struct scsi_request *sreq, int dbd, int modepage,
+		  unsigned char *buffer, int len, int timeout, int retries,
+		  struct scsi_mode_data *data) {
+	unsigned char cmd[12];
+	int use_10_for_ms;
+	int header_length;
+
+	memset(data, 0, sizeof(*data));
+	memset(&cmd[0], 0, 12);
+	cmd[1] =3D dbd & 0x18;	/* allows DBD and LLBA bits */
+	cmd[2] =3D modepage;
+
+ retry:
+	use_10_for_ms =3D sreq->sr_device->use_10_for_ms;
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
+	sreq->sr_cmd_len =3D 0;
+	sreq->sr_sense_buffer[0] =3D 0;
+	sreq->sr_sense_buffer[2] =3D 0;
+	sreq->sr_data_direction =3D SCSI_DATA_READ;
+
+	memset(buffer, 0, len);
+
+	scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
+
+	/* This code looks awful: what it's doing is making sure an
+	 * ILLEGAL REQUEST sense return identifies the actual command
+	 * byte as the problem.  MODE_SENSE commands can return
+	 * ILLEGAL REQUEST if the code page isn't supported */
+	if (use_10_for_ms && ! scsi_status_is_good(sreq->sr_result) &&
+	    (driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
+	    sreq->sr_sense_buffer[2] =3D=3D ILLEGAL_REQUEST &&
+	    (sreq->sr_sense_buffer[4] & 0x40) =3D=3D 0x40 &&
+	    sreq->sr_sense_buffer[5] =3D=3D 0 &&
+	    sreq->sr_sense_buffer[6] =3D=3D 0 ) {
+		sreq->sr_device->use_10_for_ms =3D 0;
+		goto retry;
+	}
+
+	if(scsi_status_is_good(sreq->sr_result)) {
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
+	return sreq->sr_result;
+}
+
+/**
+ *	scsi_mode_sense - issue a mode sense, falling back from 10 to=20
+ *		six bytes if necessary.
+ *	@sdev:	scsi device to send command to.
+ *	@dbd:	set if mode sense will disable block descriptors in the return
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
+		return -1;
+
+	ret =3D __scsi_mode_sense(sreq, dbd, modepage, buffer, len,
+				timeout, retries, data);
+
+	scsi_release_request(sreq);
+
+	return ret;
+}
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Tue Jun 24 12:55:16 2003
+++ b/drivers/scsi/scsi_syms.c	Tue Jun 24 12:55:16 2003
@@ -86,6 +86,9 @@
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_set_device_offline);
=20
+EXPORT_SYMBOL(__scsi_mode_sense);
+EXPORT_SYMBOL(scsi_mode_sense);
+
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
  */
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Tue Jun 24 12:55:16 2003
+++ b/drivers/scsi/sd.c	Tue Jun 24 12:55:16 2003
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
+	return __scsi_mode_sense(SRpnt, dbd, modepage, buffer, len,
+				 SD_TIMEOUT, SD_MAX_RETRIES, data);
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
@@ -1149,43 +1122,45 @@
 		   struct scsi_request *SRpnt, unsigned char *buffer) {
 	int len =3D 0, res;
=20
-	const int dbd =3D 0x08;	   /* DBD */
+	const int dbd =3D 0;	   /* DBD */
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
--- a/drivers/scsi/sr.c	Tue Jun 24 12:55:16 2003
+++ b/drivers/scsi/sr.c	Tue Jun 24 12:55:16 2003
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
--- a/include/scsi/scsi_device.h	Tue Jun 24 12:55:15 2003
+++ b/include/scsi/scsi_device.h	Tue Jun 24 12:55:15 2003
@@ -7,6 +7,7 @@
=20
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_mode_data;
=20
=20
 struct scsi_device {
@@ -102,5 +103,9 @@
 extern int scsi_track_queue_full(struct scsi_device *, int);
=20
 extern int scsi_set_medium_removal(struct scsi_device *, char);
+
+extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage=
,
+			   unsigned char *buffer, int len, int timeout,
+			   int retries, struct scsi_mode_data *data);
=20
 #endif /* _SCSI_SCSI_DEVICE_H */
diff -Nru a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- a/include/scsi/scsi_request.h	Tue Jun 24 12:55:16 2003
+++ b/include/scsi/scsi_request.h	Tue Jun 24 12:55:16 2003
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
+extern int __scsi_mode_sense(struct scsi_request *SRpnt, int dbd,
+			     int modepage, unsigned char *buffer, int len,
+			     int timeout, int retries,
+			     struct scsi_mode_data *data);
+
+
 #endif /* _SCSI_SCSI_REQUEST_H */

--=-85PO1I/Kw3DeKroTi8C8--

