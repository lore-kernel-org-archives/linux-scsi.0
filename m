Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A7DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9842964E42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhBQUfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:35:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhBQUb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKSusN122843;
        Wed, 17 Feb 2021 20:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=T/mfCz2B2yf+pyu0UO8gOcAyTJtfRUnjR5aeIRoe9pA=;
 b=AMDbxcafbhOKHXBEuKCsuTpVDrNOEVaJB13LwJ37PYNabm0OiPPkAOr+ED1RmgY9IIJC
 E2s9yjBcDUQ83v1xPxrl8o/iU3Oj2jiJdWftqTgNN5YDm/y5jHrX/dF98xqsTtyTGy7l
 /QklWo7gdIQ4vtXoRM7OUGINLcxsX+hSIDMyaIJ/5TwUp5hh6G0KQzMU8k4yu9HxPW+r
 d8TyuERbwwLlP7Mnaq7JAmHCSLl3qwH/CCWkZd0PrlKe7TtJyCqewNTuGHpLb0qRQDl1
 qRJHSpCZPETBE7Lju/Z5X+Rpy6BtgmXrXjg7YjQgH611l01+QaN+22gVJ97RthmDoQPn Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r3sah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPbbj113321;
        Wed, 17 Feb 2021 20:29:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 36prhtb5x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiy6/6Ww4/VUIvQUQMUVX5aui0ZyYE0sD6lM+eOxm1jgg6GK62f0CYQpC1Up/l47njmsICammKqoSq3gj8RyBJKZKWPbuYFkxO/0Uf4x8/c7Lw6dz2FPZoXWJtqktw1XuRmY1cXwD6xroeiIWxXMWvJCYiekxFO/DdF+nFijX3IT6j2HR1srjCoTWixPMoQ5Ta0VLMPmoaZvl0xaDAGTklGVNOPqa/9FIcPK7eqEtXWAeMptbAfI6uXhZyJg7ObJlmmunl/xmA+mOfPAsQQBxg4uj4rOM+9/bVUFlLLsOaOt0ui1U6KZy3JunEtYyYsHGUtM7mqmoYVKoSDwM91PYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/mfCz2B2yf+pyu0UO8gOcAyTJtfRUnjR5aeIRoe9pA=;
 b=brpK5Xl+n3+Ko4B3c7PaiqsriNbPFloTnAhxQKyJN7FAYx1VsBkAAqAWdEbvSmxZ8loOnXH4loKBRvWe59KSewmlUBQkVZ06OWSQ6QdZ0Q3+04oHB37MLXYCQz2Fe7h6rBOp37tWvbqHE+rgPPbl5b2MKX6HdsY/PKYsr3//3HD6HjD2/ltkfjx0NM9xlyHbtGyYHsuKXtxicEsrQ70yc2ArvMEsNarezT4aCuJ1o1PNRXa35vfaOTbeB34uxewBLdZrfPL2i9v/I9uBCIURTTQH9FasLRwd4rnmkJSLM0M8iEb44T9cdT3gThE5yhwATMXpYo/M8bMIraTgqV+b+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/mfCz2B2yf+pyu0UO8gOcAyTJtfRUnjR5aeIRoe9pA=;
 b=OQ2pY0Tn5jNw9sn4Q0j5pQy5BmeuZ9Rm90AGQLJGVqZ2IHfLBZjbLgwJORvTEitAOwy3YGJ98gjhZDWimG4jO7k+bYop963T0panb7L1do+mlLQH79nIAQMJmXRqiHR/Zk8OSAfbaCIFHtHG2Ui2M0BQ7ZiAcl8MdncJPXXfGiU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:29:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:29:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 21/25] target: fix backend plugging
Date:   Wed, 17 Feb 2021 14:28:07 -0600
Message-Id: <20210217202811.5575-22-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed784dd-4af9-4ad5-bb13-08d8d382a8c1
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB394049FAE34F66F75F4E7F0DF1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EGTHb10c9rzzmmDo7g0etyF2oV98jCk9LkxTNsTd7XKWrn4LXVcffYVvmb8qYSr8U27rgfxpCuWgONa4JNWCCcUYHIsx5iniJPnnL+1LfuU9aYlrXtxnxaHMLR4UpUqkOHAlbdmw32sjYpyNchu2jJKI4YTmay7rV5fOVsuj+/TfAh4Vemxli5QWLNbpKUle12v4cvDe518o9Sl+uz88Pmr+iXhcK7xqNS6EoaoQMKATJGRXJMFQ88ZzMSC2VJnFKGDz6orBXtRYfY3wxO8LMq+tCiKWR3uxARQF40X9pwpR8nURJySJx1uSyJ1UtN/tUhG2C6y8BlxUwhZ87UoLTHswQNV2gY9/lWJhDghNgFVV2c5yE51OFLr9ZsN+OYyLqpr2qHYb0TRu2f9LejZzl++rn8DvCVbUj0+KVD5BLS43pKpluytZc14exqv4DsmGsJsp3Uk+Ik9OO/awaVTbJFefT5+HGhDgDxsJyIiE087S5JkCAod8LRdvmpAL8YLl6OkjgtEMzcPCH65If2hJPSys7NIXHCgRgP7s8LYzY6yl5kly1J2cQvk6+ZdB9tCy6+MBpAi7ktKf06/YQaN3bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j8NxoP8YwpLezjf5jNeNcokdCbwqdGSNU1si3rCf+t3EG6VXgTc/JkLJ0Gb+?=
 =?us-ascii?Q?I786a5ezLi6aMuIrEr+P6Amh2w5bFJG722u43IJY710ZCHbzbEFFM6xFGAuo?=
 =?us-ascii?Q?XxVa4o4dKLeHeonJrvtwBP9iDx+lNhCROwrQUHVU94swmKZ9AIXPaGfjqsGI?=
 =?us-ascii?Q?kDS7IEOf1WwPowcqs8rfqxT3/jD3NVrgHWOAPx/LbX+JrB3qHRxFpIno6qVp?=
 =?us-ascii?Q?yIDHjt08n3c5oM46a2goaTczdHRfLX8xPbV1EaYjPlUmGYsEUbZwMicgoa4C?=
 =?us-ascii?Q?6mlWdhuJO0cQmG/CTlZX9UfKzv7f5JeZxmkVyamv6gaFi52w3Xa0MJqCpbGn?=
 =?us-ascii?Q?9pS5rGlsDNN/hiY1VF2OHNPcbgEL4CpwcY/+XpvpLQqhwlrFROCB05fqv/0a?=
 =?us-ascii?Q?DovS56tkSRme/ZAiY5AUe7MTqWh/aG8YFDYbm5ATd5L2aIWsykZDaPa+6wIg?=
 =?us-ascii?Q?ivFFpd5k1ZdLfuKRshNGnwDsm0lWGRt4SG5K+QinKt5VuKRJIGcC0y7t8rxz?=
 =?us-ascii?Q?3o3dPI8qRrk6Lt2gSDs0ED1l/Z1Pl3OtwWq448H+WvyFI0qsOkq63v0ho+az?=
 =?us-ascii?Q?HPmqqoTOPD6Ar9mxrSQf058qVuhn/AUHUspJm3924G+p6/bisXOzT29YI0Bc?=
 =?us-ascii?Q?MAjmpistCV0t1RMtabmnejetKpPGrPao5vC1x5fs9rl09evT0QtN5iM8ZKh6?=
 =?us-ascii?Q?u3x4RttegLA0K5pmBoWRXKboRcXBkBwkykbHGRQCuffeUxm1OI/Hw7QXvH4P?=
 =?us-ascii?Q?NsmHSKZDidqIPdV4zYYf5SAe2wOHnzLt02NWWdA+2632XgX0DcObkTs6nZWe?=
 =?us-ascii?Q?jtS/Fe0z3rtO3t8O7wsdWJvT4G5Ru7rEPob4qvnKzKoWwh9V9f1IBDiuQ6DE?=
 =?us-ascii?Q?M3G9S6uHB65TQW/99t76CRupxwSxoibwIXq/aXV2a5mGs6sKCKqnf4CEOJjZ?=
 =?us-ascii?Q?dVbo6syh2OvPIMdhsqBajSvTYWnd7DzPqnMxF5P3cxHe3qCx2xYsVNjxg6HI?=
 =?us-ascii?Q?2+8OoMebMZ0a57khQFC0Q7ZXsgkUVK/OKW7cuKuR7u6UNnKwbaWaBUqaN7PN?=
 =?us-ascii?Q?qU75fPk46sfiVTfxAbkTknAvFsy9eZJ0muaYwewVcDyvb0LeGLElzF1qoDhz?=
 =?us-ascii?Q?CmLbdz5Wr4CsWyqOV6vV/lVIvJFZHmG22XC++PAHeGAc9rulpfr14NrOjmml?=
 =?us-ascii?Q?0VOndlwh+rrXJoMW3ItTz5UC5YaD6UZeAntx9Mv7HX7v2kaoyGPp5DkGg+nt?=
 =?us-ascii?Q?Q6hhtLi5udfKaqPtzJkQfhwnW9CdaR/MpVb14JlIp5V65p+SfO2VtV2KoHlG?=
 =?us-ascii?Q?8evTFInqWIKfhFs2zpjK2MI4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed784dd-4af9-4ad5-bb13-08d8d382a8c1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:29:00.6871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPxWGdW+ceza0uBPwNcd7H2ssCJNQPb54yOU9w1YyvKJhgYFi8QC4AVlYOYc4mxSM4fXQjU1pynXCWMoOHD+wq65p/JQ4eYXi9ST8CWrz4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170153
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

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 43 +++++++++++++++++++++++++-
 include/target/target_core_backend.h   |  2 ++
 include/target/target_core_base.h      |  4 +++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dd63f81bd702..18cb00a1ee2f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1805,10 +1805,42 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+
+static struct se_dev_plug *target_plug_device(struct se_device *se_dev)
+{
+	struct se_dev_plug *se_plug;
+
+	if (!se_dev->transport->plug_device)
+		return NULL;
+
+	se_plug = se_dev->transport->plug_device(se_dev);
+	if (!se_plug)
+		return NULL;
+
+	se_plug->se_dev = se_dev;
+	/*
+	 * We have a ref to the lun at this point, but the cmds could
+	 * complete before we unplug, so grab a ref to the se_device so we
+	 * can call back into the backend.
+	 */
+	config_group_get(&se_dev->dev_group);
+	return se_plug;
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
 void target_queued_submit_work(struct work_struct *work)
 {
 	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
 	struct se_cmd *se_cmd, *next_cmd;
+	struct se_dev_plug *se_plug = NULL;
+	struct se_device *se_dev = NULL;
 	struct llist_node *cmd_list;
 
 	cmd_list = llist_del_all(&sq->cmd_list);
@@ -1817,8 +1849,17 @@ void target_queued_submit_work(struct work_struct *work)
 		return;
 
 	cmd_list = llist_reverse_order(cmd_list);
-	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
+	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		if (!se_dev) {
+			se_dev = se_cmd->se_dev;
+			se_plug = target_plug_device(se_dev);
+		}
+
 		target_submit(se_cmd);
+	}
+
+	if (se_plug)
+		target_unplug_device(se_plug);
 }
 
 /**
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 6336780d83a7..aa5f83e55501 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -34,6 +34,8 @@ struct target_backend_ops {
 	int (*configure_device)(struct se_device *);
 	void (*destroy_device)(struct se_device *);
 	void (*free_device)(struct se_device *device);
+	struct se_dev_plug *(*plug_device)(struct se_device *se_dev);
+	void (*unplug_device)(struct se_dev_plug *se_plug);
 
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5e6703ca102d..b8e0a3250bd0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -769,6 +769,10 @@ struct se_cmd_queue {
 	struct work_struct	work;
 };
 
+struct se_dev_plug {
+	struct se_device	*se_dev;
+};
+
 struct se_device_queue {
 	struct list_head	state_list;
 	spinlock_t		lock;
-- 
2.25.1

