Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FFEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C9B20724
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 03:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BWTHq9Ce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGADIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 23:08:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGADIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 23:08:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06138fAC144145;
        Wed, 1 Jul 2020 03:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=a7yNOUb+wQ/nGeOPYpyTwZ5QCHRtZL32gZTofQ8o/lc=;
 b=BWTHq9Cex1gPGAMIHRTZ/7XCtaQkt84p8DDI7kpO51xmlZp83zbR/A7uWTICOfCEpfj+
 4JuWxIVHV+0RD2m/+lCKL8IbglqXV9n04TSwSKzVu0YMI9FJKZuTH8pACnp+zhO6jLE1
 M0vACtwTL7zzZXFsEX/5dAxAjIEPPaObCnuCcyfBkIm2aFxhIhGJj95sMJ91Oc5Hwfod
 b9/Myo5iV5kB8xl3zsOQd2xkggp2yYFD+xrZBXDVk5DucuPEEh7ojxD9n24d/nTCsr7L
 O4w25EUI9DMSiVeJgcoQjijlQc8eMHtEo8UBL2HgSAOv/yLSZDSY+P7vUMX51dW01xV7 Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrn7uyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 03:08:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06138ddU158080;
        Wed, 1 Jul 2020 03:08:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31y52jq9uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 03:08:27 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06138PJf020765;
        Wed, 1 Jul 2020 03:08:26 GMT
Received: from localhost.localdomain (/183.246.145.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 03:08:24 +0000
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        lduncan@suse.com, michael.christie@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 1/2] scsi: iscsi: change back iscsi workqueue max_active argu to 1
Date:   Wed,  1 Jul 2020 11:07:44 +0800
Message-Id: <20200701030745.16897-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=3 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=3 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 3ce4196 (scsi: iscsi: Register sysfs for iscsi workqueue) enables
'cpumask' support for iscsi workqueues.

While there is a mistake in that commit, it's unnecessary to set
max_active = 2 since 'cpumask' can be modified when max_active = 1.

This patch change back max_active to 1 so as to keep the same behaviour as
before.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/libiscsi.c             | 2 +-
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e5a64d4..49c8a18 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2629,7 +2629,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 			"iscsi_q_%d", shost->host_no);
 		ihost->workq = alloc_workqueue("%s",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			2, ihost->workq_name);
+			1, ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4cc08e..7ae5024 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4760,7 +4760,7 @@ static __init int iscsi_transport_init(void)
 
 	iscsi_eh_timer_workq = alloc_workqueue("%s",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			2, "iscsi_eh");
+			1, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
-- 
2.9.5

