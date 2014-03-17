From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFCv2 3/7] vhost/scsi: Add preallocation of protection SGLs
Date: Mon, 17 Mar 2014 05:32:57 +0000
Message-ID: <1395034381-656-4-git-send-email-nab@daterainc.com>
References: <1395034381-656-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395034381-656-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates tcm_vhost_make_nexus() to pre-allocate per descriptor
tcm_vhost_cmd->tvc_prot_sgl[] used to expose protection SGLs from within
virtio-scsi guest memory to vhost-scsi.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8c88ce9..a2cb289 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -58,6 +58,7 @@
 #define TCM_VHOST_DEFAULT_TAGS 256
 #define TCM_VHOST_PREALLOC_SGLS 2048
 #define TCM_VHOST_PREALLOC_UPAGES 2048
+#define TCM_VHOST_PREALLOC_PROT_SGLS 512
 
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
@@ -83,6 +84,7 @@ struct tcm_vhost_cmd {
 	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
+	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
 	/* Pointer to response */
 	struct virtio_scsi_cmd_resp __user *tvc_resp;
@@ -717,7 +719,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 	struct tcm_vhost_cmd *cmd;
 	struct tcm_vhost_nexus *tv_nexus;
 	struct se_session *se_sess;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
 	int tag;
 
@@ -736,10 +738,12 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 
 	cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[tag];
 	sg = cmd->tvc_sgl;
+	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
 	memset(cmd, 0, sizeof(struct tcm_vhost_cmd));
 
 	cmd->tvc_sgl = sg;
+	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->tvc_tag = v_req->tag;
@@ -1692,6 +1696,7 @@ static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
 		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
 
 		kfree(tv_cmd->tvc_sgl);
+		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
 	}
 }
@@ -1750,6 +1755,14 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
 			goto out;
 		}
+
+		tv_cmd->tvc_prot_sgl = kzalloc(sizeof(struct scatterlist) *
+					TCM_VHOST_PREALLOC_PROT_SGLS, GFP_KERNEL);
+		if (!tv_cmd->tvc_prot_sgl) {
+			mutex_unlock(&tpg->tv_tpg_mutex);
+			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
+			goto out;
+		}
 	}
 	/*
 	 * Since we are running in 'demo mode' this call with generate a
-- 
1.7.2.5
