From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Fri, 8 Jan 2016 10:37:34 +0100
Message-ID: <20160108093734.GA1248@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-2-git-send-email-nab@daterainc.com> <20160108081412.GA32138@lst.de> <568F73D2.2090808@sandisk.com> <1452242859.27508.12.camel@haakon3.risingtidesystems.com> <20160108090846.GA746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160108090846.GA746@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 10:08:46AM +0100, Christoph Hellwig wrote:
> Another reason to introduce a helper to enforce that ordering!
> 
> Everything but iscsi and qla2xxx is absolutely trivial to convert.
> qla2xxx needs some work, but I think it's actually wrong currently
> as it sets the s_id and loop_id unconditionally even if we're
> reusing an existing node ACL.  iscsi is black magic as usual, so I'm
> a little lost..

FYI, here is the patch for the trivial cases.  Those needing the
tag allocator will need a little bit more work first


diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4fb0eca..3df1b21 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -806,54 +806,33 @@ static int tcm_loop_make_nexus(
 	struct tcm_loop_tpg *tl_tpg,
 	const char *name)
 {
-	struct se_portal_group *se_tpg;
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
-	int ret = -ENOMEM;
 
 	if (tl_tpg->tl_nexus) {
 		pr_debug("tl_tpg->tl_nexus already exists\n");
 		return -EEXIST;
 	}
-	se_tpg = &tl_tpg->tl_se_tpg;
 
 	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
 	if (!tl_nexus) {
 		pr_err("Unable to allocate struct tcm_loop_nexus\n");
 		return -ENOMEM;
 	}
-	/*
-	 * Initialize the struct se_session pointer
-	 */
-	tl_nexus->se_sess = transport_init_session(
+
+	tl_nexus->se_sess = target_alloc_session(&tl_tpg->tl_se_tpg, name,
+				tl_nexus,
 				TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
 	if (IS_ERR(tl_nexus->se_sess)) {
-		ret = PTR_ERR(tl_nexus->se_sess);
-		goto out;
-	}
-	/*
-	 * Since we are running in 'demo mode' this call with generate a
-	 * struct se_node_acl for the tcm_loop struct se_portal_group with the SCSI
-	 * Initiator port name of the passed configfs group 'name'.
-	 */
-	tl_nexus->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-				se_tpg, (unsigned char *)name);
-	if (!tl_nexus->se_sess->se_node_acl) {
-		transport_free_session(tl_nexus->se_sess);
-		goto out;
+		kfree(tl_nexus);
+		return PTR_ERR(tl_nexus->se_sess);
 	}
-	/* Now, register the I_T Nexus as active. */
-	transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
-			tl_nexus->se_sess, tl_nexus);
+
 	tl_tpg->tl_nexus = tl_nexus;
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		name);
 	return 0;
-
-out:
-	kfree(tl_nexus);
-	return ret;
 }
 
 static int tcm_loop_drop_nexus(
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 35f7d31..371d538 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -198,45 +198,28 @@ static struct sbp_session *sbp_session_create(
 	struct sbp_session *sess;
 	int ret;
 	char guid_str[17];
-	struct se_node_acl *se_nacl;
+
+	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
 
 	sess = kmalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
 		pr_err("failed to allocate session descriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
+	spin_lock_init(&sess->lock);
+	INIT_LIST_HEAD(&sess->login_list);
+	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
+	sess->guid = guid;
 
-	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	sess->se_sess = target_alloc_session(&tpg->se_tpg, guid_str, sess,
+			TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		pr_err("failed to init se_session\n");
-
 		ret = PTR_ERR(sess->se_sess);
 		kfree(sess);
 		return ERR_PTR(ret);
 	}
 
-	snprintf(guid_str, sizeof(guid_str), "%016llx", guid);
-
-	se_nacl = core_tpg_check_initiator_node_acl(&tpg->se_tpg, guid_str);
-	if (!se_nacl) {
-		pr_warn("Node ACL not found for %s\n", guid_str);
-
-		transport_free_session(sess->se_sess);
-		kfree(sess);
-
-		return ERR_PTR(-EPERM);
-	}
-
-	sess->se_sess->se_node_acl = se_nacl;
-
-	spin_lock_init(&sess->lock);
-	INIT_LIST_HEAD(&sess->login_list);
-	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
-
-	sess->guid = guid;
-
-	transport_register_session(&tpg->se_tpg, se_nacl, sess->se_sess, sess);
-
 	return sess;
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4fdcee2..f3074dd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -375,6 +375,27 @@ void transport_register_session(
 }
 EXPORT_SYMBOL(transport_register_session);
 
+struct se_session *target_alloc_session(struct se_portal_group *tpg,
+		const char *name, void *private, enum target_prot_op prot_op)
+{
+	struct se_session *sess;
+
+	sess = transport_init_session(prot_op);
+	if (IS_ERR(sess))
+		return sess;
+
+	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
+			(unsigned char *)name);
+	if (!sess->se_node_acl) {
+		transport_free_session(sess);
+		return ERR_PTR(-EACCES);
+	}
+
+	transport_register_session(tpg, sess->se_node_acl, sess, private);
+	return sess;
+}
+EXPORT_SYMBOL(target_alloc_session);
+
 static void target_release_session(struct kref *kref)
 {
 	struct se_session *se_sess = container_of(kref,
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 22e5615..48b661f 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -1541,7 +1541,6 @@ out:
 
 static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 {
-	struct se_portal_group *se_tpg;
 	struct tcm_usbg_nexus *tv_nexus;
 	int ret;
 
@@ -1549,44 +1548,24 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 	if (tpg->tpg_nexus) {
 		ret = -EEXIST;
 		pr_debug("tpg->tpg_nexus already exists\n");
-		goto err_unlock;
+		goto out_unlock;
 	}
-	se_tpg = &tpg->se_tpg;
 
 	ret = -ENOMEM;
 	tv_nexus = kzalloc(sizeof(*tv_nexus), GFP_KERNEL);
 	if (!tv_nexus)
-		goto err_unlock;
-	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
-	if (IS_ERR(tv_nexus->tvn_se_sess))
-		goto err_free;
+		goto out_unlock;
 
-	/*
-	 * Since we are running in 'demo mode' this call with generate a
-	 * struct se_node_acl for the tcm_vhost struct se_portal_group with
-	 * the SCSI Initiator port name of the passed configfs group 'name'.
-	 */
-	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-			se_tpg, name);
-	if (!tv_nexus->tvn_se_sess->se_node_acl) {
-		pr_debug("core_tpg_check_initiator_node_acl() failed"
-				" for %s\n", name);
-		goto err_session;
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, name,
+			tv_nexus, TARGET_PROT_NORMAL);
+	if (IS_ERR(tv_nexus->tvn_se_sess)) {
+		kfree(tv_nexus);
+		goto out_unlock;
 	}
-	/*
-	 * Now register the TCM vHost virtual I_T Nexus as active.
-	 */
-	transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
-			tv_nexus->tvn_se_sess, tv_nexus);
-	tpg->tpg_nexus = tv_nexus;
-	mutex_unlock(&tpg->tpg_mutex);
-	return 0;
 
-err_session:
-	transport_free_session(tv_nexus->tvn_se_sess);
-err_free:
-	kfree(tv_nexus);
-err_unlock:
+	tpg->tpg_nexus = tv_nexus;
+	ret = 0;
+out_unlock:
 	mutex_unlock(&tpg->tpg_mutex);
 	return ret;
 }
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ad4eb10..f09c30c 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1485,58 +1485,34 @@ static struct configfs_attribute *scsiback_param_attrs[] = {
 static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 				const char *name)
 {
-	struct se_portal_group *se_tpg;
-	struct se_session *se_sess;
 	struct scsiback_nexus *tv_nexus;
+	int ret = 0;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	if (tpg->tpg_nexus) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
 		pr_debug("tpg->tpg_nexus already exists\n");
-		return -EEXIST;
+		ret = -EEXIST;
+		goto out_unlock;
 	}
-	se_tpg = &tpg->se_tpg;
 
 	tv_nexus = kzalloc(sizeof(struct scsiback_nexus), GFP_KERNEL);
 	if (!tv_nexus) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_unlock;
 	}
-	/*
-	 * Initialize the struct se_session pointer
-	 */
-	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
+
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, name,
+			tv_nexus, TARGET_PROT_NORMAL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
-		return -ENOMEM;
-	}
-	se_sess = tv_nexus->tvn_se_sess;
-	/*
-	 * Since we are running in 'demo mode' this call with generate a
-	 * struct se_node_acl for the scsiback struct se_portal_group with
-	 * the SCSI Initiator port name of the passed configfs group 'name'.
-	 */
-	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
-				se_tpg, (unsigned char *)name);
-	if (!tv_nexus->tvn_se_sess->se_node_acl) {
-		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
-			 name);
-		goto out;
+		ret = -ENOMEM;
+		goto out_unlock;
 	}
-	/* Now register the TCM pvscsi virtual I_T Nexus as active. */
-	transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
-			tv_nexus->tvn_se_sess, tv_nexus);
-	tpg->tpg_nexus = tv_nexus;
 
+	tpg->tpg_nexus = tv_nexus;
+out_unlock:
 	mutex_unlock(&tpg->tv_tpg_mutex);
-	return 0;
-
-out:
-	transport_free_session(se_sess);
-	kfree(tv_nexus);
-	return -ENOMEM;
+	return ret;
 }
 
 static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 7fb2557..bbf7fb5 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -108,6 +108,9 @@ void target_unregister_template(const struct target_core_fabric_ops *fo);
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
+struct se_session *target_alloc_session(struct se_portal_group *tpg,
+		const char *name, void *private, enum target_prot_op prot_op);
+
 struct se_session *transport_init_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
