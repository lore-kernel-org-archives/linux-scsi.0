Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E61C43333
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBDE64F44
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhBDLhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54404 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhBDLgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYisJ124256;
        Thu, 4 Feb 2021 11:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=lHfIuCWnyvJSzhcGT5VKdD40jqEtqB4CXS8mRpf4oGY=;
 b=VfqUq/DbHvTHueuszQPwrB9wkISgyoDqPhoJl975zPaJmcLGhf8a2cgTmrYVpFykCHij
 Cv5nMfbmOZhNJ6AZBPD3Vfrjrf5Fep3+wKBNctC/x8jKDl60REIfwHdUFTPTy89sMtHX
 CBJRM8JzVblCWZL0UE69zdshqW4/mT0ufMS38SOzi0lnhAJ0eNrNPZPmTQslcwi3ALwr
 KmIh5iO4ZQxj2brwAcmALU9EWHOKebKHHss49tUCIguzbPKF7hW6fRsrvl69hp1929Mx
 jxo/wI08pZDSMtETFnLePVY0WWMoeekQnH71wP4iOwADWy8JVbakbtMvqGGyNh0ObzDN ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyb4xs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ6am187848;
        Thu, 4 Feb 2021 11:35:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36dhc2jerf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTVHyFKIn8bDLBAajDbrL5kuhxHoj3FdjlXhzzKaBHpUFo6oBnIaiCSwxMkJt5GJUcnVabHQo6WRSquBXsluS/ZXPSbMz77JmSMfMnHti6D6UpfBKWZhtsbtpXC21gFu8eWis+Rzw6VMxs+1Henteh1U47uNwUKZ976VP1Om1sd3sBVhLwc7n28N3A3xEnsF6elhHKuHfkUWijyFeCSFZoXYJ5a6yGrYqMdYwljGXzWqTDQn+vPGAgQtxUlj6gKyW/6wUAnHLeVxrJnKWmcaq20mIrfq4NzmY9ESITyR5pXqLAGSHjDo+VG1IeKJ/q9yrQsNVzkJsSS4M3Zg9MyM0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHfIuCWnyvJSzhcGT5VKdD40jqEtqB4CXS8mRpf4oGY=;
 b=GUfiO7sYCANUciPSA12w9qeEOOTZq7H/zgR/MB9yPwkIjCMr4qKv3M8Fu0wBTOM/MOYPP0CVcLT5itu33Met23mi2FsVOXSqggBZadJGNMq6UXb4STepcwmXlG6/oip2XvA1opVCTIJVGhIaol9kD4laMVu5XrbqoBRprDQvwdySSiZeIVLnwxtrXQWTYxZry3a+Ikra/4pXrXg9QhJoqcoc5Zm7ihpxKefz+lLX8BfM0Rek3cFxxk3eTQyBWmQtRhJR5/KwhjC2PIxuuImM8tON3wdDCgUtiBCMmripPejf/OAoh8JWpQY5iCwy+xG3yL6xs6fOZcUZq7WILCh0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHfIuCWnyvJSzhcGT5VKdD40jqEtqB4CXS8mRpf4oGY=;
 b=zkHIaRUzGar51zCQqgwqPSnHMHbn+Iou5M0Te6MFmjTgNFaQGveTZHgAz55RekGdhD4r0oH9e3qN498O5cCv109f3XYec7HaJqSPtSVa5e/UfItRw94uAN1bJO5Q9HzCR/qNeDF47YCMj+4AMrX6LUXbgkiz+6pgFS3P5FtpK1k=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:33 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/11] target iblock: add backend plug/unplug callouts
Date:   Thu,  4 Feb 2021 05:35:10 -0600
Message-Id: <20210204113513.93204-9-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5962df66-96cd-4d4a-793a-08d8c900fbe8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480795C5882C3F178BC581DF1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyBiK8097D/zOQ9Q/WxdiXDOkweXQDr/GCqzS0TCW2GwL4VnhuFDXFVZMrmI3lmRAWI20yKYnF8rWmmuT7h4uqux89AxssXUjz2n5DJO/8Que7GCA9FwHgT7X+uawbQlfTYizEfHvCXDYNHPnvwPCOUbGdssxlx7x+cPch7U/Wj5XVIxlg48bheue1aafMJQtBCS5vmL3LXQfGSadf0NS5cRLJf/z8yi/HT4RHyHisH4RR70J4naaqafkN3aO1iBOZwNPtvLa+2GxATzXdQ6cEBUARvEV0FMPTv+ZDBmmYTahN24JOD0bUfL5OiGPt2i1naWa0SM8FZ5EFBqQHx3HYFxYUHQCIlvdWiLN8cei3HdjDZluXwRozdhj+mZnKwpYgrQrlgExbn/3Doim0Xy0m6A5O7F9STI8JZcGhCZTpyAEcLJDlsZqyVCIGxxSul2K6W4VzU6/K99a35Hg+ln66UJWWCUGiqgTZKlDUl/FeVJ+/NPnGnXpduIZCQpGpdC39vYMYccqbbIAFQP1k1S41YNkDVQjzBHXukf9IwvDHKb5cob24HLQeUnwYEvJGUw9XUiBb2K4iDY730JTBl9jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uJnBLnS+PNjJmHS3+bwCAH1HmExZSMoOvlQ1IJp6G9vlFiCf8gIZPJ11iMid?=
 =?us-ascii?Q?54opRFUevLXAjrGuYc/zdYUJFHSwKIq2aYLDS6uob7ck0JpJiEFgn8kQC7tL?=
 =?us-ascii?Q?7+8/va3/iEFXz7bnrUF+G69hVMMuM/eVnTybJvxJ3eBUXbH0fwitgKnJqgWW?=
 =?us-ascii?Q?VrB9nB+muWn3jSrBFFIU1ajA5x8wPLEpX2+492z1Oxs2lS6gzggCGgSY43Ks?=
 =?us-ascii?Q?65qCo/0biu2LD3GMSPuTJvoDJ5C8a14UMWwAm812RpBX875m+Ckce5GXoB1c?=
 =?us-ascii?Q?YMTO9VIzRwOa/UDbFwUis8LNu5obBs4zRftAIeSiOGQqV2T21N4BECD5vLbi?=
 =?us-ascii?Q?ZW2MzWmoQRInC+tFrQHn3Oir4k6ckdIXdMK6g+pvgwKxRyiuYde7NsyzX/h+?=
 =?us-ascii?Q?3AUxZ7rN3HgVEfs1F9Erv6oCRSmN0yPNrU6oIta3WNwWslEVBa3Um9FfRndO?=
 =?us-ascii?Q?MBd7MRWMVCjSFy/sFmsUbQWtTbQjs2uWp4+S6f76tNnlg6jMlsGZ3EOc2gyj?=
 =?us-ascii?Q?7vUwTPlgPE+vAwbweNKs2g1jZgCsj9SuXzxPszCS+O/IfkviChXC6faO+ton?=
 =?us-ascii?Q?JUZ7oqRNtzfJzx3rP2B1cfS3PPI2lnRZjQUnVMELUZihHvvzmNVIplTMAfhh?=
 =?us-ascii?Q?dxzDLuA2qnUQaRKHKhrfx3/m1UNUKojfkC2bHW+yXXhPtg73UddA0t8n6peu?=
 =?us-ascii?Q?7QX3tN7XH2Cl/2CF/TKr3lIwJvt7Ht5dlcYQHSGFdNU6FFXiO5w6R8xS7aQk?=
 =?us-ascii?Q?ZtFtatthv7a7LqTMsn+KIiQmIJi+sQfShOCASTSUNdKME9xsEvWbDzPul6XC?=
 =?us-ascii?Q?Yi8WQ28B3IJ6aYAgZwLfbgs6XZrUzzvkbqNbaSDa50vnkoxFbFBU0hoSPaUw?=
 =?us-ascii?Q?Xl0TvU/tlblDRdx+LrayBNDt1H0Zm8sWxJ8PHJ8MuYo/80B8UBK7lD9y3oQM?=
 =?us-ascii?Q?N8SnNBmxVGR6zMGy/xc+BS35iFtq9uyiIxDDCO0ydTnbiKRaxAWGASE7Kdq4?=
 =?us-ascii?Q?ZJ4sS3ihBStLD4pxThSWwFhbp5o8CuiijfuTtmZBjfJGK2idb0Kq7Oqz6pdt?=
 =?us-ascii?Q?acvz5hH/Us4V48NzSpjREi+mpCJo+VJLauJBHilj1xgQLPDfoj1ivf1Wvr3K?=
 =?us-ascii?Q?KG8QGGbILyTtYlQ05e5do98tvKLLWMmkD9b1APBd9POo6K3hV1r/r+KCuqMA?=
 =?us-ascii?Q?Pnlby9W9aEWgci1f0iNjV42ArURmZSxho9Q8H+j5wSODRmf7vCGVbIyOQYkl?=
 =?us-ascii?Q?JM5Z1DAkKaJ46/NhVdRjPg+UUVEJ9S2KIuZN9RI4pX+7f+B2E+WkJ5xuGo4Z?=
 =?us-ascii?Q?JcbPMa013WFj5RdEo99fYMks?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5962df66-96cd-4d4a-793a-08d8c900fbe8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:33.7803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA1CT+clKhGdVFQ/KIsTJUP9jpwCoV1jsysxzZ+YvLrmwFQNnOCiH21ULkbex9QHkQcMj2r1COzVVuNvbW50ZoqWpVHyG9Ub903cKDs1A5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
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
 drivers/target/target_core_iblock.c | 41 ++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h | 10 +++++++
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..a4951e662615 100644
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
 
@@ -188,6 +198,30 @@ static void iblock_destroy_device(struct se_device *dev)
 	bioset_exit(&ib_dev->ibd_bio_set);
 }
 
+static struct se_dev_plug *iblock_plug_device(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(se_dev);
+	struct iblock_dev_plug *ib_dev_plug;
+
+	ib_dev_plug = &ib_dev->ibd_plug[se_cmd->cpuid];
+	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
+		return NULL;
+
+	blk_start_plug(&ib_dev_plug->blk_plug);
+	return &ib_dev_plug->se_plug;
+}
+
+static void iblock_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct iblock_dev_plug *ib_dev_plug =
+				container_of(se_plug, struct iblock_dev_plug,
+					     se_plug);
+
+	blk_finish_plug(&ib_dev_plug->blk_plug);
+	clear_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags);
+}
+
 static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct se_device *dev,
 	struct block_device *bd,
@@ -337,7 +371,10 @@ static void iblock_submit_bios(struct bio_list *list)
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
@@ -870,6 +907,8 @@ static const struct target_backend_ops iblock_ops = {
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

