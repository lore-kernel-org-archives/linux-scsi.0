Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F30C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABCE64EB1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhBIMkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:40:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBIMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYADG054675;
        Tue, 9 Feb 2021 12:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=tidXB8n4fN0LxkN855F3fC3XEAjGcZwFTrYtF55Q/e8=;
 b=K2mexNLD3LpN6fypIYMFVcq++KY2XAEhy9brjWTes8hstOB85y7HZFMM5Pr/sqDgDsc8
 BRHw6s1ey9RWd63JgWs4WbS72AmC2VqX15T3jmYjXMtwt3SB4VP5T/5Dcr2W5sf2Csh5
 jE7KMjNMFnYVM+SEx3Ds+jWJJjEoLxTXwrun7seFfHq6VfS/KI4tQ7jYJinMVYgo7JCS
 8o8kHQUTM3qcjqGHZ4vxxp33Cbijbkj/hBqWKXk+k34qxLNR2mYUe+VCKf73ne/Vl0F2
 JtavGsjsA6GiA1W2lpIo2KvKdA/BUGCFrcun1yx/IjTMeyDFA+t49mTjdo2TszTnEutg 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgmafe4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CZJIc035198;
        Tue, 9 Feb 2021 12:39:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 36j51w15v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:39:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBDtvP9tGGI7VZUPg70e/uYyJhBR0POUPPLVYn0WNG0cLJaRc8fweuOiFeXjPEFJfpmuUQqTCu4QafpF1DhtaF4zgClWY/wRRjYzR+IoUzEL8kapdb1lY2YVb36l/Fx7KKEXnnK1/ejba+a22AzCs7AxgLbStGTnyndcJ8eC1Lb6P3j30B7Cq5DJagAbQt1hrTPo4sJDy/stlVPVvzodjGyiN02YlHjpTIl7GxbUD7eli7C6qE1GneSiQLOh/jm7Vmljm3+a4use1pq6gouEtJ7ZJhB5P5Q9oHXTFxG2ebJS85nlcPsV6062GFCtk5mBBTfXogoAklnZIaATsvmMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tidXB8n4fN0LxkN855F3fC3XEAjGcZwFTrYtF55Q/e8=;
 b=dpFdzlvByb+cNYuiSHCLa7fsQ6lOV0uFrH3ZPB3XvH1Z2mNcpIwivrfHlJfDwI7NCfgXMPZSJwayAQJCsPEC0zj6ADmyG1VD8X9mJSWAstpSEEF9iboIeIGUXTSS2dwvlUR7hf1UFJiBASJVTfTaZW91293ZhMqS50eRfBViM6UNbpnOi9Bt2oVkTfGfKBc7QErkc+TcskRGZ3Bxc/OrsbsgBmYDjyXlXB9tx4bL5PED+LkB7x+tveU8Ou5U6BLMGdfL9oKScrJIdiMflEg3Jm2DL1rvNpTQSJmO67Ypkr4KCvnT9ooxhJvqtJRPhMNxiZeJW+Oc3ywnCm0T0hbuZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tidXB8n4fN0LxkN855F3fC3XEAjGcZwFTrYtF55Q/e8=;
 b=GxJrQhXHt3jWW6BG9J/lscgywhTcylBVhrzznnbTlPRLErXDS5n4Lwl9i0Df4CGNjZ81uj48wPYZGblv6DjOTbdTDTyStrvzUBIEPMkrV9jZFJWJtaNEm24KMuw/A1atfZCMzHqlyKk4iQmLZXmwknD7zCYLuBxb+ztYCtmA0yE=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:39:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:39:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/13] target_core_user: add backend plug/unplug callouts
Date:   Tue,  9 Feb 2021 06:38:42 -0600
Message-Id: <20210209123845.4856-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:39:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcce3427-d1f5-47a8-9ab5-08d8ccf7b05d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB260032C88B714CF90764A079F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWYeThUDL4emqhKytf2p6Am3DzAvR/7111WoMKqcoRNCyGzZ/eytExz3knDmM/WRY24Trh+FVEYcW9WcssUWml5zN8gK0TyIKRHv/Zm1Z2EzjAmjPr/Ebq3LhF11BssQUwk/XrZSwig7qtzX02NvUroAzUhs5LcYBHe1ztmCOgfG3GA9KRkYdsB8DS3E/WA47rGLtoHXh0QaqHVguegGVAdDD3YFKK90w6d9bvL1dhQSS1AcVSMdGyTo/vz6uJ4JXw2W/WZkNFj8mBPQQwywBMY8whSIi+gHQtw0elDW0o0bbwV/nXUKjEaCGtTM1DXY4K1dkBpbzcBzjR1wY4BheLAtFYOJezVxEcZyj1YzODo8fs6sdysBiMwcIKEwoBQCir4L/GSkjyqznudBSus1765Z63VUsmmpXq7kCboUlMXcZA6PohB0FjfLgVsSoqguFC5IWydpXMN+f3ip79uGFMEmPxPEVPYmyyo3y0U2m4eGETcqXNCJdlKJwZqSEh9HpWiR7HotsT8zawgiMeN8H/DuwGDzhP3pWdLN7NoxGzKhxPru8EcJIVhVlprjxWr6jVJmleJccnLbTTGqiiYNxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sSLHnddR6K/stmV58IGe1ogoV0mnAt0aCF1eWSb2bZ0fGSyl7xm+l1xd/iQT?=
 =?us-ascii?Q?LQvU4wov6ZgiBt/dbxbnz432LcZf8XPZubq0XTbk+byN/xBAo40xrfgW3Nkl?=
 =?us-ascii?Q?5KIoXXyx1N8goLYma/KfOkU6rv91AfNYFuRfJW3rfVEQyU4HOP02JBjjP88i?=
 =?us-ascii?Q?ZZ9LZSVzAOEg7RRPPqyST3Ud+KjK4+XZoVuBoehWFbK5g8xQmI8g8M3YVhCa?=
 =?us-ascii?Q?k8r90eZGTO+0BEq4/0nhPsa8cbyt8rEU6Ndk4qlN+AUOTnM1SvYu4BrPQP7N?=
 =?us-ascii?Q?gM1IUqcc0ivOrDuE8jTOrRt3lsSK0bpJpnEr5Fom0lyv7SEbpbAkA8qf6G0q?=
 =?us-ascii?Q?g35GFSMQCAWfwnUkOir7jHJYneSi9wjewCDBNDanefRxVwsebXwsW83dxnbQ?=
 =?us-ascii?Q?fVcbZZptyloWSa0PceT3Uc7wnzHT/7xpIJyrpSSfHhIOTazap2Nf6Duap3nA?=
 =?us-ascii?Q?Xq6Zg0j8ewt9tqm1uNhzOouzkET/QQWvvNhHBtRNdbRaR9Zw/KtsyU8Fwrep?=
 =?us-ascii?Q?NUrTbHEvv7D9gWcxogEjg9kdn3+fs9CQoWCaScs5c/Z3IA31PGSdzBWewBrH?=
 =?us-ascii?Q?sSBL4OFfhPjE57SVIH7Y1HEoGrdRC8iUSZNogSL+t3Tb2w9PmrnNMonbThx4?=
 =?us-ascii?Q?64HKUbk5tTyRejfR/MdZlyRJ4AKFmpWnuTXdNuQ6QyQKA3Waeu7+9AajUef/?=
 =?us-ascii?Q?LWQMjS4p4A6PByb0aUOpX+EH/ur6FAlolubp2WdhxxM7O5Lo76A3nnLf7Hup?=
 =?us-ascii?Q?/MPvTwF2ULqNwz5En5zL3ycqY667XfHzkPvjRGbUl63HYBAgHdWa3o2bb2Ou?=
 =?us-ascii?Q?SBPm1YPnZ1zWK3/tqYPJpWnHNF81WCTUPijLc7+o9YtFKRdqRsn6jBx0yeDQ?=
 =?us-ascii?Q?vtc9tvhISy7cHt7IjQJ3Z0sW4rvyje4Q16/UR6ytDSxV31DPQc28klYcGact?=
 =?us-ascii?Q?1pw8Tb8RTsyFF574sv8Hx5bb7rE1sIFK3CxTjJomwLIcqsUfhC1B01U/79LW?=
 =?us-ascii?Q?6e0JrFG/eekUtCNBHgCab0smTMtMYX6LJt3vPFEAxBTwd2mM1k5J2h2/tebY?=
 =?us-ascii?Q?M0Atqy4vilVZFgOxh46WNxelZDtcxCW/dgZjrAxDUHbBZHSbRxbYAa7ruDK8?=
 =?us-ascii?Q?HcfMoOxKOcAfDbaP4msSnzkaSbgdduWMBf3qMmfUM6Gou4aOb8c9gz+WJj6n?=
 =?us-ascii?Q?DjTmPQP7GEML+Zd1DF1t7d+w2tqXB9IU1j5QwzSguDeofU6lGmhkFZXWMLvL?=
 =?us-ascii?Q?0GJSqBNp06vrfh9nSwkfcpBEjuTzeujkHFzm2hDnjNI4ExnKJKc4EuH6RVmr?=
 =?us-ascii?Q?AvuKeA7Fr1pcFkmaDRblWcXs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcce3427-d1f5-47a8-9ab5-08d8ccf7b05d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:39:06.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ys5npo55v8yuGTVfaYYG1+o3gZpctixo6lM0M7hslIo6zPnXiVt+hS3NmPAjh2ItXF4sIxGR65AdW1ZX9kov+n3+EaeGElVfrp7VfEqDNes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
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
index a5991df23581..a030ca6f0f4c 100644
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
+	uio_event_notify(&udev->uio_info);
+	clear_bit(TCM_DEV_BIT_PLUGGED, &udev->flags);
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

