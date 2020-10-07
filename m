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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59895C41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7632087D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yrf0AQm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgJGUz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgJGUz0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KnSF6038252;
        Wed, 7 Oct 2020 20:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PoAgr+goPsYoyHGUHDIojY7cz7/Vh87XeLNAz04rgyI=;
 b=Yrf0AQm+BGYxk4yyJFDTU4MwqG3c2nP2qPhYmV8avMClxF53FopATqC80KnIJKnvtdJa
 uMudyj6+Q1ZD/DKaH/PMS044N24BuhM3KMWuUPVuHMq+wVqTdZvfvZx/lF9gmwzvXtax
 OWOocPZJmkJyjJiwifu4pcKKO+43in2EReyIc7DIeYJoN0tczyFmXh+2z3f31K2EWnhA
 I1+T582Tja9mH8u9DIaNrB6Pm4FF9glus09V+vDUmKE2ly3oU+eZtUzeBgou+LLKJWL0
 0XF1jfXoj2t+QBg3Yl8KCvbP8GtHwmp74ktHbRY8nV5ct0isFWK9nk80hwFy5wI29kP6 Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxn475g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KpMjn166497;
        Wed, 7 Oct 2020 20:55:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vpyuxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097KtKcb005642;
        Wed, 7 Oct 2020 20:55:20 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:20 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 07/16] vhost scsi: support delayed IO vq creation
Date:   Wed,  7 Oct 2020 15:54:52 -0500
Message-Id: <1602104101-5592-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Each vhost-scsi device will need a evt and ctl queue, but the number
of IO queues depends on whatever the user has configured in userspace.
This patch has vhost-scsi create the evt, ctl and one IO vq at device
open time. We then create the other IO vqs when userspace starts to
set them up. We still waste some mem on the vq and scsi vq structs,
but we don't waste mem on iovec related arrays and for later patches
we know which queues are used by the dev->nvqs value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d412f1..ab1b656 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1401,7 +1401,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
-	for (index = 0; index < vs->dev.nvqs; ++index) {
+	for (index = 0; index < vs->dev.max_nvqs; ++index) {
 		/* Verify that ring has been setup correctly. */
 		if (!vhost_vq_access_ok(&vs->vqs[index].vq)) {
 			ret = -EFAULT;
@@ -1464,6 +1464,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		       sizeof(vs->vs_vhost_wwpn));
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (!vq->initialized)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -1503,7 +1506,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
-	for (index = 0; index < vs->dev.nvqs; ++index) {
+	for (index = 0; index < vs->dev.max_nvqs; ++index) {
 		if (!vhost_vq_access_ok(&vs->vqs[index].vq)) {
 			ret = -EFAULT;
 			goto err_dev;
@@ -1551,6 +1554,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	if (match) {
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (!vq->initialized)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, NULL);
 			mutex_unlock(&vq->mutex);
@@ -1632,8 +1638,13 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_MAX_VQ,
-			   UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL))
+
+	/*
+	 * We will always need the ctl, evt and at least 1 IO vq. Create more
+	 * IO vqs if userspace requests them.
+	 */
+	if (vhost_dev_init(&vs->dev, vqs, 3, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL))
 		goto err_dev_init;
 
 	vhost_scsi_init_inflight(vs, NULL);
-- 
1.8.3.1

