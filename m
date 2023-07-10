Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD441C001DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjGJVpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGJVpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:45:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9376CE0;
        Mon, 10 Jul 2023 14:44:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AJov8a005792;
        Mon, 10 Jul 2023 21:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=anQEW8blyeriNRm/Tg1WF0CZEElPTk1mRGx8P5qa3Wg=;
 b=eWQbFJvhmNWHqkRtgi8FAfAu73ri8b59j4DxHK9tGtJGRFnbMVNjjx1Z3yYwYAafu19A
 w4yv67M3JO8uGQNhfRK/7PaHY2qlR05rdqv3lBJTM7kdNpapkhKm+fNS8w7cvTZSVot9
 t4L8wrSsBpVEXo+vji4pnSr/RSbPaO+x6uyuU8LqKoFm4Eq8uX5NUZMlxsWR+eFXpAzT
 OPINAjr7NIpeYPkyy1DZ/idJIcebaB/JJp5L4K0gH/CtlRWFuvEQkJ3F6STev3h16fQZ
 nP5bY+PKqZgW1b5rDCcVjz0+hKEYr2Oriw6girHkznAyOvt5dYS3xFz277DZc6T0Hvx6 Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrjmh94gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALO3nU022877;
        Mon, 10 Jul 2023 21:44:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841rrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsTowHiJmJx3ac+5QLoA6rUSI8h/wZEz9uVSv2w369+DLHYgKVo9L7UAM1SDkk6kGDqd2UXGnmt76qQsMH2n66Dm/b5hFPQyD0oVXFZ3QEXWRhQryi7HA9kOpZgU/KdNWKtZF4FRk/vdfeZICs02hkJDMM51n8wzcwRKFurEGQ6Xo5kx5RtiHrlDDhUJ75DjSJV747Q/bWIl6N9c1KHxItucdrE2lCkxoWj2LjfHxjG3uScSZD4lB1vlL39cwY02dQDfd9YdNUdQ+2QCTxCN92pj25fiZQ9hZvfF+Q9oyrFKjA8DHMY63WnOAF5Te7gzu4gqdXQAmGM6oMcpyUxO7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anQEW8blyeriNRm/Tg1WF0CZEElPTk1mRGx8P5qa3Wg=;
 b=ku1NBjLixEQIdaPATZ64XTL/ZO4I2wpBJ/F8jbVLu7AmUe4iadQNs45wmWpPgmMnB9C5dzKjfzWtO3+4ldMsWj+b+ya67Me2dQU9Ev5BoXbEmyxYrVMFI3095M4rt26lwv8uKVyom6IxQFR9TvskZtJBR+/1mqJmaGmNAca2VDwWx9wCzrSfE0S8HPWxSYSAOd8CyJe4kpv0kn5pO5JeuvIpkqA746YqYy3cSfEyUOJu77u61FZwS73cDzletLY5rATxRZNcPws4R9uwEOdxyAEJfSU34ljg79AyEx6r0W/MRuElyVDHf4RfFIC3jc2holvkGHqJqiRos32xzx1CqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anQEW8blyeriNRm/Tg1WF0CZEElPTk1mRGx8P5qa3Wg=;
 b=rfli7PuCQW18ccp6ZwFw6ibsrreOcsDI2CTfBqjhiZzfns0TJe2/52C0UvPk5y8KxN1AZ9ENX1VX2/ao/HxoHZyN9xkPzBuVdXosF8O5D3PLWPbybNG2ehg5saOLfBPApNwCHsxHLXIxy125qyvDdeZJxnn2G8fpBQjuYyjxE+w=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Mon, 10 Jul
 2023 21:44:53 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/5] scsi: target: Unexport target_queue_submission
Date:   Mon, 10 Jul 2023 16:44:41 -0500
Message-Id: <20230710214442.6718-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710214442.6718-1-michael.christie@oracle.com>
References: <20230710214442.6718-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:610:e7::27) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 50795320-6b82-441c-abdc-08db818ee4e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TliOKdy9J+fKJtd5kfRbJu8fqb2bXu+5Cov++KgWT3QaxoTOuRdrpmJudjLbsnbWBx9IqiI/MNM4S7fEoqs7tzrsCQL0mOXX3OnLc6w50i2x5fV26TF4IshPIGLY73IeaqN6bM9CNBWO5djKoSpLaWJN5yGUkZ5EvAGLrIc5xxVfdzoYdctSs4GqlEEQFFOu3IcXng5pk/8zwVUpBYIoXzd0MMThQpZkudFBoZcIEY5lqRUAE5Nj8eljWkZQw9nQf/Vj1pk4kbiTPfo5ikqTseHlcYolRNh52D1+oTeOTIicuJkK7OEDj6pZPklGZt890tjPzxjhjD4XQJfgwn/0rHiW9KYyzQfTPXTJzWhSQER+sT2MeBZjUA4onXWN6mxUyubS8zh2bdES67okH5dfkVIgEZq8V2Do3c7AZG9behO45EUGRDlcvudKSZRW4zFlIYxb4wU/TS+0sSWFqqZQqqZCf5j6mMJOWpdC2tlKfwb3x9dnHYUk0sWmpH2QUjq6TPMh1KC5sSEi7PgDE4RMHUy0sYczCm108Ht3xQurXWZ+OP4ms/GtA6Lqj+Me5dq5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(478600001)(6666004)(6486002)(8936002)(83380400001)(8676002)(41300700001)(2906002)(316002)(38100700002)(6512007)(5660300002)(26005)(186003)(86362001)(36756003)(107886003)(2616005)(1076003)(6506007)(66946007)(4326008)(66556008)(66476007)(450100002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LjTCeHfHESgFO3R29Qb9/rWAjGzubv8dBP+KFA+pSFnmdpeZC0oPtlGkliW4?=
 =?us-ascii?Q?s3tNYGkV8bVvPXaWbB+HWmkUxJJR2k5uCiUyfQAa0l0/cpiH8Sx7u+FG5QG9?=
 =?us-ascii?Q?bDYgPCl/nhSbItITYHT1fjbK8PJlexLIPt0Xkmasq6p/Z0v5IkiSv69W1RFV?=
 =?us-ascii?Q?YEZJCmBWVVZtbYDnVyXq2ufQjXDuZCgUY4lPLQ4RRwO/7JSWz4j9gYTf9aIs?=
 =?us-ascii?Q?dWmk7KI2DbTqlbqEaB0wSW8KAnRXGsAA23RrH5hLfwFa+hqT9gRmc74nlz/M?=
 =?us-ascii?Q?8kv3FdWoUsPAQ+lg4aHB9emn1tJfTjNkgaAbSX+0mahOkEO+fiUXkqNXowUt?=
 =?us-ascii?Q?/Bk7qAm5ZLdSEqdPxHY6hInIWFfj9Blbegf9wHoblQBGZkFR/mzkZbr/Zp1l?=
 =?us-ascii?Q?sNSL3jdIZm+dRKSCfkWqCs9jTa4v/yXij6N309ZyqbFqK0kagLxnx8dO25Uq?=
 =?us-ascii?Q?ywpoG9sLMzzVKRuFI/Xgtu77w4kV0ERA9ItwvK3mfGxcwNl99mM2I7PPSvK4?=
 =?us-ascii?Q?/Une1ChFarbAhBUSEY7Iihrd0vW4eOa9QNCbkBSdfuI/ehnw/MzTFf6LbYEQ?=
 =?us-ascii?Q?TGs1nKIhx0gROggdd44jzBSz5piSaIcO3oZIzuc/siQdKboHt5QRuI6/Lsrm?=
 =?us-ascii?Q?vBFLP9R/DVd8ciICeTISLoqBCpw14Z+bpUWHMoYcxxfBUdoQr3AfoHmby98H?=
 =?us-ascii?Q?rvgzgQUF+W2XghJtyibavHah0+GjoO/+RWx2l894OxalE1Du1ZtG3qAPdRQt?=
 =?us-ascii?Q?DLC1pjmgVpVFuW+P4iGxCEMX3dopg3RRI/X6anRMYFoMKzzqkD9GzKJw6CS0?=
 =?us-ascii?Q?Tps5VncKwx6tdfSsulfl8eOCdI6KB6S5aZHZakWnQFcggP4EURcEBlRwKtqn?=
 =?us-ascii?Q?xXpd9gctLpDXXbeFumPXU+7V1BMs8kKxUDCZMkKQPYf02YgXzEK7vALq/ks8?=
 =?us-ascii?Q?KPfhnaPBJWJZa4UaMAJKgcYl53+/MwbUJ9C8ZHZoIzvCa0rxliOiF9T9VvB/?=
 =?us-ascii?Q?QcefI2Ta/DhY+dRFpC22nMpFK9FRaHNPI2A1ZY+ehxvE2kSNJbBxuugUjxAf?=
 =?us-ascii?Q?pBLgbYOuwNxJELcVYu52iKqFIHat/HpicSFKwUaUW6PlOj77YNtgUlJn5jX/?=
 =?us-ascii?Q?bulGoesCNk+P1rhEA1kMwCxW5Vmy7pNUSycpYDgJjxdl66BiBiMTZLkeDy0/?=
 =?us-ascii?Q?BNQboFf7u/SzldmuLPypy9uInQfOun+hv0iLzSNzM8PnUQDLlwT6NMmJwLqB?=
 =?us-ascii?Q?2oJWOLIUCcgYlWDslkIRK57mj6zYz2B4/Dwe4wH4qs8Uz3qNSerly9LphCnb?=
 =?us-ascii?Q?DeZidUSOJ+iDjcZufN+o+rMf4K02Jx2yR6fr1IrHpBctsB5/0TNKwnjW7ZRQ?=
 =?us-ascii?Q?+DJxx7LrM5dxIKb9QilrZnb4dojvz+zdocEEqphCylVizaSC8M1rDKHF7fa+?=
 =?us-ascii?Q?aFrAsINJoYFZwQ8tRAbM2ygm+/JbuKk5DefM8A1qDWe48k1XFhUxHfGMHp7/?=
 =?us-ascii?Q?TPKo/cd2buC9616yxLEXIbaCjV6UnJVc4VcwYPpQTMi37WEep9Ggym+jd/JY?=
 =?us-ascii?Q?G2Ht1ER7tt2CWCUnvrnQO2RMqg02s5+vrP+pho+fP20LEsU0HIlD2GXv0v6k?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OjFJC+wFRHcwuQVONgDZ2KrEUhiwxpOuqUGxRZuT0hcrWOQwjjLBuC1VB4QRi6GKhjJf2U4R5no2Aj4gW69a5eJ9EXbHXzE3erSCwdO+Em/xuzN05FqBM8IRfFSQfM9n5w44V2ayF0ZLmIaD2YWycAjMpK/UOwP9rpKt3/2r56ps0HolmTf268jUBmiAmf3RILtHISfdxlK9ogYU5DxjMVgqNS8jkg+bAL1jj/i72S7or3DHg351oKk4bIFFyIEsjLNXpXXn91UfYQlksP5Y3NFW6YspKR5LPfe6UFLF7eDyNIPXbcm86MC63p7sP/0ox3XvbGGhcqnn3Z7TZmj6gmHxw5tujmfQDsEbHjDY2U7MiQgMLnKHaOz4ryKjBT7Um/R5RjJnbGkP8p4LanaNnIrtBfZwSyboxZdvKey987at4O+GJpWBaAxi4y4YFzJb6RZ3YrNKbWJ0xiOLys0npxWM/Ma0w5qindFW8seFu1Czoe8Dw5K2iDBrzHZat3TqY/+sjPdW1AcBLfWmiBegtb1vBqNppVWVNErQVUZ5+/wsqvnekzm11WhB/+zSmE0bfDYgOxtuUWmGzf0/Lz4ThCwcFYD1IalTNY86wqK/brw/Eol+NPUpySJKf3e4DfiZNDEB4JPKuRJRVwUX5VJCCZ5o6veslWTtyGySMCT9gVm3gNrMVfRmm3JkjAposTfupadxjw8QpqOq4VBdgQ/gZkyutZz6SNWsgaSvV2vlp15x0SYlPYE4Yhs+10fLNgwDf4QB1BHvs2U97I6sgxEVfg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50795320-6b82-441c-abdc-08db818ee4e4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:53.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZtWbmdZez7uyx+W7Az+bHBB+wos1cSZ2oOMmhw33muXWeijCA67fKIn0XkVCyS33srEMxtPv4tonGRMSygrXYtRxv/Hp6FMjfGOyowQ9Zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100198
X-Proofpoint-ORIG-GUID: CWQPMWpUBkOsrLMfnW-_YFpQJuHLZvI_
X-Proofpoint-GUID: CWQPMWpUBkOsrLMfnW-_YFpQJuHLZvI_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_queue_submission is not called by drivers anymore so unexport it.
This moves target_submit to before target_queue_submission so we can
easily call it. It does not change any behavior.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 59 +++++++++++++-------------
 include/target/target_core_fabric.h    |  1 -
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5349a2dd8187..701ca3593599 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1826,34 +1826,6 @@ static void __target_submit(struct se_cmd *se_cmd)
 	transport_handle_cdb_direct(se_cmd);
 }
 
-/**
- * target_submit - submit cmd to LIO core or queue it's submission
- * @se_cmd: command descriptor to submit
- */
-void target_submit(struct se_cmd *se_cmd)
-{
-	struct se_dev_attrib *da = &se_cmd->se_dev->dev_attrib;
-	u32 direct_submit;
-
-	if (da->direct_submit == DA_FABRIC_DEFAULT_SUBMIT) {
-		if (se_cmd->se_sess->se_tpg->se_tpg_tfo->default_direct_submit)
-			direct_submit = DA_DIRECT_SUBMIT;
-		else
-			direct_submit = DA_QUEUE_SUBMIT;
-	} else if (da->direct_submit == DA_DIRECT_SUBMIT &&
-		   se_cmd->se_sess->se_tpg->se_tpg_tfo->direct_submit_supp) {
-		direct_submit = DA_DIRECT_SUBMIT;
-	} else {
-		direct_submit = DA_QUEUE_SUBMIT;
-	}
-
-	if (direct_submit == DA_DIRECT_SUBMIT)
-		__target_submit(se_cmd);
-	else
-		target_queue_submission(se_cmd);
-}
-EXPORT_SYMBOL_GPL(target_submit);
-
 /**
  * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
@@ -1960,7 +1932,7 @@ void target_queued_submit_work(struct work_struct *work)
  * target_queue_submission - queue the cmd to run on the LIO workqueue
  * @se_cmd: command descriptor to submit
  */
-void target_queue_submission(struct se_cmd *se_cmd)
+static void target_queue_submission(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
 	int cpu = se_cmd->cpuid;
@@ -1970,7 +1942,34 @@ void target_queue_submission(struct se_cmd *se_cmd)
 	llist_add(&se_cmd->se_cmd_list, &sq->cmd_list);
 	queue_work_on(cpu, target_submission_wq, &sq->work);
 }
-EXPORT_SYMBOL_GPL(target_queue_submission);
+
+/**
+ * target_submit - submit cmd to LIO core or queue it's submission
+ * @se_cmd: command descriptor to submit
+ */
+void target_submit(struct se_cmd *se_cmd)
+{
+	struct se_dev_attrib *da = &se_cmd->se_dev->dev_attrib;
+	u32 direct_submit;
+
+	if (da->direct_submit == DA_FABRIC_DEFAULT_SUBMIT) {
+		if (se_cmd->se_sess->se_tpg->se_tpg_tfo->default_direct_submit)
+			direct_submit = DA_DIRECT_SUBMIT;
+		else
+			direct_submit = DA_QUEUE_SUBMIT;
+	} else if (da->direct_submit == DA_DIRECT_SUBMIT &&
+		   se_cmd->se_sess->se_tpg->se_tpg_tfo->direct_submit_supp) {
+		direct_submit = DA_DIRECT_SUBMIT;
+	} else {
+		direct_submit = DA_QUEUE_SUBMIT;
+	}
+
+	if (direct_submit == DA_DIRECT_SUBMIT)
+		__target_submit(se_cmd);
+	else
+		target_queue_submission(se_cmd);
+}
+EXPORT_SYMBOL_GPL(target_submit);
 
 static void target_complete_tmr_failure(struct work_struct *work)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 5b2367c0839e..77f69b75e851 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -183,7 +183,6 @@ sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
-void	target_queue_submission(struct se_cmd *se_cmd);
 
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
-- 
2.34.1

