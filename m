From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Fri, 16 Mar 2012 18:22:30 -0700
Message-ID: <1331947350.10203.288.camel@haakon2.linux-iscsi.org>
References: <20120313172044.GD31808@elgon.mountain>
	 <1331853015.10203.128.camel@haakon2.linux-iscsi.org>
	 <20120316135907.GA9037@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120316135907.GA9037@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-03-16 at 09:59 -0400, J=C3=B6rn Engel wrote:
> Hello Nick!
>=20
> On Thu, 15 March 2012 16:10:15 -0700, Nicholas A. Bellinger wrote:
> >=20
> > iff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xx=
x/qla_target.c
> > index e415d1e..2af075b 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -3169,11 +3169,11 @@ static void qla_tgt_reject_free_srr_imm(str=
uct scsi_qla_host *vha, struct qla_tg
> >  static void qla_tgt_handle_srr_work(struct work_struct *work)
> >  {
> >         struct qla_tgt *tgt =3D container_of(work, struct qla_tgt, =
srr_work);
> > -       struct scsi_qla_host *vha =3D NULL;
> > +       struct scsi_qla_host *vha =3D tgt->vha;
> >         struct qla_tgt_srr_ctio *sctio;
> >         unsigned long flags;
> > =20
> > -       ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12e, "Entering SRR work=
 (tgt %p)\n", tgt);
> > +       ql_dbg(ql_dbg_tgt_mgt, vha, 0xe12e, "Entering SRR work (tgt=
 %p)\n", tgt);
> > =20
> >  restart:
> >         spin_lock_irqsave(&tgt->srr_lock, flags);
> > @@ -3192,17 +3192,17 @@ restart:
> >                                           "be only one IMM SRR per =
CTIO SRR "
> >                                           "(IMM SRR %p, id %d, CTIO=
 %p\n",
> >                                           vha->vp_idx, i, i->srr_id=
, sctio);
> > -                                       qla_tgt_reject_free_srr_imm=
(vha, i, 0);
> > +                                       qla_tgt_reject_free_srr_imm=
(tgt->vha, i, 0);
>=20
> Everywhere else you move from tgt->vha to vha.  Is there a reason for
> doing the reverse here?
>=20

Hi Joern,

Non-critical typo here..  Fixing this up now.

Thanks!

--nab
