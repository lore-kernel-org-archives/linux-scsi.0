Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C23DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC4261215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhJVFV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:21:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49190 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJVFVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:49 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2kco5016504;
        Fri, 22 Oct 2021 05:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=KpQ77JjLg75kBKI3jdxp5Qjzn2ANH4HFPLU6cZpl5QO8qrwgZgm5N8yDuIo60LOCmKQ9
 v8VcX7lOnTiMoQd1J/Vr2YXUFeRkeNAkGNq6NzI/QrQrzcoWSp94UKek7hn2odUshxa1
 VT5HvXF3gj/h3MQ+MUlYkezsKSqjBEfItsAzgOWyuypgBBqq2QBbVwuNKKJP7Gb8tQdx
 R3acMd0w8x5LmCCOshFV3fiKnZnOnOv5mUjRJjA3oJRTQzl7Dp4maL4ycurkrVqWtgXf
 b3Fa01CeAgU6/FytNJf3iHIEZdiyXA1RsvBHBwyt94Q1BEgEkniJK+AoHJ4rqsmn4fje qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm8sxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIb139141;
        Fri, 22 Oct 2021 05:19:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItZV62dg3/h/nKZR1tnYb/8KbQ1grL9b/6dLdNKsDQzB+OkPIboSeQLkS5evRh/DyRwhfmtjsOzQDolElLEj7OwD+pVpBGRT1pWU9GuJiGkx1blo/sUQaHZGIvESU5tT2cEmVxuIoygrrsMyp+JgZaEcD+sa6bteHnM31v47VEIG4Z3QrQ5xIZDd47g4zw1X2oDktxqj6wNyPZb1EMMP3M5q9mW6AjlMu/RTLEjJKlQ4oiZ8gTtpK1oEnvn9BnjE1hmUa7ea6VDCOLEjgZUFDwK8h5UNNQU94xokcLtWIcDTrhBTp3wyI2fmgBRqVumz0A2ttMocaRquPbR9VPgpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=Wu7XxHwStinvEKpvKspc9DbZ6yW3P+1tAEnU0XuufHCZrR1tyYuSQgL9d5MLQ+gV4lr+PTYoIiE2a6i1np3SGCB52OeVAhJ1nq2e5Df4lqP2UVbrT99h97uEx63I/Q/MYi1hAxjQJGOMT+9ymZcfl+fV/9en9vLAQx03RqaZxIuESqz4d5ysvGcKT0yewgV9T6Z5WFosSWqGWn++xbhrKL/UEWsavuWvuoJWqyjwie8Y/1J9m/9VqRVA7fnZdM7jClSjHJQ/ALj/qfM/w+GSLD2M3+NOjmQNsEvzDdSZki25bdNg+67T54RZZZOmiYRFYnv6BslDFb6s60mn9CwkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSY05G+VH6XojMvrb20ZXD1g2hwA5+AKsJUy8o8qBuY=;
 b=dsAIvIxVFaAGVRsKlXmN92lnLmTok91OTKedHvnWtZixZG8yg5C0GJFvuus5huEX62wX47vCJxUnG1hzbDS/EU0CF1cS+UEYfR0L1h+xadU+rgbxCoYOi6Ip/glP9+mG0brENqMOLlug/nC8bZoZNUD9pyLfVs4FyDDtCmdurzc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 02/11] vhost, vhost-net: add helper to check if vq has work
Date:   Fri, 22 Oct 2021 00:19:02 -0500
Message-Id: <20211022051911.108383-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 335476a4-3d00-409f-81e0-08d9951b8339
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49740543882CB215782FAB4DF1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZRieUwQCwlbyyfhwwvG9RdJKJ2AP8ouwF046xHq++iboOcFiU3Nk/ir75mYwzTFNuVJCh8g83ABF/g/r1l6Lwxi7zvKcPSieHGGLx7wyDLaLznxF/tW50M+eergZbic3gBLE0F72HmbEl/pPKyRO1MGkaiWZI1K2RwPCJMoWPUL6j5hCe4PEkeT4Fha/bnmy6nCgkvL7w18fbezE4dhUnjaGhi0HOOUBFdLrw5hCsiwGj/PrLG8bL5Ta8b+w3hgDEwxYzNkxrsiZyEdVbjrp9M7M+8DY4tMglsswjveVsA2zFQIpuDQh69NT8sb7Mu0pdaUS209HpQhiVilOYgY1sh0QRZnNGYCXlDUffq7GZoqzJ4XD2LQBmmhDFJs1FblmfPGsaGJfgToNDUhnV1o6702UkW16w94507DygcjPHGsihIs340X84x6V0XoJeIJdVwsWhezZEokDAQNr98N7vz6RJqHgIJZcAQEehpcdsvx3OFL2I4XhwOPuPtYxao730BB1wR/+gLuttnKAJQzQ6VMC6FrplvqjhSuBv+kcADe8XiOv/81kVOWQ30oigGcmKsSmmP5fxH73RmHmxYoLdf8cm7XQJxyB2hv6YxjgTJ8d8UBVSksssDgnkdHr8+tFtoekv4sERbU+Mblt4QIX7/GePN3I98Eb2+hQQaQSlLnJiiB76ew2UVt05r90Z+pWX8aRR0p0GvKIiNPGdPX7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VSWXu+HpRuPX7ZG62Gd80PaoXA4j2+AKEvh36V5KjNk95M0Xb1v8sb+7CxaX?=
 =?us-ascii?Q?ftMZlMh1pa5fry2YjyE+UPEdH95UKzGmuwLjnqX+bvAkP7/SLmL84IFBi6or?=
 =?us-ascii?Q?uqcDXG8cMxoUVPT59kpHZKW0UY/yt7SnHGDxghT9O7I4b5ur2Qfbu8dLAjGE?=
 =?us-ascii?Q?nkG4EUNhFTl2XRkNN4JDt1DV/yLeVGpOsISwoqWCK22knxXEhWRpfsgoupec?=
 =?us-ascii?Q?PvFynUdgL1bSoujK0x5RLkLdxQ+iw/IeuOk8rHnB2rcOJTm7d75XsrpdmOdn?=
 =?us-ascii?Q?XJhh4er/7FasYrp5s6iwc0ZJ3WaGex/+Yd5ovDVichysU+f9a+73WbxxnSGF?=
 =?us-ascii?Q?kYOvYnt+LtshH10Zpwp2LoFAeD3xQFxPyVwHXEawgaEZHvwmOE9PqN2AcLZf?=
 =?us-ascii?Q?Etdlnp+hPI4f4NeRxi97zOOQcRKMEx233F2Zw8dpkG8Cc426fFlYmB1qGhF2?=
 =?us-ascii?Q?Xhwtc0w9UGTByFYWwCcKAcYHgrqJ5oxysTEF3ALPo0iE9jT5TR8dJ72FT7PC?=
 =?us-ascii?Q?NzNbMQISb2928GFLhUXKIXVUj9e0b4USHSo1H+05+yHXpbCjJboXjspIVbXy?=
 =?us-ascii?Q?lTHaW3zC98IghdxK6LUz8P3tvbiLBj56a0eeaxOpah4ulkGNkGu7ltza4MBe?=
 =?us-ascii?Q?Kt8rpdlT5wJnwU3ySBVgFYB+HNV0cCRM24w2OAtg/xjrGASv2VLmRpoMEyBC?=
 =?us-ascii?Q?kwDbYSQ1jxjO++mmHTofwzHBuxxs5t/HYnrfvycI/4yaDGdfmj7uQzkxlUHG?=
 =?us-ascii?Q?q685vyZd6ppJnorWrZq+twq236MBZJvp6EOfI1Zj8KmDQvul4VQzE+vzhir4?=
 =?us-ascii?Q?qNn293v3JG4nLlkw6i+D9iiU9WUaZBxbOTv41cSYBmoNUGY2xqmqgw6jITef?=
 =?us-ascii?Q?Z1lMAcJrB5KQ6DIz0Lkw9sqz2MVAeOktl1crvI6sunmZF9/HaJSZXzks1o17?=
 =?us-ascii?Q?+v9JSr41zNZiP9RRQ+ubq0eEY+lGUijbnU7b+j3dmL4Yzut4gzXMa1/C2rZ4?=
 =?us-ascii?Q?myNVMFp+3GT12nmD7agllbvs3Hf1965H5wgmPb9OsuPq0cDX9+EQvkqGUCMV?=
 =?us-ascii?Q?YRUL3sDS46cmoqIhsX4e5XmOKMCff4WIhV6RMIOk2F83i/XHKoGMXzorFEtB?=
 =?us-ascii?Q?vtCBT0MXxi6WWLKQaqCziNCj/xNW/3ukmVy+RueLu63svjGuS9qVlC/sxD1D?=
 =?us-ascii?Q?7+HkkzyHebGe7r+MTDbOOYag9JdrozpM+OUdc1RR30ZarTQqZpfDuUyIWcU/?=
 =?us-ascii?Q?DnslW+3KfMnrhF3gdEegLyBcovEv8KV7imeBdF75vYsdwc5P3VSB1/DurSd+?=
 =?us-ascii?Q?BesUXZ/vebN971epTM1NA7EQ1uw70e5LM7cXt4rnLiH0TfBKnsYHqsJqRQZ8?=
 =?us-ascii?Q?8Mxdi2ZD1BaUqsBZLh5JkVPIWqNIbviuNhUIjJvClkMKLy/R+USxItB7nQNR?=
 =?us-ascii?Q?5lReK+UTnaAS5Xgtb8ytZUiAf9OMICHU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335476a4-3d00-409f-81e0-08d9951b8339
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:24.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220028
X-Proofpoint-GUID: Mqi6BlBXwjFTfGaNiDtVeuUKBN_hbyN6
X-Proofpoint-ORIG-GUID: Mqi6BlBXwjFTfGaNiDtVeuUKBN_hbyN6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to check if a vq has work pending and converts
vhost-net to use it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   | 2 +-
 drivers/vhost/vhost.c | 6 +++---
 drivers/vhost/vhost.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..6c4b2b2158bb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -543,7 +543,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	endtime = busy_clock() + busyloop_timeout;
 
 	while (vhost_can_busy_poll(endtime)) {
-		if (vhost_has_work(&net->dev)) {
+		if (vhost_vq_has_work(vq)) {
 			*busyloop_intr = true;
 			break;
 		}
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9b4e7d74dab4..f6bfa1c481df 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -269,11 +269,11 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
 /* A lockless hint for busy polling code to exit the loop */
-bool vhost_has_work(struct vhost_dev *dev)
+bool vhost_vq_has_work(struct vhost_virtqueue *vq)
 {
-	return dev->worker && !llist_empty(&dev->worker->work_list);
+	return vq->worker && !llist_empty(&vq->worker->work_list);
 }
-EXPORT_SYMBOL_GPL(vhost_has_work);
+EXPORT_SYMBOL_GPL(vhost_vq_has_work);
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 7ee38b4a2807..37989518a07c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
-bool vhost_has_work(struct vhost_dev *dev);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
@@ -200,6 +199,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-- 
2.25.1

