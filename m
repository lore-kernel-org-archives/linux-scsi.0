Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4F7C47089
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D71C611C2
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhEYRtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 13:49:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49776 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhEYRtX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 13:49:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHhPV4084738;
        Tue, 25 May 2021 17:47:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9oBtXUMOMvXyb2oFyeCCWCs1EaYiK9VKMCqKDQONC2Q=;
 b=jhEZrx6LWTVg/CYtGF810XCGVnE1rC6YHxJAWWncR5Z1w2/NutRSb++PSw6rk8o1LlE7
 ZtrPrW/rL5jCmHR/lFEra3QNRwx/H6DJU33sd0GrzFOiulExFK3PZCGx20Kye6YRYpN1
 NszaXJEumgXhMWgpTE0CphJDpH7TGOrntlystIV6C/0KInM9x7kMZDy0M2KN4KjKjhP+
 aNtSJBRRTdUeVCkFuJZSb/vCbuJ9XiDzn+TM0CZ1K1Vu9rpjIXK51p4oJWZD3w7TBA2F
 zIh/anwgxlTHUCC3JOwsid27Nbh6QpGxqpwlYBaNfaK8X26Lbc30GQe3aNUmKhXNP0yR pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q8xaky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHe47u042965;
        Tue, 25 May 2021 17:47:45 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 38pr0c0mdh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2k1R/n1iShdqeGOHK6wjs3Ia+YU4r1tMN/mFdoQaHk8k2Q7vZDRNZC6ez0RXk2wBElf+m+BZsABJlMgvtfMidpxVsD4tLTP/8IX2AXTHskeX4DHhDVE4Qv29U/lU2u4cMs1I9AMjaWwMw3FcM5I+nypw+rY1FkqzPgTQFOULelpeiEocyrvue/VJTCb2sIMGU8EXqu6U3iFElNz6yrUuDUclkCA/xNOa2z/RueaaKOXacp6PvXpivdt/Z8hvW9flhoer9WHuPOYwdt9r1QAVzDLtCVfVSWTvV3DgjVZNioYHx/Mjb+i0v+WgSPAq4Xc5nC5hN+x6ImowR24zrBcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oBtXUMOMvXyb2oFyeCCWCs1EaYiK9VKMCqKDQONC2Q=;
 b=L4I3oImVCWF4WCItMFam81xng/1EE+8JdbOaiC5tiMHMdXCMr3Z9rsvAMOlFMxazuqCcBoFEPb6o8h49vLgZ3RNpDSlVepCfua6Yk7u0YR7Y2nWZc9BNdwz/bFpVjajRPrVFVIakr+00NOrmpW8ZmTFb1yfY5kuD8uH5AVDx0rNHzkGWhehkuXS8e1TZPHo4SLkYaSyTHlgqUJ7aND8lwem5yhkL6QonrKPpFT2RSJf6jqLjJdea7EkDSTvrIZ7VusznmJI6SzSyzEZSPjM/f9VoeybXkG4gZ1AYs1dJpYlZRNLpO6R6rxrLSUjU1KeV1SD8tzs3kk/cgQMPYnmbqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oBtXUMOMvXyb2oFyeCCWCs1EaYiK9VKMCqKDQONC2Q=;
 b=Q+RzuAi/7yIA8bZpozXLqebjap5ycAVFrjpB7klQi32pU2nFtkFygtyHDE44OEb9p/J4TmjSoxNQJRlorD0yrbox2mhIhkFpdweNJ/gtnVtwFpp/SxLNWWWOhyf7g1uERU6NhqtoVubXyKQGDl3g4EQYVhrlAGNixg+SVwVTqss=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 17:47:44 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 17:47:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 1/5] vhost: remove work arg from vhost_work_flush
Date:   Tue, 25 May 2021 12:47:29 -0500
Message-Id: <20210525174733.6212-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525174733.6212-1-michael.christie@oracle.com>
References: <20210525174733.6212-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:3:151::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR19CA0009.namprd19.prod.outlook.com (2603:10b6:3:151::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Tue, 25 May 2021 17:47:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a8add1-647c-498c-eade-08d91fa5332c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB472095B77CFE742CEDA77210F1259@SJ0PR10MB4720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWpg0czpc2kcpLIBedb/g5E6s9ClYeNAZLYGvo2cS78rXP8Ps1h0a1ooIxO1myGz+z63gZGkWZhAVOM9QueRGmmT7KQ1YHkZoUZckWAK3UwqpTw1bwRVrzHPAJNePSMbfy53POvatQW64IxUicpKuVBbrU+eFh/dprr01DnaPNBBr8mk5yGZRi825FoMjn0FW4ocqGm1boLwbiSoBdRmVVL2t9QCae9aH8lG3mvcrMUfa7qRd95qViKwbsB/FGh4TDbK5QPeXppt5P4EuLTIwwo7fHBALhX710OabCrWgGPdNY1e/K//j75CJ3HZxjWUebTuaKrpoupBlhxDoR7z33rkbqp1DcDsBAphfHtDaxMJ6hMzV3VfduHGvLNcLWd8n/WCKuDS/JQ2ODMRMoeyklUwidyurNUOc9Np2XUWjy9m2qMFVk31ecCncBa5eOvK7LTJP8+aEqxgQ9FJFVd9aSL734/r7q86xjdvgQZae3PH8oIZrfr3+v0n/Mq6008s1KlqFvjghWqYA3H1jRuVK6iI7DOs0PQOupVJpq9UuBjvOSpi4YHAM4cU/I6WxcFLUTlweUTigLI0fmIZEqobDSLxcur48cpZvtQT92zvxsk2J2Sx3uJbFjD5aAraSGKie+CSHLrltd4PuY4api6SQxf1pCk6jI2YaaJm7gsL+Cp3zEvtfTOCokchoTliuOJg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(36756003)(83380400001)(54906003)(6512007)(38100700002)(52116002)(26005)(66476007)(478600001)(38350700002)(86362001)(66946007)(5660300002)(66556008)(316002)(8676002)(2906002)(6506007)(1076003)(8936002)(16526019)(186003)(6486002)(4326008)(6666004)(2616005)(956004)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uZloHSjoUvi531G9YWU3Zrku1L+mrx1bp1h+8Sx+MaA+8K0ke2esgBDMuuoA?=
 =?us-ascii?Q?OgE4Ad8qkX32vhSPmbUEitvyqjcv9CIC5iHtXS7ddX7gJkApzeVaEMiu/fvS?=
 =?us-ascii?Q?PhrG7N48IyMI/4USJ4V+W0gnbSeFVpFcrk6KdEPkrM1ih971ymXiBesHv08D?=
 =?us-ascii?Q?sdCMEq3DFkDWGCykTbW+w6GZNB1sbtcOZLPB/Ib3hqI9jY3Uh0nUGg5j995v?=
 =?us-ascii?Q?TV+P/NiOoc+8FmxnjoLI6S//oZC/c8XC24DbcM30KiIsAlBM53zw11GNNxJ8?=
 =?us-ascii?Q?AV8qDRTEEYW5oR7HWkAZ2/OJq08pybW4RTY0PL/PHJQspT/nem6yKz6rfSyP?=
 =?us-ascii?Q?BisI/PjdqUyyCcFv+WwkgI8ovhLlCDsN4QiuLum233AkjgUyNcu7+JtjQj5z?=
 =?us-ascii?Q?98/fkHQZAqLk0sPEw9TQoKS1ZkCFfiFqpzYXlAmXdL92UPtct/+nkQMcyLIe?=
 =?us-ascii?Q?bsoHLro53Gq82Dmg0PTYzqJLmcKMJeXGV3Tg25/PhncPLs4FuC02ZFh8KfeG?=
 =?us-ascii?Q?dssh4CHVUHQ+VHaKiNKbiv6s6ZowkC8IRXtF30pqOhBCHSkw8lraelsXdhUC?=
 =?us-ascii?Q?NOlrKyMoDZHz4RCg2daN2KsncTw0jQ1pp7AO/xVikDZPjGR8/J3agIL7EI01?=
 =?us-ascii?Q?0SpuBhmS6BJUXvsdQZ7ss9kpdsoD4/lUHuBgLHZU0fRuPOlX3Xyz7d2p71uf?=
 =?us-ascii?Q?yjoOGdsqz8SE8AlVzTjMlPNO2TQSWybWjpk/BF/w5TFG+NRewKG4L9G+YBfv?=
 =?us-ascii?Q?Xi+oIjnfBBa1tCFnATj8hxz31i5dPR4CjZDNN6W7iGy92IpaIyHY3NjPBHg7?=
 =?us-ascii?Q?C8p8VRFGYabok0+a2Z0PR9CeBoNlqlD4FJMRcuQVXiQNo5zosGAF7z2iHV7u?=
 =?us-ascii?Q?nu8/zuZ13qpcIeLLCEBjJFvT4U0SFBxexo6pMxXVXvy3nTdgd9Iw7Ksyy6Px?=
 =?us-ascii?Q?U0DlHmm3bJJb/ZLhnf+BBBBFVOZ+GTqqCqMjxHEtmSrWY8td+qGAXo7Fx4Oh?=
 =?us-ascii?Q?9J6eFHWvIDvicvEbcUHYkG6SO3nOyattwFqsXd1ptNrkDHYlRZViOriChOFX?=
 =?us-ascii?Q?SURmkBfNdJ4+8yiQN8nc3CmGTCSbBgSstz3luJLn8uplGYUHItDM6QHEXwsS?=
 =?us-ascii?Q?bzqyJxZjSNwdR4IRWesKxmfUH/2ODksnTD6wuyTMMzCRThdgyGq3ErBLZH3c?=
 =?us-ascii?Q?huDnyaF0kl6RSA3eeAwkeobOVIxF8PfijLIx1ggdwTGOR37jBPOXUPdKLSzu?=
 =?us-ascii?Q?Wj9WJwKu7a5/zHoWsBHCHZu1ywj/aAKcupaokqyAH2DObjoyvAu0J05jBJJc?=
 =?us-ascii?Q?6KQRFhZB0RMCR4UhzX1pboqP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a8add1-647c-498c-eade-08d91fa5332c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:47:43.9891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlRXnr35IRDfbYlpYdhwZU0qo1aNmpumHyrR2RM4sDgCuyshcTRLyAz7t7mRovfeCHZ8Go206HMONPhNub0cXAgvANz7sVUU29a1CDsgO+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
X-Proofpoint-GUID: 8Mf-ncGRS-jWH0G0wuwQLpBtU-r7SmqJ
X-Proofpoint-ORIG-GUID: 8Mf-ncGRS-jWH0G0wuwQLpBtU-r7SmqJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost_work_flush doesn't do anything with the work arg. This patch drops
it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
that the function flushes all the works in the dev and not just a
specific queue or work item.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/vhost/scsi.c  | 4 ++--
 drivers/vhost/vhost.c | 8 ++++----
 drivers/vhost/vhost.h | 2 +-
 drivers/vhost/vsock.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5de21ad4bd05..051a7f8dadba 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1470,8 +1470,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	/* Flush both the vhost poll and vhost work */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
 		vhost_scsi_flush_vq(vs, i);
-	vhost_work_flush(&vs->dev, &vs->vs_completion_work);
-	vhost_work_flush(&vs->dev, &vs->vs_event_work);
+	vhost_work_dev_flush(&vs->dev);
+	vhost_work_dev_flush(&vs->dev);
 
 	/* Wait for all reqs issued before the flush to be finished */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5ccb0705beae..b9e853e6094d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,7 +231,7 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
-void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
+void vhost_work_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
 
@@ -243,13 +243,13 @@ void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
 		wait_for_completion(&flush.wait_event);
 	}
 }
-EXPORT_SYMBOL_GPL(vhost_work_flush);
+EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
 {
-	vhost_work_flush(poll->dev, &poll->work);
+	vhost_work_dev_flush(poll->dev);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
@@ -538,7 +538,7 @@ static int vhost_attach_cgroups(struct vhost_dev *dev)
 	attach.owner = current;
 	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
 	vhost_work_queue(dev, &attach.work);
-	vhost_work_flush(dev, &attach.work);
+	vhost_work_dev_flush(dev);
 	return attach.ret;
 }
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b063324c7669..1ba8e814989d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -46,7 +46,7 @@ int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
-void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
+void vhost_work_dev_flush(struct vhost_dev *dev);
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
 
 struct vhost_log {
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..f954f4d29c95 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -663,7 +663,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
 		if (vsock->vqs[i].handle_kick)
 			vhost_poll_flush(&vsock->vqs[i].poll);
-	vhost_work_flush(&vsock->dev, &vsock->send_pkt_work);
+	vhost_work_dev_flush(&vsock->dev);
 }
 
 static void vhost_vsock_reset_orphans(struct sock *sk)
-- 
2.25.1

