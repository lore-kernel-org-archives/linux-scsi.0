From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 8/8] vhost/scsi: Global tcm_vhost -> vhost_scsi rename
Date: Fri,  6 Feb 2015 05:06:41 +0000
Message-ID: <1423199201-14659-9-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

There is a large amount of code that still references the original
'tcm_vhost' naming conventions, instead of modern 'vhost_scsi'.

Go ahead and do a global rename to make the usage consistent.

Cc: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 662 +++++++++++++++++++++++++--------------------------
 1 file changed, 331 insertions(+), 331 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1a66fcf..daf10b7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -51,13 +51,13 @@
 
 #include "vhost.h"
 
-#define TCM_VHOST_VERSION  "v0.1"
-#define TCM_VHOST_NAMELEN 256
-#define TCM_VHOST_MAX_CDB_SIZE 32
-#define TCM_VHOST_DEFAULT_TAGS 256
-#define TCM_VHOST_PREALLOC_SGLS 2048
-#define TCM_VHOST_PREALLOC_UPAGES 2048
-#define TCM_VHOST_PREALLOC_PROT_SGLS 512
+#define VHOST_SCSI_VERSION  "v0.1"
+#define VHOST_SCSI_NAMELEN 256
+#define VHOST_SCSI_MAX_CDB_SIZE 32
+#define VHOST_SCSI_DEFAULT_TAGS 256
+#define VHOST_SCSI_PREALLOC_SGLS 2048
+#define VHOST_SCSI_PREALLOC_UPAGES 2048
+#define VHOST_SCSI_PREALLOC_PROT_SGLS 512
 
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
@@ -66,7 +66,7 @@ struct vhost_scsi_inflight {
 	struct kref kref;
 };
 
-struct tcm_vhost_cmd {
+struct vhost_scsi_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
 	int tvc_vq_desc;
 	/* virtio-scsi initiator task attribute */
@@ -82,7 +82,7 @@ struct tcm_vhost_cmd {
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
-	/* Saved unpacked SCSI LUN for tcm_vhost_submission_work() */
+	/* Saved unpacked SCSI LUN for vhost_scsi_submission_work() */
 	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
@@ -95,13 +95,13 @@ struct tcm_vhost_cmd {
 	/* Pointer to vhost_virtqueue for the cmd */
 	struct vhost_virtqueue *tvc_vq;
 	/* Pointer to vhost nexus memory */
-	struct tcm_vhost_nexus *tvc_nexus;
+	struct vhost_scsi_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
-	/* work item used for cmwq dispatch to tcm_vhost_submission_work() */
+	/* work item used for cmwq dispatch to vhost_scsi_submission_work() */
 	struct work_struct work;
 	/* Copy of the incoming SCSI command descriptor block (CDB) */
-	unsigned char tvc_cdb[TCM_VHOST_MAX_CDB_SIZE];
+	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
 	/* Completed commands list, serviced from vhost worker thread */
@@ -110,53 +110,53 @@ struct tcm_vhost_cmd {
 	struct vhost_scsi_inflight *inflight;
 };
 
-struct tcm_vhost_nexus {
+struct vhost_scsi_nexus {
 	/* Pointer to TCM session for I_T Nexus */
 	struct se_session *tvn_se_sess;
 };
 
-struct tcm_vhost_nacl {
+struct vhost_scsi_nacl {
 	/* Binary World Wide unique Port Name for Vhost Initiator port */
 	u64 iport_wwpn;
 	/* ASCII formatted WWPN for Sas Initiator port */
-	char iport_name[TCM_VHOST_NAMELEN];
-	/* Returned by tcm_vhost_make_nodeacl() */
+	char iport_name[VHOST_SCSI_NAMELEN];
+	/* Returned by vhost_scsi_make_nodeacl() */
 	struct se_node_acl se_node_acl;
 };
 
-struct tcm_vhost_tpg {
+struct vhost_scsi_tpg {
 	/* Vhost port target portal group tag for TCM */
 	u16 tport_tpgt;
 	/* Used to track number of TPG Port/Lun Links wrt to explict I_T Nexus shutdown */
 	int tv_tpg_port_count;
 	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
 	int tv_tpg_vhost_count;
-	/* list for tcm_vhost_list */
+	/* list for vhost_scsi_list */
 	struct list_head tv_tpg_list;
 	/* Used to protect access for tpg_nexus */
 	struct mutex tv_tpg_mutex;
 	/* Pointer to the TCM VHost I_T Nexus for this TPG endpoint */
-	struct tcm_vhost_nexus *tpg_nexus;
-	/* Pointer back to tcm_vhost_tport */
-	struct tcm_vhost_tport *tport;
-	/* Returned by tcm_vhost_make_tpg() */
+	struct vhost_scsi_nexus *tpg_nexus;
+	/* Pointer back to vhost_scsi_tport */
+	struct vhost_scsi_tport *tport;
+	/* Returned by vhost_scsi_make_tpg() */
 	struct se_portal_group se_tpg;
 	/* Pointer back to vhost_scsi, protected by tv_tpg_mutex */
 	struct vhost_scsi *vhost_scsi;
 };
 
-struct tcm_vhost_tport {
+struct vhost_scsi_tport {
 	/* SCSI protocol the tport is providing */
 	u8 tport_proto_id;
 	/* Binary World Wide unique Port Name for Vhost Target port */
 	u64 tport_wwpn;
 	/* ASCII formatted WWPN for Vhost Target port */
-	char tport_name[TCM_VHOST_NAMELEN];
-	/* Returned by tcm_vhost_make_tport() */
+	char tport_name[VHOST_SCSI_NAMELEN];
+	/* Returned by vhost_scsi_make_tport() */
 	struct se_wwn tport_wwn;
 };
 
-struct tcm_vhost_evt {
+struct vhost_scsi_evt {
 	/* event to be sent to guest */
 	struct virtio_scsi_event event;
 	/* event list, serviced from vhost worker thread */
@@ -198,7 +198,7 @@ struct vhost_scsi_virtqueue {
 
 struct vhost_scsi {
 	/* Protected by vhost_scsi->dev.mutex */
-	struct tcm_vhost_tpg **vs_tpg;
+	struct vhost_scsi_tpg **vs_tpg;
 	char vs_vhost_wwpn[TRANSPORT_IQN_LEN];
 
 	struct vhost_dev dev;
@@ -215,13 +215,13 @@ struct vhost_scsi {
 };
 
 /* Local pointer to allocated TCM configfs fabric module */
-static struct target_fabric_configfs *tcm_vhost_fabric_configfs;
+static struct target_fabric_configfs *vhost_scsi_fabric_configfs;
 
-static struct workqueue_struct *tcm_vhost_workqueue;
+static struct workqueue_struct *vhost_scsi_workqueue;
 
-/* Global spinlock to protect tcm_vhost TPG list for vhost IOCTL access */
-static DEFINE_MUTEX(tcm_vhost_mutex);
-static LIST_HEAD(tcm_vhost_list);
+/* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
+static DEFINE_MUTEX(vhost_scsi_mutex);
+static LIST_HEAD(vhost_scsi_list);
 
 static int iov_num_pages(void __user *iov_base, size_t iov_len)
 {
@@ -229,7 +229,7 @@ static int iov_num_pages(void __user *iov_base, size_t iov_len)
 	       ((unsigned long)iov_base & PAGE_MASK)) >> PAGE_SHIFT;
 }
 
-static void tcm_vhost_done_inflight(struct kref *kref)
+static void vhost_scsi_done_inflight(struct kref *kref)
 {
 	struct vhost_scsi_inflight *inflight;
 
@@ -237,7 +237,7 @@ static void tcm_vhost_done_inflight(struct kref *kref)
 	complete(&inflight->comp);
 }
 
-static void tcm_vhost_init_inflight(struct vhost_scsi *vs,
+static void vhost_scsi_init_inflight(struct vhost_scsi *vs,
 				    struct vhost_scsi_inflight *old_inflight[])
 {
 	struct vhost_scsi_inflight *new_inflight;
@@ -265,7 +265,7 @@ static void tcm_vhost_init_inflight(struct vhost_scsi *vs,
 }
 
 static struct vhost_scsi_inflight *
-tcm_vhost_get_inflight(struct vhost_virtqueue *vq)
+vhost_scsi_get_inflight(struct vhost_virtqueue *vq)
 {
 	struct vhost_scsi_inflight *inflight;
 	struct vhost_scsi_virtqueue *svq;
@@ -277,31 +277,31 @@ tcm_vhost_get_inflight(struct vhost_virtqueue *vq)
 	return inflight;
 }
 
-static void tcm_vhost_put_inflight(struct vhost_scsi_inflight *inflight)
+static void vhost_scsi_put_inflight(struct vhost_scsi_inflight *inflight)
 {
-	kref_put(&inflight->kref, tcm_vhost_done_inflight);
+	kref_put(&inflight->kref, vhost_scsi_done_inflight);
 }
 
-static int tcm_vhost_check_true(struct se_portal_group *se_tpg)
+static int vhost_scsi_check_true(struct se_portal_group *se_tpg)
 {
 	return 1;
 }
 
-static int tcm_vhost_check_false(struct se_portal_group *se_tpg)
+static int vhost_scsi_check_false(struct se_portal_group *se_tpg)
 {
 	return 0;
 }
 
-static char *tcm_vhost_get_fabric_name(void)
+static char *vhost_scsi_get_fabric_name(void)
 {
 	return "vhost";
 }
 
-static u8 tcm_vhost_get_fabric_proto_ident(struct se_portal_group *se_tpg)
+static u8 vhost_scsi_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport = tpg->tport;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport = tpg->tport;
 
 	switch (tport->tport_proto_id) {
 	case SCSI_PROTOCOL_SAS:
@@ -319,37 +319,37 @@ static u8 tcm_vhost_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 	return sas_get_fabric_proto_ident(se_tpg);
 }
 
-static char *tcm_vhost_get_fabric_wwn(struct se_portal_group *se_tpg)
+static char *vhost_scsi_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport = tpg->tport;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport = tpg->tport;
 
 	return &tport->tport_name[0];
 }
 
-static u16 tcm_vhost_get_tag(struct se_portal_group *se_tpg)
+static u16 vhost_scsi_get_tpgt(struct se_portal_group *se_tpg)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
 	return tpg->tport_tpgt;
 }
 
-static u32 tcm_vhost_get_default_depth(struct se_portal_group *se_tpg)
+static u32 vhost_scsi_get_default_depth(struct se_portal_group *se_tpg)
 {
 	return 1;
 }
 
 static u32
-tcm_vhost_get_pr_transport_id(struct se_portal_group *se_tpg,
+vhost_scsi_get_pr_transport_id(struct se_portal_group *se_tpg,
 			      struct se_node_acl *se_nacl,
 			      struct t10_pr_registration *pr_reg,
 			      int *format_code,
 			      unsigned char *buf)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport = tpg->tport;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport = tpg->tport;
 
 	switch (tport->tport_proto_id) {
 	case SCSI_PROTOCOL_SAS:
@@ -372,14 +372,14 @@ tcm_vhost_get_pr_transport_id(struct se_portal_group *se_tpg,
 }
 
 static u32
-tcm_vhost_get_pr_transport_id_len(struct se_portal_group *se_tpg,
+vhost_scsi_get_pr_transport_id_len(struct se_portal_group *se_tpg,
 				  struct se_node_acl *se_nacl,
 				  struct t10_pr_registration *pr_reg,
 				  int *format_code)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport = tpg->tport;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport = tpg->tport;
 
 	switch (tport->tport_proto_id) {
 	case SCSI_PROTOCOL_SAS:
@@ -402,14 +402,14 @@ tcm_vhost_get_pr_transport_id_len(struct se_portal_group *se_tpg,
 }
 
 static char *
-tcm_vhost_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
+vhost_scsi_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 				    const char *buf,
 				    u32 *out_tid_len,
 				    char **port_nexus_ptr)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport = tpg->tport;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport = tpg->tport;
 
 	switch (tport->tport_proto_id) {
 	case SCSI_PROTOCOL_SAS:
@@ -432,13 +432,13 @@ tcm_vhost_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
 }
 
 static struct se_node_acl *
-tcm_vhost_alloc_fabric_acl(struct se_portal_group *se_tpg)
+vhost_scsi_alloc_fabric_acl(struct se_portal_group *se_tpg)
 {
-	struct tcm_vhost_nacl *nacl;
+	struct vhost_scsi_nacl *nacl;
 
-	nacl = kzalloc(sizeof(struct tcm_vhost_nacl), GFP_KERNEL);
+	nacl = kzalloc(sizeof(struct vhost_scsi_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to allocate struct tcm_vhost_nacl\n");
+		pr_err("Unable to allocate struct vhost_scsi_nacl\n");
 		return NULL;
 	}
 
@@ -446,23 +446,23 @@ tcm_vhost_alloc_fabric_acl(struct se_portal_group *se_tpg)
 }
 
 static void
-tcm_vhost_release_fabric_acl(struct se_portal_group *se_tpg,
+vhost_scsi_release_fabric_acl(struct se_portal_group *se_tpg,
 			     struct se_node_acl *se_nacl)
 {
-	struct tcm_vhost_nacl *nacl = container_of(se_nacl,
-			struct tcm_vhost_nacl, se_node_acl);
+	struct vhost_scsi_nacl *nacl = container_of(se_nacl,
+			struct vhost_scsi_nacl, se_node_acl);
 	kfree(nacl);
 }
 
-static u32 tcm_vhost_tpg_get_inst_index(struct se_portal_group *se_tpg)
+static u32 vhost_scsi_tpg_get_inst_index(struct se_portal_group *se_tpg)
 {
 	return 1;
 }
 
-static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
+static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 {
-	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
-				struct tcm_vhost_cmd, tvc_se_cmd);
+	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
+				struct vhost_scsi_cmd, tvc_se_cmd);
 	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
 	int i;
 
@@ -475,53 +475,53 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
 	}
 
-	tcm_vhost_put_inflight(tv_cmd->inflight);
+	vhost_scsi_put_inflight(tv_cmd->inflight);
 	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
-static int tcm_vhost_shutdown_session(struct se_session *se_sess)
+static int vhost_scsi_shutdown_session(struct se_session *se_sess)
 {
 	return 0;
 }
 
-static void tcm_vhost_close_session(struct se_session *se_sess)
+static void vhost_scsi_close_session(struct se_session *se_sess)
 {
 	return;
 }
 
-static u32 tcm_vhost_sess_get_index(struct se_session *se_sess)
+static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
 {
 	return 0;
 }
 
-static int tcm_vhost_write_pending(struct se_cmd *se_cmd)
+static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
 	target_execute_cmd(se_cmd);
 	return 0;
 }
 
-static int tcm_vhost_write_pending_status(struct se_cmd *se_cmd)
+static int vhost_scsi_write_pending_status(struct se_cmd *se_cmd)
 {
 	return 0;
 }
 
-static void tcm_vhost_set_default_node_attrs(struct se_node_acl *nacl)
+static void vhost_scsi_set_default_node_attrs(struct se_node_acl *nacl)
 {
 	return;
 }
 
-static u32 tcm_vhost_get_task_tag(struct se_cmd *se_cmd)
+static u32 vhost_scsi_get_task_tag(struct se_cmd *se_cmd)
 {
 	return 0;
 }
 
-static int tcm_vhost_get_cmd_state(struct se_cmd *se_cmd)
+static int vhost_scsi_get_cmd_state(struct se_cmd *se_cmd)
 {
 	return 0;
 }
 
-static void vhost_scsi_complete_cmd(struct tcm_vhost_cmd *cmd)
+static void vhost_scsi_complete_cmd(struct vhost_scsi_cmd *cmd)
 {
 	struct vhost_scsi *vs = cmd->tvc_vhost;
 
@@ -530,44 +530,44 @@ static void vhost_scsi_complete_cmd(struct tcm_vhost_cmd *cmd)
 	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
 }
 
-static int tcm_vhost_queue_data_in(struct se_cmd *se_cmd)
+static int vhost_scsi_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct tcm_vhost_cmd *cmd = container_of(se_cmd,
-				struct tcm_vhost_cmd, tvc_se_cmd);
+	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
+				struct vhost_scsi_cmd, tvc_se_cmd);
 	vhost_scsi_complete_cmd(cmd);
 	return 0;
 }
 
-static int tcm_vhost_queue_status(struct se_cmd *se_cmd)
+static int vhost_scsi_queue_status(struct se_cmd *se_cmd)
 {
-	struct tcm_vhost_cmd *cmd = container_of(se_cmd,
-				struct tcm_vhost_cmd, tvc_se_cmd);
+	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
+				struct vhost_scsi_cmd, tvc_se_cmd);
 	vhost_scsi_complete_cmd(cmd);
 	return 0;
 }
 
-static void tcm_vhost_queue_tm_rsp(struct se_cmd *se_cmd)
+static void vhost_scsi_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	return;
 }
 
-static void tcm_vhost_aborted_task(struct se_cmd *se_cmd)
+static void vhost_scsi_aborted_task(struct se_cmd *se_cmd)
 {
 	return;
 }
 
-static void tcm_vhost_free_evt(struct vhost_scsi *vs, struct tcm_vhost_evt *evt)
+static void vhost_scsi_free_evt(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 {
 	vs->vs_events_nr--;
 	kfree(evt);
 }
 
-static struct tcm_vhost_evt *
-tcm_vhost_allocate_evt(struct vhost_scsi *vs,
+static struct vhost_scsi_evt *
+vhost_scsi_allocate_evt(struct vhost_scsi *vs,
 		       u32 event, u32 reason)
 {
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
-	struct tcm_vhost_evt *evt;
+	struct vhost_scsi_evt *evt;
 
 	if (vs->vs_events_nr > VHOST_SCSI_MAX_EVENT) {
 		vs->vs_events_missed = true;
@@ -576,7 +576,7 @@ tcm_vhost_allocate_evt(struct vhost_scsi *vs,
 
 	evt = kzalloc(sizeof(*evt), GFP_KERNEL);
 	if (!evt) {
-		vq_err(vq, "Failed to allocate tcm_vhost_evt\n");
+		vq_err(vq, "Failed to allocate vhost_scsi_evt\n");
 		vs->vs_events_missed = true;
 		return NULL;
 	}
@@ -588,7 +588,7 @@ tcm_vhost_allocate_evt(struct vhost_scsi *vs,
 	return evt;
 }
 
-static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *cmd)
+static void vhost_scsi_free_cmd(struct vhost_scsi_cmd *cmd)
 {
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 
@@ -603,7 +603,7 @@ static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
 }
 
 static void
-tcm_vhost_do_evt_work(struct vhost_scsi *vs, struct tcm_vhost_evt *evt)
+vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 {
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
@@ -649,24 +649,24 @@ again:
 	if (!ret)
 		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
 	else
-		vq_err(vq, "Faulted on tcm_vhost_send_event\n");
+		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
 
-static void tcm_vhost_evt_work(struct vhost_work *work)
+static void vhost_scsi_evt_work(struct vhost_work *work)
 {
 	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
 					vs_event_work);
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
-	struct tcm_vhost_evt *evt;
+	struct vhost_scsi_evt *evt;
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
 	llnode = llist_del_all(&vs->vs_event_list);
 	while (llnode) {
-		evt = llist_entry(llnode, struct tcm_vhost_evt, list);
+		evt = llist_entry(llnode, struct vhost_scsi_evt, list);
 		llnode = llist_next(llnode);
-		tcm_vhost_do_evt_work(vs, evt);
-		tcm_vhost_free_evt(vs, evt);
+		vhost_scsi_do_evt_work(vs, evt);
+		vhost_scsi_free_evt(vs, evt);
 	}
 	mutex_unlock(&vq->mutex);
 }
@@ -682,7 +682,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 					vs_completion_work);
 	DECLARE_BITMAP(signal, VHOST_SCSI_MAX_VQ);
 	struct virtio_scsi_cmd_resp v_rsp;
-	struct tcm_vhost_cmd *cmd;
+	struct vhost_scsi_cmd *cmd;
 	struct llist_node *llnode;
 	struct se_cmd *se_cmd;
 	struct iov_iter iov_iter;
@@ -691,7 +691,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	bitmap_zero(signal, VHOST_SCSI_MAX_VQ);
 	llnode = llist_del_all(&vs->vs_completion_list);
 	while (llnode) {
-		cmd = llist_entry(llnode, struct tcm_vhost_cmd,
+		cmd = llist_entry(llnode, struct vhost_scsi_cmd,
 				     tvc_completion_list);
 		llnode = llist_next(llnode);
 		se_cmd = &cmd->tvc_se_cmd;
@@ -729,13 +729,13 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		vhost_signal(&vs->dev, &vs->vqs[vq].vq);
 }
 
-static struct tcm_vhost_cmd *
-vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
+static struct vhost_scsi_cmd *
+vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
 		   u32 exp_data_len, int data_direction)
 {
-	struct tcm_vhost_cmd *cmd;
-	struct tcm_vhost_nexus *tv_nexus;
+	struct vhost_scsi_cmd *cmd;
+	struct vhost_scsi_nexus *tv_nexus;
 	struct se_session *se_sess;
 	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
@@ -743,22 +743,22 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
-		pr_err("Unable to locate active struct tcm_vhost_nexus\n");
+		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
 		return ERR_PTR(-EIO);
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0) {
-		pr_err("Unable to obtain tag for tcm_vhost_cmd\n");
+		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[tag];
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
-	memset(cmd, 0, sizeof(struct tcm_vhost_cmd));
+	memset(cmd, 0, sizeof(struct vhost_scsi_cmd));
 
 	cmd->tvc_sgl = sg;
 	cmd->tvc_prot_sgl = prot_sg;
@@ -770,9 +770,9 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
 	cmd->tvc_exp_data_len = exp_data_len;
 	cmd->tvc_data_direction = data_direction;
 	cmd->tvc_nexus = tv_nexus;
-	cmd->inflight = tcm_vhost_get_inflight(vq);
+	cmd->inflight = vhost_scsi_get_inflight(vq);
 
-	memcpy(cmd->tvc_cdb, cdb, TCM_VHOST_MAX_CDB_SIZE);
+	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
 
 	return cmd;
 }
@@ -783,7 +783,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
  * Returns the number of scatterlist entries used or -errno on error.
  */
 static int
-vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *cmd,
+vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      void __user *ptr,
 		      size_t len,
 		      struct scatterlist *sgl,
@@ -795,10 +795,10 @@ vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *cmd,
 	struct page **pages = cmd->tvc_upages;
 	int ret, i;
 
-	if (pages_nr > TCM_VHOST_PREALLOC_UPAGES) {
+	if (pages_nr > VHOST_SCSI_PREALLOC_UPAGES) {
 		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
-		       " preallocated TCM_VHOST_PREALLOC_UPAGES: %u\n",
-			pages_nr, TCM_VHOST_PREALLOC_UPAGES);
+		       " preallocated VHOST_SCSI_PREALLOC_UPAGES: %u\n",
+			pages_nr, VHOST_SCSI_PREALLOC_UPAGES);
 		return -ENOBUFS;
 	}
 
@@ -849,9 +849,9 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct tcm_vhost_cmd *cmd, bool write,
-		      struct iov_iter *iter, struct scatterlist *sg,
-		      int sg_count)
+vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
+		      struct iov_iter *iter,
+		      struct scatterlist *sg, int sg_count)
 {
 	size_t off = iter->iov_offset;
 	int i, ret;
@@ -876,7 +876,7 @@ vhost_scsi_iov_to_sgl(struct tcm_vhost_cmd *cmd, bool write,
 }
 
 static int
-vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
+vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		 size_t prot_bytes, struct iov_iter *prot_iter,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
@@ -885,7 +885,7 @@ vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
 
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
-						 TCM_VHOST_PREALLOC_PROT_SGLS);
+						 VHOST_SCSI_PREALLOC_PROT_SGLS);
 		if (sgl_count < 0)
 			return sgl_count;
 
@@ -903,7 +903,7 @@ vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
 		}
 	}
 	sgl_count = vhost_scsi_calc_sgls(data_iter, data_bytes,
-					 TCM_VHOST_PREALLOC_SGLS);
+					 VHOST_SCSI_PREALLOC_SGLS);
 	if (sgl_count < 0)
 		return sgl_count;
 
@@ -921,11 +921,11 @@ vhost_scsi_mapal(struct tcm_vhost_cmd *cmd,
 	return 0;
 }
 
-static void tcm_vhost_submission_work(struct work_struct *work)
+static void vhost_scsi_submission_work(struct work_struct *work)
 {
-	struct tcm_vhost_cmd *cmd =
-		container_of(work, struct tcm_vhost_cmd, work);
-	struct tcm_vhost_nexus *tv_nexus;
+	struct vhost_scsi_cmd *cmd =
+		container_of(work, struct vhost_scsi_cmd, work);
+	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
 	int rc;
@@ -978,10 +978,10 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
-	struct tcm_vhost_tpg **vs_tpg, *tpg;
+	struct vhost_scsi_tpg **vs_tpg, *tpg;
 	struct virtio_scsi_cmd_req v_req;
 	struct virtio_scsi_cmd_req_pi v_req_pi;
-	struct tcm_vhost_cmd *cmd;
+	struct vhost_scsi_cmd *cmd;
 	struct iov_iter out_iter, in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
@@ -1168,10 +1168,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 *
 		 * TODO what if cdb was too small for varlen cdb header?
 		 */
-		if (unlikely(scsi_command_size(cdb) > TCM_VHOST_MAX_CDB_SIZE)) {
+		if (unlikely(scsi_command_size(cdb) > VHOST_SCSI_MAX_CDB_SIZE)) {
 			vq_err(vq, "Received SCSI CDB with command_size: %d that"
 				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
-				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
+				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
 			vhost_scsi_send_bad_target(vs, vq, head, out);
 			continue;
 		}
@@ -1200,7 +1200,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 					       exp_data_len, &data_iter);
 			if (unlikely(ret)) {
 				vq_err(vq, "Failed to map iov to sgl\n");
-				tcm_vhost_release_cmd(&cmd->tvc_se_cmd);
+				vhost_scsi_release_cmd(&cmd->tvc_se_cmd);
 				vhost_scsi_send_bad_target(vs, vq, head, out);
 				continue;
 			}
@@ -1217,8 +1217,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * cmd is executed on the same kworker CPU as this vhost
 		 * thread to gain positive L2 cache locality effects.
 		 */
-		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
-		queue_work(tcm_vhost_workqueue, &cmd->work);
+		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
+		queue_work(vhost_scsi_workqueue, &cmd->work);
 	}
 out:
 	mutex_unlock(&vq->mutex);
@@ -1230,15 +1230,15 @@ static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 }
 
 static void
-tcm_vhost_send_evt(struct vhost_scsi *vs,
-		   struct tcm_vhost_tpg *tpg,
+vhost_scsi_send_evt(struct vhost_scsi *vs,
+		   struct vhost_scsi_tpg *tpg,
 		   struct se_lun *lun,
 		   u32 event,
 		   u32 reason)
 {
-	struct tcm_vhost_evt *evt;
+	struct vhost_scsi_evt *evt;
 
-	evt = tcm_vhost_allocate_evt(vs, event, reason);
+	evt = vhost_scsi_allocate_evt(vs, event, reason);
 	if (!evt)
 		return;
 
@@ -1270,7 +1270,7 @@ static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
 		goto out;
 
 	if (vs->vs_events_missed)
-		tcm_vhost_send_evt(vs, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT, 0);
+		vhost_scsi_send_evt(vs, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT, 0);
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -1296,7 +1296,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	int i;
 
 	/* Init new inflight and remember the old inflight */
-	tcm_vhost_init_inflight(vs, old_inflight);
+	vhost_scsi_init_inflight(vs, old_inflight);
 
 	/*
 	 * The inflight->kref was initialized to 1. We decrement it here to
@@ -1304,7 +1304,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	 * when all the reqs are finished.
 	 */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
-		kref_put(&old_inflight[i]->kref, tcm_vhost_done_inflight);
+		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
 
 	/* Flush both the vhost poll and vhost work */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
@@ -1319,24 +1319,24 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 
 /*
  * Called from vhost_scsi_ioctl() context to walk the list of available
- * tcm_vhost_tpg with an active struct tcm_vhost_nexus
+ * vhost_scsi_tpg with an active struct vhost_scsi_nexus
  *
  *  The lock nesting rule is:
- *    tcm_vhost_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
+ *    vhost_scsi_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
  */
 static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			struct vhost_scsi_target *t)
 {
 	struct se_portal_group *se_tpg;
-	struct tcm_vhost_tport *tv_tport;
-	struct tcm_vhost_tpg *tpg;
-	struct tcm_vhost_tpg **vs_tpg;
+	struct vhost_scsi_tport *tv_tport;
+	struct vhost_scsi_tpg *tpg;
+	struct vhost_scsi_tpg **vs_tpg;
 	struct vhost_virtqueue *vq;
 	int index, ret, i, len;
 	bool match = false;
 
-	mutex_lock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
@@ -1357,7 +1357,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	if (vs->vs_tpg)
 		memcpy(vs_tpg, vs->vs_tpg, len);
 
-	list_for_each_entry(tpg, &tcm_vhost_list, tv_tpg_list) {
+	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
 		mutex_lock(&tpg->tv_tpg_mutex);
 		if (!tpg->tpg_nexus) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
@@ -1425,7 +1425,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 out:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
@@ -1434,14 +1434,14 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			  struct vhost_scsi_target *t)
 {
 	struct se_portal_group *se_tpg;
-	struct tcm_vhost_tport *tv_tport;
-	struct tcm_vhost_tpg *tpg;
+	struct vhost_scsi_tport *tv_tport;
+	struct vhost_scsi_tpg *tpg;
 	struct vhost_virtqueue *vq;
 	bool match = false;
 	int index, ret, i;
 	u8 target;
 
-	mutex_lock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
 	for (index = 0; index < vs->dev.nvqs; ++index) {
@@ -1507,14 +1507,14 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 	return 0;
 
 err_tpg:
 	mutex_unlock(&tpg->tv_tpg_mutex);
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 	return ret;
 }
 
@@ -1561,7 +1561,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		goto err_vqs;
 
 	vhost_work_init(&vs->vs_completion_work, vhost_scsi_complete_cmd_work);
-	vhost_work_init(&vs->vs_event_work, tcm_vhost_evt_work);
+	vhost_work_init(&vs->vs_event_work, vhost_scsi_evt_work);
 
 	vs->vs_events_nr = 0;
 	vs->vs_events_missed = false;
@@ -1576,7 +1576,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
 
-	tcm_vhost_init_inflight(vs, NULL);
+	vhost_scsi_init_inflight(vs, NULL);
 
 	f->private_data = vs;
 	return 0;
@@ -1708,7 +1708,7 @@ static int vhost_scsi_deregister(void)
 	return misc_deregister(&vhost_scsi_misc);
 }
 
-static char *tcm_vhost_dump_proto_id(struct tcm_vhost_tport *tport)
+static char *vhost_scsi_dump_proto_id(struct vhost_scsi_tport *tport)
 {
 	switch (tport->tport_proto_id) {
 	case SCSI_PROTOCOL_SAS:
@@ -1725,7 +1725,7 @@ static char *tcm_vhost_dump_proto_id(struct tcm_vhost_tport *tport)
 }
 
 static void
-tcm_vhost_do_plug(struct tcm_vhost_tpg *tpg,
+vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 		  struct se_lun *lun, bool plug)
 {
 
@@ -1746,71 +1746,71 @@ tcm_vhost_do_plug(struct tcm_vhost_tpg *tpg,
 	vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	mutex_lock(&vq->mutex);
 	if (vhost_has_feature(vq, VIRTIO_SCSI_F_HOTPLUG))
-		tcm_vhost_send_evt(vs, tpg, lun,
+		vhost_scsi_send_evt(vs, tpg, lun,
 				   VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
 	mutex_unlock(&vq->mutex);
 	mutex_unlock(&vs->dev.mutex);
 }
 
-static void tcm_vhost_hotplug(struct tcm_vhost_tpg *tpg, struct se_lun *lun)
+static void vhost_scsi_hotplug(struct vhost_scsi_tpg *tpg, struct se_lun *lun)
 {
-	tcm_vhost_do_plug(tpg, lun, true);
+	vhost_scsi_do_plug(tpg, lun, true);
 }
 
-static void tcm_vhost_hotunplug(struct tcm_vhost_tpg *tpg, struct se_lun *lun)
+static void vhost_scsi_hotunplug(struct vhost_scsi_tpg *tpg, struct se_lun *lun)
 {
-	tcm_vhost_do_plug(tpg, lun, false);
+	vhost_scsi_do_plug(tpg, lun, false);
 }
 
-static int tcm_vhost_port_link(struct se_portal_group *se_tpg,
+static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 			       struct se_lun *lun)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
-	tcm_vhost_hotplug(tpg, lun);
+	vhost_scsi_hotplug(tpg, lun);
 
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 
 	return 0;
 }
 
-static void tcm_vhost_port_unlink(struct se_portal_group *se_tpg,
+static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 				  struct se_lun *lun)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
-	tcm_vhost_hotunplug(tpg, lun);
+	vhost_scsi_hotunplug(tpg, lun);
 
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 }
 
 static struct se_node_acl *
-tcm_vhost_make_nodeacl(struct se_portal_group *se_tpg,
+vhost_scsi_make_nodeacl(struct se_portal_group *se_tpg,
 		       struct config_group *group,
 		       const char *name)
 {
 	struct se_node_acl *se_nacl, *se_nacl_new;
-	struct tcm_vhost_nacl *nacl;
+	struct vhost_scsi_nacl *nacl;
 	u64 wwpn = 0;
 	u32 nexus_depth;
 
-	/* tcm_vhost_parse_wwn(name, &wwpn, 1) < 0)
+	/* vhost_scsi_parse_wwn(name, &wwpn, 1) < 0)
 		return ERR_PTR(-EINVAL); */
-	se_nacl_new = tcm_vhost_alloc_fabric_acl(se_tpg);
+	se_nacl_new = vhost_scsi_alloc_fabric_acl(se_tpg);
 	if (!se_nacl_new)
 		return ERR_PTR(-ENOMEM);
 
@@ -1822,37 +1822,37 @@ tcm_vhost_make_nodeacl(struct se_portal_group *se_tpg,
 	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
 				name, nexus_depth);
 	if (IS_ERR(se_nacl)) {
-		tcm_vhost_release_fabric_acl(se_tpg, se_nacl_new);
+		vhost_scsi_release_fabric_acl(se_tpg, se_nacl_new);
 		return se_nacl;
 	}
 	/*
-	 * Locate our struct tcm_vhost_nacl and set the FC Nport WWPN
+	 * Locate our struct vhost_scsi_nacl and set the FC Nport WWPN
 	 */
-	nacl = container_of(se_nacl, struct tcm_vhost_nacl, se_node_acl);
+	nacl = container_of(se_nacl, struct vhost_scsi_nacl, se_node_acl);
 	nacl->iport_wwpn = wwpn;
 
 	return se_nacl;
 }
 
-static void tcm_vhost_drop_nodeacl(struct se_node_acl *se_acl)
+static void vhost_scsi_drop_nodeacl(struct se_node_acl *se_acl)
 {
-	struct tcm_vhost_nacl *nacl = container_of(se_acl,
-				struct tcm_vhost_nacl, se_node_acl);
+	struct vhost_scsi_nacl *nacl = container_of(se_acl,
+				struct vhost_scsi_nacl, se_node_acl);
 	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
 	kfree(nacl);
 }
 
-static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
+static void vhost_scsi_free_cmd_map_res(struct vhost_scsi_nexus *nexus,
 				       struct se_session *se_sess)
 {
-	struct tcm_vhost_cmd *tv_cmd;
+	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
 
 	if (!se_sess->sess_cmd_map)
 		return;
 
-	for (i = 0; i < TCM_VHOST_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
+	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
+		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
 
 		kfree(tv_cmd->tvc_sgl);
 		kfree(tv_cmd->tvc_prot_sgl);
@@ -1860,13 +1860,13 @@ static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
 	}
 }
 
-static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
+static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 				const char *name)
 {
 	struct se_portal_group *se_tpg;
 	struct se_session *se_sess;
-	struct tcm_vhost_nexus *tv_nexus;
-	struct tcm_vhost_cmd *tv_cmd;
+	struct vhost_scsi_nexus *tv_nexus;
+	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
@@ -1877,19 +1877,19 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 	}
 	se_tpg = &tpg->se_tpg;
 
-	tv_nexus = kzalloc(sizeof(struct tcm_vhost_nexus), GFP_KERNEL);
+	tv_nexus = kzalloc(sizeof(struct vhost_scsi_nexus), GFP_KERNEL);
 	if (!tv_nexus) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		pr_err("Unable to allocate struct tcm_vhost_nexus\n");
+		pr_err("Unable to allocate struct vhost_scsi_nexus\n");
 		return -ENOMEM;
 	}
 	/*
 	 *  Initialize the struct se_session pointer and setup tagpool
-	 *  for struct tcm_vhost_cmd descriptors
+	 *  for struct vhost_scsi_cmd descriptors
 	 */
 	tv_nexus->tvn_se_sess = transport_init_session_tags(
-					TCM_VHOST_DEFAULT_TAGS,
-					sizeof(struct tcm_vhost_cmd),
+					VHOST_SCSI_DEFAULT_TAGS,
+					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
@@ -1897,11 +1897,11 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 		return -ENOMEM;
 	}
 	se_sess = tv_nexus->tvn_se_sess;
-	for (i = 0; i < TCM_VHOST_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
+	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
+		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
 
 		tv_cmd->tvc_sgl = kzalloc(sizeof(struct scatterlist) *
-					TCM_VHOST_PREALLOC_SGLS, GFP_KERNEL);
+					VHOST_SCSI_PREALLOC_SGLS, GFP_KERNEL);
 		if (!tv_cmd->tvc_sgl) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
@@ -1909,7 +1909,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 		}
 
 		tv_cmd->tvc_upages = kzalloc(sizeof(struct page *) *
-					TCM_VHOST_PREALLOC_UPAGES, GFP_KERNEL);
+					VHOST_SCSI_PREALLOC_UPAGES, GFP_KERNEL);
 		if (!tv_cmd->tvc_upages) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
@@ -1917,7 +1917,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 		}
 
 		tv_cmd->tvc_prot_sgl = kzalloc(sizeof(struct scatterlist) *
-					TCM_VHOST_PREALLOC_PROT_SGLS, GFP_KERNEL);
+					VHOST_SCSI_PREALLOC_PROT_SGLS, GFP_KERNEL);
 		if (!tv_cmd->tvc_prot_sgl) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
@@ -1926,7 +1926,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 	}
 	/*
 	 * Since we are running in 'demo mode' this call with generate a
-	 * struct se_node_acl for the tcm_vhost struct se_portal_group with
+	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
 	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
@@ -1949,16 +1949,16 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 	return 0;
 
 out:
-	tcm_vhost_free_cmd_map_res(tv_nexus, se_sess);
+	vhost_scsi_free_cmd_map_res(tv_nexus, se_sess);
 	transport_free_session(se_sess);
 	kfree(tv_nexus);
 	return -ENOMEM;
 }
 
-static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
+static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 {
 	struct se_session *se_sess;
-	struct tcm_vhost_nexus *tv_nexus;
+	struct vhost_scsi_nexus *tv_nexus;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tv_nexus = tpg->tpg_nexus;
@@ -1990,10 +1990,10 @@ static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
 	}
 
 	pr_debug("TCM_vhost_ConfigFS: Removing I_T Nexus to emulated"
-		" %s Initiator Port: %s\n", tcm_vhost_dump_proto_id(tpg->tport),
+		" %s Initiator Port: %s\n", vhost_scsi_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 
-	tcm_vhost_free_cmd_map_res(tv_nexus, se_sess);
+	vhost_scsi_free_cmd_map_res(tv_nexus, se_sess);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
@@ -2005,12 +2005,12 @@ static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
 	return 0;
 }
 
-static ssize_t tcm_vhost_tpg_show_nexus(struct se_portal_group *se_tpg,
+static ssize_t vhost_scsi_tpg_show_nexus(struct se_portal_group *se_tpg,
 					char *page)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_nexus *tv_nexus;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_nexus *tv_nexus;
 	ssize_t ret;
 
 	mutex_lock(&tpg->tv_tpg_mutex);
@@ -2026,40 +2026,40 @@ static ssize_t tcm_vhost_tpg_show_nexus(struct se_portal_group *se_tpg,
 	return ret;
 }
 
-static ssize_t tcm_vhost_tpg_store_nexus(struct se_portal_group *se_tpg,
+static ssize_t vhost_scsi_tpg_store_nexus(struct se_portal_group *se_tpg,
 					 const char *page,
 					 size_t count)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
-	struct tcm_vhost_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[TCM_VHOST_NAMELEN], *ptr, *port_ptr;
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tport *tport_wwn = tpg->tport;
+	unsigned char i_port[VHOST_SCSI_NAMELEN], *ptr, *port_ptr;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
 	 */
 	if (!strncmp(page, "NULL", 4)) {
-		ret = tcm_vhost_drop_nexus(tpg);
+		ret = vhost_scsi_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
 	/*
 	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in tcm_vhost_make_tport(), and call
-	 * tcm_vhost_make_nexus().
+	 * the fabric protocol_id set in vhost_scsi_make_tport(), and call
+	 * vhost_scsi_make_nexus().
 	 */
-	if (strlen(page) >= TCM_VHOST_NAMELEN) {
+	if (strlen(page) >= VHOST_SCSI_NAMELEN) {
 		pr_err("Emulated NAA Sas Address: %s, exceeds"
-				" max: %d\n", page, TCM_VHOST_NAMELEN);
+				" max: %d\n", page, VHOST_SCSI_NAMELEN);
 		return -EINVAL;
 	}
-	snprintf(&i_port[0], TCM_VHOST_NAMELEN, "%s", page);
+	snprintf(&i_port[0], VHOST_SCSI_NAMELEN, "%s", page);
 
 	ptr = strstr(i_port, "naa.");
 	if (ptr) {
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
 			pr_err("Passed SAS Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
-				tcm_vhost_dump_proto_id(tport_wwn));
+				vhost_scsi_dump_proto_id(tport_wwn));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
@@ -2070,7 +2070,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(struct se_portal_group *se_tpg,
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
 			pr_err("Passed FCP Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
-				tcm_vhost_dump_proto_id(tport_wwn));
+				vhost_scsi_dump_proto_id(tport_wwn));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[3]; /* Skip over "fc." */
@@ -2081,7 +2081,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(struct se_portal_group *se_tpg,
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
 			pr_err("Passed iSCSI Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
-				tcm_vhost_dump_proto_id(tport_wwn));
+				vhost_scsi_dump_proto_id(tport_wwn));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
@@ -2097,29 +2097,29 @@ check_newline:
 	if (i_port[strlen(i_port)-1] == '\n')
 		i_port[strlen(i_port)-1] = '\0';
 
-	ret = tcm_vhost_make_nexus(tpg, port_ptr);
+	ret = vhost_scsi_make_nexus(tpg, port_ptr);
 	if (ret < 0)
 		return ret;
 
 	return count;
 }
 
-TF_TPG_BASE_ATTR(tcm_vhost, nexus, S_IRUGO | S_IWUSR);
+TF_TPG_BASE_ATTR(vhost_scsi, nexus, S_IRUGO | S_IWUSR);
 
-static struct configfs_attribute *tcm_vhost_tpg_attrs[] = {
-	&tcm_vhost_tpg_nexus.attr,
+static struct configfs_attribute *vhost_scsi_tpg_attrs[] = {
+	&vhost_scsi_tpg_nexus.attr,
 	NULL,
 };
 
 static struct se_portal_group *
-tcm_vhost_make_tpg(struct se_wwn *wwn,
+vhost_scsi_make_tpg(struct se_wwn *wwn,
 		   struct config_group *group,
 		   const char *name)
 {
-	struct tcm_vhost_tport *tport = container_of(wwn,
-			struct tcm_vhost_tport, tport_wwn);
+	struct vhost_scsi_tport *tport = container_of(wwn,
+			struct vhost_scsi_tport, tport_wwn);
 
-	struct tcm_vhost_tpg *tpg;
+	struct vhost_scsi_tpg *tpg;
 	unsigned long tpgt;
 	int ret;
 
@@ -2128,9 +2128,9 @@ tcm_vhost_make_tpg(struct se_wwn *wwn,
 	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	tpg = kzalloc(sizeof(struct tcm_vhost_tpg), GFP_KERNEL);
+	tpg = kzalloc(sizeof(struct vhost_scsi_tpg), GFP_KERNEL);
 	if (!tpg) {
-		pr_err("Unable to allocate struct tcm_vhost_tpg");
+		pr_err("Unable to allocate struct vhost_scsi_tpg");
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&tpg->tv_tpg_mutex);
@@ -2138,31 +2138,31 @@ tcm_vhost_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&tcm_vhost_fabric_configfs->tf_ops, wwn,
+	ret = core_tpg_register(&vhost_scsi_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
 	}
-	mutex_lock(&tcm_vhost_mutex);
-	list_add_tail(&tpg->tv_tpg_list, &tcm_vhost_list);
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
+	list_add_tail(&tpg->tv_tpg_list, &vhost_scsi_list);
+	mutex_unlock(&vhost_scsi_mutex);
 
 	return &tpg->se_tpg;
 }
 
-static void tcm_vhost_drop_tpg(struct se_portal_group *se_tpg)
+static void vhost_scsi_drop_tpg(struct se_portal_group *se_tpg)
 {
-	struct tcm_vhost_tpg *tpg = container_of(se_tpg,
-				struct tcm_vhost_tpg, se_tpg);
+	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
+				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&tcm_vhost_mutex);
+	mutex_lock(&vhost_scsi_mutex);
 	list_del(&tpg->tv_tpg_list);
-	mutex_unlock(&tcm_vhost_mutex);
+	mutex_unlock(&vhost_scsi_mutex);
 	/*
 	 * Release the virtual I_T Nexus for this vhost TPG
 	 */
-	tcm_vhost_drop_nexus(tpg);
+	vhost_scsi_drop_nexus(tpg);
 	/*
 	 * Deregister the se_tpg from TCM..
 	 */
@@ -2171,21 +2171,21 @@ static void tcm_vhost_drop_tpg(struct se_portal_group *se_tpg)
 }
 
 static struct se_wwn *
-tcm_vhost_make_tport(struct target_fabric_configfs *tf,
+vhost_scsi_make_tport(struct target_fabric_configfs *tf,
 		     struct config_group *group,
 		     const char *name)
 {
-	struct tcm_vhost_tport *tport;
+	struct vhost_scsi_tport *tport;
 	char *ptr;
 	u64 wwpn = 0;
 	int off = 0;
 
-	/* if (tcm_vhost_parse_wwn(name, &wwpn, 1) < 0)
+	/* if (vhost_scsi_parse_wwn(name, &wwpn, 1) < 0)
 		return ERR_PTR(-EINVAL); */
 
-	tport = kzalloc(sizeof(struct tcm_vhost_tport), GFP_KERNEL);
+	tport = kzalloc(sizeof(struct vhost_scsi_tport), GFP_KERNEL);
 	if (!tport) {
-		pr_err("Unable to allocate struct tcm_vhost_tport");
+		pr_err("Unable to allocate struct vhost_scsi_tport");
 		return ERR_PTR(-ENOMEM);
 	}
 	tport->tport_wwpn = wwpn;
@@ -2216,102 +2216,102 @@ tcm_vhost_make_tport(struct target_fabric_configfs *tf,
 	return ERR_PTR(-EINVAL);
 
 check_len:
-	if (strlen(name) >= TCM_VHOST_NAMELEN) {
+	if (strlen(name) >= VHOST_SCSI_NAMELEN) {
 		pr_err("Emulated %s Address: %s, exceeds"
-			" max: %d\n", name, tcm_vhost_dump_proto_id(tport),
-			TCM_VHOST_NAMELEN);
+			" max: %d\n", name, vhost_scsi_dump_proto_id(tport),
+			VHOST_SCSI_NAMELEN);
 		kfree(tport);
 		return ERR_PTR(-EINVAL);
 	}
-	snprintf(&tport->tport_name[0], TCM_VHOST_NAMELEN, "%s", &name[off]);
+	snprintf(&tport->tport_name[0], VHOST_SCSI_NAMELEN, "%s", &name[off]);
 
 	pr_debug("TCM_VHost_ConfigFS: Allocated emulated Target"
-		" %s Address: %s\n", tcm_vhost_dump_proto_id(tport), name);
+		" %s Address: %s\n", vhost_scsi_dump_proto_id(tport), name);
 
 	return &tport->tport_wwn;
 }
 
-static void tcm_vhost_drop_tport(struct se_wwn *wwn)
+static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 {
-	struct tcm_vhost_tport *tport = container_of(wwn,
-				struct tcm_vhost_tport, tport_wwn);
+	struct vhost_scsi_tport *tport = container_of(wwn,
+				struct vhost_scsi_tport, tport_wwn);
 
 	pr_debug("TCM_VHost_ConfigFS: Deallocating emulated Target"
-		" %s Address: %s\n", tcm_vhost_dump_proto_id(tport),
+		" %s Address: %s\n", vhost_scsi_dump_proto_id(tport),
 		tport->tport_name);
 
 	kfree(tport);
 }
 
 static ssize_t
-tcm_vhost_wwn_show_attr_version(struct target_fabric_configfs *tf,
+vhost_scsi_wwn_show_attr_version(struct target_fabric_configfs *tf,
 				char *page)
 {
 	return sprintf(page, "TCM_VHOST fabric module %s on %s/%s"
-		"on "UTS_RELEASE"\n", TCM_VHOST_VERSION, utsname()->sysname,
+		"on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 }
 
-TF_WWN_ATTR_RO(tcm_vhost, version);
+TF_WWN_ATTR_RO(vhost_scsi, version);
 
-static struct configfs_attribute *tcm_vhost_wwn_attrs[] = {
-	&tcm_vhost_wwn_version.attr,
+static struct configfs_attribute *vhost_scsi_wwn_attrs[] = {
+	&vhost_scsi_wwn_version.attr,
 	NULL,
 };
 
-static struct target_core_fabric_ops tcm_vhost_ops = {
-	.get_fabric_name		= tcm_vhost_get_fabric_name,
-	.get_fabric_proto_ident		= tcm_vhost_get_fabric_proto_ident,
-	.tpg_get_wwn			= tcm_vhost_get_fabric_wwn,
-	.tpg_get_tag			= tcm_vhost_get_tag,
-	.tpg_get_default_depth		= tcm_vhost_get_default_depth,
-	.tpg_get_pr_transport_id	= tcm_vhost_get_pr_transport_id,
-	.tpg_get_pr_transport_id_len	= tcm_vhost_get_pr_transport_id_len,
-	.tpg_parse_pr_out_transport_id	= tcm_vhost_parse_pr_out_transport_id,
-	.tpg_check_demo_mode		= tcm_vhost_check_true,
-	.tpg_check_demo_mode_cache	= tcm_vhost_check_true,
-	.tpg_check_demo_mode_write_protect = tcm_vhost_check_false,
-	.tpg_check_prod_mode_write_protect = tcm_vhost_check_false,
-	.tpg_alloc_fabric_acl		= tcm_vhost_alloc_fabric_acl,
-	.tpg_release_fabric_acl		= tcm_vhost_release_fabric_acl,
-	.tpg_get_inst_index		= tcm_vhost_tpg_get_inst_index,
-	.release_cmd			= tcm_vhost_release_cmd,
+static struct target_core_fabric_ops vhost_scsi_ops = {
+	.get_fabric_name		= vhost_scsi_get_fabric_name,
+	.get_fabric_proto_ident		= vhost_scsi_get_fabric_proto_ident,
+	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
+	.tpg_get_tag			= vhost_scsi_get_tpgt,
+	.tpg_get_default_depth		= vhost_scsi_get_default_depth,
+	.tpg_get_pr_transport_id	= vhost_scsi_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= vhost_scsi_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= vhost_scsi_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= vhost_scsi_check_true,
+	.tpg_check_demo_mode_cache	= vhost_scsi_check_true,
+	.tpg_check_demo_mode_write_protect = vhost_scsi_check_false,
+	.tpg_check_prod_mode_write_protect = vhost_scsi_check_false,
+	.tpg_alloc_fabric_acl		= vhost_scsi_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= vhost_scsi_release_fabric_acl,
+	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
+	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
-	.shutdown_session		= tcm_vhost_shutdown_session,
-	.close_session			= tcm_vhost_close_session,
-	.sess_get_index			= tcm_vhost_sess_get_index,
+	.shutdown_session		= vhost_scsi_shutdown_session,
+	.close_session			= vhost_scsi_close_session,
+	.sess_get_index			= vhost_scsi_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
-	.write_pending			= tcm_vhost_write_pending,
-	.write_pending_status		= tcm_vhost_write_pending_status,
-	.set_default_node_attributes	= tcm_vhost_set_default_node_attrs,
-	.get_task_tag			= tcm_vhost_get_task_tag,
-	.get_cmd_state			= tcm_vhost_get_cmd_state,
-	.queue_data_in			= tcm_vhost_queue_data_in,
-	.queue_status			= tcm_vhost_queue_status,
-	.queue_tm_rsp			= tcm_vhost_queue_tm_rsp,
-	.aborted_task			= tcm_vhost_aborted_task,
+	.write_pending			= vhost_scsi_write_pending,
+	.write_pending_status		= vhost_scsi_write_pending_status,
+	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
+	.get_task_tag			= vhost_scsi_get_task_tag,
+	.get_cmd_state			= vhost_scsi_get_cmd_state,
+	.queue_data_in			= vhost_scsi_queue_data_in,
+	.queue_status			= vhost_scsi_queue_status,
+	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
+	.aborted_task			= vhost_scsi_aborted_task,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
-	.fabric_make_wwn		= tcm_vhost_make_tport,
-	.fabric_drop_wwn		= tcm_vhost_drop_tport,
-	.fabric_make_tpg		= tcm_vhost_make_tpg,
-	.fabric_drop_tpg		= tcm_vhost_drop_tpg,
-	.fabric_post_link		= tcm_vhost_port_link,
-	.fabric_pre_unlink		= tcm_vhost_port_unlink,
+	.fabric_make_wwn		= vhost_scsi_make_tport,
+	.fabric_drop_wwn		= vhost_scsi_drop_tport,
+	.fabric_make_tpg		= vhost_scsi_make_tpg,
+	.fabric_drop_tpg		= vhost_scsi_drop_tpg,
+	.fabric_post_link		= vhost_scsi_port_link,
+	.fabric_pre_unlink		= vhost_scsi_port_unlink,
 	.fabric_make_np			= NULL,
 	.fabric_drop_np			= NULL,
-	.fabric_make_nodeacl		= tcm_vhost_make_nodeacl,
-	.fabric_drop_nodeacl		= tcm_vhost_drop_nodeacl,
+	.fabric_make_nodeacl		= vhost_scsi_make_nodeacl,
+	.fabric_drop_nodeacl		= vhost_scsi_drop_nodeacl,
 };
 
-static int tcm_vhost_register_configfs(void)
+static int vhost_scsi_register_configfs(void)
 {
 	struct target_fabric_configfs *fabric;
 	int ret;
 
-	pr_debug("TCM_VHOST fabric module %s on %s/%s"
-		" on "UTS_RELEASE"\n", TCM_VHOST_VERSION, utsname()->sysname,
+	pr_debug("vhost-scsi fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 	/*
 	 * Register the top level struct config_item_type with TCM core
@@ -2322,14 +2322,14 @@ static int tcm_vhost_register_configfs(void)
 		return PTR_ERR(fabric);
 	}
 	/*
-	 * Setup fabric->tf_ops from our local tcm_vhost_ops
+	 * Setup fabric->tf_ops from our local vhost_scsi_ops
 	 */
-	fabric->tf_ops = tcm_vhost_ops;
+	fabric->tf_ops = vhost_scsi_ops;
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_vhost_wwn_attrs;
-	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_vhost_tpg_attrs;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = vhost_scsi_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = vhost_scsi_tpg_attrs;
 	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
 	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
@@ -2349,37 +2349,37 @@ static int tcm_vhost_register_configfs(void)
 	/*
 	 * Setup our local pointer to *fabric
 	 */
-	tcm_vhost_fabric_configfs = fabric;
-	pr_debug("TCM_VHOST[0] - Set fabric -> tcm_vhost_fabric_configfs\n");
+	vhost_scsi_fabric_configfs = fabric;
+	pr_debug("TCM_VHOST[0] - Set fabric -> vhost_scsi_fabric_configfs\n");
 	return 0;
 };
 
-static void tcm_vhost_deregister_configfs(void)
+static void vhost_scsi_deregister_configfs(void)
 {
-	if (!tcm_vhost_fabric_configfs)
+	if (!vhost_scsi_fabric_configfs)
 		return;
 
-	target_fabric_configfs_deregister(tcm_vhost_fabric_configfs);
-	tcm_vhost_fabric_configfs = NULL;
-	pr_debug("TCM_VHOST[0] - Cleared tcm_vhost_fabric_configfs\n");
+	target_fabric_configfs_deregister(vhost_scsi_fabric_configfs);
+	vhost_scsi_fabric_configfs = NULL;
+	pr_debug("TCM_VHOST[0] - Cleared vhost_scsi_fabric_configfs\n");
 };
 
-static int __init tcm_vhost_init(void)
+static int __init vhost_scsi_init(void)
 {
 	int ret = -ENOMEM;
 	/*
 	 * Use our own dedicated workqueue for submitting I/O into
 	 * target core to avoid contention within system_wq.
 	 */
-	tcm_vhost_workqueue = alloc_workqueue("tcm_vhost", 0, 0);
-	if (!tcm_vhost_workqueue)
+	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", 0, 0);
+	if (!vhost_scsi_workqueue)
 		goto out;
 
 	ret = vhost_scsi_register();
 	if (ret < 0)
 		goto out_destroy_workqueue;
 
-	ret = tcm_vhost_register_configfs();
+	ret = vhost_scsi_register_configfs();
 	if (ret < 0)
 		goto out_vhost_scsi_deregister;
 
@@ -2388,20 +2388,20 @@ static int __init tcm_vhost_init(void)
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
 out_destroy_workqueue:
-	destroy_workqueue(tcm_vhost_workqueue);
+	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
 
-static void tcm_vhost_exit(void)
+static void vhost_scsi_exit(void)
 {
-	tcm_vhost_deregister_configfs();
+	vhost_scsi_deregister_configfs();
 	vhost_scsi_deregister();
-	destroy_workqueue(tcm_vhost_workqueue);
+	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
 MODULE_ALIAS("tcm_vhost");
 MODULE_LICENSE("GPL");
-module_init(tcm_vhost_init);
-module_exit(tcm_vhost_exit);
+module_init(vhost_scsi_init);
+module_exit(vhost_scsi_exit);
-- 
1.9.1
