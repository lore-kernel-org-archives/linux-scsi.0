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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C375C2BB40
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFEBD22583
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgLDH5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgLDH5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47ngf4001185;
        Fri, 4 Dec 2020 07:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fDnLWpMlpztj5NRSL42OKriPC/lKsig5CdfRImgSJc4=;
 b=V18GHBvM7io7ZHzZamqsPyYIx4rjQZQfT72tf5Lcy6hN1qBjbf33iCE+e7/MCaeLrcUi
 SfONV0FLzgWy5jXmy7R7treWom3cBpyzRjdclWZ7m18B8nSX3Vno/dTpQvGfgY387HN6
 9UofyPCoKjW3cGHxBHZsK1rOjkbLUfqjZBcL8SRvTFTDQw1h7wAokkcxSbcU9QoQGsNW
 Vw7BTC87ChLaIdT1OiE/VXB1/xUHQ2AXldLF0juwlo/fiwNWaH0qiicWWtowVXHBAyXc
 fV2tIEPaEqDjmBaXAKGwEJxlWgKdbV3Hs1Ofs8yQiJN1/eTcznGs4E+mvpWTpni5VKfk 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyr1wu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47pThE142374;
        Fri, 4 Dec 2020 07:56:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540g37q5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B47ukQ6004196;
        Fri, 4 Dec 2020 07:56:46 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:46 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 7/8] vhost, vhost-scsi: flush IO vqs then send TMF rsp
Date:   Fri,  4 Dec 2020 01:56:32 -0600
Message-Id: <1607068593-16932-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
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
 drivers/vhost/scsi.c  | 20 ++++++++++++++++++--
 drivers/vhost/vhost.c |  9 +++++++++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 08bc513..8005a7f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1179,12 +1179,28 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 {
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
+	struct vhost_virtqueue *vq;
+	unsigned int cpu;
 	int resp_code;
+	int i;
 
-	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
+	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE) {
+		/*
+		 * When processing a TMF, lio completes the cmds then the
+		 * TMF, so with one worker the TMF always completes after
+		 * cmds. For multiple worker support, we must flush every
+		 * worker that runs on a different cpu than the EVT vq.
+		 */
+		cpu = tmf->vhost->vqs[VHOST_SCSI_VQ_CTL].vq.cpu;
+		for (i = VHOST_SCSI_VQ_IO; i < tmf->vhost->dev.nvqs; i++) {
+			vq = &tmf->vhost->vqs[i].vq;
+			if (cpu != vq->cpu)
+				vhost_vq_work_flush(vq);
+		}
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f425d0f..4aae504 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -250,6 +250,15 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	if (vq->cpu != -1)
+		flush_work(&vq->work);
+	else
+		vhost_work_dev_flush(vq->dev);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 28ff4a2..2d306f8 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -40,6 +40,7 @@ struct vhost_poll {
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev,
-- 
1.8.3.1

