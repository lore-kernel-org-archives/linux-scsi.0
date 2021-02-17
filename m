Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B24DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FE764E15
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhBQUfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:35:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbhBQUb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKT6Us122972;
        Wed, 17 Feb 2021 20:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=qR/f1F5+v6IHFpPY7E7+iPJtTky8x1LLZgRK+ztCp8i4TzIeUifiqzoF32Umfp1WZdG6
 G56Egr4kAU+c2Tf0e+uXJqpQMH9BgKQP01HXUU9i6FodSXjoS9jfy5a2d/a4fEajvikZ
 6im0rXJFCvz40NK7Xp9OZYvCj36Fg/Dyu2pxM9xRM9XyAQrQtookU06QOFltC66gbdIP
 AiLzLld5oEoGvJZfNrDB3LmE+XI8YM9IsSfldWcvP/9bGd7oZ/UbTSXdzjOoeR8zHCHw
 Zqa6pLPXZjLRyzBAwtfbBo/aljdom0kSPnxtdEUJfdL7HkJMShsIPoLXnClQVjstRll/ RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r3san-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ6x7111972;
        Wed, 17 Feb 2021 20:29:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 36prpykfjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa/0xSwsEma1towz2BUL75J2LaFWlF7e/Tde9rZESZi7Xwu2NjCfCdPc0Q7sO31bcp3nHPbI8ZQRtbZm0R7ohA37HRsCh8A373oE8MN83n+dO0zulvUGV9L6mkd0PVhyrE/cCcD/UbX+QU8ba+ncsnF1FHOO2eHV4dijCABbRblwxGmsTYduGbHEUbqbsO+9pFUqs2W/2p58whz/YIYEVou05i79NHfsXXyYNubp1XHUGdbQmodceetq3+cXi8QYnWxixH+QRbpMW9ck3FebyP9BnwMM2MQQ0tpvyYyHo1aNZggJvehJMpZKGlJQTgleG6WGDyZJIMunZvFCdyNKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=ZKt9/P/jQkCIXDr7tLDE2zSerN5AFLUxAShRkRQpsVPaeTKgfDDWpM9RKLYUxawMj4pBnMdFHGdHWcyVz6hmzv45hfOdYpg0zNPMmDndj0tcnKZCtMfmRQz3pqMNNroWEmtmHgM/hcEh1kVy2P6ngi6ghH3h5/7nlnfHHitV8dO1xFcTJmpSr10qj7Tw0KOi5jJ6tCQk14U4vFqPgJPpR2XfvpENy6pV8a6z9jJnPk//tOuk7x+AkeL6HMFKpGXoVNWKK9U3gY57gsgIJBj8kcyy+84LQV1sXs7FtdnEjHoBOMrLG6+OUHhNilUiLG6QcbX0VTN/kO/Ux2RhSOXLew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=etMajaCvMAh5czifdEVMiu/+/EgWTMAFOZqZznbD4iVbitZr57EXX3KcnHuomRhzHDYv5qh/a/vQVcc1uAD8zMBJkMltQ0jDmgbo9VrF1nexhhNLM5Y1+Jdeaf3snVPQU4lsMP39VYnoKVMrS6L8xn+jctIidcurXA+Ll60Rl4s=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:29:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:29:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 23/25] target_core_user: add backend plug/unplug callouts
Date:   Wed, 17 Feb 2021 14:28:09 -0600
Message-Id: <20210217202811.5575-24-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:29:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69bd80a6-b566-4e6d-1f36-08d8d382aabb
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3940D8948874677893B9DDDAF1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrXesSPOH7y5REIDmo5lIGW7eAx1kQa8YGWgFNQtLYQIlhguPk9R/ASpUB6S9UlHU3c+G8B/aK4MSU/jkYi6ELxXfe9Ro2NK3guK3FWarnf771TFMyv78xEgAQlRIf8j6thCQzEvkUQ41kkkLLNpf4QH20y4MsMFXZR+h1rS1TaN+GGBKIyWO8LbjyPU2om758FyBubRbXdflGPagOMhea2yXBUuGcrcTd4PXxa0iapAV12emSiWqOWJ7gJdPg/OiIOxL5J01IoGKtlbqpKoxubhw+W6z5E6LKVpa2SFrM2y2imwDL0uk6NPCpqwEiM/hAmGPG/aX/QoOhS54mriXQjQYxr8YbCQ2ItR6n8XIZ/zoB65pbqyEK/doXV4MXTRRmIRe1sLKQ/fO26N18vfgRmQDmD7M3NNr/gVudFl6xI0FvTVq9JzwLfG7dZHTbUCJTKHaNC+Ah2jGWvuRh895N5dlC4extPr/wPVUkSFtAVZibE6ElfTCd8NS71tcKm6ae1QK1FFJ8bV603XJAGqUF2TUiM28unpawtsTW5UygTkuxPHb3m8lLA7r7hGR2yiDCcARpAcdbL2XxaeS4jqeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8QbQylbTlHOVvUpPUDrHjWEWmCCkoEkOXDsoOXsef0spnnrcF0I7zVuO/nav?=
 =?us-ascii?Q?wJza/QHQzERlDoiuVMc+3Nw8W926EVB+G0iAjJHApe/0LwJHabehbGYSh9an?=
 =?us-ascii?Q?9mUiwuFnODdVmLT7SotGPN1QHkEsEFA4wuBx/9nfnKbRLY/KRp7q0mLtkXm4?=
 =?us-ascii?Q?HN3939WTdeE1k2DF8dk5gxpNGkzWuvjKqNBepL5E7dDWMT3mf0LofIMvcTuA?=
 =?us-ascii?Q?wZ6YRSYP/axxCa4IiLkRVR4klGv4ma7jVOCcI57FgMiZicraBA5s2XQZD/Cm?=
 =?us-ascii?Q?MtsF9sHtOx6ocJMGrmuMMLJzwxVAFkSQYny2zmrBTERotcjMxgwYXR2zmrUI?=
 =?us-ascii?Q?eTC7RLmjdCRDs85X7ygMO/fs3E5L0TZWQ2gaUSh9KRLbMupd2CREENDVfDcP?=
 =?us-ascii?Q?jJQ7hobHQZ49EG95NDZ2enAlKKWpgOa9xXOSqg57j6wqN9xdkgQieMP0qPlh?=
 =?us-ascii?Q?5jZL8evMklcpnmkhGZCyDyyvihHaaTzTwO+endrPe6W43ubZmsGkrhokgla1?=
 =?us-ascii?Q?+5ylChO0/hHDH92dUMEDBxgpEDrlzFl6flDj6QyX/T1A3845IOU9d/HAAeeJ?=
 =?us-ascii?Q?rXli9p3MzFf1zhXfKpwDGCn62ChBkGBSL9FaD3UXXa1Bq+/IZQdHMfJCg4AA?=
 =?us-ascii?Q?vYM/rUOi9l1V3AUXQrY/ZUHEn046wbSr8u5hHTuh6TAy6Si99dbvGV1VgOFD?=
 =?us-ascii?Q?IzHEfB/03qwWanEO7r2lCGE1x+4UFQ5iY4SByNEWDvZy2X+nxKkqmSyQxCes?=
 =?us-ascii?Q?4pUahS7pp3HRFAbHcZ0lLIE+WCeVlbP/ue2k+IoApBxBNZ3mXS3/rLEfcDrz?=
 =?us-ascii?Q?M0/eJDCsmOIap8MBPPRFqKABRqNDyXDF5JQ8XrbNSJg0hBTF6QUzQGPxAYH6?=
 =?us-ascii?Q?J/+uURi4IQhd8V1l4HmVaBDmbRQFz+dEDWZoCvfP36iUS62x9lVYRzGGws4P?=
 =?us-ascii?Q?Rr5Oevm1Py4zLGWdEQgcFuJWPDeJKWFM8xC7Zm0r+Wa3NtlSz/Gu0XgmkR1m?=
 =?us-ascii?Q?OTTtbzr0sB3qkLHAu7b7sVtecRwocGktUcGvXIFVxlp4JonjwpwU/3Y76Lpd?=
 =?us-ascii?Q?4LuXCLJ6kta5BmgjOSw7zL49I0+OeqeMv4rux9YAwvMisQZ41L7KxX5bVvS1?=
 =?us-ascii?Q?QzhGtdItJt81YK2JQXDlGLW3CW2EYCZ/+UTKohYwU/1Yijpgq2mpMM3BPIK0?=
 =?us-ascii?Q?pzczdcPjd8go03hlA3Alk0uWGTFzYjEsmyCoBoTaVKPgl14tA3HlJPHz3toT?=
 =?us-ascii?Q?R0jKaecztrcSTVeF38dwxSPanyRvcI1eZfAdFYYfCZVPx8jvKLiN49jISlaJ?=
 =?us-ascii?Q?e/aGPj+khgUCfI9pdsOEynpw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69bd80a6-b566-4e6d-1f36-08d8d382aabb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:29:03.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBjCkwnX7WhBBKiRtaFyTLL5Q/CD0jJ/jtJsC+/aNpq7vGnNqIv3RjdUbsAFrXghaU44YyyaeYZ2TLsJ2m0rUDsc7hERsPhl8YnL6AFpAiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170153
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

