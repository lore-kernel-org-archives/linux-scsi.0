Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9409BC4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8FF61157
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhKDTIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35644 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhKDTIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IXJJx027064;
        Thu, 4 Nov 2021 19:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2ALhmznvgKCqZqdwocieI5s5BoZZTfqEGdJWV86lc6I=;
 b=v0vOpGLANSTK37k3Vvwr0vSHVDCo97p/07iolvATXO9fIlc+G7GLtBDPSHVxwKhy6Kxl
 9tqgQl5xZ6IsopMR9I1rdDOA9lvhg1592NprBZEBOfjv+Wc9rYaURrPCXHDGjoMlS6fm
 aU07NkrGvNku0mqgF4HDdxu+c3OeF7o6b+uD/9cN1HWu7uDROm3AQDXosFiKbnfb4BPz
 DZN4psrE6UrGtd7qrA6FiCMVEoBf/yX1gFziL/L1YM+BiyWSyQsptoDe/gSe3J7Bcp4F
 ttID8ozcOPqXUWeexS98rXJ8lKjq5LeaO6QUhKkHfmfdmVoKVQdOXHml/fjrmODyyHFp 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxham5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIm122897;
        Thu, 4 Nov 2021 19:05:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCyId2Xa5+i8y/J71g6kp52RZzTxSQwKST//y+v+3D0VmeZuFCeAWSk9TFq7cRZWMyMeivSwpb4Rrmhajblt9Arnlb0SVq7w4BoEEBzbXeUpwyYKlgphKJtAfME5cKuZHWYAn/fJi+Stwp7pIM1Wo9jzLC1NtT1/IjtvQvo4ljmFt7EC1owh9+YRN45cRS684jSZZC2RkPvFkAFrnTl8PQWDmCbfahMikeRIZwbnJyW4CDjQmlxjjElGYhRK4r2RbF0ovrg4023mDT8wx7eZ1sCMthhueBVAZFoE1JNpu3syUGl8n2qoOSkV5aT+MsqiBpLDe4jZr/XuZMOsHOlJjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ALhmznvgKCqZqdwocieI5s5BoZZTfqEGdJWV86lc6I=;
 b=QetJvnlOr6N3s+CGqKSk3oCW+HZDnMBo4DmaWauosnCUdoEvBLQR+GnmmpJv4Th10BsNzcBKqA3V0T9HnmqxrdGtfQXySuRhKPwZaFlKZEGIUl/PdwAL+KRU1hMSZlQ16UIUH0ghPrUX6mGOhKO633W59LvyCnmlcdSdQmICDt+qTKIk/TGXGiYK7OaORgOJozMi8LHltvfzuXfJLiK5aTu4dl+4RAP6hJPGZ2tlgxNe7sUSXg8qJAkhhYuT0khAGBt4B73LcmgR3xKXsuaDbniVjCf5AadeF2jlZ7BU7MM+lQpT88SVj6iKTRsACmPZJjDKjMrl5pLyv7ipMMlXRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ALhmznvgKCqZqdwocieI5s5BoZZTfqEGdJWV86lc6I=;
 b=zON/9s5vC7bG4GCjNO3ILPH+uF25RTJC2uQk9eTLcKiAlVYzYkVsOpS4eNBt5oPdKetLH3mXyu4nJ/EjGXrgNvHToJ5eQNZJFEelQYOpN5kUGqrFuMEsp4XKbeg6s0areuxDP94zv5KH0NtY063Je9l70+5lhHEuB5ZBHC0TcNM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 09/12] vhost-scsi: flush IO vqs then send TMF rsp
Date:   Thu,  4 Nov 2021 14:04:59 -0500
Message-Id: <20211104190502.7053-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104190502.7053-1-michael.christie@oracle.com>
References: <20211104190502.7053-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:4:ad::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0080.namprd07.prod.outlook.com (2603:10b6:4:ad::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 19:05:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5421532d-ab13-4084-fcfb-08d99fc60859
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873338509A29934484B457CF18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbBkrHddWHTTEH+IiIt90r1WQqxC08p+ofkohQVeRLxbWdvIuA0kCwjUjxxd1ricM2ob7RwVKCYw+jDdvitiOIKn/wWHhy++QvLLQ4jtcx02k1fJToblEfY0DxDNfkl7l/j9CbEe8nrGMtTAknSKL1eUHwXuPSRmH0f/ds8fkBKIuPVQF+jY9R66YDGioNr5l42Lll/sXzm2r/v7MmCG0Af6XnQ7vtQNVBekTeCA0p34PosdIbpEpKR6HBYat4j+KE3FIQYPwvyilNMnFkubAsS6fBlirIvSZxjUVuvRH5rINI35PqplNcL+R8HdoKckbX6tO0DF9YaIdu0PTGwxozka4FKFcwYoJkeTaG5i0PpfH9bkfGxljWD1vvzQUtg7Fus+j7Fgfv3gFj1hgBZe0qymua5gPFXIDfVdziPpNah21TxDGMejVMT1N0ah68CyuNh9ItVhlaBI5ySJwKrYy4UdNNfluCkFtpOdwdw6OW5VgwH9siwi5/1ncHKhs2tLR+lXgYVbAjANKOS1Zv2gvACpIMQ4xFUJxC5oCEdBXnxqNzS3+ar2PYCGLT83ZxhfoLfGEOsKS7VCudW1bmXpHwsybu5xHs3sFrHt5sAw/+34Qdipi2OWg2mTnCmglocNh4t+RHkgbtp17KmVsZEMbE14U/33W7bn6N24nWNFGCxersQ1e1roZt70R7Mm8v27p4LfTjIlXm7OyNeahxkdSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?07Q6WyegPsg3VklUtWSLCRCYtkNQ7waVnuh4NlkkxlfthkAdWOzLJrv6hMag?=
 =?us-ascii?Q?ZQEGt1hy5hW4lKbH7BYKmJx1egEVNfzpJ/lEOsHDlHZJfbl444ALMM7VekAD?=
 =?us-ascii?Q?GY2REu64NuCR7uOVkfJZ2i5G7Vr3LMCwLHgayEGZOQwyo7aHdDwLvEUpRDwP?=
 =?us-ascii?Q?IyFQSprsESySJVyJOKQpoWiSlz46UcJUBKbIQRxyg7s5d+TIRh3+peJFra1L?=
 =?us-ascii?Q?on31Es0E/kJ5I+kBzeEO7vI3eqDC3j5xYAd151i0yqj1TTZri/uudhWWXqAl?=
 =?us-ascii?Q?v7+Xf7dYHr2/eqso7+gzEEYPzgMLwE2gjUHqv9HwhSXN+nALhJeOBY5LwkfL?=
 =?us-ascii?Q?fQs5vauAOZGn4R6A47vSq/2dngeai2YjlPz8gZFjxn1/W/ZHY2dsR3HqfSml?=
 =?us-ascii?Q?R/cRj2i3wrClgvB3IwUDQBHappr8dwT9QNMjJVOM+gmE7cZiB4MTB3I6m9Ko?=
 =?us-ascii?Q?FO6IWXDw/dhfnlcM05ql1Wk+IZYXOyE4RR92YmDbIVtyrHlQuY7ZNvYrKI0U?=
 =?us-ascii?Q?9tGE+siPY0KrpLNqG1rBt6tzdHqkAocjtXyM7FJEbnKTaDQT9+QfKc4K579o?=
 =?us-ascii?Q?DQqU8KEBGhsUNuT9ZU2SLYrWajaIGYUeSJ5GQ00yhbOh8R/KSeg1iQSbtaFB?=
 =?us-ascii?Q?PbjV6xjPvGTPFQYxD8Yckt05SP55o+K353R0bPcS7HoB5f5c5qEYUEkdEiEc?=
 =?us-ascii?Q?Ou/An1AjLFZLw2SiHIk/1RD8yv8zl8d6jyWon5hoxnYLqRYyj+bW6+C73dYx?=
 =?us-ascii?Q?R/NGKg/2Q9kapLFlsUNSnF9nEf2K/WsOuDOQXuNHn0q7Fp4ieBo/drGQsBiP?=
 =?us-ascii?Q?7N5VreEl/JY4/RB9Oq78kKQfz9WitY0IMFGXFcym6hzC8ZcUr/JWRNvgkDEg?=
 =?us-ascii?Q?PXSiiL2ifiZBMVss0+0d5MOCDO+JNGoyEGZC+UjAFW3QX7ATY0uNJuH3nP0m?=
 =?us-ascii?Q?K7Yjxp5VU16P8oFWEzApQ5CVdeO+O5alM0Zvv3T74QR3FdRzXqpxtZGIa1jK?=
 =?us-ascii?Q?PBD5lE1ycNyQ9AFhNB2+HuiSS0kwtg5tiCFrsR/1rgQHLhEu3IFfJ6jCxLqL?=
 =?us-ascii?Q?srqdeKGuw0gNxhNKrUPVFaXq/rOcVCLqNSDuDZy1nN19obTM/CnrYTjMCCjm?=
 =?us-ascii?Q?G3h28kk62vAkC/Y4T2lGp7CLXZqoGsShzLVRXV21ySAqr+1rcjw86YYOqNef?=
 =?us-ascii?Q?58SzK6ugKrizmM+8OSPtaccJsPE0yLw0qPqUgFxgz1dOe5suVvZAvtbPn0Yc?=
 =?us-ascii?Q?Wi4yiGbVskdf5pRa29HMfcXiNvZzoV1RTpGah7IgKPPoLTE7kuu2m2MQAXre?=
 =?us-ascii?Q?Y7rL3joJ38Yrl78Ehr81XpEtp8L9agiVcgWJW6wROFyY8tSzNF5AA8+hdRzM?=
 =?us-ascii?Q?zX3vPhmODP5bSglgrwgsL13t6/3GjmI2uIGi1J1rV3N1o4NsiMyZNFtYH7PE?=
 =?us-ascii?Q?cs1cZ0Aj4lpep3L5zdZ7NZ7dmQjnBb4LMa79lQ8Z2XRuAwe5xyh2wkwC4xDW?=
 =?us-ascii?Q?EHLER7M3sXlNwRD3cY266gIsPEnYv+3emQy5r2Tir1fd1bF/LSd2KMzZeoin?=
 =?us-ascii?Q?i7tS6fmHJ4rMdkDeAh7Qyp2QJETI2XrZIxTiKQGQDD+y0vKPaq+pP4fBvljB?=
 =?us-ascii?Q?Zd5ZmPG0ilwLCckreaKHoTtuGsLQWnUvBHUCAaTAgNrjwvOS/YFkOoUnJNfH?=
 =?us-ascii?Q?JlWllQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5421532d-ab13-4084-fcfb-08d99fc60859
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:14.3381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtfczlmBUpTEEiRu8lekULNyCeHKeJo5FXlEsIEHYiG479+jqq50l4IMGoUdoWalga62n0eSz1prXs95P4GtnZhoKOi4i4zIrqA+E1nOaIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: CC3Hy-Oq5Zh9FKqzKEVQePELTBOBio2k
X-Proofpoint-GUID: CC3Hy-Oq5Zh9FKqzKEVQePELTBOBio2k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first then call
into us to send the TMF response.

With multiple workers, one of the IO vq threads could be run after the
TMF is queued, so this has us flush the IO vqs that don't share a woker
with the CTL vq (the vq that handles TMFs) before sending the TMF
response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 08beba73ada4..29d9adcdb4fc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1153,12 +1153,28 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 {
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
-	int resp_code;
+	struct vhost_virtqueue *ctl_vq, *vq;
+	int resp_code, i;
+
+	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE) {
+		/*
+		 * Flush IO vqs that don't share a worker with the ctl to make
+		 * sure they have sent their responses before us.
+		 */
+		ctl_vq = &tmf->vhost->vqs[VHOST_SCSI_VQ_CTL].vq;
+		for (i = VHOST_SCSI_VQ_IO; i < tmf->vhost->dev.nvqs; i++) {
+			vq = &tmf->vhost->vqs[i].vq;
+
+			if (vhost_vq_is_setup(vq) &&
+			    vq->worker != ctl_vq->worker) {
+				vhost_vq_work_flush(vq);
+			}
+		}
 
-	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
-- 
2.25.1

