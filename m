From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 5 Apr 2003 11:27:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030405112759.B4320@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:19973 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262623AbTDETQk (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 14:16:40 -0500
Content-Disposition: inline
In-Reply-To: <1049556643.1762.16.camel@mulgrave>; from James.Bottomley@steeleye.com on Sat, Apr 05, 2003 at 09:30:41AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I don't think this will work.  I see two problems:

(1) You can't filter TEST_UNIT_READY (opcode 0).  Not a big deal, but a
theoretical problem.

(2) We need to be able to filter at the originator.  For example,
MODE_SENSE is perfectly fine to send to a CD-ROM, but not to a hard-disk.
We can't make that distinction with your code, unless we put the filtering
code not in queuecommand but in places like sd.c.... or we need to change
the filter to also take a device type.

Matt

On Sat, Apr 05, 2003 at 09:30:41AM -0600, James Bottomley wrote:
> On Mon, 2003-03-24 at 11:30, Matthew Dharm wrote:
> > On Mon, Mar 24, 2003 at 09:15:57AM -0600, James Bottomley wrote:
> > > OK, I can do this: A simple one with either a blacklist (reject these
> > > commands) or whitelist (only accept these commands) going by the first
> > > command byte OK?
> >=20
> > Well, you need to go by more than the first command byte -- ex. INQUIRY=
 is
> > okay, unless length !=3D 36 or EVPD.
> >=20
> > I think a blacklist is probably in order, but with a BIG COMMENT mentio=
ning
> > that if someone adds new commands into the code paths they should at le=
ast
> > consider if they belong in the blacklist.
>=20
> OK, try the attached.  There is no central blacklist, you must construct
> it on a per driver basis, so in the queuecommand of your driver you have
> a:
>=20
> 	static struct scsi_cmd_filter filter =3D
> 		{ SCSI_FILTER_BLACKLIST ,
> 		  { MODE_SENSE, SCSI_FILTER_INQUIRY_NOT36, 0 } };
>=20
> 	if(scsi_filter_cmd(SCp, &filter)) {
> 		SCp->scsi_done(SCp);
> 		return 0;
> 	}
>=20
> to use the filter (I think, I've compiled but not tested it).
>=20
> Let me know how it goes.
>=20
> James
>=20

> =3D=3D=3D=3D=3D drivers/scsi/scsi.h 1.68 vs edited =3D=3D=3D=3D=3D
> --- 1.68/drivers/scsi/scsi.h	Mon Mar 24 11:23:37 2003
> +++ edited/drivers/scsi/scsi.h	Sat Apr  5 09:24:38 2003
> @@ -959,4 +959,39 @@
>  extern int scsi_sysfs_register(void);
>  extern void scsi_sysfs_unregister(void);
> =20
> +struct scsi_cmd_filter {
> +	enum {
> +		SCSI_FILTER_WHITELIST,
> +		SCSI_FILTER_BLACKLIST
> +	} type;
> +	/* normal scsi commands are bytes, exceptions are words.  The format
> +	 * of the exceptions is:
> +	 *
> +	 * Byte 15: invert the specific condition
> +	 * Byte 14-12: Reserved
> +	 * Byte 11-8: command opcode (must be > 0)
> +	 * Byte 7-0: Command specific */
> +	unsigned short commands[];
> +};
> +
> +extern int scsi_filter_cmd(struct scsi_cmnd *, struct scsi_cmd_filter *);
> +
> +/* exception definitions for the filter */
> +#define SCSI_FILTER_INVERT		0x8000
> +
> +/* opcodes for the filter */
> +#define SCSI_FILTER_INQUIRY		0x0100
> +
> +/* useful filter commands */
> +#define SCSI_FILTER_INQUIRY_36		(SCSI_FILTER_INQUIRY | 36)
> +#define SCSI_FILTER_INQUIRY_NOT36	(SCSI_FILTER_INVERT | SCSI_FILTER_INQU=
IRY | 36)
> +
> +static inline unsigned short scsi_filter_opcode(unsigned short command) {
> +	return command & 0x7f00;
> +}
> +
> +static inline unsigned char scsi_filter_data(unsigned short command) {
> +	return (unsigned char)(command & 0x00ff);
> +}
> +
>  #endif /* _SCSI_H */
> =3D=3D=3D=3D=3D drivers/scsi/scsi_lib.c 1.75 vs edited =3D=3D=3D=3D=3D
> --- 1.75/drivers/scsi/scsi_lib.c	Fri Mar 14 18:35:27 2003
> +++ edited/drivers/scsi/scsi_lib.c	Sat Apr  5 09:27:35 2003
> @@ -1375,3 +1375,71 @@
>  		kmem_cache_destroy(sgp->slab);
>  	}
>  }
> +
> +static inline int scsi_filter_exceptions(struct scsi_cmnd *cmd,
> +					 unsigned short command)
> +{
> +	int found =3D 0;
> +
> +	/* specials begin at 0x100 */
> +	if(command < 0x100)
> +		return 0;
> +
> +	switch(scsi_filter_opcode(command)) {
> +
> +	case SCSI_FILTER_INQUIRY:
> +		if(cmd->cmnd[0] !=3D INQUIRY)
> +			return 0;
> +		/* does the transfer length match the data */
> +		found =3D (cmd->cmnd[4] =3D=3D scsi_filter_data(command));
> +		/* now check for inversion */
> +		if(command & SCSI_FILTER_INVERT)
> +			found =3D !found;
> +		return found;
> +	default:
> +		/* unrecognized filter */
> +		return 0;
> +	}
> +}
> +
> +/**
> + * scsi_filter_cmd - Filter a given command against a list
> + * @cmd: command to be filtered.
> + * @filter: pointer to the filter containing the type (black/white list)=
 and
> + * zero terminated list of commands to filter against (first byte only).
> + *
> + * Returns 0 if the filter passed successfully and the driver can contin=
ue
> + * processing the command or 1 if the filter failed and the command shou=
ld
> + * be finished (via ->scsi_done).  In the latter case, the command will =
have
> + * the sense fields filled in indicating the correct sense for an illegal
> + * request.
> + **/
> +int scsi_filter_cmd(struct scsi_cmnd *cmd, struct scsi_cmd_filter *filte=
r)
> +{
> +	int found =3D 0;
> +	unsigned short *command;
> +
> +	for(command =3D filter->commands; *command; command++) {
> +		found =3D scsi_filter_exceptions(cmd, *command);
> +		found +=3D (cmd->cmnd[0] !=3D *command);
> +		if(found)
> +			break;
> +	}
> +
> +	if((found && filter->type =3D=3D SCSI_FILTER_WHITELIST) ||
> +	   (!found && filter->type =3D=3D SCSI_FILTER_BLACKLIST))
> +		return 0;
> +
> +	/* fill in the Check Condition/Illegal request */
> +	cmd->result =3D SAM_STAT_CHECK_CONDITION;
> +	memset(cmd->sense_buffer, '\0', sizeof(cmd->sense_buffer));
> +	cmd->sense_buffer[0] =3D 0xF0; /* valid, response code 0x70 */
> +	cmd->sense_buffer[2] =3D ILLEGAL_REQUEST;
> +
> +	/* ASC 0x20, ASCQ 0x00: Invalid command operation code */
> +	cmd->sense_buffer[12] =3D 0x20;
> +	cmd->sense_buffer[13] =3D 0x00;
> +
> +	return 1;
> +}
> +=09


--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

IT KEEPS ASKING ME WHERE I WANT TO GO TODAY! I DONT WANT TO GO ANYWHERE!
					-- Greg
User Friendly, 11/28/97

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+jy4/IjReC7bSPZARAiJNAKCj7lYjhJSOAuCYrysUQp+lLHu/YgCgndH9
3k1dQp/WFwpNRhJ48k3TyWs=
=KHEj
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
