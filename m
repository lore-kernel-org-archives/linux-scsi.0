From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in fabric configfs handlers
Date: Sat, 30 Oct 2010 16:13:54 -0700
Message-ID: <1288480434-29670-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:28181 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752888Ab0J3XN7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2010 19:13:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>, Linda Xie <lxie@us.ibm.com>, Robert C Jennings <rcjenn@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch takes tomo-san original commit 94fdb0196151 and changes a handful
of important items wrt to the fabric configfs logic.

Firstly, this patch introduces struct ibmvscsis_vdev and converts the
VIO ibmvscsis_probe() and ibmvscsi_remove() callers to allocate/free
struct ibmvscsis_vdev instead of the original usage of struct ibmvscsis_tpg
which is intended to be allocated/freed respectively in ibmvscsis_make_tpg()
and ibmvscsis_drop_tpg() fabric configfs handlers.

Secondly, this patch changes the metadata that is used to determine the
fabric WWN and TPGT (collectively the TCM VIO SRP endpoint) layout for
/sys/kernel/config/target/ibmvscsis/$WWN/tpgt_$TPGT/.  This patch will
now use struct vio_dev->unit_address for $WWN, and dev_name(vio_dev->dev)
for $TPGT.  The values passed in via configff for $WWN and $TPGT must match
in ibmvscsis_make_tport() and ibmvscsis_make_tpg() against what has been
automatically setup for each struct ibmvscsis_vdev in the VIO ibmvscsis_probe()
callback.

And thirdly, this patch converts ibmvscsis to use 'demo-mode' instead of explict
struct se_node_acls.  This change follows TCM_Loop convention for an emulated
I_T Nexus, and adds an configfs attribute at:

	echo $VIO_SRP_INITIATOR_WWPN > \
		/sys/kernel/config/target/ibmvscsis/$UNIT_ADDRESS/tpgt_$DEV_NAME/nexus

Note this code does not currently enforce strict SRP Initiator WWPN naming
for the VIO Initiator Port, but this is something that will be added as the
PR transportID handlers are filled in.

Finally, this patch temporarily disables the per CDB emulation in
ibmvscsis_queuecommand() that still uses struct ibmvscsis_tpg instead of
struct ibmvscsis_vdev.  This is being fixed is a subsequent patch for the
I/O path <-> TCM code hookup.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/ibmvscsi/ibmvscsis.c |  629 ++++++++++++++++++++++++-------------
 1 files changed, 410 insertions(+), 219 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
index 5dfd31a..396de44 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsis.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
@@ -58,38 +58,24 @@ static char system_id[64] = "";
 static char partition_name[97] = "UNKNOWN";
 static unsigned int partition_number = -1;
 
-static LIST_HEAD(tpg_list);
-static DEFINE_SPINLOCK(tpg_lock);
+static LIST_HEAD(tcm_vdev_list);
+static DEFINE_SPINLOCK(tcm_vdev_lock);
 
-struct ibmvscsis_nacl {
+struct ibmvscsis_nexus {
 	/* Binary World Wide unique Port Name for SRP Initiator port */
 	u64 iport_wwpn;
 	/* ASCII formatted WWPN for Sas Initiator port */
 	char iport_name[IBMVSCSIS_NAMELEN];
-	/* Returned by ibmvscsis_make_nodeacl() */
-	struct se_node_acl se_node_acl;
-};
-
-struct ibmvscsis_tpg {
-	struct vio_dev *dma_dev;
-	struct list_head siblings;
 
+	struct ibmvscsis_tpg *parent_tpg;
 	struct se_session *se_sess;
+};
 
-	struct crq_queue crq_queue;
-
-	struct work_struct crq_work;
-
-	unsigned long liobn;
-	unsigned long riobn;
-
-	/* todo: remove */
-	struct srp_target srpt;
-
-	/* SRP port target portal group tag for TCM */
-	unsigned int tport_tpgt;
-	/* Pointer back to ibmvscsis_tport */
-	struct ibmvscsis_tport *tport;
+struct ibmvscsis_tpg {
+	unsigned short tpgt;
+	/* Used to ensure VIO I_T Nexus remains active while active port/LUNs exist  */
+	atomic_t tpg_port_count;
+	struct ibmvscsis_tport *tpg_tport;
 	/* Returned by ibmvscsis_make_tpg() */
 	struct se_portal_group se_tpg;
 };
@@ -101,10 +87,38 @@ struct ibmvscsis_tport {
 	u64 tport_wwpn;
 	/* ASCII formatted WWPN for SRP Target port */
 	char tport_name[IBMVSCSIS_NAMELEN];
+
+	struct ibmvscsis_nexus *tport_nexus;
+	struct ibmvscsis_vdev *tport_vdev;
+
 	/* Returned by ibmvscsis_make_tport() */
 	struct se_wwn tport_wwn;
 };
 
+/*
+ * Allocated during VIO ibmvscsis_probe() calls for an individual SRP endpoint,
+ * and will be mapped back to an individual struct ibmvscsis_tport TCM 1WWPN
+ * at ->vio_tport.
+ */
+struct ibmvscsis_vdev {
+	/* Defs required for VIO SRP STGT endpoint */
+	struct vio_dev *dma_dev;
+	struct list_head siblings;
+	struct crq_queue crq_queue;
+	struct work_struct crq_work;
+	unsigned long liobn;
+	unsigned long riobn;
+	/* SRP port target portal group tag for TCM report by struct vio_dev->dev */
+	unsigned int vio_tpgt;
+	/* Set to SRP by default for POWER5 VIO Firmware Ops */
+	int proto_id;
+
+	struct ibmvscsis_tport *vio_tport;
+
+	/* todo: remove */
+	struct srp_target srpt;
+};
+
 static int ibmvscsis_check_true(struct se_portal_group *se_tpg)
 {
 	return 1;
@@ -122,12 +136,13 @@ static char *ibmvscsis_get_fabric_name(void)
 
 static u8 ibmvscsis_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 {
-	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
-				struct ibmvscsis_tpg, se_tpg);
-	struct ibmvscsis_tport *tport = tpg->tport;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
 	u8 proto_id = 0;
 
-	switch (tport->tport_proto_id) {
+	switch (vdev->proto_id) {
 	case SCSI_PROTOCOL_SRP:
 	default:
 #warning FIXME: Add srp_get_fabric_proto_ident()
@@ -142,18 +157,21 @@ static u8 ibmvscsis_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 
 static char *ibmvscsis_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
-	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
-				struct ibmvscsis_tpg, se_tpg);
-	struct ibmvscsis_tport *tport = tpg->tport;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
 
 	return tport->tport_name;
 }
 
 static u16 ibmvscsis_get_tag(struct se_portal_group *se_tpg)
 {
-	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
-				struct ibmvscsis_tpg, se_tpg);
-	return tpg->tport_tpgt;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
+
+	return vdev->vio_tpgt;
 }
 
 static u32 ibmvscsis_get_default_depth(struct se_portal_group *se_tpg)
@@ -167,12 +185,13 @@ static u32 ibmvscsis_get_pr_transport_id(struct se_portal_group *se_tpg,
 					 int *format_code,
 					 unsigned char *buf)
 {
-	struct ibmvscsis_tpg *tpg =
-		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
-	struct ibmvscsis_tport *tport = tpg->tport;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
 	int ret = 0;
 
-	switch (tport->tport_proto_id) {
+	switch (vdev->proto_id) {
 	case SCSI_PROTOCOL_SRP:
 	default:
 #warning FIXME: Add srp_get_pr_transport_id()
@@ -191,12 +210,13 @@ static u32 ibmvscsis_get_pr_transport_id_len(struct se_portal_group *se_tpg,
 					     struct t10_pr_registration *pr_reg,
 					     int *format_code)
 {
-	struct ibmvscsis_tpg *tpg =
-		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
-	struct ibmvscsis_tport *tport = tpg->tport;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
 	int ret = 0;
 
-	switch (tport->tport_proto_id) {
+	switch (vdev->proto_id) {
 	case SCSI_PROTOCOL_SRP:
 	default:
 #warning FIXME: Add srp_get_pr_transport_id_len()
@@ -215,12 +235,13 @@ static char *ibmvscsis_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 						 u32 *out_tid_len,
 						 char **port_nexus_ptr)
 {
-	struct ibmvscsis_tpg *tpg =
-		container_of(se_tpg, struct ibmvscsis_tpg, se_tpg);
-	struct ibmvscsis_tport *tport = tpg->tport;
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct ibmvscsis_tport *tport = container_of(wwn,
+				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
 	char *tid = NULL;
 
-	switch (tport->tport_proto_id) {
+	switch (vdev->proto_id) {
 	case SCSI_PROTOCOL_SRP:
 	default:
 #warning FIXME: Add srp_parse_pr_out_transport_id()
@@ -234,25 +255,20 @@ static char *ibmvscsis_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 	return tid;
 }
 
+/*
+ * Note that ibmvscsis_alloc_fabric_acl() and ibmvscsis_release_fabric_acl()
+ * are NOPs as IBMVSCSIS code is running in 'demo-mode', so adding explict
+ * configfs level struct se_node_acls is currently not required.
+ */
 static struct se_node_acl *ibmvscsis_alloc_fabric_acl(struct se_portal_group *se_tpg)
 {
-	struct ibmvscsis_nacl *nacl;
-
-	nacl = kzalloc(sizeof(struct ibmvscsis_nacl), GFP_KERNEL);
-	if (!(nacl)) {
-		printk(KERN_ERR "Unable to alocate struct ibmvscsis_nacl\n");
-		return NULL;
-	}
-
-	return &nacl->se_node_acl;
+	return NULL;
 }
 
 static void ibmvscsis_release_fabric_acl(struct se_portal_group *se_tpg,
-					 struct se_node_acl *se_nacl)
+					struct se_node_acl *se_nacl)
 {
-	struct ibmvscsis_nacl *nacl = container_of(se_nacl,
-			struct ibmvscsis_nacl, se_node_acl);
-	kfree(nacl);
+	return;
 }
 
 static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
@@ -366,153 +382,296 @@ static u64 ibmvscsis_pack_lun(unsigned int lun)
 /* Local pointer to allocated TCM configfs fabric module */
 static struct target_fabric_configfs *ibmvscsis_fabric_configfs;
 
-static struct se_node_acl *ibmvscsis_make_nodeacl(
+int ibmvscsis_port_link(
+	struct se_portal_group *se_tpg,
+	struct se_lun *lun)
+{
+	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
+				struct ibmvscsis_tpg, se_tpg);
+
+	atomic_inc(&tpg->tpg_port_count);
+	smp_mb__after_atomic_inc();
+
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Port Link Successful\n");
+	return 0;
+}
+
+void ibmvscsis_port_unlink(
 	struct se_portal_group *se_tpg,
-	struct config_group *group,
+	struct se_lun *se_lun)
+{
+	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
+				struct ibmvscsis_tpg, se_tpg);
+
+	atomic_dec(&tpg->tpg_port_count);
+	smp_mb__after_atomic_dec();
+
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Port  Unlink Successful\n");
+}
+
+static int ibmvscsis_make_nexus(
+	struct ibmvscsis_tpg *tpg,
 	const char *name)
 {
-	struct se_node_acl *se_nacl, *se_nacl_new;
-	struct ibmvscsis_nacl *nacl;
-	u64 wwpn = 0;
-	u32 nexus_depth;
+	struct se_portal_group *se_tpg;
+	struct ibmvscsis_tport *tport = tpg->tpg_tport;
+	struct ibmvscsis_nexus *nexus;
 
-	printk("%s %d: %s\n", __func__, __LINE__, name);
+	if (tport->tport_nexus) {
+		printk(KERN_INFO "tport->tport_nexus already exists\n");
+		return -EEXIST;
+	}
+	se_tpg = &tpg->se_tpg;
 
-	se_nacl_new = ibmvscsis_alloc_fabric_acl(se_tpg);
-	if (!(se_nacl_new))
-		return ERR_PTR(-ENOMEM);
-//#warning FIXME: Hardcoded nexus depth in ibmvscsis_make_nodeacl()
-	nexus_depth = 1;
+	nexus = kzalloc(sizeof(struct ibmvscsis_nexus), GFP_KERNEL);
+	if (!(nexus))
+		return -ENOMEM;
+	/*
+	 * Initialize the struct se_session pointer
+	 */
+	nexus->se_sess = transport_init_session();
+	if (!(nexus->se_sess))
+		goto out;
+	/*
+	 * Since we are running in 'demo mode' this call with generate a
+	 * struct se_node_acl for the ibmvscsi struct se_portal_group with
+	 * the SCSI Initiator port name of the passed configfs group 'name'.
+	 */
+	nexus->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
+				se_tpg, (unsigned char *)name);
+	if (!(nexus->se_sess->se_node_acl)) {
+		transport_free_session(nexus->se_sess);
+		goto out;
+	}
 	/*
-	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
-	 * when converting a NodeACL from demo mode -> explict
+	 * Now, register the VIO SRP I_T Nexus as active with the call to
+	 * transport_register_session()
 	 */
-	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
-				name, nexus_depth);
-	if (IS_ERR(se_nacl)) {
-		ibmvscsis_release_fabric_acl(se_tpg, se_nacl_new);
-		return se_nacl;
+	__transport_register_session(se_tpg, nexus->se_sess->se_node_acl,
+				nexus->se_sess, (void *)nexus);
+	tport->tport_nexus = nexus;
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Established I_T Nexus to"
+			" VIO Initiator Port: %s\n", name);
+	return 0;
+out:
+	kfree(nexus);
+	return -ENOMEM;
+}
+
+static int ibmvscsis_drop_nexus(
+	struct ibmvscsis_tpg *tpg)
+{
+	struct ibmvscsis_tport *tport = tpg->tpg_tport;
+	struct se_session *se_sess;
+	struct ibmvscsis_nexus *nexus;
+
+	nexus = tport->tport_nexus;
+	if (!(nexus))
+		return -ENODEV;
+
+	se_sess = nexus->se_sess;
+	if (!(se_sess))
+		return -ENODEV;
+
+	if (atomic_read(&tpg->tpg_port_count)) {
+		 printk(KERN_ERR "Unable to remove VIO I_T Nexus with"
+			" active TPG port count: %d\n",
+			atomic_read(&tpg->tpg_port_count));
+		return -EPERM;
 	}
+
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Removing I_T Nexus to VIO Initiator"
+		" Port: %s\n", nexus->se_sess->se_node_acl->initiatorname);
 	/*
-	 * Locate our struct ibmvscsis_nacl and set the FC Nport WWPN
+	 * Release the SCSI I_T Nexus to the emulated SRP target port
 	 */
-	nacl = container_of(se_nacl, struct ibmvscsis_nacl, se_node_acl);
-	nacl->iport_wwpn = wwpn;
-	/* ibmvscsis_format_wwn(&nacl->iport_name[0], IBMVSCSIS_NAMELEN, wwpn); */
+	transport_deregister_session(nexus->se_sess);
+	tport->tport_nexus = NULL;
+	kfree(nexus);
 
-	return se_nacl;
+	return 0;
 }
 
-static void ibmvscsis_drop_nodeacl(struct se_node_acl *se_acl)
+static ssize_t ibmvscsis_tpg_show_nexus(
+	struct se_portal_group *se_tpg,
+	char *page)
 {
-	struct ibmvscsis_nacl *nacl = container_of(se_acl,
-				struct ibmvscsis_nacl, se_node_acl);
-	kfree(nacl);
+	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
+			struct ibmvscsis_tpg, se_tpg);
+	struct ibmvscsis_nexus *nexus;
+
+	nexus = tpg->tpg_tport->tport_nexus;
+	if (!(nexus)) 
+		return -ENODEV;
+
+	return snprintf(page, PAGE_SIZE, "%s\n",
+		nexus->se_sess->se_node_acl->initiatorname);
 }
 
+static ssize_t ibmvscsis_tpg_store_nexus(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
+			struct ibmvscsis_tpg, se_tpg);
+	unsigned char i_port[IBMVSCSIS_NAMELEN], *port_ptr;
+	int ret;		
+	/*
+	 * Shutdown the active I_T nexus if 'NULL' is passed..
+	 */
+	if (!(strncmp(page, "NULL", 4))) {
+		ret = ibmvscsis_drop_nexus(tpg);
+		return (!ret) ? count : ret;
+	}
+
+	if (strlen(page) > IBMVSCSIS_NAMELEN) {
+		printk(KERN_ERR "VIO SRP Address: %s exceeds max: %d\n",
+				page, IBMVSCSIS_NAMELEN);
+		return -EINVAL;
+	}
+	snprintf(&i_port[0], IBMVSCSIS_NAMELEN, "%s", page);
+	port_ptr = &i_port[0];	
+
+#warning FIXME: Check for explict srp. for emulated VIO Initiator WWPN
+	/*
+	 * Clear any trailing newline for the VIO Initiator WWPN
+	 */
+	if (i_port[strlen(i_port)-1] == '\n')
+		i_port[strlen(i_port)-1] = '\0';
+
+	ret = ibmvscsis_make_nexus(tpg, port_ptr);
+	
+	return (ret < 0) ? ret : count;
+}
+	
+
+TF_TPG_BASE_ATTR(ibmvscsis, nexus, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *ibmvscsis_tpg_attrs[] = {
+	&ibmvscsis_tpg_nexus.attr,
+	NULL,
+};
+
 static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
 						  struct config_group *group,
 						  const char *name)
 {
-	struct ibmvscsis_tport*tport = container_of(wwn,
+	struct ibmvscsis_tport *tport = container_of(wwn,
 			struct ibmvscsis_tport, tport_wwn);
-
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
 	struct ibmvscsis_tpg *tpg;
 	unsigned long tpgt;
 	int ret;
-	unsigned long flags;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
 	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
 		return ERR_PTR(-EINVAL);
-
-	spin_lock_irqsave(&tpg_lock, flags);
-	list_for_each_entry(tpg, &tpg_list, siblings) {
-		printk("%s %d: %s %u, %lu\n", __func__, __LINE__,
-		       dev_name(&tpg->dma_dev->dev),
-		       tpg->tport_tpgt, tpgt);
-
-		if (tpgt == tpg->tport_tpgt)
-			goto found;
-	}
-	printk("%s %d: can't find %s\n", __func__, __LINE__, name);
-	ret = -EINVAL;
-	goto unlock;
-found:
-	if (tpg->tport) {
-		printk("%s %d: already bind %s\n", __func__, __LINE__, name);
-		ret = -EINVAL;
-		goto unlock;
+	/*
+	 * Compare the configfs passed tpgt against the vdev->vio_tpgt
+	 * detrmined by dev_name(&dev->dev) in ibmvscsis_probe().
+	 */
+	if (vdev->vio_tpgt != (unsigned int)tpgt) {
+		printk(KERN_ERR "Passed configfs tpgt: %lu does not match VIO"
+			" presented tpgt: %u\n", tpgt, vdev->vio_tpgt);
+		return ERR_PTR(-EINVAL);
 	}
 
-	tpg->tport = tport;
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
+	if (!(tpg))
+		return ERR_PTR(-ENOMEM);
 
-	spin_unlock_irqrestore(&tpg_lock, flags);
+	tpg->tpg_tport = tport;
+	tpg->tpgt = (unsigned short)tpgt;
 
 	ret = core_tpg_register(&ibmvscsis_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, (void *)tpg,
 				TRANSPORT_TPG_TYPE_NORMAL);
-	if (ret)
-		return ERR_PTR(-ENOMEM);
-
-	printk("%s %d: %d\n", __func__, __LINE__, ret);
-
-	tpg->se_sess = transport_init_session();
-	if (!tpg->se_sess) {
-		core_tpg_deregister(&tpg->se_tpg);
+	if (ret) {
+		kfree(tpg);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	printk("%s %d\n", __func__, __LINE__);
-
-	tpg->se_sess->se_node_acl =
-		core_tpg_check_initiator_node_acl(&tpg->se_tpg,
-						  (unsigned char*)dev_name(&tpg->dma_dev->dev));
-
-	transport_register_session(&tpg->se_tpg, tpg->se_sess->se_node_acl,
-				   tpg->se_sess, tpg);
-
-	printk("%s %d: %p %p\n", __func__, __LINE__, tpg, &tpg->se_tpg);
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Allocated VIO Target Port"
+		" %s,t,0x%04x\n", config_item_name(&wwn->wwn_group.cg_item),
+		(unsigned short)tpg->tpgt);
 
 	return &tpg->se_tpg;
-unlock:
-	spin_unlock_irqrestore(&tpg_lock, flags);
-	return ERR_PTR(ret);
 }
 
 static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
 {
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
 	struct ibmvscsis_tpg *tpg = container_of(se_tpg,
 				struct ibmvscsis_tpg, se_tpg);
-	unsigned long flags;
-
-
-	transport_deregister_session_configfs(tpg->se_sess);
-	transport_free_session(tpg->se_sess);
+	/*
+	 * Release the I_T Nexus for the Virtual SRP link if present
+	 */
+	ibmvscsis_drop_nexus(tpg);
+	/*
+	 * Deregister the tpg as a emulated SRP TCM Target Endpoint
+	 */
 	core_tpg_deregister(se_tpg);
 
-	spin_lock_irqsave(&tpg_lock, flags);
-	tpg->tport = NULL;
-	tpg->se_sess = NULL;
-	spin_unlock_irqrestore(&tpg_lock, flags);
+	printk(KERN_INFO "IBMVSCSI_ConfigFS: Deallocated VIO Target Port"
+		" %s,t,0x%04x\n", config_item_name(&wwn->wwn_group.cg_item),
+		tpg->tpgt);
+
+	kfree(tpg);
 }
 
+/*
+ * Called by target_core_fabric_configfs.c:target_fabric_make_wwn*() to
+ * look for a matching struct ibmvscsis_vdev setup by ibmvscsis_probe()
+ * below
+ */
 static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
 					   struct config_group *group,
 					   const char *name)
 {
+	struct ibmvscsis_vdev *vdev;
 	struct ibmvscsis_tport *tport;
+	unsigned long flags, vio_unit_address;
+	int ret;
 
 	printk("%s %d: create %s\n", __func__, __LINE__, name);
 
+	ret = strict_strtoul(name, 0, &vio_unit_address);
+	if (ret < 0) {
+		printk(KERN_ERR "strict_strtoul() failed with"
+			" ret: %d\n", ret);
+		return ERR_PTR(-EINVAL);
+	}
+
 	tport = kzalloc(sizeof(*tport), GFP_KERNEL);
 	if (!(tport)) {
 		printk(KERN_ERR "Unable to allocate struct tcm_ibmvscsis_tport");
 		return ERR_PTR(-ENOMEM);
 	}
-	/* tport->tport_wwpn = wwpn; */
 
+	spin_lock_irqsave(&tcm_vdev_lock, flags);
+	list_for_each_entry(vdev, &tcm_vdev_list, siblings) {
+		if (vdev->dma_dev->unit_address == (u32)vio_unit_address)
+			goto found;
+	}
+
+	printk(KERN_ERR "Unable to locate VIO SRP Endpoint with configfs passed"
+			" vio_unit_address: 0x%08x\n", (u32)vio_unit_address);
+	spin_unlock_irqrestore(&tcm_vdev_lock, flags);
+	return ERR_PTR(-EINVAL);
+
+found:
+	tport->tport_wwpn = (u32)vdev->dma_dev->unit_address;
+	tport->tport_vdev = vdev;
+	vdev->vio_tport = tport;
+
+	printk(KERN_ERR "IBMVSCSI_ConfigFS: Allocated TPORT WWPN <-> VDEV"
+		" for vio_dev->unit_address: 0x%08x vio_tpgt: %u VIO Initiator"
+		" WWPN: %s\n", vdev->dma_dev->unit_address, vdev->vio_tpgt,
+		dev_name(&vdev->dma_dev->dev));
+
+	spin_unlock_irqrestore(&tcm_vdev_lock, flags);
 	return &tport->tport_wwn;
 }
 
@@ -520,6 +679,16 @@ static void ibmvscsis_drop_tport(struct se_wwn *wwn)
 {
 	struct ibmvscsis_tport *tport = container_of(wwn,
 				struct ibmvscsis_tport, tport_wwn);
+	struct ibmvscsis_vdev *vdev = tport->tport_vdev;
+
+	vdev->vio_tport = NULL;
+	tport->tport_vdev = NULL;
+
+	printk(KERN_ERR "IBMVSCSI_ConfigFS: Deallocated TPORT WWPN <-> VDEV "
+		" for vio_dev->unit_address: 0x%08x vio_tpgt: %u VIO Initiator"
+		" WWPN: %s\n", vdev->dma_dev->unit_address, vdev->vio_tpgt,
+		dev_name(&vdev->dma_dev->dev));
+
 	kfree(tport);
 }
 
@@ -587,8 +756,8 @@ static struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_pre_unlink		= NULL,
 	.fabric_make_np			= NULL,
 	.fabric_drop_np			= NULL,
-	.fabric_make_nodeacl		= ibmvscsis_make_nodeacl,
-	.fabric_drop_nodeacl		= ibmvscsis_drop_nodeacl,
+	.fabric_make_nodeacl		= NULL,
+	.fabric_drop_nodeacl		= NULL,
 };
 
 static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
@@ -599,7 +768,7 @@ static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
 static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 {
 	struct srp_target *target = iue->target;
-	struct ibmvscsis_tpg *tpg = target->ldata;
+	struct ibmvscsis_vdev *vdev = target->ldata;
 	long rc, rc1;
 	union {
 		struct viosrp_crq cooked;
@@ -607,8 +776,8 @@ static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 	} crq;
 
 	/* First copy the SRP */
-	rc = h_copy_rdma(length, tpg->liobn, iue->sbuf->dma,
-			 tpg->riobn, iue->remote_token);
+	rc = h_copy_rdma(length, vdev->liobn, iue->sbuf->dma,
+			 vdev->riobn, iue->remote_token);
 
 	if (rc)
 		printk(KERN_ERR "Error %ld transferring data\n", rc);
@@ -625,7 +794,7 @@ static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 	else
 		crq.cooked.status = 0x00;
 
-	rc1 = h_send_crq(tpg->dma_dev->unit_address, crq.raw[0], crq.raw[1]);
+	rc1 = h_send_crq(vdev->dma_dev->unit_address, crq.raw[0], crq.raw[1]);
 
 	if (rc1) {
 		printk(KERN_ERR "%ld sending response\n", rc1);
@@ -695,12 +864,12 @@ static int send_adapter_info(struct iu_entry *iue,
 			     dma_addr_t remote_buffer, u16 length)
 {
 	struct srp_target *target = iue->target;
-	struct ibmvscsis_tpg *tpg = target->ldata;
+	struct ibmvscsis_vdev *vdev = target->ldata;
 	dma_addr_t data_token;
 	struct mad_adapter_info_data *info;
 	int err;
 
-	info = dma_alloc_coherent(&tpg->dma_dev->dev, sizeof(*info), &data_token,
+	info = dma_alloc_coherent(&vdev->dma_dev->dev, sizeof(*info), &data_token,
 				  GFP_KERNEL);
 	if (!info) {
 		printk(KERN_ERR "bad dma_alloc_coherent %p\n", target);
@@ -708,8 +877,8 @@ static int send_adapter_info(struct iu_entry *iue,
 	}
 
 	/* Get remote info */
-	err = h_copy_rdma(sizeof(*info), tpg->riobn, remote_buffer,
-			  tpg->liobn, data_token);
+	err = h_copy_rdma(sizeof(*info), vdev->riobn, remote_buffer,
+			  vdev->liobn, data_token);
 	if (err == H_SUCCESS) {
 		printk(KERN_INFO "Client connect: %s (%d)\n",
 		       info->partition_name, info->partition_number);
@@ -726,10 +895,10 @@ static int send_adapter_info(struct iu_entry *iue,
 	info->port_max_txu[0] = DEFAULT_MAX_SECTORS << 9;
 
 	/* Send our info to remote */
-	err = h_copy_rdma(sizeof(*info), tpg->liobn, data_token,
-			  tpg->riobn, remote_buffer);
+	err = h_copy_rdma(sizeof(*info), vdev->liobn, data_token,
+			  vdev->riobn, remote_buffer);
 
-	dma_free_coherent(&tpg->dma_dev->dev, sizeof(*info), info, data_token);
+	dma_free_coherent(&vdev->dma_dev->dev, sizeof(*info), info, data_token);
 
 	if (err != H_SUCCESS) {
 		printk(KERN_INFO "Error sending adapter info %d\n", err);
@@ -831,13 +1000,13 @@ static int process_srp_iu(struct iu_entry *iue)
 	return done;
 }
 
-static void process_iu(struct viosrp_crq *crq, struct ibmvscsis_tpg *tpg)
+static void process_iu(struct viosrp_crq *crq, struct ibmvscsis_vdev *vdev)
 {
 	struct iu_entry *iue;
 	long err;
 	int done = 1;
 
-	iue = srp_iu_get(&tpg->srpt);
+	iue = srp_iu_get(&vdev->srpt);
 	if (!iue) {
 		printk(KERN_ERR "Error getting IU from pool\n");
 		return;
@@ -845,8 +1014,8 @@ static void process_iu(struct viosrp_crq *crq, struct ibmvscsis_tpg *tpg)
 
 	iue->remote_token = crq->IU_data_ptr;
 
-	err = h_copy_rdma(crq->IU_length, tpg->riobn,
-			  iue->remote_token, tpg->liobn, iue->sbuf->dma);
+	err = h_copy_rdma(crq->IU_length, vdev->riobn,
+			  iue->remote_token, vdev->liobn, iue->sbuf->dma);
 
 	if (err != H_SUCCESS) {
 		printk(KERN_ERR "%ld transferring data error %p\n", err, iue);
@@ -862,17 +1031,17 @@ out:
 		srp_iu_put(iue);
 }
 
-static void process_crq(struct viosrp_crq *crq,	struct ibmvscsis_tpg *tpg)
+static void process_crq(struct viosrp_crq *crq,	struct ibmvscsis_vdev *vdev)
 {
 	/* printk(KERN_INFO "%s: %p %x %x\n", __func__, */
-	/*        tpg, crq->valid, crq->format); */
+	/*        vdev, crq->valid, crq->format); */
 
 	switch (crq->valid) {
 	case 0xC0:
 		/* initialization */
 		switch (crq->format) {
 		case 0x01:
-			h_send_crq(tpg->dma_dev->unit_address,
+			h_send_crq(vdev->dma_dev->unit_address,
 				   0xC002000000000000, 0);
 			break;
 		case 0x02:
@@ -889,7 +1058,7 @@ static void process_crq(struct viosrp_crq *crq,	struct ibmvscsis_tpg *tpg)
 		switch (crq->format) {
 		case VIOSRP_SRP_FORMAT:
 		case VIOSRP_MAD_FORMAT:
-			process_iu(crq, tpg);
+			process_iu(crq, vdev);
 			break;
 		case VIOSRP_OS400_FORMAT:
 		case VIOSRP_AIX_FORMAT:
@@ -1023,6 +1192,7 @@ static int ibmvscsis_inquery(struct ibmvscsis_tpg *tpg,
 			      struct srp_cmd *cmd, char *data)
 {
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
+	
 	struct inquiry_data *id = (struct inquiry_data *)data;
 	u64 unpacked_lun, lun = cmd->lun;
 	u8 *cdb = cmd->cdb;
@@ -1064,7 +1234,7 @@ static int ibmvscsis_inquery(struct ibmvscsis_tpg *tpg,
 			 "IBM-VSCSI-%s-P%d-%x-%d-%d-%d\n",
 			 system_id,
 			 partition_number,
-			 tpg->dma_dev->unit_address,
+			 tpg->tpg_tport->tport_vdev->dma_dev->unit_address,
 			 GETBUS(lun),
 			 GETTARGET(lun),
 			 GETLUN(lun));
@@ -1254,7 +1424,7 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 {
 	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
 	struct srp_target *target = iue->target;
-	struct ibmvscsis_tpg *tpg = target->ldata;
+	struct ibmvscsis_vdev *vdev = target->ldata;
 	dma_addr_t token;
 	long err;
 	unsigned int done = 0;
@@ -1275,15 +1445,15 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 
 			if (dir == DMA_TO_DEVICE)
 				err = h_copy_rdma(slen,
-						  tpg->riobn,
+						  vdev->riobn,
 						  md[i].va + mdone,
-						  tpg->liobn,
+						  vdev->liobn,
 						  token + soff);
 			else
 				err = h_copy_rdma(slen,
-						  tpg->liobn,
+						  vdev->liobn,
 						  token + soff,
-						  tpg->riobn,
+						  vdev->riobn,
 						  md[i].va + mdone);
 
 			if (err != H_SUCCESS) {
@@ -1344,7 +1514,7 @@ static int ibmvscsis_cmd_done(struct scsi_cmnd *sc)
 	return 0;
 }
 
-static int ibmvscsis_queuecommand(struct ibmvscsis_tpg *tpg,
+static int ibmvscsis_queuecommand(struct ibmvscsis_vdev *vdev,
 				  struct iu_entry *iue)
 {
 	int data_len;
@@ -1358,11 +1528,13 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_tpg *tpg,
 	       __func__, __LINE__, cmd->cdb[0], data_len,
 	       srp_cmd_direction(cmd), (unsigned long)cmd->lun);
 
+#warning Use ibmvscsis_cmd->sc descriptor
 	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
 	sc->cmnd = cmd->cdb;
 	sc->SCp.ptr = (char *)iue;
 
 	switch (cmd->cdb[0]) {
+#if 0
 	case INQUIRY:
 		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
 		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
@@ -1421,6 +1593,7 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_tpg *tpg,
 		__free_page(pg);
 		kfree(sc);
 		break;
+#endif
 	default:
 		/* fixme: needs to use tcm */
 		sc->result = COMMAND_TERMINATED;
@@ -1432,9 +1605,9 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_tpg *tpg,
 	return 0;
 }
 
-static void handle_cmd_queue(struct ibmvscsis_tpg *tpg)
+static void handle_cmd_queue(struct ibmvscsis_vdev *vdev)
 {
-	struct srp_target *target = &tpg->srpt;
+	struct srp_target *target = &vdev->srpt;
 	struct iu_entry *iue;
 	struct srp_cmd *cmd;
 	unsigned long flags;
@@ -1446,7 +1619,7 @@ retry:
 	list_for_each_entry(iue, &target->cmd_queue, ilist) {
 		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
 			spin_unlock_irqrestore(&target->lock, flags);
-			err = ibmvscsis_queuecommand(tpg, iue);
+			err = ibmvscsis_queuecommand(vdev, iue);
 			if (err) {
 				printk(KERN_ERR "cannot queue cmd %p %d\n", cmd, err);
 				srp_iu_put(iue);
@@ -1460,45 +1633,45 @@ retry:
 
 static void handle_crq(struct work_struct *work)
 {
-	struct ibmvscsis_tpg *tpg =
-		container_of(work, struct ibmvscsis_tpg, crq_work);
+	struct ibmvscsis_vdev *vdev =
+		container_of(work, struct ibmvscsis_vdev, crq_work);
 	struct viosrp_crq *crq;
 	int done = 0;
 
 	while (!done) {
-		while ((crq = next_crq(&tpg->crq_queue)) != NULL) {
-			process_crq(crq, tpg);
+		while ((crq = next_crq(&vdev->crq_queue)) != NULL) {
+			process_crq(crq, vdev);
 			crq->valid = 0x00;
 		}
 
-		vio_enable_interrupts(tpg->dma_dev);
+		vio_enable_interrupts(vdev->dma_dev);
 
-		crq = next_crq(&tpg->crq_queue);
+		crq = next_crq(&vdev->crq_queue);
 		if (crq) {
-			vio_disable_interrupts(tpg->dma_dev);
-			process_crq(crq, tpg);
+			vio_disable_interrupts(vdev->dma_dev);
+			process_crq(crq, vdev);
 			crq->valid = 0x00;
 		} else
 			done = 1;
 	}
 
-	handle_cmd_queue(tpg);
+	handle_cmd_queue(vdev);
 }
 
 static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
 {
-	struct ibmvscsis_tpg *tpg = data;
+	struct ibmvscsis_vdev *vdev = data;
 
-	vio_disable_interrupts(tpg->dma_dev);
-	schedule_work(&tpg->crq_work);
+	vio_disable_interrupts(vdev->dma_dev);
+	schedule_work(&vdev->crq_work);
 
 	return IRQ_HANDLED;
 }
 
-static int crq_queue_create(struct crq_queue *queue, struct ibmvscsis_tpg *tpg)
+static int crq_queue_create(struct crq_queue *queue, struct ibmvscsis_vdev *tcm_vdev)
 {
 	int err;
-	struct vio_dev *vdev = tpg->dma_dev;
+	struct vio_dev *vdev = tcm_vdev->dma_dev;
 
 	queue->msgs = (struct viosrp_crq *) get_zeroed_page(GFP_KERNEL);
 	if (!queue->msgs)
@@ -1533,7 +1706,7 @@ static int crq_queue_create(struct crq_queue *queue, struct ibmvscsis_tpg *tpg)
 	}
 
 	err = request_irq(vdev->irq, &ibmvscsis_interrupt,
-			  IRQF_DISABLED, "ibmvscsis", tpg);
+			  IRQF_DISABLED, "ibmvscsis", tcm_vdev);
 	if (err)
 		goto req_irq_failed;
 
@@ -1561,85 +1734,103 @@ malloc_failed:
 	return -ENOMEM;
 }
 
-static void crq_queue_destroy(struct ibmvscsis_tpg *tpg)
+static void crq_queue_destroy(struct ibmvscsis_vdev *vdev)
 {
-	struct crq_queue *queue = &tpg->crq_queue;
+	struct crq_queue *queue = &vdev->crq_queue;
 	int err;
 
-	free_irq(tpg->dma_dev->irq, tpg);
+	free_irq(vdev->dma_dev->irq, vdev);
 	do {
-		err = h_free_crq(tpg->dma_dev->unit_address);
+		err = h_free_crq(vdev->dma_dev->unit_address);
 	} while (err == H_BUSY || H_IS_LONG_BUSY(err));
 
-	dma_unmap_single(&tpg->dma_dev->dev, queue->msg_token,
+	dma_unmap_single(&vdev->dma_dev->dev, queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
 
 	free_page((unsigned long)queue->msgs);
 }
 
+/*
+ * Called by arch/powerpc/kernel/vio.c:vio_bus_probe() once a VIO SRP T/I Nexus
+ * has been detected to start the target port endpoint registration process
+ * within TCM.
+ */
 static int ibmvscsis_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
+	struct ibmvscsis_vdev *vdev;
 	unsigned int *dma, dma_size;
 	unsigned long flags;
 	int ret;
-	struct ibmvscsis_tpg *tpg;
 
 	printk("%s: %s %s %x\n", __func__, dev->name, dev_name(&dev->dev),
 	       dev->unit_address);
 
-	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
-	if (!tpg)
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
 		return -ENOMEM;
 
-	tpg->dma_dev = dev;
+	vdev->dma_dev = dev;
 
-	printk("%s %d: %p %p\n", __func__, __LINE__, tpg, &tpg->se_tpg);
+	printk("%s %d: %p\n", __func__, __LINE__, vdev);
 
 	dma = (unsigned int *)vio_get_attribute(dev, "ibm,my-dma-window",
 						&dma_size);
 	if (!dma || dma_size != 40) {
 		printk(KERN_ERR "Couldn't get window property %d\n", dma_size);
-		kfree(tpg);
+		kfree(vdev);
 		return -EIO;
 	}
+	/*
+	 * Assume VIO POWER5 SRP firmware..
+	 */
+	vdev->proto_id = SCSI_PROTOCOL_SRP;
+	vdev->liobn = dma[0];
+	vdev->riobn = dma[5];
+	vdev->vio_tpgt = simple_strtoul(dev_name(&dev->dev), NULL, 10);
 
-	tpg->liobn = dma[0];
-	tpg->riobn = dma[5];
-	tpg->tport_tpgt = simple_strtoul(dev_name(&dev->dev), NULL, 10);
-
-	spin_lock_irqsave(&tpg_lock, flags);
-	list_add(&tpg->siblings, &tpg_list);
-	spin_unlock_irqrestore(&tpg_lock, flags);
+	spin_lock_irqsave(&tcm_vdev_lock, flags);
+	list_add(&vdev->siblings, &tcm_vdev_list);
+	spin_unlock_irqrestore(&tcm_vdev_lock, flags);
 
-	INIT_WORK(&tpg->crq_work, handle_crq);
+	INIT_WORK(&vdev->crq_work, handle_crq);
 
-	dev_set_drvdata(&dev->dev, tpg);
+	dev_set_drvdata(&dev->dev, vdev);
 
-	ret = srp_target_alloc(&tpg->srpt, &dev->dev, INITIAL_SRP_LIMIT,
+	ret = srp_target_alloc(&vdev->srpt, &dev->dev, INITIAL_SRP_LIMIT,
 			       SRP_MAX_IU_LEN);
 
-	tpg->srpt.ldata = tpg;
+	vdev->srpt.ldata = vdev;
 
-	ret = crq_queue_create(&tpg->crq_queue, tpg);
+	ret = crq_queue_create(&vdev->crq_queue, vdev);
 
-	printk("%s %d: %d\n", __func__, __LINE__, ret);
+	printk(KERN_INFO "%s %d: Detected VIO TGT vio_dev->unit_address: 0x%08x,"
+		" dev_name: %s vio_tpgt: %u \n", __func__, __LINE__,
+		dev->unit_address, dev_name(&dev->dev), vdev->vio_tpgt);
 
 	return 0;
 }
 
+/*
+ * Called by arch/powerpc/kernel/vio.c:vio_bus_remove() to shutdown a previously
+ * registered struct vio_dev and struct ibmvscsis_vdev *.
+ */
 static int ibmvscsis_remove(struct vio_dev *dev)
 {
-	struct ibmvscsis_tpg *tpg = dev_get_drvdata(&dev->dev);
+	struct ibmvscsis_vdev *vdev = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 
-	spin_lock_irqsave(&tpg_lock, flags);
-	list_del(&tpg->siblings);
-	spin_unlock_irqrestore(&tpg_lock, flags);
-	srp_target_free(&tpg->srpt);
+	spin_lock_irqsave(&tcm_vdev_lock, flags);
+	list_del(&vdev->siblings);
+	spin_unlock_irqrestore(&tcm_vdev_lock, flags);
 
-	crq_queue_destroy(tpg);
+	printk(KERN_INFO "%s %d: Releasing VIO TGT vio_dev->unit_address: 0x%08x,"
+		" ev_name: %s vio_tpgt: %u\n", __func__, __LINE__, dev->unit_address,
+		dev_name(&dev->dev), vdev->vio_tpgt);
+	
+	srp_target_free(&vdev->srpt);
+	crq_queue_destroy(vdev);
 
-	kfree(tpg);
+	kfree(vdev);
 	return 0;
 }
 
@@ -1711,7 +1902,7 @@ static int ibmvscsis_register_configfs(void)
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
 	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ibmvscsis_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = ibmvscsis_tpg_attrs;
 	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
 	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
 	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-- 
1.5.6

