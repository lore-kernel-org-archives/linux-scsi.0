Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0BFC5517A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8086207BC
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uXbMA7cK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgKJFdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 00:33:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbgKJFdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 00:33:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5JPC7141677;
        Tue, 10 Nov 2020 05:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=1EmFXJlLM7eeTgidZ48+xyRSKazL6wPDsGKo9/nl8mc=;
 b=uXbMA7cK8ebbHC2SDhI0TqkVOz6XZ5ogO0aKy2/PtdKzqk/wkJ1Zytgy0ZGuDwILkzTJ
 vlNJBL/NNCUqs6mPJEq7XDq8vlRqo+YqVAHXSsvilWWAe+uKJZalimb2Mu2/d+cYBBAu
 LeuiaL7VugDYST+tI/QqI9AAFSpxTlHCYnvXXlXeCgyj2/u/5pK3G01ynKaDo1zP0NlA
 nXX/xmZMbp2bMT5KU0awx5JBSFZKV215LzReGrHmfWhOcqtA+7URqmNpPouF23KjtJNy
 HY9Rwix4su/VhwB6UUBqL7aYEYpVAu9cz+v7H7n799VIZ2qFGWb+UxiaIvKP/zpFbxmn 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72eftbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 05:33:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5EoBu125353;
        Tue, 10 Nov 2020 05:33:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5fyqrk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 05:33:33 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AA5XXf5011733;
        Tue, 10 Nov 2020 05:33:33 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 21:33:32 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 3/5] vhost scsi: fix cmd completion race
Date:   Mon,  9 Nov 2020 23:33:21 -0600
Message-Id: <1604986403-4931-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=2 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
When the last put happens a little later then we could race where
vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.

This patch has us delay completing the cmd until the last lio core ref
is dropped. We then know that once we signal to the guest that the cmd
is completed that if it queues a new command it will find a free cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/vhost/scsi.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e31339b..5d8850f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -322,7 +322,7 @@ static u32 vhost_scsi_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
+static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
 				struct vhost_scsi_cmd, tvc_se_cmd);
@@ -344,6 +344,16 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	vhost_scsi_put_inflight(inflight);
 }
 
+static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
+{
+	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
+					struct vhost_scsi_cmd, tvc_se_cmd);
+	struct vhost_scsi *vs = cmd->tvc_vhost;
+
+	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
+	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+}
+
 static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
 {
 	return 0;
@@ -366,28 +376,15 @@ static int vhost_scsi_get_cmd_state(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void vhost_scsi_complete_cmd(struct vhost_scsi_cmd *cmd)
-{
-	struct vhost_scsi *vs = cmd->tvc_vhost;
-
-	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
-
-	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
-}
-
 static int vhost_scsi_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
-				struct vhost_scsi_cmd, tvc_se_cmd);
-	vhost_scsi_complete_cmd(cmd);
+	transport_generic_free_cmd(se_cmd, 0);
 	return 0;
 }
 
 static int vhost_scsi_queue_status(struct se_cmd *se_cmd)
 {
-	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
-				struct vhost_scsi_cmd, tvc_se_cmd);
-	vhost_scsi_complete_cmd(cmd);
+	transport_generic_free_cmd(se_cmd, 0);
 	return 0;
 }
 
@@ -433,15 +430,6 @@ static void vhost_scsi_free_evt(struct vhost_scsi *vs, struct vhost_scsi_evt *ev
 	return evt;
 }
 
-static void vhost_scsi_free_cmd(struct vhost_scsi_cmd *cmd)
-{
-	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
-
-	/* TODO locking against target/backend threads? */
-	transport_generic_free_cmd(se_cmd, 0);
-
-}
-
 static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
 {
 	return target_put_sess_cmd(se_cmd);
@@ -560,7 +548,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
-		vhost_scsi_free_cmd(cmd);
+		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
 	vq = -1;
@@ -1091,7 +1079,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 						      &prot_iter, exp_data_len,
 						      &data_iter))) {
 				vq_err(vq, "Failed to map iov to sgl\n");
-				vhost_scsi_release_cmd(&cmd->tvc_se_cmd);
+				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
 				goto err;
 			}
 		}
-- 
1.8.3.1

