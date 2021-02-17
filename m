Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81309C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE0864DEC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhBQUdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:45 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54236 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbhBQUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKP88p018170;
        Wed, 17 Feb 2021 20:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=eL/vLZuKbd01zmFpeZJGdvF0WVzdreipNWoLFunMtPE=;
 b=oJ5HtaNzkUu9/BmZJx1ijW9aYqYFxWDi5BxorP+vktf+Y/t3Ia4G89zhYJ55lNLVEfxL
 IXLGpkNy9cPJqjRW3xbPss6ub5ClszSxJbreR/HMo9iUJ2f2DXxxj1wjTdkqZa3pBhWs
 LKuqqazaJfn8dFlHx1dJRXnh20DjYoP0sMXXLu9wSvwPP/nmP7SOgP4VV/NRvNLFhVZX
 vYshgS2vmJdSu6c6CesvrpkhspsYppnpQUWvEEKiApGGwTip/O85ElBJnMjWLBiHtHa8
 Wmktp1UX7KP0l+m8qUhuekbINX7NeVndq0KtA6hul/fAchrqZaW3xmGoJSkmrzWNTepK sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bbwxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPbkf113375;
        Wed, 17 Feb 2021 20:28:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 36prhtb5tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGjNcIxUhccs6LQKMSsTBCOjV6uA4+rX9r0o9Ny3vO1N7P4YqfQc9vCT7S0W8Q0KcanEHoX2gmiAmMYQwhudmXL1C1tNEaM4fvreUOix50i8ObD9gtxjKh8xom+BX7Az0lI129lqAx18WXyspWI3I/SKqv6SacpUOJ2jWRl7VYVPTx5axAYJjXLpi3vtfqhxNw+GqDzI6+YSxC9BG5eRjC9qLLJ3wZpi0ObIUgOJzfxXpd8snSnJCpgArUYaVycnaDKR1Tupppi9TTkqPQZwrnJ+w/XqUFb9J23x2mSuPzGQntwBXgBr4XM5Gdf9qzmJUumOuuX/Ru7FsHoEzr1aJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eL/vLZuKbd01zmFpeZJGdvF0WVzdreipNWoLFunMtPE=;
 b=AfVZIcefjBoS6b8q3C3hqgmaoHPnuWucyyhmR3UT2QVnvg8KzpAlKvIlrf+GSXjVBEdZ6ZO8C3K7muK4JbGDodjF+Y/GC/NifSAJHpfyoTVAsaciNfINfbsqqllB8A07QlEzSmiZCjEl2guPvX/71Zo4iuLhbka6/PTB8fNk3gC1DKcu7zKcCKfA4Sz8BmDhr7xUmMEvcksn1naR/ek5BOjp+bm9TMwjWT0y63+Wdy+RaZud+9grYDXhs9IjBB+Qzxmv3NMVarjuZS9FeQWZE15Z/oZOch1iVJSOA2Av7x08sTI1sd7T5yGWdabNTOTDnj0mnz+QI98zy5FQpkp7Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eL/vLZuKbd01zmFpeZJGdvF0WVzdreipNWoLFunMtPE=;
 b=vnRnIjfK9IfRl7ydXIa5a5B2lLDz50KWi0SD6S++MWiFddWG+8DHrYZFrELwYGLpVOdw+gdIJDxyD8Gu3gvCTmMKG6EUug+TwywIqsSWgHGp9Y6VtczD7rDSuM0x1M3LXJ2rOM2IMIyuk+z3r5eN9oJszU1Srup08Ib0HmINZ6k=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/25] target: add workqueue based cmd submission
Date:   Wed, 17 Feb 2021 14:28:02 -0600
Message-Id: <20210217202811.5575-17-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f9707e-59e1-4e57-947b-08d8d382a3be
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3940F000C240C3AE165C5067F1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gv5c8iYAGJXggPAFEUUCzWJn2/GwzJRH5wYOtqmdw80UpAhKgcQX8RytwNOaDGfASbWzJiPNZXf3cVsdwxrIkufjy9uKHhJoUlcA1aUs3JfZf1X1z3K0/ddR3r52JCZHMIsJxdWZjWuGElFJytxiBddxBKBja24ozk2c2K+vuFPkyXrM+iTjqvCAVSInP27dRiD49x02ziPVBzna8yePRsHzqMwOKGVGJ8stVAesu87Id0vvuG6QJPTfoukwgwZfUa0VHuRkef6qFUa9ZWGqLwDFaTdCjhKh+oseeYGmjayf6B7TWEwmPLf95QMaNOp9B3y1tA/bO+qLoCYqRQgltOs5xlpPcFzj4DzJYNOil4at2qccKr2jLpdNm+9ouuc3Tpiz0O31ECAqg/W87yZCmv2HkLwxWKa0sKgk1YY1pMpgRXvV11zfyOqTbDkOmnFE2wvxUni40wM0EH+iUite9BKNoH5nUR/uhgRTEFj3Qp26QwxwBduSm0Ukz/sueA+DNWvqNxrGAfXmL3oGnCgQIr797qalJ5NLPx/A87UY/ZgCy3i2iYJxL3WLU6X/SsGOrphOrmtofQBbqIxtgbe7Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Okj/DE6ft3klbMnslaZw1wOXSSFyDh0cb3tQqpGt9hRDnPcVAFaYiriOLHbt?=
 =?us-ascii?Q?7eCiVOT4qUbqF40rMZ1/3JDx1d1I7hITzhlYaGTAfKnPKVlsDCEJC3bWBCvA?=
 =?us-ascii?Q?pI0Wvh10+42J0IqV1sG8BPHpZKjyTDs1xufrfMcQ7qPN2LuzoT8/uBfW4Izc?=
 =?us-ascii?Q?m9B2q3vHs3Wj9BZPynC7ZLQJm7DV4+Oj2gbxzRUwj8u21EFF6uhch/ypv5AK?=
 =?us-ascii?Q?BFMDMUpzhSymoTeyIhObRrXNzlMnoPQPAKIdFAh8wlQT0zRzrlWzG+0+k+60?=
 =?us-ascii?Q?BuAujrpEmcDdViGRNHKU4jKQD1O2haxAKfK5hQsCUi6csXRCqywZnTfOp3ao?=
 =?us-ascii?Q?DdM4OxSqTMw7HvXkP6F+1TbAN8MNtHDRj8FYV1BNiNfU+9Vp9yDvkMBzAL2i?=
 =?us-ascii?Q?3cn73ZzfVqk5DjLa5624Yx+85X442VKf9rqNloomWceRbFa/Z9DtRg8zaCkb?=
 =?us-ascii?Q?GVUrx9esoI/3IMR/x9Tk/xA9V6HySDhfolPhiyR1em6oksTskXxpcwulY45q?=
 =?us-ascii?Q?Jabg1Ifa10Zw4ZTeb3jVyf9BK2xMfSURLJBlzO2JZF8yTiGpI1e9cUHyUQXp?=
 =?us-ascii?Q?uZiBAbF844ktNcKomFJP1jBLKyC7dEOqN0NhVJdYv16831cG1kaZzxK0gPU+?=
 =?us-ascii?Q?GEPVdyoWahrjMxtmk1qQH3XKmYsZhxRS/Z02cvK5cMkDJeOOeH6XM11WWIoN?=
 =?us-ascii?Q?cn2qeuxLY8AeU02iqsif7d1V+5wPlMZujWH65BHdRIr9BnU+E788DgDg3E2p?=
 =?us-ascii?Q?aKXkpt2NXzbYKLv3Knf7SgJwqnMQgNpYaIZAig1wqdrf4tf7gfupdq4HmM7C?=
 =?us-ascii?Q?aLr3GFQqv5vOD2yjC7PtHbqpFH1mlZ9e1puIBlKOLFkthCklqoUcdYGtY7u/?=
 =?us-ascii?Q?aBCN2coZi21N907L8ph3393/+TKGzvFAQHy7yxUTM4bq9FwxxnwTKkDeofz/?=
 =?us-ascii?Q?32m162k8Kh4SbL+sCS79BUOSyWbeBsE9p9K4CB7SK009rBFs/YgSfqX/8fQf?=
 =?us-ascii?Q?HUW7fQCx1Jp2O0fo6rKqMIElI3Xs7FaNgzoLoiYi3jBrP/oT+N+FLUlxghj5?=
 =?us-ascii?Q?uQjVm5624tsoczIzDoCI9C38SY4VfdfUTGMNsH9rz7zirP8om+tigfKHFrkW?=
 =?us-ascii?Q?+ZyxxDXSgW4afhwL/dW7xHKDKnJ6lttXdpmXV1G4Nt7kORAVwBeYPuKvrQo7?=
 =?us-ascii?Q?kR04eHA2EjoSEDUJTfsFHVmM3hyS2/tm2QBmuZpT3eOv5GPMP+K1FlzqHGLt?=
 =?us-ascii?Q?LdiIbPovhR6xe2ydK7Y2aFWNs9kmk5DjumEJqPMVUPQJlpFhUYazMvf1gIIU?=
 =?us-ascii?Q?zj3v5ekM1SGq9cK7lZK/2ksH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f9707e-59e1-4e57-947b-08d8d382a3be
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:52.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e71jJiSp1Lgb4ZUoCde8XygB/05cIo56UGanCDAZUzUy9XU7rgYIQvT92PjenZqDddjO2c8sDsN0fZVNugokftn/UKnLGITkqSxy2WS2jI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

loop and vhost-scsi do their target cmd submission from driver
workqueues. This allows them to avoid an issue where the backend may
block waiting for resources like tags/requests, mem/locks, etc
and that ends up blocking their entire submission path and for the
case of vhost-scsi both the submission and completion path.

This patch adds a helper drivers can use to submit from a lio
workqueue. This code will then be extended in the next patches to
fix the plugging of backend devices.

Note: I'm only converting vhost/loop initially, but the workqueue
based submission will work for other drivers and have similar
benefits where the main target loops will not end up blocking one
some backend resource. I'll port others when I have more time to
test as I think we might want to make it configurable for some
drivers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_device.c    | 10 ++++--
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 42 +++++++++++++++++++++++++-
 include/target/target_core_base.h      |  8 ++++-
 include/target/target_core_fabric.h    |  2 ++
 5 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7787c527aad3..74d3a4896588 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -735,8 +735,14 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queue_cnt = nr_cpu_ids;
 	for (i = 0; i < dev->queue_cnt; i++) {
-		INIT_LIST_HEAD(&dev->queues[i].state_list);
-		spin_lock_init(&dev->queues[i].lock);
+		struct se_device_queue *q;
+
+		q = &dev->queues[i];
+		INIT_LIST_HEAD(&q->state_list);
+		spin_lock_init(&q->lock);
+
+		init_llist_head(&q->sq.cmd_list);
+		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
 	dev->se_hba = hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e7b3c6e5d574..56f841fd7f04 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -153,6 +153,7 @@ void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_queued_submit_work(struct work_struct *work);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6c88ca832da6..dd63f81bd702 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -41,6 +41,7 @@
 #include <trace/events/target.h>
 
 static struct workqueue_struct *target_completion_wq;
+static struct workqueue_struct *target_submission_wq;
 static struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
@@ -129,8 +130,15 @@ int init_se_kmem_caches(void)
 	if (!target_completion_wq)
 		goto out_free_lba_map_mem_cache;
 
+	target_submission_wq = alloc_workqueue("target_submission",
+					       WQ_MEM_RECLAIM, 0);
+	if (!target_submission_wq)
+		goto out_free_completion_wq;
+
 	return 0;
 
+out_free_completion_wq:
+	destroy_workqueue(target_completion_wq);
 out_free_lba_map_mem_cache:
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 out_free_lba_map_cache:
@@ -153,6 +161,7 @@ int init_se_kmem_caches(void)
 
 void release_se_kmem_caches(void)
 {
+	destroy_workqueue(target_submission_wq);
 	destroy_workqueue(target_completion_wq);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
@@ -1380,7 +1389,6 @@ void __target_init_cmd(
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
-	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	cmd->free_compl = NULL;
@@ -1797,6 +1805,38 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+void target_queued_submit_work(struct work_struct *work)
+{
+	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
+	struct se_cmd *se_cmd, *next_cmd;
+	struct llist_node *cmd_list;
+
+	cmd_list = llist_del_all(&sq->cmd_list);
+	if (!cmd_list)
+		/* Previous call took what we were queued to submit */
+		return;
+
+	cmd_list = llist_reverse_order(cmd_list);
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+		target_submit(se_cmd);
+}
+
+/**
+ * target_queue_submission - queue the cmd to run on the LIO workqueue
+ * @se_cmd: command descriptor to submit
+ */
+void target_queue_submission(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	int cpu = se_cmd->cpuid;
+	struct se_cmd_queue *sq;
+
+	sq = &se_dev->queues[cpu].sq;
+	llist_add(&se_cmd->se_cmd_list, &sq->cmd_list);
+	queue_work_on(cpu, target_submission_wq, &sq->work);
+}
+EXPORT_SYMBOL_GPL(target_queue_submission);
+
 static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 63dd12124139..815de4c97230 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -487,7 +487,7 @@ struct se_cmd {
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
-	struct list_head	se_cmd_list;
+	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
 	struct completion	*abrt_compl;
 	const struct target_core_fabric_ops *se_tfo;
@@ -764,9 +764,15 @@ struct se_dev_stat_grps {
 	struct config_group scsi_lu_group;
 };
 
+struct se_cmd_queue {
+	struct llist_head	cmd_list;
+	struct work_struct	work;
+};
+
 struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
+	struct se_cmd_queue	sq;
 };
 
 struct se_device {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 0543ab107723..3c5ade7a04a6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -165,6 +165,8 @@ sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
+void	target_queue_submission(struct se_cmd *se_cmd);
+
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
-- 
2.25.1

