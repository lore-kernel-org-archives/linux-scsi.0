From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 05 Apr 2003 09:30:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049556643.1762.16.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kEksH2N1NKaoekstXAfh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:3847 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262505AbTDEPTk (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 10:19:40 -0500
In-Reply-To: <20030324093028.A1066@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--=-kEksH2N1NKaoekstXAfh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2003-03-24 at 11:30, Matthew Dharm wrote:
> On Mon, Mar 24, 2003 at 09:15:57AM -0600, James Bottomley wrote:
> > OK, I can do this: A simple one with either a blacklist (reject these
> > commands) or whitelist (only accept these commands) going by the first
> > command byte OK?
> 
> Well, you need to go by more than the first command byte -- ex. INQUIRY is
> okay, unless length != 36 or EVPD.
> 
> I think a blacklist is probably in order, but with a BIG COMMENT mentioning
> that if someone adds new commands into the code paths they should at least
> consider if they belong in the blacklist.

OK, try the attached.  There is no central blacklist, you must construct
it on a per driver basis, so in the queuecommand of your driver you have
a:

	static struct scsi_cmd_filter filter =
		{ SCSI_FILTER_BLACKLIST ,
		  { MODE_SENSE, SCSI_FILTER_INQUIRY_NOT36, 0 } };

	if(scsi_filter_cmd(SCp, &filter)) {
		SCp->scsi_done(SCp);
		return 0;
	}

to use the filter (I think, I've compiled but not tested it).

Let me know how it goes.

James


--=-kEksH2N1NKaoekstXAfh
Content-Disposition: attachment; filename=scsi_filter.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=scsi_filter.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/scsi.h 1.68 vs edited =3D=3D=3D=3D=3D
--- 1.68/drivers/scsi/scsi.h	Mon Mar 24 11:23:37 2003
+++ edited/drivers/scsi/scsi.h	Sat Apr  5 09:24:38 2003
@@ -959,4 +959,39 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
=20
+struct scsi_cmd_filter {
+	enum {
+		SCSI_FILTER_WHITELIST,
+		SCSI_FILTER_BLACKLIST
+	} type;
+	/* normal scsi commands are bytes, exceptions are words.  The format
+	 * of the exceptions is:
+	 *
+	 * Byte 15: invert the specific condition
+	 * Byte 14-12: Reserved
+	 * Byte 11-8: command opcode (must be > 0)
+	 * Byte 7-0: Command specific */
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
+#define SCSI_FILTER_INQUIRY_36		(SCSI_FILTER_INQUIRY | 36)
+#define SCSI_FILTER_INQUIRY_NOT36	(SCSI_FILTER_INVERT | SCSI_FILTER_INQUIR=
Y | 36)
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
=3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.75 vs edited =3D=3D=3D=3D=3D
--- 1.75/drivers/scsi/scsi_lib.c	Fri Mar 14 18:35:27 2003
+++ edited/drivers/scsi/scsi_lib.c	Sat Apr  5 09:27:35 2003
@@ -1375,3 +1375,71 @@
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
+	switch(scsi_filter_opcode(command)) {
+
+	case SCSI_FILTER_INQUIRY:
+		if(cmd->cmnd[0] !=3D INQUIRY)
+			return 0;
+		/* does the transfer length match the data */
+		found =3D (cmd->cmnd[4] =3D=3D scsi_filter_data(command));
+		/* now check for inversion */
+		if(command & SCSI_FILTER_INVERT)
+			found =3D !found;
+		return found;
+	default:
+		/* unrecognized filter */
+		return 0;
+	}
+}
+
+/**
+ * scsi_filter_cmd - Filter a given command against a list
+ * @cmd: command to be filtered.
+ * @filter: pointer to the filter containing the type (black/white list) a=
nd
+ * zero terminated list of commands to filter against (first byte only).
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
+	for(command =3D filter->commands; *command; command++) {
+		found =3D scsi_filter_exceptions(cmd, *command);
+		found +=3D (cmd->cmnd[0] !=3D *command);
+		if(found)
+			break;
+	}
+
+	if((found && filter->type =3D=3D SCSI_FILTER_WHITELIST) ||
+	   (!found && filter->type =3D=3D SCSI_FILTER_BLACKLIST))
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

--=-kEksH2N1NKaoekstXAfh--

