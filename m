Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BE9C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5259064E42
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhBJE5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43324 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhBJE42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4sg3o004468;
        Wed, 10 Feb 2021 04:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=bNT4jF07aOLU+YCqTRyA/wDH94bJ60ceXt8GAJ2h+4CzR3HGB/M7XwzxGPvnqNXkeOa9
 x4g5O+HvBKYXbGfDjLh7tGmaZIQLVr78X1rIhBaF5dDnuHJBOiqM5/LxYXJDvr5PINN+
 S+rIZCUWxZPxfKhMwt8DVeSF/ru95budIYnx8/H90pO+6SUqmP42w/J4klp0jAmTcqDQ
 tf3zG6GuVzpkSxyiKxcD5JOAg7JghvMAej5NIGIiXhMDC2J7k9nBVOJ5iumnsLFQMCnj
 poAvBNOhAsrmspzCI0YNXnNfIFlKGZaBaIt4UWEOMtfshEWObrlPG1srx2oL2uypkhWy eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmaj0tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRBC048727;
        Wed, 10 Feb 2021 04:55:42 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejtQYhUFbjkvypVcJLzJ9VdTAv0qGwhAFA+lo7DwsrLywLt+AZX2PmQjnpI43s5p/4f/G7YvopWTOb7PkNzg8I6fJ6W9/u5+IXYBFF6rdfLeMkbr1d0yDR3dMr3hSbdQBUeFw1n1jHRt8jOXSG+ylEdYOGa1MH22A9YnN+aah2tmnZQmmgkzqvlwfFRT/wrsYGfryDYucQZRgS0aYP+g+q+YJ4iwm/JPWM/Q1XM3S+CARGZXsRwI8Uji6gw1TME/J9jBDVfa1FU13luJxSLygLBo80P6RHFQ+s7KR1thJbsqJaVthW239ma75pMmAHxTZjnNZ0pv4Vgkk/aP/oocPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=GjzLKfADH+SPzvpdoWFLizUV/SCNLB28KzChBZqhCJvSYfe8i9ZU3cal/OKN7/7tAAnxLnfFW0si9hBQIScDAtombAHUdeAk68PF5xOtUyJ6OEFTxOD6WBE1ccmuELoFPLhzDQ9nEdkCaX+bsNHBY0NHOirE88/vhXeqVuBvYVOSCYCxWNyKvl4Fe67sHhFYRkCf6K4kbkapCznQstSF2awlVvg+ZljmFZQ3tC/1qBBNFI+mZR8cn/rUhN7mt0T44VVeZD2Hr4Yl8bNpxtyOCEm9GzDRtTDiVpihYuv/e5pOVqEcbS5J5LaqOTQtJNklkl5+Y5tBv6UFugRDhcP/QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iNoXyoC4xa0O0nQ251es2Dfg6INqaheeFO8Sm6kIQ8=;
 b=iB7QTRhd5azrDRa1hrrPjQPTeDnjGj//8h21QYYvJtsLR8Nn82sQ6ey6nlBbnY3+uKLv2/qfLSlg3JP2In4jmzAXNVHo7bJHMpUT+uDVlyuRYsuBzi7PKdu70aXNmovINuo9zTXnkmey+cXPPBih2GUH/kGYr9gpWyLyXrMrR+8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:37 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/13] target_core_user: add backend plug/unplug callouts
Date:   Tue,  9 Feb 2021 22:55:13 -0600
Message-Id: <20210210045516.11180-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b1638ef-88dd-4490-7db8-08d8cd801ba8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB336697B45A49A2B8741958E4F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLBLDeUemB84DB1Cd1xr4Zd/eWC+GVwk99m5uGq6w5i1JJl33r1OYag9BqVwaFYEzEV+rNQz/rpzohn0H5VejwMwnhatD+Zm25YMk6zydBE6UxnmfopjET7BveWL1kPT5gnvInSfxav6KD/jSzCMa54QxZ/R+2cX079u1WaKjChZ2KK6Juktb+tfmte6c3VqXHN+QEAQcWJy+oJ/GGZymdB9CbgHVGhOkIOYrCVkA0kseZ1WF2JPi+KIB8QZzSS7dTO0jm5xTD/MMMGL0GqU53sqM4u+Kv0jI/gSofSJtmDGsix2Moth02sbvg5ssHFsHiABHt//BIv5USG6AZGS9gFcJkh/uc/YOlwwHqS0fadUHTnghOaZMVa243aJ8jlTWBefwm4zWFpYfwyUOunUUywsOFTVCxsWOAdcdX41MpFNhVonpe7P4/0wpBakFw/dRadsmUdONZTZGDhumA7NILD16VYbSwT/PzNE/LcrGFcLvHo+lCkV6+qOJgpIWp2uyTpsD2xVC6BfiFcGleaNTAIlbTejn+J9id+xyKHpaFwY235NdcvQm3yAC6lCZgz4jEzNEUxk+0anNDHcEMozJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y2z0nExpvZf2WLXKwp7iEF7iTXsxaVCCqzCZJbcanmz/Lw7wlXefUXBsJTiH?=
 =?us-ascii?Q?ASNFSW/+3US8mSXESySmT42/G413uKZ+kkVSzz0Oa8RCMFDVZrBg2hG1J5xQ?=
 =?us-ascii?Q?jQj+jaTfZHdo4gOsSbTWvOM+Z696rav12xujWtGumJl98gAnU6BK/BXpwW4G?=
 =?us-ascii?Q?lIS0pGR1VuMhGxgiF2hwy4uMOysp97F/YW9J/oWcEozEGEL0CEnTW5E6HHnG?=
 =?us-ascii?Q?rPD962LxCi9k6whP9lQax8kbYttaceJ7MBjBJccidg3KGl149BtwYCr3NUgW?=
 =?us-ascii?Q?HC4K3ch9RlTWmvxEEOEBKEWsuIFKApqmi7b5/1xZDLf3rverpk3of/f0Jm50?=
 =?us-ascii?Q?p1XfRh8GbFv0jVKkPrumm28nTnuHVo8XB4ikY/i0ydYwE84FyBChXhYBKcnR?=
 =?us-ascii?Q?3AgSFljGctG0L/0QLAZaS/0Itrxff+34JqswdP1J9sTClr6/CtR2CtZ6cJ1j?=
 =?us-ascii?Q?7Oilury+y0kGgppoTLrJTZDftSJe4X6M8brbfLJqGTVmZpNA5ZtzSHVlTc7c?=
 =?us-ascii?Q?vQJKgFA5oaadinvuPom3R/anTOqpVzyaSAruwVra+2Qkjhdx7a9FUOwa7u1k?=
 =?us-ascii?Q?Mhn97AFZ7YMXorpp/i/aVwd1Db6Nw18SF88N3sjiilYlhZ5o3Kb/bA0D1AdH?=
 =?us-ascii?Q?TVGWB7f/pERDFLNcBVKoj+zSqDzoVJ8noELdlmkoo+sX1HDSKdbxlxIL+2SC?=
 =?us-ascii?Q?peewTmvYBWDPs4i5/4cIHjlPXsE/QGFzxmNB56kjGqhlLqtfQ3QfPk86w5tZ?=
 =?us-ascii?Q?vW/JcbTdVx5vpKrvQqfSeHF2flL+jHmWE60k/JN4zw7QObNRhU934vYYETOe?=
 =?us-ascii?Q?IHhnigbgprsGXUThgxHFH+kq1e+jHJq7afv6+GM+8Sr/vUxnHdh78ryqBm2M?=
 =?us-ascii?Q?ivO8hExIKArpHPcztpJYd3tMnBbV2yRjbcQKEMdDpu3RDJ+S2Wgnap5gC10q?=
 =?us-ascii?Q?4UXG2F6YT8TRNdGxBJgwn6CYsYgtaLa4GEAGM6dkRnLL7zgVjrKxY+XLhBWV?=
 =?us-ascii?Q?R49oLJTARqmYBq7wJMlYGZw4dxmfh6BNS04pULtcK0NPxuPf6m0jhJERgRCk?=
 =?us-ascii?Q?a3JrQdcUSh8V5u5uCECoAp7pacuGnRUgg1iSVNOYnq1USmlKZLkLK7xhkQL3?=
 =?us-ascii?Q?NKYL4giVeW4hI8BXYPN3qCRiNUvt5So8Cj9YqqDq6wGCONkZYbTaTHSukQgl?=
 =?us-ascii?Q?QHVFnIJkBLrYEDt4m/0EWeVDpR/3W/6o6mEn3/iFPbCozo4g1onggOawFYa/?=
 =?us-ascii?Q?U80JQ/L4ourUZw5CNnlkd9rjZ96yAi4Ub9Q2Ppr9vD1oxTPbHGLDbFi1DGbH?=
 =?us-ascii?Q?aC+mFj+vLApcYFUsMsplMI8K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1638ef-88dd-4490-7db8-08d8cd801ba8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:37.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8iqH6P9G4mrG+fJvCT/3YxNq3dMSzMIBY1Bp/SgK7T/LropwfjahpQYEPXYqSKsTWrGjZGtKrycnGTgg8q7LgqRArVSzP9QM9Y9Q38CpeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
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

