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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F98AC56202
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFC022201
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R5a1zoi5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgKLXTm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:19:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:19:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACN9uH8109270;
        Thu, 12 Nov 2020 23:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=o28HMjxZvdjabwbgesnkp8UHr7OdXDYF6AOdSGODfhc=;
 b=R5a1zoi5WqCDkNUW4IrS4unkWWDdWKT5cQUHFwbNY0nwlz8g3Pd0x58d1ZQvrkh5Uzzj
 ScHPDBF0JYG6y9l7msnHddMyMr2h8yiVNmeD3cQ4RQPCbk/PDmWgDl28wvan3AICsJsm
 vMpzc4VC0F8kqX/kfIjiHcttrT2lMyWKXZu5/S/6dLsuW4oUbQmgmk+ZAaKzuBkhJENf
 792Q7NO02CpKThAimJMZtW5nuWDFRNQZlRJcsbHmBH8Ra65NnW9gBu6SqEoJz4v9trF4
 4qgkCV4R1zw4zgGxwuA0EBRq1GBQaj5F/JiBynCMiJpnxTPOXYjJuwmAX5FQgueXHOAQ UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72exauj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNB0vu027435;
        Thu, 12 Nov 2020 23:19:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g3tsem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACNJS85026839;
        Thu, 12 Nov 2020 23:19:29 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:28 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 07/10] vhost, vhost-scsi: flush IO vqs then send TMF rsp
Date:   Thu, 12 Nov 2020 17:19:07 -0600
Message-Id: <1605223150-10888-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first which
calls vhost_scsi_release_cmd to add them to the work queue.

When the next patch adds multiple worker support, the worker threads
could still be sending their responses when the tmf's work is run.
So this patch has vhost-scsi flush the IO vqs on other worker threads
before we send the tmf response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c  | 16 ++++++++++++++--
 drivers/vhost/vhost.c |  6 ++++++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 2bbe1a8..612359d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1178,11 +1178,23 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
 	int resp_code;
+	int i;
+
+	if (tmf->se_cmd.se_tmr_req->response == TMR_FUNCTION_COMPLETE) {
+		/*
+		 * When processing a TMF, lio completes the cmds then the
+		 * TMF, so with one worker the TMF always completes after
+		 * cmds. For multiple worker support, we must flush the
+		 * IO vqs that do not share a worker with the ctl vq (vqs
+		 * 3 and up) to make sure they have completed their cmds.
+		 */
+		for (i = 1; i < tmf->vhost->dev.num_workers; i++)
+			vhost_vq_work_flush(&tmf->vhost->vqs[i + VHOST_SCSI_VQ_IO].vq);
 
-	if (tmf->se_cmd.se_tmr_req->response == TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9eeb8c7..6a6abfc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -278,6 +278,12 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	vhost_work_flush_on(vq->dev, vq->worker_id);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 232c5f9..0837133 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -46,6 +46,7 @@ struct vhost_poll {
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 int vhost_vq_worker_add(struct vhost_dev *dev, struct vhost_virtqueue *vq);
 void vhost_vq_worker_remove(struct vhost_dev *dev, struct vhost_virtqueue *vq);
-- 
1.8.3.1

