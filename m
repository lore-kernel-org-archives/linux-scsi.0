Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD0EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5E264F45
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhBDLiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:38:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54144 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbhBDLgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZabO085641;
        Thu, 4 Feb 2021 11:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QvHfCjMXWF+ej1Mva1HpJdfSYxFcxh9AkDlgaYiKMss=;
 b=P4MaXXhj8CGERkKf52W2pCfGwxjy6DLJ+Te3ahwdaS1G3ohmwehVyY2bv0cOep9Z1sPa
 N6BKIunoe7dL8ETn42JNv8csbW/6Jyo9R4XhSlJdR7ldgDx8b5ApzXsxChco8xJCGDgd
 g9b4RQXAZiVWJGYGzjjSE/oumcLOV3C/vj0UL7Biamfk+0DRfjScw7LJyXVvLJlUHVuZ
 fYK/siqoqjYdPkF6LO8g6qX/S/IRZfoD29mlcIt4X05rF53sFOr0D/Ksx07VDHE+F52N
 2kJe0wvyKlaS+J3g3TSu7qeKU2racZ0a8aJ58qGsH0HpCgCawx/CTNvQYS0MFER/klf2 hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36gfw8r08t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ6al187848;
        Thu, 4 Feb 2021 11:35:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36dhc2jerf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lacfTYKRX35PPaptZTxIwwCaAkblRbVKin6gEz+QK9/p9F//4jgJf1aVL5DxjaNNpssHM99RdR6fQIIrzq2EkpObrbEfWWAQ/JwYGl4tdoMchRv6UkwQFPBIXzK5zqsnB/Nf82yq/ZWFw03GDCMxSZ6PWXEtNIz3KPbKNn6LxPrnGk+RVp7a8EpgKfBm4Bh5k2j8K38PO9o4DnxXS2+CItg22ye8K856to6aGsYKMMrVlOhPMmjSXAz/E204Miwd1fMeONTTINI3XcxLB967nRb60brqxZzQC5tAlvbhD8465girusb1EYu2GjkL6iBgIfROPUxGcWk+nWIzwN5tBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvHfCjMXWF+ej1Mva1HpJdfSYxFcxh9AkDlgaYiKMss=;
 b=WDsRmsi56Z87aHtqVNwoBR+7tawu0lUqCabFrfNzX/SApAJf8ixKYupSzcsPEUN/o8d17Iv5iP/rU32C+/Suk6bXJDQWTXi3F1PjgZVn/MRkg6QFYWIw00rBmLppmJX4BLAkzACfD1Q+lO6/vaIgMVzLsuHAcsy1l+r5pkCqcTJmQHo1QoGPB64deRFLgh2g53fO041dGuKAoBGqhZE879UyKLsuM5/u3mE3ky4XNr5DGvVeBD0JR8CKuOVCysef8fKk10p7xRNSmQf1u6vkY0Fm+OL/E29wGxRBES0wmG2ZRSZwOI6TO+IzHTkoVdT2HlCbJKSSGGU+dTm2hGU3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvHfCjMXWF+ej1Mva1HpJdfSYxFcxh9AkDlgaYiKMss=;
 b=tykTlxZnuCE9n8v0XH+mwXqz5XxhhW7TajRiAz9iovSFikgn2+VS4019ZhEi4HNzhkk6YpInM42CSVBf1NcQ/7m/C+QrNa81uqZI6qy9teoTlP+vx/YA3aBml7ArNF8BAxV97RZbn1BqlLf4GTV/EzTEmHLvDlJhgOkLtJQfiNA=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/11] target: fix backend plugging
Date:   Thu,  4 Feb 2021 05:35:09 -0600
Message-Id: <20210204113513.93204-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5237766b-0125-4cc9-ff84-08d8c900faec
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB448089FCB9BB758E5495954CF1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNQOQGhx8u7auVA38iTn5f2M/T0avnPRm9M6Tlfv2ytRtIX1qZrOjAa6GCsg6GNn9ZITWzuDXjtZJfP4L5DNep03EzpmjB486oVS8N80XcimeZkBQJz47JqRjWmJ0zIItvS5X37NuJxlJ+UMBveVuAGDSZ9zBE9SXbdPQBHvR35Lai+Ms1iBLNtCAtZy/GQxK9OrkC/OTnOs9gjiwOi+LpWdMyndrcNh6pKRwd95pczY4JUjf/O9L4rHMZb07edveneZHCDXEtnMaXBeKgO2N2ESLzsVIDZVYBKVJoPfwDsOFzN7rrtby84y99+8NDtx/4jVuMbMmO0i6OqufZIquf68cunawFQZDF2Or9V1lYgUPjddMI2p1JgQPbORFVqh5oIJfFKRuUK1Vx8M/BtsmeneU+6IHVh2RGqGX4T3FkdIizxA9RHw2dlqt5lvtZoQDWHdGmnLQO7JYXm+5rMcU7ilyJ7ZjGcQthTMvIfRuaUHVVMjX7y8NyrsCNric0OEvTMGrzhIZvTkVQYObTHOmC16SGQW+5kiXLg2tlQeON6nPiXwl4f4FlqM22aoJXlveQRQ6Isp6Gz7f8shoEQofg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cw40RNkxqxkVI6YFsVs8cGR5BUFppQDrhZufCl2EUDEWNkxj/PWxy+Hog+vK?=
 =?us-ascii?Q?DL7c7q85NEMLwFS1fMg+MamyeC3ra8Jk5HkSrDkCscf59xwzWgCBM1okPStl?=
 =?us-ascii?Q?PSUFam98aBK5A/oCD8JbctR3+2z0I91yA70QzpwrPHaY7koli4lEZ/mo2y8q?=
 =?us-ascii?Q?Mk3tE2ItSrX6OVK9mj/EluUKWeuVhZJs3iPtChdibl8lZ/0Rb/9vjV/IiaQ5?=
 =?us-ascii?Q?YlRohu/1VeG1N8YEZWduXSqWxdDvklYDR7+/S3INLtmzNxki6jeForWjUP/B?=
 =?us-ascii?Q?+RTwmsvQQP5zjikYFFj6gIGHCDsT2ZatR3x/TeGKg6A3DxnGdg2VElnLsN+O?=
 =?us-ascii?Q?61oIiB/uCbP4GIxKkwsRV1sTr6j3v6xuHSNtyNJiMN8w604I09HOEIvtMBda?=
 =?us-ascii?Q?F32u+1IZx60uogFiP00VKkeL7NAUoztYTH73yODnZnV3gLK/s7LNv4z95FQ7?=
 =?us-ascii?Q?U39b74agHkZJs89A4ObdYryokHlKBNdmKgnLfZUZrkNdZTUzLiNs7xqLnTBF?=
 =?us-ascii?Q?Y1Xfi0OhfZS8QFqtuCo2uP479ofxJddtzZ8bK5swS4CPz6Y9NqKEYwAYRrXq?=
 =?us-ascii?Q?KvI7gIA6n1zILv+0xeykE+K+fbIJjQtBjaHatQNdzn9laP/EoUyrIeEiiP4h?=
 =?us-ascii?Q?vn+Gy89yhQ06YQYsTmTM/nGpKvJPmNiUJiUJTcJHMPVwBFwqAvpK7zAqliPM?=
 =?us-ascii?Q?eB3qyfWWUi9YxeNI/oinujA+ElPyrGImz089+LiGNTQXmONKK6rhfPQA0sVT?=
 =?us-ascii?Q?gB/SXf/X7IEtv3eAEBH9knHuy2PtSntBmPM3WZu+sUcn/C4d6NMsdxaKonwt?=
 =?us-ascii?Q?rnhCV6bGezIf/zFOV6sEw9+YSi9RCRXNFhR7wktrx5O8mjC++nDuBe5nxrkM?=
 =?us-ascii?Q?DZBn5KizfMZvsPPQIAiQ7qlLH+TV7WTvsIXjeXY7Ph74JxJvShQZTRd8pbNT?=
 =?us-ascii?Q?9h+bedtxxrRMF3QTiXrwNnsK+2w9ZCzGd35wIyaVFl4t1TKPKYrgE/cotzmF?=
 =?us-ascii?Q?43n/0T9KGqGv30QxRD4qaeWywgYBa5PULNoCmGLfGdWLd1/i5nj6MWobw3PR?=
 =?us-ascii?Q?hMrPfFN2Zib4x1xhRG8vEaeYYJIbegKwbApanJv+S7BhL2OY4g8eFCtOJSP7?=
 =?us-ascii?Q?LKtShCjkMz2V424eWKY/n5VTAJO/E39WResvfVNvhF8+5714rEUj63avhH0W?=
 =?us-ascii?Q?Fi2MURsvQ59sULGVglrMfL/fOe72VLCHZjJXKUxMftiaWqJ7u30tNRLKZ9tn?=
 =?us-ascii?Q?TaeUTKRoB9troTuKV597ToR4OVyT0TGJMwnlWhJ6GExMYQDQkA/BWitITK0/?=
 =?us-ascii?Q?6SST7DgzJ5IjXS+LrsEWNY1o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5237766b-0125-4cc9-ff84-08d8c900faec
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:32.6380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RavrIg3F4/KzvTM2dWGivxvINc0ia7WBAhxjJfRUUOU2SBMZBCXYzBjP+SMZTObvgF9dttAGtENz+HyXERxrdUejSPSquJnOkIkMKhJ4vLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_core_iblock is plugging and unplugging on every command and this
is causing perf issues for drivers that prefer batched cmds. With the
last patches we can now take multiple cmds from a fabric driver queue
and then pass them down the backend drivers in a batch. This patch adds
this support by adding 2 callouts to the backend for plugging and
unplugging the device. The next 2 patches add support for iblock and
tcmu device plugging.

Note: These patches currently only work for drivers like vhost and loop
which can just run target_execute_cmd from their write_pending callout
because they have all their data already and they have access to their
transport queues so they can batch multiple cmds to lio core.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 53 +++++++++++++++++++++++++-
 include/target/target_core_backend.h   |  2 +
 include/target/target_core_base.h      |  8 ++++
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dec89e911348..35aa201ed80b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -227,6 +227,48 @@ static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&sess->cmd_count_wq);
 }
 
+static void target_plug_device(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct se_sess_cmd_queue *sq = se_cmd->sq;
+	struct se_dev_plug *se_plug;
+
+	if (!(se_cmd->se_cmd_flags & SCF_BATCHED) ||
+	    !se_dev->transport->plug_device)
+		return;
+
+	se_plug = se_dev->transport->plug_device(se_cmd);
+	if (!se_plug)
+		return;
+
+	/*
+	 * We have a ref to the lun at this point, but the cmds could
+	 * complete before we unplug, so grab a ref to the se_device so we
+	 * can call back into the backend.
+	 */
+	config_group_get(&se_dev->dev_group);
+	se_plug->se_dev = se_dev;
+	llist_add(&se_plug->plug_node, &sq->plug_list);
+}
+
+static void target_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct se_device *se_dev = se_plug->se_dev;
+
+	se_dev->transport->unplug_device(se_plug);
+	config_group_put(&se_dev->dev_group);
+}
+
+static void target_unplug_sq(struct se_sess_cmd_queue *sq)
+{
+	struct se_dev_plug *se_plug, *next_plug;
+	struct llist_node *plug_list;
+
+	plug_list = llist_del_all(&sq->plug_list);
+	llist_for_each_entry_safe(se_plug, next_plug, plug_list, plug_node)
+		target_unplug_device(se_plug);
+}
+
 static void target_queued_submit_work(struct work_struct *work)
 {
 	struct se_sess_cmd_queue *sq =
@@ -242,8 +284,14 @@ static void target_queued_submit_work(struct work_struct *work)
 		return;
 
 	cmd_list = llist_reverse_order(cmd_list);
-	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		se_cmd->sq = sq;
+		se_cmd->se_cmd_flags |= SCF_BATCHED;
+
 		se_sess->tfo->submit_queued_cmd(se_cmd);
+	}
+
+	target_unplug_sq(sq);
 }
 
 static void target_queue_cmd_work(struct se_sess_cmd_queue *q,
@@ -284,6 +332,7 @@ static void target_init_sess_cmd_queues(struct se_session *se_sess,
 	int i;
 
 	for (i = 0; i < se_sess->q_cnt; i++) {
+		init_llist_head(&q[i].plug_list);
 		init_llist_head(&q[i].cmd_list);
 		INIT_WORK(&q[i].work, work_fn);
 		q[i].se_sess = se_sess;
@@ -1759,6 +1808,8 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
+	target_plug_device(se_cmd);
+
 	rc = target_cmd_parse_cdb(se_cmd);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 6336780d83a7..45b5ae885af6 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -34,6 +34,8 @@ struct target_backend_ops {
 	int (*configure_device)(struct se_device *);
 	void (*destroy_device)(struct se_device *);
 	void (*free_device)(struct se_device *device);
+	struct se_dev_plug *(*plug_device)(struct se_cmd *se_cmd);
+	void (*unplug_device)(struct se_dev_plug *se_plug);
 
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b7f92a15cd1c..10ac30f7f638 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -146,6 +146,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_BATCHED				= (1 << 19),
 };
 
 /*
@@ -513,6 +514,7 @@ struct se_cmd {
 	struct completion	t_transport_stop_comp;
 
 	struct work_struct	work;
+	struct se_sess_cmd_queue *sq;
 
 	struct scatterlist	*t_data_sg;
 	struct scatterlist	*t_data_sg_orig;
@@ -612,9 +614,15 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
+struct se_dev_plug {
+	struct se_device        *se_dev;
+	struct llist_node	plug_node;
+};
+
 struct se_sess_cmd_queue {
 	struct llist_head	cmd_list;
 	struct work_struct	work;
+	struct llist_head	plug_list;
 	struct se_session	*se_sess;
 };
 
-- 
2.25.1

