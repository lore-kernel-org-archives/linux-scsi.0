From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 30/37] target: Cleanup unused target_core_base.h bits
Date: Fri, 14 Oct 2011 00:42:02 +0000
Message-ID: <1318552929-13341-31-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

This is a squashed version of the following target_core_base.h
cleanup patches:

    target: remove the unused SHUTDOWN_SIGS defintion
    target: remove unused se_mem leftovers
    target: remove the unused map_func_t typedef
    target: move TRANSPORT_IOV_DATA_BUFFER to the iscsi-specific code

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      |    2 +-
 drivers/target/iscsi/iscsi_target_core.h |    3 +++
 drivers/target/target_core_transport.c   |    3 ---
 include/target/target_core_base.h        |    3 ---
 include/target/target_core_transport.h   |    7 -------
 5 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d86e18d..4d01768 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -765,7 +765,7 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 	u32 iov_count = (cmd->se_cmd.t_data_nents == 0) ? 1 :
 				cmd->se_cmd.t_data_nents;
 
-	iov_count += TRANSPORT_IOV_DATA_BUFFER;
+	iov_count += ISCSI_IOV_DATA_BUFFER;
 
 	cmd->iov_data = kzalloc(iov_count * sizeof(struct kvec), GFP_KERNEL);
 	if (!cmd->iov_data) {
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 470ed55..84818d7 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -57,6 +57,9 @@
 #define TA_PROD_MODE_WRITE_PROTECT	0
 #define TA_CACHE_CORE_NPS		0
 
+
+#define ISCSI_IOV_DATA_BUFFER		5
+
 enum tpg_np_network_transport_table {
 	ISCSI_TCP				= 0,
 	ISCSI_SCTP_TCP				= 1,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ee73f10..89b85dd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -69,9 +69,6 @@ struct kmem_cache *t10_alua_lu_gp_mem_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
-/* Used for transport_dev_get_map_*() */
-typedef int (*map_func_t)(struct se_task *, u32);
-
 static int transport_generic_write_pending(struct se_cmd *);
 static int transport_processing_thread(void *param);
 static int __transport_execute_tasks(struct se_device *dev);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 872cafc..c00224e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -10,10 +10,7 @@
 #include <net/tcp.h>
 
 #define TARGET_CORE_MOD_VERSION		"v4.1.0-rc1-ml"
-#define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 
-/* Used by transport_generic_allocate_iovecs() */
-#define TRANSPORT_IOV_DATA_BUFFER		5
 /* Maximum Number of LUNs per Target Portal Group */
 /* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
 #define TRANSPORT_MAX_LUNS_PER_TPG		256
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index c915169..ccd85b3 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -110,11 +110,8 @@
 
 #define MOD_MAX_SECTORS(ms, bs)			(ms % (PAGE_SIZE / bs))
 
-struct se_mem;
 struct se_subsystem_api;
 
-extern struct kmem_cache *se_mem_cache;
-
 extern int init_se_kmem_caches(void);
 extern void release_se_kmem_caches(void);
 extern u32 scsi_get_new_index(scsi_index_t);
@@ -186,10 +183,6 @@ extern void transport_send_task_abort(struct se_cmd *);
 extern void transport_release_cmd(struct se_cmd *);
 extern void transport_generic_free_cmd(struct se_cmd *, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
-extern int transport_init_task_sg(struct se_task *, struct se_mem *, u32);
-extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
-					struct scatterlist *, struct se_mem *,
-					struct se_mem **, u32 *, u32 *);
 extern void transport_do_task_sg_chain(struct se_cmd *);
 extern void transport_generic_process_write(struct se_cmd *);
 extern int transport_generic_new_cmd(struct se_cmd *);
-- 
1.5.6.5
