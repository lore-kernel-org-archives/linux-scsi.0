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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A85C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AAB2245D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oa6QMx+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894386AbgJVAfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894372AbgJVAf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0UJEO175045;
        Thu, 22 Oct 2020 00:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tD4l6hgSw3EK127NilJ16s5B/kUYm96URryFtF3SN7k=;
 b=Oa6QMx+PjD3Gw61zlfK4/RCOa20cRfjFMUGNbPHc8PS0pFEE523KO/7rLW45tZR1Gm26
 4gtDKk60dA4O2d1UqaG5O4+1myiWnU9kAZpkZIWcWj+MNef8TTWPOthRjc7KdCgtovHR
 6f5GquiaJ4kkyp8KLe0DZjuQjHmfRp2FXr1/3twx64+E0v3toHp1Ma+C5PWlhqLOf2RX
 /dCM//0DGIETeEXniGAgoAbu43abdDUa93m13gcYyQp2pKpeJVBw1C17sBq6govshEBr
 WSv7cJ2PX4iHTk3HaTjriabfNoVAn8EQUbbeQ4KCy+3VfP4FO6Wu0D24AiOVltB/hmB+ cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34ak16kp3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0U8iL177306;
        Thu, 22 Oct 2020 00:35:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6q15uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0ZLBE030031;
        Thu, 22 Oct 2020 00:35:21 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:20 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 17/17] vhost scsi: drop submission workqueue
Date:   Wed, 21 Oct 2020 19:35:03 -0500
Message-Id: <1603326903-27052-18-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can't control a VM's vhost scsi IO right now because the vhost worker
is added to the VM's blk cgroup, but the vhost worker thread actually
just passes the cmd to a vhost-scsi driver workqueue which ends up
submitting the cmd to the block layer.

This patch has us submit from the vhost worker thread and removes the
work queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4e91a90..3178bf54 100644
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
@@ -240,8 +238,6 @@ struct vhost_scsi_ctx {
 	struct iov_iter out_iter;
 };
 
-static struct workqueue_struct *vhost_scsi_workqueue;
-
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
 static DEFINE_MUTEX(vhost_scsi_mutex);
 static LIST_HEAD(vhost_scsi_list);
@@ -776,10 +772,8 @@ static int vhost_scsi_to_tcm_attr(int attr)
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
@@ -1126,14 +1120,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
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
@@ -2511,17 +2498,9 @@ static int __init vhost_scsi_init(void)
 		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 
-	/*
-	 * Use our own dedicated workqueue for submitting I/O into
-	 * target core to avoid contention within system_wq.
-	 */
-	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", 0, 0);
-	if (!vhost_scsi_workqueue)
-		goto out;
-
 	ret = vhost_scsi_register();
 	if (ret < 0)
-		goto out_destroy_workqueue;
+		goto out;
 
 	ret = target_register_template(&vhost_scsi_ops);
 	if (ret < 0)
@@ -2531,8 +2510,6 @@ static int __init vhost_scsi_init(void)
 
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
-out_destroy_workqueue:
-	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
@@ -2541,7 +2518,6 @@ static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
-- 
1.8.3.1

