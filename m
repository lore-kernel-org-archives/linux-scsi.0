From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 21 Apr 2003 11:28:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050942530.1772.12.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030420143351.C20891@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7M1y/8lG1fQTgUJemi6a"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42245 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261570AbTDUQRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 12:17:09 -0400
In-Reply-To: <20030420143351.C20891@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--=-7M1y/8lG1fQTgUJemi6a
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2003-04-20 at 16:33, Matthew Dharm wrote:
> How about this patch?  It is based on James' work, but I cleaned up the
> comments a bit and eliminated a structure which was used to only hold two
> elements.  I also added a filter type and fixed the symbol problems when
> modules were used.
> 
> I've tested this, and it works well.  Linus, if you'll take this I've got
> several more patches -- ones to make usb-storage use this to cut some
> undesireable commands, and one to fix up the INQUIRY probing in scsi_scan.c
> to be compatible with the filter code.
> 
> Linus, please apply this to 2.5.

Actually, you havn't folded any of the list feedback into your version. 
I've done the merger and collapsed the EVPD inquiry filter into a
qualifier of the inquiry filter (which seems more appropriate).

James


--=-7M1y/8lG1fQTgUJemi6a
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1131  -> 1.1134=20
#	 drivers/scsi/scsi.h	1.73    -> 1.76  =20
#	drivers/scsi/scsi_syms.c	1.30    -> 1.31  =20
#	drivers/scsi/scsi_lib.c	1.83    -> 1.86  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/21	jejb@raven.il.steeleye.com	1.1132
# Add a command filter to scsi_lib.c
#=20
# To facilitate emulated hosts rejecting commands they do not
# wish to process
# --------------------------------------------
# 03/04/21	mdharm-scsi@one-eyed-alien.net	1.1131.1.1
# [PATCH] Re: PATCH: exclude certain commands from emulated SCSI hosts
#=20
# --=3D-ubLHM6H8VjG+svJp0RLA
# Content-Disposition: inline
# Content-Type: text/plain; charset=3Dus-ascii
# Content-Transfer-Encoding: 8bit
#=20
# How about this patch?  It is based on James' work, but I cleaned up the
# comments a bit and eliminated a structure which was used to only hold two
# elements.  I also added a filter type and fixed the symbol problems when
# modules were used.
#=20
# I've tested this, and it works well.  Linus, if you'll take this I've got
# several more patches -- ones to make usb-storage use this to cut some
# undesireable commands, and one to fix up the INQUIRY probing in scsi_scan=
.c
# to be compatible with the filter code.
#=20
# Linus, please apply this to 2.5.
#=20
# Matt
#=20
# # This is a BitKeeper generated patch for the following project:
# # Project Name: greg k-h's linux 2.5 USB kernel tree
# # This patch format is intended for GNU patch command version 2.5 or high=
er.
# # This patch includes the following deltas:
# #	           ChangeSet	1.670   -> 1.671
# #	drivers/scsi/scsi_syms.c	1.20    -> 1.21
# #	 drivers/scsi/scsi.h	1.31    -> 1.32
# #	drivers/scsi/scsi_lib.c	1.34    -> 1.35
# #
# # The following is the BitKeeper ChangeSet Log
# # --------------------------------------------
# # 03/04/19	mdharm@zen.san.one-eyed-alien.net	1.671
# # Added SCSI command filter.
# # --------------------------------------------
# #
# --------------------------------------------
# 03/04/21	jejb@raven.il.steeleye.com	1.1133
# Merge jejb/mdharm
# --------------------------------------------
# 03/04/21	jejb@raven.il.steeleye.com	1.1134
# Complete jejb/mdharm Merger in scsi_filter_list
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Apr 21 11:26:23 2003
+++ b/drivers/scsi/scsi.h	Mon Apr 21 11:26:23 2003
@@ -971,4 +971,49 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
=20
+struct scsi_cmd_filter {
+	enum {
+		SCSI_FILTER_WHITELIST,
+		SCSI_FILTER_BLACKLIST
+	} type;
+	/* normal scsi commands are bytes, exceptions are longer.  The format
+	 * of the exceptions is:
+	 *
+	 * bit 15: invert the specific condition
+	 * bits 14-12: Reserved
+	 * bits 11-8: command opcode (must be > 0)
+	 * bits 7-0: Command specific */
+	unsigned short commands[];
+};
+
+extern int scsi_filter_cmd(struct scsi_cmnd *, struct scsi_cmd_filter *);
+
+/* exception definitions for the filter */
+#define SCSI_FILTER_INVERT		0x8000
+
+/* opcodes for the filter */
+#define SCSI_FILTER_INQUIRY		0x0100
+
+/* useful filter commands */
+
+/* of the FILTER_INQUIRY opcode, < 128 is a length bits above are inquiry
+ * type */
+#define SCSI_FILTER_QUALIFIER		0x80
+#define SCSI_FILTER_QUALIFIER_EVPD	0x01
+#define SCSI_FILTER_INQUIRY_EVPD	(SCSI_FILTER_INQUIRY | SCSI_FILTER_QUALIF=
IER | SCSI_FILTER_QUALIFIER_EVPD)
+#define SCSI_FILTER_INQUIRY_36		(SCSI_FILTER_INQUIRY | 36)
+#define SCSI_FILTER_INQUIRY_NOT36	(SCSI_FILTER_INVERT | SCSI_FILTER_INQUIR=
Y | 36)
+#define SCSI_FILTER_INQUIRY_NOT_EVPD	(SCSI_FILTER_INVERT | SCSI_FILTER_INQ=
UIRY_EVPD)
+
+/* marker for end of filter list */
+#define SCSI_FILTER_LIST_END		0xFFFF
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
--- a/drivers/scsi/scsi_lib.c	Mon Apr 21 11:26:23 2003
+++ b/drivers/scsi/scsi_lib.c	Mon Apr 21 11:26:23 2003
@@ -1423,3 +1423,88 @@
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
+	switch (scsi_filter_opcode(command)) {
+
+	case SCSI_FILTER_INQUIRY:
+		if (cmd->cmnd[0] !=3D INQUIRY)
+			break;
+
+		/* is it a special filter */
+		if (command & SCSI_FILTER_QUALIFIER) {
+			if (command & SCSI_FILTER_QUALIFIER_EVPD)
+				/* is EVPD bit set? */
+				found +=3D (cmd->cmnd[1] & 0x1) ? 1 : 0;
+		} else {
+			/* does the transfer length match the data */
+			found =3D (cmd->cmnd[4] =3D=3D scsi_filter_data(command));
+		}
+		/* now check for inversion */
+		if (command & SCSI_FILTER_INVERT)
+			found =3D !found;
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
+int scsi_filter_cmd(struct scsi_cmnd *cmd, struct scsi_cmd_filter *filter)
+{
+	int found =3D 0;
+	unsigned short *command;
+
+	/* search command list for a match */
+	for (command =3D filter->commands ; *command !=3D SCSI_FILTER_LIST_END;
+	     command++) {
+		found =3D scsi_filter_exceptions(cmd, *command);
+		found +=3D (cmd->cmnd[0] =3D=3D *command);
+		if(found)
+			break;
+	}
+
+	/* pass behavior -- found on a whitelist or not found on a blacklist */
+	if ((found && filter->type =3D=3D SCSI_FILTER_WHITELIST) ||
+	    (!found && filter->type =3D=3D SCSI_FILTER_BLACKLIST))
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
--- a/drivers/scsi/scsi_syms.c	Mon Apr 21 11:26:23 2003
+++ b/drivers/scsi/scsi_syms.c	Mon Apr 21 11:26:23 2003
@@ -55,6 +55,7 @@
 #if defined(CONFIG_SCSI_LOGGING)	/* { */
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
+EXPORT_SYMBOL(scsi_filter_cmd);
=20
 EXPORT_SYMBOL(scsi_allocate_request);
 EXPORT_SYMBOL(scsi_release_request);

--=-7M1y/8lG1fQTgUJemi6a--

