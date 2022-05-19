Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C22C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiESAgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiESAgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4511EADD
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIl2m005301;
        Thu, 19 May 2022 00:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=QDo/JWbfq+OX9GrZYx4Y2+wG4QYGx0u8iijVeDScJvyjE2CIbwLXw597wum1nNv7PFgk
 LkgX1KApBM2YN6F8mEYqHTZFRIX1VNJVgVY99ZhYfTzxcrHfOplmsjK+TTTljFWqcBUJ
 R+JRSypOUOARqeUNxjgu4iMs2yHD81KMJHggDwcNAQ9RN2k7jJFBJpDZfQ3v+NydgiT0
 tjv1+BWacnQNFOqEADD5Oa7kZjsZfYYiqp2f/yZwzu92aqsMxXM7duVLJm14f+sfKhep
 fRYSGpXnj6vQhkpYJQyB0a43ZDOSRXzoKsFeDBS/FeaWFKWUbGXwWmY0+jGDW7CZyoWd wA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23723168-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VI015306;
        Thu, 19 May 2022 00:35:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6w3TEEpH2waPKAcx+Ks844w+TEMTDE5a4EYeHcafX7zRuwPUZyRt1vV2lt1PXENngiG39uIqmjpTTH1RAEpOwZRThCNgp/JLolPMmu7HVO+B+eoLN1QaJq6A4MPkfsGZoBmy1uB8ycwYFm5fI8MZjmjshbNyRJZf5M5vokdMnhL0K4fXPUrFzutd2MsWAJtbkm3Ne4jhSMc3qteKICTIEVCNmZB5gZZ20Yex722SXVf1b42MPZnpG5YFVdjrzjTfuMBn/P7LiDHWGsXSHmg+IWTD/BVoEjEEMQ+sEUbS3+59cRKL8mbhnBcvImF34MLNxaCTRoM2KztaaeEz9iCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=UrpueBhpkjh9FuEbjJN2Qqa/XG2igjghRsqhs2VNzsbxUoKFUZUb6YJSOmi0Zasb0N6B6raKo/CHN454cmyzPjDs+HqPM1vR/EfWyg41Z5sZ45n0UoPWlJ4UHxAyXN7le2FE809Edu1EX4/9XXl26YEKNdycyhOtXPD/g1+c6K5D8OM0fXZM7K3W79AYPLZNas04ukA6veOm/+NvgKYaDudqm6sjsV0yMulHltp3g1RbYGOGD7KEi82t/03jaL5oH8iRDfQnx3T72kF1TncLEEl02Hn9WcUw5hXJEn7wI67b/KMgxwl8HITjgmrJEaqmDsPF5rGcvRI8px2L7iEuQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=Z5BahZ1sQvDBE3qM9PfTB9n8rwVE7vOIw/nPZqYfgoUPBYIpxfGKyWTXmr4MoO+5ctsqw7EqX5AAevFBncDVZBcBoQYChmhM8TqumeeZAykE/9L9MToEYIrtNH88RrtzNN9RLcX2+1t0NCvGjJTkZJB1TAE9m9PMvKVDpjZLIyI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 12/13] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Wed, 18 May 2022 19:35:17 -0500
Message-Id: <20220519003518.34187-13-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01ff1379-6cf9-4d7d-7e7f-08da392f7af1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020D8D823BAC0CCC1186AEFF1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jz5h0r+xmKSiLBS9bpIk89Xs+HIu8rNRPNf3DjpO1OKMR0I03WqBw3eJmfbBe8KVx4oSKxQQvfJV1/Jra0dpwwNTRtx/So8j/jp8uXa4+u18w8D5qv2wEZ6gQ9uH5/ktr2BDuqV+k3zxzj4Cv85RSeaFy8HPC9RTB2MyBic8/wktttN/iF6jvsQF64obP2fqd7A6nrhVFNA5OeHCt4V8EG71xCdYaLY9+L4c2kiOILvFmXwAF6+C9duK29QfUsuJMrOEVn7bn+ggGjY+vJAoIIh/sOMZzRKd4D6W6Wnp/aPIrg9FSy1ahEqGF5voweL2I6QF2uVMeu7c9x/VNHbDcZWW+XKizw9mxu7v/e2IxTG8oBbFJVsrmMQpU09iEcTv3K/2bf0vwQLLzxeLCfubxjH7ShzpVagnFNvbxlATuJeqe8Ct3Y3pXm8z13I/LOwB0gBwbgAY8FSdq9Z35k4IlRIwPyX5KG79u1ROHCuCXJ/y78yXYeHGbXj4M/zdc4yAYvkhMDR+gbEdJ6lYtJ48DKq74wmQR/zpsSPx5IJG5pFi5AdFrGkzobtGuDmSLxa1/oFO6fK8mVhTzS5OKX3bmN+Pp9wJSCkqNWjK3u/1fu/EIL01YEdPRMWkS1f4fZ0sXzr31i6tiNwPe58sGKZS1amCj9TmAtkDOiHXsgyfWpfXHt+ivWS1wKXCbvxU4Xjs6cA0K9/5Chfa9ZigfLxIPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WtAPuG9eap6xYmR1/T+aGNd4SGigQ+jVcMKvJKTYPCBoWTMAC4NikgA56UMC?=
 =?us-ascii?Q?hue1Yu5LQek3r3wXDmeLWTaSzqj+HfC/SNSFlHDci0aFYBFrAnlwQZr4Xfq0?=
 =?us-ascii?Q?1IFk/NxiH6Ig2aJVBf6slfxRXKIHiovBXPdb7Sk2BZC+egb/7YxhqtgN/JQd?=
 =?us-ascii?Q?5qgjkeotj2yAIKC60M6YmWTKnhHsPHFIJ1PXGUC4OT1XPuhNU9fFUiDUN58U?=
 =?us-ascii?Q?HiYhUE5eHlZKqLRpBE5EQTXpY7oE56tpcIajZDO+BOIxkuzFrK+gwIk9ZHgV?=
 =?us-ascii?Q?JT+4lkvNwRfOsm3YvcVJ46L2OOmaOODb/o9vg2SpHfFDqU3C8TBJx97pIVC/?=
 =?us-ascii?Q?5cYCovHBavJOAjImmIaYdDKx28q89a4lPdvud+7ia6BHB1fkecOS5jwx2M9l?=
 =?us-ascii?Q?SGtgFpZqbEVGRwEeIxavlNwQTGDcwH23TTT4MQuzzKrUcrJChFym3ITXuLoQ?=
 =?us-ascii?Q?vv+kIxN1nm5CoF3fdTENsvORLoYTmqItsfka/QLHnXkWWLKOSRWscxZdCAz7?=
 =?us-ascii?Q?7qL6JWGmQQgzhsE6zJI/EPbopOzxQvVkS+23a1Z6m7Ua4eq8MQPjM+uUILbj?=
 =?us-ascii?Q?JpVuJODdWeDrVuNLoajBqfzfL3WgAfoZhUCweSCA8HUAm5yn7EO0mtC/nT9E?=
 =?us-ascii?Q?OOtNpomPhNGjeha+B2soaTg0Fr0lpRlKV6xTxS77mlH095jG5V+tHUNzAuAB?=
 =?us-ascii?Q?Z31asdTfyWGJ9Ms/KIJpmsER8W2JEyDtWysn6LKz4Sjt6A3cQaLdXb14wBcu?=
 =?us-ascii?Q?BqF8fNsu+0PQqJLMeJtYd6lGg96EHvwlYZW2Jhyu2mLMh0m/rW7iNl6RKuW8?=
 =?us-ascii?Q?timiiz8+YNEvdApHlzB5svCKmzCisjyDikMrZWBBImaUZxjiOdrDiUSMT+tJ?=
 =?us-ascii?Q?5y5Z5CiRFuG6fdE3j0wHheOaMrbBScKqgThdu2UCNuKWT49nAu2b8jZVcqtd?=
 =?us-ascii?Q?N6el7f4oyeTavm7f3ANpnQ+ihw3fD7jep6PkSQbwpdBucJwJC3GiRkoRmYxR?=
 =?us-ascii?Q?hiUwjx2jt66qclevmBI6/hRprfsIOCt4Koqsgimk9/LjcNp0ykbwRkyf6hAf?=
 =?us-ascii?Q?cHHjVdN9ORGK6xgukltdIc0vfofVcFOUg5ONkdiRFLteIIr4MzY2++kLcLO6?=
 =?us-ascii?Q?WEpmn1UWcj0A+1Mo3WwapruL13MiTqJBtdApg46YzD8V4BRXY9nJ8eWPmez6?=
 =?us-ascii?Q?dmExJYqw/3fO1tT8ERIMrCOwk8aLtJlAqnqZl7BKRasUVgo4esh4sg8fBlmr?=
 =?us-ascii?Q?/BzGhhDpvKGm3Pb+GlzkYGiywLXkjX6WpmIYFr/Jia72sYTfND9SL+ZIweLv?=
 =?us-ascii?Q?YlSkYlYyT0uPJQMRjbQECuMtliZr6WpbLI/ptfIrgM6FWIPIv84i9TL/A6he?=
 =?us-ascii?Q?ztj8NyNzob+I67UpmtY+lv0YOVBBOqWpvWFv/foy+qXVtQrQotY6UwofVuOC?=
 =?us-ascii?Q?F6K13rdFnje5FkyFbUFJ6OtWMRgp8nSQegqW+c2PUeKDgdhBrMc2WtrsXZ5f?=
 =?us-ascii?Q?4RvIle7Q8HHdwFRmcwkexgu/nYtyTTB4xj4TN/DiZt7aW2lNC9Y6jXpT4kWS?=
 =?us-ascii?Q?4KtXBumRSdFhL64++R3OvJbWVDcopknd4rxFl9H5bip7bYrvTzwozqmQYHdV?=
 =?us-ascii?Q?i4Dgrrh6HdqL+dYLQtr9s7zWUs5Kps5Z5KymQ0ObtKRkP0hcrk+HFkqe4iNi?=
 =?us-ascii?Q?AVoJ13wFQci+KYHzQs/BhLYWiE+BvdfCx3Us/7j0ve2dQ8P/1HQVpuArzg3+?=
 =?us-ascii?Q?lTTVcc19YvCej/W2qjjM3Jh96uEgkgg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ff1379-6cf9-4d7d-7e7f-08da392f7af1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:31.6176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZjaxsIrMekN0XbmBQTiP/IxxvyOivGN98cwtxAEIjG8WOpe7Yi/M/pD+tEZWLMZ+OsRyFBH4pifP3EKpH3Smp/fyzIaeURzSHV+I0RL8Ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: u8UKp_o7riO4wKb82opNdYIMAIyVxWQw
X-Proofpoint-ORIG-GUID: u8UKp_o7riO4wKb82opNdYIMAIyVxWQw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need the back lock when freeing a task, so we hold it when calling
__iscsi_put_task from the completion path to make it easier and to avoid
having to retake it in that path. For iscsi_put_task we just grabbed it
while also doing the decrement on the refcount but it's only really needed
if the refcount is zero and we free the task. This modifies iscsi_put_task
to just take the lock when needed then has the xmit path use it. Normally
we will then not take the back lock from the xmit path. It will only be
rare cases where the network is so fast that we get a response right after
we send the header/data.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dee6e2d5c86e..2bba10464cfa 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -490,6 +490,12 @@ bool iscsi_get_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(iscsi_get_task);
 
+/**
+ * __iscsi_put_task - drop the refcount on a task
+ * @task: iscsi_task to drop the refcount on
+ *
+ * The back_lock must be held when calling in case it frees the task.
+ */
 void __iscsi_put_task(struct iscsi_task *task)
 {
 	if (refcount_dec_and_test(&task->refcount))
@@ -501,10 +507,11 @@ void iscsi_put_task(struct iscsi_task *task)
 {
 	struct iscsi_session *session = task->conn->session;
 
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	if (refcount_dec_and_test(&task->refcount)) {
+		spin_lock_bh(&session->back_lock);
+		iscsi_free_task(task);
+		spin_unlock_bh(&session->back_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
@@ -1454,8 +1461,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 {
 	int rc;
 
-	spin_lock_bh(&conn->session->back_lock);
-
 	if (!conn->task) {
 		/*
 		 * Take a ref so we can access it after xmit_task().
@@ -1464,7 +1469,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * stopped the xmit thread. WARN on move on.
 		 */
 		if (!iscsi_get_task(task)) {
-			spin_unlock_bh(&conn->session->back_lock);
 			WARN_ON_ONCE(1);
 			return 0;
 		}
@@ -1478,7 +1482,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * case a bad target sends a cmd rsp before we have handled the task.
 	 */
 	if (was_requeue)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 
 	/*
 	 * Do this after dropping the extra ref because if this was a requeue
@@ -1490,10 +1494,8 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * task and get woken up again.
 		 */
 		conn->task = task;
-		spin_unlock_bh(&conn->session->back_lock);
 		return -ENODATA;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
 
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
@@ -1501,10 +1503,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
-	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
-	if (rc) {
+	} else {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
@@ -1513,8 +1512,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		conn->task = task;
 	}
 
-	__iscsi_put_task(task);
-	spin_unlock(&conn->session->back_lock);
+	iscsi_put_task(task);
 	return rc;
 }
 
-- 
2.25.1

