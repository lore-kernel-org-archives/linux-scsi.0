Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCA8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4E364EB1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBIMkK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhBIMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaULe009428;
        Tue, 9 Feb 2021 12:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Ca/rM6cNPFhPKHaYbHHm8zkO5GUgL/b3cEo0tBUZF2w=;
 b=lEX2vem6u6sj8bbTz/QQ8GAhScC/x4wlW36p6czYC+97NsSM+W9rHHvwqwCbwNkDuqzx
 9Sbw2LSu/Yz4V9zv3beTnrxtMxQvogAUItF2nqo4ymXNbWp226VzxKrCR1NngGdQoeoL
 Lxcy0C56JGj8+dvsHIwy7XQqf4tEGkgwKoaYTW8h4WmSCcuwS4XFawIsOvK8KUquglkd
 eSQ1sdVmd9x5qAe9J/xDIZSt8M/w8zeyxhEtLHKTnDvbwiMSEodbyi7rRLQKe1ehOoNE
 DxhmoozpgDKO/Qt2qQe5Ycz8a5GM8JmDktApsIFnCFPonkKSJq1ixqXj05qd+E4wS+GM RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36hk2kfajn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZeCf029740;
        Tue, 9 Feb 2021 12:39:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 36j5115bft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMCxnaPpGNYQToV45zbgsJ5T12GENcA16QhJ9y3A4sSsQuyTChwjA8OcmsPWHQcgsKAcUoFi6NVzhrQzVfXkT2LAohHM8f17UpbKVk52e/2Rb1/heRg1izyfsh07ibZarMvEG4zCUiWdMUlCdJaoIzM7g+ASM9J0/Qmj3YeCfq9HswSmhpkpENimCEQ0sCnQL/gvnF7E6LB9gsQ1U5QOc7DGZbHgIkyJv4BGv+3ZieBJWc/fL/9PFVDBYB2fF015wrWdb048zmTHfJftYK4wWVQRKyZE/PTwCjmjXslSv3GYltY0nR9yZtDcOYdtXKx8KD2iOocf0Wn5Psl25XP9bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ca/rM6cNPFhPKHaYbHHm8zkO5GUgL/b3cEo0tBUZF2w=;
 b=JKefdRsCIAHpCc6xucpY1DpXBpEJLqXOSWPsGp3Ly4WuZq12dXVQA9MlP3F1SHmgM0HyK4cp0JWLtgpIT6FTByrPwEGeLHzgImSlmq5hUwNHd1fmIwZrLCRedMjdy0cA2LLxRaGAktDGZbgIWv0Y1bmnHVG3JlJRI4IixcIsY2otRByeYXt+SWucjY5l65Fec/R/AGp+ks0dLzs221Nbpn7EpfaJopFRpFNpFR2O23tcpd7IIN+dHnuRB3a89DWpWvmy2jUfUcL3TlBw7SqDyH2q2ln3m9oFTroAvkPgd+nAhgtxcGQ4NK7/0uGIccxqZi3eqZ2B17i399Q2DZhrmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ca/rM6cNPFhPKHaYbHHm8zkO5GUgL/b3cEo0tBUZF2w=;
 b=Z4hPe/h9nQmoSr3hgLou9T0BLYPUbUK/mToZz0yvIevL4tGD1Jm5NeBcuwv8Vn6s0FcyZT1he8w3091kxAbaGUDvVgA99xtmQ3D9dN5iuVcFIRIYLnEkzIDJWiQijpU2cM50g6Mg5a9RYyWElibx/CQzoqEDYKbjcx318D7Oi7E=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/13] target: fix backend plugging
Date:   Tue,  9 Feb 2021 06:38:40 -0600
Message-Id: <20210209123845.4856-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30b11baf-076f-49e3-577a-08d8ccf7aefb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB26008B0C04E0E8EAAF5F86FBF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JMuQcoXWuniIsOT1S7iuia9omd8vI6aUuNKcm2otOhm8oVjG7du4N1gN01mXnzddxWQZfnqy68eLMz1ZjzdfkvfBzO+TT4yw8ft6+pBFTB9XPz7OrOxHjAQDqX3nRUxJr2y1Di2JQRJdYZqe8eLkRdyBLEtnMX2200a2SF3plDR+q8Y/yf/AoXU/EH4igG3Nd9+pZXe4BIwEeVJtLyjufmx5FQW1F7evAKnJCcpmKVYKIf8L+9p+nQLAMyh2GvU4pEUEbuPRS+N5FQ2Itdy0xV4t8MLzvW9wUaPbwfCK+gX2GKI/ZbLbFXeTXb3JBkYNCULDLcj2R9fZk56Ob91cYYMdUe0GUxnbyuQ+gzIirnpakEKt6Q7IYX5Yh+nQP0j/OJ1p9yvV+kcq99ZaCJRTdYondD4SgjtR9APRmhgZnLQmi9Nl5DrkghmjOwwCZw/T/njAomzgsuE76/5XkfjLVfelknnvcdZnolgiDER2UPXUueMHGhuI0nuWHNtisVxLBFhZUge+RbvfylL89gu0TnCXg6WFozs/JWpJ6cr1h+MIHrLkPKjDqndDA7I/ojP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/aeWlDcZ8vH89v8kTjrMo0YgO+M8phCg3DbYZ5I70o565MLVR9BMrRxfazJb?=
 =?us-ascii?Q?37ppxaceDxYc/B6ChiUm3DnSCrW+//Mb3IbL+w4ip7JaPtX76+HY6C/xx4IB?=
 =?us-ascii?Q?1E1CqG9nINJr0lKjceghn/SU+XHzT6Cgxs5j+XSjteA3zxaOZ7G+TN5lMnRm?=
 =?us-ascii?Q?4rYsQLDXL2KAsBoJO5Jp8ioujbJb2b4mdhMR0KtoJSpFF7JSvkGnrti5/5sX?=
 =?us-ascii?Q?5YsbjahM9QhSsxiHZCbYrDwXAHONwkpztNYkTgchf4SW7tQq2foQtXIChGsR?=
 =?us-ascii?Q?o0o7qHM5bsEH6tJ9jVtTu61hahRAJFUPnwha+9c+BGe38Lk6ak70k7JXHPhl?=
 =?us-ascii?Q?J5V//SjeKOECMWRa+fMvUUTs7YaM9rrUqDJw3f7/zTF8LYgiOxl3C9n8kkIm?=
 =?us-ascii?Q?OHliLgVMPnB6eA0KZBEkTxspvVxkAFLV7Z/o70iGCqp8UohyFKc4cby8PuSG?=
 =?us-ascii?Q?0F+pWOLewXRodyDywj3STglxYr6GcWsDSyjmgW4rkQMSbaUtmvKyligyFvyz?=
 =?us-ascii?Q?PZhVqwNCagXs/0pYDGRQwPzE0LiLOPvn6n4E9Lv/YHwTOljDkcY1hS1Gsp90?=
 =?us-ascii?Q?jp1LcMmAuQceAfvdDAOR3A6tYN6stQfu31HzbjVCJWRbFWgcRjadpVtF+adV?=
 =?us-ascii?Q?vmBbfjVqUbkjCa3arcjW55mJMsT7Jtstwk10O8Srzy1UvSmW+2swnt8ZI3HX?=
 =?us-ascii?Q?4JL7we1ltkPEohjjiiS0h/kAQbG1capuRKdpLK+IYNuYVrGnMk8o++ESwHvS?=
 =?us-ascii?Q?fmMrIxtr5pfzBX668AKqOkvDrvAAI0k+xX/R8BVk3V2W6U3aCFxiv0oyCmtx?=
 =?us-ascii?Q?nXYa2SzmMxOoWHmeG1OdZhL2HyDU/9QRUtBP5TwAHSf/naCb/OjW1sWKU+NB?=
 =?us-ascii?Q?pYpzX/TBe4PMt6QDt3mh8Pyor/dMcNzpEbOFGGC5jJFCrkPe7kr6NgIw5nQN?=
 =?us-ascii?Q?qNNUC8ODYZvoSXTq/v87OrSHpFm8eYgsa466lkleK4weMgrj05WjAAQw8irO?=
 =?us-ascii?Q?XeM0hsnzsU0VwNdzKX1oX7jlJlihQoIS/xez/NXO9Avbld5qY+eycT2nucz4?=
 =?us-ascii?Q?BOL7II1DxkP2UOELZLZaRdDUmxC3avSvd3oGiCVPldg0kmn1heTCLKbklAaz?=
 =?us-ascii?Q?7dkljQ2zQRBrYc7Mf9Sd4A3EhFtPnU+aVzkpIc5rSsZlZXoc+RciCvmjLi0n?=
 =?us-ascii?Q?+Mcgt/lbjdVp0rbyOmWS/+rLpdEOW3CHitlCxWcRaPih96KWy7R/QZA2N6XQ?=
 =?us-ascii?Q?OKBImqGFyrCvFVGOqupqCyAj/7CRDgLldf7JB78UmW9o36bfJrQyomD1AIay?=
 =?us-ascii?Q?9CGZ5P2A7gB/lSIjtDKV+Grf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b11baf-076f-49e3-577a-08d8ccf7aefb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:03.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLjyBk2jusrm0s1cThETpzA8foz+19VTqDGRxGXGKzrGjzcf9AH+BI5W+cqlLCJB8rJWHOE7HlS/Tk42aKKtIKUlD0ehnfp0p/mTG0ZSBrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
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
index 46e20c42119e..a90f20222894 100644
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

