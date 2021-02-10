Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BCEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58D4264E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhBJE5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhBJE42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4sDSi026528;
        Wed, 10 Feb 2021 04:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=drum5xNzJBUEXU3n5ro4CyyO8UrXtN9NvQ7m15RoPyDXRuq/qj8xgxZAbPPR61Kragel
 zDxJzJyx7kRjmC1ZmBDjnhsCvka4tztlfIngjn86BcuzDhJU6dDO0ffvRGgfeCMqr7Pz
 dO4asplqFj+QrJHRlweLNa3PLT/VfjLCC6mX325N87sbJXJ3ki4OtgTefc6WSWM3E1KO
 tsNIobzAP0ZJkZfD95dZBJRPXJY3hIM9rFjfrcsXLAmgV/QtbdJlmBFh81Ka3ranGbxy
 pePKytNq1GyXA80zF1A2XsqbpUndzDiGcrobORJ7n+rFwOF0RBnjsTM0di9dE8DjbB1o BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrn1uam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBB048727;
        Wed, 10 Feb 2021 04:55:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwOD6WXc2tZNJ9/o2hP8pfmxV+PiQ6AtUD1/ve5Ff/d66YQu/rmIRZ7xs1wNKn+viD0G4dF9JuoIxpjaKLqUiKoPQVmQT6mJVDxEO42TgX8qPWoN341lNZmNkRnLPOrmnMVLDLU/sK3YETF2q5SwvEASYopVZaEV4mFYcjFLMB886Ul59LJ7ty4+XECwbKa3IqLkwfqdJE4dAOnnUm3kUHqfMsRbW5Lw6exLnWhFmbqW/gwPcxPhJP0TNA6Y2jETfAm0ziW9HXY6WnXS7fqWnHUIyORiVPoZfRENPIkDlPVZ4L11Rx5HUGKj33IuBHRbVLmm8d0QqypjiVuzdzTomw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=m+AWuU1w3lRbk95oUvoGqTLyj2dKgMQxBSXIp2l1JdylWcUIg3byCunAq3jmxLzJvDjLcwMuBw7hEBejIOWQJzz3jevvgZK53C9mnhrWSGvPscgbpGMWCaHKLjlJwplhDoeT853mcsl6lpZfvFPR8mrv3zWhMahxNWlvlNuhSWK3W3AjGDG1LJBM2i2n2Ftxf1cw5NBVYNQ+6EGJnv8oVOPkKPn/1+26fnounn1sJBkqktv05WitZm8PG64j50Oy7lXDi07eXnWMl20hfcCV6qv9RNZEc6wyzp/QV5PHoHKUHS/tXhwCLiG7tJz5CG9196xkRcOSx9rx1pXIspxdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=YC/D44mLbBkNdpp2hV5gyRkhMzUKlScT8dsURy4xL8zKbQhXpDztZaXpQ481mKKBfH5QKQcVSUODu/Jk/Az4WFK4FjvqymnSEHy6mkpayRDHJ6u/v31cP7lsWWdo8DuMlY/6Aee4oAtYrMaQ+gWC2luc9/APsrAxFiVxI0UhqqU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/13] target iblock: add backend plug/unplug callouts
Date:   Tue,  9 Feb 2021 22:55:12 -0600
Message-Id: <20210210045516.11180-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb85dc23-a993-4ce3-02ec-08d8cd801afc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33665304E9C325800C1690FCF18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Re/2DLC+N6LzZij1YhIoI0pdoYsLHC/b+SGGzna41qK98NJjpNelBvinUb6WpzLG5UDJfhsyyPQxEsPh2yjGoi0WsO1UN8JHYjtMhIzZboxrQwChPhKp9w9BmGYKXpCnrms7scDdACGjRerJNHpk6MWQ1tDpqg27ylcQEBw8LWCCemyNChgEdbOnEaZ7hkfBhN7Paw1vlkCFeqez55kqz/ScRA1pJX4sXNv9FrkvVonufbz6cidsz342OaEqdBPvYLdR/AS92xIimid8Y9y2C9AURLhJDHOXbxwqzj/4+E2Wwb3d8BnFnKyD/6bG8S+P2xBiV4m4w+Jn/i5cW8RWaM45USPciUAdWpftHb1ThbTIHIbjcNhpoGzjfLxleqWd5pPSSZKpEwBb7mdNJ6x0pca+Lv+LhCj55cP1ZVy1MOxmt6n392GdiFlePn7sqiajFh/KZpfuUehymRXYf9DlMJpy+v9DvVjpujYpr7Z+F0Jq9iqTUgiK6MkSwMAWL2M0VythPQRGLw9f6GBXe8yPrfaafvOZyeSY8h8LokXbWwHy8D0Z8NkSPTud4hHrnpC6mZgyqW0/j1lT5v87ylSnQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IC7cyoq30YUvXjIzijjyrjfc9UabuBn2q19P9MFcNzIOnF9sd77V6DRLkObC?=
 =?us-ascii?Q?kqbqQuRycozMCJkPjAFfkh+fS/GA2WdfGtOlVxHWY1ejMbPkTXFlf2az+QOL?=
 =?us-ascii?Q?OmAEJ4Dk3RjBO7mNQLLhWaNryPp+QZxltl5z3I+EVyJkQgvBpyxhUMGeR4Iq?=
 =?us-ascii?Q?cJDBRfcrrfmDFJ3pMPiPw3tlnikGzB9aufvSShP0xzyMb3e5RZqybAqOwJyg?=
 =?us-ascii?Q?JHgpuBXszngXsPxvMS11qpWmSoKTozoy9GUBwzXzi1JkxZK2cp7AorPOsGaD?=
 =?us-ascii?Q?FfL4So1YV3BW15glk3AhXlAuiNZ5dO/cR3UjjPqqsc+iKUgPtoRPJc5sn7CI?=
 =?us-ascii?Q?R4bIKdDsxZuFD8plXKC5Fbgbh7qoMtb3mMRYCmR19IAhnrE3220V5d4GmHSh?=
 =?us-ascii?Q?FcXs4KtDBVEzWwfcEgWLfl+pXQpMg7BK26IOUegpJBufo6YnCdD9fhZg/al3?=
 =?us-ascii?Q?0xfDGmmZPJZLcihG2ccC4gAo1qREedBbz+5O4nhBZCksVA3NVhKFUwEKR8x/?=
 =?us-ascii?Q?Ds/104rQUIa+di+gS4XipUi8WGO/y5smZvQTl4k/MFKfkPtHzU5uJk6E2cG4?=
 =?us-ascii?Q?fxa8rWXggQhNWLGR0jWYBg4MURndqg28Pw6uIJxxuIGyYJ0dSY5T49MYJhPN?=
 =?us-ascii?Q?UB1hZbS+qG8aVJhUhUmK5Eaor/J9bm+21jaJIQYXuEPaols5rjubDelDsFyz?=
 =?us-ascii?Q?8sXpWOGPd6V4JiJKy2zx5ImQrl7kVFZ2DlGLVPWoQcstZ2uUJj4eHZX5stPT?=
 =?us-ascii?Q?Rm/4Ly4KIUc/swvd61717p53AbX0RQXj+PG6v/J1izSySuHND5sYKbQHsMNl?=
 =?us-ascii?Q?VuS315oWET1OMG5Zz04XJzNKW0CWaUjRfjpZTeBWMzd5I1L0jLigh2jglxSD?=
 =?us-ascii?Q?gq8HSzXKy3a5JIHCcxdTfcxEtgM/hLy9c0jtlkY29xDwsU5qPVGV5Qhm43yq?=
 =?us-ascii?Q?6RtWEQyfg4ovddxrcEsqHTA9Hr1yRQDlRRLdANLo1KOsftr23jKTeylidSWh?=
 =?us-ascii?Q?DfIIHZEXZ1NkJyWLjirsKf5f2HqsqvfNA4NaslKqOGrrygQmrzZMXaMdx9lC?=
 =?us-ascii?Q?F9a2Y+CTtURAtdpB6+f+WVT223w9q8q4NdwIHzH56THh1un8B01hWHl2ANG0?=
 =?us-ascii?Q?Q7ZERGNZElHs7QtAax6LmowyjoQtFqT0Ujouae7xF84JBYbkE0rS3/HkAFb4?=
 =?us-ascii?Q?k3Mv5Xeue6PAvL+eQaJm0xa6XPR58FJTIl7r7fd5JZQhi5PsXGjq8jqoeNgP?=
 =?us-ascii?Q?bOWNdHIzJvpmD+evIZZkSumY1bAuheqPkW9e/IMdmYFDKF6Y/hBK0Pyml4+L?=
 =?us-ascii?Q?WDovDqjqwS5aEIfOwvhj0pbB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb85dc23-a993-4ce3-02ec-08d8cd801afc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:36.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijMcnaZicrGWg7GAJoyR3So6BzzM8FcYr/eZAtaV+LrVqgOG1LJLCq1fWi6bQy9L+Uom5L1UOmFzEc3qfgcpHYm8NlIwJExpIEIetepgx1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds plug/unplug callouts for iblock. For initiator drivers
like iscsi which wants to pass multiple cmds to its xmit thread instead
of one cmd at a time, this increases IOPs by around 10% with vhost-scsi
(combined with the last patches we can see a total 40-50% increase). For
driver combos like tcm_loop and faster drivers like the iser initiator, we
can still see IOPs increase by 20-30% when tcm_loop's nr_hw_queues setting
is also increased.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 44 ++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h | 10 +++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..33c88eca090f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -61,9 +61,18 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 		return NULL;
 	}
 
+	ib_dev->ibd_plug = kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),
+				   GFP_KERNEL);
+	if (!ib_dev->ibd_plug)
+		goto free_dev;
+
 	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
+
+free_dev:
+	kfree(ib_dev);
+	return NULL;
 }
 
 static int iblock_configure_device(struct se_device *dev)
@@ -171,6 +180,7 @@ static void iblock_dev_call_rcu(struct rcu_head *p)
 	struct se_device *dev = container_of(p, struct se_device, rcu_head);
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
+	kfree(ib_dev->ibd_plug);
 	kfree(ib_dev);
 }
 
@@ -188,6 +198,33 @@ static void iblock_destroy_device(struct se_device *dev)
 	bioset_exit(&ib_dev->ibd_bio_set);
 }
 
+static struct se_dev_plug *iblock_plug_device(struct se_device *se_dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(se_dev);
+	struct iblock_dev_plug *ib_dev_plug;
+
+	/*
+	 * Each se_device has a per cpu work this can be run from. Wwe
+	 * shouldn't have multiple threads on the same cpu calling this
+	 * at the same time.
+	 */
+	ib_dev_plug = &ib_dev->ibd_plug[smp_processor_id()];
+	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
+		return NULL;
+
+	blk_start_plug(&ib_dev_plug->blk_plug);
+	return &ib_dev_plug->se_plug;
+}
+
+static void iblock_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct iblock_dev_plug *ib_dev_plug = container_of(se_plug,
+					struct iblock_dev_plug, se_plug);
+
+	blk_finish_plug(&ib_dev_plug->blk_plug);
+	clear_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags);
+}
+
 static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct se_device *dev,
 	struct block_device *bd,
@@ -337,7 +374,10 @@ static void iblock_submit_bios(struct bio_list *list)
 {
 	struct blk_plug plug;
 	struct bio *bio;
-
+	/*
+	 * The block layer handles nested plugs, so just plug/unplug to handle
+	 * fabric drivers that didn't support batching and multi bio cmds.
+	 */
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(list)))
 		submit_bio(bio);
@@ -870,6 +910,8 @@ static const struct target_backend_ops iblock_ops = {
 	.configure_device	= iblock_configure_device,
 	.destroy_device		= iblock_destroy_device,
 	.free_device		= iblock_free_device,
+	.plug_device		= iblock_plug_device,
+	.unplug_device		= iblock_unplug_device,
 	.parse_cdb		= iblock_parse_cdb,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index cefc641145b3..8c55375d2f75 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/refcount.h>
+#include <linux/blkdev.h>
 #include <target/target_core_base.h>
 
 #define IBLOCK_VERSION		"4.0"
@@ -17,6 +18,14 @@ struct iblock_req {
 
 #define IBDF_HAS_UDEV_PATH		0x01
 
+#define IBD_PLUGF_PLUGGED		0x01
+
+struct iblock_dev_plug {
+	struct se_dev_plug se_plug;
+	struct blk_plug blk_plug;
+	unsigned long flags;
+};
+
 struct iblock_dev {
 	struct se_device dev;
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
@@ -24,6 +33,7 @@ struct iblock_dev {
 	struct bio_set	ibd_bio_set;
 	struct block_device *ibd_bd;
 	bool ibd_readonly;
+	struct iblock_dev_plug *ibd_plug;
 } ____cacheline_aligned;
 
 #endif /* TARGET_CORE_IBLOCK_H */
-- 
2.25.1

