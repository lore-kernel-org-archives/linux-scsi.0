From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 4/4] target: Obtain se_node_acl->acl_kref during
 get_initiator_node_acl
Date: Wed, 13 Jan 2016 00:00:28 -0800
Message-ID: <1452672028.27508.40.camel@haakon3.risingtidesystems.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
	 <1452457724-10629-5-git-send-email-nab@daterainc.com>
	 <20160112150941.GC2058@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160112150941.GC2058@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-12 at 16:09 +0100, Christoph Hellwig wrote:
> > +++ b/drivers/target/target_core_tpg.c
> > @@ -75,9 +75,16 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
> >  	unsigned char *initiatorname)
> >  {
> >  	struct se_node_acl *acl;
> > -
> > +	/*
> > +	 * Obtain the acl_kref now, which will be dropped upon the
> > +	 * release of se_sess memory within transport_free_session().
> > +	 */
> 
> As said before this is incorrect, or rather shold be incorrect.  I
> think it should be removed, but if you want to keep it should be
> in core_tpg_check_initiator_node_acl and not here.
> 

Done.

Here's a incremental patch being folded in for -v3:

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 52ae8ba..62f02ea 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -75,16 +75,9 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
        unsigned char *initiatorname)
 {
        struct se_node_acl *acl;
-       /*
-        * Obtain the acl_kref now, which will be dropped upon the
-        * release of se_sess memory within transport_free_session().
-        */
+
        mutex_lock(&tpg->acl_node_mutex);
        acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-       if (acl) {
-               if (!kref_get_unless_zero(&acl->acl_kref))
-                       acl = NULL;
-       }
        mutex_unlock(&tpg->acl_node_mutex);
 
        return acl;
@@ -236,11 +229,24 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
        unsigned char *initiatorname)
 {
        struct se_node_acl *acl;
+       /*
+        * Obtain the acl_kref now, which will be dropped upon the
+        * release of se_sess memory within transport_free_session().
+        */
+       mutex_lock(&tpg->acl_node_mutex);
+       acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+       if (acl) {
+               if (!kref_get_unless_zero(&acl->acl_kref))
+                       acl = NULL;
+               mutex_unlock(&tpg->acl_node_mutex);
+               if (!acl)
+                       goto check_demo_mode;
 
-       acl = core_tpg_get_initiator_node_acl(tpg, initiatorname);
-       if (acl)
                return acl;
+       }
+       mutex_unlock(&tpg->acl_node_mutex);
 
+check_demo_mode:
        if (!tpg->se_tpg_tfo->tpg_check_demo_mode(tpg))
                return NULL;
> 
> 
> 
> The call of core_tpg_get_initiator_node_acl in
> iscsit_build_sendtargets_response needs a put to balance out the
> get of this kref while we're at it.

How about the following..?

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a81c0e5..4125520 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3383,6 +3383,7 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
        struct iscsi_portal_group *tpg;
        struct iscsi_tiqn *tiqn;
        struct iscsi_tpg_np *tpg_np;
+       struct se_node_acl *se_acl;
        int buffer_len, end_of_buf = 0, len = 0, payload_len = 0;
        int target_name_printed;
        unsigned char buf[ISCSI_IQN_LEN+12]; /* iqn + "TargetName=" + \0 */
@@ -3435,10 +3436,14 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 
                        if ((tpg->tpg_attrib.generate_node_acls == 0) &&
                            (tpg->tpg_attrib.demo_mode_discovery == 0) &&
-                           (!core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
-                               cmd->conn->sess->sess_ops->InitiatorName))) {
+                           (!(se_acl = core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
+                               cmd->conn->sess->sess_ops->InitiatorName)))) {
                                continue;
                        }
+                       if (se_acl) {
+                               target_put_nacl(se_acl);
+                               se_acl = NULL;
+                       }
 
                        spin_lock(&tpg->tpg_state_lock);
                        active = (tpg->tpg_state == TPG_STATE_ACTIVE);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c5035b9..a7c1bb5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -431,6 +431,7 @@ void target_put_nacl(struct se_node_acl *nacl)
 {
        kref_put(&nacl->acl_kref, target_complete_nacl);
 }
+EXPORT_SYMBOL(target_put_nacl);
 
 void transport_deregister_session_configfs(struct se_session *se_sess)
 {
