Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A515CC2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 02:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B82D2076A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 02:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GrYDJ9nz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732712AbgDPCZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 22:25:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbgDPCZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2020 22:25:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03G2OJ89195854
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 02:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=hEQhncM1KM0DM7lGK8kRU3rQ9NjJO+Q5ht1S6rjIAmQ=;
 b=GrYDJ9nzwMLWvEuiyQHuj0qZAvUDSRC/d0sfYCi2zOSX/KR96tKruolZ0F7C8jurtPG9
 zAyg9TIxJj5WcAi2fdoS94obb27SeEnMAYvPVK7C5dUpFebLZbs1Co3N34yzMm9DFu3p
 MWJGbUI1nqFa0iP1yCcWyneE/YrZ1VUJhj9YuMRiLuxWSBfAFjEMWkVpfi03kNW7HknV
 cwmeoEIDqQgj0qCkn8jA20zqfRYZFsl+WBeLVRfgvdOrmCIBYB+B5Dwb2VqI29gxBZCN
 rJ44FdSsGOMMhsVzrxP0Oueb/y3sP2LmGYaGLXXEV5HwilIN2MlokxsJAb8QwwojGJxf +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30dn95psf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 02:25:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03G2N4pH042858
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 02:25:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30dyvg9y53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 02:25:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03G2PmZu027966
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 02:25:48 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Apr 2020 19:25:48 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] scsi: iscsi: register sysfs for iscsi workqueue
Date:   Thu, 16 Apr 2020 10:25:26 +0800
Message-Id: <20200416022526.21781-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=3
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Then users can set cpu affinity through "cpumask" for iscsi workqueues, so
as to get performance isolation.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/libiscsi.c             | 4 +++-
 drivers/scsi/scsi_transport_iscsi.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 70b99c0..588c68a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (xmit_can_sleep) {
 		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
 			"iscsi_q_%d", shost->host_no);
-		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
+		ihost->workq = alloc_ordered_workqueue("%s",
+				WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM,
+				ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfc726f..1370dd7 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4602,7 +4602,8 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
+	iscsi_eh_timer_workq = alloc_ordered_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
-- 
2.9.5

