Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F78C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5E561215
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhKDTII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28204 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234234AbhKDTH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:59 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IapaD001625;
        Thu, 4 Nov 2021 19:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=X5HrRn/ql1GFGMZSy1m7FRy5eOe5R4RwTzYfSa4G6ew=;
 b=izSnITBz/SnV+L7VPF9ZgA/mAhISCT7QKx8i9MOBGSXeeFRiASbXx5wZoXqMbzP2NQjU
 BZe+x8rr2me1B2HgsYJSnqrbPiTiQJcDCkbkk+cCfe4uk4bDGrNWmOC5Ar2u15IN6oZ/
 JPrbpSwvg/fw1BHCDdbjr0rg/hNPUdB2gxDiTL2QRb2yqCnJimYqL3TlRQLHzSSMDf8Z
 ppW9j404usLgWvZI3wwU8oynqBy5wCe10G+Ms8EOKvM5arhcIpoiUBEM9boshlf+DNJh
 BuUg1VdLauDYfWHM0L8oInILAQuCyxJTGcqMO44oRKeFcsSByKe+5Ty/q9iMQtC6yuux 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIh122897;
        Thu, 4 Nov 2021 19:05:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/jFX/yvLDHa1jhfzOwr9uSBWkOkoiuGQSKd0La3Y8gPjTpWtNP8Rdx/U9mjLUcZJGOF9KQT3yBebakqYGoccO+qY6CktcipzEI9c9YQZmfuQbY1kzeV1rGTg9cmtWQmuUVS6tTXiunKCm9fji5rm8nv/qzcLoSvnwIEQYz64Fhxc8gabInYU8FXfqOyNhUZfJ0PuaZVBJ+tPUjC00ncR/AvfTE24LdAAgmivfdjDFII/WyHHgeI2NYzPWIbi8oC9Xcwuesvmyq+mGuwqw8aQCkT+sXia5S+2A6DU2O6GZ1fPHs7s8QId8t+NwBH67a1qC8R+MuZAfd4zfpR+/rjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5HrRn/ql1GFGMZSy1m7FRy5eOe5R4RwTzYfSa4G6ew=;
 b=QP3o9ZG09fcnqBChQOiqSeMrz0EHyK8sgPwRouMpkM1kJIVaCe6TjqSykCKK7ZM78ph/0bC7kp0AHoNBkwo6O7B9gTlTz6xeis4K3oFeHmsOR+xR4LrCsXXKlSSIQ/0utdySxqg4ejYEEI/3T73WMNBeAId5aS7239Ue5nP50u+wCjB0FDIAOhwJhiKdZzn10wpQrLB8ndAUUfRGS8uNIsVsgceYlH7ygluj1YoZ2lTESZK1CmxJ1yuBNAO35EzVaItdGynGowKsyQb+ct3UjC2u/dzANAqMolo3SEw3GUjXqlVQK++D0EPZibbWtt7wQXZK4h/2RYCUgmEf7Hekhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5HrRn/ql1GFGMZSy1m7FRy5eOe5R4RwTzYfSa4G6ew=;
 b=GclgwAitZFdH+B2xuezUUkxQY6NpA63gpePzFi5P31mcyh2XpvS4dkTh6tRdm9GGn6B1Tp9xFfIieihKdrLRa06aq/SS7oAFkyJNOrzhR3WaMIqs4/sIRoriC0TuRDzMT81T5pEM/mp2vPtvSXLDAqiE/OC2sHc/SeXha3Jz10E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 05/12] vhost: convert poll work to be vq based
Date:   Thu,  4 Nov 2021 14:04:55 -0500
Message-Id: <20211104190502.7053-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e958ab9-85d6-4591-f394-08d99fc6071f
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873C48AD95698FEECF91C9CF18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Blq5QWpoh39qT9iRi62I4GZIJtgb0IlAfjO9MQy+pIQA01awPs2vnTe7H7OSLvMJ1xdryRl2915mVaxrTrQdIFU1KC7Jb0QkyoV5SOCQqhNaDLxo3kv5+G8g/UsA+LTWAdfMa5XiljNMEL/ulXvcPImqeQJ7wd7vtoxhBGWQEdOqX1fQbjHDONswjDCYSHuc7YwOD9bHc4epDsMzO24Hpss4qVyEpMEvvoGuaLky1tuJRDgMBDtfqK/r7QomspMkp8cZhnY2+v5rhqgrwHVRg093wBdEmWSaaG9TmLHs+pD8IMdBonUv9psMyc7JIFNafuZU/EnaIWWGYFsRuexhQ738VITxYg+XZ6azPqEZmySUTzAlsyT1LvdtvyUryRlEZJ6diJm3kpjWk9armDKlHBBywiZZzlpL4g9xArymWXkR3yGZHLvyKuBgnlyds+3unoDnJ7YcHswpzCgruQur5MyPdvrvDiY6iOEeIsAQvrpieb1+ytK90TAQ9graI1wMQQk7tL76k2vaTq6L93m5CbH8KYOHwG4X5IEzYYZUIEdNIf142N6nYaQJA9WsDc/nCNh6exTwObkoDBU0PQrnDp801F1qitxW/COgQBTTWeNjw0RKl9hjZTULTE9ITgDg1LYzq7cNBrP3oDic34rjlafI49tpOSUsXBOR33LcqQqUmRfoxVbTXhE4ZKuBKuUysxbKDhZ4WfKpWH7m1TctMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SgOUCzhIjU0uThXaC0KKWQSVpSGZhtaGhvd7iqLLnYb4Rjb+ntNhJOGGsmNd?=
 =?us-ascii?Q?T8WV5MRqHMyx3x8BL4n8e7wFb4wYfX1oeJAZFVSdPwVSv6Gmo3of9zp+VQJj?=
 =?us-ascii?Q?6Xtgn8JHZ8QG/mGkwTBdFHpyLRXyUx0DRu6CEAfzinV+HyPVOiGY6gSrqwv7?=
 =?us-ascii?Q?RvhFFshg7yRil8hhG4x3mRCLgQ6ROZsnuASqHhlEWeaU2VQyhq6WzmVi/SXL?=
 =?us-ascii?Q?yvC/D/UmH74DYKz/PzPryxrZsydHguXKhdj66FIGnLT4F3aEE8C89wM9REsU?=
 =?us-ascii?Q?Tf1HU15RhROS1fifOlQ9xdVtKuO9OGJzv6t75yRI14ALXhwrQs2K+LycgUUR?=
 =?us-ascii?Q?pd7GlugFmKD/LehPG4sSl/1eJogCst08bY5NVhfBFixOCH5A9O6EkTx0I9UL?=
 =?us-ascii?Q?TZh7cj50bVpSzqqfUztvD7cubIXxCdcYz/QReZ6o2Q3dkUQ56iwEOrCoZ8gH?=
 =?us-ascii?Q?mXNiadsbOd8I6qHUaBaSIM0Bi+h89aM8KLEiTR7fu25SdR8xLslUA/4YMjvo?=
 =?us-ascii?Q?TfCF4KqDTmCJszjYsLorA7+7fs+bO1dd5EuisSDr3pM6iLMqudTKUbuDHG9H?=
 =?us-ascii?Q?xyz2Qso/x5qVfxlFcqXNw5q40FXgtYhPwxZQnhH/86sNxk08fznWOOqRC0xS?=
 =?us-ascii?Q?HIivoQm4yCMNUVEIUXWBVla2eZvTnLxHwza2zO/XnL6da+M8wbg3LR97R1AH?=
 =?us-ascii?Q?fPX7WWm35nEj57MuZdG52g7+p1y/08ZVEntheOZ/+2KafJwA7UzRcZXn06SB?=
 =?us-ascii?Q?qpOoA6h47j8s6RSJJy0/ikifjcVF8YXKLDIjwQlTB0f+O2ZVdVnWLl69KDi3?=
 =?us-ascii?Q?Of+zL6FVLP7KA4ls8Q2tCOU5yVIlVZK2akrbWjLxL4kHXdSy1s6LjnRWv9Wx?=
 =?us-ascii?Q?RmqSxxOv2oM1h/psytrddDT1LEha3rXlmPqqEViQpA0NhhXjdVnIX3iv/Bxg?=
 =?us-ascii?Q?w6fPBviXfK85vqRBZICXqw+Tg58bug8ROWbdf5RFX0jPXaNRcA2sgSt4Wdxl?=
 =?us-ascii?Q?nbz86YwCr/hJpaNpxv7y1FZ1/IFj/hOtfk4ubo1x3GTHK3r0w/eqJd86u8Fq?=
 =?us-ascii?Q?y1F8duiXJDjdcYGRkQYy+/JuGxH+fw1CEZow/GAYedwsbcoUgjVj4xG4Iz6R?=
 =?us-ascii?Q?BYpGOWOI8LHH64B/wTzzgiaQQMCObz2icg26C9aiztcGvD2/M3DDXnhTYjqL?=
 =?us-ascii?Q?z9Rr2RxUXLEIoitCLMICgxuYtqxwM1IsmD4m7vp9GQd0wytvQFFz6RQLlLIA?=
 =?us-ascii?Q?vqvEPDDRr3rJZiQIv19SjWIT13vMmUeN4c6HovT5DVm5P/m9Y3u9kit9z0jx?=
 =?us-ascii?Q?BWPO7IVWIYhrKJHo322+OWwR7EaQ9Y2XSypveEHpToUmsmIGMhCKE2jhHGhy?=
 =?us-ascii?Q?/S0YImYdxbCMEOWTnaB5qAi5ebbdRLoBSX1ISwMwyGgj9PZqjrP9LQdzAnb2?=
 =?us-ascii?Q?nhErdlIRcqzsp4O5feJPzbEoxd22zRxbXNznHcyn7dUZWc/aMhbfXmLXTl7X?=
 =?us-ascii?Q?CWrskqSRlUqd2vkyRDt/kEOwgNZlhASgtjcNl2GYupaFdBj7z0fto0VZy/cG?=
 =?us-ascii?Q?bOxjbZijIg4FvSZ2qa5ZQ0dNl6p+ZetDlbusK87opM/Mr2F90m2zS+xuKRIa?=
 =?us-ascii?Q?Ygylk7NsVRT6qJYuOzsxCXphHhGLxp4r3u17pfsyLfIsk7Nn+hIBBm6aHkUz?=
 =?us-ascii?Q?D+EKgw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e958ab9-85d6-4591-f394-08d99fc6071f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:12.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xx3oZ1fIsnGH2V0pkioaqcEHajzM0CNRqFNEV3FYmeASxM+GAd8frK75+IZdexbDcupsESflJzcXwkm8ZiVqWqesG6ocFxV0brjcHYjZlyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: FNNyY2oljsMKXaSiVo_KE2xHh2roSY1C
X-Proofpoint-GUID: FNNyY2oljsMKXaSiVo_KE2xHh2roSY1C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has the drivers pass in their poll to vq mapping and then converts
the core poll code to use the vq based helpers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  6 ++++--
 drivers/vhost/vhost.c | 10 ++++++----
 drivers/vhost/vhost.h |  4 +++-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6c4b2b2158bb..2e1abab45f3c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1339,8 +1339,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 		       NULL);
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e4d765f6c821..c84024afefff 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -186,13 +186,15 @@ EXPORT_SYMBOL_GPL(vhost_work_init);
 
 /* Init poll structure */
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev)
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq)
 {
 	init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
 	init_poll_funcptr(&poll->table, vhost_poll_func);
 	poll->mask = mask;
 	poll->dev = dev;
 	poll->wqh = NULL;
+	poll->vq = vq;
 
 	vhost_work_init(&poll->work, fn);
 }
@@ -288,7 +290,7 @@ EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
 {
-	vhost_work_dev_flush(poll->dev);
+	vhost_vq_work_flush(poll->vq);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
@@ -301,7 +303,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_has_work);
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -526,7 +528,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
 			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+					EPOLLIN, dev, vq);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a985caa35633..d9650da2be2c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -46,13 +46,15 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
-- 
2.25.1

