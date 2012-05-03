From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/3] tcm_qla2xxx: Convert FC address map from flat array to btree
Date: Thu,  3 May 2012 12:42:58 -0700
Message-ID: <1336074180-20577-2-git-send-email-roland@kernel.org>
References: <1336074180-20577-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336074180-20577-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Steve Hodgson <steve@purestorage.com>

tcm_qla2xxx needs a map from 24-bit FC addresses to node ACL pointers to
look up incoming commands.  Current code keeps this as a flat vmalloc()ed
array with 2^24 entries -- with 8-byte pointers, this consumes 128MB per
FC port!  Occupancy of this array is at most on the order of hundreds of
entries (and even that would be a lot of initiators on an FC fabric), so
this wastes a huge amount of memory.

Change this map to use the kernel's btree library; this reduces the memory
used to be O(number of entries) and has no measurable speed impact (in fact
since the data structure is now packed rather than sparse, the cache/TLB
effects may actually make this a net win).

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/Kconfig       |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  195 ++++++++++++++++--------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   22 +---
 3 files changed, 90 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 940988d..0a98cea 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -30,6 +30,7 @@ config TCM_QLA2XXX
 	tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs"
 	depends on SCSI_QLA_FC && TARGET_CORE 
 	select LIBFC
+	select BTREE
 	default n
 	---help---
 	Say Y here to enable the TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7fb4e81..7c3cbc1 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -764,11 +764,10 @@ static int tcm_qla2xxx_setup_nacl_from_rport(
 	struct Scsi_Host *sh = vha->host;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(sh);
 	struct fc_rport *rport;
-	struct tcm_qla2xxx_fc_domain *d;
-	struct tcm_qla2xxx_fc_area *a;
-	struct tcm_qla2xxx_fc_al_pa *p;
 	unsigned long flags;
-	unsigned char domain, area, al_pa;
+	void *node;
+	int rc;
+
 	/*
 	 * Scan the existing rports, and create a session for the
 	 * explict NodeACL is an matching rport->node_name already
@@ -782,29 +781,31 @@ static int tcm_qla2xxx_setup_nacl_from_rport(
 		pr_debug("Located existing rport_wwpn and rport->node_name:"
 			" 0x%016LX, port_id: 0x%04x\n", rport->node_name,
 			rport->port_id);
-		domain = (rport->port_id >> 16) & 0xff;
-		area = (rport->port_id >> 8) & 0xff;
-		al_pa = rport->port_id & 0xff;
 		nacl->nport_id = rport->port_id;
 
-		pr_debug("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
-				domain, area, al_pa);
 		spin_unlock_irqrestore(sh->host_lock, flags);
 
-
 		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
-		d = &((struct tcm_qla2xxx_fc_domain *)lport->lport_fcport_map)[domain];
-		pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
-		a = &d->areas[area];
-		pr_debug("Using a: %p for area: 0x%02x\n", a, area);
-		p = &a->al_pas[al_pa];
-		pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
-
-		p->se_nacl = se_nacl;
-		pr_debug("Setting p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
+		node = btree_lookup32(&lport->lport_fcport_map, rport->port_id);
+		if (node) {
+			rc = btree_update32(&lport->lport_fcport_map,
+					    rport->port_id, se_nacl);
+		} else {
+			rc = btree_insert32(&lport->lport_fcport_map,
+					    rport->port_id, se_nacl,
+					    GFP_ATOMIC);
+		}
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+
+		if (rc) {
+			pr_err("Unable to insert se_nacl into fcport_map");
+			WARN_ON(rc > 0);
+			return rc;
+		}
+
+		pr_debug("Inserted into fcport_map: %p for WWNN: 0x%016LX,"
 			" port_id: 0x%08x\n", se_nacl, rport_wwnn,
 			nacl->nport_id);
-		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
 		return 1;
 	}
@@ -825,29 +826,16 @@ void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 				struct tcm_qla2xxx_lport, lport_wwn);
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 				struct tcm_qla2xxx_nacl, se_node_acl);
-	struct tcm_qla2xxx_fc_domain *d;
-	struct tcm_qla2xxx_fc_area *a;
-	struct tcm_qla2xxx_fc_al_pa *p;
-	unsigned char domain, area, al_pa;
-
-	domain = (nacl->nport_id >> 16) & 0xff;
-	area = (nacl->nport_id >> 8) & 0xff;
-	al_pa = nacl->nport_id & 0xff;
+	void *node;
 
-	pr_debug("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
-			domain, area, al_pa);
+	pr_debug("fc_rport domain: port_id 0x%06x\n", nacl->nport_id);
 
-	d = &((struct tcm_qla2xxx_fc_domain *)lport->lport_fcport_map)[domain];
-	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
-	a = &d->areas[area];
-	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
-	p = &a->al_pas[al_pa];
-	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+	node = btree_remove32(&lport->lport_fcport_map, nacl->nport_id);
+	WARN_ON(node && (node != se_nacl));
 
-	p->se_nacl = NULL;
-	pr_debug("Clearing p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
-		" port_id: 0x%08x\n", se_nacl, nacl->nport_wwnn,
-		nacl->nport_id);
+	pr_debug("Removed from fcport_map: %p for WWNN: 0x%016LX,"
+			       " port_id: 0x%06x\n", se_nacl, nacl->nport_wwnn,
+			       nacl->nport_id);
 }
 
 void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
@@ -1183,10 +1171,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 	struct tcm_qla2xxx_lport *lport;
 	struct se_node_acl *se_nacl;
 	struct tcm_qla2xxx_nacl *nacl;
-	struct tcm_qla2xxx_fc_domain *d;
-	struct tcm_qla2xxx_fc_area *a;
-	struct tcm_qla2xxx_fc_al_pa *p;
-	unsigned char domain, area, al_pa;
+	u32 key;
 
 	lport = ha->tgt.target_lport_ptr;
 	if (!lport) {
@@ -1195,24 +1180,14 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 		return NULL;
 	}
 
-	domain = s_id[0];
-	area = s_id[1];
-	al_pa = s_id[2];
+	key = (((unsigned long)s_id[0] << 16) |
+	       ((unsigned long)s_id[1] << 8) |
+	       (unsigned long)s_id[2]);
+	pr_debug("find_sess_by_s_id: 0x%06x\n", key);
 
-	pr_debug("find_sess_by_s_id: 0x%02x area: 0x%02x al_pa: %02x\n",
-			domain, area, al_pa);
-
-	d = &((struct tcm_qla2xxx_fc_domain *)lport->lport_fcport_map)[domain];
-	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
-	a = &d->areas[area];
-	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
-	p = &a->al_pas[al_pa];
-	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
-
-	se_nacl = p->se_nacl;
+	se_nacl = btree_lookup32(&lport->lport_fcport_map, key);
 	if (!se_nacl) {
-		pr_debug("Unable to locate s_id: 0x%02x area: 0x%02x"
-			" al_pa: %02x\n", domain, area, al_pa);
+		pr_debug("Unable to locate s_id: 0x%06x\n", key);
 		return NULL;
 	}
 	pr_debug("find_sess_by_s_id: located se_nacl: %p,"
@@ -1238,29 +1213,29 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	struct qla_tgt_sess *qla_tgt_sess,
 	uint8_t *s_id)
 {
-	struct se_node_acl *saved_nacl;
-	struct tcm_qla2xxx_fc_domain *d;
-	struct tcm_qla2xxx_fc_area *a;
-	struct tcm_qla2xxx_fc_al_pa *p;
-	unsigned char domain, area, al_pa;
-
-	domain = s_id[0];
-	area = s_id[1];
-	al_pa = s_id[2];
-	pr_debug("set_sess_by_s_id: domain 0x%02x area: 0x%02x al_pa: %02x\n",
-			domain, area, al_pa);
-
-	d = &((struct tcm_qla2xxx_fc_domain *)lport->lport_fcport_map)[domain];
-	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
-	a = &d->areas[area];
-	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
-	p = &a->al_pas[al_pa];
-	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
-
-	saved_nacl = p->se_nacl;
-	if (!saved_nacl) {
-		pr_debug("Setting up new p->se_nacl to new_se_nacl\n");
-		p->se_nacl = new_se_nacl;
+	u32 key;
+	void *slot;
+	int rc;
+
+	key = (((unsigned long)s_id[0] << 16) |
+	       ((unsigned long)s_id[1] << 8) |
+	       (unsigned long)s_id[2]);
+	pr_debug("set_sess_by_s_id: %06x\n", key);
+
+	slot = btree_lookup32(&lport->lport_fcport_map, key);
+	if (!slot) {
+		if (new_se_nacl) {
+			pr_debug("Setting up new fc_port entry to new_se_nacl\n");
+			nacl->nport_id = key;
+			rc = btree_insert32(&lport->lport_fcport_map, key, new_se_nacl,
+					    GFP_ATOMIC);
+			if (rc)
+				printk(KERN_ERR "Unable to insert s_id into fcport_map: %06x\n",
+				       (int)key);
+		} else {
+			pr_debug("Wiping nonexisting fc_port entry\n");
+		}
+
 		qla_tgt_sess->se_sess = se_sess;
 		nacl->qla_tgt_sess = qla_tgt_sess;
 		return;
@@ -1269,28 +1244,28 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	if (nacl->qla_tgt_sess) {
 		if (new_se_nacl == NULL) {
 			pr_debug("Clearing existing nacl->qla_tgt_sess"
-					" and p->se_nacl\n");
-			p->se_nacl = NULL;
+					" and fc_port entry\n");
+			btree_remove32(&lport->lport_fcport_map, key);
 			nacl->qla_tgt_sess = NULL;
 			return;
 		}
 		pr_debug("Replacing existing nacl->qla_tgt_sess and"
-				" p->se_nacl\n");
-		p->se_nacl = new_se_nacl;
+				       " fc_port entry\n");
+		btree_update32(&lport->lport_fcport_map, key, new_se_nacl);
 		qla_tgt_sess->se_sess = se_sess;
 		nacl->qla_tgt_sess = qla_tgt_sess;
 		return;
 	}
 
 	if (new_se_nacl == NULL) {
-		pr_debug("Clearing existing p->se_nacl\n");
-		p->se_nacl = NULL;
+		pr_debug("Clearing existing fc_port entry\n");
+		btree_remove32(&lport->lport_fcport_map, key);
 		return;
 	}
 
-	pr_debug("Replacing existing p->se_nacl w/o active"
+	pr_debug("Replacing existing fc_port entry w/o active"
 				" nacl->qla_tgt_sess\n");
-	p->se_nacl = new_se_nacl;
+	btree_update32(&lport->lport_fcport_map, key, new_se_nacl);
 	qla_tgt_sess->se_sess = se_sess;
 	nacl->qla_tgt_sess = qla_tgt_sess;
 
@@ -1321,8 +1296,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 
 	pr_debug("find_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
 
-	fc_loopid = &((struct tcm_qla2xxx_fc_loopid *)lport->lport_loopid_map)[loop_id];
-
+	fc_loopid = lport->lport_loopid_map + loop_id;
 	se_nacl = fc_loopid->se_nacl;
 	if (!se_nacl) {
 		pr_debug("Unable to locate se_nacl by loop_id:"
@@ -1556,31 +1530,27 @@ static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
 {
-	lport->lport_fcport_map = vmalloc(
-			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-	if (!lport->lport_fcport_map) {
-		pr_err("Unable to allocate lport_fcport_map of %lu"
-			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-		return -ENOMEM;
+	int rc;
+
+	rc = btree_init32(&lport->lport_fcport_map);
+	if (rc) {
+		pr_err("Unable to initialize lport->lport_fcport_map btree\n");
+		return rc;
 	}
-	memset(lport->lport_fcport_map, 0,
-			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-	pr_debug("qla2xxx: Allocated lport_fcport_map of %lu bytes\n",
-			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 
 	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
 				65536);
 	if (!lport->lport_loopid_map) {
 		pr_err("Unable to allocate lport->lport_loopid_map"
-			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
-			* 65536);
-		vfree(lport->lport_fcport_map);
+		       " of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
+		       * 65536);
+		btree_destroy32(&lport->lport_fcport_map);
 		return -ENOMEM;
 	}
 	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
-			* 65536);
+	       * 65536);
 	pr_debug("qla2xxx: Allocated lport_loopid_map of %lu bytes\n",
-			sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
+	       sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 	return 0;
 }
 
@@ -1630,7 +1600,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 	return &lport->lport_wwn;
 out_lport:
 	vfree(lport->lport_loopid_map);
-	vfree(lport->lport_fcport_map);
+	btree_destroy32(&lport->lport_fcport_map);
 out:
 	kfree(lport);
 	return ERR_PTR(ret);
@@ -1642,6 +1612,9 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 			struct tcm_qla2xxx_lport, lport_wwn);
 	struct scsi_qla_host *vha = lport->qla_vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct se_node_acl *node;
+	u32 key;
+
 	/*
 	 * Call into qla2x_target.c LLD logic to complete the
 	 * shutdown of struct qla_tgt after the call to
@@ -1653,7 +1626,9 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 	qlt_lport_deregister(vha);
 
 	vfree(lport->lport_loopid_map);
-	vfree(lport->lport_fcport_map);
+	btree_for_each_safe32(&lport->lport_fcport_map, key, node)
+		btree_remove32(&lport->lport_fcport_map, key);
+	btree_destroy32(&lport->lport_fcport_map);
 	kfree(lport);
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 41730ed..7a94f03 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -1,4 +1,5 @@
 #include <target/target_core_base.h>
+#include <linux/btree.h>
 
 #define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
@@ -45,21 +46,6 @@ struct tcm_qla2xxx_tpg {
 
 #define QLA_TPG_ATTRIB(tpg)	(&(tpg)->tpg_attrib)
 
-/*
- * Used for the 24-bit lport->lport_fcport_map;
- */
-struct tcm_qla2xxx_fc_al_pa {
-	struct se_node_acl *se_nacl;
-};
-
-struct tcm_qla2xxx_fc_area {
-        struct tcm_qla2xxx_fc_al_pa al_pas[256];
-};
-
-struct tcm_qla2xxx_fc_domain {
-        struct tcm_qla2xxx_fc_area areas[256];
-};
-
 struct tcm_qla2xxx_fc_loopid {
 	struct se_node_acl *se_nacl;
 };
@@ -77,10 +63,10 @@ struct tcm_qla2xxx_lport {
 	char lport_name[TCM_QLA2XXX_NAMELEN];
 	/* ASCII formatted WWPN+WWNN for NPIV FC Target Lport */
 	char lport_npiv_name[TCM_QLA2XXX_NPIV_NAMELEN];
-	/* vmalloc'ed memory for fc_port pointers in 24-bit FC Port ID space */
-	char *lport_fcport_map;
+	/* map for fc_port pointers in 24-bit FC Port ID space */
+	struct btree_head32 lport_fcport_map;
 	/* vmalloc-ed memory for fc_port pointers for 16-bit FC loop ID */
-	char *lport_loopid_map;
+	struct tcm_qla2xxx_fc_loopid *lport_loopid_map;
 	/* Pointer to struct scsi_qla_host from qla2xxx LLD */
 	struct scsi_qla_host *qla_vha;
 	/* Pointer to struct scsi_qla_host for NPIV VP from qla2xxx LLD */
-- 
1.7.9.5
