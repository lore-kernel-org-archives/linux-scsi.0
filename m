Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFAFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 07:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE8420679
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 07:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ywLZO/YD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgFCHKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 03:10:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCHKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 03:10:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05372UIE025996
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2020 07:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=/vRbDhMqsyCtHtiuhEn0HwHmMOF3TeSvVKf0ajs2kaM=;
 b=ywLZO/YDJLXffST4rkkbwTMQAAtezFxv6Js6g3mxTm54yRsCpdog1DIyHs5toaewpemx
 3XfQ+WGJ80nrrp8lOJ+ouENBKpBpcDs04223YklJ3au/lIwau9H+juST7YAfDZZim8sP
 54qBuPDBdCG7UULvcDJmwUlQHLHjh2tj1+OZc/g7EHBeB6/eqegD+AmaLueciufHwYVq
 KG3TCaxvG/wYjFPYQP0wcWNL1l4bVOfZiTklIzdwopfp3c7Mp+98o05g05xcrum1LQO4
 SDA4hGl0PrRm7J4LBryQlTnCc8+Flr5NJul/AL7lSvfj7mOFP+WmRILJ3xEOSZKKwrM7 JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem7hum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2020 07:10:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053743ok079842
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2020 07:08:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25r9tmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2020 07:08:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05378d9l008281
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2020 07:08:39 GMT
Received: from localhost.localdomain (/183.246.144.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 00:08:39 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] scsi: register sysfs for scsi workqueue
Date:   Wed,  3 Jun 2020 15:06:16 +0800
Message-Id: <20200603070616.29629-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030055
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030055
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch enable setting cpu affinity through "cpumask" for scsi workqueues
(scsi_wq_* and scsi_tmf_*), so as to get better isolation.

The max number of active worker was changed form 1 to 2, since "cpumask" of
ordered workqueue isn't allowed to change.

__WQ_LEGACY was left because of
23d11a5(workqueue: skip flush dependency checks for legacy workqueues)

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/hosts.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e4..aa48142 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -272,8 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (shost->transportt->create_work_queue) {
 		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
 			 "scsi_wq_%d", shost->host_no);
-		shost->work_q = create_singlethread_workqueue(
-					shost->work_q_name);
+		shost->work_q = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, shost->work_q_name);
+
 		if (!shost->work_q) {
 			error = -EINVAL;
 			goto out_free_shost_data;
@@ -487,8 +489,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
-					    WQ_UNBOUND | WQ_MEM_RECLAIM,
-					   1, shost->host_no);
+			WQ_SYSFS | WQ_UNBOUND | WQ_MEM_RECLAIM, 2, shost->host_no);
 	if (!shost->tmf_work_q) {
 		shost_printk(KERN_WARNING, shost,
 			     "failed to create tmf workq\n");
-- 
2.9.5

