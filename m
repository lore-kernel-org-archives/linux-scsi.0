Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A31CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C106121F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhKDTIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:08:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31746 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234008AbhKDTIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 15:08:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IWnvj001563;
        Thu, 4 Nov 2021 19:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=G3ojJFHHl/L/lXUuIAFUfdn39ABfIdzQ7mvh0/sQ8MjApXLVyFnTGE2ISgm66QX1saeF
 5KyWC4sil7cqzHe+gd8jeNyBH1BKgmp/yV6X1NRwbqaUmqoHhedCF2NhsXrCH9nuB9It
 +3J4S+WwgjmSSSKCAnZKaTKKP2o2bIP4HJwq0Yh0t/Ei0s9Wals3aPdRo8idQKh9iIAy
 295EYl6tDo7OkY+4nBcob5qXPS8CvA2AQGccdcseK067O8nbBlb/wVpnj+1LR5yxfj25
 X/PxXFvk8GTuJJjSjoLTx5Y3foBs82ize+yIp//yLEXu3C4Z+bRwi9pywXL27KJG2cqZ Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9u84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4J0PIj122897;
        Thu, 4 Nov 2021 19:05:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3c1khxpeas-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 19:05:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3/UzKqW0kHrLfPdfItnlXk8Wsz4QG8cdNxX1DwDWL1sTKhyzh5nCXecCL/QjjwRbFMXDCbGuKieVitvAy02kn2vKA6+JgZNUEXUuFH04s48Ycg3u8880yMi1IBmPWR4nzBdY4l1IJ8tYIvAt/uinaNgtb9MRESGLTwjWDcvhAB2qACYlaVBm1zXVDZQpqhgen4C8RpE7FL673bAZqaaK6h8BJQB3KXC7S3A1XwKgW1wdqlpzmONlrsRei0exZ0XFSVUNDxumhABJya25UgWPZGsE+kWvs60iPedFvWYC+XRuV5jw/Yx3BKWw5mcFQ/LzY+4Znu6oJU1b2aNsVUDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=GMTfZRpuwOUx7c7XxuMLVQr1ZZwOLf63nNJNG2UkIhhE0EXWFnxMA/AvfXFBcAspwFxzpoVC0prlj1x1DV9H9y7I6Gu0YKgo/FQEvZE4hFIcnl2bL7SSk8R+iZ10F4fP/itEFQp9N6wftRfbaYw3aygfDzybyQs+zoOuBHVQF+IZcRJTFGi7s3uWzPsG+0BDI1zIxatT/V22sK9AtSF4JQaT5PlN9SY58hDeEfcTeJ+YfyVuKi4p5GNefgaiETlPorCT8I/WKfRHLtv9/i8jo24eTfXJ6hOvV2EgWnGnWmACV1xvLIuefyQHBD/5AkkXq5SzqZuPNxK0L/bm1Q+Fbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=ayLacFo2GpxkFwiuq7WO9xYe8ErzwVw6v0DSOoxAn4yWGsVLzgyqMzqpgHapa2o0hTpg/QTDAZgdaO/4sSYrzz+WicEdqCu+obVmT155LLm2UOLHkpfM85f76xRHLcZxQ7kJVa0aT2CC5Xv2YGKkqgttIDJJm+Q18AP0zgWsyU8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2873.namprd10.prod.outlook.com (2603:10b6:5:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 19:05:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 19:05:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V4 07/12] vhost-scsi: make SCSI cmd completion per vq
Date:   Thu,  4 Nov 2021 14:04:57 -0500
Message-Id: <20211104190502.7053-8-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: daea8f37-21e4-4651-e462-08d99fc607c5
X-MS-TrafficTypeDiagnostic: DM6PR10MB2873:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2873F7B4818829D46FCC4A06F18D9@DM6PR10MB2873.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z66mMg3HtzMWd9suOY4GWYlV+weLZTzUSmNLWvg85YYeCDPBmqt8xGHRFmK/6HU8yVKmTLIhdg1phO6qFU5eIrtobTmgARwckXC08t6o15iillrOumqTMmGZhIFbhxWxjqSRzcQUiohA/Kk9Uy6Tm0shYRV0+PxhFPSRgbPnhXSD04amdytg83s9pvmVQqr05PBixVoFPmmDhEiCTH6QhzJgktlPIoJ0/4wB9O6cOhdoQg8yFfWexWHusY5cOx217HJvzQof7rTUPNJlJu9ni4cdyPawyngzioogwRJ5JHM6Qt1R9d/HQ6z9MKKNbH/PkWzo4gonCU1FynAnHcNTJmXDAy9uKB9CIRLwWuZ0EKOCYqwt2fLjpo1/g8ILc3xA0WsNjFp9PXBJXg1TiVumGApdCoR0k6Q0Hd8eVOScbppxq7SYfvYXbJdzs1LoYvttFCLZ1a1h3GG98xRTavlWYkr/ITGOQdHTsrqqgQWnVtSLnW3uxLBJ/K8QjyWQQZXLnkVp8gD31zxsfYrNrD/6Bo3b8rhuHAjjCfXL/PtpkXEDLV5jv+cUAmzvlh8NIuZAoT1BDhMR3WHdHo4hiIxDfHe4vhIHWUC8+NL5bFh2IWHZJEejcfsRFYw8RTgZabOQ3l6BFDIak6U9NWfsvHHakaXDf9IRAb/T0KZoQKkftm4v62ZQrWTP/yZOd5bwduZU0lBKdMkGHAtcBGDgSHvacw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(8676002)(52116002)(6512007)(66556008)(66476007)(6506007)(26005)(66946007)(38100700002)(38350700002)(4326008)(186003)(36756003)(1076003)(86362001)(8936002)(83380400001)(6666004)(316002)(508600001)(956004)(6486002)(2616005)(2906002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a0s4kz+flKFKa3RP+voj0UEMjtvCJLy5aITOtH5OMslzwHXDjeO51BCp3A5e?=
 =?us-ascii?Q?Kl7aLdaFEHTuSiCG08DymQc1eTPx4mD8RoJnGWY0Dpwh8R3g6txSOy3Yg7/L?=
 =?us-ascii?Q?F65rniNYwO5tIWRw44gB7ICUtpuUqw46Jnm1WKdqrXzPp/wWcVXquz+uVISz?=
 =?us-ascii?Q?cijNTLaglc/Lm3U+Y3lcUtVPu1F8O+zobgi+fekzfBUYwBxWLtcQRI7WNtRY?=
 =?us-ascii?Q?zAAu2La2b9Rp64EEOygxlCfGIJIfIZ2FAkcMeyQV3+dfrL7R8sU0M59TaZU3?=
 =?us-ascii?Q?dQYsKDejnzyi1Nd7wYcgXAO8gKjU9JOBesqoRFZXYsuHXWmsaBeIFgWtP0+t?=
 =?us-ascii?Q?wxaZTr8lO6rPWfHVkDNgaa2ZJW8ZCy3wJhGFoYvMQ2GGrwhQhuLCmsHPx4uW?=
 =?us-ascii?Q?2J4W7n4xrUQpaZHJ4ecoEvu9D/orb0l9ZSWGerO+MfEuTdO4KSUgMiwZJ4aL?=
 =?us-ascii?Q?jvcjuanYogTWnoBFFT+zDlHG2CaJmV6JKEQeWYUrF60WODA6L80Nyp3jd1in?=
 =?us-ascii?Q?MgPbijWim38eJNSOGSO1G5GUP5FHcSxT/+I+RnYwuozsk6Ba5CL5d8D6aZtW?=
 =?us-ascii?Q?7iIsHBvP68H58gzgtdaNy9drxvu+9kbTlBpxcO1dKZmj+OqAY3ka8pXvy1EI?=
 =?us-ascii?Q?VdiJeIaFObC2bzeslHHqF47RtKuNaFMg0SN8uIrmNOBEF+tp/JRaA8iXbpFP?=
 =?us-ascii?Q?rQHCDuKZH5cflQWF7cA9xk1e2EZA2qMSf795czVb1X+1C9rCx/nli3TpLL2B?=
 =?us-ascii?Q?h1z9M7ChgmQrAc9plrTQPN7KNpOjFzcSr2oIB1fTCT9nf19BoeuKDGVwHcn3?=
 =?us-ascii?Q?wJB4TlGO9P0Btu3BuDIBpOArLkLk7VyuYYjGRfMyohbeH3eeaegPp2TM+mwu?=
 =?us-ascii?Q?yVPt2Am/69KgwKRSV56himqYMajZLkRanTcl6Ko11Cr7TJ+DnbQqsEJegr2c?=
 =?us-ascii?Q?VCPSgJh4fykm0EK+CutHko3nV+fh5MGDT4lnD/VnOjnvYtMrl6uvVwq7OGhw?=
 =?us-ascii?Q?UiNGhtiZT0l5YQ8mFFiM7Hc3Dc6Ik3SL9b9t9+ghjLGY0Lj//fwPX1ExE+ag?=
 =?us-ascii?Q?vODXS5ru9DIRLusExeY5A/ZSMusRfKpquYUo7Mo28jpSe72W7WNnTIOaz/Sp?=
 =?us-ascii?Q?UBaukyNMEe/vQD+WBDr9WqJ9aAiTrHLpYbKicTzhBA41+kHNo4jRgAc8dXIH?=
 =?us-ascii?Q?f8mgrCjiycOcg31GYhPHSIOYKPVrTr6no6AbetuJ3WAb6QS7Jrz3DDF5LI+S?=
 =?us-ascii?Q?kF9d2DFqBb6sKJsUBeXLbLltqFeybNb2LS28PpRgFLrkLQnOK4Y27MQRL1EI?=
 =?us-ascii?Q?JOoTJH1JB4oRqr12VbtLuya/w825cibXPBCcr5bAgd5IJdN5q6Qh7oyFcU9R?=
 =?us-ascii?Q?N3P8pt9PY9Vh3Rq0q/OeIwl34kZAY1l93mxHIXL/LPnDZYHHy8fJqlI+VY0v?=
 =?us-ascii?Q?1Y3dfs7qYKxnXhWhMql+rqcHsYaRNd5evtBnq3194XIDh5ZfZcYD31C8skC3?=
 =?us-ascii?Q?P7TYtdLgiC3shIGFCILCNAzUGWflBFn3+9n/Z3Bs7IDWmBqXYCxwCq2tYzs9?=
 =?us-ascii?Q?VEvNPuXwx1S1+j7BMbyXtjlzTMXzu/zkyg0qHn6yc6s6WMZU0IsiLROCim47?=
 =?us-ascii?Q?p7xzEusX2iReo657s25rb80UYxAda1SaXeescAxDWpeUiD2QPg/r/hF1f8Eg?=
 =?us-ascii?Q?Kxja6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daea8f37-21e4-4651-e462-08d99fc607c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 19:05:13.3855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7l9NTT/QxMCQJTn4VEVOtPAbekh5Ts4e3gUu7GGQgxAVzsqBeftJ5N4yBuF8H6JMQ8ocMbg0gZezcPrlpup0+eVGeYmPAEEDMg/7yxUR5BE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2873
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040076
X-Proofpoint-ORIG-GUID: ThkAG-cKJgLX4szjQnO1DUNJk0jqY8DN
X-Proofpoint-GUID: ThkAG-cKJgLX4szjQnO1DUNJk0jqY8DN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch separates the scsi cmd completion code paths so we can complete
cmds based on their vq instead of having all cmds complete on the same
worker/CPU. This will be useful with the next patches that allow us to
create mulitple worker threads and bind them to different vqs, so we can
have completions running on different threads/CPUs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/vhost/scsi.c | 48 +++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 532e204f2b1b..0d85ddb68420 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -164,6 +164,7 @@ enum {
 
 struct vhost_scsi_virtqueue {
 	struct vhost_virtqueue vq;
+	struct vhost_scsi *vs;
 	/*
 	 * Reference counting for inflight reqs, used for flush operation. At
 	 * each time, one reference tracks new commands submitted, while we
@@ -178,6 +179,9 @@ struct vhost_scsi_virtqueue {
 	struct vhost_scsi_cmd *scsi_cmds;
 	struct sbitmap scsi_tags;
 	int max_cmds;
+
+	struct vhost_work completion_work;
+	struct llist_head completion_list;
 };
 
 struct vhost_scsi {
@@ -188,9 +192,6 @@ struct vhost_scsi {
 	struct vhost_dev dev;
 	struct vhost_scsi_virtqueue vqs[VHOST_SCSI_MAX_VQ];
 
-	struct vhost_work vs_completion_work; /* cmd completion work item */
-	struct llist_head vs_completion_list; /* cmd completion queue */
-
 	struct vhost_work vs_event_work; /* evt injection work item */
 	struct llist_head vs_event_list; /* evt injection queue */
 
@@ -365,10 +366,11 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	} else {
 		struct vhost_scsi_cmd *cmd = container_of(se_cmd,
 					struct vhost_scsi_cmd, tvc_se_cmd);
-		struct vhost_scsi *vs = cmd->tvc_vhost;
+		struct vhost_scsi_virtqueue *svq =  container_of(cmd->tvc_vq,
+					struct vhost_scsi_virtqueue, vq);
 
-		llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
-		vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+		llist_add(&cmd->tvc_completion_list, &svq->completion_list);
+		vhost_vq_work_queue(&svq->vq, &svq->completion_work);
 	}
 }
 
@@ -531,18 +533,17 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
  */
 static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 {
-	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
-					vs_completion_work);
-	DECLARE_BITMAP(signal, VHOST_SCSI_MAX_VQ);
+	struct vhost_scsi_virtqueue *svq = container_of(work,
+				struct vhost_scsi_virtqueue, completion_work);
 	struct virtio_scsi_cmd_resp v_rsp;
 	struct vhost_scsi_cmd *cmd, *t;
 	struct llist_node *llnode;
 	struct se_cmd *se_cmd;
 	struct iov_iter iov_iter;
-	int ret, vq;
+	bool signal = false;
+	int ret;
 
-	bitmap_zero(signal, VHOST_SCSI_MAX_VQ);
-	llnode = llist_del_all(&vs->vs_completion_list);
+	llnode = llist_del_all(&svq->completion_list);
 	llist_for_each_entry_safe(cmd, t, llnode, tvc_completion_list) {
 		se_cmd = &cmd->tvc_se_cmd;
 
@@ -562,21 +563,16 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
-			struct vhost_scsi_virtqueue *q;
+			signal = true;
 			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
-			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
-			vq = q - vs->vqs;
-			__set_bit(vq, signal);
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
-	vq = -1;
-	while ((vq = find_next_bit(signal, VHOST_SCSI_MAX_VQ, vq + 1))
-		< VHOST_SCSI_MAX_VQ)
-		vhost_signal(&vs->dev, &vs->vqs[vq].vq);
+	if (signal)
+		vhost_signal(&svq->vs->dev, &svq->vq);
 }
 
 static struct vhost_scsi_cmd *
@@ -1776,6 +1772,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
+	struct vhost_scsi_virtqueue *svq;
 	struct vhost_scsi *vs;
 	struct vhost_virtqueue **vqs;
 	int r = -ENOMEM, i;
@@ -1788,7 +1785,6 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	if (!vqs)
 		goto err_vqs;
 
-	vhost_work_init(&vs->vs_completion_work, vhost_scsi_complete_cmd_work);
 	vhost_work_init(&vs->vs_event_work, vhost_scsi_evt_work);
 
 	vs->vs_events_nr = 0;
@@ -1799,8 +1795,14 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	vs->vqs[VHOST_SCSI_VQ_CTL].vq.handle_kick = vhost_scsi_ctl_handle_kick;
 	vs->vqs[VHOST_SCSI_VQ_EVT].vq.handle_kick = vhost_scsi_evt_handle_kick;
 	for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
-		vqs[i] = &vs->vqs[i].vq;
-		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
+		svq = &vs->vqs[i];
+
+		vqs[i] = &svq->vq;
+		svq->vs = vs;
+		init_llist_head(&svq->completion_list);
+		vhost_work_init(&svq->completion_work,
+				vhost_scsi_complete_cmd_work);
+		svq->vq.handle_kick = vhost_scsi_handle_kick;
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
 		       VHOST_SCSI_WEIGHT, 0, true, NULL);
-- 
2.25.1

