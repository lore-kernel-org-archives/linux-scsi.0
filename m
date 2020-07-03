Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE0CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D05208FE
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JjjTKpLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgGCFRA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:17:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgGCFRA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:17:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0635D0nS190615;
        Fri, 3 Jul 2020 05:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=arddawxe/NarPsuArRlIV1nbKL4dlA3Ya1GT5IfE0IQ=;
 b=JjjTKpLpwZEvubDiFa5UmbuNbu0UEJ9tP3bP+8Lyw0FkUAwiPSeIIiaOZjoOeg9xTAyA
 iJp6M5NwafJtdK8b6zN0VMHPSWA66BKdpNGsf2AvkwYN9pJ00F7T5Q2a0BJqXevwW//P
 CRThfLAAgx0PZFBoycti3XxNubcIo+/DOu9fmqUOp8hfyLBvQAVQAt6sUhsPHecgZ7+Q
 X/o/ubCn9dfsHQeVG+7BLhu1Zdk1q3kBMDuNF6sddlEQVYQ8jVA9/NAAVi4o6NP5PFvS
 NAzkqE/iXsWzLi5+xNwfNsPv3NElbvKANHvjxdGMRc/izhMmTC8E3Dk8T4mV8ffY17KT Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1e8ppc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 05:16:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0635CtQM017097;
        Fri, 3 Jul 2020 05:16:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52ns3ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 05:16:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0635GqAG003089;
        Fri, 3 Jul 2020 05:16:52 GMT
Received: from localhost.localdomain (/183.246.145.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 05:16:51 +0000
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] scsi: iscsi: register sysfs for workqueue iscsi_destroy
Date:   Fri,  3 Jul 2020 13:16:03 +0800
Message-Id: <20200703051603.1473-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Register sysfs for workqueue iscsi_destroy, so that users can set cpu affinity
through "cpumask" for this workqueue to get better isolation in cloud
multi-tenant scenario.

This patch unfolded create_singlethread_workqueue(), added WQ_SYSFS and drop
__WQ_ORDERED_EXPLICIT since __WQ_ORDERED_EXPLICIT workqueue isn't allowed to
change "cpumask".

Suggested-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7ae5024..aa8d4a3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4766,7 +4766,9 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
-	iscsi_destroy_workq = create_singlethread_workqueue("iscsi_destroy");
+	iscsi_destroy_workq = alloc_workqueue("%s",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			1, "iscsi_destroy");
 	if (!iscsi_destroy_workq) {
 		err = -ENOMEM;
 		goto destroy_wq;
-- 
2.9.5

