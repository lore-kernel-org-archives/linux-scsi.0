From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 21:15:28 -0400
Message-ID: <20120518011528.GG18067@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
 <20120517192830.GC18067@logfs.org>
 <20120517210521.GE18067@logfs.org>
 <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 May 2012 19:02:36 -0700, Nicholas A. Bellinger wrote:
> > =20
> > +static void tcm_qla2xxx_release_session(struct kref *kref)
> > +{
> > +	struct se_session *se_sess =3D container_of(kref,
> > +			struct se_session, sess_kref);
> > +
> > +	tcm_qla2xxx_close_session(se_sess);
> > +}
> > +
>=20
> Deadlock here..  tcm_qla2xxx_close_session() takes the hardware_lock
> before calling qlt_unreg_sess()..

Good catch.

> > +static void tcm_qla2xxx_put_session(struct se_session *se_sess)
> > +{
> > +	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
> > +	struct qla_hw_data *ha =3D sess->vha->hw;
> > +	unsigned long flags;
> > +
> > +	lock_hardware(ha, &flags);
> > +	kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
> > +	unlock_hardware(ha, &flags);
> > +}
>=20
> I'm not sure what wrapper lock_hardware + unlock_hardware looks like.=
=2E?
> What special does it do beyond just obtaining ha->hardware_lock..?

I have replaced all instances of taking/releasing the hardware_lock in
our tree with these wrappers and also added assert_hardware_locked().
We have a rare bug where qla_tgt_reset() holds the hardware_lock and
qla_tgt_issue_task_mgmt() does not, as proven by the assertions.  By
now I have added all sorts of instrumentations in a desperate attempt
to understand the bug.  Main drawback is that porting patches between
our tree and yours is increasingly painful, as you have noticed.

> <SNIP>
>=20
> No need to rename iscsi-target stuff now, as it does not need
> ->put_session() or change it's current operation using
> target_put_session() for existing users..

Actually... I renamed the function to generic_target_put_session() so
that transports without special needs can use that as their
=2Eput_session pointer.  In principle the rename isn't needed, but the
generic versions of similar callbacks tend to be named generic_foo()
elsewhere and I like to follow common patterns.

But more importantly, I completely forgot to add the function pointers
to all the other transports.  That needs fixing...

> > diff --git a/drivers/target/target_core_tpg.c b/drivers/target/targ=
et_core_tpg.c
> > index 70c3ffb..dfc1b1b 100644
> > --- a/drivers/target/target_core_tpg.c
> > +++ b/drivers/target/target_core_tpg.c
> > @@ -510,10 +510,10 @@ int core_tpg_del_initiator_node_acl(
> >  		list_del(&sess->sess_acl_list);
> > =20
> >  		rc =3D tpg->se_tpg_tfo->shutdown_session(sess);
> > -		target_put_session(sess);
> > +		tpg->se_tpg_tfo->put_session(sess);
> >  		if (!rc)
> >  			continue;
> > -		target_put_session(sess);
> > +		tpg->se_tpg_tfo->put_session(sess);
> >  	}
> >  	target_put_nacl(acl);
> >  	/*
>=20
> Note this breaks all the other fabric cases that don't provide a
> TFO->put_session() callback and will currently require a
> target_put_session() call.
>=20
> This call to TFO->put_sesssion() has been moved into
> target_put_session() the -v2 patch below..

=2E..as you also noticed.

While your version isn't completely absurd, I learned to hate this
pattern the hard way.  In filesystem code, there are several dozen
function pointers that default to buffer_head code.  If the default
was to dereference a NULL pointer and get a clean backtrace,
developers of new filesystems would notice soon enough, add their own
function pointer and move on.

But since the default is to assume buffer_heads, you now use a
filesystem-specific structure with buffer_head code and the result,
often enough, is a fairly subtle corruption that can take several days
to track down.  The only thing that kept me back from removing those
defaults was fear of missing a fix for one of the fourty-odd
filesystems linux currently supports.  We are fucked because we are so
deeply fucked that noone dares to unfuck the situation.

So if you try to follow the buffer_head pattern, prepare to dodge some
rotten fruit the next few times we meet in person.  I really _really_
hate that.  I has cost me several weeks of my life that I could have
spent being more productive and feeling less pain.

<end mad rant>

> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xx=
x/tcm_qla2xxx.c
> index 24b4e45..5aa8372 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -845,9 +845,28 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_m=
ap(struct qla_tgt_sess *sess)
>                                nacl->nport_id);
>  }
> =20
> +static void tcm_qla2xxx_release_session(struct kref *kref)
> +{
> +       struct se_session *se_sess =3D container_of(kref,
> +                       struct se_session, sess_kref);
> +
> +       qlt_unreg_sess(se_sess->fabric_sess_ptr);
> +}
> +
> +static void tcm_qla2xxx_put_session(struct se_session *se_sess)
> +{
> +       struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
> +       struct qla_hw_data *ha =3D sess->vha->hw;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ha->hardware_lock, flags);
> +       kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
> +       spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +}
> +
>  static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
>  {
> -       target_put_session(sess->se_sess);
> +       tcm_qla2xxx_put_session(sess->se_sess);
>  }
> =20
>  static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
> @@ -1743,6 +1762,7 @@ static struct target_core_fabric_ops tcm_qla2xx=
x_ops =3D {
>         .new_cmd_map                    =3D NULL,
>         .check_stop_free                =3D tcm_qla2xxx_check_stop_fr=
ee,
>         .release_cmd                    =3D tcm_qla2xxx_release_cmd,
> +       .put_session                    =3D tcm_qla2xxx_put_session,
>         .shutdown_session               =3D tcm_qla2xxx_shutdown_sess=
ion,
>         .close_session                  =3D tcm_qla2xxx_close_session=
,
>         .sess_get_index                 =3D tcm_qla2xxx_sess_get_inde=
x,
> @@ -1791,6 +1811,7 @@ static struct target_core_fabric_ops tcm_qla2xx=
x_npiv_ops =3D {
>         .tpg_release_fabric_acl         =3D tcm_qla2xxx_release_fabri=
c_acl,
>         .tpg_get_inst_index             =3D tcm_qla2xxx_tpg_get_inst_=
index,
>         .release_cmd                    =3D tcm_qla2xxx_release_cmd,
> +       .put_session                    =3D tcm_qla2xxx_put_session,
>         .shutdown_session               =3D tcm_qla2xxx_shutdown_sess=
ion,
>         .close_session                  =3D tcm_qla2xxx_close_session=
,
>         .sess_get_index                 =3D tcm_qla2xxx_sess_get_inde=
x,
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/=
target_core_transport.c
> index e797986..6b7dc67 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -315,7 +315,7 @@ void transport_register_session(
>  }
>  EXPORT_SYMBOL(transport_register_session);
> =20
> -static void target_release_session(struct kref *kref)
> +void target_release_session(struct kref *kref)
>  {
>         struct se_session *se_sess =3D container_of(kref,
>                         struct se_session, sess_kref);
> @@ -332,6 +332,12 @@ EXPORT_SYMBOL(target_get_session);
> =20
>  void target_put_session(struct se_session *se_sess)
>  {
> +       struct se_portal_group *tpg =3D se_sess->se_tpg;
> +
> +       if (tpg->se_tpg_tfo->put_session !=3D NULL) {
> +               tpg->se_tpg_tfo->put_session(se_sess);
> +               return;
> +       }
>         kref_put(&se_sess->sess_kref, target_release_session);
>  }
>  EXPORT_SYMBOL(target_put_session);
> diff --git a/include/target/target_core_fabric.h b/include/target/tar=
get_core_fabric.h
> index 4e3f7a4..2c2af2b 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -47,6 +47,7 @@ struct target_core_fabric_ops {
>          */
>         int (*check_stop_free)(struct se_cmd *);
>         void (*release_cmd)(struct se_cmd *);
> +       void (*put_session)(struct se_session *);
>         /*
>          * Called with spin_lock_bh(struct se_portal_group->session_l=
ock held.
>          */

Apart from my buffer_head rant, I like it.  Thanks!

J=C3=B6rn

--
Science is the belief in the ignorance of experts.
-- Richard Feynman
