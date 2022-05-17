Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A44AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiEQW17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiEQWZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C2E52E62
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKgGlf031659;
        Tue, 17 May 2022 22:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=bIl+4Wq75rY/Em5/uUCCh6NrLgWtE/wtqF3HEG5a2dbW2pPPDPUlPaNcSVkBMCpE/MSn
 ecAZv5h9Z763yb6CBZBZPGOOGCySzpq9S4444Kw87Pk2KcGo3EnelRteepPR84GR2Gj0
 gKIqlse5dJCF9Yph2k3B7su3Ftr7Ji0mhfP0h/S3vJghx3LOO1WXtj3oao9gei0u0K0E
 carrjeyCcxAYD2VSDNdB5cH3665NjRbWVNQoibkEZRcUZ1LRLbkucMIDH8CjMLM/uwTE
 M+1droIzQSBIk9vgPIOYH0fA/g/qkaukIAV2izC4a1vbjh2a83xmUuKhAuJodz3yppx/ ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafjgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMP12H008394;
        Tue, 17 May 2022 22:25:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3m138-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCOmXuivM4cGWATO/V+n9fSH2qaKeW68hF+Xw62i/r+eYiS/BvW/ASmWb2b+gxf3P+jO5c1b6/7eZHlnZhLhwGGy7Eo+3GvByl8VF+X8eY4dT1i2am+zXb7b25KxaNb8shXln8IpcKlnGw2twUZZMxS+iitilWiZdEWDiH6/JHyYuhfv4rQ3kXdtAKkOd3BVTwmt7xJk2UlMNogbuRodo4GsckP6TBplI3/itaBf/7BQfZoyY5eIqPYOpGix26J9mdPZri3pTAa5JZ/K3iCbxv2PL/x66h0Xav7zbBkDFpXYwcWs0eNVivumne/yR4pDBh/IKTT9AeSDlIi8F9uAkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=GIWs0SO8RsyYFSVTKx6m6GELe/i7zjLRWIDlwiRoB5WQu4L/yJu6f0912xA1E+DNVIKQGbTLh/kTeKkdHV2fTEf4FsLsAXViGKM05cBpnDo/NGVT/QedKqzPwvu4In+495mjLyrD8RFBprxPAGygNdr6DYSB4mruxgWQgyNljHixvpzW21L+qpDclW1UOMNXem9YshiVFmlXJ1pHwz9NOP9oOWy6UEfqqBjqubQZ6GdRPyYtrrMv0rHd7lf7syaJgiucIie9KaYf3pHimCKYfKFWqySIddPHhofmbVCt2/ikMQ2zK7IfM4zYiHLNvZBweQuHYMIMkacQMQ/IQu9vdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoLRFYwtfYXgqM94q+LtOcUNb1/hmHA3AWS5gnAarlU=;
 b=WqQ+M5Dwcb69KYqTLoRkgk2mfnm/zXW23RNHuhHeZ39HjPD3r1k5epD8Vxkd02unU0LvHcK2OaGVQ9bRx6hKOAoaZz67qajRiePNZnOR3pI46e7KmGcKrUWjeqmxkOWaS3PLETtzWqLkP+Xc+54ezg/YXx6r/nD/+glpAzXgT0M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 10/13] scsi: iscsi: remove unneeded task state check
Date:   Tue, 17 May 2022 17:24:45 -0500
Message-Id: <20220517222448.25612-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4715473e-76cd-40b2-dc5a-08da385414e6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB551723FE98F9AFA153F06EC5F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFDWte99rw8rqha4e17b8CSFedM0Sn9l+rQnE20i32nvSgKwT/WZxGKtTWsuI4LXU8RNzPPZTecwhQnk/3JW1b7N0egRKBXFLQ/L/SmmnvMM+EDR83EKTkf5REP8OZrMH9Gkp3+gPJz27PyKLiwV3KNnEoZvINw3Qasas5KvSfXrDW0R28JZOWnzxvF/9AbziHwmv6b6E4uWzh48ejS7mw2xjyO6yerR6tekPQsy8FfGszLkNp6P+cVfngKhdV+CyA4eEexkOByxUnBZ8k1j5P+Kj72TjOLtFFG/eZfONny4avqw92g3PaHwBZGkZbHHCqH2IKU4asQytcHyTFq2g7T5nRUvc/jUbubJxAOdRd6BTdKp9qi13O+2IBzDC5XK/BcIaMTyckwk+RbrXZuqCpxhc6H0Ym+6jhMd/82irwueAR3mrb/ar3uYl00ImzVNGfAd68Ffo2SnvdKZgRkv5dKw2pTuS7eIaiJ9Jjm71uZg3G+2TTIZ3xFlKvdiEjyVDJ0lBmun/Af71beSrFSQepOMXHVa0cJwQws48+5F379ndtHNIwknuhe8z8lPfzOpWGJbR/+WvSuPVa9PAiqNon6FqVop4MXOB/Bcv46oRUoiTcQ+s7jC7f6iYkd0RBSXt+ND+tcpzdj4UjdKUSqtZ74xt7GXv7dh+ie1w3efvkasJI1LmEK51bQRv6ifIzeM2ZKDc3gMPro4cmAr7/Fn5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(54906003)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3gWYiIltPuV0eFHAs0yrJuAieB+wbVitXnwzA1UHpxRSv4l/iCbkKLDe42Y?=
 =?us-ascii?Q?IXzZR8xWUTYyRsc+4R3MOOawf+qw7ewLUgKUjzX/Yr/mX2ht5kze3Vz+LSp5?=
 =?us-ascii?Q?eD8BzunppQ9k97TM7vvf4zutdGz5E59fJNJp+1xevhOH2T8NkJ/YUazsz06L?=
 =?us-ascii?Q?sKz+SLgIudUf+u+BnnrmcuIgvL3YnfgSVEVzICYyvYiy3mLqUhbiRpfj+MA6?=
 =?us-ascii?Q?ldIuPGQ08eHn84FK531Ato468etIBIs3siWkTaBN2VEML8YFK7UUG9BwAzqS?=
 =?us-ascii?Q?K/ZZ/BUIfZZ38jLAunHCJsgneyxxJMB5jKS/k5uxt5oEUOHpZbqzDqXpBIjN?=
 =?us-ascii?Q?ijRFpklD5ml65Q6VsmgaL7L74853A5DV0lE74g++RBrKYCrhZ/+7o9f5a/Yh?=
 =?us-ascii?Q?VEi+/c/3xnJXbioQlcQYSVFLjovr4oxojM+k+d3jBD6bBx9pZ/vWfpQBdyfo?=
 =?us-ascii?Q?Wq18EPCN+sJ8rva7NaOxPZTYbpEIAv0FruUAAzv92sUGVgimzTvYIATfzcw2?=
 =?us-ascii?Q?m8eM3ZLNjPFfCBIrI/0cOnMShKvW4gIg0tlMFHiBvPrqZuISGFRuYgZWEOg/?=
 =?us-ascii?Q?NZIi+LI4yAVsaMB4f65of+Co+LPYhdDoZ+nbXxW/iUyBodAALUpThUaI49iv?=
 =?us-ascii?Q?txfLmBKt0qxnn/2+KzRE/iEsDAim9m7qNTZV5F/cnl228Rcz6wOXokWLY8ei?=
 =?us-ascii?Q?V/NqMR6fLQLRTj57DNk0RW/Jfe9EdnMapqh2zjTdu/UyqKWuqb5xMq431cTf?=
 =?us-ascii?Q?IUJ8OvbSPbN1/4fy3eZMjpIvcheFfZIw1EKbGCKSeAJkhEZbRDoL2H9FZkyt?=
 =?us-ascii?Q?s/PEKSVfio4t2PL8ZRTN7TLIeLVv91XPq8/p7Cc9U8/p9mE3W7xpVzqmkL+P?=
 =?us-ascii?Q?0fnwhzogn5Ky9IyIH1Q6hrFQTRKw+9LE/QlK/2f35uAb5rqDi6MjDE5tRSvs?=
 =?us-ascii?Q?vqE6oA5c5lhQ0/jUYdhijdYMqt7/tnenGzFWQ+8iCqeRIgydeM9iXD6/WqHS?=
 =?us-ascii?Q?76wBAJUTrdiQWb8jnfnf3wSgo2kjzwAFD79LAnq0Wk6uEtmvDgQIpx7FZJ2/?=
 =?us-ascii?Q?/Ky5aCMthXK4SnzV7F+3oTZR1U1M6tLv8FALOw4dQRdbzP7Fx531QfaU64Pi?=
 =?us-ascii?Q?qVOSLyL19/W4DIQoxuSxfw/B4HjlNCsnPg6s9+b8YYOydFXWzVF1urtAIlbt?=
 =?us-ascii?Q?TIisyEem0gigfSonztG8ahfSI149JRMAU9nKZI2xOAHGxHqPmy10V1Zu2QAb?=
 =?us-ascii?Q?E63AtlpDkVOauJ4ObEcb093Jor+joZZZBbr0xzQjClJHwYWOXt1j5fvSp0JK?=
 =?us-ascii?Q?WC0xEk9mc2a0d/Fo3NG03CQ1D4Q1JqoXVnSKMgbRZVeW/itanIy4Ha8964vR?=
 =?us-ascii?Q?ENUv4S5JsXmxN6nx+5kV5F5S6de4Hbhxz5lxf0cxy9YjIV3Ea4SjZz8nocZR?=
 =?us-ascii?Q?qCbDNANcyxXnxj66xnPdHF48/xFBqA4xMFSo8YibHjMtp6mpvHetXYJxdz26?=
 =?us-ascii?Q?LxpkZ1VntmvTLltcIa5SAeNrkchd4UPlXg91Hqd8c/VtUKAgcr2lMuIKJFNO?=
 =?us-ascii?Q?k/7qg6aJ7dGVoDz/QLK6ZuMEcJ5f67xvekfQeLqtivIoCY6bZTCggdKIu8gl?=
 =?us-ascii?Q?9fk1IWs6p/7E6JgZzotXQOhLDMI+zk2EscJdvVrQ929CJnSf/pYmbPWWEW6M?=
 =?us-ascii?Q?Sd/BIJskmsxKIG2v9SEei0MidrYTe5m0aCfNaGyw09JX6NEe8CQ44bA3aS4x?=
 =?us-ascii?Q?G45v+YN6kucNvRiH3oNOxrf+32rQzX8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4715473e-76cd-40b2-dc5a-08da385414e6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:25:00.7303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSvwyW5VS1+Yf3AX6yhdmU303w8zwYGaEAugOX1TQTwat2cbx4npQbfW2UxlQsz3gV1BCaxazqzhrLH1SAzPzR01YImi25I9uWYcrxa6gKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170130
X-Proofpoint-ORIG-GUID: 7MnJb9d0jkH4OB6j7YhpGopCRwv7oJEc
X-Proofpoint-GUID: 7MnJb9d0jkH4OB6j7YhpGopCRwv7oJEc
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

