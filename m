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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E09CC55178
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100EC2225F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bO7c9XSO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507552AbgJVAfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507540AbgJVAfR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0UV8i175090;
        Thu, 22 Oct 2020 00:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yGPxi7YyhiW3bDm7sHXKtH1cTG3pVGo9u48d+kL7jyw=;
 b=bO7c9XSOgLNqye9kuS8aBV/B6sAERNE8Ye419UtdjFksj66lruIpZ+bvVrQNlymAZ0F4
 bNgeiV6u/F9Qzdfm4JRTuSb3Q+24YNtQa1lpYS3hWixCHPq9JTGvEuRF7N4fOP1aPcUQ
 Vo3VMmnnIKK7vCZulwU7cUn4IfowLHUkmoxrqXOuEkYJhoS2yeimh2HSsBF+qU1i9LEt
 DsSJnvarFfTMp71DWAT0qpana9zB7mqhWAeSXD4h9YPhv+12gfoySaEvrwUKxzEj13D6
 sI+CeMihjplMMaNrzo4HThucGRyXZIbmBbjnqYXFmEThEzqEMj5r8gYr/++cWwZo8KMW Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ak16kp3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0TfDe186172;
        Thu, 22 Oct 2020 00:35:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 348ah090yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M0ZCce011322;
        Thu, 22 Oct 2020 00:35:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:11 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 02/17] vhost: remove work arg from vhost_work_flush
Date:   Wed, 21 Oct 2020 19:34:48 -0500
Message-Id: <1603326903-27052-3-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost_work_flush doesn't do anything with the work arg. This patch drops
it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
that the function flushes all the works in the dev and not just a
specific queue or work item.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/scsi.c  | 4 ++--
 drivers/vhost/vhost.c | 8 ++++----
 drivers/vhost/vhost.h | 2 +-
 drivers/vhost/vsock.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0ea78d0..86617bb 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1370,8 +1370,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	/* Flush both the vhost poll and vhost work */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
 		vhost_scsi_flush_vq(vs, i);
-	vhost_work_flush(&vs->dev, &vs->vs_completion_work);
-	vhost_work_flush(&vs->dev, &vs->vs_event_work);
+	vhost_work_dev_flush(&vs->dev);
+	vhost_work_dev_flush(&vs->dev);
 
 	/* Wait for all reqs issued before the flush to be finished */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5c835a2..6818f71 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,7 +231,7 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
+void vhost_work_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
 
@@ -243,13 +243,13 @@ void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
 		wait_for_completion(&flush.wait_event);
 	}
 }
-EXPORT_SYMBOL_GPL(vhost_work_flush);
+EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
 {
-	vhost_work_flush(poll->dev, &poll->work);
+	vhost_work_dev_flush(poll->dev);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
@@ -532,7 +532,7 @@ static int vhost_attach_cgroups(struct vhost_dev *dev)
 	attach.owner = current;
 	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
 	vhost_work_queue(dev, &attach.work);
-	vhost_work_flush(dev, &attach.work);
+	vhost_work_dev_flush(dev);
 	return attach.ret;
 }
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e016cd3..1365f33 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -46,7 +46,7 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
-void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
+void vhost_work_dev_flush(struct vhost_dev *dev);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 
 struct vhost_log {
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a483cec..f40205f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -652,7 +652,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
 		if (vsock->vqs[i].handle_kick)
 			vhost_poll_flush(&vsock->vqs[i].poll);
-	vhost_work_flush(&vsock->dev, &vsock->send_pkt_work);
+	vhost_work_dev_flush(&vsock->dev);
 }
 
 static void vhost_vsock_reset_orphans(struct sock *sk)
-- 
1.8.3.1

