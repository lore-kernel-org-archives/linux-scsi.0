From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: 22 Jun 2003 15:37:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056314343.10846.93.camel@mulgrave>
References: <20030621165920.F2811@one-eyed-alien.net>
	<1056241551.1775.14.camel@mulgrave>
	<20030621174640.M2811@one-eyed-alien.net>
	<1056250487.1775.58.camel@mulgrave>
	<20030621212406.N2811@one-eyed-alien.net>
	<1056290282.1979.4.camel@mulgrave>
	<20030622124917.A21716@one-eyed-alien.net>
	<20030622125650.D21716@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-o8vbK74zCDNBLtK4X+hY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:53510 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265865AbTFVUZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 16:25:20 -0400
In-Reply-To: <20030622125650.D21716@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--=-o8vbK74zCDNBLtK4X+hY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2003-06-22 at 14:56, Matthew Dharm wrote:
> > But (as I read it -- remember I'm not an expert), the old sr.c code didn't
> > set the DBD bit, just like the new code.  So whatever formula applied to
> > the old code should apply to the new code, yes?

Hmm, the diff I sent was an older one which had the dbd meaning
inverted.  The attached is the one I'm actually testing.

> The code James sent sets DBD to 0 -- I like that, as many usb-storage
> devices choke when DBD is set to 1.  I believe in avoiding the DBD bit as
> much as possible, and James seems to have eliminated it.
> 
> However, DBD==0 means that a block descriptor is likely to be returned --
> so we need to add in the size of the block descriptor header.

OK, now I'm confused.  the write caching determination code that you and
Andries spent a while getting to work has DBD==1, and I thought we'd
eliminated all the USB problems with that code...

Since the BD skip code is quite a wodge of complexity, I'd like to know
what devices fail on DBD==1 before trying to add it all in, especially
as we (fortunatly) have nothing in the kernel that actually wants to see
the BDs.

James


--=-o8vbK74zCDNBLtK4X+hY
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/sd.c 1.123 vs edited =3D=3D=3D=3D=3D
--- 1.123/drivers/scsi/sd.c	Tue Jun 17 04:17:15 2003
+++ edited/drivers/scsi/sd.c	Sun Jun 22 09:21:16 2003
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
+		 unsigned char *buffer, int len)
+{
+	return scsi_do_mode_sense(SRpnt, dbd, modepage, buffer, len,
+				  SD_TIMEOUT, SD_MAX_RETRIES);
 }
=20
 /*
@@ -1119,20 +1091,20 @@
 	 * When only page 0 is implemented, a request for page 3F may return
 	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
 	 */
-	if (res)
+	if (res =3D=3D 0)
 		res =3D sd_do_mode_sense(SRpnt, 0, 0, buffer, 4);
=20
 	/*
 	 * Third attempt: ask 255 bytes, as we did earlier.
 	 */
-	if (res)
+	if (res =3D=3D 0)
 		res =3D sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255);
=20
-	if (res) {
+	if (res =3D=3D 0) {
 		printk(KERN_WARNING
 		       "%s: test WP failed, assume Write Enabled\n", diskname);
 	} else {
-		sdkp->write_prot =3D ((buffer[2] & 0x80) !=3D 0);
+		sdkp->write_prot =3D ((buffer[res =3D=3D 4 ? 2 : 3] & 0x80) !=3D 0);
 		printk(KERN_NOTICE "%s: Write Protect is %s\n", diskname,
 		       sdkp->write_prot ? "on" : "off");
 		printk(KERN_DEBUG "%s: Mode Sense: %02x %02x %02x %02x\n",
@@ -1155,37 +1127,37 @@
 	/* cautiously ask */
 	res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4);
=20
-	if (res =3D=3D 0) {
+	if (res !=3D 0) {
 		/* that went OK, now ask for the proper length */
-		len =3D buffer[0] + 1;
+		if(res =3D=3D 4)=20
+			len =3D buffer[0] + 1;
+		else
+			len =3D buffer[0]*256 + buffer[1] + 2;
 		if (len > 128)
 			len =3D 128;
 		res =3D sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len);
 	}
=20
-	if (res =3D=3D 0 && buffer[3] + 6 < len) {
+	if (res !=3D 0) {
 		const char *types[] =3D {
 			"write through", "none", "write back",
 			"write back, no read (daft)"
 		};
 		int ct =3D 0;
-		int offset =3D buffer[3] + 4; /* start of mode page */
=20
-		sdkp->WCE =3D ((buffer[offset + 2] & 0x04) !=3D 0);
-		sdkp->RCD =3D ((buffer[offset + 2] & 0x01) !=3D 0);
+		sdkp->WCE =3D ((buffer[res + 2] & 0x04) !=3D 0);
+		sdkp->RCD =3D ((buffer[res + 2] & 0x01) !=3D 0);
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
=3D=3D=3D=3D=3D drivers/scsi/sr.c 1.82 vs edited =3D=3D=3D=3D=3D
--- 1.82/drivers/scsi/sr.c	Mon Jun 16 19:22:18 2003
+++ edited/drivers/scsi/sr.c	Sun Jun 22 09:06:02 2003
@@ -660,7 +660,6 @@
=20
 static void get_capabilities(struct scsi_cd *cd)
 {
-	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
 	int rc, n;
=20
@@ -681,18 +680,10 @@
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
+	rc =3D scsi_mode_sense(cd->device, 0x08, 0x2a, buffer, 128,
+			     SR_TIMEOUT, 3);
=20
-	if (rc) {
+	if (rc =3D=3D 0) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed =3D 1;
 		cd->cdi.mask |=3D (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
@@ -702,7 +693,7 @@
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
 	}
-	n =3D buffer[3] + 4;
+	n =3D rc;
 	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known =3D 1;
 	cd->readcd_cdda =3D buffer[n + 5] & 0x01;
=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.95 vs edited =3D=3D=3D=3D=3D
--- 1.95/drivers/scsi/scsi_lib.c	Wed Jun  4 06:43:01 2003
+++ edited/drivers/scsi/scsi_lib.c	Sun Jun 22 15:26:15 2003
@@ -1336,3 +1336,105 @@
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
+ *
+ *	Returns zero if unsuccessful, or the header offset (either 4
+ *	or 8 depending on whether a six or ten byte command was
+ *	issued) if successful.
+ **/
+int
+scsi_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
+		   unsigned char *buffer, int len, int timeout, int retries) {
+	unsigned char cmd[12];
+	int use_10_for_ms;
+	int header_offset;
+
+	memset((void *) &cmd[0], 0, 12);
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
+		header_offset =3D 8;
+	} else {
+		if (len < 4)
+			len =3D 4;
+
+		cmd[0] =3D MODE_SENSE;
+		cmd[4] =3D len;
+		header_offset =3D 4;
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
+	return scsi_status_is_good(SRpnt->sr_result) ? header_offset : 0;
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
+		unsigned char *buffer, int len, int timeout, int retries)
+{
+	struct scsi_request *sreq =3D scsi_allocate_request(sdev);
+	int ret;
+
+	if (!sreq)
+		return 0;
+
+	ret =3D scsi_do_mode_sense(sreq, dbd, modepage, buffer, len,
+				 timeout, retries);
+
+	scsi_release_request(sreq);
+
+	return ret;
+}
=3D=3D=3D=3D=3D drivers/scsi/scsi_syms.c 1.40 vs edited =3D=3D=3D=3D=3D
--- 1.40/drivers/scsi/scsi_syms.c	Thu Jun  5 06:26:04 2003
+++ edited/drivers/scsi/scsi_syms.c	Sat Jun 21 20:52:12 2003
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

--=-o8vbK74zCDNBLtK4X+hY--

