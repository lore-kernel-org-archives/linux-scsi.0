Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE62AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiC2SKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2SKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5639A1ADA0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsmNc013396;
        Tue, 29 Mar 2022 18:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=IW1mzUwcowJ3d47nka+SUJO3AiBxgKrMZZEnTf7UjF8=;
 b=Fko1Dcb5TNC8It8Eh/YtaFo4v7ZitlxZjkpytXcyE1cmhMgkalIXyc35oR5VrrS+bZS/
 y4bhc+GO2k8qEzN/Idk45VH/Mxn1JYqHs1rR2ti60lr2ZRKGQjmBD3QkRfh5Ooi6XgCA
 DOV01wNpPD3V8hPX+F2G93s5ciHciL25LRD2HalPasKmRik3YnxOyHNNnFjLr26vk2IM
 1qL1mshvb5/514L05OzezqrZ2XdJnJpf8rS+145dHfVQ5XFIH6BrUccHSjAmQWYB2FOY
 672RytW88ceYUJAtqByluzEhfGsLnB0z+IYDHpi3BcNnBiSz8j6PCsGtjtsO4FGxmnD4 pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1uctqf6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THw2uJ013210;
        Tue, 29 Mar 2022 18:03:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 3f1qxqfdqq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3MlCZ4MdYU1OcrYB00vGHREEslt9EGt72egcFNbcWoUQho5J+nqcjx75Y12RGlD88XRrCb73mwK3PlC6Fu2inglrvMteNowMEKYpCkugBS8zA185fDj2/S5c1odWFggUvCHnOF6ClE+ZgblRVo2h45iSAuqKFsiq2aJBxN4Ynm6Is5N3RsxlNNAEI2g0Tbh0IHrXhmIZkGr1P/wwoxs7PFV5Mh7PCnyH2sJuk1bvdgPcKoW9dD7nr3o2Bl6GCosRq3becIEpmRIyz6KwnIqjna348mxmWcyvVCW99hrKX7hMsLfs2UaYkI56Fj/5XKCEKcEzF82YLxGTU2hBdHEXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW1mzUwcowJ3d47nka+SUJO3AiBxgKrMZZEnTf7UjF8=;
 b=At+F+O6jyAJeaJCLHabIy1S0k439wy12GYHVoqQSRCPvb/2CizntwFE4wHxDWek9izQl8BE2gqTgGpVFerr9vxCvJ6iofvYQR9eGP6MvvAs/oUjpR5WpnoiURBImYuH8RZXn6JO7jCYhGHZcKl0P3XiF6kZcnJZMreHUScTwR1YfD0FBep9SDzwAZYDrogi/dfmzRjgjqLgheNSe+KNPdbOc4Lp5NKMcxbysn26DvLVnpETf6Zzq9TofkHE1gJIgMD1RGnvO5rkOGrd3k46HK/hXPzOpFkn+B6IU04OTC2ZmfNQXBggb20U48Q6jxORK6gI/KdV+VB5ICBEvNZ8BKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW1mzUwcowJ3d47nka+SUJO3AiBxgKrMZZEnTf7UjF8=;
 b=XqrZXcsXSMB33ZrkJjlsOOQM3WpnmBUqmyjuEvWr4AEbmJqLrhQCpgEO4zKnEhhXtNJ+3CJ/0n4X8PMJCRypxc9P1X/EYOXA65U5xpPA/EMy/po2SnhsIV6RZegxxdylol4iGfHX+6+p0ewEnCOaUlnt/riLm1dxunSOHv2AGHo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 13/15] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Tue, 29 Mar 2022 13:03:24 -0500
Message-Id: <20220329180326.5586-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffe30ee4-cff6-4aad-b2d9-08da11ae751f
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584D77054476989AA4BC0F7F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hzjYWcVu0C3rGmz8MJlTDfuySoJtgzvZJiQ4YbpXMCHtkjZvLm+Q3NXOcXU0/6ZRin5qTkO7RSVLOg4fW9LrI+QH1oy/qpRHdrSQ14sThhtLYhKBey2urhmbDfwvmOqPxzA7Arutn43kNBzVs/nueUp7k9NBaXpekO4yAJ+3O3eMKJN4LRTUYWkyTo7aKOtsn5e6WPwDQDd5i3lXIohtZF5JIikPLJHgOSZ5xRtsJcx6W/csCdBxULf6te4eJJetkVEfpUYDLZ6Nt6KGbiUKVffBmixF0D8FC2UzqfEdFFWcoAhqRIqEZQidrITOOfGJLibGrEkqATFyAw/vZvaxkv+y0DJvtX7YQbq+JsfS5T+OpJ34AwynpRgFtmWLeyfK0fvGrq34PHQUpjfaMtaXvvQ3NU8q9+GRfH+fk3myAA0uKqkuXDsy0cRXTexql7TPBESB8KyJHNd2Uwf0w6WhKCx93gFN+j2WSHQeb4GC2e1cfskPglTHwsN78vWUdpngh6w8QkQILLzfxX9t5zBYPwmQ0ROUoFbxhAheh1GI4nWvM712e8WaWWuZFmqfI8odZOnOagtlWINwpgjI+XWRnmZ8d2RmbRhGXhfpR1LzoQWR/AmY9a+sw1Ykf4tsY21TVTbxCJhgyjKZ+TRXqLdmTyLsD2YhgJ7rwd7NUBeQgLyiTAS67Ylp1XSkn9Rj88lEd4WZ96Pc/RRaAQUkC8odHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F4d+4mj743gxmtSBP30MUnnKtRoLfmX2TutW4Ccp/AwbH+8t8qK+Rnjz4Ms3?=
 =?us-ascii?Q?6aq6CMUFj3i7CyX0Ob8tMKFntJ9UpvjjP27wijZfM1UQIPcBCwhSdDwPNh1h?=
 =?us-ascii?Q?2FRrucrejOgq64VAKScKAMWOrVrQfH7p6XMqDptxqojfd76LefEPNdFR/jIi?=
 =?us-ascii?Q?H6629M2A2YFUM9OWH/TCjddGgrJiSz7vnzhH4EpKqmgKZztBd/R03/VorKSl?=
 =?us-ascii?Q?JxQkHIy2b4fNh9rmZNUz97l86bh1OxxDkamk42xKUW7d3WMRdju0caL8m4mb?=
 =?us-ascii?Q?D98fC+NQiMq819WYcs6AkqbKSAcZZLtQWGurqHLS6FBTgajnkwWPypugsbcv?=
 =?us-ascii?Q?WgrhFKa59t1gwnpkXX1eFVMS+yj/F6Xta1StPI2S+J4zGLxANC4yl8U2DA0q?=
 =?us-ascii?Q?Sz6UC3Bz3g3eXl3xZMRhNAc1R20/KVg1P9fPtGaWF2trZD21Qb98/RlLjy/t?=
 =?us-ascii?Q?DDBM8Q94aoBCGNItX/VN0FGzOAiHN83U5Uw4ZFkzy2xE3IomPh6vYvSDNpTu?=
 =?us-ascii?Q?DT82wRk5Zvhwuf4Vk8GiG/xzFAeTVksfOi5ciXWoiS4OG+Rh+jItBiwYDa3N?=
 =?us-ascii?Q?DWXrmzk7snGLkREHleBPAloERPjz9PP1ctLmgJ4l6Z+ucN3eRZJKhRHEjopt?=
 =?us-ascii?Q?Icfo1sYgFUoB1WZoBSeYLfLoRW6+j4wQvd5h9iQQDWWrTc//T6AQoXhHsCy9?=
 =?us-ascii?Q?XgvQIao4bOd66PD71+qLxJY07WO2drQB5EoLVZzheayj/nbQiw9xn3lUeeps?=
 =?us-ascii?Q?VoLpZWe33+tny7qzYOIWQA7DuvvfHFtqWjlszcvqr+Cwk36YrVSi9QJLyEDS?=
 =?us-ascii?Q?38Ve+4+KtYh4pgkVV05VbBQIVihznMAIeFK35yFDJ7S7+BnIi8/942ErWlTk?=
 =?us-ascii?Q?+9pmhE+G2B2b5wy06+3Z+XuP5O8eaj0F4xX5IqpaZ3y5G8bhFhmbz82/itar?=
 =?us-ascii?Q?ZTUMqZudkYdUwKWPV8DntIc4cf7af1UvXx/mvfVFCFq8Is8sj6ru04KoSjDE?=
 =?us-ascii?Q?AZTJkgBlNyeOLMULIEHZ0/Km369s82C9JP1D2+YZ4oK8GrAroxrqNa9pu7/Q?=
 =?us-ascii?Q?UZRYqo+L8vw4hYar9i/kMOGMdzv+0erwmU+lwkvpGc3IuIZVjKDmD+AU27xh?=
 =?us-ascii?Q?q1c37S8tFhm/QVKrqyMJFUkoQS1/MeNQFglGzBdsz7Lytnqs5z3ffx8CCnB/?=
 =?us-ascii?Q?Yv2l4Qg3Y0BPc8azLN3xqUHTSXEtceBxHKp0ux+/p6+T7obOG6pb1hbTW1Xs?=
 =?us-ascii?Q?ADR4Ujo9Z65HtrrrtSsbJMhSSqSX/4ywOoLktP5SHrvsffq24FFRU8FWNVev?=
 =?us-ascii?Q?LiTtMVaFcd82t6TeaYEvH789z8D1Up3eHSMBFM6bklGNnVxLtC5BMuTuAAiM?=
 =?us-ascii?Q?j+qpK33ggfNxEkejhn45M2hcYnFMMGeMTsDeMkRDcn67h09zRsmUENbOyWe+?=
 =?us-ascii?Q?s0t7isWyzbZn/rmjpFoAqUdBVFxG/L3VM8d9n1J+PP8IczUMUJ9rqDklORgt?=
 =?us-ascii?Q?RkR+1RitRc5cNCDlvbXCeknxTHK3+jnXOrXfcb+6/12MHE2Q/8+o3AsLbnJ0?=
 =?us-ascii?Q?So6vSz+Fa1tDCsDNYUlClj0wm43h41AtP1EUhqrvlvZuUbpcKU6OtHoM1ZW8?=
 =?us-ascii?Q?glUSPxcI0qccXcQkdFNt2DS/LdXyJ0x6R6kMIMV/6T5vD7gwZO9D0UEm9FeE?=
 =?us-ascii?Q?KUF1ZAglfj2oFNKJ+seKXNgnKP6l1PvuMayeLp++ZbYBTqvZufRubZVa2JqG?=
 =?us-ascii?Q?f+Sr5qMdG+oCwiWkWn73gMVUVNMHMMQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe30ee4-cff6-4aad-b2d9-08da11ae751f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:41.4902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4/CPWt919pHuHEf2AfRiKuYFBym+tybw/XwdA53azhf6ZeZ/5qvL61X0IEWplB/m47qVpbkgSJnYFV35pr1KGBfVcYzqYF8PtKoZUHYmT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: xA6E3Uc-JjveRnY9z-qOhrbe0JhhiF3L
X-Proofpoint-GUID: xA6E3Uc-JjveRnY9z-qOhrbe0JhhiF3L
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
index 544113f3a9c6..eede1f88a407 100644
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

