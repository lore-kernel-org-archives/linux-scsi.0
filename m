From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 23:09:27 -0700
Message-ID: <1337321367.32217.412.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
	 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
	 <20120517192830.GC18067@logfs.org> <20120517210521.GE18067@logfs.org>
	 <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
	 <20120518011528.GG18067@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120518011528.GG18067@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-05-17 at 21:15 -0400, J=C3=B6rn Engel wrote:
> On Thu, 17 May 2012 19:02:36 -0700, Nicholas A. Bellinger wrote:

<SNIP>

> >=20
> > No need to rename iscsi-target stuff now, as it does not need
> > ->put_session() or change it's current operation using
> > target_put_session() for existing users..
>=20
> Actually... I renamed the function to generic_target_put_session() so
> that transports without special needs can use that as their
> .put_session pointer.  In principle the rename isn't needed, but the
> generic versions of similar callbacks tend to be named generic_foo()
> elsewhere and I like to follow common patterns.
>=20
> But more importantly, I completely forgot to add the function pointer=
s
> to all the other transports.  That needs fixing...
>=20

=2E...

> > > diff --git a/drivers/target/target_core_tpg.c b/drivers/target/ta=
rget_core_tpg.c
> > > index 70c3ffb..dfc1b1b 100644
> > > --- a/drivers/target/target_core_tpg.c
> > > +++ b/drivers/target/target_core_tpg.c
> > > @@ -510,10 +510,10 @@ int core_tpg_del_initiator_node_acl(
> > >  		list_del(&sess->sess_acl_list);
> > > =20
> > >  		rc =3D tpg->se_tpg_tfo->shutdown_session(sess);
> > > -		target_put_session(sess);
> > > +		tpg->se_tpg_tfo->put_session(sess);
> > >  		if (!rc)
> > >  			continue;
> > > -		target_put_session(sess);
> > > +		tpg->se_tpg_tfo->put_session(sess);
> > >  	}
> > >  	target_put_nacl(acl);
> > >  	/*
> >=20
> > Note this breaks all the other fabric cases that don't provide a
> > TFO->put_session() callback and will currently require a
> > target_put_session() call.
> >=20
> > This call to TFO->put_sesssion() has been moved into
> > target_put_session() the -v2 patch below..
>=20
> ...as you also noticed.
>=20
> While your version isn't completely absurd, I learned to hate this
> pattern the hard way.

Incremental steps here please..  Adding individual ->put_session()
callers using target_put_session() is trivial to change for everyone
else once the changes to tcm_qla2xxx are working as expected..

> In filesystem code, there are several dozen
> function pointers that default to buffer_head code.  If the default
> was to dereference a NULL pointer and get a clean backtrace,
> developers of new filesystems would notice soon enough, add their own
> function pointer and move on.
>=20
> But since the default is to assume buffer_heads, you now use a
> filesystem-specific structure with buffer_head code and the result,
> often enough, is a fairly subtle corruption that can take several day=
s
> to track down.  The only thing that kept me back from removing those
> defaults was fear of missing a fix for one of the fourty-odd
> filesystems linux currently supports.  We are fucked because we are s=
o
> deeply fucked that noone dares to unfuck the situation.
>=20
> So if you try to follow the buffer_head pattern, prepare to dodge som=
e
> rotten fruit the next few times we meet in person.  I really _really_
> hate that.  I has cost me several weeks of my life that I could have
> spent being more productive and feeling less pain.
>=20

We currently don't have any hard requirement for obtaining a fabric
specific lock in software drivers like loopback, tcm_fc, and
iscsi-target, so this ends up being a NOP back into target_put_session(=
)
for handling of the default fabric independent se_sess->sess_kref put
shutdown case.

So while one might be swayed by your historical arguments above, I
really don't see a scenario unfolding here that would unleash a hell of
"no one dares to unfuck" the unfuckable as you've so eloquently stated.=
=2E

> <end mad rant>
>=20
> > diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2=
xxx/tcm_qla2xxx.c
> > index 24b4e45..5aa8372 100644
> > --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> > @@ -845,9 +845,28 @@ static void tcm_qla2xxx_clear_nacl_from_fcport=
_map(struct qla_tgt_sess *sess)
> >                                nacl->nport_id);
> >  }
> > =20
> > +static void tcm_qla2xxx_release_session(struct kref *kref)
> > +{
> > +       struct se_session *se_sess =3D container_of(kref,
> > +                       struct se_session, sess_kref);
> > +
> > +       qlt_unreg_sess(se_sess->fabric_sess_ptr);
> > +}
> > +
> > +static void tcm_qla2xxx_put_session(struct se_session *se_sess)
> > +{
> > +       struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
> > +       struct qla_hw_data *ha =3D sess->vha->hw;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&ha->hardware_lock, flags);
> > +       kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
> > +       spin_unlock_irqrestore(&ha->hardware_lock, flags);
> > +}
> > +
> >  static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
> >  {
> > -       target_put_session(sess->se_sess);
> > +       tcm_qla2xxx_put_session(sess->se_sess);
> >  }
> > =20
> >  static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
> > @@ -1743,6 +1762,7 @@ static struct target_core_fabric_ops tcm_qla2=
xxx_ops =3D {
> >         .new_cmd_map                    =3D NULL,
> >         .check_stop_free                =3D tcm_qla2xxx_check_stop_=
free,
> >         .release_cmd                    =3D tcm_qla2xxx_release_cmd=
,
> > +       .put_session                    =3D tcm_qla2xxx_put_session=
,
> >         .shutdown_session               =3D tcm_qla2xxx_shutdown_se=
ssion,
> >         .close_session                  =3D tcm_qla2xxx_close_sessi=
on,
> >         .sess_get_index                 =3D tcm_qla2xxx_sess_get_in=
dex,
> > @@ -1791,6 +1811,7 @@ static struct target_core_fabric_ops tcm_qla2=
xxx_npiv_ops =3D {
> >         .tpg_release_fabric_acl         =3D tcm_qla2xxx_release_fab=
ric_acl,
> >         .tpg_get_inst_index             =3D tcm_qla2xxx_tpg_get_ins=
t_index,
> >         .release_cmd                    =3D tcm_qla2xxx_release_cmd=
,
> > +       .put_session                    =3D tcm_qla2xxx_put_session=
,
> >         .shutdown_session               =3D tcm_qla2xxx_shutdown_se=
ssion,
> >         .close_session                  =3D tcm_qla2xxx_close_sessi=
on,
> >         .sess_get_index                 =3D tcm_qla2xxx_sess_get_in=
dex,
> > diff --git a/drivers/target/target_core_transport.c b/drivers/targe=
t/target_core_transport.c
> > index e797986..6b7dc67 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -315,7 +315,7 @@ void transport_register_session(
> >  }
> >  EXPORT_SYMBOL(transport_register_session);
> > =20
> > -static void target_release_session(struct kref *kref)
> > +void target_release_session(struct kref *kref)
> >  {
> >         struct se_session *se_sess =3D container_of(kref,
> >                         struct se_session, sess_kref);
> > @@ -332,6 +332,12 @@ EXPORT_SYMBOL(target_get_session);
> > =20
> >  void target_put_session(struct se_session *se_sess)
> >  {
> > +       struct se_portal_group *tpg =3D se_sess->se_tpg;
> > +
> > +       if (tpg->se_tpg_tfo->put_session !=3D NULL) {
> > +               tpg->se_tpg_tfo->put_session(se_sess);
> > +               return;
> > +       }
> >         kref_put(&se_sess->sess_kref, target_release_session);
> >  }
> >  EXPORT_SYMBOL(target_put_session);
> > diff --git a/include/target/target_core_fabric.h b/include/target/t=
arget_core_fabric.h
> > index 4e3f7a4..2c2af2b 100644
> > --- a/include/target/target_core_fabric.h
> > +++ b/include/target/target_core_fabric.h
> > @@ -47,6 +47,7 @@ struct target_core_fabric_ops {
> >          */
> >         int (*check_stop_free)(struct se_cmd *);
> >         void (*release_cmd)(struct se_cmd *);
> > +       void (*put_session)(struct se_session *);
> >         /*
> >          * Called with spin_lock_bh(struct se_portal_group->session=
_lock held.
> >          */
>=20
> Apart from my buffer_head rant, I like it.  Thanks!
>=20

So that means your testing with it now, right..?

Thanks Joern!

--nab
