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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5078C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5007B2080D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r2ECPbcH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbgKDW1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 17:27:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbgKDW1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 17:27:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MOx1s178643;
        Wed, 4 Nov 2020 22:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vYxi6lT6xaHqbmsZFKPzIoOdBYzwh23N3vY9/2xDKfs=;
 b=r2ECPbcHQIjQBwm2utj9UAHXMhSN2hg0M02n4LSHJtsl9su8U/eYQOgJdS4p5/T60DQP
 Rhba4sZCEck6thhvpy3xMDT8DEaGGmAS2hQFtOGfuk432VdS31E+FQmZ11m4hqUfx4P5
 TNR5v06wlvwWxJtiul6I6h7fvQgOJxop8He0u20Tf/kPMGdVPQS98KamOjn0Dob3Slp5
 IAxQ7tdULP4p/BScmejYWlr0kN9GoLRZ/z0HOlZfI7h2UeFhdurV6ka1aG+l52eKfjRI
 tOyJ8Io27z44V+e48+F+cwhlTvKoQj1A5G5ubyB4/+HShAKxa/4xS9Y5zGRSvuW+AgrF Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34hhw2s6pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 22:26:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MJnoK082929;
        Wed, 4 Nov 2020 22:26:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34hvryj74e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 22:26:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4MQuC0011496;
        Wed, 4 Nov 2020 22:26:56 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 14:26:56 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 07/11] vhost scsi: support delayed IO vq creation
Date:   Wed,  4 Nov 2020 16:26:40 -0600
Message-Id: <1604528804-2878-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
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
index 5b3720e..24c345c 100644
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
-	r = vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_MAX_VQ,
-			   UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL);
+
+	/*
+	 * We will always need the ctl, evt and at least 1 IO vq. Create more
+	 * IO vqs if userspace requests them.
+	 */
+	r = vhost_dev_init(&vs->dev, vqs, 3, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL);
 	if (r)
 		goto err_dev_init;
 
-- 
1.8.3.1

