Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD0AC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4812F20747
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gcFsKcwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgFKKKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:10:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgFKKKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 06:10:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BA6rAh013287;
        Thu, 11 Jun 2020 10:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=IwBCM+hJeskaz3TsvUhPt5M+TeyH9rZ0QcVjuHy3CzI=;
 b=gcFsKcwModl8fFbU4ceDOW1iHkSpdpYA3SG5gmlxt6QGHnE7EKgNkdgxZUcWzFRX0XfR
 omRzdoRflJUgx2LObI4jNWIjLStXJyQHnikOx3yEzcLcMJwUDao8Xw2mNHEPHfoIwl+e
 r+KgN4tedJ9Oyf43MU4g5UhVLhOs2wikEktqZbRz74N5x8RQNUQCxZs07wByEEvOI6Hq
 X5Yx9kh5B6cP/KGfb03j47B27FbQep1eWSdriuwh7gCQAh20T/BHhN5esSiBOecF6mVP
 g4PwuF9z9Pk84yNDMfxKR5enQcjiOzV+3LkgG77G8JSP3L6ezSsiv5i0wWI3Ogjz/zLn Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31jepp0vbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Jun 2020 10:10:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BA7lCL056640;
        Thu, 11 Jun 2020 10:10:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn319jv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jun 2020 10:10:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05BAANGK016532;
        Thu, 11 Jun 2020 10:10:23 GMT
Received: from localhost.localdomain (/183.246.144.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 03:10:21 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     tj@kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        lduncan@suse.com, michael.christie@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 2/2] scsi: register sysfs for scsi/iscsi workqueues
Date:   Thu, 11 Jun 2020 18:07:17 +0800
Message-Id: <20200611100717.27506-2-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200611100717.27506-1-bob.liu@oracle.com>
References: <20200611100717.27506-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9648 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9648 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=3
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006110078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch enable setting cpu affinity through "cpumask" for below
scsi/iscsi workqueues, so as to get better isolation.
- scsi_wq_*
- scsi_tmf_*
- iscsi_q_xx
- iscsi_eh

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/hosts.c                | 4 ++--
 drivers/scsi/libiscsi.c             | 2 +-
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e4..4b9f80d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -272,7 +272,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (shost->transportt->create_work_queue) {
 		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
 			 "scsi_wq_%d", shost->host_no);
-		shost->work_q = create_singlethread_workqueue(
+		shost->work_q = create_singlethread_workqueue_noorder(
 					shost->work_q_name);
 		if (!shost->work_q) {
 			error = -EINVAL;
@@ -487,7 +487,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
-					    WQ_UNBOUND | WQ_MEM_RECLAIM,
+				WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS | __WQ_ORDERED_DISABLE,
 					   1, shost->host_no);
 	if (!shost->tmf_work_q) {
 		shost_printk(KERN_WARNING, shost,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 70b99c0..6808cf3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2627,7 +2627,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (xmit_can_sleep) {
 		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
 			"iscsi_q_%d", shost->host_no);
-		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
+		ihost->workq = create_singlethread_workqueue_noorder(ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfc726f..d07a0e4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4602,7 +4602,7 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
+	iscsi_eh_timer_workq = create_singlethread_workqueue_noorder("iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
-- 
2.9.5

