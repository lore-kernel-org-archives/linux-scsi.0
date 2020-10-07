Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED0EC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E46020872
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iNFSF82Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgJGUzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgJGUza (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoBsP028846;
        Wed, 7 Oct 2020 20:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PwNFczbC8s1H1iexbFxiXSr3V+MYluFMMJIQZWiW7mg=;
 b=iNFSF82YemKWysNav0QFxe7TOrXtLeq18dmZrGrVzgIlFVacewuCfAhH/pu+bpuVTiqt
 n5CQqMKD3FWB/aBt3KJEbYGOSrWYAcFBHEwQ6qG2IWit6PZw7YPG5b3rzsRoia3migak
 8b1KMSZurN9VGLM7aSyounBBGRYmI01k7EB4Lr6Tlq9VbY0Zqya2JnR9j5k1r499c81b
 3W4ZIBdKPjzaJytxLUeWxEKbtTpm8Ed1QnUiHaMQDFO8lKxbJgADrcMV/mYv06U/PyJf
 n52OAT/dppyARWatzb0FEYQRghYtKWmGhN5/baIT2Id3kQvq/SljnG+E6FGfe+VhVtto SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb4ef3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpL2l166319;
        Wed, 7 Oct 2020 20:55:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vpyv08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097KtLNu032109;
        Wed, 7 Oct 2020 20:55:21 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:21 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 08/16] vhost scsi: alloc cmds per vq instead of session
Date:   Wed,  7 Oct 2020 15:54:53 -0500
Message-Id: <1602104101-5592-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently are limited to 256 cmds per session. This leads to problems
where if the user has increased virtqueue_size to more than 2 or
cmd_per_lun to more than 256 vhost_scsi_get_tag can fail and the guest
will get IO errors.

This patch moves the cmd allocation to per vq so we can easily match
whatever the user has specified for num_queues and
virtqueue_size/cmd_per_lun. It also makes it easier to control how much
memory we preallocate. For cases, where perf is not as important and
we can use the current defaults (1 vq and 128 cmds per vq) memory use
from preallocate cmds is cut in half. For cases, where we are willing
to use more memory for higher perf, cmd mem use will now increase as
the num queues and queue depth increases.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

V2
- fix use before set cpu var errors
- drop vhost_vq_is_setup

 drivers/vhost/scsi.c | 207 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 128 insertions(+), 79 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ab1b656..f6b9010 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -52,7 +52,6 @@
 #define VHOST_SCSI_VERSION  "v0.1"
 #define VHOST_SCSI_NAMELEN 256
 #define VHOST_SCSI_MAX_CDB_SIZE 32
-#define VHOST_SCSI_DEFAULT_TAGS 256
 #define VHOST_SCSI_PREALLOC_SGLS 2048
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
@@ -189,6 +188,9 @@ struct vhost_scsi_virtqueue {
 	 * Writers must also take dev mutex and flush under it.
 	 */
 	int inflight_idx;
+	struct vhost_scsi_cmd *scsi_cmds;
+	struct sbitmap scsi_tags;
+	int max_cmds;
 };
 
 struct vhost_scsi {
@@ -324,7 +326,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
 				struct vhost_scsi_cmd, tvc_se_cmd);
-	struct se_session *se_sess = tv_cmd->tvc_nexus->tvn_se_sess;
+	struct vhost_scsi_virtqueue *svq = container_of(tv_cmd->tvc_vq,
+				struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_inflight *inflight = tv_cmd->inflight;
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
@@ -336,8 +340,8 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
 	}
 
-	vhost_scsi_put_inflight(tv_cmd->inflight);
-	target_free_tag(se_sess, se_cmd);
+	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
+	vhost_scsi_put_inflight(inflight);
 }
 
 static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
@@ -566,31 +570,31 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 }
 
 static struct vhost_scsi_cmd *
-vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
+vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
 		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 task_attr,
 		   u32 exp_data_len, int data_direction)
 {
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct vhost_scsi_nexus *tv_nexus;
-	struct se_session *se_sess;
 	struct scatterlist *sg, *prot_sg;
 	struct page **pages;
-	int tag, cpu;
+	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
 		pr_err("Unable to locate active struct vhost_scsi_nexus\n");
 		return ERR_PTR(-EIO);
 	}
-	se_sess = tv_nexus->tvn_se_sess;
 
-	tag = sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
+	tag = sbitmap_get(&svq->scsi_tags, 0, false);
 	if (tag < 0) {
 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd = &svq->scsi_cmds[tag];
 	sg = cmd->tvc_sgl;
 	prot_sg = cmd->tvc_prot_sgl;
 	pages = cmd->tvc_upages;
@@ -599,7 +603,6 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	cmd->tvc_prot_sgl = prot_sg;
 	cmd->tvc_upages = pages;
 	cmd->tvc_se_cmd.map_tag = tag;
-	cmd->tvc_se_cmd.map_cpu = cpu;
 	cmd->tvc_tag = scsi_tag;
 	cmd->tvc_lun = lun;
 	cmd->tvc_task_attr = task_attr;
@@ -1070,11 +1073,11 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
 				goto err;
 		}
-		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
+		cmd = vhost_scsi_get_cmd(vq, tpg, cdb, tag, lun, task_attr,
 					 exp_data_len + prot_bytes,
 					 data_direction);
 		if (IS_ERR(cmd)) {
-			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
+			vq_err(vq, "vhost_scsi_get_cmd failed %ld\n",
 			       PTR_ERR(cmd));
 			goto err;
 		}
@@ -1378,6 +1381,83 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		wait_for_completion(&old_inflight[i]->comp);
 }
 
+static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (!svq->scsi_cmds)
+		return;
+
+	for (i = 0; i < svq->max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+
+		kfree(tv_cmd->tvc_sgl);
+		kfree(tv_cmd->tvc_prot_sgl);
+		kfree(tv_cmd->tvc_upages);
+	}
+
+	sbitmap_free(&svq->scsi_tags);
+	kfree(svq->scsi_cmds);
+	svq->scsi_cmds = NULL;
+}
+
+static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (svq->scsi_cmds)
+		return 0;
+
+	if (sbitmap_init_node(&svq->scsi_tags, max_cmds, -1, GFP_KERNEL,
+			      NUMA_NO_NODE))
+		return -ENOMEM;
+	svq->max_cmds = max_cmds;
+
+	svq->scsi_cmds = kcalloc(max_cmds, sizeof(*tv_cmd), GFP_KERNEL);
+	if (!svq->scsi_cmds) {
+		sbitmap_free(&svq->scsi_tags);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+
+		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
+					  sizeof(struct scatterlist),
+					  GFP_KERNEL);
+		if (!tv_cmd->tvc_sgl) {
+			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
+			goto out;
+		}
+
+		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
+					     sizeof(struct page *),
+					     GFP_KERNEL);
+		if (!tv_cmd->tvc_upages) {
+			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
+			goto out;
+		}
+
+		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
+					       sizeof(struct scatterlist),
+					       GFP_KERNEL);
+		if (!tv_cmd->tvc_prot_sgl) {
+			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
+			goto out;
+		}
+	}
+	return 0;
+out:
+	vhost_scsi_destroy_vq_cmds(vq);
+	return -ENOMEM;
+}
+
 /*
  * Called from vhost_scsi_ioctl() context to walk the list of available
  * vhost_scsi_tpg with an active struct vhost_scsi_nexus
@@ -1432,10 +1512,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
 			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
-				kfree(vs_tpg);
 				mutex_unlock(&tpg->tv_tpg_mutex);
 				ret = -EEXIST;
-				goto out;
+				goto undepend;
 			}
 			/*
 			 * In order to ensure individual vhost-scsi configfs
@@ -1447,9 +1526,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 			ret = target_depend_item(&se_tpg->tpg_group.cg_item);
 			if (ret) {
 				pr_warn("target_depend_item() failed: %d\n", ret);
-				kfree(vs_tpg);
 				mutex_unlock(&tpg->tv_tpg_mutex);
-				goto out;
+				goto undepend;
 			}
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
@@ -1462,6 +1540,16 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	if (match) {
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
+
+		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
+			vq = &vs->vqs[i].vq;
+			if (!vq->initialized)
+				continue;
+
+			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
+				goto destroy_vq_cmds;
+		}
+
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
@@ -1484,7 +1572,22 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	vhost_scsi_flush(vs);
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = vs_tpg;
+	goto out;
 
+destroy_vq_cmds:
+	for (i--; i >= VHOST_SCSI_VQ_IO; i--) {
+		if (!vhost_vq_get_backend(&vs->vqs[i].vq))
+			vhost_scsi_destroy_vq_cmds(&vs->vqs[i].vq);
+	}
+undepend:
+	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
+		tpg = vs_tpg[i];
+		if (tpg) {
+			tpg->tv_tpg_vhost_count--;
+			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
+		}
+	}
+	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
 	mutex_unlock(&vhost_scsi_mutex);
@@ -1560,6 +1663,12 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, NULL);
 			mutex_unlock(&vq->mutex);
+			/*
+			 * Make sure cmds are not running before tearing them
+			 * down.
+			 */
+			vhost_scsi_flush(vs);
+			vhost_scsi_destroy_vq_cmds(vq);
 		}
 	}
 	/*
@@ -1861,23 +1970,6 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 	mutex_unlock(&vhost_scsi_mutex);
 }
 
-static void vhost_scsi_free_cmd_map_res(struct se_session *se_sess)
-{
-	struct vhost_scsi_cmd *tv_cmd;
-	unsigned int i;
-
-	if (!se_sess->sess_cmd_map)
-		return;
-
-	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
-
-		kfree(tv_cmd->tvc_sgl);
-		kfree(tv_cmd->tvc_prot_sgl);
-		kfree(tv_cmd->tvc_upages);
-	}
-}
-
 static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
 		struct config_item *item, const char *page, size_t count)
 {
@@ -1917,45 +2009,6 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
 	NULL,
 };
 
-static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
-			       struct se_session *se_sess, void *p)
-{
-	struct vhost_scsi_cmd *tv_cmd;
-	unsigned int i;
-
-	for (i = 0; i < VHOST_SCSI_DEFAULT_TAGS; i++) {
-		tv_cmd = &((struct vhost_scsi_cmd *)se_sess->sess_cmd_map)[i];
-
-		tv_cmd->tvc_sgl = kcalloc(VHOST_SCSI_PREALLOC_SGLS,
-					  sizeof(struct scatterlist),
-					  GFP_KERNEL);
-		if (!tv_cmd->tvc_sgl) {
-			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
-			goto out;
-		}
-
-		tv_cmd->tvc_upages = kcalloc(VHOST_SCSI_PREALLOC_UPAGES,
-					     sizeof(struct page *),
-					     GFP_KERNEL);
-		if (!tv_cmd->tvc_upages) {
-			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
-			goto out;
-		}
-
-		tv_cmd->tvc_prot_sgl = kcalloc(VHOST_SCSI_PREALLOC_PROT_SGLS,
-					       sizeof(struct scatterlist),
-					       GFP_KERNEL);
-		if (!tv_cmd->tvc_prot_sgl) {
-			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
-			goto out;
-		}
-	}
-	return 0;
-out:
-	vhost_scsi_free_cmd_map_res(se_sess);
-	return -ENOMEM;
-}
-
 static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 				const char *name)
 {
@@ -1979,12 +2032,9 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
-					VHOST_SCSI_DEFAULT_TAGS,
-					sizeof(struct vhost_scsi_cmd),
+	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name, tv_nexus,
-					vhost_scsi_nexus_cb);
+					(unsigned char *)name, tv_nexus, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
@@ -2034,7 +2084,6 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 		" %s Initiator Port: %s\n", vhost_scsi_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 
-	vhost_scsi_free_cmd_map_res(se_sess);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-- 
1.8.3.1

