From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 20 Apr 2003 14:33:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030420143351.C20891@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:9485 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263705AbTDTVWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Apr 2003 17:22:04 -0400
Content-Disposition: inline
In-Reply-To: <1049556643.1762.16.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 05, 2003 at 09:30:41AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

How about this patch?  It is based on James' work, but I cleaned up the
comments a bit and eliminated a structure which was used to only hold two
elements.  I also added a filter type and fixed the symbol problems when
modules were used.

I've tested this, and it works well.  Linus, if you'll take this I've got
several more patches -- ones to make usb-storage use this to cut some
undesireable commands, and one to fix up the INQUIRY probing in scsi_scan.c
to be compatible with the filter code.

Linus, please apply this to 2.5.

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.670   -> 1.671 =20
#	drivers/scsi/scsi_syms.c	1.20    -> 1.21  =20
#	 drivers/scsi/scsi.h	1.31    -> 1.32  =20
#	drivers/scsi/scsi_lib.c	1.34    -> 1.35  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/19	mdharm@zen.san.one-eyed-alien.net	1.671
# Added SCSI command filter.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sat Apr 19 17:16:59 2003
+++ b/drivers/scsi/scsi.h	Sat Apr 19 17:16:59 2003
@@ -960,4 +960,52 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
=20
+/* SCSI command filter
+ *=20
+ * The 'command' array contains either (a) a SCSI command byte, or
+ * (b) an 'exception' rule.  These are distinguished by the high-byte;
+ * SCSI commands have 0 there, exceptions have some other value.
+ *
+ * Thus, *command < 0x100 is a SCSI command, >=3D 0x100 is an
+ * exception.  Exception codes are defined below.
+ *
+ * The format of the exceptions is:
+ *
+ * Bit 15: invert the specific condition
+ * Bit 14-12: Reserved
+ * Bit 11-8: command opcode (must be > 0)
+ * Bit 7-0: Command specific
+ */
+
+/* set filter type to whitelist or blacklist filtering */
+enum scsi_cmd_filter_type {
+	SCSI_FILTER_WHITELIST, SCSI_FILTER_BLACKLIST
+};
+
+extern int scsi_filter_cmd(struct scsi_cmnd *,
+		enum scsi_cmd_filter_type, unsigned short* );
+
+/* exception definitions for the filter */
+#define SCSI_FILTER_INVERT		0x8000
+
+/* opcodes for the filter */
+#define SCSI_FILTER_INQUIRY_LEN		0x0100
+#define SCSI_FILTER_INQUIRY_EVPD	0x0200
+
+/* marker for end of filter list */
+#define SCSI_FILTER_LIST_END		0xFFFF
+
+/* useful filter commands */
+#define SCSI_FILTER_INQUIRY_36		(SCSI_FILTER_INQUIRY_LEN | 36)
+#define SCSI_FILTER_INQUIRY_NOT36	(SCSI_FILTER_INVERT | SCSI_FILTER_INQUIR=
Y_36)
+#define SCSI_FILTER_INQUIRY_NOT_EVPD	(SCSI_FILTER_INVERT | SCSI_FILTER_INQ=
UIRY_EVPD)
+
+static inline unsigned short scsi_filter_opcode(unsigned short command) {
+	return command & 0x7f00;
+}
+
+static inline unsigned char scsi_filter_data(unsigned short command) {
+	return (unsigned char)(command & 0x00ff);
+}
+
 #endif /* _SCSI_H */
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Sat Apr 19 17:16:59 2003
+++ b/drivers/scsi/scsi_lib.c	Sat Apr 19 17:16:59 2003
@@ -1368,3 +1368,89 @@
 		kmem_cache_destroy(sgp->slab);
 	}
 }
+
+static inline int scsi_filter_exceptions(struct scsi_cmnd *cmd,
+					 unsigned short command)
+{
+	int found =3D 0;
+
+	/* specials begin at 0x100 */
+	if(command < 0x100)
+		return 0;
+
+	/* we check for inversion in each switch so that we can define each
+	 * test to act only on a specific subset of commands
+	 */
+	switch(scsi_filter_opcode(command)) {
+	case SCSI_FILTER_INQUIRY_EVPD:
+		if(cmd->cmnd[0] =3D=3D INQUIRY) {
+			/* is EVPD bit set? */
+			found =3D (cmd->cmnd[1] & 0x1);
+
+			/* now check for inversion */
+			if(command & SCSI_FILTER_INVERT)
+				found =3D !found;
+		}
+		break;
+	case SCSI_FILTER_INQUIRY_LEN:
+		if(cmd->cmnd[0] =3D=3D INQUIRY) {
+			/* does the transfer length match the data */
+			found =3D (cmd->cmnd[4] =3D=3D scsi_filter_data(command));
+
+			/* now check for inversion */
+			if(command & SCSI_FILTER_INVERT)
+				found =3D !found;
+		}
+		break;
+	default:
+		/* unrecognized filter */
+		break;
+	}
+
+	return found;
+}
+
+/**
+ * scsi_filter_cmd - Filter a given command against a list
+ * @cmd: command to be filtered.
+ * @filter: pointer to the filter containing the type (black/white list) a=
nd
+ * zero terminated list of commands to filter against (first byte only).  =
See
+ * scsi.h for details on the filter structure.
+ *
+ * Returns 0 if the filter passed successfully and the driver can continue
+ * processing the command or 1 if the filter failed and the command should
+ * be finished (via ->scsi_done).  In the latter case, the command will ha=
ve
+ * the sense fields filled in indicating the correct sense for an illegal
+ * request.
+ **/
+int scsi_filter_cmd(struct scsi_cmnd *cmd, enum scsi_cmd_filter_type type,
+		unsigned short* command)
+{
+	int found =3D 0;
+
+	/* search command list for a match */
+	for( ; *command !=3D SCSI_FILTER_LIST_END; command++) {
+		found =3D scsi_filter_exceptions(cmd, *command);
+		found +=3D (cmd->cmnd[0] =3D=3D *command);
+		if(found)
+			break;
+	}
+
+	/* pass behavior -- found on a whitelist or not found on a blacklist */
+	if((found && type =3D=3D SCSI_FILTER_WHITELIST) ||
+	   (!found && type =3D=3D SCSI_FILTER_BLACKLIST))
+		return 0;
+
+	/* fill in the Check Condition/Illegal request */
+	cmd->result =3D SAM_STAT_CHECK_CONDITION;
+	memset(cmd->sense_buffer, '\0', sizeof(cmd->sense_buffer));
+	cmd->sense_buffer[0] =3D 0xF0; /* valid, response code 0x70 */
+	cmd->sense_buffer[2] =3D ILLEGAL_REQUEST;
+
+	/* ASC 0x20, ASCQ 0x00: Invalid command operation code */
+	cmd->sense_buffer[12] =3D 0x20;
+	cmd->sense_buffer[13] =3D 0x00;
+
+	return 1;
+}
+=09
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Sat Apr 19 17:16:59 2003
+++ b/drivers/scsi/scsi_syms.c	Sat Apr 19 17:16:59 2003
@@ -55,6 +55,7 @@
 #if defined(CONFIG_SCSI_LOGGING)	/* { */
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
+EXPORT_SYMBOL(scsi_filter_cmd);
=20
 EXPORT_SYMBOL(scsi_allocate_request);
 EXPORT_SYMBOL(scsi_release_request);

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Would you mind not using our Web server? We're trying to have a game of=20
Quake here.
					-- Greg
User Friendly, 5/11/1998

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+oxI/IjReC7bSPZARAnvOAKDTqBwmR6MmDdhINhdmLXGjCbAUywCfXwoG
VJgUs21vFaVCR/LFwCCEhMk=
=LQfN
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
