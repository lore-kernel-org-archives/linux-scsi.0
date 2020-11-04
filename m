Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A50C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1857F20825
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QxpV1A0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbgKDW1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 17:27:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732243AbgKDW1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 17:27:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MNw1a075753;
        Wed, 4 Nov 2020 22:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=EwdRm1umLepHoKYDoCNXhngQwj5gSn0mYpNs+D38boc=;
 b=QxpV1A0t+MMzeowMLhSJXlO7CfdT4M38wCz2ryWhZq7VGL/snNZ6e23P+tq6XnREqSyP
 cTYnYW0ZuoKGkTS3bYe1EZU+ZilLd9FUix3iqaYSgZzaWr1C3PVdIu4emtt53oUpRyre
 5Iu7D24pJd6J80aZVEyDmJ+o085phNEUvQIA4Qo4mHRyqNQkPmVDhsjsY/1CrtLF0UcL
 wsGhbbLMWqJyGN53QdqW2DJH65NYI1hGlKkWqtT0mJicOvwfepRQeP0Q2TFLx4OuegZt
 wPdx1Oi34WpT89bjoqfu9X6OgaI8jQgSCGw3WnSBWFVLM4DEZnrvYLjR2ebhygF7CPz7 yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34hhvch7c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 22:27:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MKkX9192173;
        Wed, 4 Nov 2020 22:26:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34hw0g9gxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 22:26:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4MQwQ5008233;
        Wed, 4 Nov 2020 22:26:58 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 14:26:58 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 09/11] vhost scsi: fix cmd completion race
Date:   Wed,  4 Nov 2020 16:26:42 -0600
Message-Id: <1604528804-2878-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040159
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
index aecfa5f..0d5cec5 100644
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

