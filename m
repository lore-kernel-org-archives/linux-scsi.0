From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: 2.6 PATCH: sr.c should issue TEST_UNIT_READY
Date: Mon, 1 Sep 2003 17:20:37 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030901172037.A27538@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: torvalds@osdl.org, Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The linux/drivers/scsi/sr.c code will issue a MODE_SENSE[_10] command to a
device as the first command sent to the device.  If the device has just
come out of reset, it will likely respond with a UNIT_ATTENTION/NOT_READY
status, which causes the MODE_SENSE to fail.  In fact, the device may have
several UNIT_ATTENTION conditions queued up (power-up reset, media change,
etc.)

This results in the mode page 0x2a data not being properly read and
interpreted.  As an end-effect, things like packet-writing don't work
(because the writeable bit is not set).

The solution to this is to issue one or more TEST_UNIT_READY commands to
the device to clear any pending UNIT_ATTENTION conditions.  This is the
technique used by sd.c -- in fact, this code was lifted directly from sd.c

At some point in the future, abstraction of this initial TEST_UNIT_READY
code between all high-level SCSI drivers may be apropriate.  For now, this
patch makes sr.c issue TEST_UNIT_READY to clear the UNIT_ATTENTION, thus
allowing the mode page 0x2a code to work properly.  Given the approaching
2.6.0-final release, I urge that this patch be accepted.

This has been tested with multiple usb-storage peripherals.  Please apply.

Matthew Dharm

=3D=3D=3D=3D=3D drivers/scsi/sr.c 1.53 vs edited =3D=3D=3D=3D=3D
--- 1.53/drivers/scsi/sr.c	Tue Aug 19 10:38:06 2003
+++ edited/drivers/scsi/sr.c	Mon Sep  1 13:28:41 2003
@@ -695,6 +695,10 @@
 	unsigned char *buffer;
 	int rc, n;
 	struct scsi_mode_data data;
+	struct scsi_request *SRpnt;
+	unsigned char cmd[MAX_COMMAND_SIZE];
+	unsigned int the_result;
+	int retries;
=20
 	static char *loadmech[] =3D
 	{
@@ -708,11 +712,46 @@
 		""
 	};
=20
+	/* allocate a request for the TEST_UNIT_READY */
+	SRpnt =3D scsi_allocate_request(cd->device);
+	if (!SRpnt) {
+		printk(KERN_WARNING "(get_capabilities:) Request allocation "
+		       "failure.\n");
+		return;
+	}
+
+	/* allocate transfer buffer */
 	buffer =3D kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
+		scsi_release_request(SRpnt);
 		return;
 	}
+
+	/* issue TEST_UNIT_READY until the initial startup UNIT_ATTENTION
+	 * conditions are gone, or a timeout happens
+	 */
+	retries =3D 0;
+	do {
+		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
+		cmd[0] =3D TEST_UNIT_READY;
+
+		SRpnt->sr_cmd_len =3D 0;
+		SRpnt->sr_sense_buffer[0] =3D 0;
+		SRpnt->sr_sense_buffer[2] =3D 0;
+		SRpnt->sr_data_direction =3D DMA_NONE;
+
+		scsi_wait_req (SRpnt, (void *) cmd, buffer,
+			       0, SR_TIMEOUT, MAX_RETRIES);
+
+		the_result =3D SRpnt->sr_result;
+		retries++;
+	} while (retries < 5 &&=20
+		 (!scsi_status_is_good(the_result) ||
+		  ((driver_byte(the_result) & DRIVER_SENSE) &&
+		   SRpnt->sr_sense_buffer[2] =3D=3D UNIT_ATTENTION)));
+
+	/* ask for mode page 0x2a */
 	rc =3D scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
 			     SR_TIMEOUT, 3, &data);
=20
@@ -722,6 +761,7 @@
 		cd->cdi.mask |=3D (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
 					 CDC_DVD | CDC_DVD_RAM |
 					 CDC_SELECT_DISC | CDC_SELECT_SPEED);
+		scsi_release_request(SRpnt);
 		kfree(buffer);
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
@@ -775,6 +815,7 @@
 	/*else    I don't think it can close its tray
 		cd->cdi.mask |=3D CDC_CLOSE_TRAY; */
=20
+	scsi_release_request(SRpnt);
 	kfree(buffer);
 }
=20
--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/U+JVIjReC7bSPZARAqDJAKCSkUWD1K2ILmhR2url94gGPI+jMgCgwFhI
j2f7cyzVgqyslTMK8Fg86xo=
=V6Rn
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
