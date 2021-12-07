Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7964DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhLGCzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:14 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48696 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhLGCzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:04 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M56Al019276;
        Tue, 7 Dec 2021 02:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sptFC9ACWeJehv2+iivuW6IYYpR4vhUSH/F1E0l2eC0=;
 b=lleM+2fFToXorRgZqgr+WaAQicnRjnMs5RbXx+ioU2eIbcFVwFP0tOtN1J/HCe9ve9I+
 GXxnF6f7o1UJA4zjGs3z9yuvD96pFRMXh6CgJ/YMCYz/F5EQbbTHTSJLStfmgiGtLB8t
 FF3ayV9azluJt39WWnmpSziG7JGptGLGRdNQw0d+QqpBcVg+pSOCwTxokDGLdOmGAeX4
 jdcndGNW3th+yfUcXcrfpEe9T+J29vxV4FYX3tzdtuTP4Bly1VVMDJamAn/70T8hm25A
 KodX9NG5by1R5FXOD6gTc3Hn580NXhnl3s3CZl/htd/krl7mq+zd9a4XdcIpOCtLvDqL +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqmefb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglc153019;
        Tue, 7 Dec 2021 02:51:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrF8TquI90g+lpJLo3YH94gOVmDp5sZ2SkUSTRnhFe9Mex/6n6XEm79Pu1gRRLU3z3MI2Lb2Klzb9VYFjphDiMiHXqPi5gwIs+9/cS07H089Q3WhtKU6siIpIuOHSrgwk3R6yfiGknuaV+CeZVwkXdpRjZvnkvMl4bfohyPYPkrXi56vsYVZTkwnVteJ6clemZPxYf2tAcN5dJp6Y8MHqITNr0NPtQBVW7/VNXhZZSalmop0HUckixL6PrdoXnjAeAcEwmbQ2fwihkhEumKuzum39o2kZS+u0A8McT1xZF1XljFd0QD+gvJl2OgXJWXn/XJwPyAnloXP1wTBugX8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sptFC9ACWeJehv2+iivuW6IYYpR4vhUSH/F1E0l2eC0=;
 b=Iu4U0lM1BbCtgTauatGUzTxG6HlDF8yTnJEI/pUuB0ZluRko3iiiQzhjn10cugSWK6Htlg1F4tXcXisDp3pcI6OWghke2Un2/a+2X2queIoOHdjo23QsavcwpCGyjxUQl9PYeZ5g7GRHu+qcmWidrQgjXkl3M3p92f+xzp7m/fdioa9yJiIq8hy1sTn03KuWYtjFhGJb05APRLUyciifFP4gA0POBhb/4FKikvWQi1WFeF2zTAj1P4ebZLHoGdOF2vyj4BUJS585tVm0cuZPRHdiGH2plkW62cHq6eQgOjgtM/z1e/0UBHLTY1Kc1v81m7tI37bhASXMinHEnPYwjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sptFC9ACWeJehv2+iivuW6IYYpR4vhUSH/F1E0l2eC0=;
 b=et9nF7ZGjnWdfUro2x7/DxPV/yZYJa4qayArO+kPZcoVIvUelvNhh+FPPox1HwW0Ra5PmTED72V0/eM+0MFsCYl0O0F7ZuQPNigxIbkESLtmZCmeoIwmatancSoSPiD/ylBpKMq0VSfcDUA/tqPR2yoKwppA2D0TiYvOVeFN3eo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 07/12] vhost-scsi: make SCSI cmd completion per vq
Date:   Mon,  6 Dec 2021 20:51:12 -0600
Message-Id: <20211207025117.23551-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 739f537b-ac60-4a6f-56b1-08d9b92c779b
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347518060EE66F72CA4C479F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+ZWNJLzCbbR4qkBYf9A7SDWgpsrKBuR8ZcxtXfs7smP9pk/nDGWW+l+9UTL0L1CrE8DZLzeDgOruM5LhufAp6YVuNDCoVRdk5y89uDLc9jdDmrzWDUDdQVxZw9WB/8YaS3RFhcRtpz5a2xqeCpLYfFlhzMZNpGyy0MHXwaDpdQy6o5VrvXclHMHPfmCQyfvVYZXQFHRryqC7sthhiZ5NPaIr1rkMNnz5jyz8knwqBzGD5ZajuAaZ2F+tFsQBvGxQOBsCHiEdK577APApjv1S+PXMP4GHqiE7uzW8qjmMLDl0H1D3j7EIHW+9R/i/bmBVOCP300H+u7t2YFiS9Vxd6PUUgReJSJYS/qacNerdNgOzrn8tghWaughlr8UJLHyT6uaOw0A6MNd7QbtTsEmAfoMDKxvuL3dxU4skjfrPbymwqX33s4gXIfon/nrpuXGpdb61b46EYfmNTRxSh7VMagm+E7a4wCV27D5yWCxq5P/m3Y8SV0hqVBTZd5flL9ZNU3rpjNUEwZvidHsfkIQgPx5XcVByIlbjvZs9UfAcug84wChh3fjM8rRfD4kbzuHm0Ufvi9zGJxtjKp/SMseiKgUyA0CRw5U6YZJ+PLJGM1X7r1lrjF/ebNikgeIevL3YXupzvwWSZfcJflZP2SfAh1837aVzJ5ujB+A5ohcvqVlY6I/BlxkGPrLCdxQOIccluVVo0GAGs6ng4xQXjNG6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IL9GLv7sHaIrn8werNniT3lMuEjSwQmoWiM/Km09pcSQIboewnVS9Ah4500G?=
 =?us-ascii?Q?k+CFHI07m+TGAVlixSahYvVJ36HI7KX2yNXMwkh9/0Sg4hNxOTk6dPKLPlR8?=
 =?us-ascii?Q?AFY9oZlL/4df8FtjvJokXQWsCt1L73NwyuELbAB+cnRZBsWvt8f8avizP+lN?=
 =?us-ascii?Q?7RVAvPNjtxDiGrSR4TqwPM9vWMP3EzDN6EXm1LU9upUCwCK19bSU9u152du2?=
 =?us-ascii?Q?MN46FxQUO16rh5SdOFRZiz3b/qnniOY3N0Z7BY1+pewOr9+/fO2OHAYRr+ss?=
 =?us-ascii?Q?+vBuOAJMk7JICtKKffrT/PW2WdliyEMUOOiSktY0K5WSJdbYQ1RVstqepe69?=
 =?us-ascii?Q?GEETtgmb+kOU6pUjWONmdwWxl8/imNmfRtqw0FcGVch3DIxiadqMos365U16?=
 =?us-ascii?Q?8YdOqtFB38o5eKPmlBZ/MriLcnQEcrIVmn7EEb1pxnYLwBnuG4WvS29W1wCI?=
 =?us-ascii?Q?92mGWOPSPFWj5ErfEMkntco1EmLdoKq8EBuHN+XGhWvvIIGeR2CIRzsRbB9l?=
 =?us-ascii?Q?v0feWrHxuf4KnFRbZDueGlHI26+jsBqtQQf2h0UcT3+/zTQIpdrAVGgLnd95?=
 =?us-ascii?Q?dT/SZ1oxH3zVszET8jQ4AVhx/t7EeHCWpaRd1irg2GWa8bMbyUwM6blfw14X?=
 =?us-ascii?Q?uoU0NMt6V4M3AkpCSO8swoS0VH4ResgLhjtfgj457pbs9zZW945CR+y6XYpO?=
 =?us-ascii?Q?Mvn4anh9mjLTrDGkrb/gH6aVb2g8Dc6uta4UTwH77Ou0MjqUP87MvSoWnmYJ?=
 =?us-ascii?Q?1LvvGDXQSoJxPIcWEnaVBRa1QdR+nVEBCABPaOEdLYx91NBuTj4Omrh/YF1b?=
 =?us-ascii?Q?ymtnu7rHdH3FVVbaKzhKrTQ/BSfksKKeM+t0InUj5b2biB5iTqPbF0uE5MhN?=
 =?us-ascii?Q?Kf/9T2zvjIcu584wWR9AKcAbRtCgEGotl+lsT10dcH4kgj51eG246UHInqnM?=
 =?us-ascii?Q?evNWhTmBfmF/gIWca0Zzg11R0mI80vnGTXGr75RT2Pn1arwpUm6YVV4fd3LJ?=
 =?us-ascii?Q?Fh3llSP5Z94HEq4mqQVJIkIrT09lSD8yNBgbQLVtBd8UnKiOf+Sak0eZbNlQ?=
 =?us-ascii?Q?DC6fZRT33nAxGUxkYSopljyl9FA845GC2oNyETUyQOXdUq9zyXpHr/PIlfAa?=
 =?us-ascii?Q?BBn1M524wXbBLDyOQnQ+qxO/7UVbifLH2/qz4m8qJ6RGNqfp/hkVJ02uRP6k?=
 =?us-ascii?Q?sqQqc4bAX8Xtxl14UcnjEhuiMbuNCAqpyymFJUNwzapDwPgEAmw+Z2Y9fWOn?=
 =?us-ascii?Q?rzk1S893ndTMZyRt9dPerrv37C+xzJyD2DvN1Xg1liq9GmLa8eJH/1vFTc4u?=
 =?us-ascii?Q?heoEI6faHzyi3GKk+BsJwS9NkStdmv9uKvMmGM0yIe5ZlH1I9zB6A1mt6Nqy?=
 =?us-ascii?Q?78cnIvjSFUkMrqQ71uEz+2UtkqGv07FQcL1bAEU2fijc0cYK57G4zqafbADL?=
 =?us-ascii?Q?XtEAHjDGmp3zwCzmtPLvUBciWO2WtFI4lF7PjyCb6ORcHc4KXgvlS1+j71c9?=
 =?us-ascii?Q?jqfSiLFsMKouv2NgAU4VnJ0waNRLxqv6dYwbIelm62MehV4Y4jxUVyWCJhHW?=
 =?us-ascii?Q?5MYutWVSlPQmmG/trwpJTf5dX894bUkmL7vZwvU59NoPdincy9lRPS8IvHmq?=
 =?us-ascii?Q?pAYM1otEdyBjWRqnohcHxrSmFqvDa/eD0NtCkb7p4YkOWfbgK0c9ZAeWKHSZ?=
 =?us-ascii?Q?7ahVFQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739f537b-ac60-4a6f-56b1-08d9b92c779b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:28.7173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KORstit+rqtEEVTTRyBATLIgEi+oith2ZJwb4ibHlSLQJ+ZCoznEzkMkHM/Gq2kVMbfo+VsYvmlqGsePLL1Q/wRMUt95voBEmNXSIx2uYkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: WrUqxNC-YwCC7GdWsSIh43xpxrKtc3Me
X-Proofpoint-ORIG-GUID: WrUqxNC-YwCC7GdWsSIh43xpxrKtc3Me
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
index 94535c813ef7..b2592e927316 100644
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

