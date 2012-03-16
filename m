From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Fri, 16 Mar 2012 09:59:07 -0400
Message-ID: <20120316135907.GA9037@logfs.org>
References: <20120313172044.GD31808@elgon.mountain>
 <1331853015.10203.128.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1331853015.10203.128.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hello Nick!

On Thu, 15 March 2012 16:10:15 -0700, Nicholas A. Bellinger wrote:
>=20
> iff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/=
qla_target.c
> index e415d1e..2af075b 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3169,11 +3169,11 @@ static void qla_tgt_reject_free_srr_imm(struc=
t scsi_qla_host *vha, struct qla_tg
>  static void qla_tgt_handle_srr_work(struct work_struct *work)
>  {
>         struct qla_tgt *tgt =3D container_of(work, struct qla_tgt, sr=
r_work);
> -       struct scsi_qla_host *vha =3D NULL;
> +       struct scsi_qla_host *vha =3D tgt->vha;
>         struct qla_tgt_srr_ctio *sctio;
>         unsigned long flags;
> =20
> -       ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12e, "Entering SRR work (=
tgt %p)\n", tgt);
> +       ql_dbg(ql_dbg_tgt_mgt, vha, 0xe12e, "Entering SRR work (tgt %=
p)\n", tgt);
> =20
>  restart:
>         spin_lock_irqsave(&tgt->srr_lock, flags);
> @@ -3192,17 +3192,17 @@ restart:
>                                           "be only one IMM SRR per CT=
IO SRR "
>                                           "(IMM SRR %p, id %d, CTIO %=
p\n",
>                                           vha->vp_idx, i, i->srr_id, =
sctio);
> -                                       qla_tgt_reject_free_srr_imm(v=
ha, i, 0);
> +                                       qla_tgt_reject_free_srr_imm(t=
gt->vha, i, 0);

Everywhere else you move from tgt->vha to vha.  Is there a reason for
doing the reverse here?

J=C3=B6rn
