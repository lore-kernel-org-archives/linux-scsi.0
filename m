Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC91CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiESAgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiESAgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB78114C
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIm7j007814;
        Thu, 19 May 2022 00:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=N+JDVqxxOD/8Mn4GZj9iOxD0PhFfZsSptJKhgxE0/6vxjS+bjaBlsbCI+r27MtuqCqhk
 CotK0IOptqbngIur581OEzJ/GKcyqdN+9TRIDAKvfPjqwWwmr8CiDYz8RinKioymnuel
 FR+XKdIz+kjg4M2rZDAk78hZnXmoIOHD+Nr7Ib2bH9nsNO1GJcI7Euwgp1F5P0jlb0N6
 SD1pNLg7bSStrVz5XogLstIpMRoIHW4rIdVq1GB2qkpa6z93qDnv7/LxT7VXQTQfSdkt
 twwaL2N99lCRgH0qZ82TI44lwPIyZYn4LkKXfAHLpxbsAkNAYo9nhHeDl5tvL9acsPTu rA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucajja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VG015306;
        Thu, 19 May 2022 00:35:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEnFvq9dnkjdNN1+cEvhqupMRgrTymaXv3bsk1OLNNDnwtD3W+E33JBgJnUyotkfYyVKkFAV7JUmo+PS9VQLehfwzOgZdDQNvkisTNacq1IYIpwVR3uSXeyfjHqEMs6Udz8MaiV+YSPLgGeqo+/B9OrYd5TGnThaFuHtGwTvJI4k7kiOVB8czd6Vqc7japSF0jjzJTR3e8JVF7nXMvl/GoTZstQVdJ1ycDSe0n6YRzrC8l+yrIyhnkmugf8x6ztWjgnLdXjxwvFWDCsCfi6vDXCN0ffmgo+toraDkFYYJZ4B3METSSRokUA5ErcMzd96PoY8QwAgSjjQONG2pprLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=EOJTtZtevOvn6HdeVQbb6Sl66vB14Oe+6R1mMe0x0kU4z5kVCvXH/plDKiHKtT03O4OrUwhcHzrxMRxhF9jlMyukfvDd8xAXMbm5ZBTHt3u9BNUdL4bXI3EV8DEVMyJc647f6GlQHCqEukcXZkzQ69JMP2QS5WmfVQnGUSiaK42RBKLzhQuvJlcX6eMueKyGZyJZqOaAK2PDOAVQiULD1c0BjxZv4ugzyokvoroFnabAprFe7DxRspTt7qGDq/xxcFntJ/MNwzH+JGeM2mVya4a6pmAxiMGsfIhc+joBauK37ZG3ZfIcDX4+6Rs+6B2qvT0n2issbNW9/bvH+zx7LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=GNqDNfBsMD4CdIqn+/ZOK3X7/hORoxAd0iYRVT+7XXgEmRNaXNPs2sswJNMEeGqMSUVKbgV/tzRG9ZpGwjOVcLKpha9ZjN+EH61ye4KTOSTP1mg9Skoauu5NDIt+M9SnlaM5Orjd12QatvkxLl3AXE/bY4jsJqFqMqkOxJGMdQA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 10/13] scsi: iscsi: remove unneeded task state check
Date:   Wed, 18 May 2022 19:35:15 -0500
Message-Id: <20220519003518.34187-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19c9adfa-5de6-45b8-142b-08da392f7a41
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020CAD2A5EC2C4D73F6648EF1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mrUmrGOB8+jeT8xTV3FG+Thpb5b/Sf6KuNtDdmxlWvsPW35PW0wypmiZfyrtxP9Xvt5zpOqfupb0kyD8F1slVg53HcX3XkVi9fp5OBWqScT8rwmJbmk0LW+wNgU53rQBAAypHl/junzKziYQ2j41HbyfVs/YAt9GYH08klM4AFq/nxX2ShTaWPtA3yS/Ah6jbRLo0jM+PKe6oZfrGNev2nWS00/Om0u/ypA/WfRoD7p+DQVQdcMhZp3cfXiaHZUia+q25EoYZ1EwNUl3yS3QMlXCE6FRj9PJCXtqNTnX5kIN/cu3ZmwUV9I3p/zYW0cunnoYSZiKpL6A6aLyQUWbOUYV61e5Pz5Xf0tGfolNMvxbE2OzaVmTIOURMXaclj89K+56m16QO4xLVH255JbmNVmht1vQEO6AA4sCDXySC8kcGCRXVTnt1aS2QZiL91VY58NEEQD32DvPKlU1paQGsYH0PQMQv5dtkJvB7WTClpwjnubaLosm15n/5IKTgF1cYiCeEitQRiZmBYD6B2Puj9VVa/vuFQpSI/6r4OErcoioHFPdmp4nX6GVwqncCXMnexoB32tr8wQqIDsHxkNwgTFeJWah9zLOVkV41EWfQr8y3CuJAx4+Zghx0As/eaUuUi2rvngAEMRdpvlBbbZS55CiBiqb8LccP8KVs/C9Hs6/9XIBADGOm2ONdlVbMokR0HBBMONo2O2a1xfMC1RwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(54906003)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xmtmUxW2yOm3k7WbFReztTVbmtQQcbBYHRW9KzVxvp5zZHlcUWKF0WLbRcGI?=
 =?us-ascii?Q?vdJHgaTsK0qB2EFfIEDqY4DntgjF7Vs4ryfOL4zlODZN1JCrtzsxxmTzhp+i?=
 =?us-ascii?Q?ez8bOTu23FBw5t1/elTWYnRIBmJQrWPF0pzRAgkYVRjQBqdSJbt+5MYkbk3W?=
 =?us-ascii?Q?bGTjYCs55PUj8CFABWqxPIAniHrlqWt8KCeW6PMfJ7Vk9Y08jG8SwDzp1RO9?=
 =?us-ascii?Q?27i7+b7bmUHlZLwAWH7S7EocMHma9KFpb9ROf9IHOZU7vOHPh7FYTGm8uLQj?=
 =?us-ascii?Q?hG34qYuKx0rMMVTQi7E0hv17Ic4T0aWLyDvAhoz0+dB3KytNtzmVQhyLEoTz?=
 =?us-ascii?Q?ffCJAHmJMooBUOYakYYWR7D5VBcmIfipjXAkOu8kTMfcJ0KXgfUcVuUVA141?=
 =?us-ascii?Q?dBASD0QVF4ShdL6IBMGWWLMyYuN9oHtpiwERKaq47y+jkkqprPV871liUMX8?=
 =?us-ascii?Q?6GHp4jdQSnK/Rojt4t+FCe9etVefIgXk68L0Q/VfaHEJwwW4cum/5stbMDHA?=
 =?us-ascii?Q?Npr/nkKj8a5LEsrDt8NDkOLocPRG3TJczFvksz+FzWsmqf7863hpTnAMcd2V?=
 =?us-ascii?Q?RBQQKrA0JyQcV9AGtk6Z6TqoF3GvdxAzU6/lEGtzMxlOLPDU32dhtF0UUOIN?=
 =?us-ascii?Q?xuas7C1X6CJFr6LGdV5C8wmc44d0l/IyNK6hzp3HiTXhkduZlP2g+r01e9+k?=
 =?us-ascii?Q?At0NJ/kqvKY4mFYY9IKZylGtinu4Iifzh9LCESo5s59bGXc61NvByBGZNV7F?=
 =?us-ascii?Q?pDr0tVte/1sJKKuDHP5Aog4SFQqQK4BxadoMYr+3fTPa5hCWXwZ2Q5cC+/iO?=
 =?us-ascii?Q?7dntMQaI9SDxYESw2T7HsPz1ywKmGjXYHXXILn6GrgKGtXOtYeyP9gAhC94q?=
 =?us-ascii?Q?1mBjLvST/V/bfE2xGSWH8MOeKU6mXHR/enMaRW9/wk5Z5LtahHI7fAinjxmy?=
 =?us-ascii?Q?1kuLCtVFdt2O1j8AW8Icqn44TmD/6RhHLdQ+bgq8YYv5rRaDDWBqcSP8ka5Y?=
 =?us-ascii?Q?kJNY5d8uUWOLhipYXCIgVBG9unH92Ep+6Zm4DRHOq9s4HGa4rHAhupH6TVxQ?=
 =?us-ascii?Q?wQlG0IZ4mRuJwZTvfFE2IuDwmZzGzR2EvKBHrYYbgd/GKJYmtITgmNNkzzzK?=
 =?us-ascii?Q?gshxZCsFZvTDvzXz+8ANEte2QBy6DY2/Nvp6ApvGiJqmHHz1NEiiAAMcDf2N?=
 =?us-ascii?Q?p0g7qRdtwDKAErSZ5EmWt7sRVQ+5F4sbUKr4ZDFeXXbRMtH4SUKeXoM9Ty6I?=
 =?us-ascii?Q?7Zb0tNS1sIguZIeuIvpd2Ng7QJ4WJzRbJyS4qiPxYTxKUwmVnBXw4J48lgWL?=
 =?us-ascii?Q?/yEL1mwKGmkbsKBlz6D8YuP9YEdkeomJZ0nl62Hon59qsIxXQFwK3JjOsKq4?=
 =?us-ascii?Q?WcFWMhAdjzFDuI/QGVTtdLP/6dxhLXintn+sa2Jrxv7gi1IIshEMyOOsnx5E?=
 =?us-ascii?Q?XAm51/hbGxjCydxPDGFpgcelvepSSFG3v8DtDkCgVRS6Iicp2+vHHTTqRlyY?=
 =?us-ascii?Q?cpiGCc0cV3xNAQVfbh/XAKbHmUgiFKzUivOOWOEgAlEeoNxbg3vLjrDGRrOv?=
 =?us-ascii?Q?vpUXkR/7GSKy64rfKyr98fZpgf6uEjAoIjIKa7gRZsqyIj3ZeZeZbf6MCRKR?=
 =?us-ascii?Q?JHqxQUhxPWxQRox8kToBmMvmYpJkibxwu8Y1mPNdleVKkGeCdYOcLM37TsWq?=
 =?us-ascii?Q?hMKDhgULsz/R5uTXT09WGn6dABRweJYP0jXLZKVUhllkJyBKU1jx6DOuTAnT?=
 =?us-ascii?Q?wJ6paeKHvHOsRbBihWpeqjk6XCfIAJs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c9adfa-5de6-45b8-142b-08da392f7a41
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:30.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BG8gnvLGrSPlhemK/whwWt3Pspbpjq5OWFt735WMZ0fnmpeCETkR6ac0HlF03D9ZPgkGhHkhM7uDx8CjyZPkDsRaJD+lOST+DZGvWu7lK3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: cr7Y1PD83pcRUM-MDyiMM2uS9FbndTos
X-Proofpoint-ORIG-GUID: cr7Y1PD83pcRUM-MDyiMM2uS9FbndTos
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch:

commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")

added an extra task->state because for

commit 6f8830f5bbab ("scsi: libiscsi: add lock around task lists to fix
list corruption regression")

we didn't know why we ended up with cmds on the list and thought it
might have been a bad target sending a response while we were still
sending the cmd. We were never able to get a target to send us a response
early, because it turns out the bug was just a race in libiscsi/
libiscsi_tcp where

1. iscsi_tcp_r2t_rsp queues a r2t to tcp_task->r2tqueue.
2. iscsi_tcp_task_xmit runs iscsi_tcp_get_curr_r2t and sees we have a r2t.
It dequeues it and iscsi_tcp_task_xmit starts to process it.
3. iscsi_tcp_r2t_rsp runs iscsi_requeue_task and puts the task on the
requeue list.
4. iscsi_tcp_task_xmit sends the data for r2t. This is the final chunk of
data, so the cmd is done.
5. target sends the response.
6. On a different CPU from #3, iscsi_complete_task processes the response.
Since there was no common lock for the list, the lists/tasks pointers are
not fully in sync, so could end up with list corruption.

Since it was just a race on our side, this patch removes the extra check
and fixes up the comments.

Reviewed-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8f73c8d6ef22..72ed303184cc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	bool early_complete = false;
 
-	/* Bad target might have completed task while it was still running */
+	/*
+	 * We might have raced where we handled a R2T early and got a response
+	 * but have not yet taken the task off the requeue list, then a TMF or
+	 * recovery happened and so we can still see it here.
+	 */
 	if (task->state == ISCSI_TASK_COMPLETED)
 		early_complete = true;
 
 	if (!list_empty(&task->running)) {
 		list_del_init(&task->running);
 		/*
-		 * If it's on a list but still running, this could be from
-		 * a bad target sending a rsp early, cleanup from a TMF, or
-		 * session recovery.
+		 * If it's on a list but still running this could be cleanup
+		 * from a TMF or session recovery.
 		 */
 		if (task->state == ISCSI_TASK_RUNNING ||
 		    task->state == ISCSI_TASK_COMPLETED)
@@ -1485,7 +1488,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
-	if (rc && task->state == ISCSI_TASK_RUNNING) {
+	if (rc) {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
-- 
2.25.1

