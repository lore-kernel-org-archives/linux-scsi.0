Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FFFC47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 785EF613D2
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhEYSIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:08:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhEYSH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6BGH108199;
        Tue, 25 May 2021 18:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=jNoPSS9OR1afYGivf8txMPOzzrt/zQAPB8PnBy4NwRs=;
 b=rD0DiOzTbN5AsJIYvW3bcrVXpzEiUhst4lcMgkKlaSa+bODrZH0m+Ptw41e5xvXKBNPo
 +iSLEqjRKFWyUvwsBKRvQLve5eVyVI4lzDzmDWd4VOBWLfnotu7EbmTg8PkN8VzhYuM2
 9bHHcc/qQGK1VJSQ0LONKbyILyDj3vEuicZTzIF0zPG0FT355rqrh8tfAvwnKrzWyoyA
 06wCLNFDCvaD9C2m2oSeftHN1TjfMzLbDNCgKfuif29HfZw2GXt2JkT7+N2JP+f7r38+
 d1BB5gfqHB0oGfGWMkb0KonEDDMD/E7qMyxIxYSJmMp6ICh2NolaM3dnlRE4Q93Vnvxf 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q8xc0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI63vf094406;
        Tue, 25 May 2021 18:06:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 38pr0c0xub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaH7+N5B8bX3jO/2X90JSa1f4clH8KiPBmKwZWsBlPquMbs7S6vfIzQ0I+UFGIiqZeL1EN3CahPk/OGw83UzjKjKXF6e0I6RO4GTXdNNm8eU65zdHVFendBRhSTiLA1E7wsiTV2glYWnln+JYXxGXBHcgWyAX1YalG1bfqVpHoMf3ypsWmgFcd5FwjyqalVMmii5MS3d7t1S3XEsmpV+TNNJ6KY+y9++dEbzGNAWf3WNdVYYMR2jOnU5aJvSRFNCO46smXMab66egUIR49yggjoiOL/oPm9hkcQc7z9mo1KL8FmhPwuNwVXkGLr0NI9XRd0ujo7vlNigxezhSIRy+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNoPSS9OR1afYGivf8txMPOzzrt/zQAPB8PnBy4NwRs=;
 b=K0SUzclFkhILEEZJrh6GcvJNHsaarnQ0r+6KkzKpDfai7yvfaAGmuB8NnhwMY1FaNRLGTMgepZZPQlw4U1H1RXpPr8ZzIBS924QD9tcMszZqssOk/za1ybPVIT5QoolvbZgzF9wcj3f4sYXbyRWx11IngewPTHWOYu14tcNxd3AI01gy2U9ROiTmGwW5nYUpatit+kaxgy7OD1Yc+SnRtpeqjWiS2aZNgA5w6ydSpoNUZ6r6/v/5IiXXYYTAyWDQEJgwOAHxWKkJql9PP4Rqlzf9uskDhAbewkzGCZZhnBnlzttmRTdw379b9kkhSjVnslpi2yKV0URR7st/ryDN2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNoPSS9OR1afYGivf8txMPOzzrt/zQAPB8PnBy4NwRs=;
 b=s+EgbGvZTS8AXO7xyCasBeU15Jsomb6faYD7uvdsnO2SBdAwodt4HzNvOnnRzrCDkpp5TP1XTKtoiE+abeLUhny8xD/RbIotmIIXX3Ynf3lshday2e24p9OEauNZH3WzMEWIj5ZDwP0k+LcKJFfppUw0IjhTEsKt2huHJZDDa7I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 18:06:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 8/9] vhost: add vhost_dev pointer to vhost_work
Date:   Tue, 25 May 2021 13:05:59 -0500
Message-Id: <20210525180600.6349-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
References: <20210525180600.6349-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a44b980-049a-42d0-3128-08d91fa7ce3e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4639FBC6C4E9468FBD5092E0F1259@SJ0PR10MB4639.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14MhCWrYnmrOerTB/xo9jz4W6X+Hbhp8ckBN8heH+p9+6wckyRGRqlQAfE4G8YgKTZ5pSjWfKzovSI3wSeH7bLPlErIdOicX48dRR876kaawHEjzvkZ80zXtgWpYAZrufg9gmIjJAC0DPgEkaph/EzDQfjmjK1wTyV7NQkKelQ7ttFIJwLf736DX4YMKbS76RRld03qhXQUyn5g4pvfgx9kbXiwj5OSm/U+nIc7olhjChuO3qYt4IMVJZlbUF05oOhGtinncSqQkQ+/w/heC7Y67wigyYs1CyFbqRSHvdjBQuyjSQx4+8px85sV7pFdJHEinHObjD0N/SgO9d8pxUjGU4907IXfCCZ4oY40iBqxuN0olbhu6aNHxq8nthstIid5fMl++qoOs5YvzbcK+d0DAqj79fpLWBXordqjwt5DzGwNdNYTdGaAUDjTYctq/d0jH+w/KLLhXNASVpzfe1wLHyp9gtW5zglk8D7NbwzQ2E1avQfdAez8gxWbwgwW/uhVTzPZ+3vr4O3ICMivQdR28HS7By8PO8J+COEtmA80eIQVr3Ti4ndeB2iuvwgAdlSyGrzyR3z1ZeAzUnCoE7fPGa/eG/0rLmf2Ghe+xvThV2kumh4IueByPf6B+J6BliVBU/7GVdtLjZb7jhvIkNwGs5G2XX0KUJD5isbN4KRCbsT7HEuh6cOBWkhfGQ4+c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(136003)(346002)(36756003)(2616005)(83380400001)(4326008)(186003)(316002)(6512007)(6666004)(6486002)(1076003)(8676002)(16526019)(478600001)(2906002)(52116002)(66556008)(38350700002)(86362001)(66476007)(26005)(5660300002)(38100700002)(956004)(66946007)(8936002)(6506007)(107886003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cJAoJS7YA4ZINs0M82eBteIXyUa5av1Q9j7OoA0wbIb1aP1uCMrA45UKYxEA?=
 =?us-ascii?Q?VJe2Bm+ANos59BlXPg+C8rJwhP7iUjwqre0+sJSuK2pU5Ijj51IpG0uwPb/5?=
 =?us-ascii?Q?nu9IGllF7hWL/+7Qoxn7/Q/B2BbEJOaxA2dYEE5DJkLJRMm2JCiDU4Blkpf6?=
 =?us-ascii?Q?DSMQC/rsbCFjFtErXsz9RY3yUi5aYFcbsutS/5WGKrm3243aQ/ZiGJRt6+cn?=
 =?us-ascii?Q?YCC/4ztV7tMM8v8u2cuIljdNROSrR4dhSgdDT65VPETHS6T5S2XkwETYeNnv?=
 =?us-ascii?Q?xQ0iog2nQelpEITeiHdvSoyTgXwy3GMa+MFoDZuh0PJEdIW4HFZojgy2z2yc?=
 =?us-ascii?Q?xWJ1vaZov1AteZ5/+rvP9oHwuaF5IX56tvAop6XQeihzaZYOE9WAjh4FxfKX?=
 =?us-ascii?Q?N8J7QP/OsYBJwMylO4CdTK3y2Tb3/9nzE0f+3zdxMoFitX8a7iope2fnabqp?=
 =?us-ascii?Q?1HMIQvQ5af9hc0VoASxd35T8JaiMmcuao1AA8WmHUfBJDMZ9C5UlfQGUc/mF?=
 =?us-ascii?Q?WXN1jwsb+7VfODbksVABZOqIrmIw3Txj45EuyNkQY24V/QLxfaJ2FXA2LXK3?=
 =?us-ascii?Q?5JELApgBjD9VIlUPwtP0qZMUGsJfDgNiw8iY58/VgJmv7Ov6cgzi/L7yga3i?=
 =?us-ascii?Q?iW9JzuUwWc+5MfSn7GJ44S9+vPdoggX0eItNXcnTxsGtNTQIUBE8kybvG3r3?=
 =?us-ascii?Q?CXeohrO7Dd8Oiq10FlHz7nz7D8+NKPEVfGqKhjZFIPA8hhI7rrI58YIDFpPA?=
 =?us-ascii?Q?Wop/lf/5ZZke2u71Bql5Vqubr7YPHcl/l5ei9RHWBopcRwCULoxFiLhQQH+L?=
 =?us-ascii?Q?0i/V3aCgspHBCy4bd6/Q2hzFArM1s18LZrF0lw+mapQqWvVsnHHMm/LaKQJj?=
 =?us-ascii?Q?G+dg2JrX4iho0FhqYlX2vajS2n110UmEMkyzuMfHnJ8kmUrSoZvsii4SxWW7?=
 =?us-ascii?Q?VE/7PhEO2SCRDwtczcUpK/Kyc4LSwBERRIsR4oP7ePvXyrb5UfrFUc59Dl4u?=
 =?us-ascii?Q?+Ymoo1fharqt1Vvk6aRBM7RZwbXqhxWcmevY/Smnyq5NYSryQ8yzI2xS00Qh?=
 =?us-ascii?Q?hUkiCPDyAkboQqnqwlTq1H1H13B7X0Z2W30FpJPnemt/DpCCI5oO8AHgxLTe?=
 =?us-ascii?Q?Ozj9vcjIBXqFwNFGHzd9lxrNvuzxsxVdD5sFDn/LnJq35P6noyV75mZ92MCm?=
 =?us-ascii?Q?vUA0pBCUkCeaxBUAbCWskJd0ptjdV0VoVxYTefAW9Oe0h9qdLwmSJ58ADEDl?=
 =?us-ascii?Q?59PW/l2qh66xuuiWvJAsGA8KbvtOnrizYDz9GU4ccJuKZNpaavwXdue/mYEF?=
 =?us-ascii?Q?hsGHgcEfGFuURURevqgGH9b7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a44b980-049a-42d0-3128-08d91fa7ce3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:23.1516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLh+viGjj9PYhXLI/HmywHqKIjNAPzVPY54IA2vy9/H/pEoSjNyrXMXbl5aOZ5xYcZua9fvOqd4pzHCL8i9jIiAXfsabaXkWkqYqSXp4Z0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-GUID: Nr6yb43KqpaReSeoJ46Rsod6Oaj-CrsM
X-Proofpoint-ORIG-GUID: Nr6yb43KqpaReSeoJ46Rsod6Oaj-CrsM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch allows a vhost_worker to handle different devices. To
prepare for that, this patch adds a pointer to the device on the work so
we can get to the different mms in the vhost_worker thread.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c  |  7 ++++---
 drivers/vhost/vhost.c | 24 ++++++++++++++----------
 drivers/vhost/vhost.h |  4 +++-
 drivers/vhost/vsock.c |  3 ++-
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b607bff41074..073b20bca257 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1808,7 +1808,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	if (!vqs)
 		goto err_vqs;
 
-	vhost_work_init(&vs->vs_event_work, vhost_scsi_evt_work);
+	vhost_work_init(&vs->dev, &vs->vs_event_work, vhost_scsi_evt_work);
 
 	vs->vs_events_nr = 0;
 	vs->vs_events_missed = false;
@@ -1823,7 +1823,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &svq->vq;
 		svq->vs = vs;
 		init_llist_head(&svq->completion_list);
-		vhost_work_init(&svq->completion_work,
+		vhost_work_init(&vs->dev, &svq->completion_work,
 				vhost_scsi_complete_cmd_work);
 		svq->vq.handle_kick = vhost_scsi_handle_kick;
 	}
@@ -2017,7 +2017,8 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 	if (!tmf)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&tmf->queue_entry);
-	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
+	vhost_work_init(&tpg->vhost_scsi->dev, &tmf->vwork,
+			vhost_scsi_tmf_resp_work);
 
 	mutex_lock(&vhost_scsi_mutex);
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 981e9bac7a31..eb16eb2bbee0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -182,10 +182,12 @@ static int vhost_poll_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync,
 	return 0;
 }
 
-void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
+void vhost_work_init(struct vhost_dev *dev, struct vhost_work *work,
+		     vhost_work_fn_t fn)
 {
 	clear_bit(VHOST_WORK_QUEUED, &work->flags);
 	work->fn = fn;
+	work->dev = dev;
 }
 EXPORT_SYMBOL_GPL(vhost_work_init);
 
@@ -201,7 +203,7 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 	poll->wqh = NULL;
 	poll->vq = vq;
 
-	vhost_work_init(&poll->work, fn);
+	vhost_work_init(dev, &poll->work, fn);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_init);
 
@@ -270,12 +272,13 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 }
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
-static void vhost_work_dev_flush_on(struct vhost_worker *worker)
+static void vhost_work_dev_flush_on(struct vhost_dev *dev,
+				    struct vhost_worker *worker)
 {
 	struct vhost_flush_struct flush;
 
 	init_completion(&flush.wait_event);
-	vhost_work_init(&flush.work, vhost_flush_work);
+	vhost_work_init(dev, &flush.work, vhost_flush_work);
 
 	vhost_work_queue_on(&flush.work, worker);
 	wait_for_completion(&flush.wait_event);
@@ -286,7 +289,7 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 	int i;
 
 	for (i = 0; i < dev->num_workers; i++)
-		vhost_work_dev_flush_on(dev->workers[i]);
+		vhost_work_dev_flush_on(dev, dev->workers[i]);
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
@@ -306,7 +309,7 @@ EXPORT_SYMBOL_GPL(vhost_has_work);
 
 void vhost_vq_work_flush(struct vhost_virtqueue *vq)
 {
-	vhost_work_dev_flush_on(vq->worker);
+	vhost_work_dev_flush_on(vq->dev, vq->worker);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
 
@@ -573,14 +576,15 @@ static void vhost_attach_cgroups_work(struct vhost_work *work)
 	s->ret = cgroup_attach_task_all(s->owner, current);
 }
 
-static int vhost_attach_cgroups_on(struct vhost_worker *worker)
+static int vhost_attach_cgroups_on(struct vhost_dev *dev,
+				   struct vhost_worker *worker)
 {
 	struct vhost_attach_cgroups_struct attach;
 
 	attach.owner = current;
-	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
+	vhost_work_init(dev, &attach.work, vhost_attach_cgroups_work);
 	vhost_work_queue_on(&attach.work, worker);
-	vhost_work_dev_flush_on(worker);
+	vhost_work_dev_flush_on(dev, worker);
 	return attach.ret;
 }
 
@@ -675,7 +679,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	worker->task = task;
 	wake_up_process(task); /* avoid contributing to loadavg */
 
-	ret = vhost_attach_cgroups_on(worker);
+	ret = vhost_attach_cgroups_on(dev, worker);
 	if (ret)
 		goto stop_worker;
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 75b884ad1f17..75ad3aa5adca 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -24,6 +24,7 @@ struct vhost_work {
 	struct llist_node	node;
 	vhost_work_fn_t		fn;
 	unsigned long		flags;
+	struct vhost_dev	*dev;
 };
 
 struct vhost_worker {
@@ -47,7 +48,8 @@ struct vhost_poll {
 	struct vhost_virtqueue	*vq;
 };
 
-void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
+void vhost_work_init(struct vhost_dev *dev, struct vhost_work *work,
+		     vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
 void vhost_vq_work_flush(struct vhost_virtqueue *vq);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f954f4d29c95..302415b6460b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -648,7 +648,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
 	INIT_LIST_HEAD(&vsock->send_pkt_list);
-	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
+	vhost_work_init(&vsock->dev, &vsock->send_pkt_work,
+			vhost_transport_send_pkt_work);
 	return 0;
 
 out:
-- 
2.25.1

