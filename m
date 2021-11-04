Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4370C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD16061051
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhKDTIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33068 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234246AbhKDTIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IapaE001625;
        Thu, 4 Nov 2021 19:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=Wfm4GH0nis6ysVyQ/sTi4RJsIbllGKwCRj7u33DAIbwniZyzSr7PgxUaDYlJVBQmsF9N
 NMRxmfb1zIE2vxUqcfsHVopOppl/YE/KvLiImxGetGzYwuPmnI9tcQgPGuHH9FV2NEMI
 vuDUUmp8/SR7EUvQsun/UdC4hG+lmVH8lTltyBXfPLMPoAXnKibHTw+0DgFDOty14pyI
 PMBhKhMDXw2JvJfCbpIZ5wMOmQXFkS95FbYC0YSXUVlno3hEqO8ZQ/PiD8J97eSutEKE
 I8oPHiKr0o7WwFOCR9vye28KQ0TreZJWunOq70t+EGbELTZgH5nhpJQDtVy5gAHfHCRw ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIl122897;
        Thu, 4 Nov 2021 19:05:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMbj35niI5sOFDl2TrF4YfrmZnSApvx2CeLFMSENPsU6D7eVdUd1KNdssThhfpbHbhwbwi5BYyfXk9iVWSCEvCgPUkrxiif0iX9UOJtgnEZwvhcSMTggMuVR0vLTqR/2FHaAtcD8YYj0klCgrS2eaHhrQf5HFREmdwgktAQJC70cN1JZZ8Kmy8KA7TY0T1wBW1kJoGfSM4FoBDl2LG7y8vjWgvRRc/lbXijkZwaBYeBb31e8FiFQeKqCjYCO70c2oftvIEc5UTUZ+mnQcoo6N0pM5XrJnOzSadrGuOLlNU1Rv8FWy5EBd8qB4Q6iopBgQTA7hfTCT0nXRjZ4xQGEhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=I45FxeN40b1vHQ6LMmJ1nvsFaFEw9Nu4cqdV7WJU6Dovgf/QB5ySOU3HXgq4ZRscY+6v38hzm93jC6kou+l0SfsjQeyrXulTym+sa3WQINKJzelDr8ouAf8D2IXS3efu3yl7JTyxz76qby2m6OE3zUnnHPY+3v8URBohAPJaTVJDMSo9VaJxVKZKXUFqzYbjG3a4QWR9NRl+rx3r5+ziihZZNl0qn30Lz7TdlS5rf3Y6ERI6kOJJ5rGS6JCi2cRlGM2+hNRq1YwrLlQDEwVNkNTk2WQ97bEKyomLaYUJK1zIKug2Im8ydn0tC8fV5a5PK4++67TUDjkh6R5u/CEpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGDDUIOqDwyhFnOlbOmNwt4zkp0IVmaJ2y7UYayCi0g=;
 b=zYcYtnvcW6UAyBS+r6U3OKigRcQm0n4QxCjGLAVva8kcZuDkDvkswbYgwFNldX8paaaoifkEgBEr4FNV+IfLgTCs2inmNtTSd9ZqB9/gMAUZimxkdXPUV7F7Gp9jzvXgcJlrtxThvcdBHBBRoA0xunkQ4dIsZyPKDJ7NpeDqcqg=
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
Subject: [PATCH V4 08/12] vhost-scsi: convert to vq helpers
Date:   Thu,  4 Nov 2021 14:04:58 -0500
Message-Id: <20211104190502.7053-9-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6c5f18b4-72a7-448d-0cb1-08d99fc60815
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873FB8D13EB9E6A44047D6BF18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIUANvzNDRcP3T2JRgAKgnE3btkvWcu4jXIETBNQRd0el/3fu8tHVu+ZdkImha918JrE6JUDnIUBtvGocuEuLw3h7ADd/g/he6OuRZaftjUdB6TsqnEfsM0pvpoZWjMjZJb0DMKgb+wLflyaYR/5HW3UlJvdjuXRGpWScQMzbpVKlO33XKsohN5JtIOpEW+ftIt2x4l5oGZLgE+2ok2hhRTCHnRtCAj/cahoHqjSOcdOAzU7EPIuLxNK0lL4iOcBxJ1VLc6xH6jhlcjUhGyK0pQyl8UYb1a8YytZHhBO8UKPd5ZehIRn4YvaX5dWbuF9RnrY5F6MYlymZIzcvAmWGVUbWxPUIqOzqcxuEW4nUuYNGjmNvlsEkd8zKt/RRBHrB1FOmmeYwQ/vh8yUUbT82pwmxdHjdEdVsoRXULkb1y0XysC6FalgsgitAKP3VOqjyOTWcujjAqFRoZV8aJ6+IaguVtc4ko1aEQk/ng54+wLdfr58JWZbpbV2VYYZim1P18NlEo4gioYtG1OzGqB7BjvpODV9hFdsGpdqNqS9xH1DXDRtEi7yKfBVGTLRWpfndqjtruPlgdNGkjZJxm/p/CXcSMCqmzDOG/tgqTqW/562gXeMxuoKCFUOkz6W599Qm8KWHQJxlhwieVScyoCoEP7IKtOPyR+XH9KOua1W9asXGzzPkvaWvYlHOXeVaFiVyWjGBLMWc1X42eDceBAY5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0eVLF2kopHOlZn5bFJ0LHDbJmJfkfyk2e8e73NxBuqj6lUIPMXBiNd3Fzufe?=
 =?us-ascii?Q?RtK5w48wDAMo0Uw+RMJ7p5TZx/Ua3cUMo/1w2HHPcPMHZ5NAPG6KC3lZe8L3?=
 =?us-ascii?Q?RltHPDYwO6U4LZEEhIs3U2WU1LF3yWEK7gDBtgMsAgzl8zx1JSHhj3Od69HN?=
 =?us-ascii?Q?8LSbrcjESGFvIzG26v2L1y3R14XUNRpzzGu1GFFd/soG+JnPdwKOpFWLlSr+?=
 =?us-ascii?Q?bbrqJMNyHdb+QBxuhPkjyLM5JZ8e3D6JPHo9ULlS0Ncvj+5n1lBvG2Yttjmp?=
 =?us-ascii?Q?NVzKrVRQdVbR42XBexSGJIhdcqrtlAocxIcQnSfbn26ssiXyXKn77MKp3G9U?=
 =?us-ascii?Q?vd0ayBJbgLokzwYbVR4fjsJ/xT60KtoovkZvjNWmu1o6xatxUqR2n1PCPkPZ?=
 =?us-ascii?Q?XuTcIWEIy8q56yYskjs0OdnyUdDJGqn9WU9ZkpxxKVcqj/RszjwD235gSsUK?=
 =?us-ascii?Q?zrDKU7sDBffaCLwvOeIRHgYaTh3zMMYMR0cr80/zmS3bX956WRncNGplLxrP?=
 =?us-ascii?Q?af7YKtlBCM+3N2lMWnjSv6+QpiHB0DDuCmZe+mQSgAc22hfm8TDFctxudzhI?=
 =?us-ascii?Q?WozMftz5n8l1M9dpV3Y1yb2KwcSXPATCiRHmLbHH0BxS+6h4sRz2e6HNhNXs?=
 =?us-ascii?Q?IlTfp1/dsqY0NnyR24vNzlqa+GevZGm4vU/2chd49EKRTh2h0IQfsNOjK4he?=
 =?us-ascii?Q?TWIDAYJ0gTbBh7zAttGQIOEbEbWCL0nHzoq71HVevkj+ZLMay+U/n1OFIrHC?=
 =?us-ascii?Q?fivt4z6v7/xUtFyYpzgBiQRuexpTMtyWDllyMSYDR09MdbNfo4GtnDtExKzd?=
 =?us-ascii?Q?lnhgMBFFUzIlHOydibjEBEnLasB6AUSaW+eJbrM8TfS5ufin14v8eJ9Hm1x3?=
 =?us-ascii?Q?rls08LP2Q/UEkSnpOWSr+GVyqdrvk6FGXm5i98mvLOyoTMbnrbb4a/ilaQoE?=
 =?us-ascii?Q?Pq7Ec+T91Frcg0AfkyC9tcU07HF+Ky8kTm8pk7H8nYzAgJV9YjAqBkkwtdO1?=
 =?us-ascii?Q?mdFxHz774T7CHscnkiStOiU1PBf8c3chnXq2YydBSz3msTXLnBKD7fiX9C/Q?=
 =?us-ascii?Q?IuNYjRK8MV793HdBQJyPlOZ6zk+gfNOqs9DfIDjWqEOMfPU5Oa+o64OVkxHn?=
 =?us-ascii?Q?h5L5butsHvsB6yDwdn89FmiWgAhXWkV9r9P8LYV9Iwd42sojR6u0qAQPEHC6?=
 =?us-ascii?Q?CYY42ejj3c+TOtOQ/iC2QLvoHpso2eN7q4jVrlqFKho0PIzQexPNcxiIIrs3?=
 =?us-ascii?Q?G2UNp6gnQ4tPsMJQVNtrmN2VZaG5iuT7liw/aPMkrN9Ejl7zKw803uIUAVYV?=
 =?us-ascii?Q?nKb6fLRrok1ckcD76fMWEoB0VK337tW4VOwWgMjr/kdyvkpca0vCR7oDlunp?=
 =?us-ascii?Q?Us1vqBb5gvOTg+vOuA5vTkf+4oBcUFLoNqKcHAXYzxHDQQ+9KDYnY+3QayEi?=
 =?us-ascii?Q?KdBKiJ+LJRONIQRaj1DiV9H0fsEqrTniPPB4JS8UozQmP4P8brZHgMuWr4N4?=
 =?us-ascii?Q?q0AKla6Z7SJP7yTL8fq2zFNHwKofwfn8p4so7eWKKs6ffh6DVUf7s+GaLqwH?=
 =?us-ascii?Q?tiif4wGr4RjDQ1RycaV3MoRFb+oZnz861UD6zE8Fycvj80B1Qw+P9DXCW88o?=
 =?us-ascii?Q?B1BKOFk7b0Awt8IxGgODutbeQktpaBnTem3QDx+GT/ZmzB8LTc+1rAk1hRTy?=
 =?us-ascii?Q?KMGkmQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5f18b4-72a7-448d-0cb1-08d99fc60815
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:13.8763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBr6GhvSfyiBNFGIUz/WmAtdP5I1NuDZrSm65TDAt7pHdLhKEUDYBAWO08bm4GeSMrBg3mw6HCqJM4UYGyfv6kemMuk1jnAIVAWohQQqwms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: sgsOQUCwxd53Ss-KMkvmUHsGz_2Yps0f
X-Proofpoint-GUID: sgsOQUCwxd53Ss-KMkvmUHsGz_2Yps0f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert from vhost dev based helpers to vq ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0d85ddb68420..08beba73ada4 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -361,8 +361,9 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
 		struct vhost_scsi_tmf *tmf = container_of(se_cmd,
 					struct vhost_scsi_tmf, se_cmd);
+		struct vhost_virtqueue *vq = &tmf->svq->vq;
 
-		vhost_work_queue(&tmf->vhost->dev, &tmf->vwork);
+		vhost_vq_work_queue(vq, &tmf->vwork);
 	} else {
 		struct vhost_scsi_cmd *cmd = container_of(se_cmd,
 					struct vhost_scsi_cmd, tvc_se_cmd);
@@ -1360,11 +1361,9 @@ static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 }
 
 static void
-vhost_scsi_send_evt(struct vhost_scsi *vs,
-		   struct vhost_scsi_tpg *tpg,
-		   struct se_lun *lun,
-		   u32 event,
-		   u32 reason)
+vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
+		    struct vhost_scsi_tpg *tpg, struct se_lun *lun,
+		    u32 event, u32 reason)
 {
 	struct vhost_scsi_evt *evt;
 
@@ -1386,7 +1385,7 @@ vhost_scsi_send_evt(struct vhost_scsi *vs,
 	}
 
 	llist_add(&evt->list, &vs->vs_event_list);
-	vhost_work_queue(&vs->dev, &vs->vs_event_work);
+	vhost_vq_work_queue(vq, &vs->vs_event_work);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
@@ -1400,7 +1399,8 @@ static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
 		goto out;
 
 	if (vs->vs_events_missed)
-		vhost_scsi_send_evt(vs, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT, 0);
+		vhost_scsi_send_evt(vs, vq, NULL, NULL, VIRTIO_SCSI_T_NO_EVENT,
+				    0);
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -1428,11 +1428,10 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	 * indicate the start of the flush operation so that it will reach 0
 	 * when all the reqs are finished.
 	 */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
+	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
-
-	/* Flush both the vhost poll and vhost work */
-	vhost_work_dev_flush(&vs->dev);
+		vhost_vq_work_flush(&vs->vqs[i].vq);
+	}
 
 	/* Wait for all reqs issued before the flush to be finished */
 	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
@@ -1967,8 +1966,8 @@ vhost_scsi_do_plug(struct vhost_scsi_tpg *tpg,
 	vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	mutex_lock(&vq->mutex);
 	if (vhost_has_feature(vq, VIRTIO_SCSI_F_HOTPLUG))
-		vhost_scsi_send_evt(vs, tpg, lun,
-				   VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
+		vhost_scsi_send_evt(vs, vq, tpg, lun,
+				    VIRTIO_SCSI_T_TRANSPORT_RESET, reason);
 	mutex_unlock(&vq->mutex);
 	mutex_unlock(&vs->dev.mutex);
 }
-- 
2.25.1

