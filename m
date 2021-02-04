Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214EEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E672C64F44
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhBDLjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:39:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39714 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbhBDLiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:38:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ0o4122037;
        Thu, 4 Feb 2021 11:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=eo3sU2Ca9/if7bP/nX05oZpZ3m086iarrYcEYw2UUhd96Y2ieNhvDyuiGzFOjS9v4Hje
 CJ23N0S9nbWr+Mv9KhoWNAQJLj3BVylBKdcKHvxtoowTA61YsqUYyOLQI5wdkhpOZ84U
 YFyY09N0/SBWTqsL1MDLqbs05XmrWaWqP+nGn4typMJcCWVIw4vNdKJw9zMtd+jpYcRE
 UOkLxoqkgewE15KMeAuIz0QT9ggB5PH3/RAOEh9W8OlkORGnkW5kq4SnJfCensjwmgrv
 0BDLKvwpv7qc9sMeyWegNDHB1PjDafi4NujETkqiUV4JeFwUNo+8RgJmbepUGSPh/OkS aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydm4rcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:37:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYfUL134930;
        Thu, 4 Feb 2021 11:35:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 36dhd187r2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPvYoJjxvx6kDjyQMh+EHfQHk/DvQIX4J4ahMDy/ZhO6q1adpszGsEeYHhnKA5ZWassw1eEq3TLRYsHjzZh7n9bS2Maafdb3hWhM4MFdHjAy2X3o0gwoW9WCjJpHnTIbYcEAsuNGny93Dfl2sntI1V2Z6lhH79BCLnMFba2i2iRCZ3cAIwhs/8tiZMdSSHgaAzrZdI4ZzD2WQPQsA9XZeuQYHRgVSd8hlTWOcwis0wMDhNvmyo3o5syCHV2i+p3rM0kk956j7Vg6SlAhgjlybr6egOKG4CpSjxe46s35y4e/2P50tiAmhm1c1+jdRBXberrk+fWD6i95woO09UJV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=DyuIZKN21MRO9cJ5XAH0EOWGTTGrPWcdwvEmbX8t5jd/OOh2Mgt5T01bRjFK08UQNzJYk0tSic00dEcAU0awXiLWUrP6rv0pBSaw3qUueXsSRWvXQ9IbyRklkzsK3XTvwsZo6J9to1mwyKCpywNJLussWLqneCuVtQMddP61QPqv/AnusgNTfRuf1QYow9461w9UV3hUDtcdkaRLqQGeEp5d18TS2zb5Lsmbi6BobD4QkqRye/c86KWsmVtuHCNjyJvnCzAQTy015eoX/oefPtN6UXsEK5cOcmkIRzBCBS7mpHw9tmYhro2Wk/5oyIiRrFSxHZbKkSN/0Uq5djKZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=F8sNNQs4A4cgfVqEUphBs4n0WzEgpykoEsYxU0OGdI8h/Oh7L69bvHGeNNyHw+unUnmdgKJyo9F6eb3Xy9U1aS6+KpMwTPfuAz3jEfxAzouc3lqns5iexbn/uromwfEaff3zQhL5bAY693ybMY2XocDynUYsZavXs+/7JJgDBXE=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/11] tcm loop: use blk cmd allocator for se_cmds
Date:   Thu,  4 Feb 2021 05:35:05 -0600
Message-Id: <20210204113513.93204-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 505a757f-4949-4dc8-d740-08d8c900f7c1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480B4904A591A60C3459604F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ye0LNNLif47aFUDq8zf9Vpimm+8edXoSWlkE9BnvSCQqC9qtftI6M6XEmTD7WQ8BD3uXVbPgDWoVIXlnGy+fTl5MvOSf5z/EW+pnMf6U5RhNieCB9QIQhnOH3HayrtrF4WeSnFu7h8tBnRKIAoYFp0jVQylKeKJrxOpPdBHlsC7QAiWSXyi1RrXwmTXkho3wv6T7uiFiSuAHR+V9MpxMPdUFcuqh1ep1+ERgG4/0LIHxJhimEadqB8lrz0Nf+ohQ/gy0mtIhUwRFDlZzsBXSz9xnHBJLVu5UHzzpvbKAHE4WZDXuH9CutTbOnvnhNHX+eweQJNmabYEKW3pljx3c6cKXZqaNYLG4pXVTdDhlbMqgY35zHHvJlsoPqwpPbtMdupqWFflbeJ1qT9LGAE2LQ80XzxlmroCy9HzR3Ahpe6TisaBDV3PBTsV9RVhcWGFABHanqWzliBeKmz+Tk66o4LzLc5vEFKoVU/zEvOXXrowzF4NK9B77VmXbaRBYbjNtByk339JH6tjhZf/Drpg+4FgcbdS1mNJViWgs6YC8/Eqr2PirtPmAg3yIZHc1CDdRDOo6S3a3X3OOJAPuAiig+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qE8iDmUoS+wRtCaMK4/uQ1dwsrEMMzIXwsEfyWD7ZCYIa2F+XNHjc5w/w4c8?=
 =?us-ascii?Q?L30OJ5XAk9XX5WCN2E6W18I7mY7eCc91fH1NTnfQfpKAOtS8+T8XkSam1Sia?=
 =?us-ascii?Q?ePES3ieMEpWkggltvDeZC583EiY2wR6CKgE7qEWZl1nJf3+4doCrnyMpYi+Z?=
 =?us-ascii?Q?x2LLPBvEDQE3ZW9OMnBfH/4vPeWxiI0kefN77EbhoBDuHTZQf+7cUg/WPYqv?=
 =?us-ascii?Q?4CovfDyuAsNS6GBFsBJtCpO25J9uPNZtRya4sQsUp1A8tyvP85bYcaGTG2Zr?=
 =?us-ascii?Q?zBqmMvH+mQwENDggZxYuvaJW4jM8dOBcPOp05cz8e47iI9Yr2VwrwdaM+K2s?=
 =?us-ascii?Q?AEC9KXSb29nekcEiNEAJDJOM64QJiy9gZxRQzboirrOZsu5ad0+wVQm6K0Cv?=
 =?us-ascii?Q?awHJ4VFxV9gcKeoUgVM9DYoJS2HVX0djycK3p3hDTCbU+d4JARuPl7nZZar7?=
 =?us-ascii?Q?F3eL2pzBcu/w9LrfXiDuo2/KKrgY00NtHlBCIBCRXv1RLIG7HeBcjrZP/rSV?=
 =?us-ascii?Q?e43mFoxdo6YNPCinvteBqS/mSyEPyfOiQSGt1In/DR+RS368IK8GIRkY1SmX?=
 =?us-ascii?Q?ZhSZ27YPbTaxKnMW+Hw8IlzCQkz9xnrfqrVpBDWa78THcBaUbx8LdFSDB3mp?=
 =?us-ascii?Q?1r7GgoW7uLzc6zwucoNL8Jvj+6an7xTjnnoJZfcF4w+Acd8RFiaBbcXB5hQM?=
 =?us-ascii?Q?KtlYc2CeaRhJDafkMvA3HDfwYQ7RaYcILQh7H/ct5mUaS/jtPFkoAyJVk9jp?=
 =?us-ascii?Q?NCfVBKQFG2QDD4hy6EX+ccucxooCHghP0yqN4z562LfSRVQukilSCsT+kLpl?=
 =?us-ascii?Q?dlm3IWmoVIP2Es8aeNSS9pgta+Nmi8xz50h2ToKUo0FJRU5fhwK2QA5XYgX4?=
 =?us-ascii?Q?As2qvUHIOot45pInUlY/uFLGyDia32qZsNDY6xngVOIMjbDje6OkSOVGOwVt?=
 =?us-ascii?Q?25ul/7WnOsFK1wKow4QYohQN5qRWXbJ7YMeSvKGfKEAS0VD4y6kejHQXqitd?=
 =?us-ascii?Q?Sy67zDAKkBFfihYbhOdv4gXSZEsU8RmuAGuwLMnREFOmsQXdTz00M2PnNn8B?=
 =?us-ascii?Q?T8kMMb5TxaGzgyMlSajWkhq3S1wuBEGwzyByesO/jvMjRo3e0LicGkR80uHb?=
 =?us-ascii?Q?XQoWqTaFq6uzCKfDPQBu1wr1FgDFrifwxfJMf4z7vmQz8gw4cQQEv8R4jwW0?=
 =?us-ascii?Q?y7m9YBG7g4J5nkbhVC2q0CUFkqwGEAqs2t6ZoHUmt8kLDeSI0r/Bq3QEZWyz?=
 =?us-ascii?Q?zPqP9pIYf8HoLZdB39mVC+00tWTuvNvgJCrxOtW4ji8GLRkzAG3qLR+JnA+A?=
 =?us-ascii?Q?WcIRJFIjVoMhdf+8SjoeeXM3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505a757f-4949-4dc8-d740-08d8c900f7c1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:27.0142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vd/ikbbaatLQi6HtV8G9OW75xmYVfzNQtz7dZpVUp8sC64EzWFydZWrCmcBLcYnepJail+6pNxuwKQNml1+yTiFk3vEjVhNMYuz8/92gcN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..274826a2b0bd 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -67,8 +67,12 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	else
+		sc->scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -165,7 +169,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	return;
 
 out_done:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
 }
 
@@ -175,20 +178,14 @@ static void tcm_loop_submission_work(struct work_struct *work)
  */
 static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
-	struct tcm_loop_cmd *tl_cmd;
+	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
 
 	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
 		 __func__, sc->device->host->host_no, sc->device->id,
 		 sc->device->channel, sc->device->lun, sc->cmnd[0],
 		 scsi_bufflen(sc));
 
-	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
-	if (!tl_cmd) {
-		set_host_byte(sc, DID_ERROR);
-		sc->scsi_done(sc);
-		return 0;
-	}
-
+	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
@@ -320,6 +317,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct tcm_loop_cmd),
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
@@ -580,7 +578,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
 	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
 		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
 	return 0;
 }
 
-- 
2.25.1

