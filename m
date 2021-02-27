Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46857C4332B
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C08D64EC6
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhB0ROJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhB0REl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0PmK079924;
        Sat, 27 Feb 2021 17:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IVFd2EElf5yvl+jtYWcVdOrdCKf6CNk255hvy+cM7QQ=;
 b=rtS//5Ad4YWKJLozLa0lmi/EFsfI9gx5Ba6m9dv0/a4vS56sGykbj+d8lUt1QuK+pzk7
 FRnDnYpZvlAA2xB2OeZEzl3cH4YcQCmxwHFbcJiTujRi2XXfr15kzCYLfw7QxcP8fr9o
 0pfnI01YaJzcWdLpJpm/Di5mamhZUXA4q/CuK+B7QYVaP2WCcANKEq9DTkqFLtecPZD1
 HOyt2sz7a46N6t9AmH0LVQXd/dDkWTjsR2kRtL0w2kPjqwpWceFcwjZJLrYhokOEtE9d
 k8YJJGP4YeR0ysBgGKydK7Y4in7ObSRiHpxVYkM7v3vTKcRuX90LSMSzHnaxYm/FeE+B kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36ydgr0rs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbl173209;
        Sat, 27 Feb 2021 17:00:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XecFrSYUhLtxBYmGva7BYBIpAVbsn7hCbvSY5CXCchcu/zUgYpUBCMfiD+1A9GuQLUJZN+L2OurkvxBMN/8ttg0FQr13MIPN70/p3J7MIyrAejVrcv/ybrhGokz/FH0tldqGJ6v2BgC8RJYsi0nUFJH9FlzWDwLMX/f5Mk6l1h1Kynzx/V5PSvm4zXlDSrMwQNWn3skI388lqGU3kdqVxqg9++En6lrkCXOB6yvQ2d+clm0sM3A/zQchuqB62XdRMwWQ7iYLAAwL08ngUqap8/THAO747POnxsCix4iHxeX5xLKAE4Bwa1oloWzn407Nt3wP5ZjJRBRpkBS1UCiYGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVFd2EElf5yvl+jtYWcVdOrdCKf6CNk255hvy+cM7QQ=;
 b=TtDWo1m266CXZvl9SGLZrcKxcg1bpUMdexVJKIP0byduVxBV80LsotlZOr7z54BBBIS7fXEbQgWN/r7fk2dmWnoqaDCKe515DkkD1maRs/YtNmZWrZ/lTPPPzpTCw8AEmdkk17kT8XqcwdisE1s08hffQ38H2gzXYFo/B3kkVrWuBx9CCyI2Htd18OeVVQEuEIQmuSWqh8BtdpckeW2kBKhUxpcD78TMAmTUjzq2vU2l/mrDHI1GJT3MuDZpAOqPrF71hMqjggfFBQDPHI4fePBcHb/GVqjv3aZS0aTuBIypxT7f/IAZq9jPRG3eGYHnlZqQsT8ghqG7rCiCNY5JXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVFd2EElf5yvl+jtYWcVdOrdCKf6CNk255hvy+cM7QQ=;
 b=Ngo4TIvqltbAak0aMjgPeSDbEg+djUlEZOAhcirXckPQutNgytY3GvbJ4CTI2DxZB5dv7qUMBXxrVcjdsOl3QnUxRrxcEv9cPSjkyAzIB0lfRBny/vO34eT7kJC1PwCIRW+VSzUIxLu3VErikRi2kJxbBYw1omT1Z0R2Wh/IxIg=
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
 17:00:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 23/25] target_core_user: add backend plug/unplug callouts
Date:   Sat, 27 Feb 2021 11:00:04 -0600
Message-Id: <20210227170006.5077-24-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2b0128e-144f-429c-ec06-08d8db413379
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB253843163CE82F95C0596784F19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HR5cj+SlyNgC0H/0rl1cxkdp1TahawooP/lLUE8UNdAtJeYu0KHCR34ATqvAicTgf0LaA+7PLc99nzlOpagalTyaRtkIVw+00ARFks4llZCPRL1+ULfa/rKGpy6QPEoxBnhrj229oClVUctJVGsMPqR84/Raz4wYzJieSohsv6Ekl1lIL+CB7Bc46PkV3s8u1gy1fHJLvFLXq8KSRFtnIIENR0iluvpee7Re8kw8JCQWtbi8wZDoo1wtY/ea8L/TqR0X4UoeKnVDX0uQDnRj98ekDFDXws22T2h0BG2L7hmPol8GHYKmRhkWFxzSWD9xBaslPO9hovb5kIIw3yUGkdQKrlhjhoep452p1faII+aBLIz9YbrgQSNCdgOuXPe2D7UbSg/j/+7eUH0W4tYACdrXfjTakC5nKPqg2VZJgHk408WD+vT+IO/eqQRRBjvwQqGK/EEcX4h1/xQggrTSfzuOEkxoBLMtihJ6BVU30roOA3m+gCCMb6QzriXdXkQ6RhofsWbwim1g3fiMMYv0dEOm9KOim0e7Pk27KmVDuq8u1+lb3A1EFTo5gqAQoTACh9Bd1TMBZ/lefig3ShLf6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kFWNYBojKqI7gLvzCgDAgtUfaPm8U20tTIpaZzy2s3xH1TAsKhj4NJTtZepk?=
 =?us-ascii?Q?a0klrNqnNZmQqRgWi5+M1zrCXWUiEGNDVkXGE+iWFSC+oH2XacxhxwQ0KpU4?=
 =?us-ascii?Q?8gGVgqDREvgo2qhp5mUgzsDQHsjpzeTxQAFaCb6JswUAJXW5SOa+NJmTeYs6?=
 =?us-ascii?Q?S7dcERJL7L20Rt8BqmnhCi22s3LUtpO4F0iofAcuH43pzwC150Bx0iU8FRlw?=
 =?us-ascii?Q?u6/NE1nnSnER25K40TXh+KpzMk5exu8UhN3yPKRQSpC6Xn2MlCXuBL7h5++a?=
 =?us-ascii?Q?4HgtSBZFgmVYbqG4+EgYC92VXhUvPSC1hBYjBEc5k1axA5dkllC03CpC4vfC?=
 =?us-ascii?Q?5OBTZM8wMSHRwLy7UPYm3ojc/UNyQqJ+wsj4Y4TtLhgcvnhmUezxLKUFYMsR?=
 =?us-ascii?Q?q/LDgPlkOHK+ZRaO7JARuEqUKcjAFHJnXMEWiNAayXRJ2TNTf0SKkefaQ0D6?=
 =?us-ascii?Q?ciFrk5kc7tfUOvdHQ8tGBT8LZzUSUCoP+yZHoaKPxvHlBWN9/2namvVI68qU?=
 =?us-ascii?Q?e/MqiO6phH0nFh4mTtbRgedeEkB5T0lLISin3nWXnUMnkzuWtR4SL/XgkHb+?=
 =?us-ascii?Q?KypMqLk2GTrVLf4LKl6DAt/fJJeZ6pul5mDSYFv0CqWZV9q0HO6gSuimbZ6C?=
 =?us-ascii?Q?RJfou30nnVjS/VJ+CnAt5ebVsp5ayReWMXEqSuznxjiYZINnaCWcRrtcL47Q?=
 =?us-ascii?Q?clbTYO8wz8XhTJrPeMWvWRMrjf8pvkOd8J0NO5c2nAIcQVvpcuDNbWMs083q?=
 =?us-ascii?Q?z2zj+0jpxBs5Rn+Vgn63DXMQv5Rv/iwQfukyE62QsNVHSLx2dKVJXjXd6FEN?=
 =?us-ascii?Q?pkZoVtvsy00eu1tjz3GOfgeEl7P1sz6zl3FX8lRxbpEOPabucYZOuL3bxgB4?=
 =?us-ascii?Q?AA5uk4/7xcT6hiodMieOatBYqCs92g2f0sk7YQmHWbqkzmzJaaZ05LgWJ2fm?=
 =?us-ascii?Q?bILHmh3c5wEcOwQeXkgJIyKJtwlr5xyAc/69hDzoaPAfLcaWvKyuXGi4dFYQ?=
 =?us-ascii?Q?EeLK39KWk9hWvRRb5P4Ay0Cy4UA1s/+lWHHKZzQa/cQRqU7vvgyHOod++2cb?=
 =?us-ascii?Q?ZHAyq/L5l1vsi74U9wAHbNF3k4SLYECQ6yrwH79V4eI7rD7/mGWT1ktFfKfY?=
 =?us-ascii?Q?Dy/48QhIuM58eZbRspCktRN2EfJUKdZTXFv5bZ/ocwqtqVZT6cmHhibW87jx?=
 =?us-ascii?Q?QYgQ8ZBdhREcz7WPNk9rgBCMMnQMHblO3WntKsyuyeMb/JpCt7L5hoQB44Ls?=
 =?us-ascii?Q?L5Q8hPsBz2uqBqViWkIzU+GU6UvMdcoxThyzNmRf6ank3aAUTL82hPrKl4/6?=
 =?us-ascii?Q?zWnFMvaNQJqPMYyWGgf1iqIi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b0128e-144f-429c-ec06-08d8db413379
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:35.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PuaT01kFXyg3prJBXuRjl0MTU6dnbdYmBvyJ1bpkZhrxKJ18sPZBTQ1WogDFqb7gFq8UoFaEZG47SwKl4n3M7i4N3bceNqP2nM5YDSZ6JJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds plug/unplug callouts for tcmu, so we can avoid the
number of times we switch to userspace. Using this driver with tcm
loop is a common config, and dependng on the nr_hw_queues
(nr_hw_queues=1 performs much better) and fio jobs (lower num jobs
around 4) this patch can increase IOPs by only around 5-10% because
we hit other issues like the big per tcmu device mutex.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
---
 drivers/target/target_core_user.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a5991df23581..a433bda56b89 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -111,6 +111,7 @@ struct tcmu_dev {
 	struct kref kref;
 
 	struct se_device se_dev;
+	struct se_dev_plug se_plug;
 
 	char *name;
 	struct se_hba *hba;
@@ -119,6 +120,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
 #define TCMU_DEV_BIT_TMR_NOTIFY 3
+#define TCM_DEV_BIT_PLUGGED 4
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -959,6 +961,25 @@ static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
 	return cmd_head;
 }
 
+static void tcmu_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct se_device *se_dev = se_plug->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+
+	clear_bit(TCM_DEV_BIT_PLUGGED, &udev->flags);
+	uio_event_notify(&udev->uio_info);
+}
+
+static struct se_dev_plug *tcmu_plug_device(struct se_device *se_dev)
+{
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+
+	if (!test_and_set_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+		return &udev->se_plug;
+
+	return NULL;
+}
+
 /**
  * queue_cmd_ring - queue cmd to ring or internally
  * @tcmu_cmd: cmd to queue
@@ -1086,8 +1107,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
 
-	/* TODO: only if FLUSH and FUA? */
-	uio_event_notify(&udev->uio_info);
+	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+		uio_event_notify(&udev->uio_info);
 
 	return 0;
 
@@ -2840,6 +2861,8 @@ static struct target_backend_ops tcmu_ops = {
 	.configure_device	= tcmu_configure_device,
 	.destroy_device		= tcmu_destroy_device,
 	.free_device		= tcmu_free_device,
+	.unplug_device		= tcmu_unplug_device,
+	.plug_device		= tcmu_plug_device,
 	.parse_cdb		= tcmu_parse_cdb,
 	.tmr_notify		= tcmu_tmr_notify,
 	.set_configfs_dev_params = tcmu_set_configfs_dev_params,
-- 
2.25.1

