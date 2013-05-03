From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 7/9] iscsi-target: Refactor TX queue logic + export
 response PDU creation
Date: Fri, 03 May 2013 16:40:56 -0700
Message-ID: <1367624456.21785.2.camel@haakon3.risingtidesystems.com>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
	 <1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
	 <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-05-03 at 23:04 +0200, Geert Uytterhoeven wrote:
> Hi Nicholas,
>=20
> On Fri, Apr 12, 2013 at 10:52 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
>=20
> >  static int iscsit_send_reject(
> >         struct iscsi_cmd *cmd,
> >         struct iscsi_conn *conn)
> > @@ -3505,18 +3548,9 @@ static int iscsit_send_reject(
> >         struct iscsi_reject *hdr;
> >         struct kvec *iov;
> >
> > -       hdr                     =3D (struct iscsi_reject *) cmd->pd=
u;
>=20
> Woops, and now hdr is no longer initialized:
>=20
> drivers/target/iscsi/iscsi_target.c: In function =E2=80=98iscsit_send=
_reject=E2=80=99:
> drivers/target/iscsi/iscsi_target.c:3577: warning: =E2=80=98hdr=E2=80=
=99 is used
> uninitialized in this function
>=20
> > -       hdr->opcode             =3D ISCSI_OP_REJECT;
> > -       hdr->flags              |=3D ISCSI_FLAG_CMD_FINAL;
> > -       hton24(hdr->dlength, ISCSI_HDR_LEN);
> > -       hdr->ffffffff           =3D cpu_to_be32(0xffffffff);
> > -       cmd->stat_sn            =3D conn->stat_sn++;
> > -       hdr->statsn             =3D cpu_to_be32(cmd->stat_sn);
> > -       hdr->exp_cmdsn  =3D cpu_to_be32(conn->sess->exp_cmd_sn);
> > -       hdr->max_cmdsn  =3D cpu_to_be32(conn->sess->max_cmd_sn);
> > +       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd-=
>pdu[0]);
>=20
> Hence it will crash later:
>=20
>                 iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
>                                 (unsigned char *)hdr, ISCSI_HDR_LEN,
>                                 0, NULL, (u8 *)header_digest);
>=20
> and
>=20
>         pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
>                 " CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn-=
>cid);
>=20

Whoops.  Applying the following patch to fix this up now, and including
in the next PULL request.

Thanks alot for catching this!

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi=
/iscsi_target.c
index ffbc6a9..c230eac 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3557,11 +3557,11 @@ static int iscsit_send_reject(
        struct iscsi_cmd *cmd,
        struct iscsi_conn *conn)
 {
-       u32 iov_count =3D 0, tx_size =3D 0;
-       struct iscsi_reject *hdr;
+       struct iscsi_reject *hdr =3D (struct iscsi_reject *)&cmd->pdu[0=
];
        struct kvec *iov;
+       u32 iov_count =3D 0, tx_size;
=20
-       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->pdu=
[0]);
+       iscsit_build_reject(cmd, conn, hdr);
=20
        iov =3D &cmd->iov_misc[0];
        iov[iov_count].iov_base =3D cmd->pdu;
