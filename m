Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD554C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9074C64E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhBLHcf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:32:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBLHaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PnUu142718;
        Fri, 12 Feb 2021 07:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=CG2Tjt85LbT5MAwQAdvr8l39TDwjJB2U/+clnJ4pRLBILFNGvms4ZT2WwPeieJ/IYQyQ
 3qqRdYvqe91TtOO4NIonvSyhvG5otQ/PLJfbPr+P0x8o4XSWw9r4VKa59f9vGIF5XP/8
 7kz+qnPAh3Q2ZMttBHQI3C7KlLrNkVEgnytzPR9zdRTkDEwoNjYa+7XN8XnEel8bITQK
 QH/hfAO/a/sA8/b6JV/O6xsL0HfoYcX+NH+1fvJEvx9TndABK8KbM9Cj1qmieBYCGL/Q
 TrDiJUnGMFsujhiyG482al3hf2FYNvPqjsgBDRbjTdFsybJ3zTDW+mjT/Q7Bl2O9IBll NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7QA0X090287;
        Fri, 12 Feb 2021 07:27:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3030.oracle.com with ESMTP id 36j4psn5w4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbhUW76vMqVEDctUcoeZudGCDfxkNjoJqTWg1CJG1H0Pw4c67jFlM6C0uSMmeiPue5U5W0Zw4JR3WU26HDDb+OXTpOLPaStJV4TTQg+pUWsSmeiCI62OLlTepZq/3/MmCW1+AiBO0O3omSUoS+wDnAH4SH1GOSR35hrGFdaBtR089x9Ek0v0UMEYNIF+gjo3rlb+pL6uP/AUCtEPAR26OJxLN3QiRwxvdLeDV/juG6vuA3d2zsUS5k3hPFhYUcGxheRozEBrhZywgBtBK5SUyycT3NvL5GNirEsMYYrHkiNyV78yPrhvxbRDr0dzqKbUbv+UtDUzlGXj5985SJnngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=S9nahK9TqXd6cQfu7iKWGsIc6KwHM2AWYY2OI0hI4L91pyPnU4RKkaaa3njGSO/YLJvG+FXXU2NBED8D/UNrHO+FlUVSnzYlGs2DhXS5R/h3sJpeM1Nq8VmGtjpheEDdUWPv6b/CxSb43cSB0fQKDdDFKtJj/gtAAGk21hFbAkgQnxpvtgP1fMbRe1ZmKvBquhlz5ctT5WUzdZW4pOiF33XwKvCRflBzSwR7QRqE63BA2cGYJ1S+UJ7LHPItGgLRLo2yJ+0LhwMZM4E9yAOjRQxBLECWF7NwfQPql6Nctw54jAUxZozKlTQBdj0FiOdi7iZZHGn3+rnrnJTR/Ynlqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=efOlhJG1Yg5G+2cmLNQwT2QskBtYuLTIocvdJlPbkvut7IommX8n8WHoSIUCaacdAVh43TFWHKQDAPEm1Q/P0xC52MGvGyrzFVyXnAkmQqEbUYjcuNwvmW0QHCOu90YzM8gAmZhGw3TaBeu+P/bTroU/+UfsBk7vjdvEWCi+sVM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:16 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 23/25] target_core_user: add backend plug/unplug callouts
Date:   Fri, 12 Feb 2021 01:26:40 -0600
Message-Id: <20210212072642.17520-24-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9261523e-d005-4c7d-510b-08d8cf279f69
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254DE9A85F2EA5A6D582561F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O761EKvGCnfzyXokc5CLuwoeYSneh2upsmrVHl6lnZlqZSumbEEo8I1RiTUOcvCaB7kW9ZFgygRH/W63PV0eOJ5tGbNGvL6krl5su4rMmYTZshuJH1gW/6Eu/3+X2N9HSCQq0PEkBP12r2y5g1RAdOgMKD5dgOk5+m4xhaWPm+RXjv84vKWKwx4c0NSXtfGjR82oa7F6BSyvItZ96UTU4kGwlcj0H2OXEyfW4mpEiDAcqA2YGCBczBDTWHArlDUuT5ZfaoB3qlv41bGLGK4n1CI+LfC18yEWdGoUy8FVkpyzHDUPHHkaf4nZmDzsoqBi4bJ6VYlabyx0Lm8uh374Ln5EMfw2c9cJT4q+UpUzNedbPnTxBjsDRvCNTY+HbDgtj7nvgo0SrrFmxRM7h5s9YRiIkdbIguj/mtK+YyXQXt4fC0D7yJQjsUKkV7RWCoYjDRx8Ug71zbMx+X8+gW9EjnkiNL81sEDH2WQMcUQ/j5vdccGlIxH7UEiUgk6jTMAF6UCIiC5kgc7nO91Cgn5s6bTMGsO0ZH/3teigwDcyKvz6djxrpNN02+ogWHCdlP6W4wPynu/mYlanJD1Xbo3O1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kGfNDJ/pxX+TsuQQKKkCm78VdB5iUqERC5UTstO4MY3gqTx90tej+DA0zrDj?=
 =?us-ascii?Q?UswbWwFPcutxd7hs1b+6SRXt036Y48SOzUvu5LxU0ksaN1YmfMfK4+IdtBw6?=
 =?us-ascii?Q?iiAIwy2ObjbMp6ECpd3TbdGFpEt5rpzYf0cNiO7ixklDnpvZlp9Pj0KaRVr9?=
 =?us-ascii?Q?Em5P6MrNVMNDWuGfyIie2cKd5xR7eM2dTxZE4BldlACdd/XGNP6MEyO9s5wZ?=
 =?us-ascii?Q?pYHIAXs6i806d6nHnV8pRlClBCv8mXkBIFqJKNC10S2QbEsy59IT4v5e6dxp?=
 =?us-ascii?Q?2ed2PKj4PpPcYBjW1Ld7G9kx99BT4GJ1KMEpoNWUFr9s5DrnQUrxD88bT1jt?=
 =?us-ascii?Q?YL9dE6D3Vdmsi5j/s/p3McWbq8HsCWlouOVaTwi8z2ooZtouby4we0m3OkgY?=
 =?us-ascii?Q?96ikdr1Vca+VgE52X/EBO2YnTiKSL2EJuJMBxnniRYyu67zy+Xzn4gPe7YCM?=
 =?us-ascii?Q?3aMAozjaaBoMplKx5De9NGG534JjaC09mfgBvK7msZHNYzuCygphIXeeBmVP?=
 =?us-ascii?Q?7XYLw3xy5Nae5U/CJeXpYKgVs7D1lwj7ueSGq7B45KB3rseLkGfpfGMTZ1kd?=
 =?us-ascii?Q?2d44yMbJTQoVvFLFkz+pMagZrRLfKsG1+z4Ol8UdllGQDcgg/hESxfB90ouM?=
 =?us-ascii?Q?4CY/Kvixbh/DeWEtegII86gqbZToH2NZQV4WllobeHyuF21a49afSS3XR8gY?=
 =?us-ascii?Q?X42VDqyu/m3jBH+4grVTtJgK4Wtvtwe5qgJnyfwcZhpuGJbrHKzRCI+SLA64?=
 =?us-ascii?Q?SBFdzuMt8Vby+YVfL6AwOjxngWQVAwXmB7ves2K+u6wkixDcT7enbHjacIH7?=
 =?us-ascii?Q?9+p/q4qH0S/1ldPInqsTbYy5wf4NHaeBVnHb1Zm/lNQoW7S4a2Vw0Qk7sE9r?=
 =?us-ascii?Q?yXefNIxHmdef8yVx/WqI9aCEiUBhxQ73mio2nS8TgACytPHxApuDPjCE92iS?=
 =?us-ascii?Q?siEmFDQn7gkrFe2Erxf0M0x5DWIDM7jmERJUUR3sjALKynK1IBJeLVpDPt0R?=
 =?us-ascii?Q?YMjzA7lC5R5JtoYzowSoKut6wNu+DQke+6cPcS4b5UC2Pl5NvFkWr5qyGAr9?=
 =?us-ascii?Q?bdowxa8tFCg1/AoXYltW+jzCP9G6C7DQWVEMi9xeRm2szA1o5W/ReKEJrLU/?=
 =?us-ascii?Q?CjnQP+J9zLfm7pAPIhYfik+4utpkCvK8Jc6pv1q2rG+lsw3RlZfTJXEMpskU?=
 =?us-ascii?Q?ZSNm334rb1qbRzIJZiwJNfIa5J/KR35LwukMCFeiNUpxvRRJkkiHKLoWQdZE?=
 =?us-ascii?Q?onG2RHTnFdfXAr1wALK3SOyl7dAeKr2Amg3mjKyEqnzX3uwNYWeNKHbxQkeC?=
 =?us-ascii?Q?1v6PVGZsRUxLZLIPv4eB/qMy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9261523e-d005-4c7d-510b-08d8cf279f69
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:15.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tPr+OtcFT8h43sxbJ7YaHll3E24fJXJGCgmEUZMmcIm6Dq8aXF0N1LMc2ODNwjyisKa0Z0Wx0jtW8hARKLgiiqEMT5v3535Vz4S+c7grGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
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

