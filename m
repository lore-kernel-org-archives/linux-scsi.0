From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 4/4] target/qla2xxx: Remove QLA_TPG_ATTRIB macro
Date: Wed,  9 Oct 2013 11:05:59 -0700
Message-ID: <1381341959-22254-5-git-send-email-agrover@redhat.com>
References: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Just a dereference, don't need a macro.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 --
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 92b1654..7eb19be 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -330,7 +330,7 @@ static int tcm_qla2xxx_check_demo_mode(struct se_portal_group *se_tpg)
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
 
-	return QLA_TPG_ATTRIB(tpg)->generate_node_acls;
+	return tpg->tpg_attrib.generate_node_acls;
 }
 
 static int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
@@ -338,7 +338,7 @@ static int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
 
-	return QLA_TPG_ATTRIB(tpg)->cache_dynamic_acls;
+	return tpg->tpg_attrib.cache_dynamic_acls;
 }
 
 static int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tpg)
@@ -346,7 +346,7 @@ static int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tpg)
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
 
-	return QLA_TPG_ATTRIB(tpg)->demo_mode_write_protect;
+	return tpg->tpg_attrib.demo_mode_write_protect;
 }
 
 static int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tpg)
@@ -354,7 +354,7 @@ static int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tpg)
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
 
-	return QLA_TPG_ATTRIB(tpg)->prod_mode_write_protect;
+	return tpg->tpg_attrib.prod_mode_write_protect;
 }
 
 static int tcm_qla2xxx_check_demo_mode_login_only(struct se_portal_group *se_tpg)
@@ -362,7 +362,7 @@ static int tcm_qla2xxx_check_demo_mode_login_only(struct se_portal_group *se_tpg
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
 
-	return QLA_TPG_ATTRIB(tpg)->demo_mode_login_only;
+	return tpg->tpg_attrib.demo_mode_login_only;
 }
 
 static struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(
@@ -847,7 +847,7 @@ static ssize_t tcm_qla2xxx_tpg_attrib_show_##name(			\
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,		\
 			struct tcm_qla2xxx_tpg, se_tpg);		\
 									\
-	return sprintf(page, "%u\n", QLA_TPG_ATTRIB(tpg)->name);	\
+	return sprintf(page, "%u\n", tpg->tpg_attrib.name);	\
 }									\
 									\
 static ssize_t tcm_qla2xxx_tpg_attrib_store_##name(			\
@@ -1027,10 +1027,10 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	 * By default allow READ-ONLY TPG demo-mode access w/ cached dynamic
 	 * NodeACLs
 	 */
-	QLA_TPG_ATTRIB(tpg)->generate_node_acls = 1;
-	QLA_TPG_ATTRIB(tpg)->demo_mode_write_protect = 1;
-	QLA_TPG_ATTRIB(tpg)->cache_dynamic_acls = 1;
-	QLA_TPG_ATTRIB(tpg)->demo_mode_login_only = 1;
+	tpg->tpg_attrib.generate_node_acls = 1;
+	tpg->tpg_attrib.demo_mode_write_protect = 1;
+	tpg->tpg_attrib.cache_dynamic_acls = 1;
+	tpg->tpg_attrib.demo_mode_login_only = 1;
 
 	ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 3293275..771f7b8 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -45,8 +45,6 @@ struct tcm_qla2xxx_tpg {
 	struct se_portal_group se_tpg;
 };
 
-#define QLA_TPG_ATTRIB(tpg)	(&(tpg)->tpg_attrib)
-
 struct tcm_qla2xxx_fc_loopid {
 	struct se_node_acl *se_nacl;
 };
-- 
1.7.1
