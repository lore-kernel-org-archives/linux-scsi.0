Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDBBC4167E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhLGCzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:07 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46450 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230374AbhLGCzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:02 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5HmO012536;
        Tue, 7 Dec 2021 02:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ptj4cR7uVbc9x64500ivlUyYaZ5mnIiFPGGDSEMpyIo=;
 b=qMQJMMvBDQumDrkQ6VVytFMOj3fA0IL3JEVHhKHfVPyK4r7gDmoNQCEiYU6RarLGygdb
 e0kp9tD2FI6V1MbwCf0aFxD7pZXEUtGm9RY5vG2MQtjGXHsLONfeovikmhUVzqsoKtgl
 /WtNZRGbRhB1edMu/gOU2hM9OwiDm42WDxpWNFo9lxXYULYd8aUKwrHcbxSwoFwjZLCb
 GjpHBDai+TadD6OAh/m4DgwsWsNhS6BHs6IXZiou+M+rJz67M0PydHfdsnmhEsn9N1C7
 Ed729nrsUoht4jF2tEHtOSsT8ncz4xW/ZeRlnK0e2oSQ2MSxMlakqJU7Y5+gYK0sf3RO mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c356-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglZ153019;
        Tue, 7 Dec 2021 02:51:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQRDh+Q8X2ba30Vv/SqfFoAw7c+Dw0UfkZ5vfgr7qatvNH1QGchXcP5cJRyZwdRTYWQ3aPNEdDNB8T83ehfRntcchE4U3cAR4VGEimfoHYtqAyzpxL5jkI8z+XLKYbuMSRogAM6TQetOjx27D0QbJEu93EK9n4QcrDOKfgwJTQhTu6IycrK/CrCwWjA6isTadCpgCO5ugTG1E4Bgq0yvMEftDd1wwUGzYRx/1mZG/JhOFQmJC4rGxYBm346g6Q+08BPX4V2+IsZKHN8x+QLz8kxes9q+GrOXKsvDsT/bx2KnkEZkmJLal/q7NORm9PDpkPIERsHvmKfqKWVcJo2g/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptj4cR7uVbc9x64500ivlUyYaZ5mnIiFPGGDSEMpyIo=;
 b=P/DDf6RcTdX4ZyVXIxwFpVIbrgAcZRsLrHo+NoLvB2t3+7cmfhZ9dF83im0UsPdM0qYbpsTnbLo3SpOP2hDbAfM8c+Tq3m1HEBVUXG2T7H+038vyuYG2jxRnLs79NRRHritgkNve++eU1qrWZIVjV0FPrISxZQrEs1tTQ7s6rATAM/JDXY+Nvn3rcXeDSeIJRxBP4TOYsN4/SCLclN5qWW1CfcMBi/Jk/FMAUGlHmBI15T14D3pKVBefS16bgxGFb1KLQCV2UqQdfP87RBeiVeB+Zy2PWsKoRK1zCe8rv+n4GihYuLIgyQkcFWapngWcuEj66qX9jPkEoo4jMfCHaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptj4cR7uVbc9x64500ivlUyYaZ5mnIiFPGGDSEMpyIo=;
 b=bz2Lyv1t8KPvVV254Gs+KC6BLXAkOlL/2MnmPrVnzK+ub72qyhY2Sv5DhDq+4Aq7ChJg5fvfOiUnvYvLyr4bmLWvTeSpdow3MKBLmvdcF1vYY5Br6VYzzSYl6o+cpsR0JUWpvAVXvOjcM8u3BjpdfuGC7x69a494Rh8DBOUxg+8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 04/12] vhost: take worker or vq instead of dev for flushing
Date:   Mon,  6 Dec 2021 20:51:09 -0600
Message-Id: <20211207025117.23551-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd89ed49-cdef-4fa4-45b4-08d9b92c76b4
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43477158B81F3BD03B6E9576F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Wg+OlO0otT9swI5E8ZIu+UvNvHY0nFR42a7tlhidKwMsQcS3qxs3CVciwJAABt4n5WmBY+hd0lYH8zYh+t3+dj4xl2sg6J50sLIDY8SGgxnjyFuDInYqYa28YJ/ouLMj7H4YTDLlowFsYUza2BRw8gjy+9zxPkqF2stLSck7anP3etFren5mCwv3ddXnUTcLhxJhCf3HImjjPdfaVmXvVdry/9/0Tm9hbzUduW7xlYqxjnUg8Q6k9x+eMKh0CQ4fWE72+2GXr+hZzf5uWjVx2uTbT+hnr40u53jlb9BD1veCYXBoeTa/vu8YGgfZiEbPusbG+34wuEWsRQDJjfxZSnHfWyf03oxathh1q0ZrfSLVOoVv9cE84cRC7SFoZwAFEoAl8U+e044tyUJMigZHrje3aju9ZyP66K6m4JkslMPaJOB1h6+6NnKqROoTcZQAFUjNX9u/5+64vPmJ7Mv/p/lVeliZVXyqaeXl44DuuXgKEobmVFKcwfD2KXKnrIU/EeqDIvhknx1lT+0HsIvNWbxZBcQHR/itxxF++I9wEQjjV5xaOkfh7zu1bjOyUKYeZyUTeysKSGS+pQFh5z3saf81KgEWhWUcGGXPTKuFe/BdM7ZIZc1DWFA/ONjzk+XOf80xgk++Xj24hUpK8Px63ZGQHOVMxUW1RxdTXRVmHiUWT9rxD11mlqqZuN1ZBzKtKxhF3qeJoF9dwJcqtzKkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gv7Sd2WuEOnS3ZHfj1jp4thQJB23oIujNdNZ6HZoz31Zw4/STOMUTMOvBMDJ?=
 =?us-ascii?Q?TcS5uQgRm7aNQ+PpYVA0EouJu0QONu6bRdZRnjFkFQUCILZ5Plj9dOc34tYQ?=
 =?us-ascii?Q?o7l6aKDFoVt08ifxE8MmSyg6YOlQrfBVXroPGiYJPfgUj7F9y7l+pcV5joGG?=
 =?us-ascii?Q?m0dGYeHv6d1whtl7opvDjg7QlMfjbwpEcbd82Rg5SOKCOxE4GVf0A+jYrTNr?=
 =?us-ascii?Q?2L62JtM+TNYeQLJtnY7X6km9RKUBcs5yQ1bB8iKEnm0ipOaF/oZnW0FWauBy?=
 =?us-ascii?Q?kglkUy3igZ25TsAhlNFHM8uWba6IrONQkNSf0L3JdA9ous3FSk0vbxZAy8XQ?=
 =?us-ascii?Q?72kMOl8ZAtEXtw6HcS/LU9Gd27OOjPUamgyJPvRA17HEmW0GA8eSV7M8uRcY?=
 =?us-ascii?Q?+slPXOn407YaDZyP2lsSqNM72eOeCtD300wg7tQZmsnuqy1dZ7l+xvzL9MCu?=
 =?us-ascii?Q?loJmhLygLN+RhDAQlFRMU0kK1zNWg6EI0TdiSOUkzpbPECtiMBwx1Zg7WUNb?=
 =?us-ascii?Q?a/5Mo0FaK0i+Fcv4Lup3ezDh0tx22sB8+6OmOhrbRosan6t9+LbyIXyh3F7V?=
 =?us-ascii?Q?qHQXOGFvlBnEnvSQef7mKwemIt7SdsjE7Ls59NZLrFUiJYv5fmd6+AtJRk/O?=
 =?us-ascii?Q?Jmxqr88SSqojgFGxX0KiDLy5Skd3NGgkLK9YxjTwbvXCCHCYROqvgNBxUSlq?=
 =?us-ascii?Q?QrB2hli6qd0zXPoN/N8d84PBWB2NV8pRHIUv77jvHiP7CqVq1ECvJ6ZGOafy?=
 =?us-ascii?Q?m73zKLJhNXQTVLaevoV+nu5E/Eu0vVDt1BMGCLVr0F7DtktbbUQs540edav7?=
 =?us-ascii?Q?fMF3HLVF1U4fgHTZzJqt/gD30RlphTJ0HTzdUClA3wDyB2hOXYuDjdc6HzmA?=
 =?us-ascii?Q?49DUr463dhdSsP8qldCjzDdRitjh/qESKaRJof5nZQWorT48SRK8mjQSMOrs?=
 =?us-ascii?Q?3Yo6DtomLlVDKFLMwwOWEuc00cm3HwuZSSmGScuHJ3NDiCQRpUIh14sbaDvB?=
 =?us-ascii?Q?+aqdrDHdqswe22ZTTN6muEkN8ptmKqHVJ7Dw3sNmT8nq9WfOEnrC4xn9rCGL?=
 =?us-ascii?Q?Qg76tDD2rzQ6XyCexq8N+5x1ZOLw3qZavrfbqjXmJ+CVlmNqqqztQvgqqY6m?=
 =?us-ascii?Q?cIm8BIT/dAjjzl+WpVTSjWaivqpizcCtMcIgVy/i8IwGk1TDu/763DWmNi0B?=
 =?us-ascii?Q?TNq24VDab53qdZYNlegfdiYmPLNyGH55tOaxC8QZCi2nyHulWWrOIbDkJh1y?=
 =?us-ascii?Q?zwYPBb20+YCYzjCy5GegHmb4pMEQwXhZh0tUOcKRxAfNTDc4WW5TcC6devW0?=
 =?us-ascii?Q?OReccueqDASs2v69L5XfsqvYxWV3Aj/V+CNIQqmiCuWuYGZ9yyE6efFbD5S5?=
 =?us-ascii?Q?3eYN3zLqYVbL9P1n2Bwa6vd/6n9TuPk1Bfy/2B2C0dZrimPYInd0xdJ+jsHn?=
 =?us-ascii?Q?4+YWZe4hydPgj+ZLD4bbqC4TUFEFAjhAm0r+Dwq9xy9nIqSPvEEct63+39sz?=
 =?us-ascii?Q?NqKdYEhC+oM+GoB5EXFDKP1gXgd0+jrlGfS5TPkeeBnsycvxaHjlUevOYHLg?=
 =?us-ascii?Q?+7xTj9A7c+kKMblBFx9cYy44B29pik3hsM47M+iHXpTBgw9EzzoFh/ap4Y+b?=
 =?us-ascii?Q?Ao9fM0PiPEEebJBsPX2K6fDEILyLCA6gJ43sh6LXr/hMUnNDjhMLaTDaWk+h?=
 =?us-ascii?Q?IwQvMg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd89ed49-cdef-4fa4-45b4-08d9b92c76b4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:27.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbG/jQ1xEgsw7ZiVHDYXMM88mPHQZfkk5S4AbPTm43EfOsBZQvfeP16mL0fCIRYGTRABOHqffWICrdnDxkn9PKFv2eRwRLy33wzuLPEjqaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-ORIG-GUID: 0iVbFU53UJBdLImQRpzDoG_EbYF8NV8X
X-Proofpoint-GUID: 0iVbFU53UJBdLImQRpzDoG_EbYF8NV8X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the core work flush function take a worker for when we
support multiple workers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 86192e1658af..e5f5acc7e648 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -246,6 +246,20 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
 	}
 }
 
+static void vhost_work_flush_on(struct vhost_worker *worker)
+{
+	struct vhost_flush_struct flush;
+
+	if (!worker)
+		return;
+
+	init_completion(&flush.wait_event);
+	vhost_work_init(&flush.work, vhost_flush_work);
+
+	vhost_work_queue_on(worker, &flush.work);
+	wait_for_completion(&flush.wait_event);
+}
+
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	vhost_work_queue_on(dev->worker, work);
@@ -260,15 +274,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
 void vhost_work_dev_flush(struct vhost_dev *dev)
 {
-	struct vhost_flush_struct flush;
-
-	if (dev->worker) {
-		init_completion(&flush.wait_event);
-		vhost_work_init(&flush.work, vhost_flush_work);
-
-		vhost_work_queue(dev, &flush.work);
-		wait_for_completion(&flush.wait_event);
-	}
+	vhost_work_flush_on(dev->worker);
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
-- 
2.25.1

