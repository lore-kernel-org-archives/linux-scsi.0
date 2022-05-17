Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83979C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiEQW03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiEQWZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527EB52E57
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTjSk012903;
        Tue, 17 May 2022 22:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=bfdb4syXDPs0ky55XH1AmS4EryLv9b24n8Aim5KjpBd7MkLSfpyoMwiD92iEv5kxl4S8
 lhqJoHGN6qldF4NGSbfvBW3Hli7E3OHpDPHQQVv/BVCiGRjBAO70Nj4ck7NJOwZo7AU+
 fSR+AAA850IlTA1fTuyFE93SPUyyCJ5D9lVseZMoMdyFLXP55KTFZEEtZaMSI24z7R3/
 CooF+NzG4xzGamGAK9dIAtgga7LwtH5LnrPqljhpChnwUgklbufVri611MzvbAHaTcQb
 RhIxToQ/ML1jtWFka4FM9a0a7r1euife7fiuzB6TIXvc7NAAXl0kOubep1XOYFY9/Xcq dQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytqqvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLnwM019398;
        Tue, 17 May 2022 22:25:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3c0cq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MF/raYfb6d9Uufyxd5kSu+OEz3BIkRnQL4TPLDZZ4CYAzp5eH8ue6mVHhwVS75egGVwMMrVV6sm2ylcXCs07zUZd6ERGmptY3/9HV3vqG+ctlhMQCyvqaWTu3b17nqhA0PjubUsHc7MaQ5FlJ3azSPeLMDVv2fQbaMpONXtODgq1UB8CSqoC2/YTOc5EobvhsKnqj/GCTuJ52PDs85tO4XkKpGYv/5vnTr2VOo/plYhF2oKlXJZZD6KZDEPOnMkrJQjVfFSlKgT55kn9/0/Qa5vpHexj8Wwo+TUW0L7scbaUADmgtUcXZNKWYC/P4XMwI+b9sCFcI2wY+4L62OTLDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=ORbY539SswQidItSNc9zGcdvkX24QBb8govjqBSVm+yZBXNsZVE01qJIMmG4sgc5c9vp2Y+y2C9UWVv4h3arnFzNmCjhcqQi5M/os4eoix/WXs2xRSBVIAmH9Mw4cK6+kG/vFUoftoF5HCV0ZTO6yGMpN1jOdpoaaQZ8IAXPysnl3zcof10+mCZeeHUrsMhQmm6MWnyndtBldhNeokpboIgU3sD0PORysUBiJQuG5motTJbLhv+4YBdofoRjmBBdR2SNUx1aGFkN2B7QiwdjJegZXPY/ty+BWOrGgTpEDQDqCZJ3NFACUW9VRY6SXR3P8eyugX+yUQkVMjJEA2Yb2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBeg8CCS7OgIHpdG+6/WUDHhCxTLd3NX0pzcz02Iwco=;
 b=OE3CA2xLVUs+gpJ2FRR09UMTvMLWNW97a215cOuTZaSCPswsGr1xDcxayZ5UIq/SPWKPzaPhGB1OK/+LNhFA2c4MrqO7s1KyHzeyUNsycohWxEKyitl4b1RRFG/j3TurYWkSQ7ss3c2qrc0Zld+ozEWFsy8Cw0yRFVjhFKTN6aY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/13] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Tue, 17 May 2022 17:24:47 -0500
Message-Id: <20220517222448.25612-13-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 660e0bd2-5acb-42cb-ab1a-08da3854157a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55175F53414AB48854693B3EF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giZXdTpDFlpvRzWOQSCZXEDPYFDchZbBadW+n7I00R3Cqr1T50/Qx2syyGZG9Slo69vRuqLk+OxdcD80xnLUKX+hZZijWXSSto73brdsDcfTp+s62mV3HIokqDwIeM4xiOlbwLYMZ5ID8R9Hi442Ag9iFvPocJlSg8JjYYygQiV4XqWzeCFAfWMWmHDG4Nv54PJqzqCPcZFF5OLWampig/GRGZxfA00zEtzD3hej/yTcRkMq0RZxvx/rrclwMr4+HLp/JNL3pbg4LBgB98olSopJ5ITxfxGHHIAm5fLlBBarCW94j9LpX8q6VYQh/yyFMNYXgTv5kS/O6VfNKHK7JPgdOYFs6Rm+TkAMpYsZw0V1NTF0dDHBZa7y97peEW+3kUTvDMhSeRS6dzDwqE/fqWPK+AI06pAl8a9BCkoAuByJe9nsbCjiX3sJdI9eD4EVdQcYQa3eImLjU8OhzUSi3JbJYan43dNbnaALlTHgpu8T0OoPoavP55shyA42e+TlpU4ZMLuJgxc0DMRKPhTVPMIp8FHjuEi68Zyam8lbKli+V1AOnBqILM5kY4OuzUw/IP1cOcUT1HaaMV1WHtrLqMPVs3IC2WCn9PevJgmo7lzvfQDFWsuhindkQUEKl4OoDd3II8j+GtQHaGDDW/idms/oe4NHWpjS/JEGE3qXDj/yCXlRbhd22IjlGRR35rEm+d3kbX1pycIB7+YJsP1Khg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QrmDtt/jNdyFiEnVvO8Fe9a7tZg7jJivMHf2RRN3iBV/iXJjAo+d0kG2YzQt?=
 =?us-ascii?Q?YbQv1EJt0GH7uL6oHszBIgPzXV0m7BMiSg64lDjnR1OgAihzqP5Zj1WGYoaZ?=
 =?us-ascii?Q?0HEMykJpn+Pb9WBZxD9U0WfziD7wYgMY6iX5POylq9/BRJ4ZYd5hSeYf5zdY?=
 =?us-ascii?Q?yInnVkpRKDpN/Y4kOl4+QtiErBmMDe+9QwPp1F48zNM1+gVe7yA79XmQfLGH?=
 =?us-ascii?Q?IRnvnwDYzcKr/tLb96KBm4bF4hOgDqUBtKIZ9RcMQSFpIqx9WawF0EhrpTHp?=
 =?us-ascii?Q?KsCBgavXqRQX4J4s6FqyxEASRDxLbk8bx55Iy9XcNuXfd6PKWdsOe2BH1VQh?=
 =?us-ascii?Q?GM8hBt9OaUvrcdhKXrGrJPXZQVshGvZ2z1i/pLObTna+TR9DLq8fAiTHeCpY?=
 =?us-ascii?Q?gKAbmUiNngSvMhXxtjbIf2sQfOe+1uzYAw8V5HRZARYCAcglcs/s/vq4F1GO?=
 =?us-ascii?Q?sky48Au+EuOzE4y7d84SpEdJSO+FSGuhWMkQb6j4aMX9VVktN5eq4TUN5gnK?=
 =?us-ascii?Q?2GMxw3335MWNiXypXGXeOkBWaqhM70QQf+UvimqFIMEjVDsXao4NPmVAgn2c?=
 =?us-ascii?Q?nDwxBzLwmQTZXGciFdybMppQGytj7P0rIAdPeLBLp5XGt5JDS8uD6beOMpIX?=
 =?us-ascii?Q?PhbGRcEPiVcFxcT0mhfmho6evOTWOx6CQiX/oL6eKL4+ABEKqoH6kwXARqBk?=
 =?us-ascii?Q?MWqpqkGFEN+kYqm+MKJBR6FzTmhsOgAt6Nt1Gl1Ppo4/ATZ0aamF6vahDR4T?=
 =?us-ascii?Q?D9MW4HHXSeANrk00+2L88hcgcnHxaXFlS/+IlNNY7lEGRBcNa5mQaXEaqqKc?=
 =?us-ascii?Q?G1uiI+hRQlKq7YzAT08SNNm1Ildz/8BAkgUv2gQKkN3PTeWy9AbycmZgme2S?=
 =?us-ascii?Q?zB7+VfSGAoOa6krbwrkGYXZs4rC1gFxO7GojoTqfBNg3sjyCCyuJ3RSInrEM?=
 =?us-ascii?Q?OYJ9OIRtCNVM+lV96uhSQsGW3po7N29uoy1wuOyEdlSCpTIsO1jbpV2C+PbI?=
 =?us-ascii?Q?YPoNRlyxqtG59MsO5myItUeRgFRB89iB/B5yIBnalV82x1jLqX0lo8HXYIDb?=
 =?us-ascii?Q?oLbeKn3PKzQk9ntL7u/N3fT3c3unuP4qUxVIVNMtShCdbdsKSRcQFtv9aMyf?=
 =?us-ascii?Q?LJ2umPfQdko3UAHq28huczB93LV+QqPS1b5qRw9dFPYo3Tox0urSOqRoHeoS?=
 =?us-ascii?Q?8n/clkxU4+FjTIzdoJcRWr1q2ljr9bS0bdPc4gZ9EOXIeWMaz2Fk1Ej+d7gE?=
 =?us-ascii?Q?VXCfCBtW5FoQd0g9u+IXLDQixBh9zrsqk3tgYhD6Oh/HfWui77+a7F0YFOT7?=
 =?us-ascii?Q?/8o/S3Qm8hqhVTGUlba4gJGuH3hRZxVG+G86cnPp7/PPsp4qjVFBaV8xv7go?=
 =?us-ascii?Q?eyqpIBqT7w04Ww4a01jp9bFlfSe1ssLfGOu+IFGf41CBQKPTYedRxto22tg+?=
 =?us-ascii?Q?kOBdnAV5h61VbmYWErcG0umJWFaBl7mpA5/RuCcY0hWWUHXD1tLrGDGeCZ/f?=
 =?us-ascii?Q?dIhpK5ahSy3B9Avd6FpO7dZ5gVu68ky2PRvz06/BbsOyxD5FRletFF+aTFEX?=
 =?us-ascii?Q?PR9LKv8VjVxStHQvo0fTuvfykTqNhE+2znpGljLxYsQ1aoGOEqtFlTriw6I8?=
 =?us-ascii?Q?39jB8ukkxAvXqkxt0RoefYi4Sd8O8vXIk+XenqO6DcXRUchb90rG0/qH5bB/?=
 =?us-ascii?Q?DpB5x8vaW5GrxDmyUbnr/cfqr/xgerkr3y9tImo3JdDwCV8Z0gXe3MPaoMNc?=
 =?us-ascii?Q?lgzniuoxOe/zhxANX7odd4iiLwTGKm0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660e0bd2-5acb-42cb-ab1a-08da3854157a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:25:01.6365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqZ7ZaLjFWq6Vwp9jMqBJ2YtEwS1ny36pybXdEKXJt/rbqqhht64qeDNu29abISnqyUAkmdkYj/tGVb9zj+hIuAEpGv6LRi/6uZD22tYCh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-GUID: ysYuK2AVmwGopKavaKq6WfNJsOW2Dky_
X-Proofpoint-ORIG-GUID: ysYuK2AVmwGopKavaKq6WfNJsOW2Dky_
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

