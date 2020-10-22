Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C77C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F612225F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKooyk1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507567AbgJVAfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507556AbgJVAfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0UDiS174977;
        Thu, 22 Oct 2020 00:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=aYEB9oNwgE3rL1pWC/WbwJ3rVzn4m1SbcZXmZ3XDWmI=;
 b=MKooyk1dprZmClpjpCGRXLj6PlTzLS7h7g8IiI4u24hK1BCBbgQN9g13z7K4+8kOloJu
 U7cGIPShkATKvimrXI9HdA77gSuzwrxZfcoxs/N8FmMTiwf+QhJC9xvY+r5ZPsoiJomU
 JM0q2Ifr9zGgiCqlCmE4b3GBNvXpyg2ojGTwpOZ7ofgaLeSAmjGvU0wg2b4kDFOTUHS7
 depTTuc4M+K+y6bkOASulc5BHQdF3GHkfAVtjoMEB7joBPuYbQlLr7qe0ed2dcRtDA6Q
 /8WMawd/i2UICDDHDRxqgIyP3Tf2O14HBtY7onT6NAJqEVc/+SjCHWk70e1Nr6V5BGLG Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34ak16kp3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0TvLL117901;
        Thu, 22 Oct 2020 00:35:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ak1995de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0ZGQc025694;
        Thu, 22 Oct 2020 00:35:16 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:16 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 09/17] vhost scsi: fix cmd completion race
Date:   Wed, 21 Oct 2020 19:34:55 -0500
Message-Id: <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
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
---
 drivers/vhost/scsi.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f6b9010..2fa48dd 100644
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
@@ -1096,7 +1084,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
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

