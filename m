Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0941BC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2FB164E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhB0ROA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhB0REm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxaKI178656;
        Sat, 27 Feb 2021 17:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=uqxM+uL2hAt9v/fAJSZa6EXNMKWkB1Lw7Jcqu4332R7B35BT9K0Gt0eT1wbDecJvoIQu
 Ayv2ZUqGSWPc5p23zppbo/1EZlGWMvlo0Nhp4NpZ3pOxEI9O3H/6PEgf9lTIJ6RDUxu/
 sww3POiTa1tS/kQYFw7MYEqrIEYsDJxEiFTvpMT1nNF1SII30M2FDdem+7dOvN9T+1+/
 +8IiLdgl/mlR6z+Knjv5VNFcfxTGvBXmEC1njQtcRSx39yCCsvZ4HgFFjJkFnwu++blt
 0ntLgb1ZGHKFWrOCbViSaUgRxb1vyFoHR2PkyVtZ6ln9vBFGHKjgu1iOvbM8xnMCtrVu +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmrptf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbk173209;
        Sat, 27 Feb 2021 17:00:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwQufDyD3kQaQxqfIO9BWD/4wIEMc34E+P/26l1mTTuaWX6pmzXKg797T6RUOciG9gfAd/DhX1qysu6MsZBvLzfwHSi5Hqr0B9yxnN4mJokPSMne7gzBo0S6d44BQ0wEB04RR8Sm10kI9VQUQL8ovK1h+06i3aNEtyHOeRE7eoOakDdewaClR6+5+/Agr6mnilbn3mnUqMvk//CCKF2z/Wy9StADPoL8IvSE6n4Xf9XFP7ubl1/MyFFFAmLK6Tp7WLrnmvbynXuJAqXC7msQjtnIGzHV0+ltBL/+d+XJDr74wxhz+nckbuOyPzUgECORRtAmuXZsytVKvRXE78nzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=WpgBWOXq1GMzIX4MRSGd10yUc44TrOv9CsXBJYaEdiu/mFutZ78Bwt/za1I6Y8tdnRrzhjCBIPkE4MBtUueoTtsS37H2J1dmBsO6G/YPeCsN7wgB0o0F/Zh4lK0nuXoQUHW/WYnU/cEFIIB66eF1jpRqJmxE53RUKFN5Pcr5cl87BSORLx0QJg8O1z+GZqZGN76dz4059258s2toOXy7ILdli4HDyQTnRtP5ljBUeGbqOvuBKN+LZmL85V3oXFiRG8DAWdSVZE1GfkgeLq6re43HFSv3rqhH5nwaFNkq52NJNU4zu5xKDeHll6hQkOzqtFyKiaWfwrX7fa2gDq6mAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=CqxX8rCQSg7Hxzvw+JitivLqQBK5Egqw0QPLg3rk1XY/mDX+sIICoNs5hu1LfsE9+q7HY/tLdoQLzosNHngvnOORtCj/+UxRToUGNiPvruMmeLhHnYal8VjL9nRrZ71DFSeEYbXuGIZhDdMs8aso/XdHHvH9wamkqeeZhLZQHII=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:35 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 22/25] target iblock: add backend plug/unplug callouts
Date:   Sat, 27 Feb 2021 11:00:03 -0600
Message-Id: <20210227170006.5077-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d83b05b8-8fbb-4724-2da9-08d8db4132f4
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB253807F49208CA2C4AD2FBB3F19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThqF2E66ftkRjIe7j8N3bPZu0r3093iPbPkPAELk8xaFhbGwG94Dg976HeVlejuayT5f+lQS4i1gPEZelxGnBRHZuJ0KEVS6GQlYQcen8FMyoJLsjOKDSK6B8dudjA8qZwyLCwfJRzF8K+3L/9880n22BbUwCsROkfPI7CH6Xe5jNzvV1FJvQ2dne2/sIl6FdBPWkc+U/zY8xJHAnxqBdIXD/OUYHrlO1sJ0mY18tThTVRPHEjVjhLnVK0S4nj3RUUcwLAgQ7TwuA5KNeiYVqUxSez/G9k6U7z7unUr0lZW2d1OHubL9p3WwGXvBRdDAsPxklDdTQBbUwRUdf0OgnANmUcJoKG/kAYimkwLYbCdX3wuwKi/PzJThSjDGQG2mrlq94BxVv2M+J24eGkapKOLqAjPcS4gpqfR5ovRuAIUe/3yQOveXx0zG/CRWfWRJeRQqsIfqaqeOjtxk0kGDswFFa07o1GPFiR16Xm10e9e15HHOgKPpX8XrtUSLFYPH9qKChKGeghLgVHayQ1nVyOzT1azCQ8asVvRl3nZF9d84un3lKr4nYckZ02520QWEMBbLZLjRKKr64qj7YUVyMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pmQ7fGHLT/GFIVi7GJLNt/oAvZTAcB+2lcAsbQLJ7kIh7cJspFGjO+EulfuO?=
 =?us-ascii?Q?eFUavc+q49Ize2GvyrMS5PLY+wol1OeWWpb1Gd4/Kqk130roSL18ZMR450nP?=
 =?us-ascii?Q?Vv+J13MQoJPa3vWQDJY/Kyhwlvqt0/G0B9L/916h+u0CeGCFnR8NOvTbumfn?=
 =?us-ascii?Q?f7xhevuqfTDNZvHmps/MgS9Bu94wrQmSz/EIGn3ePkiCODv8uC28a+z75flj?=
 =?us-ascii?Q?i2FFNhBze0VuxAcBAx/Z3F5hqG9uhXouLumtWGMF/xao0iN95GGEr3i0PanP?=
 =?us-ascii?Q?M1dnTSbJa6EsIuJkpTuz5nwiwlFqFv7bFHW5nSUgqJPeygIvNu+6vYixVUQH?=
 =?us-ascii?Q?+/bDAvHXR7U8I2Jc+cedkiYvfx1XxoiN8JVF6QwuVGRJXCHfHql1au1L+GO3?=
 =?us-ascii?Q?MyvPfTjsoSkXWsNWSxltIFpywhfvBpFCNEibpmCtV9KXeyEpwMkfwtrWA8pu?=
 =?us-ascii?Q?QRUXZNrSDaGeDz2fRrT7qMdH0eDNPqq0BLRiMele5UW1nB0Pr3TyjbkvQ4yt?=
 =?us-ascii?Q?2OjUEThwpYKusPibRellFe4ctTtxtKG7LiKRzuld1REgbIvye4mXFE4fF7yk?=
 =?us-ascii?Q?lY9edg9vC87+67CoqeA8LhoKToouGRpPvyT0dN3ncnbR/Djp+cNRUuA44qGp?=
 =?us-ascii?Q?kdXVcZ4N/Qss1S5brwWZ1JLbxGktWpWrTVWCCDQMMlvW89/NIQ1sKWz30RFT?=
 =?us-ascii?Q?z5CsuycSyratPweykRyXhj3+jGx9Mfqb7GOUbsxuv87OgGni2BtvYAyekh5G?=
 =?us-ascii?Q?wOO4WzeGXcoMFgMsuapCXTr1N7KY0ZIf4/eEbyBTP6OBlf/YB3l0pIHE0MfV?=
 =?us-ascii?Q?ArMJLgwY9d79zO0PRUgOLllZeiu4Q0JELM+TzxG1debmbaSqWsMlTqHHsjww?=
 =?us-ascii?Q?S5BzwnGmGHZY359sDDZbNTcVIi3Xz2L7Xc4MHDi5Ijv2AqZvoD75D4x9/6J5?=
 =?us-ascii?Q?hVQ/D88Q2sB3XLkXeoiKyIhNd2v4VH94UKv/VTNPxK4R5fed7esHl2T8NXsK?=
 =?us-ascii?Q?0Au+qTKiqAxFk/qqve/5QJ3LWqX7SUhQu6thBs3l1jmAS9KL0dKPeb2zS0RN?=
 =?us-ascii?Q?BDfi8Hnb8bQ1sPjBoYN/gKgsvR6HP+AJ0mRh0Pz5IR/St7EK+FbIiTL0RJ4h?=
 =?us-ascii?Q?fczX6xn7obzNxJQEwtS8/Y07XirxjkBq9oL4Xp2lXidvJdsx44geONztDUfc?=
 =?us-ascii?Q?0x/3yQ1InKEIXz4zaCa99lmVwhgPKkA06KPJ3kFxGJEoTiZU38l9UjBY+Lg5?=
 =?us-ascii?Q?h3yQFd1D3WYmn4lbHfEtAjTumjFMh+g43NsdE6SzCWvZdOpZ60BK2HmyrkrZ?=
 =?us-ascii?Q?OvEZbeMQIT2i6ulphJhOPWUt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83b05b8-8fbb-4724-2da9-08d8db4132f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:34.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3nBQyYTl5t/LbwP5ImalHmpw6ob8h0gOjX7vzUayMlMbJVeMIeicP+rmPSVN81QFLEIgg9/tvP8twQlDvBYzmskLtbS0ym8a+tdBKh9vPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
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

