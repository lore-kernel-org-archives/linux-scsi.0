Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3257C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88A164E6C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBLHcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhBLHaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P57A016723;
        Fri, 12 Feb 2021 07:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=RMKUP9acNwEt8OiYbdJELk4qwh1hItm/OpETMB3QN4lHoy94Tye9l+C80H6Tdnjl+EE3
 /BBbKkEcfYuXam3nl5E6uxS99jxiwHbirmwD5Qm49nvXwCW2vw7lPmyx3P1NgwTFf01N
 Y0TdiIYgNYeuKK3VzxJBF5+FzVoHsWQHa1Km4nnlu/ALDT7cherxk+So4yg7jI/NbvWe
 YiBRteE3k6bnGPIBkVeIRr7Kw2z7Vhy5QNmI/aPoF3zUoSHCHWa4faxRuA2LpJ8Ku80Z
 c6vG4RaMsf1NgOjhAP/JqZrorwhTgwg+0ARwu0xNba2KCa3DElfArwogIRGZx3q1seve OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dvcuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QA0W090287;
        Fri, 12 Feb 2021 07:27:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3030.oracle.com with ESMTP id 36j4psn5w4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpVePgyJFJSlnoXjIckIeTo54U9rleEgIVX7iNULYPdtKAhjTIZP/ZDyvkA55Dn8Aj8oqkQ0NcoMFrT7vNqjJNdlZEo28BQTuEQm5LEnhJshE3l1HJims5v6jPDRP4Ga0BlsKEo3TirVlHnCa1Up9SxOSTRQLzOJcpsdf9dpzly2cpQdoOPZFoaRghWuRmrcMBG+1uB/af902OXBRWO+k6WjlG2fUp+tf67XdaYwVs6p/Gvrvehu+OJ+9wd+NUU56Xq1HNcn5ZBHG1wzaDoRxu+WbXj5oIBNAMJfPpQOf25tsgx2umMDNMpl+5eCn5rWquktsF8gBZwiPprQbxdIqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=X8b2xVSK5pWWL+3SwMbwQc8sl0AdHh7cz3zuuxGftiTTuTjFUrNa6hVA1Qvo/4nFr4ykbdy3m7e7p/cLTpdwukRC6G77OzkSJclXN/Z4TPzUk4fbjZOQQrnUGTc49DJi2b0GOGPk58ECQMJO++uIMww537tZHCiY/2ESPdiuzsCVs6h7oSzAn9CARdalmHpDo6pwHFeQobj+TvpGe63hrAjSK7C6bjpl0qbdPAV3tsDeIDK1k/QBS2Ug2/OBRuuIOMztroLplvAudysx3pZFp/RAMXO/sG0MDe2nmPrMiKxSMbRI7RjcaQb42Gb9aRqNHO/QqxoGmlbI0Ft3/o/OtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI7pVbjPpUYMdhGnmWZkin4Vzj3OtMnjwsUvl1/w24=;
 b=W7JA9dvGNJAQDasJLFyRTH0Z1SxSwF0DOVkrhUem7JzaUv/aWd4C/4Xx8rxnYPyC+eeEndzSr/9cWPYvOvIQ9Sp5uUPdFFF0YD73BIOrFXpo3XAQjrHJraPh6qmzJ7LuzB7A7oPp3UlhsVohubAZq8/bbvkxG4Vyn+DgTX1tJmA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:15 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 22/25] target iblock: add backend plug/unplug callouts
Date:   Fri, 12 Feb 2021 01:26:39 -0600
Message-Id: <20210212072642.17520-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97ee0b81-b974-419a-7624-08d8cf279ecd
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254EB27C804660105A3FBE7F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmyaP7XudJQHJEB2ZdGn/SbjeGP3xAaJNUn3XAaR97oo5tgWIs2yxlUwGBJtk0qpbCtCgOfY6JCBJPvyavhrx+s2c1AJGU0zZFiTjmd+Bl9vKvEYQ/NG+kULiTTHmM540F4MrDGU9cfXLGheuGvSVRIJ12+CeJwmIqXSXISELybdbTOnPoMdTjZFofWEwfdbGICZcwbE3aWKCS/v9VW+BY8LmHDzYu4C8Ml6wSmjHfNqrk5QZgYLZQrtBtW+1oKN7tRQMYyiv+48TxJY6kbCI+i43+GuYYD5R9FF2LZYUYJE+clnyj5DXTSZPB1AvR9VyxebD0fmgQDcZv6BH1Rj4/2a9RClUmUy/gI3tu5TbDvGepsvAnpNm0TxVat1/lItq6XDO45vcbEzCLeyebiD0r6gt4w5IJ0utrp8fv3clzt0Uk5qOQjXBTUIRzRpZCcHkRVi+drj6zZQlBANGa2AzYpQaxduy8l+nwBM6hLRFp56KDjjl+w0h3o58b64Xpqi/qHZUV+CS/f0t277aMx1yzUVj4YwveKZfU8ZHRNTpCv+2M0kJX4yRMM5HvXE0xDu83MyqEQxrQ19ByOdFicLuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1fhuh6yrO3lzYnQNIibBYIqoXmh5xI0WrVuSDRkCuxq1QmNnBuXwt6vmQrBO?=
 =?us-ascii?Q?7XA/vKELz5Vvgdc+Q+GQEAfAlaTH652UlCC6Iv1glGW2sbIC9Xge3lRygjCh?=
 =?us-ascii?Q?Q2Zw+60c2+IXVT0oPflKpZc+DKMaf0lJgUO9Rml8GIbAJCJz1+cJ8R2keL7s?=
 =?us-ascii?Q?9tPAhwlLT+DJXcewXbZtWPDd2hgNNDUifoeb+U85mlopur1h4MCinjLPcNT4?=
 =?us-ascii?Q?z0pRUjzO5aqlrklNFuNqQwDhNORQf101aZMHHAB7vCyUFh13s0ir0rtTCWDB?=
 =?us-ascii?Q?Gbts+J+vlmzGeQKEqXumC3IIbo3CYxm2KigefoWvmQKU6FtQUmAUpZpfjBla?=
 =?us-ascii?Q?EvQdBNG9FkqHVJBvyhnIggTHhd8T+zbJIK5XWjmOrDM4OwhRCevkv7EvYVs5?=
 =?us-ascii?Q?h9xLDf9lukDf9EfPkpHZEfShtdcKroJKSCLvQ/EUfqSaJmJr+ba6yYdNlY4z?=
 =?us-ascii?Q?v82JOIwtL1d2vNvcBLq+VK08uK1v9C493LpWU75US1nugUh4cuIen3twdSgQ?=
 =?us-ascii?Q?PAVugiQDSi1rQipxutZrrv9Tw7WChH5UDqVbc7W+OY9lfbFZ2H5+ely000TE?=
 =?us-ascii?Q?6+dqXEeN85xlpJ3e/s2wKyYZfqf42mPgtVfWMWiiaTnXX6S4aMCzidvYobug?=
 =?us-ascii?Q?y5fyTAIN34HHJ9Ls3aS+pfQkNrRKO2lbzT+1+5ifYraoO2WMtg5NAy00+SXq?=
 =?us-ascii?Q?VDFdO1HvSOpxISR6u+eJ0LpLS/NWmDCzvBgrztt7JivAwRpgfoQF4nzXSRsd?=
 =?us-ascii?Q?ahidw70y+yzMLUYvHWWkKWxNyzRlMA5bDmc+ISzFMDgMmAVRdjWJLorkcuCD?=
 =?us-ascii?Q?YfZrfdzqwI24vgpZspqSS4gyKigP1tV4S71Y1dvaS+A+hy0r7639gyyxm1sZ?=
 =?us-ascii?Q?UIFBvrI1Ohm51gbUjXvArYN8xW024NOWvLaaDW6Ej95ShLKsX4txRKhOz0iA?=
 =?us-ascii?Q?mDGJWYpB2QQIRksuziaIlv18V8jqiuA8xrzLiUf8e8W+yrqPojIcidOeMKha?=
 =?us-ascii?Q?xuJi9JxdLwn/DmwEMgZjgw0n+bPp6fqhcid31/krgdDhYnPr5jejq6LXI3A6?=
 =?us-ascii?Q?1WArCI47sENO/28b0edJNkKHf6JUiKOD2BMPpHRgmThUwVfgDt8B2AM+qQJL?=
 =?us-ascii?Q?I9A1c3t04dU6IXHMi18ldAuSmPBp4PFJe0unY6ZU9ziaQjmIFg8wMWgOo/xf?=
 =?us-ascii?Q?x87pQlJvY2W1ouI1ZAjcVd18zpVJbBxLyRpmady2OxgfhykDfVyhYGxRodbv?=
 =?us-ascii?Q?IMNC0ZKIePiEuxl7ZKs+8PqPdt6PiVyuuRVgKIoNFefe81EjnTOiW6QyRfeA?=
 =?us-ascii?Q?h00JvZ/IaTw1q61u2qhJWYXn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ee0b81-b974-419a-7624-08d8cf279ecd
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:15.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cpy8qxPGbsIlyEyzBQJ7jjb1mshjHRgjxy9TaKyxw30mdApppNRoLjPurzJfYxfJiYqW8v08ZLpfHK8Ihizra8nVVRM7uSLSH8hUkaiUZjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
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

