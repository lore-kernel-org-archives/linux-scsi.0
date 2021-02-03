Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047A7C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B004E64DF8
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBCBfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:35:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBCBfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:35:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131XXYF192548;
        Wed, 3 Feb 2021 01:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=ntd5RyymaltuRKm7WXZmH1W8CEnVQy5NjZ3SRSkRH3VR4zXL/ktvupzST1VCHN09tVR0
 Dl0Qf9awx1hVGkag4SDMEJ70zZTEaN96wfAOEGbVxqv6sAw0oS25g7xQ4vO/NtFKu015
 QURy380R5HzsI+Mem2PC/uKIX2gH/blXljEwTaB/2pZMEpXuLPtRnw9zLrNjXclzTs3x
 8iUnPf/uUxr3EAZxKtzRvOmoXUYhFjw09m+r22Ho2XKVKItKLzbMik8Ops1gvhjvtVzk
 76hhijoiEb2KpQs4mwc9aDcdtNEJVl4m1N3KUrEW3AHG2KsGY6DtrCIiAO6fSXvPU39X IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36cvyawtym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QD2M045065;
        Wed, 3 Feb 2021 01:34:12 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2056.outbound.protection.outlook.com [104.47.44.56])
        by userp3020.oracle.com with ESMTP id 36dh7sfwqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnIDVltC85clcyTxAhcygSR6+LIvDymHhqvtBE0urDVeWoSPARN5AibjO9biymTRsepmqtwuMHrQWq2RxU/+ulzszo51AJ5IMrtIbjOA5LAYnuovh4rYAMNxSOy2CRvgxoWdIQCBl0BFxrw0yjx6Il/JUmdCbkyUkKETlufu/RiEP0UtGRkpIA39Xf5ii3AG6FVutfVzh+TBRjCVj/X26ReGBWuyS33Dyx/qgFdn6QTGsspdAorXWseXjjXjbRH9rbuDZhy1Km5mO88W+/aStJ71F8jJi0luBHbcUcagFVreGOMRIvYiAoH1OzGNTO8lKXJ3gR8oIas/oDqWjksJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=Q/bXEl979B/8mY4+sStT5pqHR5YGRaO1FltKFzLsrt9lROiLs/EyY9aVnMIbQLilhQtPEya+lFaIZrBv2i0YWlWQ9XQ4dtcgMaS1s3bn0f9xqKQFvOI4puH7okvnllsyBNBj86S2D3B8DgVYJXaJR05ZJJG5vH8Kxh8ulCHo/JvNcD2VOBj8eF3Slv5USz6gAWT54R1cJ2vC+NdPlyvzP/1HMAWp1GcVNPh20TkTqghXbiFFqY/dCNL/KHEBly0kRNy/aTft1zlhoJsh3tPXBwMn4QkoSgGqQMcGjWHaJcQfn9j/WgMvzSsXJ/Yz8LygXX/Ld52Jo/aIEp4eyTcRhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=LESmGIcY63tTszEa9eZElnhFYlc/OF9F6UOrdN5OWGfFg0mGVAaaf/k04rs3/v4pwYemK59q1mEqHt65Abrcp2sG+n0AhcZTA+l+h1By375j3S6DEo00UExUydh84xF+affSC2qjLNTNCiLL2i2UWXc9OSRxJmicnFgmcw1nLWU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:10 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/9] libiscsi: add helper to calc max scsi cmds per session
Date:   Tue,  2 Feb 2021 19:33:52 -0600
Message-Id: <20210203013356.11177-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116f556a-381c-4d7b-90de-08d8c7e3ce0e
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5320BEDA643612EED5961A1FF1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSe8MyGjgVBDKDaReW6Kxq1Fv2w/ueeLGGTkenErRPBkFrBponBM01MsFENyqga2HcnN7sAybURtmBroUQb2GUap3Ikpofuo1a183L508jDyiKlu/kX5eSdfZ5I5VPq51xfbLjZ71Vne1xIpyd004R/ja01HKui5V7uxW5ICM5fhYrI3WbowmYeikEFn8J50NV9+HkqDOQsI8oHUQC1sTHccr9CMgnaSpcaxFlMffphhAdbCvQjYXns6RfZUZC8cJbtqo8pTsh58ERrM342NgVoha7xq6kjYiMWrCH/LslFUt029qWHP3ndLcowwqgWqyx8A+zZ2WdK9iBR4GMkPQvqXgwIhrLfEZ108WtxOS03vLWf7lDinO7/ZYmLsqOOKQYJO122n833JDih2jI49u+9yLvntMDvMNBNv1+xFOAVsmUiM9ve8BZDrJl7odksi4zLWLTGfadpHBYBi656bNZGRgBCA/IasLbbSgNPl2AuakWPqc96iliHeNb7Yx+dWKGs9xFLctxXE7PhsRA+QcYBK/e9ALLeIxHC5X3AJ28tbOsmFl5gS2338ai+/BzwomJibbouoH+445pPmOCOIOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SIA+6Lr3Zk8YH3k05aowXPaEd+hxyXVk6EQuG+Kcg4+FV4Un39iWiGFc2p+T?=
 =?us-ascii?Q?A5VgyWW0ST/MvXI7vmr3REaUH7cqiEBhFeRO3IXK7LCa18FJiQOx2aIFeOHc?=
 =?us-ascii?Q?aoOQaXhdBBJsj5esvWWrUdLazx5Co7lalxVL1r09C67wSXh1RgpvjdLNDQmt?=
 =?us-ascii?Q?cEQsEEu1trP2AV+lsH8Eobfb8KCF1f7S+n0giR3yUtDHPEBaSC72nEOQ+gyt?=
 =?us-ascii?Q?iRqjxxRv8J4S4rfVDdrhml0VPNXgXIqfXG6XzPxZ1FkZsSSpUFGB+NS7W9Z7?=
 =?us-ascii?Q?Fh0WBkGLv21Hprx3znQid2zsgOIBMTUfUhipY4sRMpLBes+/drxiU6ygzRyV?=
 =?us-ascii?Q?x6qet/L4lmRteaCozh3cgSGFh9aBGG8Y91OkjPpAnyGkEhFUOok8g3VuS+Nh?=
 =?us-ascii?Q?B136D0PDo50J/iFmx79R+vrXB+NedkxfGMpVNonSZX0o6PGqwxXt7f3iZMQe?=
 =?us-ascii?Q?hvWdkIg1A0aiNo9z8kf23u+kgxpgW6PQp++7y5tLIB3lX4sYEiKLnZ34OKWn?=
 =?us-ascii?Q?/3rJKx+qHxtXRhMqOBWpDyRrKsmWXWSdLaLk7hAygBe4oC25N+ySe43eyaFU?=
 =?us-ascii?Q?vgDCMyBvNnGLZ5SKXATw3lct2ezhtFmoyHgRgFEF37nj8gAHfU8XshfI19RY?=
 =?us-ascii?Q?rXui/3Q8FHj66ghcpuP1F8GxaI1/IOuKUj6YPnXbp81lpqpcO4YAilcJNrGv?=
 =?us-ascii?Q?r6GnxQWBMsQu1KMcjpCVTQShS6r7wJ1f6WSXpr0n2CBqhwmetoMyjzXgaSzg?=
 =?us-ascii?Q?WbxbUR6Nnlmg4c+VIZhPkiuzUekk6komDj+3Unh7cQUwTOJS58i90yUJe89U?=
 =?us-ascii?Q?lm4PdOoZ9atQIxlc7IAdJtOqhsruvDWo2uk+EzahDkWHxOnR55dcLcGyZNYd?=
 =?us-ascii?Q?aKhNylDRZprU6Sv2Ef9Q+enKHX0gp9o9sARiK/89BcxL7FGqnhM0Tm6IzCm1?=
 =?us-ascii?Q?/P1ZaScsGRmV6h40JoiuPyPxvVdjjWdmP3GjCTgurb/GcXEI/8dgYsIy3VLA?=
 =?us-ascii?Q?ZJwA8jqlwhvxXn4g+Ps6GAr3iUGTl1zcc7W9LZ8JMDW8xnuiUm1Ugk6V9RTe?=
 =?us-ascii?Q?3Ny+WQwB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116f556a-381c-4d7b-90de-08d8c7e3ce0e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:10.3109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWAjfbuy9wMpwCbmMFY/gZG6UUsfpN7YoDmx0RokHRFbdgifyDYwYPl8uZE9nfrghb17biRv51uem1RCoHjLvQn7C41twTn94mLBwYYXzeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch just breaks out the code that calculates the number
of scsi cmds that will be used for a scsi session. It also adds
a check that we don't go over the host's can_queue value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 86 ++++++++++++++++++++++++++---------------
 include/scsi/libiscsi.h |  2 +
 2 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b271d3accd2a..f64e2077754c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2648,6 +2648,56 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
+int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+				 uint16_t requested_cmds_max)
+{
+	int scsi_cmds, total_cmds = requested_cmds_max;
+
+check:
+	if (!total_cmds)
+		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
+	/*
+	 * The iscsi layer needs some tasks for nop handling and tmfs,
+	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
+	 * + 1 command for scsi IO.
+	 */
+	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
+		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+		return -EINVAL;
+	}
+
+	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
+		printk(KERN_INFO "iscsi: invalid max cmds of %d. Must be a power of 2 less than or equal to %d. Using %d.\n",
+		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX,
+		       ISCSI_TOTAL_CMDS_MAX);
+		total_cmds = ISCSI_TOTAL_CMDS_MAX;
+	}
+
+	if (!is_power_of_2(total_cmds)) {
+		total_cmds = rounddown_pow_of_two(total_cmds);
+		if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+			printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2 greater than %d.\n", requested_cmds_max, ISCSI_TOTAL_CMDS_MIN);
+			return -EINVAL;
+		}
+
+		printk(KERN_INFO "iscsi: invalid max cmds %d. Must be a power of 2. Rounding max cmds down to %d.\n",
+		       requested_cmds_max, total_cmds);
+	}
+
+	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
+	if (shost->can_queue && scsi_cmds > shost->can_queue) {
+		total_cmds = shost->can_queue;
+
+		printk(KERN_INFO "iscsi: requested max cmds %u is higher than driver limit. Using driver limit %u\n",
+		       requested_cmds_max, shost->can_queue);
+		goto check;
+	}
+
+	return scsi_cmds;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
+
 /**
  * iscsi_host_add - add host to system
  * @shost: scsi host
@@ -2801,7 +2851,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	int cmd_i, scsi_cmds;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2812,37 +2862,9 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	ihost->num_sessions++;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	if (!total_cmds)
-		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
-	/*
-	 * The iscsi layer needs some tasks for nop handling and tmfs,
-	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
-	 * + 1 command for scsi IO.
-	 */
-	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of two that is at least %d.\n",
-		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+	scsi_cmds = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (scsi_cmds < 0)
 		goto dec_session_count;
-	}
-
-	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2 less than or equal to %d.\n",
-		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
-		total_cmds = ISCSI_TOTAL_CMDS_MAX;
-	}
-
-	if (!is_power_of_2(total_cmds)) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2.\n", total_cmds);
-		total_cmds = rounddown_pow_of_two(total_cmds);
-		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
-			goto dec_session_count;
-		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
-		       total_cmds);
-	}
-	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session) +
@@ -2858,7 +2880,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
-	session->cmds_max = total_cmds;
+	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 44a9554aea62..02f966e9358f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -395,6 +395,8 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
+extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+					uint16_t requested_cmds_max);
 
 /*
  * session management
-- 
2.25.1

