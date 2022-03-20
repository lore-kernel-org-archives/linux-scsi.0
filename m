Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21C7C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbiCTAqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244491AbiCTApq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB5C241A0B
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JEhZuv012459;
        Sun, 20 Mar 2022 00:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=G/x9rCYuQmcNZaeQxXNKcCHd2LWbuTuyiAqHrcqM1yI=;
 b=kBeHw+T4BRjHlTrF1pdzP4uRDq89uveSRibddONg6VQTJ9jHk91W3GSEflqeEiHMvwLT
 KVZ2Zeuvq9Rc05/5ZB0haLSKPYoj3uAnbxDnncAleFnH+b0NIhWiJghopekBKMmewOad
 CSSK59s8Ruj0F+efZ3g22KqyOmggeE8NV8KCUC2ZAf7iFVxfzmCkO8btdst83EMgpck4
 bLOL9mDB4RsmKQGkhtVDtgfYYduzigXBkJeDYR1wzOFbpbyT5cm5TcMAqOL13anuwAKo
 LUTzWf2gZqHjvPG2Of1zHJbV2MzFp23GZmiCLDpfV/UofUlnWNY/diBe2JRKuCPByZCg zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss0ux1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffap137063;
        Sun, 20 Mar 2022 00:44:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzPgD/hvHkS7yHOHFLC5/vDvU2j5M/VKs5UM5gWkClLCaJMXXWQTGv1q5ampDB7UuvzJ3u3qKBSX0XPc5HzHNBgHGErIMn7q18qpwmq0iTAa46IJROViW3xRw6qhaFBdH4tdfwWlgn94iK0jXELSNSv+PrctNT1RT+k3VISi38lNrnJ4AfFXB0qXjUFetlZEF31nfLvkggIQP7ESdCG19Xhxmi/1n2zkLnx4FEgHntEbZtyNFWutyM1jcV/wjSuWrmfGR3JY1mFsKxEkQOa2XPhW9wIMHiyBWaY23DGLsdOtfiqukzb2a/hCf0vAFq3JPCdpB41M5/WRL/m61TB7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/x9rCYuQmcNZaeQxXNKcCHd2LWbuTuyiAqHrcqM1yI=;
 b=NJWwW2I487xVSiATuRZG2BUxjCNzk2ka0vrRkOpaSAPW/puArvNoMNK/NSl6Bn/biaTjMoXd8qDg2KkPoXxicifgsqqCdAhhFe40ly3MOgDxunUgoXNd/m1GyJiPj8ClNrni03mCuXEThkd5AVYrq6X3m+hTXDYr85M78WHZNp24rLmkOms4BCWmZztfcGId3RTd1ZzPxow93nRb5+aAV9l+8FRgYds1fk/Tz54RBZ0Ivyq/NaeNcJHnTEtmxaoaLo9YQ+IP+2hzr7axi73Jh41Huv4G+Knh0dL/ELHw9pBsLXoWKA3WvXRQoyfFLNyPqFjrahED2eKVb46UDfLEAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/x9rCYuQmcNZaeQxXNKcCHd2LWbuTuyiAqHrcqM1yI=;
 b=F5oAVBMEwm/I1ZWHmQ+lBUKjUsXr3pgQ/PUfvPDYuoALQq+aFRYQmAxVNqsY/zlfBJmiyY1DF2jweXDXm6XhZYqIepRAtII10p61Caf9rDvSOrV6S6YtWG/3vshmMmqkXvcs/zv8XX96jn13nUuJ5K7z5wbuqWvNANu0VhRRGDQ=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:17 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 10/12] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Sat, 19 Mar 2022 19:44:00 -0500
Message-Id: <20220320004402.6707-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f267ef2-76e9-4146-a805-08da0a0ac388
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992C57650B2F540BCEFB01EF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLKnG0tbB3RJBZItNVvJnL4XXWz0p9SGH/VTpFeNhLYSyCDEGe5r7qHaMBz8ho656YWa4CE/BXW+gj6EiTyXSYBoFvBPiDeDScF7OxIpKItDRWY1BTUQ5LXxNtpjqx48DTTdXSv0IKKqWZGmLfS7tMnxt99j0lZZCKRqR25ygRyRiykiD472C2FmVB0fRqCzCOPw5L7ckcP6RrzDLJtGdNfFNTOdHPycW3KicFjY7td8tQ4Ghw2md3Gv25oVCYXHZdYEcar3c6OGpqdrypB7aCZvLocKeUzmaSDgM1zGpTEOLQPnqW8Va/oO5AEqBGC615CetS8g7BthaWfyjM8bWFnA4+wkSLsBercT+LHac97xr9V8H+aoFKu8GnWymn9Ay33O3dLnMvBdgst/tqLyLck3xc99ToDde81FZpil6oRhQzHGjSf9YWp+i0bMqjK2FJMyCgnN6EBiR7C/6LAxmIo3el3DA1IwjMDsdvmrD3iQjeVt5yzH4ajJ6EzfBWFLNPyApIYbSybQqZ7Zocg5QuAMbpWOSaKmv/rD6IWr6zjk78+lG+mwAKNogwTU9UQbvdGnSAYXXQ9+ta5jOD/UEgC9mNZNKRehKK1cAArjvvQb4Hp8ExjxPWu9v4T1HBu3boUIwwAAFcclwTv3dlBJJqoMtLJBWzSHq43p+iQrrlUARdK93qcvVjVZ9LJm7MAN6cmS7JmsFyV0dnF3G+QhLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSgR4IRPdUptODVMDqwzJUvjuTc54UxYYIRZbA1n9+XvP7pVirM0vv4bCPNR?=
 =?us-ascii?Q?0VXCQyLsbHxLarD7FP7tjlFO3cXf4nVsBNF9hQyjvZx5Hm6XlVQkIFvMXG9c?=
 =?us-ascii?Q?4OMDI7ffjzD8L6vyidltprsIk9+S5iC0MqO1eDGOXPtjzX0JUCOa5JYhNPKC?=
 =?us-ascii?Q?dRNxQuQ4RcANGC5QiucpPxPzTlFMTjfnnq8LrTYHzvlFvtvvLu9ktbaZyTV1?=
 =?us-ascii?Q?takqG1rIJXJCEmJ2xF0IolYtx33hWDz2pgCaCsrOOxYh2ICwTXgpTW7qm22v?=
 =?us-ascii?Q?baw+uNMS488ErfWyx6hW89t1xa+jQg7r/VPvWPXKlZExmk4ywsSKvS2bwnnd?=
 =?us-ascii?Q?pj0CXnyuU5tsU181WLEQHRq5ot9W/r6WEiY7nXq8LV4zomazkrwO279zOEdg?=
 =?us-ascii?Q?u2u46SlOzb30GK1FfRwJBsJxHpe/odsIxbM2IkCvD5Avsxh4cKeTMP9Q1KS9?=
 =?us-ascii?Q?OWkI77WsPPBzeE2KaskvI2JefAiYWbThOb9OWojFf2/mOSzKh5tmFLNnaZyk?=
 =?us-ascii?Q?hMr6NzfPyGVsrVfuOM1g4mm+bGqFh/LGMNOUZ9SoxNxnSJ8fOMrnuOxBmYRd?=
 =?us-ascii?Q?9DRHUuIoWR2JjUToLhpcy/LUtEf9UKzYgCkAEXpSBi0u5U720VcC87cCIjDE?=
 =?us-ascii?Q?FUKCyx+naM5r3o3KQLnJXteCF5DorJ24by6QHWX8Y9fbpxQ3NZb7QvosSTYQ?=
 =?us-ascii?Q?E22yjmTnm49+PcGKLXytOFcS4mRt2sE20fsY8GcCtwJYFonhaTXFc9CMP2H/?=
 =?us-ascii?Q?G2jst6S15z8Ap70cOP8bET8Hw5aZZ+VULa1n1L80gRjcEYM32ej37Yy8YE/4?=
 =?us-ascii?Q?yfanBtbyMfkppzOz+mAvmR1Emjj+rgRsg1Fenb9C12nL9qjEzd7saqZhFN25?=
 =?us-ascii?Q?+ATLM9Xi8/YPEhTxpowRiL57p9lcSlYXOp9f9mES6pLkXbu2QrYL3I+DJJ8n?=
 =?us-ascii?Q?i9msb5njRuiAELAii3aUHwxgs2jAvSFJpgq1fVZafh0r2qTNNXDTI15/TTtz?=
 =?us-ascii?Q?ssMxIpYVUJn1h9E/t1Kd1jW5rfaz/KUe9k8lnAMlZncONe9Aif3pw+ccQ9lQ?=
 =?us-ascii?Q?J3KCT6NI9c/QoYGcu7a7lwn6+q/2CeQ0S9NVNXA2g1Ig7nl20un594jRHG40?=
 =?us-ascii?Q?vtV32CzYnB4poVDJ0aRK7X9/U2O1vME9xSLQFfgyq3IJDlPdEwpdxRdWg7q4?=
 =?us-ascii?Q?vDq17MLThkDOWrm0kmNMpYruq3ayMJAGQtwZjtD0+BRcw9xxejvp1NPkDICi?=
 =?us-ascii?Q?f4PnJdyOK7++7OOe/8JKtJ+La04gTS20XVMEf+O6i7hIp0ZrNojg954pADjA?=
 =?us-ascii?Q?gdtEzVTYjAqdAWLEnZjHmE/hheROpMABvm+/3l6Nazv8U9YZaTAUYWXEGvxC?=
 =?us-ascii?Q?cTpISj4V1xTwpfxcR8zVcP7DqPB9gLm7x5xC23f3uY+Dv0M4HrVa8Y4G4eCj?=
 =?us-ascii?Q?yt3lJSZCcw+s6ZltI17t2TbsdRtL0YfOWb/q6cHA6bkxxQDPytE9sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f267ef2-76e9-4146-a805-08da0a0ac388
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:17.4841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTOLbCNJMlFnh9MLxZxuW00dfyy8pkWmGPllybiPfAP8v5M874gZETZpsoxWjkbfqvtd4Ts9pcz8aebkaF6BMXyg8fDX0TGBvG5t5no6XfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-ORIG-GUID: t8PzUdjIvB2058PpfFEaEBnkxhoQOiPl
X-Proofpoint-GUID: t8PzUdjIvB2058PpfFEaEBnkxhoQOiPl
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
index a2d0daf5bd60..cde389225059 100644
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
 
@@ -1453,8 +1460,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 {
 	int rc;
 
-	spin_lock_bh(&conn->session->back_lock);
-
 	if (!conn->task) {
 		/*
 		 * Take a ref so we can access it after xmit_task().
@@ -1463,7 +1468,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * stopped the xmit thread. WARN on move on.
 		 */
 		if (!iscsi_get_task(task)) {
-			spin_unlock_bh(&conn->session->back_lock);
 			WARN_ON_ONCE(1);
 			return 0;
 		}
@@ -1477,7 +1481,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * case a bad target sends a cmd rsp before we have handled the task.
 	 */
 	if (was_requeue)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 
 	/*
 	 * Do this after dropping the extra ref because if this was a requeue
@@ -1489,10 +1493,8 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * task and get woken up again.
 		 */
 		conn->task = task;
-		spin_unlock_bh(&conn->session->back_lock);
 		return -ENODATA;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
 
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
@@ -1500,10 +1502,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
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
@@ -1512,8 +1511,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		conn->task = task;
 	}
 
-	__iscsi_put_task(task);
-	spin_unlock(&conn->session->back_lock);
+	iscsi_put_task(task);
 	return rc;
 }
 
-- 
2.25.1

