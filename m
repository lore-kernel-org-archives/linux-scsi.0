Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7969CC2BB48
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3046822583
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgLDH5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59638 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgLDH5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47oOOk026140;
        Fri, 4 Dec 2020 07:56:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0xHJTknsigptAmxtGR0ya6vv59PHoXzUKSgeLJA21UY=;
 b=h5PjlktXCjshlaCkwWhccoNo2v5p4yN+sAJNonajBM2D/xUjtvIH1cORvUBfL0gShGik
 NcRTYjZatO0QehOas6PsqApn2pJxjjuDzm5ZmhF+rE+1ogbr5saPamqjeDiqQszGE8Jt
 BJRdIh/fl0sCplHrPg+tdiqcHZl32y2PgHl+tVo9x4kzPE4jDXvnL+9hvBTkT7OumLjl
 gZPoF+RHmEUQEpbwxkwGT8vKmPi3Le7O5G9FqXxUkBHijExS+9ZCiLjwtk4C4ChmFpaN
 5XY99n1Hb1TIf6tjYYjK7xP6hMKo6tgXA+KqdXA/BcfyiMvW7iGdtb7FS7zNoWSVtJXj 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm1u80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47pUvo142397;
        Fri, 4 Dec 2020 07:56:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g37q72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B47uldh007288;
        Fri, 4 Dec 2020 07:56:47 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:47 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 8/8] vhost-scsi: hook vhost-scsi into vring set cpu support
Date:   Fri,  4 Dec 2020 01:56:33 -0600
Message-Id: <1607068593-16932-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This hooks vhost-scsi into the vring set cpu ioctl support by
just replacing it's existing workqueue use with the vhost
support.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8005a7f..29b139c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -101,8 +101,6 @@ struct vhost_scsi_cmd {
 	struct vhost_scsi_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
-	/* work item used for cmwq dispatch to vhost_scsi_submission_work() */
-	struct work_struct work;
 	/* Copy of the incoming SCSI command descriptor block (CDB) */
 	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
@@ -778,10 +776,8 @@ static int vhost_scsi_to_tcm_attr(int attr)
 	return TCM_SIMPLE_TAG;
 }
 
-static void vhost_scsi_submission_work(struct work_struct *work)
+static void vhost_scsi_target_submit(struct vhost_scsi_cmd *cmd)
 {
-	struct vhost_scsi_cmd *cmd =
-		container_of(work, struct vhost_scsi_cmd, work);
 	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
@@ -1128,14 +1124,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = vc.head;
-		/*
-		 * Dispatch cmd descriptor for cmwq execution in process
-		 * context provided by vhost_scsi_workqueue.  This also ensures
-		 * cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects.
-		 */
-		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
-		queue_work(vhost_scsi_workqueue, &cmd->work);
+		vhost_scsi_target_submit(cmd);
 		ret = 0;
 err:
 		/*
@@ -1811,6 +1800,15 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	return 0;
 }
 
+static struct workqueue_struct *vhost_scsi_get_workqueue(void)
+{
+	return vhost_scsi_workqueue;
+}
+
+static struct vhost_dev_ops vhost_scsi_dev_ops = {
+	.get_workqueue = vhost_scsi_get_workqueue,	
+};
+
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
 	struct vhost_scsi_virtqueue *svq;
@@ -1849,7 +1847,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		svq->vq.handle_kick = vhost_scsi_handle_kick;
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0, true, NULL);
+		       VHOST_SCSI_WEIGHT, 0, true, &vhost_scsi_dev_ops);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
@@ -2502,7 +2500,7 @@ static int __init vhost_scsi_init(void)
 	 * Use our own dedicated workqueue for submitting I/O into
 	 * target core to avoid contention within system_wq.
 	 */
-	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", 0, 0);
+	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", WQ_SYSFS, 0);
 	if (!vhost_scsi_workqueue)
 		goto out;
 
-- 
1.8.3.1

