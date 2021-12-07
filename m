Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7700FC43219
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhLGCzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50002 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231694AbhLGCzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:06 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5CPn004499;
        Tue, 7 Dec 2021 02:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=DkoqjtSG2ATYucz2O/6b9MD6Cz3yAAid8gBClUM0Bug=;
 b=TykCfqJkJsRmngVCXfkJVwF+RWXXXPdEE4R6atUFbJxr9x7rvhcVdt7XvhecQFr6rXcf
 utPooisrU5FgIEtVi2w1Zl3rf9Rm1TB7kcbDcTZaBA7oUJKHa/EswZPfHqz3O+CB4/P5
 o5e77iC254CK7M3QwaCwLkvu2QF/HD5BkNd2wCFmKP3vWm5rmz36vQ/gopzSyAO7mdyW
 7CIyYeQsqo/wn+FrmGHktTb0JRiFQb71e+kUZoNZElpjZBSTXvsZhHWrt+KqtXbEcbtn
 oyhORhCvQ2+fE8QxJelfm+OCAlpldjtJHkh/uy3vuQ5oY4+ZMvbjmVedZdANi9wP+oMY fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjbwyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kgle153019;
        Tue, 7 Dec 2021 02:51:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKvb5ANqeJTkUvNLPXYozS69evUJEtO6qhyGs7rLP319NHBN9ZiZXVM+0Xo8Oqe6Hqnt5LVNWSwObobkjFCmPxXi1eEa8KXU2+Vc+3gWTvcUMscocsk74dzs5qEnwlLJw+FcZ0+EXwV1o80tDmL5ANl5tc/gKMb4zfbiO15AyMn3QHePz6gtpntKDzFDwDjMWzZ9h9PgGaepZf0wRT6XM1zvv2dlPfl6t77IHCY/JPHB4wBBTbsoS/o5oLJfAEAQLip5nDGaFSmgZ5zyQ4yOt+TiWHw7WLU6V9wlhhT2HswTOxxTIZ9w7vF3oMQh0Zrob0r8tVoNAR7xdnmHocIBFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkoqjtSG2ATYucz2O/6b9MD6Cz3yAAid8gBClUM0Bug=;
 b=gjjdCnRLHPQ/aQRlk7N81nZMPZoyByXHTnImUNcqww7lBb1a0aD/owvub2X0CR7RfsdU9fmeKK38IlbNWNhsUra8u5embqIuz831S42DUuWGDdIfVX8A5FhP0ULFPJTh7syDr31sBDrX7LAwwlyvACHOgkRG9lnvbQibirD96LUE4fXVI6FNhTXQEwsjG/sijzHF4pIYMRqasTyikyPsrPdQgjTk2sDf8ESi2HRdSg85h6PQejSAYpa3GtbcBiunPu18jAqXUJdWCD1xrB8sfK2CCAwVu7dYVm6yatPaaDDE6B8J6ZBvIHiO0ATHEKDh+YeGeE2dXUjKtDksGmrHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkoqjtSG2ATYucz2O/6b9MD6Cz3yAAid8gBClUM0Bug=;
 b=Xf7CIxLprJAHCCJea8vOC3TNia4Sc7qaKoNT/lTWI28UoEtuZekkPNatzyFWj6DsIMdTob/xYaqFZNq/9AZ2YBVqMblY89Bw5QrTMWylgFJxTupYZK7Lw7yUYyH+eMoewJrmMtDaEf6qOvTVEKxul81A/sOX0kstYnPE4+kALzo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 09/12] vhost: remove vhost_work_queue
Date:   Mon,  6 Dec 2021 20:51:14 -0600
Message-Id: <20211207025117.23551-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2589c4c6-8f31-4f1c-2ec1-08d9b92c7820
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347D0F8715F87ABE1EF76EAF16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6bFa4kHRAWek9x9G/9tJqiLU0f3CV2bcKReURGt7eetvHvftlfmAnD3dUL4dwzRGKPp4B2rM3S9CN2TJJzrs2DbrkhzQTagzyitZORL4OQWJmL7+iCGqa839SameY5Ml2oIgsuZJCi9+0F6xI4jIfBZDa5l0Eobsx3bGvqqJPapdic5Z+uHnsmfkoyPrzVwnWes4r86FXm9+CjImtUJJHee4oajHkM+UVct9GAivmx6oAq1/d8moFVoRJWeWBWgfTlgYCEfIhr9K29+dth4Z/gQFkjfpTC5kWUik371KKUwEK6JhD60yf5lTlvdI+5M/wEcIQ4AEtco0sUyORhi6R/jRtroKylCNQ3KCiXydgWbiH4+UFasopaFHC6hp/UbOiFJXsRL/5Yd0UYkSls/cZ/3E1eVJcOtWq4UG76AdCM3Fx94uX3/+KXfWjPX0tARrYipELmxbX4p9Xg+slVB91Ib4qFF7VsSaTjBRCioYUpORrnCXHqf8i/j6jg/GQ9P8RJXYlgdrF6ondpJCwKeEkWSUw34fzTBbRZMIHqFuHa3vIfJVuI5Qdqbk6J1zunWlRQe1Up+phx1uKyGLgItG+FlZ3AVvjwXjSqDxQgDF4r2JyRWGUOCPkRFcT1/RvpXyeidWj3BWMu94fkBJheesXAk00QcS2iJCZU7yM17HHbWMrKkeXCbo7jeE7mWzMKQUni0fT2CW+6Vz+3mYhzy5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9FjvqGzpiabesWKIyAZp6V8n+ypmBUSh7qnvUPrp62fbly7JnNhEScQ70UQu?=
 =?us-ascii?Q?4SonCSTwrfScyT+8KPqXOpfnR6ZL0rDQkSITaia9JHIkt7wAkmlA0nCF8kPN?=
 =?us-ascii?Q?mBVH2k3k9y346nuTpBJf+q968MEK0k5bH75MQgVUHToYTHf2RWQ2E4DXhI4G?=
 =?us-ascii?Q?HW/zI1MwEnO2R+QUTgzO6RRdglaS0ODhhcFokOw78f8a9Vkd3mHOsvrfOnmT?=
 =?us-ascii?Q?mmAxSdEZKf9VfLf8p1tvfrNnI6yGjVBfDiYQM2S20efPK1Kx2jxB2gZT83/c?=
 =?us-ascii?Q?DnwKfDyz6UhOUXw3hbA2vbNuBFMG5xcyENhXqWBdjdkIxwG1TWK3Y41/b6Dz?=
 =?us-ascii?Q?AR4ZZhJX5R1g6VIY33jcHDgtKj3vbhhrucDuvYG+tq1IZZV5GJnHaNwD5TCQ?=
 =?us-ascii?Q?IBBOgt1znzsZw7RVhQaAY7l3xMta6GOleJts+EURBWZXQb6vB9Ty0IQAnNwI?=
 =?us-ascii?Q?UNNUepnfDoMCtlPqOmHVgqtPDgRpKLLiU63gpClnDI2k6Q1hQRAQYr19sMNg?=
 =?us-ascii?Q?9O1K2jAPdpVA5jREop4LbP7wHF2xZ/b0xSdU7Ng9DPmnMSwHt0Pe//IYrO0f?=
 =?us-ascii?Q?aqTsIgT6QCK/oYNQ1FLCRtcnO/n3zbEKL2AoGKe7f5xOWrPGtoGjbvFff39M?=
 =?us-ascii?Q?ZXaQXQ+yCvFbcvJjjnh01PrPjXgKsc3UhuFcC1AoW2Jh6BgltpMbumAXWNSU?=
 =?us-ascii?Q?RwtbWz6CouFSCFC0abvoLOmSHx2yssMJ4iaxdhYv3TH/eufNWEgBV9c+7ceN?=
 =?us-ascii?Q?SATdMLX76SEWWhLWU2a50/6gnWwsv7wR7FIpUrx1grgl1jfuS1vJyF4BvFtT?=
 =?us-ascii?Q?+KgNKV5m4d8eGzpyNt2eVPuHdjIBARedNmTX5RGjkv8NnzE97PGiy2132t8t?=
 =?us-ascii?Q?RkUpLzPeB0iZc6naFPfRCNJk3zAuY7Ln96ERImQh4siC/GYwMk326jZFgKUX?=
 =?us-ascii?Q?eah3tQf2kIvJCMFJcUtBeV/H/hA+bytUGHKW8tgxAuxTBlrl1zZhinNZUep4?=
 =?us-ascii?Q?qjoOlDtYASUpIXR55qh/ABbB+15U8cJQo2pIlGTbfLq0k129DfttcKh+KhwJ?=
 =?us-ascii?Q?9/oPsWozdF4G0+xQ63E0JKeTm7J8ZMOVXkNQBYk1f3C2COhzRnLDD6Kdwv1A?=
 =?us-ascii?Q?gAIimuY5WnMRmEbBIrx5PAKgbQWYOeI4LltLUGepArj0wqFhP+Phy41J4Z4+?=
 =?us-ascii?Q?fcXsRYsbcnYhjJpF9RqrJPK2qjn+5YlvUvB6LftCiJ82iokneg1Cch6WJ9VZ?=
 =?us-ascii?Q?x9CZDMiODQr0wLPUGKTdNUXpSe4EoID0e8EwLTzZiYIdr4hEP/Qv/jyaWgSk?=
 =?us-ascii?Q?yFr4DsA/ZMvF+/2tnhTbx6e1N3n07R94Hc9Hwk1XcKPF7Y3+07/3zw6aFH4V?=
 =?us-ascii?Q?Yw+SFXEd1scaOekoT6q/uBleJUmi4A1MepuCPVlO697qd52ql/TP9A5Qnyh2?=
 =?us-ascii?Q?MMQdJsIFkXXQOeyNX0EMoCDszQQ3CpQ3kDmZ8/uI85Ml16SmiSLAnEmKmyj5?=
 =?us-ascii?Q?d01hjk1PjeZyILI3N4WbuALI6dEyfFGGAHzEVFV+AXmYmlWNh8gk52QZdpb3?=
 =?us-ascii?Q?JqvsuUAJoXhBjZFF+d+jTSNJp5SYRkK1uKtXD94/ghzGXmEqX06FCu/gooSS?=
 =?us-ascii?Q?QZayFYu0Mo0eeh0zMOrXbEPdAdsgenOZdQVP0SE3/au3dPOcbAI8tWeE7RrJ?=
 =?us-ascii?Q?SRHfbA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2589c4c6-8f31-4f1c-2ec1-08d9b92c7820
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:29.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AZnRSe9Ob59ERgXjDh3a2CsEYMLuJns/1HXGiZtocoVXNGmZ+HaAgRxmgHqS14fWvuVA2J9Qa84fTrarLjKKm9ja03S1f4nT8Bfvtgs8Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: -QOCfylhPAFnhSkrI9I3bcgtOfb4SKAH
X-Proofpoint-ORIG-GUID: -QOCfylhPAFnhSkrI9I3bcgtOfb4SKAH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost_work_queue is no longer used. Each driver is using the poll or vq
based queueing, so remove vhost_work_queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 6 ------
 drivers/vhost/vhost.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e9f78f0d72cb..050b8007db8b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -262,12 +262,6 @@ static void vhost_work_flush_on(struct vhost_worker *worker)
 	wait_for_completion(&flush.wait_event);
 }
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
-{
-	vhost_work_queue_on(dev->worker, work);
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
-
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
 	vhost_work_queue_on(vq->worker, work);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 58032429bd05..4423b2420c90 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev,
-- 
2.25.1

