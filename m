Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25531C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E343B64EB8
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBIMkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhBIMjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYkxq038321;
        Tue, 9 Feb 2021 12:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=KclUObLCUqKE/XMsQZmNavMXW0k/hkril4g11ked4Ls=;
 b=eHOnPLs0nHFN/+NGFDVB/oIcrKAHMfc42o3FmKUPRzHp2veKIa3DwOLAcUvPPIpJGjR4
 +HfhP4IQKrhHuaf6X3CqWuB8pCwsTHy691OeS2fIQVu7wAcPoHLPuGkfo9D4l8ylavLd
 WK6cfxOGL7ACJ7J+Q7ChzMlWtjAi9C4k92T6N829PrFZenk3XnWRJgDbfYHO490lNYu2
 R4A4QgdOtvTnRdyjmhiV6kp08basfjZa2B/JTm6rQviIsez1YvUpw5IwpnlrhhLqbrRY
 tUixTdT2agDkk03kyjsbXUoiY+HzIw06dqPMS0UAPh7+rbSzywyVdWl3zbIHXNJ1Af4q +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36hjhqqagn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZeCg029740;
        Tue, 9 Feb 2021 12:39:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 36j5115bft-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0dkMDl+C1Rfu+M2tVd7ssbgWZ/5diJjDlGwUya8vV7kVSu9QtPT+7aJQ2rirADYjnWhOtamIpEuf+mamvZukiFg+kZQ5n9NsC91ygWbCyi2z+y1iK6gbtn/huBmwPapO0DmxQfSYns6yYOMJ2Z0xnVaKfmh44V4+oMojqAsmemdcaNJKQHWFfxLOs/i6a0CLuaEnYJK90HtTegj5W9wHIE/Ziv2zeGTcgHvPcJfhw/CbAf8rXxokROqGLJhyrMTORPbMEdb7OsJBRdN54QuV3aO7XqInYOrmCi+YKqCrnCmEAfzAYfndzr/eFbCNi0LBFCIy2by/Sv2rEbekeDCnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KclUObLCUqKE/XMsQZmNavMXW0k/hkril4g11ked4Ls=;
 b=oX0ZPfAz8N8N2aupyofM8PG2yqrU1yjrgdgfQ/wx36N1hx9Hz3Sk4S9jXsc0l8Tp6jJdPbhmuDtJxJvSLJbumbaEcx5zYcU9Zn50s/MPpPs+AKk5ECR0bBwBs0pYpuEK28NVMTGqzKDKM+mcWjcA1Y1Llz2FDNka7g+RvPlEoisDu4eSLe/UdKH+k9w0CxDozX5Uf6FGnv5PORNrVbocItrvGPw0YcUMs4zVX4/Np0Vb/Vneok/tqSAk7F9j57gl0A27wpIkOzSEX6vTOr8/et+hTdVDV5Q7WAORgHqfuqAZ21vhs3rnlg+q8YYJ5wxpZKRoIU/F5aUPWgfsbnW9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KclUObLCUqKE/XMsQZmNavMXW0k/hkril4g11ked4Ls=;
 b=v8qQMPOOXwoLodO5RYhwxUVRGB9WDNE+j1FWi2BFB44eQfRiHohEd7EqxWaJ9/XfDzIV/XGjpDoo2Nb06H915rjkkUvUD3Z5SZrfKDHHh88CHSes/Fw0pWFFwxecioSmUfLqAIiHrkUO2o4EN0+1nsVL4Esql+zMhEzmFvENyHA=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/13] target iblock: add backend plug/unplug callouts
Date:   Tue,  9 Feb 2021 06:38:41 -0600
Message-Id: <20210209123845.4856-10-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b6e7608-6456-42f7-3e84-08d8ccf7afac
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB26000FDFE7085B07C5F7AB3DF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /msOQ3hP3wgOqfArpBkPpLNeQRjnav4TpVRDoRvrvFo+8bXJ8rww7LzL3CnW0fFGIkNB/8pwy1lNFJT1LK0wGpAmvVFLUbGB7VXTZEH18fp9ZA+tvFpoMfIZ1wWlKoDyCXNFcGHsGZRq1RihZayvsjXgas31URXHqm+/4jyAlmxM47Kb431Lq4ibk3LSlU7uIYZFZIVqQBa373BL05v6YT6gY8l34KQH9BevI/h3hudEhz5Pu8IQIApKNS8t4gwo6FeyqyXt0rb/Br34bhHyHHouJSwwS0gb3I2qk2PY0uAdw+URwsSOq6UpBKSE6CWgvjEcvRu20vANmh0fFO6UyfxV2suFCA//lAKQN9X6uxd7liUYx3h9xk2oQxX4W2UDEzsVLtq8mwpwXDo97zveZBpQNoPRJOy5hirExbNXDfLia/SOWF7y/ajIvRIku78FMZjUeYQ+gBgmyV2AUwD7eVzIl4qF94Ar5yCgk859XoGNbcGMPygkzq3XbuNx/fsM0Rfg/xWzaPoPMprMXVDy+9REyTRH2Mp50wVbEsmcW64lHQ1rN6kjUrGA3HhKS+jPwuElH6CtbWb/OuP7gVTv4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4aZZDE3kHZlzvOOpuzjRgk58d15d9tB90xvH+nXZxghKycVuf0Alo7GLygKW?=
 =?us-ascii?Q?Xd/OYSTZ/jtW2FwDEUzzfa0AsEcScHARUJPNFN53xLx+GciV76f++keZwWa7?=
 =?us-ascii?Q?sGaRaoRZLeUgLo8aluLHvpvAgcAiMf4YIkz3IGMux7pIW9ngXr9JRFRSaiWq?=
 =?us-ascii?Q?M2QrkwCs1ZrX1SlX7XbRIEd20eurECK1QqvVJ533ao2yClYvZmTKQN82xnqL?=
 =?us-ascii?Q?VJFyswrpSF2l0sR2b4ZWXrPg740uYMHEvUl5n9sMqj9m/B5poK9LH910VqZ+?=
 =?us-ascii?Q?BMklgzz1WzBnUePvkRe6hZ+gMWtb/MckZ4emrJ2uW2ik8vVwoWu7Qv0jhbi7?=
 =?us-ascii?Q?MF43LLDr6QIXw2hEjZhFJRJX3Wjuxy6aXCNdq2YUuo55HQRNgLUlmro1OZkJ?=
 =?us-ascii?Q?SN/QWAEWEx7ErFmS+0xx4jJzjcLquVIDW0z9ESN/GqVr3I3ANjQ75R4fwEGU?=
 =?us-ascii?Q?t18aBWJuj/8oIKCBQA6dfftPQ3E2Zx6P/bSyyVwtNoscri/kDtpU7hBZEUDS?=
 =?us-ascii?Q?ZD/vJ8ebS0W9dps8sU41YDCC9lJOOkEpVy2hpwGs2p6AxSt7eO3YiSnRQ3gb?=
 =?us-ascii?Q?keSZg2iKvn0QxkvAqwpR8qyNDBcqkZZLCS5i+afjwZJpl+dUHMME79l3n6gv?=
 =?us-ascii?Q?8Mz+JddY20vljxgjzAVTG6fd7GA886MpkWglFrPrLFIPMXFQRxzQwm4lxYL/?=
 =?us-ascii?Q?1Y/38o+ncgkiclokkplt5PJTptdBUbxhy91xXjtkTD2e6GetDiHBdpagvMlI?=
 =?us-ascii?Q?wrf/xMH52//D+w2iF1ZYR60sm5fNQDV5bilUc676OIYu0sdfiIlzQE0msCEF?=
 =?us-ascii?Q?Xvhm+ki3RG05CiKe1w2xuMymOQxCBiaT0fvQYn19v9UMY35PmYWEtpzJQDN+?=
 =?us-ascii?Q?4peUEBnKe7VXoYkSt+HCIFxh5F63qATSyqqo+xb+JOb3HZDZd1+Fjo/q7T7M?=
 =?us-ascii?Q?HrniEi5Oq4N4v8fzW27bL5qk3hcVJyJ+I5z3T9R1VELvJ/HPeENyoy1ol4EA?=
 =?us-ascii?Q?S1nlHWxNRmwLagf5IAgi8mUZPUSlzjZECeIawxv8p66GqHyMiaFxl60NZsmU?=
 =?us-ascii?Q?k6B7PkjO14vQiWOdppWNZBmjBGZncge6TVhzhPKxpusFIkQ7VnSEwJAPkt5y?=
 =?us-ascii?Q?sdvev99mtj/XjVtJ6IqH2UlpGUUDgwfWjRpqJQtKGp/ie3eklxnNaWGFKZ8w?=
 =?us-ascii?Q?8R88M0lBu2Mz7DU6tHCWZU813Fw7yX4Ox2H2ORi9/+9zXsKZr3+Y4WDmlxuL?=
 =?us-ascii?Q?TinMp5AkaLiY0lePxlnB2hYy9p7j84/jtjYllMCGVe88ooBR38whUfTnqZVw?=
 =?us-ascii?Q?p0QohGBJeuMHFTB1CSXyDtaI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6e7608-6456-42f7-3e84-08d8ccf7afac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:05.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIKT34xiAnPMvQojJQw639yb7IvN6nqwuWkai3x7YMzl4c3L13/WSsg5wlRxSh6vwIiZhW+CUXRyslJ2d+ts5KquCX4RATbzUhYHXgItKto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
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
 drivers/target/target_core_iblock.c | 39 ++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h | 10 ++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..58e0d47d5163 100644
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
 
@@ -188,6 +198,28 @@ static void iblock_destroy_device(struct se_device *dev)
 	bioset_exit(&ib_dev->ibd_bio_set);
 }
 
+static struct se_dev_plug *iblock_plug_device(struct se_device *se_dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(se_dev);
+	struct iblock_dev_plug *ib_dev_plug;
+
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
@@ -337,7 +369,10 @@ static void iblock_submit_bios(struct bio_list *list)
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
@@ -870,6 +905,8 @@ static const struct target_backend_ops iblock_ops = {
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

