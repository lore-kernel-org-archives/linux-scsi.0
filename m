Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EEDC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D77164E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhBJE5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhBJE42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tf1F139980;
        Wed, 10 Feb 2021 04:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=RoF4+pus+pCIcA/duU0uic6Eh7s5ZBtjtzLLAHYCAcg=;
 b=T8nLCIcoa3HwHFyQi0EBAne+bgJOPMyczic6k2yvBZxwd84z7UDHjhprWzta9LIS5hrI
 xuN/eLvpj8Tyunpgz7C9JPt6/sL2N2LfL80f3yIWxjDaVsjf3aYKCw8geT3z3tO/il9B
 Vcnp+UShM2BYKWeSmMU03+2MyExibR96Xp33H/WCaont15c987G8PbC5ylo0+Bk9Ir4g
 Yaknwgwg961Nau4BZb+aom8KYXSDamHWyKHwV3EJsR56lYYOS0hIy0fMqk10pMKYCZWg
 369U+/+YiwPp8XEQjBFu4TyxQzWPLo0uASgwGQBN5wbaKtDQIhzT6wZu3oIJbLhtRffZ rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uprdfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBA048727;
        Wed, 10 Feb 2021 04:55:40 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odsK9sjcxe5HazT1HiNp7oAz0qxog/T90GURVToCszU5PDir63jYktldAzgVUskKEGJ2SgYPVGJAJNvh6H1LpCmXo+JgXduPc9uhNvOKESUww2SbLlnQWDkKt8m/gxXT6JAIu2/ujhKbqUYIN6p2CmYov/vp8NRN9SilPErggEecxXtXA3Y3XonI+vcdvYaXtnH14pc7fgbZgGeUWmoJ3lKIFIcUWCGCvA6FvCHgTmUpi/uQYd31I3640aMdn19qSIBkn40KEd3u4DxVRXGT6SPmpAJJCeHgE+TEFKtPRGZDceQMlSYDlIUhlOXMEcRwGieKG6ucNcrLfMzvSZQpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoF4+pus+pCIcA/duU0uic6Eh7s5ZBtjtzLLAHYCAcg=;
 b=f/dcaW6ZClK/XD4kPdbba0eOB3vGL+zau2HsfL93UzwAJLKNq9iVaOGSvae/Usr+miEoQTPkV/3fIqWxb/ZL6xDU3JVV5ViIClvb+5IB2iqsnl1VTjK3vS7K3hMqLP8bNDJaKC4gPhYrREjZGRhFdIt2xTJ7XwKonranFSLwHY7Cbob5H6Qbx121sV/8caHFfwiptonATJy9LvvLK/ZaQ3Olgf5ZJGOB9qFiul/XfJdhrhtPIyfQ6+apAYE/tr4QZXaWkv52r3pookRPCPfrl5jCAqGz6zSD5fzNTUx3sBT/B8awWKjwoU7RlTwtIDL4dbDglJk9AikVLqahae+ffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoF4+pus+pCIcA/duU0uic6Eh7s5ZBtjtzLLAHYCAcg=;
 b=kQpaIFXmHWksTtWrUJEpU4iRdJYUn8djyhjeRYsogUcbKT55v4TGbHZKf3NMOQHd9EGOZgGz1QBtVasRf4jxxf+xv2BB5pTouiSSJ5zCiLBpN8FCFAyjLoY9pFXtftKhYCUtAQGE1z3Tv+KP5USnI/bjjgpBW1QqpDsH46q8oCI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:35 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/13] target: fix backend plugging
Date:   Tue,  9 Feb 2021 22:55:11 -0600
Message-Id: <20210210045516.11180-9-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35693bcb-7fa4-4ec8-afd0-08d8cd801a46
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366C4BA66C2FFF64E132A2FF18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7e81UyhyIrYjUYOb/B9dQJRfdjiz9JIaLrOnwkZf2kpuQ9/cnsVddK2pdKGHKsxlS0eVUew6VE7HXlFI+AyLYyEoJ6LboWL7w7IxSVWtewTar1Isk5mxnJ0rPDRTzoFGqRddJ+0KVsXCJHePSqMh8nXWnBQTZgUA4+/i6kfDzL3OhWZldCgbt/vQhsCpKQJ9mSLRUaGtlI0iGMfRBvlB/G8ueMTj2ZUUQl0oQZoAqC9AU60tUQNBpBV9fI/bn4E6mHPFPZbCQCDrqn6j5ImsDr81iwIEN4rBA7RiKcE3wNVX/DmwVwTyyXbmNbqj9CaFc4SFb7b9Sigft74YNCtrjiA8s21Jz0uMjCkMRYQJCsAKxZ8Txwz5AvQ1lI6KlKmmTesV9/My3e+zfOKn76T8J+fXQKzRi2AIbuGilzw3Rm2zFIgzkpDLXLZC1QfmeltnV9ljtXHdyMopt6D2rjMR9gdzHSuv9KYJfZinkpL+uCxsmGVGtL12CSUSaTZPmD6/wIym06SB01UxnA2nVytVEYZN6o1KsAPB2HqHGX/rKD2EVNl9x1fgcWKGVzQG1U87
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fCdqfuGt7IUhdts2hYjEHmezSllTpYajwx2sx8m94D7jCj8kzSWxjyX8QFlb?=
 =?us-ascii?Q?zcLCOGb9XpaVcbkv4muIJuJzfYjUjWLCqKMkzE8PmJQCiwGJX72aVJHO1HHm?=
 =?us-ascii?Q?xMQIjobp5SK670DBl9l1cwXjxXcO46so8LioprL55ihf493TP7KosSIfUleU?=
 =?us-ascii?Q?A07L86QK4ZvKrsdZl2h+8DeY3pWehD1CbWoxsoesl5Yp1PeTfPtxfYdCtVfp?=
 =?us-ascii?Q?LU41eGT8XPThgB68aanOmnqM8VTCznHLinZCfQmjpz5FlTrxm6Wpm/uBvIgG?=
 =?us-ascii?Q?WDJVl51Q/qkmH61z7G+wfjHeZavGpiqqsee+j8QpND0cBhe1WMJzLdq1S4kL?=
 =?us-ascii?Q?RzbFa8J9KzaUJ8Eng22JZZN6PObfaJwDCLHfPgT1jm8dqlh0RnvpgKYTJzt/?=
 =?us-ascii?Q?nYNlr5iPKMBFwHWMIFqZIvlUXLWu1NqPr/LQTfZyayAm4TWOnsK0PxBHxQv8?=
 =?us-ascii?Q?yJ1gkH8sdprnRCYZU6Y9LHIomOtN/7shcSC6JxU6mOgekrAQGsQNBgK8AGSE?=
 =?us-ascii?Q?QP9hAnd+qkUTt+f9Hi4U5+9p7aB/BCJS79vmvmCuyJBBazwZwmyApaL3TUzR?=
 =?us-ascii?Q?BGMEA4Owy2yoXJE9k44Q87YX0A9+nsJKUuCQuqKQkuL12bwX6BcGBihxafDz?=
 =?us-ascii?Q?U5AhJ8xxnAxe44HlwvR80fP83Dzhv5NZCMXWHqCK6U/jq2W/MkTqrFGMxnhy?=
 =?us-ascii?Q?gMJ80cSd2hDUtvkn3PiQrUJkdx903Mw5JIxkdI8LC08mfrB109EFc1mh7sau?=
 =?us-ascii?Q?CKy3pC2Z4uwbiWNRXn7CsdlTzcoB0MMuut02et1GJ9gT94cSdL6Day/s56ni?=
 =?us-ascii?Q?Sxy8hhPI48DmO1euFGCF6c7YyEIn5sB3Vj/rMMt0Zmi5lgpL9cxj9wM4Nbha?=
 =?us-ascii?Q?xewUYOj+4Cw3deAbpQOiH2L/zd1DE98LZwcKFCAu4UXK8gxWnyZW44rET3yp?=
 =?us-ascii?Q?V9DllVEfEPsAQID5pNR0UMT/hFJyWF5lgf5UdIB1G3wCZ2Gq9aiNjoqE9OLn?=
 =?us-ascii?Q?01x8tBOOQAxNGs3qv7m1ADsN7lNmBFCyDL7lnPEDz8QeEmAytezs8t/zadhH?=
 =?us-ascii?Q?m98wTKWR3U4KSPGHZ5KYQSEPzijhK+fxCGXpSv875N8bIctBI0gDNJ3ZGtXq?=
 =?us-ascii?Q?SDhuJviwtHUgW9nY+8iKBID4Jh5AnNE6IrH9Q+9Y5+nCbPVT6U6XrMb1izPL?=
 =?us-ascii?Q?jDRsN9knbuOy5g2WfT9KNOJLp7WLy/B718nd7VLL2NlZBjRqzBA9Huy5Z7JD?=
 =?us-ascii?Q?R4uWR8JkFnZJElrWanTmAPn5TUP+aIUlyF3R5nQkDtyHxuvCGC/M+tAcUvq1?=
 =?us-ascii?Q?O0obS4O2L/BprWTUicXCo9wn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35693bcb-7fa4-4ec8-afd0-08d8cd801a46
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:35.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaWunwLEK53dCoXadDL4Kuav8hGl2AYgwWTnKgYS3VYA4Dpb/h2dYwfZ0PdUg3DUfbEfWtVbmHIXq3B7KBOLTqHfiAuPkP3Y/yhd0JqL0JE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
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
 drivers/target/target_core_transport.c | 40 ++++++++++++++++++++++++++
 include/target/target_core_backend.h   |  2 ++
 include/target/target_core_base.h      |  4 +++
 3 files changed, 46 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5f33730e3d27..c4bc012fc215 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1835,10 +1835,42 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
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
 	unsigned char *cdb;
 
@@ -1849,9 +1881,17 @@ void target_queued_submit_work(struct work_struct *work)
 
 	cmd_list = llist_reverse_order(cmd_list);
 	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
+		if (!se_dev) {
+			se_dev = se_cmd->se_dev;
+			se_plug = target_plug_device(se_dev);
+		}
+
 		cdb = se_cmd->se_tfo->get_cdb(se_cmd);
 		target_submit(se_cmd, cdb);
 	}
+
+	if (se_plug)
+		target_unplug_device(se_plug);
 }
 
 static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
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

