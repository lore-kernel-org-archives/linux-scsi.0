From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 19:02:36 -0700
Message-ID: <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
	 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
	 <20120517192830.GC18067@logfs.org>  <20120517210521.GE18067@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47787 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967788Ab2ERCCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 22:02:39 -0400
In-Reply-To: <20120517210521.GE18067@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>

On Thu, 2012-05-17 at 17:05 -0400, J=C3=B6rn Engel wrote:
> On Thu, 17 May 2012 15:28:30 -0400, J=C3=B6rn Engel wrote:
> >=20
> > tcm_qla2xxx_free_session  <-- removes from lookup tables
> > qla_tgt_free_session_done
> > ---                       <-- move to workqueue, dropping hardware_=
lock
> > qla_tgt_unreg_sess
> > tcm_qla2xxx_close_session <-- takes hardware_lock
> > target_release_session
> > target_put_session        <-- drops refcount
> >=20
> > Since the lookup tables are protected by hardware_lock, we would ha=
ve
> > to either take the hardware_lock _before_ dropping the reference co=
unt
> > or do atomic_dec_and_lock().  Both of which requires knowledge abou=
t
> > the qla2xxx hardware_lock in generic target code.
>=20
> And below is a patch of RFC quality, at best.  Assuming it actually
> does what it should do, this is still insufficient.
> tcm_qla2xxx_find_sess_by_* currently don't take a refcount and in
> particular the qla_tgt_reset() path will happily dereference the
> session without a refcount.  Steve is currently working on that side.
>=20
> Anyway, are there any other problems with the patch that I have
> missed?
>=20

Hey Joern,

I think this patch to add a TFO->put_session() special case for
tcm_qla2xxx (and possibly ib_srpt as well) is the better approach in
order to handle when a fabric specific hardware lock needs to be taken
around the final se_session kref put.

My comments are below..

> J=C3=B6rn
>=20
> --
> You ain't got no problem, Jules. I'm on the motherfucker. Go back in
> there, chill them niggers out and wait for the Wolf, who should be
> coming directly.
> -- Marsellus Wallace
>=20
> [PATCH] qla_target: hold hardware_lock when dropping session refcount
>=20
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c        |   22 +++++++++++++++++++=
++-
>  drivers/target/iscsi/iscsi_target.c       |    6 +++---
>  drivers/target/iscsi/iscsi_target_login.c |    4 ++--
>  drivers/target/target_core_tpg.c          |    4 ++--
>  drivers/target/target_core_transport.c    |    6 +++---
>  include/target/target_core_fabric.h       |    3 ++-
>  6 files changed, 33 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xx=
x/tcm_qla2xxx.c
> index 759c65b..bfdd6f2 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -934,9 +934,28 @@ void tcm_qla2xxx_clear_nacl_from_fcport_map(stru=
ct qla_tgt_sess *sess)
>  			       nacl->nport_id);
>  }
> =20
> +static void tcm_qla2xxx_release_session(struct kref *kref)
> +{
> +	struct se_session *se_sess =3D container_of(kref,
> +			struct se_session, sess_kref);
> +
> +	tcm_qla2xxx_close_session(se_sess);
> +}
> +

Deadlock here..  tcm_qla2xxx_close_session() takes the hardware_lock
before calling qlt_unreg_sess()..

> +static void tcm_qla2xxx_put_session(struct se_session *se_sess)
> +{
> +	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
> +	struct qla_hw_data *ha =3D sess->vha->hw;
> +	unsigned long flags;
> +
> +	lock_hardware(ha, &flags);
> +	kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
> +	unlock_hardware(ha, &flags);
> +}
> +

I'm not sure what wrapper lock_hardware + unlock_hardware looks like..?
What special does it do beyond just obtaining ha->hardware_lock..?

To build in lio-core there where just changed to normal irqsave() ->
irqrestore() w/ ->hardware_lock

>  void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
>  {
> -	target_put_session(sess->se_sess);
> +	tcm_qla2xxx_put_session(sess->se_sess);
>  }
> =20
>  void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
> @@ -1833,6 +1852,7 @@ static struct target_core_fabric_ops tcm_qla2xx=
x_ops =3D {
>  	.new_cmd_map			=3D NULL,
>  	.check_stop_free		=3D tcm_qla2xxx_check_stop_free,
>  	.release_cmd			=3D tcm_qla2xxx_release_cmd,
> +	.put_session			=3D tcm_qla2xxx_put_session,
>  	.shutdown_session		=3D tcm_qla2xxx_shutdown_session,
>  	.close_session			=3D tcm_qla2xxx_close_session,
>  	.stop_session			=3D tcm_qla2xxx_stop_session,

<SNIP>

No need to rename iscsi-target stuff now, as it does not need
->put_session() or change it's current operation using
target_put_session() for existing users..

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target=
_core_tpg.c
> index 70c3ffb..dfc1b1b 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -510,10 +510,10 @@ int core_tpg_del_initiator_node_acl(
>  		list_del(&sess->sess_acl_list);
> =20
>  		rc =3D tpg->se_tpg_tfo->shutdown_session(sess);
> -		target_put_session(sess);
> +		tpg->se_tpg_tfo->put_session(sess);
>  		if (!rc)
>  			continue;
> -		target_put_session(sess);
> +		tpg->se_tpg_tfo->put_session(sess);
>  	}
>  	target_put_nacl(acl);
>  	/*

Note this breaks all the other fabric cases that don't provide a
TFO->put_session() callback and will currently require a
target_put_session() call.

This call to TFO->put_sesssion() has been moved into
target_put_session() the -v2 patch below..

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/=
target_core_transport.c
> index 50cb798..63089b4 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -318,7 +318,7 @@ void transport_register_session(
>  }
>  EXPORT_SYMBOL(transport_register_session);
> =20
> -static void target_release_session(struct kref *kref)
> +void target_release_session(struct kref *kref)
>  {
>  	struct se_session *se_sess =3D container_of(kref,
>  			struct se_session, sess_kref);
> @@ -333,11 +333,11 @@ void target_get_session(struct se_session *se_s=
ess)
>  }
>  EXPORT_SYMBOL(target_get_session);
> =20
> -int target_put_session(struct se_session *se_sess)
> +int generic_target_put_session(struct se_session *se_sess)
>  {
>  	return kref_put(&se_sess->sess_kref, target_release_session);
>  }
> -EXPORT_SYMBOL(target_put_session);
> +EXPORT_SYMBOL(generic_target_put_session);
> =20

Ok, so here is what I've put together from your original patch that's
currently running on top of lio-core.git.  It appears to be doing what
your original patch was attempting to do, but is still missing the extr=
a
refactoring + export of set_sess_by_*() callers as discussed earlier..

WDYT..?

--nab

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/=
tcm_qla2xxx.c
index 24b4e45..5aa8372 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -845,9 +845,28 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map=
(struct qla_tgt_sess *sess)
                               nacl->nport_id);
 }
=20
+static void tcm_qla2xxx_release_session(struct kref *kref)
+{
+       struct se_session *se_sess =3D container_of(kref,
+                       struct se_session, sess_kref);
+
+       qlt_unreg_sess(se_sess->fabric_sess_ptr);
+}
+
+static void tcm_qla2xxx_put_session(struct se_session *se_sess)
+{
+       struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
+       struct qla_hw_data *ha =3D sess->vha->hw;
+       unsigned long flags;
+
+       spin_lock_irqsave(&ha->hardware_lock, flags);
+       kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
+       spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 {
-       target_put_session(sess->se_sess);
+       tcm_qla2xxx_put_session(sess->se_sess);
 }
=20
 static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
@@ -1743,6 +1762,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_=
ops =3D {
        .new_cmd_map                    =3D NULL,
        .check_stop_free                =3D tcm_qla2xxx_check_stop_free=
,
        .release_cmd                    =3D tcm_qla2xxx_release_cmd,
+       .put_session                    =3D tcm_qla2xxx_put_session,
        .shutdown_session               =3D tcm_qla2xxx_shutdown_sessio=
n,
        .close_session                  =3D tcm_qla2xxx_close_session,
        .sess_get_index                 =3D tcm_qla2xxx_sess_get_index,
@@ -1791,6 +1811,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_=
npiv_ops =3D {
        .tpg_release_fabric_acl         =3D tcm_qla2xxx_release_fabric_=
acl,
        .tpg_get_inst_index             =3D tcm_qla2xxx_tpg_get_inst_in=
dex,
        .release_cmd                    =3D tcm_qla2xxx_release_cmd,
+       .put_session                    =3D tcm_qla2xxx_put_session,
        .shutdown_session               =3D tcm_qla2xxx_shutdown_sessio=
n,
        .close_session                  =3D tcm_qla2xxx_close_session,
        .sess_get_index                 =3D tcm_qla2xxx_sess_get_index,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
index e797986..6b7dc67 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -315,7 +315,7 @@ void transport_register_session(
 }
 EXPORT_SYMBOL(transport_register_session);
=20
-static void target_release_session(struct kref *kref)
+void target_release_session(struct kref *kref)
 {
        struct se_session *se_sess =3D container_of(kref,
                        struct se_session, sess_kref);
@@ -332,6 +332,12 @@ EXPORT_SYMBOL(target_get_session);
=20
 void target_put_session(struct se_session *se_sess)
 {
+       struct se_portal_group *tpg =3D se_sess->se_tpg;
+
+       if (tpg->se_tpg_tfo->put_session !=3D NULL) {
+               tpg->se_tpg_tfo->put_session(se_sess);
+               return;
+       }
        kref_put(&se_sess->sess_kref, target_release_session);
 }
 EXPORT_SYMBOL(target_put_session);
diff --git a/include/target/target_core_fabric.h b/include/target/targe=
t_core_fabric.h
index 4e3f7a4..2c2af2b 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -47,6 +47,7 @@ struct target_core_fabric_ops {
         */
        int (*check_stop_free)(struct se_cmd *);
        void (*release_cmd)(struct se_cmd *);
+       void (*put_session)(struct se_session *);
        /*
         * Called with spin_lock_bh(struct se_portal_group->session_loc=
k held.
         */



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
