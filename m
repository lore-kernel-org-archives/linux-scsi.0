Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA5DC4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B176E64DEC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhBQUeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:34:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhBQUbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKP9xO148121;
        Wed, 17 Feb 2021 20:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/eg8QJ5aV6hrGRyZb+SnIk9I6c1q8Jhcy+lH68YhITI=;
 b=k0huCKYr2LdPu5bI8k4wpff5HQg7jYAHY0NxnM24NjYnruz+cGxmeEUe+jeLJ0X664Xj
 LShiFAtBmVz8PCsF9+be60++cKMEY5KGxqzwZ0tUcy1DQMoDPCxRw2vuRQYiPIninUA5
 JqUnxb6JU4WdXFcBwNkU3IKBWMheUCKpEBiVzDMdWH2/EBEPgheZ6OoYMWR0Am9xzWve
 Y++rQF0oKg54bhDcBBvrVLCCPdK/qOcjs0LDm1QM2MOI3k0RzZ7AM7kXoF6bsvWSlcuK
 FPT1XtpmppRaPXrAipLu9WmWe9Jo4JkR1ckNf8nm+3ynb7ZpuahcpGauzBgLzNXcbHsh 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnkpkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPcde113504;
        Wed, 17 Feb 2021 20:28:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 36prhtb5ug-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMKqstN4Xl/X9WK0qwICO32C5mRoikF4hmvmoReo99JfKMAKljXokU88EJs5V/DAjq3CnJRPmxHpGhnKPivqYccmvvr3zv6k3IMbfNkXodBO+tB3GGOXUimAkpeKudwHNr4hTzxZpvC0SV2D3fWnoYGPwI4YMM+26dxSIHZU0uBuKa5hFExtd3m9JTLOOHRdUkA9RpFYNRhgPbckMFK3YRtA9SZ4ZQ0omGVSb8qm8BkJwr/TBBjZooTSu7rVjp4Bw1Ovkdr/IrpDVcdej3XDfkQxWOuqUrfHYpU7sy36uKpiEGvz194WPkZi4/7m+jKgoLx/IwXZ9jBTe0dL2MOfCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eg8QJ5aV6hrGRyZb+SnIk9I6c1q8Jhcy+lH68YhITI=;
 b=itwKHfJgYKIepmPDMrH7gSckUDYACMea3WjOKV/Mccj0cfajGlj4ntgjGgw0+9LM6pGEfGVtdZ123bdAgJ5E4M6XElLBaIqceDidn4+0k+5vchP9ddUx5C9e52Iowc42OxjJ3L8LwnHWbjm9IFIxYYUMK070G/QINZg/Ez1ZULMVvkXO9mOmhED3n2QdmrBMcI2bLDKExUnM3pMySQ3QvhsN/1bPVQr97NX60qktWYHdkRxRsQ6OhbHXe7VYQ4XcA0L+7/d+tw8Kav1yuKpwlpx0O7slgbRU3xrk8aa+hItQ2esGHvwTY8kRzow1TroXJJh3IV7pctjgVG2h6bYndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eg8QJ5aV6hrGRyZb+SnIk9I6c1q8Jhcy+lH68YhITI=;
 b=Hfmz1ZXOvJV6DLVaZXPNh8u0OCZFOVaXKzCz4N+0iXMgJkWCAfrpJd4bn8SqSXDp7yo8AMXqVddmLNLAKvBHIJJFWtVFGkBRS4yHRyN8CikPCciGEXJIp6oA3iSLB2t50OvR7Vg1vumuGCDk5O5/ywJPR/jSS4HyBbW7Y1JHrPg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/25] tcm loop: use lio wq cmd submission helper
Date:   Wed, 17 Feb 2021 14:28:05 -0600
Message-Id: <20210217202811.5575-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bb81c92-dfd4-4ed0-36cb-08d8d382a6a2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3940CF5615ACA748D9640269F1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQj2KOReF3PmnVXAtl5z9ZKtLCnNFum3H08hmMgn4MXvzkvFj28mlN0ZgTwBn67bEbZ5MGJUucgOXB3PzKycedGE52q+u5jbNgP6pe+H6lWThiYVkZBKUb8ZICtT0E7kCvUcyeOdWWgaVAST/TEoxEnyT/97UbwJGjiqdO1WptayG5D2T/17RgKO8jTxJt7RJnKvG1NGRtMeTi8T8I4trtqInmcPP1LttmGoBKa11a2BExReQ9QiDtkHsUUCobGLXb7XIJRtRIun3v6k6AiMAPsv5xoRIVZ6PREoZ5xVjMVB6ldPTv+elaf0ATZFnKOFQ7XJfIlSJcqsTsbzFSfv0Fg3rLYmBzuRT2KmbR6+79R8JjZWTsiQC41TiXjVZOCG4XWp3iyklrE7wITbS8f2tHMmAdFlYuBHf2wNeqwl3XLpcXi2XhguU730mSFDqSKNnlDYHbLFAmxThdsidA0VCXnVUREWZ5Rf47Lls1MYkwV41te1e+JjNmey3FgHpQJwGBzuig72bKooJgwKhkcjiZbrxVp4ecVTZvhU7VWC9n5LKdsElEnKlPauZUUoTIFOMTm8Fw6Gv7NElJQjVDaqTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KwR5RlO0ZqW6FeR17ZT1FvBO2nSScJhWCqnYolXSD6XDauTwwmT6PcgZtiSb?=
 =?us-ascii?Q?EFIA5ZRPt7/gs9GB4D7Ow+8XFR1GFar4dkOJ43KzIa0Xi+zTbhHLmNbWc2X6?=
 =?us-ascii?Q?MZ77sRzCmclB0npAmT79RqLJkY82Px0ZMiadxjyIM9Pgh9NQLeDRgOdR9+Gs?=
 =?us-ascii?Q?SJd2UIAffZ5nQuz/3h/1v8sLtwwXPeh8swJWoIvhgVVwBjeN8G/kNurzoCK0?=
 =?us-ascii?Q?2dmTAagpvkCj/D8kTLMBo//muQho56uks4xIQd9e6o+BpKL2ZtlyeemmwvSN?=
 =?us-ascii?Q?Sei/kj0efj7Lg4+GJjgIBUNLxBwC5ClCslN+9XdgEq7N7rFJHqL+uLoezi5X?=
 =?us-ascii?Q?XpLtJGwpE9ue8as7ykFuWbn2Gn2GRKvgsJCGwnQk9CeF/VMEV4KSRV+Qi49s?=
 =?us-ascii?Q?oa7CviXgiL5MsIC48FESBtfAuvyiiL2P9u4nQA6nhgsAMzn8/WXUn1VE/JDX?=
 =?us-ascii?Q?D//OwniOb6Lx+CLPymjut8NfDEJXjCslnHhlWvPCEj/ynGzo1COA2gG8HBua?=
 =?us-ascii?Q?EFtm/L0cDAzcScMXQGu5daqYQm5nzJDtnevUH5o6nEHHhdlwvM4HY08zSgbn?=
 =?us-ascii?Q?2IKeoJXN5o8GmbRFYRuhlTXIjJxjowAHHqO6xEQ765QiFORBvgTlBVAQ3b83?=
 =?us-ascii?Q?+CZsFX0G57U7Qd6yZp4zRXTLcTZPhnNgIr51F8Xh/SouY/Mpyrmudd40kRdx?=
 =?us-ascii?Q?MTvP7c1dctTOr1HG7W4bTU3ADs5YV20BuQT/2xAFpgDj7LH84iUS7O6qc581?=
 =?us-ascii?Q?PIDHISc4qpiRvn+9Zd49Fu2gq+n/XzONuM5zStchg5F9dszyyPOLIyxTeINX?=
 =?us-ascii?Q?mARFxu28NbmHz5LPdrXkyLenUXqu3pH0G66BELsgXctyhg3ULLDlZrvnfqLN?=
 =?us-ascii?Q?cFWcLcBfJ9czmrL3riTUBwo796Ek1J+5ZsLQ4g3WJLi/ft0J9UR5ZdmH20qH?=
 =?us-ascii?Q?h1MT94T/s6PNQebgXZm0aQ3x7GfhOeytQF/jAJorI+ka8X2RBCG3pnLSY56n?=
 =?us-ascii?Q?3qoKi2Uxj8TNbx8vdWJ/qUVSsORmj8sxJ5GIdb46EZATbzqYZVZTjAJvRiu2?=
 =?us-ascii?Q?vAZZ4TtJ7JTao+KA5bUZmt8uWMhxfCH/zN9TRkJV2qqBUfeqZ14RkcmUvj5T?=
 =?us-ascii?Q?RogKZC2uiQQfyW4TA/BS8nnSoQT+HctVcUQqJ/RI6ilTePnlj/7mG52Kb5jH?=
 =?us-ascii?Q?MBthL+2+mJDHJX3JezzyqbfgLAzo9nRMu7u+9fC1OjpPLkbFvNq4H0Nr5900?=
 =?us-ascii?Q?wQIgwUpymdgXM35Na39m4ZJyY7wJgZQjsL7/DWx73+Opt0zihK5PBkyTgycN?=
 =?us-ascii?Q?FgOgC96m3JeCtetafvlmJu0S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb81c92-dfd4-4ed0-36cb-08d8d382a6a2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:57.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIAqs0GPBlVRLJvsp5A3tFH3IH7rfymYYANA62TXFZsaWPYewRqd05Kw2LE+Bm5AGYYAYGDYj0H2F8F7XqdycDWSp0kD4p2Rj90N7uD4ilI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++----------------
 drivers/target/loopback/tcm_loop.h |  1 -
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index fb877aec6321..2687fd7d45db 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -39,7 +39,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
 static int tcm_loop_hba_no_cnt;
@@ -106,10 +105,8 @@ static struct device_driver tcm_loop_driverfs = {
  */
 static struct device *tcm_loop_primary;
 
-static void tcm_loop_submission_work(struct work_struct *work)
+static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-		container_of(work, struct tcm_loop_cmd, work);
 	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	struct tcm_loop_nexus *tl_nexus;
@@ -161,10 +158,10 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
 			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
 			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc),
-			       GFP_NOIO))
+			       GFP_ATOMIC))
 		return;
 
-	target_submit(se_cmd);
+	target_queue_submission(se_cmd);
 	return;
 
 out_done:
@@ -187,8 +184,8 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
-	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
-	queue_work(tcm_loop_workqueue, &tl_cmd->work);
+
+	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
 }
 
@@ -1160,17 +1157,13 @@ static int __init tcm_loop_fabric_init(void)
 {
 	int ret = -ENOMEM;
 
-	tcm_loop_workqueue = alloc_workqueue("tcm_loop", 0, 0);
-	if (!tcm_loop_workqueue)
-		goto out;
-
 	tcm_loop_cmd_cache = kmem_cache_create("tcm_loop_cmd_cache",
 				sizeof(struct tcm_loop_cmd),
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
 		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
-		goto out_destroy_workqueue;
+		goto out;
 	}
 
 	ret = tcm_loop_alloc_core_bus();
@@ -1187,8 +1180,6 @@ static int __init tcm_loop_fabric_init(void)
 	tcm_loop_release_core_bus();
 out_destroy_cache:
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-out_destroy_workqueue:
-	destroy_workqueue(tcm_loop_workqueue);
 out:
 	return ret;
 }
@@ -1198,7 +1189,6 @@ static void __exit tcm_loop_fabric_exit(void)
 	target_unregister_template(&loop_ops);
 	tcm_loop_release_core_bus();
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-	destroy_workqueue(tcm_loop_workqueue);
 }
 
 MODULE_DESCRIPTION("TCM loopback virtual Linux/SCSI fabric module");
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..437663b3905c 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -16,7 +16,6 @@ struct tcm_loop_cmd {
 	struct scsi_cmnd *sc;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
-	struct work_struct work;
 	struct completion tmr_done;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
-- 
2.25.1

