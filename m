Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F0AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE7960E97
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhJVFX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 01:23:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52962 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhJVFVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 01:21:51 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2lxtA016493;
        Fri, 22 Oct 2021 05:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=S2hL5lYYUYy05FGRzU8wrFBIZAaH27CirioSn3MWP0i6xFNuTR4jaBzzUgTn8dHbFjCP
 JdDg2f6uzcp4sOeN9OnogVqrv+chkvQKW2XRXMJDxmXmof8ZJhTXf2qD4qRpqCVw8UjK
 vzoGz2GnDfMHKxw2VN2CKl3X/mlIBrZ2nIsnfugcknNIU++sLl3rNACMsDD0s5T8TTqB
 mRD6pgVI0nC89GneWOwXs2t5Zo/CZi+DjOzfcQWKkgDU+WQsSew5Ykh4VOMiNPpNQ53f
 o7pujvhKBdSVEvIP55WPGIau+INqs2tqDrSH/pztOpqvNOsByr3IJI+KHoO2vK2X5Bl4 /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm8sxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5BHIg139141;
        Fri, 22 Oct 2021 05:19:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3bqpja16nf-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:19:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYo6GTahHcIvsr2D9WzrJS454XQbePr4mYKl3juEtD0KADITWrE5r5XIXyzseflk+9RizMLH7jfJ//2oes/DzTqkx8Thusr0nXGCcNurb3I4XNy95mMrqD1QAsbpIFeQMZkuelSWIHsWNl0TQS87ocfweo29fycWBKMrg7bGQTb4kzDiw5xWPve7pYoPDp0ejpopAtwhUkd/ahHljT27EkWtelCC9mzoSRdDFOWQedWZGRjUNX9iTpVKwuk634YJq/zlbVDB2O83pmSEPCC/ZWruHDOtlUyW/nrSCQRtjNMehgNYOZ0PZYRkXUYTMF7GYQIhx2ZwCavbrqn9nF/QEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=PPjxz2W6Fy3iQ0rtwmwpTI1tBmMSv+rNvNJuoLcLzBmkS6YL9QHADmBKmXDb2y96KJHa4t2QPslEYw3hYW7KuKAzh9huBiIw4vmL8jD9c8IZ3S78Yjt3+rAyzHO91Q7AcQ/JGwW/aAmH+LuE4VKrP5K+1WEZikTulX2q09k3wvOknkn9IH6Ag8y/Bi7mzhwF+/tJ0I3xVMNxITQ6/2vefX27azKpIUSS7/Yyo+nn8or3FHKpdRzZEKSHj5/50NFSTPyIhTb5THvebkgO6pS4fgNbOE/yL/tIw1gE2bQz8ffRzmfySjKdDrWBZUM8pY2BAwPv5znxUmTfxwkjyGCIew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2BiWlWONQB9Fkj62gZN5o6V72Nn3xht8vO97+bmBR0=;
 b=Ga2Gw9vRbcMwziva9O2tERnAYY8/L+sywdnGJeCzTLPJYB9NQgP5PKgq4M2YWgYBXS4123bhSUBoXbm+WNyqkc5Kvs4zle/CzhgC4bAvaohk/MZot38qz4hXsBaL+Ho3/ogRcpHgTPt9R5UdbliO8bPLUqGSMEbYT1pP5MNyMuI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4974.namprd10.prod.outlook.com (2603:10b6:5:3a0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:19:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:19:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 07/11] vhost-scsi: make SCSI cmd completion per vq
Date:   Fri, 22 Oct 2021 00:19:07 -0500
Message-Id: <20211022051911.108383-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:5:80::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0012.namprd08.prod.outlook.com (2603:10b6:5:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:19:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4db59406-8ecc-4920-6673-08d9951b851a
X-MS-TrafficTypeDiagnostic: DS7PR10MB4974:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4974D23FE2845E86796E4539F1809@DS7PR10MB4974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KlhOjs17IOf2mwLaUbPcd0WqzzZPqstKfyxh427jwxKz7MpFDwAHf+T4nb/qU/Ty16b+P8ZYgw2g3KH1NFl7UXbeltdcY8oQZsFZjpzaVQxkA8sIx9XQz88dgQhbTxwyqWRem2KzX5VwJ3rMXmwagY9qJ3R1kHGdsQni8FjwXkR8Nd1cqpofiXwzUc2PIQC/M/a1wRBMVXDXPUKabtBXZ+6s8LFqIddvyFf+O24vxure24jfA5Ag7XARbEvs4+0u6RPhvqYw9fkk7Md5d6F9g/1/ordJICQGkP9IgSXNXe/jKIEPazktPEqE7dCL6rujuCNZbwDn2n7iy2M46qlAjXLTUe04EYz7Q3j4CFq8s/Wxe1/Xr3ZvTrwKB3DHkC/yQFWtM7g2N4pHBQCQQTSb1JqcOh3bz7wbyGT05WHjJHTgX3nvdo6RKG1oVY6zm/SOn7hj2IyFdQQ5WfbE1CLlys+kvCd2g7heeFBlbpVektHZ+dfe/lbFXWHT5VsJ0Xcl0eVHpOAf4ZioL86MasapOFyqg6XeADDGoFyg6eR8Zm/HjYfFtfR5DxWHKjrkruwfFFrF0xzR2AlO5Y4sej4+nrt+/UyZUzhey9pRDEvtBjeJIhC8M608uk/iIfNmBF1pn7jb/v8oBS8l8YvhNbFgcVl6ZhxWA3o7K5ymC+AFd2cqdlrtcPLvPmeT47CgwEO7BcqZG5ZN4gx+11FJAus5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(107886003)(38350700002)(66556008)(4326008)(36756003)(6666004)(1076003)(508600001)(2906002)(66476007)(66946007)(8936002)(38100700002)(316002)(6506007)(186003)(26005)(6486002)(6512007)(83380400001)(52116002)(2616005)(86362001)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6T9Ztn5ZY0rxYmBzfGfA2MPe82hyr9W56k/VNdak60Y+P0NXuwsU+QcSs0Oa?=
 =?us-ascii?Q?ie39h41B2wUgoSPrpCDMT7Qt4xBdvA6FesrMewNSANOIoCtQWT++s1XAjHpj?=
 =?us-ascii?Q?quHmnr808lRDHBgjgwZi5TM2RN9UNUxrk8cWVWiFeXHQ82oKDVZ1aNR7wDn6?=
 =?us-ascii?Q?MPhaaOWvOY9oaDpH8DuXx+zucwak/kAQMTRVOFom6Y8wZPrtRqjP8A/1C6xJ?=
 =?us-ascii?Q?YgtdGTL21l1b7sCTRpUCOG3Cu4vZRuPJ9LFce94RAzT6d69XDAJG8vM7hVHV?=
 =?us-ascii?Q?HyIglAbQ4K/01qu6Js8PkW4Ej+Jz3B0mCAAdwMEpYHyJQom40Um4UlplJWTW?=
 =?us-ascii?Q?9DK9GVSqD0oPL9A2UX4E83Lx29gy4VcGoW3Ig0fTyHSRbnK7KvmTUcu+WYWk?=
 =?us-ascii?Q?UGtq8Lfx2CqOZ05aOZLnlYzDo2SmNBeVIQEA20O/p5SpgSQwxt6SClJaNe4S?=
 =?us-ascii?Q?jp2bHPVWqmy3aK8aRUtZzbtIv2J/LbSDGS2CNw7unJifpet7lSbE3nkl1krB?=
 =?us-ascii?Q?ZAO6bliyEj6N796YGIGmRf8PsmNHe9triTmwDuvV/HYGa+eomi0EnYtlmpee?=
 =?us-ascii?Q?iWwLPKth6+5Ryqf0+Ip2dNG7UaS+4ewFHo8JWR0Wbc2MlMCZvPV3QHkhkpuG?=
 =?us-ascii?Q?XRqNrePGA0rMEgKhneobR/ZQccjPYiP415d1LfyWFauBk4bdMFt/aRhHcF7Z?=
 =?us-ascii?Q?rs33O3VPKUoy3q4eMYoVEEl4o42iqNMkpTXgN3u+ugTuJhcbrEozJCvLYoKX?=
 =?us-ascii?Q?yEtx3sW8iR4cPUkcn5DZeBRlsSMGn5GBmtuIfBx4rEV7P/JXsQg112+oi+/T?=
 =?us-ascii?Q?oaL16Zh2FOuYQSybRNvuyPwk8ZcTdSGuPBzhF0gAIRIM2elEKgjuFwgP49nG?=
 =?us-ascii?Q?htNwWiTHIjRaMc5NXWFRtU30BD8CMsjruImfpPwreHWpnYZafSBu0t9YzcRu?=
 =?us-ascii?Q?6ETYQTOXhy060tVCq6aWTbNCk6fpz4Jszr8Lf5/PCv+VrIwVp4wBl2f7SDFa?=
 =?us-ascii?Q?kWcVGbHL0+lO4FXfSemr2c814jZ0N/VvivQSQl3iDLn+4SKKk6cU2gqrsvMe?=
 =?us-ascii?Q?AUoFMfXyE0rD75Ocu+pqntEg3IFdwNsesSLRgzHEQrbHSTBTyfEj6xrrR1qY?=
 =?us-ascii?Q?6plOFkmZ3mAmIvRSUhqFtxuwyfHl+7qQVFlDSlmyldOVfFTsOZNRr3bIe26e?=
 =?us-ascii?Q?s/C+xjbPSPcIukzjdtflDHPV81IRukAw0qLmKCCCewoppnciT11Ha22CT3Yh?=
 =?us-ascii?Q?1RZAr7akoiAl7iBeIvs0/wbc9MrBqAAqalxODQgg1Y/zkGcnFPc17kKoukoP?=
 =?us-ascii?Q?RX467NnJjPFgQWAtFy2Kgd2YLp/yWyXQNkxjvny5e4g9jTIrXwkpoI/oQU89?=
 =?us-ascii?Q?BW6BJ1Y0V/E/iSe5cag6eRJoV80mbs1hRUagzGxJYt8T84nb0417wK+AEDqQ?=
 =?us-ascii?Q?wupoBvOOUwM8UdTEmURV9J6xqhUpmQ5z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db59406-8ecc-4920-6673-08d9951b851a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:19:28.1270
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
X-Proofpoint-GUID: u7MvQBTI8INCS3GcmfYuDqq-kIN0x8GH
X-Proofpoint-ORIG-GUID: u7MvQBTI8INCS3GcmfYuDqq-kIN0x8GH
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

