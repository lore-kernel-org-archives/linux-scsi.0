From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC-v4 7/9] iscsi-target: Refactor TX queue logic + export
 response PDU creation
Date: Fri, 3 May 2013 23:04:50 +0200
Message-ID: <CAMuHMdWVpF9G2v5oSYL642mpWdQCMGBhSQYa=Zw0s9DyoNJLjQ@mail.gmail.com>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
	<1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-8-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,

On Fri, Apr 12, 2013 at 10:52 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c

>  static int iscsit_send_reject(
>         struct iscsi_cmd *cmd,
>         struct iscsi_conn *conn)
> @@ -3505,18 +3548,9 @@ static int iscsit_send_reject(
>         struct iscsi_reject *hdr;
>         struct kvec *iov;
>
> -       hdr                     =3D (struct iscsi_reject *) cmd->pdu;

Woops, and now hdr is no longer initialized:

drivers/target/iscsi/iscsi_target.c: In function =E2=80=98iscsit_send_r=
eject=E2=80=99:
drivers/target/iscsi/iscsi_target.c:3577: warning: =E2=80=98hdr=E2=80=99=
 is used
uninitialized in this function

> -       hdr->opcode             =3D ISCSI_OP_REJECT;
> -       hdr->flags              |=3D ISCSI_FLAG_CMD_FINAL;
> -       hton24(hdr->dlength, ISCSI_HDR_LEN);
> -       hdr->ffffffff           =3D cpu_to_be32(0xffffffff);
> -       cmd->stat_sn            =3D conn->stat_sn++;
> -       hdr->statsn             =3D cpu_to_be32(cmd->stat_sn);
> -       hdr->exp_cmdsn  =3D cpu_to_be32(conn->sess->exp_cmd_sn);
> -       hdr->max_cmdsn  =3D cpu_to_be32(conn->sess->max_cmd_sn);
> +       iscsit_build_reject(cmd, conn, (struct iscsi_reject *)&cmd->p=
du[0]);

Hence it will crash later:

                iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
                                (unsigned char *)hdr, ISCSI_HDR_LEN,
                                0, NULL, (u8 *)header_digest);

and

        pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
                " CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->c=
id);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
