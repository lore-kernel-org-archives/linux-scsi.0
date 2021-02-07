Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0D4C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC6964E8F
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBGEs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:48:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhBGEra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:30 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kVo1168284;
        Sun, 7 Feb 2021 04:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=y2cUMmo57L+YpW6CtEV13VVcS5bWj+iShow0y5lttB2CXN90KmUoTWVLhyjVQCXc2ti9
 bVC8AmJdbSo6LXCbixH3FADNX4rAgmiQYUht6WZWh98qDqrwlr8EmY04xGblJhuYtr4j
 t3wszLFNmQ/zpoHVx8P9lm0WJVcY8mAFg0PGXetv5yrUTTmUOfLJh/Sm0GA7zqXtoWPv
 ejxXICFzEu3TyqJUnZ3IMKWSnTwHirM4TVM4R8qn112ibTAjRKYy4GNzECN0YZvokzxo
 zIjpSuWwuML7a6Y5cf84DNl5KC3W3Gkul28kAhYGW0ZBwk3HV9EwyBODUnvTL9aJEfeL zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgma9fnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174inaL004118;
        Sun, 7 Feb 2021 04:46:30 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by userp3030.oracle.com with ESMTP id 36j51tcp26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFAvsOFgloJw+A9vHfFU+TO3inG1aegP2NP+PByyhk/4GctmMYPyrd+AjFnqdK2gd/js/2zrQz0Mt/LshgQ8e6FiXhsAS45saBgK4gjjbL+lx0Tdw5oQbtkWyoWvqMLzhUrEA5faBuqCF4UXkrgdHfiYu7f92Xnd5fFgOaXTNDrVnDYWwfILdpRo4s8uz6BcapM9OalCMugG6a/XoBOhnHgNJ9GU3JNKnUhgcgSDWnyQtLroeylNROiQ7Ik8RXmwy0CY2evhTNdFbK91soxE8oKDLYUxytf/b9QcgrX2C82gB+I3loyRLn8oLj5zigg7dTLPDtOQRPSYG6F39BDY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=MRELMQ8joGRVXUS816TNGndUJxetcem8dFU9jbzTUS6C67N45zBz2P4X0jKzXQw1SxUGzPVkfptDsNwpNMfBeWYcG1gDoEpY2NNnVrrfWSRkrK+243nWmYb7Tdp3w5T5i5yxdffD93b94XRbrZN55IwbZ9c17H1wuOp1+7ODsjYFTZNZ6nn6A9s5QoiZ/mgNuAH+UGd9wIcmD/BQWS/Z03SFBsXooWMNuGxjLqf1Ih3tQ9WfH5ah9SWwjUunfNlO2da8SYYUkItnUwOPkgKFu4L4TGui8g7Gesow63w1XWL0gCnQvclzeEEHwzbNdZ8UbO+hn/heobjHiq3Cdw50PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXLWGDb0Awq2YgQWc8+hl/MWbXDYQdV3tzHjFEVwbyY=;
 b=QDtYB7EHX2Dt+YYY7fqYZWaIODOv07y+q3LcL3ra5vVK6LIqqwV5KFjei6A2sitEfW4U64JGuDLJGYz0Omn00W+5tfASBlNgT2/div+FWh/ulhOcbW80HtHFQIwIUklAqkjd0E2AqLf3asUIumQVTsTlJxdh9/e5rsuqjURHY98=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:28 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/9] libiscsi: add helper to calc max scsi cmds per session
Date:   Sat,  6 Feb 2021 22:46:04 -0600
Message-Id: <20210207044608.27585-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e54b3a00-fe1f-43ac-8ee4-08d8cb2354ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34294928AED48A913366F095F1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8TfBEVpztcuMw2DB9BmH/Nnj+Zfq1iduUc01zK2qp3/pwSBgz9E52k7Z4TqGA+mDrPSIHtaos/7UCZ+BHtLsjdkrd1Pa+/KJXklI9fZujE43PA5qOQHEWSYZvIdOWZvkAo4TzONVUTuRWVuG0Zrd+VBpNgHbAW9Sp0GzUXz5tbbaympPiy4Q09OoGKKpvREEVlyJ9z5x9ksHYxTmXHivyu7qxoQsC4dk7L4zIgqVJ9Zv/lqflG+944V1MfHb+ddUHitK0mJe+loks3sW1Pmwi2sH0eyCrby6B21kn1I38xB4JkRtnDuRh7SizVZzaY3LMNxzh36gswlQrYWMDdF6gNb6s9Ng/m0SusZPDhu2rUxXNMlZNwB6ByQpJYzvBuRgeQ0BIBwCCgpc9r9/WzJNlzm4b5JA5LbdBYVQdQCD/RRsgvtkdXbJcAPW+bq2VinHbvYeLK7G9yBuezDNpV+huajswMgy1hd+YgBMh5/poGB/anCZtBvKIEGj3+nBJymidaLwBk91NsLW6rombChpIB8ySK8zB0Zq8zyyNASsSDeo5qgPgpdHS9BzWxd2/Q5YuDpxFipAZPl09ce365Odw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vmspqmi0/4NZLKrggXd1qy3UwcHxFs5WjroOKAMbR5y6SmvUFnvRgzUKudJU?=
 =?us-ascii?Q?WJTRhWESWrlFebGiMjwMGXEmvMre1Lou5zscZzBqp+g0LIN/Xh2zKi5SkFI/?=
 =?us-ascii?Q?aiKVV8jy7FN1/RZAG98uZHqXjbjygCNa6iDJtyt4CP0WTisff3cTE7Cqfz8s?=
 =?us-ascii?Q?rIFg+IWMPUlIFqkbDKM8wKklhXs/H1KRHuO/5GfNXNCq7X8tSNWoZfJMzjbU?=
 =?us-ascii?Q?z61FIkbgD+XuCplfkWa8OAFaB4Sc9B9vaZIGFIbspYuxJQbF0Y80yXYC647M?=
 =?us-ascii?Q?ZPvPNGr66PqI/irxDC/gjYp72N+M+GcRek1IjbP9JPN4RO6GPXsfyRjXbTXB?=
 =?us-ascii?Q?H8iyL/lMAqvS+e6C8LcPSF5D3EqBmBYjFNb105ad+bux2AfghLdGD4GEYxTA?=
 =?us-ascii?Q?XAcgpjOYSlY+ZdMT7gJre1vnpTCRXK2ftWJmtKg8dbzGWfRIp+efsOsfstQJ?=
 =?us-ascii?Q?0OAbERLH845vn3yA7Opk38JyCmK3b5ZFc8hazhkdcEYaTuQJVrzX79D1wxRV?=
 =?us-ascii?Q?73yVzKYecLwDRX9Rch3YrJiJu3sjdHSPahhHQB+2EFzhC+xhDYU388adW7YE?=
 =?us-ascii?Q?QsgjaUx0NPD8dv/Gu652F68sbFpSHF390l1zmz9omjzbqi9GeKPpeu7LoPJH?=
 =?us-ascii?Q?yxAQ5O2Datnr8Igq60IiHe05nbhDos+SQe4opjUfbJnsWm2HnxSLYjw9ms81?=
 =?us-ascii?Q?HYYEq82Ypn+2BWagrX6WuXhrmNMei59gMWqLDkJaNZN2k5E+KtiF50t1XVSX?=
 =?us-ascii?Q?Zo2zvmM+z+TGbd3NpBHT9FFw4hsxVEQFA87WAnC/5MtcYyZPzzGM+Hw+Eg8t?=
 =?us-ascii?Q?OBjQRT8A+hzMbwwVbDsOVWyu4yCgvSrk6HrfsMUShlzqWdxErqDafcKSXiPm?=
 =?us-ascii?Q?lYxbDhxBEZse3IP75qvUIzFXKxQ8Q9UerXQg5GqB/4JVzGDCJl1zg1sziHHY?=
 =?us-ascii?Q?0gUhM1cOmv3UhkbK+HVSosKl4iaNynnJSHLwYfQpy6f6XdJ3sP7guwq4CMDh?=
 =?us-ascii?Q?po9cILk7pDPx3GEfshI6jgVxRcW0sMFnrjf/IH8PBO7I/XDOV+KdoR36dk05?=
 =?us-ascii?Q?Gdfxzyk3FPcVR0jE5q/U/886yUgiFCY3AmfkwbdfZDeYk+hwEygI6v1r1kNh?=
 =?us-ascii?Q?CbkakcGaLp8kuFxWf7ao0H6qnF5SUkFrZaC7T2OLMq7zsx+LkO0+0EZX26wM?=
 =?us-ascii?Q?BOkD02aji7wVW5lVwZi9ww9+OptyLrYBRQUoGtIHilvzniHrMKMCokLHTSuK?=
 =?us-ascii?Q?Oi2BoYx9RET1PKdqIwUMtzY3GyGxaA0Obgdem414GAFf3StXkP7+/RO8gk86?=
 =?us-ascii?Q?fVxyHUwHuTSrtXE3ix2TCKt3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54b3a00-fe1f-43ac-8ee4-08d8cb2354ac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:28.0022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVQwQGAjZb0gATZqXDMR4whwfvP2du1xWrepG5r4j0aAtngIJVNrSC/GGxsL+NIwUXIaScBSJQO4fg2xZKPyOL1h19CBLHOIvY9cYOqgdr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch just breaks out the code that calculates the number
of scsi cmds that will be used for a scsi session. It also adds
a check that we don't go over the host's can_queue value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 86 ++++++++++++++++++++++++++---------------
 include/scsi/libiscsi.h |  2 +
 2 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b271d3accd2a..f64e2077754c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2648,6 +2648,56 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
+int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+				 uint16_t requested_cmds_max)
+{
+	int scsi_cmds, total_cmds = requested_cmds_max;
+
+check:
+	if (!total_cmds)
+		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
+	/*
+	 * The iscsi layer needs some tasks for nop handling and tmfs,
+	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
+	 * + 1 command for scsi IO.
+	 */
+	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
+		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+		return -EINVAL;
+	}
+
+	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
+		printk(KERN_INFO "iscsi: invalid max cmds of %d. Must be a power of 2 less than or equal to %d. Using %d.\n",
+		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX,
+		       ISCSI_TOTAL_CMDS_MAX);
+		total_cmds = ISCSI_TOTAL_CMDS_MAX;
+	}
+
+	if (!is_power_of_2(total_cmds)) {
+		total_cmds = rounddown_pow_of_two(total_cmds);
+		if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+			printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2 greater than %d.\n", requested_cmds_max, ISCSI_TOTAL_CMDS_MIN);
+			return -EINVAL;
+		}
+
+		printk(KERN_INFO "iscsi: invalid max cmds %d. Must be a power of 2. Rounding max cmds down to %d.\n",
+		       requested_cmds_max, total_cmds);
+	}
+
+	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
+	if (shost->can_queue && scsi_cmds > shost->can_queue) {
+		total_cmds = shost->can_queue;
+
+		printk(KERN_INFO "iscsi: requested max cmds %u is higher than driver limit. Using driver limit %u\n",
+		       requested_cmds_max, shost->can_queue);
+		goto check;
+	}
+
+	return scsi_cmds;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
+
 /**
  * iscsi_host_add - add host to system
  * @shost: scsi host
@@ -2801,7 +2851,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	int cmd_i, scsi_cmds;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2812,37 +2862,9 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	ihost->num_sessions++;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	if (!total_cmds)
-		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
-	/*
-	 * The iscsi layer needs some tasks for nop handling and tmfs,
-	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
-	 * + 1 command for scsi IO.
-	 */
-	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of two that is at least %d.\n",
-		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+	scsi_cmds = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (scsi_cmds < 0)
 		goto dec_session_count;
-	}
-
-	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2 less than or equal to %d.\n",
-		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
-		total_cmds = ISCSI_TOTAL_CMDS_MAX;
-	}
-
-	if (!is_power_of_2(total_cmds)) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2.\n", total_cmds);
-		total_cmds = rounddown_pow_of_two(total_cmds);
-		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
-			goto dec_session_count;
-		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
-		       total_cmds);
-	}
-	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session) +
@@ -2858,7 +2880,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
-	session->cmds_max = total_cmds;
+	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 44a9554aea62..02f966e9358f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -395,6 +395,8 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
+extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+					uint16_t requested_cmds_max);
 
 /*
  * session management
-- 
2.25.1

