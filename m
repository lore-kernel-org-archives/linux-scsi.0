Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DACBC0015E
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 20:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjGIU3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 16:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGIU3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 16:29:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4F1103;
        Sun,  9 Jul 2023 13:29:14 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 369KQeXD030370;
        Sun, 9 Jul 2023 20:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zIXLXTxXbUrvok5zG/PIsLEH/5n0YuUA14ENBkiUApo=;
 b=odeWTD4QoMPM+AxGUg+J7OF7oOOL5Gqrh3HJMzrg6JADJZ3QY5eMlR/cdVfl21duz3R9
 NB4fkFtBCvdX9V2DNPBr57X/l+HNoj8QUQOkAi7Uq/IEBLqat0inXjKPAcfMfBmAJ8v9
 0UJaPtywDz2lEIKPKq6gU43T0NjG8oZv+vJFUii00DghqAl0Kn226TB1Bixlu2wEi3mP
 JsRSGs/Vn4cuE+1iryBYLE29E6pkK/L5BTIaDx9xGQIOnvRYgRSzztZ1a0tf0NR0YQGN
 1JYEsAEQJi76JJNOso8AeK5FqEXcZUrQEmHLmG0iwGLqJq/B20TPsUcRuhjDMqTBZAcP Jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr0wf838h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 369JpvKT006332;
        Sun, 9 Jul 2023 20:29:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88y1wp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HT6ocdT70PQCsXc1Ryx/W9/XMq1BfoWkV7ZCkjlCE3/z+IJi052X4PKUstpghhs53oqnfEnTbCmzPxCesyrMyP6p9g9jWnBWA9IzhDbutdOp8Wl0kOifHv+VkwVmIkfoVQtI6Eo+7xtAi0xoBwiKq03rLv9Kv4324GgGSEPH5IGmYwNcbeI3fF66Hh/pIOumLkZ8TUV/0DEbOetHu6CKh9DSn0hBkoM7k3TBOsRvb0Rmw1R3bqtckiEs1meL8CSGng/sfA62vYlC/5NkFL1LDWaG4n6r9PiykCAV+IYZEcviI6HIf/TeQo/UpobfySMDOaV9XCp5o2/d/HBe6Y4GsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIXLXTxXbUrvok5zG/PIsLEH/5n0YuUA14ENBkiUApo=;
 b=lBASC/cv1CES9/TBXoquUJb6IdQQ9GVnd6L7kZtLlCD4TJBmeK2na+xE+lD1Kw08jGGAk3h4msJGLN1/GTJkhNhj+9yiecF+5IJTzhbm1kWwgz+mPlICZF6JAseKbfE/Tvej3UxImnAsvYofz9W5LqiwI3c7Y/zUgmPNfOLB4to/sELPMLCcnXeRCsYTBaVsWmwpTqNTY1wiVedEEnsNlIsPlKSsH6QLWN/8d6hs1WMPk8H3g0HPMMV2Ouckx4VlJlyPsxaAKR3OWbH0cX9j7c31eJOLt3+Ob/n78L62G7TaBJevzoWNL64jg/hSqfu0afuLfOQ39U4P9QLztdDUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIXLXTxXbUrvok5zG/PIsLEH/5n0YuUA14ENBkiUApo=;
 b=mNU0JqXMW+Dyqdgum1gEyFjCK1kgMZBLHr3uJiLZ+r81r1JOvNv6U8QSHKXpZFu4L5PiSVBtNzrcWnrJoLiyYgSAUpnNKVQL3VxWRhei6KLkABjB7ouQomNiB/t0G5oguKXdFgX5uhS/2umUTi+qOPrW6AJzbrAJi+Lc8+iT4nM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5994.namprd10.prod.outlook.com (2603:10b6:208:3ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Sun, 9 Jul
 2023 20:29:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Sun, 9 Jul 2023
 20:29:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/2] vhost-scsi: Rename vhost_scsi_iov_to_sgl
Date:   Sun,  9 Jul 2023 15:28:59 -0500
Message-Id: <20230709202859.138387-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230709202859.138387-1-michael.christie@oracle.com>
References: <20230709202859.138387-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ed61e9-f056-4d6e-a737-08db80bb245d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUfKGmUGevZDqEWO6ra9VJ7pqLLFRnSVRNrLE+zzzgnDZE8AizjFUcGgYLcQcXRtr4xyriMlOQX2athWUgfhI6KsG5frxj9K9r6mGMcBFI6vIATn4b6r6lzNuVlinMokGaSdS135G7PlDkmkaxqwoAnNp2W7WU5BdU/fJk+QPkgx92E4qNnDeTXc3oWzgx7MixI+iRc7ZB++gOSB5rs/HvWsYYbhEM8PhQNwbZuczkTOzA89/3kMo+eSkYyXwvT8J6lHpxsdc++Dqh8VsZRGPX1Bu9bydP1/CXj4gz0wEezY7t0CFAEqFuLD64AOqdEpPqag9cCpaZzTcFXHcLgLDIos6MTTBwhXLLecc+8SX0ZsylCEiGTMOGWB0oM9GmIhx3P7lbpR87W8dRHxqZliAZXQ+KcLtlvjgmd+gXHzknocSfCyITa/tNTVkArt3A+3IEACQp5x6dU0htKDtgS7FxMZ/j2n/bnj8IYn9SJXc1WN+TOiZFv+NiDHKlCo0/LnLvtgSNhlPkTNGHXukYjhUZ+0YduBUL2Y7NMJG4+uZeHGjWF359grLKyD4JeP9pcN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199021)(86362001)(38100700002)(36756003)(6666004)(6486002)(107886003)(26005)(1076003)(6506007)(186003)(6512007)(2616005)(5660300002)(316002)(2906002)(66556008)(66946007)(478600001)(8676002)(8936002)(66476007)(83380400001)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NN3MmaXeq5vOHdJ9t8UvOx/g9ImFSSa7lFHkm3RsBJcBslsh423f7d8S2pMV?=
 =?us-ascii?Q?Xvd3b0H6YJe9YmgdBZTJCET0rZndfhXXBEiQGI6/ZOlP0Y6N8LSXEX8n/FQ1?=
 =?us-ascii?Q?q9BO9C4xYANuWyxwYYMgSNYQaMcSwt1AkWEkHuT5QzwF/vjra5pc17QfrrCW?=
 =?us-ascii?Q?Xa326/KcI3eOBK0YauAylHTZ/T/BKEREA3V0K3eHtv8c8ZE9rwiT3RwlmeJ3?=
 =?us-ascii?Q?AizQAuiktDC8zFLxgPrqHGA9GYKwh7CtMoH4YSFJmyVIV1uL8iuNp3uDcVvU?=
 =?us-ascii?Q?EyFuLYgBTdfr5FuZ9gn6lcPsuJNy17zS69TYdGqeYkBwlUdYGQpvJzr/NXEO?=
 =?us-ascii?Q?s4BptLj89fhpDGPsl14lWenzJkPvhCeVkHKyL1AFCR0PzsfC0/uwzTnNMCCp?=
 =?us-ascii?Q?LyYHhwVQd/6+Ngpkpx4sCtGA2w4GGw4MbHQEvfwdbvNQLyrqowoLHBEilC2K?=
 =?us-ascii?Q?AeDzfjUYY6EAGZ0BBp8YKfW3IiDVkmE0tOKfvucZGgZMVmXN+VIwIIkqRX7w?=
 =?us-ascii?Q?PZq5ws4ME7DIKMcnOMFuLm5pK80NNZuK0ArMlAc1LyF63Q7Eg1/SkzLZxjWD?=
 =?us-ascii?Q?WS/YcNuY/vQRr8Jv408isiWxhVyJdPFRZPAoxnkG+ywDoWwG0+DNT/X7sqA9?=
 =?us-ascii?Q?na3uyDja39Kvls8RzBO8hWotCippvxErQ5tsajLjfUFs0Lml57D75RCb5Xmq?=
 =?us-ascii?Q?4W/YeKn6ckWRPltvd0n3npYztRfN85coDverfjqbXFMA5T6JYXgmK4D/TuaB?=
 =?us-ascii?Q?kwf+WVq5Sj28NfVT2Brt8/dpD8v/0bu7a2+XU2LIv2Iz1r3usk1NHcge0z2m?=
 =?us-ascii?Q?fykmpNq/8Uc++ONeG3zjKbdJQZJ/KZb9w4qSGS5biBjkHAO2tIx3iGjerdbb?=
 =?us-ascii?Q?MAObJp9CGdAx/RppYMvD9JJnLoT+x4KeFX96S3Icb2IgyHcm08CcLsN+jtCV?=
 =?us-ascii?Q?/hxe/5Qt1NSnJdQb8ac3w+My0nbel3mf8DzjLKwvk1HhLBIIfCv6daBSWgL4?=
 =?us-ascii?Q?bHtul1Lh6BUpw2RTSSlluCXjjXZbeTt3BzcBDbIMYkBNSX9uHEWWkehI7Qbe?=
 =?us-ascii?Q?5QYCBopPZ84o1GeHTYI9m/8AqdUXPwQVW5bjpEdYv2DKaSQM75/HfEjglhEI?=
 =?us-ascii?Q?uPQGe+fNb65eI885Z186yAUdGTHZHqBeeGxyuYgjomoSLl21uFpbEM7Y3RCI?=
 =?us-ascii?Q?sZ574ujoaP6xIbFfo1Ou64G4OnB2QUPicnNur8VK8pK4T5bcNBqmvdjuiN0o?=
 =?us-ascii?Q?+plFSsEyuvrNi1c4wPO4h/waCJLtELIx61t62DvjBwl08dnqE3svozOW3MNp?=
 =?us-ascii?Q?qLgW+tWIrNwTk/Q5nkNq5++YwimPfrtHfij3IufNnEFQC1DvfFBXyEELKpKI?=
 =?us-ascii?Q?WVqJJ69z0tm8XX38kpZ4E+ik+4Z5hHKqgIbgcYPkGb68EPuWIbfUeGM3rwtt?=
 =?us-ascii?Q?opTCw9TQ/ijbNZrBM4KA8Z8DNvZGkGwHfQviqD9uaClhsQkmdegBDXu7nUgu?=
 =?us-ascii?Q?WE7qWfnJs/Y29RGUMy7WaZIt5XfbQjYLxsp/JDhdauB8VGpu1wdNxB6VXxte?=
 =?us-ascii?Q?050ckgV28x+/jqdwKS9hqxACmQ/LiKqdVWasnY8m9i1rVM3u/KNhJfzLQTN8?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZFuyjZ91z0gQKbTmZDVIxzSYk9iAOAuaDrOZE/wmzto66o4QsgSbFPgCSkfqRzBJOaivQ0MY0eZNYBRxuK9Tz75vlMcgX9asQz0kWUiX4lWT83xGXn7kGuGK2tfHByRxN+HAPAR4C7l3hwy87muEnlx1haAP+0g+C4cwf+6Bg7V0wgv0emt+qBHUn1q/H/Jhc9EaPTV4oKCfz2agTcP+dE2baxdfJm0ntg/QD/HzVWwdX0RkrZp5j8XuUVntU8GVY03nCt86hS7VCp4CCjtDs2QkuMxNhGriz2jDyJkF6Cwfb0ps7VKDgfu3k38+w+aBlvyTwo6x6mzjR1RVX7AQmpjyM5KMAftqB8200xlGt3Ro6jcB+nGmiQTWCNNetSh2ypZSiQZIdClIVhmnH7F8DWS12R9k+exB1RND0jQQrouHSulOLekfbPTQBYYpJ1ZGmbcS1CDLY7hxqtNh8zYdU229+V70VQlvLT+NE7LkARrUR70XhWacgSHtD/WoQiYOFy9X+CITb17CMpwy2sEt7MJfIPMeA2NVr0x34Jf78Fb8Ec+N4UQ8Wj0YqL6X1iVZkQQQMRu4fEQ1vfzxRaOKTlFuupA6vtra5CWIFsx+WCp0BoSPd+0ygvsKLRk0dplDpDEeZtyg07Vj3J7dLFfHe6C7LUa8KGFKylqDlmDH0PFwvSg1oSKMgr5fu+MPLUQonZlb3lvzHj9ZFlzwahpb8IcVNG1nNX5lq7Lehsd8XYwEtjL4LWbgxuw5OKhgJbHLwgE3LYVC3mrlvZclU/zcUftmMSgRn6zUbPYOD0lSGRMDQ5qdsxNa2TnpYydica2z1SJAN8oQ+iMdozxC53QzCKPs/BROyJM2Ll7k43nvtjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ed61e9-f056-4d6e-a737-08db80bb245d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2023 20:29:06.1290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMJRWaVEnjtL0LmwOObVJaMUXRUZwAG7OEIMIOZZMzeWcW6D7MKSrknELQNc3x+zqGaht0eoBu47q461JY4KxveUHIz3mkFScpx+/jdSdp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-09_14,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307090193
X-Proofpoint-GUID: C9pw1s_JrDdCbWik_GwnWJBSVqyF3yF-
X-Proofpoint-ORIG-GUID: C9pw1s_JrDdCbWik_GwnWJBSVqyF3yF-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename vhost_scsi_iov_to_sgl to vhost_scsi_map_iov_to_sgl so it matches
matches the naming style used for vhost_scsi_copy_iov_to_sgl.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 324e4b3846fa..abef0619c790 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -780,8 +780,8 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
-		      struct scatterlist *sg, int sg_count, bool is_prot)
+vhost_scsi_map_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+			  struct scatterlist *sg, int sg_count, bool is_prot)
 {
 	struct scatterlist *p = sg;
 	size_t revert_bytes;
@@ -829,8 +829,9 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
 			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
 
-		ret = vhost_scsi_iov_to_sgl(cmd, prot_iter, cmd->tvc_prot_sgl,
-					    cmd->tvc_prot_sgl_count, true);
+		ret = vhost_scsi_map_iov_to_sgl(cmd, prot_iter,
+						cmd->tvc_prot_sgl,
+						cmd->tvc_prot_sgl_count, true);
 		if (ret < 0) {
 			cmd->tvc_prot_sgl_count = 0;
 			return ret;
@@ -846,8 +847,8 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
 		  cmd->tvc_sgl, cmd->tvc_sgl_count);
 
-	ret = vhost_scsi_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
-				    cmd->tvc_sgl_count, false);
+	ret = vhost_scsi_map_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+					cmd->tvc_sgl_count, false);
 	if (ret == -EINVAL) {
 		sg_init_table(cmd->tvc_sgl, cmd->tvc_sgl_count);
 		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
-- 
2.25.1

