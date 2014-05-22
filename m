From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 3/6] vhost/scsi: Add preallocation of protection SGLs
Date: Thu, 22 May 2014 02:26:19 +0000
Message-ID: <1400725582-5521-4-git-send-email-nab@daterainc.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58024 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaEVCvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 22:51:05 -0400
Received: by mail-oa0-f53.google.com with SMTP id m1so3316277oag.40
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 19:51:04 -0700 (PDT)
In-Reply-To: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>

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
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ae434db..30402e6 100644
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
@@ -722,7 +724,7 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 	struct tcm_vhost_cmd *cmd;
 	struct tcm_vhost_nexus *tv_nexus;
 	struct se_session *se_sess;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
 	int tag;
 
@@ -741,10 +743,12 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 
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
@@ -1703,6 +1707,7 @@ static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
 		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
 
 		kfree(tv_cmd->tvc_sgl);
+		kfree(tv_cmd->tvc_prot_sgl);
 		kfree(tv_cmd->tvc_upages);
 	}
 }
@@ -1762,6 +1767,14 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
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
1.7.10.4

