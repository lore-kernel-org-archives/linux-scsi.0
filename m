Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F42C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 22:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC42610A2
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 22:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhESW2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 18:28:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhESW2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 18:28:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JMJ1n1009924;
        Wed, 19 May 2021 22:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nXFov+pXFX1HSsMwJ06NSQ+zP4+38HN0TAghZblNNso=;
 b=sUuR5REV4hqR7EsaYTZ4lmA/w1lril8fOnw14EZnvby3+zMjA2nB+5luvl6H+3LrWUds
 Lbom7tx38+AWTtb5tRtoZ5URTGEr5Aj5KveJp0icoOCn5w+Hk9QplcjixPOpPQ1qAFwI
 blN9jcv2ly45EoNkNJM6kHC5QBlJpnI/Vo0nMETi+FhOkk8BIuDVSuPP2D5EpETjploD
 IuJgVi9MFrqf4XONqgRhnNgYQpUX6bByPJGABz0nIIocTVbvDJVETLkDMRPlZqaQyI2m
 FUdgAcnTfw2grj9CQL54bOtg/UROfhTvFNRiRTKPYw4NYcY+8SIE0hjclnepYPLtZL+G bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38j68mk0b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 22:26:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JMMiBX100357;
        Wed, 19 May 2021 22:26:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 38megkv6v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 22:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdFF0JYHOQ+n8407xqTX186gHJ6h/R2KZDoaDTWuwnHDGKuPq+mwrkuuKgtnR9730g7DrGyx6989hGc7ZaYqSPZf6h73NowtQ2BeZUFLtPe0uIBnRECpyaPfnEO3me0VPta1hCmptiC07fEPNUPoe3mTDrNsT9cGNhZQCKZTjXK7+HBujBf0Gusa8XG6tv0XZeIiXHFXAZAHXiUA+TgQcvkGJWyfZ3awRpzYyW9LuDrzlCoquQKks3uggEO+buWRhyO27dp/YfWj5wvUYLQBtXKQSferxa0KDajfxmLO2EFiVe5V6FaS3o/yxbWkvG+HazRu/Z/bhdcQdlE4WVR3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXFov+pXFX1HSsMwJ06NSQ+zP4+38HN0TAghZblNNso=;
 b=lc5Rn2I6r45tMC8fF4XQPlEsrzkqk0fzqNtATELke3AJCHZcvRGJbkLMOH7arBQMNzAPPr3/TXiODuL2iCmPhoaqDaApprJ2EqBVckibIPh4F5XHDRbWEeoGTVeq+8WYsbMBJSQKcSsvA4GoKvtLeqXALVSzizfmp7m3JYYpAy1R2Fa0KBj0nlw6TUwok4AoPQns68tKTcMMK+3h1cStZyY/skWX5Lyq748R/th6hIYiNz+EbzqCGopSUXPmYhf7txRipysKYhcbQKw+B3eRN1fFjPigEzhyn6zF3ek81HkDTqQqJCkuqVWpciHQEBt/G50xnszso0Tfnp2TsCiiNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXFov+pXFX1HSsMwJ06NSQ+zP4+38HN0TAghZblNNso=;
 b=TRfw6yc+h8QCfLdc+pBBwxUCUaHKnJNXrXCyaFdzH390gGuJgfljMzCnIf5S6C15mjPuD3Sx1qRqPjmlfFwOIPvUOGaoJU0fJwmmI40fgrZNrUxEhvRmx4ELcmsbSNNeH3RZD/PmWg3S/t4FY+HsI0f1FvBtCs3ZIYHZazWQriI=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2584.namprd10.prod.outlook.com (2603:10b6:a02:b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 19 May
 2021 22:26:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 22:26:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     shinichiro.kawasaki@wdc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: target: iblock: Fix smp_processor_id BUG messages
Date:   Wed, 19 May 2021 17:26:40 -0500
Message-Id: <20210519222640.5153-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR06CA0047.namprd06.prod.outlook.com
 (2603:10b6:3:5d::33) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR06CA0047.namprd06.prod.outlook.com (2603:10b6:3:5d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Wed, 19 May 2021 22:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb6c477b-cf46-4d98-98f8-08d91b153117
X-MS-TrafficTypeDiagnostic: BYAPR10MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB25845A77E8A1968B73FA4E43F12B9@BYAPR10MB2584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH2/Q8Y0vHhcLPI+d1DxIiXolLzpUmim47Oi7WF5CZM2uqM/fUcBAwWgvkiYxdFFqZHU/8wlJpD6lmZqgfSoYdzAk9dkzMDDtB4dP3pRX7q1+7ovxarg4dc5VvMe6v3E3KhwBFkEwVF6BhnupT3a3tUqHTZq24MBzfK4oA6iXxxUv5K0Bz+usrDA7Ltm9lpyWTE+GIsoM0MESBHTpnJLY2Jl0fBRsmTNtOxaTVnQYRJQvmCXjBDCOhUq4lx2DGmPxIdmiSD2RhWwEFqeBV06tvwIRLrImPHFTH1j5PB058YbDx3tOyqPjMCq6XzucGa5PKqJj/trAAMDIKuLdvSQLumHll73UseiEgO39b+jB/CkjXkQcfaPmtCj+zO2/NUM9ycBH0dwyZ7c9t1N6XIPWJhacFBl5lyuC2ITWDf+luCeflyh4FmH+7AJbefd1mn40z0YkYI0hQSlEzKXvDKeWd2GnWWnpwjZXJi9cmPGCjm1EWb3wvcX0lgT5oNNa1yF5UiDJFpWWe5pfpCtyCzovLtwOIWW8O7QQGFOGnt47WNidQh9C1joqDKI9POx1cbLrPNoAHZMwRH9SBR1w7cM6lI1wOIlVaTcz3l59Gs91VjjN5fKH4PEw5r2mMDNJrqcjEa/vv5ZtmvPT6h1MXk6KA2v42gkswDYQo+FN7blPsZ4o0JSNYXqPmgM7hBfw2fi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(366004)(39860400002)(6512007)(52116002)(38350700002)(6506007)(5660300002)(38100700002)(8936002)(316002)(8676002)(83380400001)(6486002)(2616005)(36756003)(478600001)(66476007)(66556008)(2906002)(1076003)(186003)(16526019)(107886003)(6666004)(86362001)(956004)(66946007)(4326008)(26005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lmO8CJmLfVD3ePQCZ1lGix3qNpjJrstKlKXfkoFH8amqjZSq/XC31EO7g0vD?=
 =?us-ascii?Q?oKJeYbaSl16pmi9+55ygituWjqCQS3LqxE0nhnQCbxhlPKnk1+H1f70H1xfJ?=
 =?us-ascii?Q?JdoY944rTEeP4tCWyTvEcFZ7VzJJgn9KuBE76Xz+FyfqpOfodNhgYo3Am0Yo?=
 =?us-ascii?Q?XwEjbBKlAeKKnpcdSTXjM9Y+HouixgmuDR7m9cKrnd4FPkOvy8IzxBt5WnMm?=
 =?us-ascii?Q?ZqnNZjVdgSwg6amCjHKVKZFHNLB2TX/J0xk+rm5a4r05VjduaAP1G5BOmlLB?=
 =?us-ascii?Q?zAXA0bPNLhD0VQxmB0kXKV/6MiNI0qlht7WZRcGFVpQaJjviJY5DZ9cHLQZY?=
 =?us-ascii?Q?4N09pcD/p8L69IQ0FLIO/ayjHdEpP8s/kolJPcclWtZ9RoatseOBMUWhHDKD?=
 =?us-ascii?Q?ZWQLM/Izovn6UBbl+QKJAvgQ/bkMAdU3NkDP56EGOaJlBWEYH/W4l+vNlaSq?=
 =?us-ascii?Q?1RKRaCGKnQ1lUWc+8afTRcfOkn+4hS1QTfSvDFnH1hQDeMAdsG4HoxmMxlEC?=
 =?us-ascii?Q?r3yj9RS/IOcun3PMjlIlhRg9QfhoQFxNzfuB2ph34lmzE79Z4Iu6rjnqSZu3?=
 =?us-ascii?Q?jg9G7Kd7ugylPHN5C8RHMzieLc8c1T7CQ3Fzav5GJ+Xyb8/bDTjjgGaLYZeM?=
 =?us-ascii?Q?kzUNQgp6xzlOKrAe22EpSTyNuEaiT4Y24m9D0QP46sz9W3bRPqxk+65mxI/r?=
 =?us-ascii?Q?R1oslEdMXsfNJeNJoWcvig/sKfWta0RM09OSh36rEszpd2Uvq4t/Yv9tP/MB?=
 =?us-ascii?Q?t+Z5lxOC3ioxGMmE775TTu0Uyg0JFsvxqXojfiNEGkfhsfg7eJNLoPUpux3K?=
 =?us-ascii?Q?cE50mp/F5MJvdk2/XLlKVVjK+snWGPgOqGbBLvTTo0Ieh4nelahfQtWrQQdN?=
 =?us-ascii?Q?dX0lm6OUmdL2BLLGZ+S5ymMXy1/Ixuw+UBlgiOGctbVfVOk1dYpeon4CO+rX?=
 =?us-ascii?Q?Ye5HUDrxw5eG8fXJR2SJBMP5rg9XMO5pVstlX4y2sVIdczi0cPwQLEVbd7RN?=
 =?us-ascii?Q?hwMl6r6POUzziMCFUNaBuGL/48dDudMRlQnRBlA6iLkpBJwwhcspuU3H4GjV?=
 =?us-ascii?Q?NWv95Ef4CKJG7A+DsEIikRbSjBHClY4EaVJLcdB/FYXAVzDQUcJl6ixyK6Wd?=
 =?us-ascii?Q?6EuTZmb03dxPsFKQp0mCfHecy01lgjGuN+gAC3havSkmiGSvBt3sAnSfM4d9?=
 =?us-ascii?Q?Ybg9rbs+SdgmXcCrpCvD2XqdEBpDJqnngCtszMqGS2dJvWmXbNNLPWFI+Z9E?=
 =?us-ascii?Q?dIdl9264qenS3h7uU+9r49/bxDivdNtqQ24Nq8ekMf0NH/12WUKBe9jw2t79?=
 =?us-ascii?Q?9psHD79oHu2DI8xPzmaecPZb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb6c477b-cf46-4d98-98f8-08d91b153117
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 22:26:48.6906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N17uQclBLClk5Usfks9IOsdKm5Y5w0pD6tOezTVQjRU0HaejGI/WfAe95gmKKM3y7VzcqzoD3asFCHamtXuF/O4u9vNFzGTGc9ZI4e3MXY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190136
X-Proofpoint-ORIG-GUID: e0jwmqwirYd4maHGlPhvA8lAYtulaKeh
X-Proofpoint-GUID: e0jwmqwirYd4maHGlPhvA8lAYtulaKeh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us use raw_smp_processor_id in iblock's plug_device callout.
smp_processor_id is not needed here, because we are running from a per CPU
work item that is also queued to run on a worker thread that is normally
bound to a specific CPU. If the worker thread did end up switching CPUs
then it's handled the same way we handle when the work got moved to a
different CPU's worker thread, where we will just end up sending IO from
the new CPU.

Fixes: 415ccd9811da ("scsi: target: iblock: Add backend plug/unplug
callouts")
Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/target/target_core_iblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d6fdd1c61f90..a526f9678c34 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -204,11 +204,11 @@ static struct se_dev_plug *iblock_plug_device(struct se_device *se_dev)
 	struct iblock_dev_plug *ib_dev_plug;
 
 	/*
-	 * Each se_device has a per cpu work this can be run from. Wwe
+	 * Each se_device has a per cpu work this can be run from. We
 	 * shouldn't have multiple threads on the same cpu calling this
 	 * at the same time.
 	 */
-	ib_dev_plug = &ib_dev->ibd_plug[smp_processor_id()];
+	ib_dev_plug = &ib_dev->ibd_plug[raw_smp_processor_id()];
 	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
 		return NULL;
 
-- 
2.25.1

