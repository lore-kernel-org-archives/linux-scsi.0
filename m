Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413E9C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE9E61157
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhKDTIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36180 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234253AbhKDTIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IRGe4027061;
        Thu, 4 Nov 2021 19:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=uwnZVkIi3RNwZdvitKIv3W6jvwZ5tXaLAOhG0em686hNtFbqptZ0bn4gkF46cRSX31H0
 Wh6GVP/Q7o6mSHKYIsHmUPG+DCqTo2yHFmsVPDtCTWr09QRdNKaASe2RMldX2Trk7Zf9
 KThUNZaNwCQQybyUWH5+HXFy1B5dhiPBy5D24qUFzzRIeweWKXcUDl/9U5aESg1ysPr2
 MLmjMR31wKi6ongIpWx1ntOGeEq1wmcYQI6k31+SOeOHWKZWL9LD2erw+GyDwyJHVG6/
 oN4orMYn1HUKOzECITrKU9qRt/fIsZxHnxZDZ8OMWpzindWJF5BIWH95Jh6fmqV9/rYO +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxham67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIn122897;
        Thu, 4 Nov 2021 19:05:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlYKSUC5L6kWtywa9vHYaPWHFIgvmtHxGg6+XChIAnrIuY5A6elC9RBJx+O6pcat2Y/Qml4TWNAFOXcDL3Cphl5n3O4bHdZYsEqiIT8up8rPJLkJP9X7nDCHzuwm8RhRIsE9mJ+r6BtPzjruNBHWBxTri/aN3r+i2xOF4Di5tsZyryIf+U14rGt59Sw2lizEcnmy+WYG6W9d3T+8U3xpp7I4/IfXK4yoGNDl7kDac6keGSS45nox6r1hYxdFB4j3Oi5mTG73A1iqig6FxTHCHJUNxj7eXx1S/cA01BNdaZ93wsHDrOJE31IcrB1fZgztTmMTgLCmUnVxwUS/LJ5prQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=BLy4K3yLrUR48Qs8TRr+dG3j1GVoPARg68DgKBd34frm8dJYzxhxU7aKQHWcJLB0As/YZszWOfezIIcWAMKp9PmfnGv+Ys4YQ8ZNQiDRyxoz42zQPPbNN8hTqMw030E1uHn3u1Oj9V8IgoyVyZru5kK9vo72/Ksv4SXl3J9rNTEW/vUnd119kr+b6Q2Q6pV5knZgO709us/dWuOsrvt3a+x9e2+sk7c5693x4pjNVNTkayu8sRBGzi0/bzh/aibOmzYfpNqep/WGyfMWNTYpm83+zSr51ZUhvVY6BxsEEm+/tn75J1pMpGz8jOnk8AEQd/cGVRjtnEhDWamlRD3YYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fspmCOXmEpt+I2Zli2AQcYiLadL+u7tR5vrwNrLtu8w=;
 b=xb2p7TkMQZEPayJrvUsqXaFT3QcBkJn3nsU7j6bJj3H7DONYVmrWRGBs1yg4hfttLH03v5vu48OEw10td5jT1VNhyTHmL6W4y7Kd+HaNmvHZhXGjp/PSic72hWN9oOT7Jg3fHEYd8ggiHxKhFGdmUZxL/wQ+vXmO67WtGpMbqmE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 10/12] vhost: remove device wide queu/flushing helpers
Date:   Thu,  4 Nov 2021 14:05:00 -0500
Message-Id: <20211104190502.7053-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0318f15-a271-48aa-0f8d-08d99fc608aa
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB28733109F401FD162AE02815F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHSxI3i/kjPL4UNkYJ9+xVavnv/UPFmQW495mJZiTL+9TWTnOaU5cwGv8Y8xuzZMbqVNcUvaRinz0lebb8Nu05zt98ILa/afAhYfgV74KQF8ZfOovjyZiSRTwCzwoAn5cXA5pEJfqW8SiEEBEj54W2DKxfLGg+9JxYpt7JZT0zfWjUkjyFBrCXziB1nWhE7TLe6B5cX0T8rQmAy0CzMfZG3XxQh8e6c857W4DklqHk+5Pm54AWmxauukXnzInG3vx0t1Y9YDvLGFSdDpZjYD2NUaNl9P81gVYCAdYiM5sNLAo4M+i2Ic1brIB31dr/hnHr8sgpyFWGzaqE51latzcP6dNJNA5z6NOXC1vY+R0nYI7jiaPoG8efx6p7WGz6XKNtUchTc8EJ7bvm3OVwpI70ETTfT0mI+36W6hF/A9V4uDUHhET67XLF7TGkYBT7bvqWjq/CM7TpW56Ju2P4DFvMFtMJDwMlcIfvk9SQ8IhaMEQ1qPgrwflQEDSUn+04MJhI+Fs8x+/i0gQd5rMxfYD1LOlHlxQhpBWN2mEqstUH6bpVgzteiKcp2QTG51L1657jsG5tzDWc/8a8VgYcHoklbWe4q4SLm9Khf8zwu6X4bDFhcUJoq5RQdwUDQNMYueQTNKygyQnyYbzXd+Ed0XLGK17AHD+m0ya8p8ehfrQ1rAp+U0UrIIyw0woeIkCEUh4iV0Idxgd+3ArE+1VSVl2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pi2sMSwqtPcndXiOSN1rB7F9BTILQS1lmy17xR6tHkxBt56nOFH3COtlOBUz?=
 =?us-ascii?Q?QAFJxrUOAK67l80MR3tjy7PKXGLJ3pxtK0ecHkKeOt3Onmch5rI4Ox88RIoz?=
 =?us-ascii?Q?0V8icRDS5eAfwnRN9tu5qAFS0fL3GmlPLoa9KvvT+S39fyYidHqVjToV/eBm?=
 =?us-ascii?Q?CxX5FwLzI6cp6WSCNVtHn6GfouH4VBGgsD7CPAu4T893NQJHp3MaCNCo+LTv?=
 =?us-ascii?Q?Dj0cPZlR3OEGDhzRDc+ax8a3gJ4kvDUgnIOuste+GASmM9wXAJooAj0bTulE?=
 =?us-ascii?Q?qPQbcZmvgIJjXEjHu5AJGk0OQxCU8VxfuCVBtXaxcajGITb+UGCcToVq1wVs?=
 =?us-ascii?Q?XPEMvl93Uzo41RTbzP0hHqmKcUtn19zNTvOVkbrj0Da2DpyoFIxyqyoS/l11?=
 =?us-ascii?Q?rRqZcHc6TuMNJphk5ucN76zvUtw+Rekvpr/JX9ErscP+KPi2E73RO7td+ivL?=
 =?us-ascii?Q?iFTtNp/LNqfrV6Lx3BniyWdGNdKUtTWxWNS0TCLXrBENY1Xna716OOgFqgIX?=
 =?us-ascii?Q?fhNzCtq6au9o8pYzMmOzcLv1cagAAarFu7km2WxnzQK64YY18eCQb/cC62SC?=
 =?us-ascii?Q?xvl+ZzC010DiVjhf3HslbGHzFGB/Xf4VXhS6NhdsW3OrUqwmH3nM4Z94+LX9?=
 =?us-ascii?Q?wgfbSL7gyeIh6Y/Fr/RKpwC1Xz1Z8b8rb0ch39LhD6hqMObrBz1RnOwYHdy6?=
 =?us-ascii?Q?oFq8dnheYFY77JzgYEXHiHEnvTcjkLy33ABajwHe6peiF6H9mKLhdN5+u/QR?=
 =?us-ascii?Q?fQjMfiL8I6vZBhiyJTgsCKLunEJjX5wKAhGptz9gI8N6B3+HZwLAZfA1GPm9?=
 =?us-ascii?Q?HGEfNl4OY/oW0jZbqjgQEHnWEbEiIWvnTnMbX4jG24mGhZBd6VDVhMF95arV?=
 =?us-ascii?Q?nMpxkIELci3Erq377YCTDRU5epASNCXcN7M1ch0hCwp3WMzUfc2Gg/advCPh?=
 =?us-ascii?Q?go499VvuVimysoySlbSmYw2MJaXfPqCEHEE+q+yAHD4+clqBW36CZgd99plx?=
 =?us-ascii?Q?xs05OiJvcrsddcigd3bn02uEIhnAkhkP2EiNyBahsO4aZoeCSLCOoLhjS1fF?=
 =?us-ascii?Q?SE6WS1IjiR/vyGWV+Ma0KUgCIUWHgcproBOqIc1ZCGISGkT8gU5Y7EWFi4Ag?=
 =?us-ascii?Q?44u1QCvWZta8p9h1R/AuKODSFQZVmnv9WZV3rxjUMT4TzeWPF0Qr5Dw3At8I?=
 =?us-ascii?Q?h7OxEzH9K/JzMAocszPNwZu6jn9yl9Ie3JApmeni1Nhw8mMc+iE4HVao5ZYY?=
 =?us-ascii?Q?BA/hCnmdbNU8+lIxNfISFM+Va2uz2/y+5FMtJ0du+nNEkr4qQdb0pKIc5GaH?=
 =?us-ascii?Q?alu4Leb7KuuW7+4fXAL5TmB8oVzixzquuUWH6XZPtPOWwEjHz4WcCPYfdBVZ?=
 =?us-ascii?Q?mJC4jwbPHADXeIXPdZcEV9aEM5uf72nBNvqmFPXiY/lCwt+A7JKbQC9vtYRw?=
 =?us-ascii?Q?2o1ffE2WRNqtqlufSQ3Ug6B/wXBQSMmq6Mj5zWexBumBLBPKjKzZAJhapcxy?=
 =?us-ascii?Q?iXGkp25nOzLAkWQbRiyPOMuKjMN853KAUjo42Uk3V06JqVaTPMHR02MsCwr0?=
 =?us-ascii?Q?8z1wRyeS67Ikl8jJK5u7bVcixiKw3nXUF//hzE6WG/Cik3g1GAy6Q71H687w?=
 =?us-ascii?Q?A4Is8wrLz2OjtMi6GYQ3BuB7pMzqLrsj4EvSZX+yhbBJjksn1rbcOfL4AE8O?=
 =?us-ascii?Q?XGNi0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0318f15-a271-48aa-0f8d-08d99fc608aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:14.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ln9QHhXAEsDB0l8OMaAyXjgzTsX57llg5kAPcSZB6Eo4299x0fN9dVvNMpN85nN4c4A0vO2FRGtrPMqwmyPCdBadmCzMnhbyxSzSXz9YICI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: AZREJikqd3iDhO7EHRtH3pwcC8yECSHc
X-Proofpoint-GUID: AZREJikqd3iDhO7EHRtH3pwcC8yECSHc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

vhost_work_queue and vhost_work_dev_flush are no longer used, so drop
them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 12 ------------
 drivers/vhost/vhost.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c84024afefff..04f43a6445e1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -268,24 +268,12 @@ void vhost_vq_work_flush(struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
 
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
-{
-	vhost_work_queue_on(dev->worker, work);
-}
-EXPORT_SYMBOL_GPL(vhost_work_queue);
-
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
 {
 	vhost_work_queue_on(vq->worker, work);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
-void vhost_work_dev_flush(struct vhost_dev *dev)
-{
-	vhost_work_flush_on(dev->worker);
-}
-EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
-
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9650da2be2c..33c63b24187a 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -50,7 +50,6 @@ struct vhost_poll {
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
-void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev,
@@ -59,7 +58,6 @@ int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
-void vhost_work_dev_flush(struct vhost_dev *dev);
 
 struct vhost_log {
 	u64 addr;
-- 
2.25.1

