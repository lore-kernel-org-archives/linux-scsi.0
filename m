Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB52C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1D36121F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhKDTIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25358 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234229AbhKDTH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:07:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IUwVi027083;
        Thu, 4 Nov 2021 19:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=OrkPI4MhsQM67hfASN6C5o4EmTy2q/sxoKStttwFsgIQCnZYWd3i3MhvSbWOwU5cWpTQ
 3Ri2J1v/C41JBRZCGTioheXzLB32uP2rCt8SZMIGR7qXCv0v+ePWWuHjw4LHKhpaaTr8
 4Ig17G5iAaoKkiBQp3M6KKSa2dApF7R+DDVzFe3adMSWAwl4a9lGoz/YkgueSG07dgIu
 Fbivyo16YRMoy6bZ52DRf0Rq/RViA1kueXP598B0laV8lyELP11EEolYESJisaqK6kX6
 Biz0Scdn8tNOs931egG6d+oxLjjt4uP0hcdgvVjjYLnfQxUkTVEWBTHj3iLMLVukOhI6 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxham50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIg122897;
        Thu, 4 Nov 2021 19:05:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeJXVSvmv1h4A1+g5eOyTkVTLw2ZVTwJfGAtzSwk4+A2yy7lVQ6D5ISZVi3IFjbhiW6TXontDoIoyCJgiGq++zZDVgiOmnoLI5ScdkeJEJ0uATaWk5+a/6HElLFpgPlIOwi8zEvP6k29DMU749Y+esHpykTq7ukpVthpxRjHTGeGvrHzQqt7jJPDSCsrFMk/Oozqc+Vdhr6cvT6n9MplAnsdA4SRQ5xnxhjTsRonQLrTIj1FNR1Jw7bWlXGtyF7yUP8MA9xAbP0TpJP7pOFqzkSG6UjRLo3NX+x+z+P5qst5t/Ung25XYM7ImeDIcHV1vUj6J6tfRnttwzvvK9dMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=XW5UgIgLacSnXgGvjH06wdxnR2C9MvFjbcNRrFM3KaJufpqz0NkzMkCTSeF2N8jy+IcJvQwMA6CnGMxpRMAFghBcE2G4Agp4krvsCdppW22yvn1AElDktKjLYiMroHWi5PAm3h3p9/JV+vQ6Wv7MS/9jLWzUDsjMYBsMNoQ9oJ8ri0fHa78phqnjUyGpaH+SGNjAtf+e/mnXUrgPVw66mEI0T0d/YioHObDK4MswTIOVlFfgwhgYQxhq5PmMB9a5roB0uK9w7RkBQ9QUzKSmbvXs+s6S0gRS7yXmwe93yZwZC2IHWCIH06jeR6ggoS2MW95Iz0Qg/6dHY5SHM5S7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D40tPvmKWcALQ529N71eSOpOGZt4d+MRa6Xymi5OU3A=;
 b=R+2QrNjS9M2BgxWIoIfA9Yyxn2G0cG3gR28Y35ZnTz6/b8SKAVuXwgW4FHromWXN5EKmSp3T8lO7SBmGSgWA7wBRAboULjZvxAeFcdbmC2G0P9RZ9aSNFtcs1KW6L9Tys1pW/9HJ9k98uhiF3nVs5KzISEh9irgHv+ahVfUIGdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 04/12] vhost: take worker or vq instead of dev for flushing
Date:   Thu,  4 Nov 2021 14:04:54 -0500
Message-Id: <20211104190502.7053-5-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 25fb686c-6472-4711-c2c8-08d99fc606cb
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873EBF1BD5DDDE578602EE5F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/Xx+XSPMzHevw8vFVEBf21ybY0w7Vff+pp8BVAuOydKm6aCWHqhXggUwx5sXoLSsNMcZ6tIIxp5K6H12M1GaolxRZog1CO20W//GQbY8vj6DmS7n2rSvVbp3wqaTGZCfJcimlVe/yipmf2er6ClglPmwUJBv73jMVBurtL3JgZcC88epWj+aOEghZBDDbq5ZIT0I+tuboLHvOQGYzOq0aPs+zg83Sk1s2T9lX/TijRYdLvVa2TZfuuOe1XuH1n023C8t05Ugf9IDtkt+lLqfXlpX2OY8iQNu2eFO4cER9hIoV0qA/fN1jv+1tywwXSC7oL1uDrdF4tsPrvng9yKZpeQuZ+C2sAwiPtggDuxqGLCb8RizbHMURYE6CdLFS3pB3JYACxGFJRtT2n1wx2Owl+OaRshc4/S3CT5jeod8s7tfCIFTnXVa8FJbbbcEr2V3UAv16NPDG1AGZCWpYJWO28+js1oyUaLbg+oIdEp6o685VGbugPnBzKbXbUQY1Zd0q6M5Tk1NSHi98Ng1SkVJ/izwK9DLAASxAOKdYvD5oWPqjfrhEPBXNW0tWHPhtD0NXvtKblsB02HgTLwpToinSNTZKyeipET7eGiVBhQbYT4wzdaXxdUSugIorvsjrRbK1n26sfoXC2x/yltt1IJkEkT5hQ70onJU9EaH4I18bsxc8/U4Xu+og2Oy5UEdoK+96VCxov9A08IBNl6vIABLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oKsib+yg57l3w04qIlcBY+2q5/PIqEGwm9eT2YBeWk3bds98fvErNIySD023?=
 =?us-ascii?Q?wgTwyWSVJ4w9elql7jPWVj67v1jB1YydnbCJD1InexxO/FjWFVCjtEx9YGMX?=
 =?us-ascii?Q?onH2vFHdUfg16YO/29s1D2xEUcw3GoHvqjZAa+7f7TQNOTXdig53OXqTNlri?=
 =?us-ascii?Q?wmUcxO6RZtH9vYXm0uYJsjfj04YoxxsWyRuHp8l8SFYnyeShFA1xcDaBTkXk?=
 =?us-ascii?Q?61qSAkUi8+IWnvZi0Mfu/V8ea8/COKluxnWALSuTBIK61dpLM1ucA4MFnHYw?=
 =?us-ascii?Q?JBI7K7qs+AWN/d4hBic/fq3dkxusPY5mAdWjZkEtL3W+xMVUz36wugfPaRm1?=
 =?us-ascii?Q?YZciHLd/IXEbngguF4iZONSBqj9YArhhsCWVWYkTP3KCsMudUPPh5zPC5iOn?=
 =?us-ascii?Q?UiddtSHq+OgP8bUMYg5UH6f+1CjdCbc4q7ixMP0Bzv2T9lCCSijlHou8YP0C?=
 =?us-ascii?Q?oXNpIzYXrehK+lcVfpdGCfCVsdTW18pb38WKC/vdjBVHSGhSvxMck6XrlTu+?=
 =?us-ascii?Q?CSZmVMqI/I6MnfpJf62tewA0GtDlHNegE2Jfo+oC9FDXDw5hFEN5f553mYhM?=
 =?us-ascii?Q?F8jRzUsT5ZybuLmiX+d2oEhflHFNadwmOLo3o+Dd8/X5oqYOYw4AUr++SF9D?=
 =?us-ascii?Q?xXKzL5MSzakgoeh1wHuBF0zRlnHGtl8JONi7588bwp9GQWFj0r5r+58Voi6e?=
 =?us-ascii?Q?SEZ3rCp+Od5vzX+xRYp4D6JsvqZaiMbbP2A1Oq4fwrrGJEo6lVvVarI8Zoyg?=
 =?us-ascii?Q?mJnqTauCWkPH3JtnC3L62qiuudme8CXQrxQ8wckMVdqMnivBUHi6PUgSYlGl?=
 =?us-ascii?Q?ACYF+pX6B+j4s0Nwy3HF9Apbcsfr7AjRZVJDlfLEdvhzQx2bKRTj3tfisqpY?=
 =?us-ascii?Q?ACazWBMmQTkhX/GABkbJPuLPea8I+TF8NyBo/9aSwDPyiouJYG1nn33L4j/e?=
 =?us-ascii?Q?zBNonRgidKHYOgEAtV87LDfaErhhke16iR85JJyIrAJaKKSmfQ4a7PoOy+l3?=
 =?us-ascii?Q?/FVi+4wmaTo3k1P5i0wObu9sISMar8E8BuVtu1dy3CIjhS1rMRa6MLqnC+fV?=
 =?us-ascii?Q?xbR5e/nH/Ix/vicDEhsF2UbWyP5Af15Bowt1jMULD2mwaLplXO5EpnlP8Ppc?=
 =?us-ascii?Q?P9ptxZgc3jZAsTRRk8HFVr81i53H/YACIVdvxMXa0Qj2FN4AhMc0AwbpdK1t?=
 =?us-ascii?Q?lIXwy5S9dIzoDvPuZsyFsZbsfH6Bnqe2k7CsqaYY/6vtTIJLkxVqAlj1GMbe?=
 =?us-ascii?Q?KMajpWs8YTL7z3tzPKJkk+EeqinUX9oe/6YUN3VCXmRlY1nt+cDHVLg0/wd7?=
 =?us-ascii?Q?Duy6ULQoAjChKpJLF6SsS0dw7YR+QisrIUEW/4zzcFA9TmKvB0epWLZlmD+n?=
 =?us-ascii?Q?tHWziRizFwP+kz6TPF0EIAtRYBqY2rsJEUTcqcE45QmUU7iJxIwzD4ZGe4AE?=
 =?us-ascii?Q?gpvAGOTub939LLKqyvn7BR9vm33HeE1794dDKqyFKLZXjb58YrLqJVqcAFET?=
 =?us-ascii?Q?2vya+n/ah8+Kf3uaK42bl7FjQbcEc8IwhsEZaE4b2Q4p9cnrhMGCXQJhGEKR?=
 =?us-ascii?Q?iIA9Cz0RN4E3t3BECreP/m14KEXv7ozLKDqg9Mob6+7+fB298fXB2dZ+gFlX?=
 =?us-ascii?Q?NgmwL4WcjWuZO2UQ/4aw9J43WggXmIO29SbgCpkR4kadKf/2amlb+8tmaUfd?=
 =?us-ascii?Q?petSeQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25fb686c-6472-4711-c2c8-08d99fc606cb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:11.7663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmW3Mi50GVq3prURqQoPEjydjuZyXxvHoYtrGIJls+E/5oTSf/5feSZJoqiKXsTaqoXc3Ba6VFHG+ki4UmUys0/Dxfsbk7TGntGHFRn9CQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: MI4MhI_4MSpxUf09a1DeD3jQefZWr1Jx
X-Proofpoint-GUID: MI4MhI_4MSpxUf09a1DeD3jQefZWr1Jx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the core work flush function take a worker for when we
support multiple workers. It also adds a helper that takes a vq during
flushing so modules can control which vq/worker to flush.

This temp leaves vhost_work_dev_flush. It will be removed when the drivers
are converted in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 30 +++++++++++++++++++++---------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f2c6981297d0..e4d765f6c821 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -246,6 +246,26 @@ static void vhost_work_queue_on(struct vhost_worker *worker,
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
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	vhost_work_flush_on(vq->worker);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	vhost_work_queue_on(dev->worker, work);
@@ -260,15 +280,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
 
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
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8f209d1c8890..a985caa35633 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -199,6 +199,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
-- 
2.25.1

