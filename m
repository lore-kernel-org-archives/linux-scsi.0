From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 17:05:21 -0400
Message-ID: <20120517210521.GE18067@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
 <20120517192830.GC18067@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:35108 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762434Ab2EQXKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 19:10:23 -0400
Content-Disposition: inline
In-Reply-To: <20120517192830.GC18067@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>

On Thu, 17 May 2012 15:28:30 -0400, J=C3=B6rn Engel wrote:
>=20
> tcm_qla2xxx_free_session  <-- removes from lookup tables
> qla_tgt_free_session_done
> ---                       <-- move to workqueue, dropping hardware_lo=
ck
> qla_tgt_unreg_sess
> tcm_qla2xxx_close_session <-- takes hardware_lock
> target_release_session
> target_put_session        <-- drops refcount
>=20
> Since the lookup tables are protected by hardware_lock, we would have
> to either take the hardware_lock _before_ dropping the reference coun=
t
> or do atomic_dec_and_lock().  Both of which requires knowledge about
> the qla2xxx hardware_lock in generic target code.

And below is a patch of RFC quality, at best.  Assuming it actually
does what it should do, this is still insufficient.
tcm_qla2xxx_find_sess_by_* currently don't take a refcount and in
particular the qla_tgt_reset() path will happily dereference the
session without a refcount.  Steve is currently working on that side.

Anyway, are there any other problems with the patch that I have
missed?

J=C3=B6rn

--
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace

[PATCH] qla_target: hold hardware_lock when dropping session refcount

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c        |   22 +++++++++++++++++++++=
-
 drivers/target/iscsi/iscsi_target.c       |    6 +++---
 drivers/target/iscsi/iscsi_target_login.c |    4 ++--
 drivers/target/target_core_tpg.c          |    4 ++--
 drivers/target/target_core_transport.c    |    6 +++---
 include/target/target_core_fabric.h       |    3 ++-
 6 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/=
tcm_qla2xxx.c
index 759c65b..bfdd6f2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -934,9 +934,28 @@ void tcm_qla2xxx_clear_nacl_from_fcport_map(struct=
 qla_tgt_sess *sess)
 			       nacl->nport_id);
 }
=20
+static void tcm_qla2xxx_release_session(struct kref *kref)
+{
+	struct se_session *se_sess =3D container_of(kref,
+			struct se_session, sess_kref);
+
+	tcm_qla2xxx_close_session(se_sess);
+}
+
+static void tcm_qla2xxx_put_session(struct se_session *se_sess)
+{
+	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
+	struct qla_hw_data *ha =3D sess->vha->hw;
+	unsigned long flags;
+
+	lock_hardware(ha, &flags);
+	kref_put(&se_sess->sess_kref, tcm_qla2xxx_release_session);
+	unlock_hardware(ha, &flags);
+}
+
 void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 {
-	target_put_session(sess->se_sess);
+	tcm_qla2xxx_put_session(sess->se_sess);
 }
=20
 void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
@@ -1833,6 +1852,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_=
ops =3D {
 	.new_cmd_map			=3D NULL,
 	.check_stop_free		=3D tcm_qla2xxx_check_stop_free,
 	.release_cmd			=3D tcm_qla2xxx_release_cmd,
+	.put_session			=3D tcm_qla2xxx_put_session,
 	.shutdown_session		=3D tcm_qla2xxx_shutdown_session,
 	.close_session			=3D tcm_qla2xxx_close_session,
 	.stop_session			=3D tcm_qla2xxx_stop_session,
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi=
/iscsi_target.c
index ebb835d..47fcd3a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4159,7 +4159,7 @@ int iscsit_close_connection(
 	if (!atomic_read(&sess->session_reinstatement) &&
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
-		target_put_session(sess->se_sess);
+		generic_target_put_session(sess->se_sess);
=20
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
@@ -4280,7 +4280,7 @@ static void iscsit_logout_post_handler_closesessi=
on(
 	iscsit_dec_conn_usage_count(conn);
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
-	target_put_session(sess->se_sess);
+	generic_target_put_session(sess->se_sess);
 }
=20
 static void iscsit_logout_post_handler_samecid(
@@ -4446,7 +4446,7 @@ int iscsit_free_session(struct iscsi_session *ses=
s)
 	} else
 		spin_unlock_bh(&sess->conn_lock);
=20
-	target_put_session(sess->se_sess);
+	generic_target_put_session(sess->se_sess);
 	return 0;
 }
=20
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target=
/iscsi/iscsi_target_login.c
index 02bea10..046c102 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -180,7 +180,7 @@ int iscsi_check_for_session_reinstatement(struct is=
csi_conn *conn)
 	if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
 		spin_unlock_bh(&sess->conn_lock);
 		iscsit_dec_session_usage_count(sess);
-		target_put_session(sess->se_sess);
+		generic_target_put_session(sess->se_sess);
 		return 0;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -188,7 +188,7 @@ int iscsi_check_for_session_reinstatement(struct is=
csi_conn *conn)
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
=20
-	target_put_session(sess->se_sess);
+	generic_target_put_session(sess->se_sess);
 	return 0;
 }
=20
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_c=
ore_tpg.c
index 70c3ffb..dfc1b1b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -510,10 +510,10 @@ int core_tpg_del_initiator_node_acl(
 		list_del(&sess->sess_acl_list);
=20
 		rc =3D tpg->se_tpg_tfo->shutdown_session(sess);
-		target_put_session(sess);
+		tpg->se_tpg_tfo->put_session(sess);
 		if (!rc)
 			continue;
-		target_put_session(sess);
+		tpg->se_tpg_tfo->put_session(sess);
 	}
 	target_put_nacl(acl);
 	/*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
index 50cb798..63089b4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -318,7 +318,7 @@ void transport_register_session(
 }
 EXPORT_SYMBOL(transport_register_session);
=20
-static void target_release_session(struct kref *kref)
+void target_release_session(struct kref *kref)
 {
 	struct se_session *se_sess =3D container_of(kref,
 			struct se_session, sess_kref);
@@ -333,11 +333,11 @@ void target_get_session(struct se_session *se_ses=
s)
 }
 EXPORT_SYMBOL(target_get_session);
=20
-int target_put_session(struct se_session *se_sess)
+int generic_target_put_session(struct se_session *se_sess)
 {
 	return kref_put(&se_sess->sess_kref, target_release_session);
 }
-EXPORT_SYMBOL(target_put_session);
+EXPORT_SYMBOL(generic_target_put_session);
=20
 static void target_complete_nacl(struct kref *kref)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/targe=
t_core_fabric.h
index b5927f1..ede0c84 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -51,6 +51,7 @@ struct target_core_fabric_ops {
 	 */
 	int (*check_release_cmd)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
+	void (*put_session)(struct se_session *se_sess);
 	/*
 	 * Called with spin_lock_bh(struct se_portal_group->session_lock held=
=2E
 	 */
@@ -107,7 +108,7 @@ void	__transport_register_session(struct se_portal_=
group *,
 void	transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	target_get_session(struct se_session *);
-int	target_put_session(struct se_session *);
+int	generic_target_put_session(struct se_session *);
 void	target_session_i_t_nexus(struct se_session *, const u8 **, size_t=
 *,
 				 const u8 **, size_t *);
 void	transport_free_session(struct se_session *);
--=20
1.7.10

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
