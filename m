Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA2DC352BE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 11:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F649208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 11:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TSHvFyVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgDQLQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 07:16:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729962AbgDQLQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 07:16:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HBEETF067354
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 11:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=l19If+Fcqlz72x/DlTiTFUIqQkVlQKqI8/7SK45lIL8=;
 b=TSHvFyVdmF4GXj8+L/sRVwZHVn8WK8GgJUm372PVFfNndCW0Mk5z38kLzoNIq2xmeR9k
 w3IStE+7NPi4SLv64vCctScaGkpANV4A4DpIeIX6mdlwtLmPvoB0JWBJGrm9AgtCcNMB
 9XPkCKlQ/NxuAFnJSnvIyBT+8qO29M56H0VCTfnftLl3tyOgskrI/ApGMViHPOT/daCf
 7wCgEJJxjbSn8YyOjkDtBXnynYRZsBozRuzV2jIeVYq970tFLXithkzN2OcqMFC0ElFB
 aR9HS0y8YqILL7vGf6877kCRAjgtDozUJF0/ngBoZqJHiux6PG7wsrlJX0CtxjVBuSjD oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30dn95xj6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 11:16:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HBDKei021650
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 11:16:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30dn91by8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 11:16:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HBGEk5004711
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 11:16:14 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 04:16:14 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
Date:   Fri, 17 Apr 2020 19:15:45 +0800
Message-Id: <20200417111545.30437-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=3 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=3
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Then users can set cpu affinity through "cpumask" for iscsi workqueues, so
as to get performance isolation.

This patch changes the max number of active worker form 1 to 2,
since ordered workqueue wont' be allowed to change "cpumask".

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/libiscsi.c             | 4 +++-
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 70b99c0..adf9bb4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (xmit_can_sleep) {
 		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
 			"iscsi_q_%d", shost->host_no);
-		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
+		ihost->workq = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfc726f..bdbc4a2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4602,7 +4602,9 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
+	iscsi_eh_timer_workq = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
-- 
2.9.5

