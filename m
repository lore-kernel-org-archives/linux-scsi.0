From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] iscsi-target: Fix bug in handling of ExpStatSN ACK
 during u32 wrap-around
Date: Wed, 26 Dec 2012 22:33:37 +0100
Message-ID: <1356557611.23065.4.camel@deadeye.wl.decadent.org.uk>
References: <1356557415.23065.0.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-FHAFpqev66o+DbhZE0U9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39379 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2L0DOx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2012 22:14:53 -0500
In-Reply-To: <1356557415.23065.0.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Hodgson <steve@purestorage.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org


--=-FHAFpqev66o+DbhZE0U9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch has just made its way into my queue for 3.2.y:

On Mon, 2012-11-05 at 18:02 -0800, Steve Hodgson wrote:
> This patch fixes a bug in the hanlding of initiator provided ExpStatSN an=
d
> individual iscsi_cmd->stat_sn comparision during iscsi_conn->stat_sn
> wrap-around within iscsit_ack_from_expstatsn() code.
>=20
> This bug would manifest itself as iscsi_cmd descriptors not being Acked
> by a lower ExpStatSn, causing them to be leaked until an iSCSI connection
> or session reinstatement event occurs to release all commands.
>=20
> Also fix up two other uses of incorrect CmdSN SNA comparison to use wrapp=
er
> usage from include/scsi/iscsi_proto.h.
[...]
> --- a/drivers/target/iscsi/iscsi_target_erl2.c
> +++ b/drivers/target/iscsi/iscsi_target_erl2.c
> @@ -372,7 +372,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_=
conn *conn)
>  		 * made generic here.
>  		 */
>  		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
> -		     (cmd->cmd_sn >=3D conn->sess->exp_cmd_sn)) {
> +		     iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
>  			list_del(&cmd->i_conn_node);
>  			spin_unlock_bh(&conn->cmd_lock);
>  			iscsit_free_cmd(cmd);
[...]

This changes cmd->cmd_sn to cmd->stat_sn, but the commit message only
describes fixes to wrap-around.  Is that another fix or a bug?

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-FHAFpqev66o+DbhZE0U9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNttK+e/yOyVhhEJAQoYlQ//cQqhxNEm9OIPwPv/rV0tCeY9Z3/fbIud
ovhi+7ceuKC5ZxY8QLt/VSLs9cj65w4pTuONBkjiMpECTEuVn89W9R1nZlEscy3I
qM4mTtGUs4wM0JI2NqX1kP21MS0HINz7FojCYTff51340BwCPn1Zf5iChyqVrPOW
Y5e5I4bN9p+USuoOiTCErOWAjYSkCJ7aHJjRVChK9f2SsTOV5qBp/S+i1OCPpeFh
9IWhEfKDWbLWHLY397Wh5PfSnvsOYW1mMtLeC6df4oFvzmvYMwT3+lWorkFLyHgW
Js58eBfaEs7+mEaJmoCCzm7mMz3/oKFUJ/eeR9V8PqJROvb7mU8EMA+sml+8/ueD
c/GuyJA9EUBYpY1AtPEy2OurIydP8umLxhQIWRF9VQJ0Wy5eX6ykQSQ5ew0w6xBr
czgBhzly9u/3MjQmnyeFTgfXdgPLomW002/BrnGPo4e7hYZhfuFFOeg3iWrGZygo
iSmwP2YtxrscgbO+/Qus+9nQzgvVnKWmJ8vtLxNV94WP3h6TlbM2+3qQZQxU6rTN
4vow0gNk+Lurouu/6QMoWTNUjjIrXlY2VSDoCI+vQ+TJQPjlActl96DDBooNHIOB
6VU5cmJi/ZAsqcgKA9WPbZUVpe47+WfCAVTRNDU6mpIR/L4ialjXEd0ROLxrad/2
qxK8YVySxWE=
=ejTL
-----END PGP SIGNATURE-----

--=-FHAFpqev66o+DbhZE0U9--
