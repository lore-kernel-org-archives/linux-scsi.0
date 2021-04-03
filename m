Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6847AC433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B4A6135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbhDCXY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhDCXYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOPpk041904;
        Sat, 3 Apr 2021 23:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=l+cgs0CxZa0kdunLLv/LQau+6sVLgqZGMxefP3ziA2Q=;
 b=WrH6IfbxTFxg3dmsAARHKZ8ypqzH0/3VJmxgkAo4JjG+lQPBwk68AIiJDqOHuJMJEgIV
 r7fUlGqr6jih4p9YEvGbT+xcN0HRQID8JZm74v6K4oxAgkPhVTVj/KwkCzy5L181WgA0
 BSjaEfBN46XT9nDUgfMebqPcWC8fzoJ7vk8wLjX7rmcNiStGJlXJ2OZjBxyTmSOzKiHP
 zXxz50pRkDasuHLKdYjdsWOxnJcV+t+6ijRRcW/nGGBUshACZx0f5gLNoF2WI6bYRpWj
 lqqsgvI8aA/P5HK9K8bNgJKpJdSTNOZ2WbmHV97g+rT0f35t56u/f+tG5X0wfxMxgfOu Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJqbb074887;
        Sat, 3 Apr 2021 23:24:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3030.oracle.com with ESMTP id 37pdfspp8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFKeNoo733KF8P36J6/bThixmlvt2aucT7mfhA2TMfunRT5PdIu1CW1vh0c54gRRL60JgX1QuIyPIelkjNk5hJa6KS9qy2YraHTTQvhIkzFUU81uc7cjF/oeRQ7kHg3pyyYI92Ys8bP9PLZ2mxuJ4dNeDNK5XWGzhj49uaVl/av1OrI4uCD+A01Tkr4Z11hCnL75nwImSKRIjBmunIMO27Q4wEPHSKVftvNRcQw8uMZJ+MPKcDNY7lr/Y0Dyvkd+f2VVed5LRR+vwBiHSYK90I90+KGQMJo1z6DIPZytyLu0I61B+ws/g13DK1QvxfoTf3J+haPEFQobbL+QRuh9/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+cgs0CxZa0kdunLLv/LQau+6sVLgqZGMxefP3ziA2Q=;
 b=b5ITWqKJn5PTgsMpq3CFV9+/PuDq1a/fno8mwHbd7JXCzkW7UV5JKBDCjCDMyLYYiMM0cSDBg+586gDiMGI16L6IS96207iMRNKqfvgV4Lbm1y0JHRewAFhybm6Hmy8VjH4XdY85j5Jakd64LkKz4xic9+Zh9Vd/0Lh6yM9CeoOCRuZ2TATJTLo9f8rPJnw4d/Jga6uiniw/lA7BcV4ls78vEJ/jTYqXjVWJ3grJnJYUjikpFzA5qCOkjzIvOj4QuXhAywMkTQxyjAZyj4+pFeUpYx3QXNiVZD2utwvB85qQ+yZFxKR0ibqMlHT/uZPyzFwjF/kdcveW4v6fhZnxVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+cgs0CxZa0kdunLLv/LQau+6sVLgqZGMxefP3ziA2Q=;
 b=sf4isTv2XBIRt1p8iPpUWUXa8PBdhYikNstUc+ClCls2C100vSVmzY2y+0ThyGcrr8dXQK/fkL6xJO5mAumr2vG2d3UcgPYuErRDNatrkBHI9oux6COxXvGA7WSxoffTNZbmogjU2tiYGB1ypF3n+ci/yuIaQWlWKU4DqAZLBxM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:22 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 29/40] scsi: libiscsi: replace back_lock with task lock during eh
Date:   Sat,  3 Apr 2021 18:23:22 -0500
Message-Id: <20210403232333.212927-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfa53353-d928-4eba-d769-08d8f6f79cd8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431F6BB7A7E3D0F179D9AC1F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWj9YUWUTYXrAoEWSS93pBHNQDhk6ydSVejds81X/1l3R20Ojo3eo5H8ERCa0YIXgg2HKqXul2p/svZ+ym8ypQs7xw24oL8oCaYjHcoRYvxWHcyu8lcBqMRo2sN4G3syv4qzkebMhtQC7Zx2jY8263Auv6yzX5CKynF/eRMIDIm1EZdmIT9TdOCMA5Raa9mvptwdy//p3SwQd9AvFhD6P0RurTdAepiaeBpiiI5QqchZEMxbQ4tdgZVmpu96vBlC3GGW919IxKjJQOB72fNBH12TaKLlSfiQ7/eqOxEDsnXTO3caSAOgbLxZ866fALy1nW91WB13axKneWXWCM69LBkCh/FsCgBPxRl3ni4UdYzICbwJOTnEBlBdbpD3Q3St4/4yQBT1a/Vl8u4/YXNgjtiUw9TlFiaV2GQn/tiadIndc3ceMspumKyG8pBNF4hpo67mBepiuuSDxPSO0+sLAFIbdpk6LaPjoa67FHbqH64ORIT/LItvpMmXgDH/sVymUJLo+GMKG95IeGhxkhZYnNNLpOj5PLJtZeIrUfUpoksjJZnlMsAT+pe4foTJOZri3A/cVutkOFPWnruLThA/haOulzFOGbPhMzlQfDhyfe0pEhoSvffSVJpZ2fZybZJUvXC874KQ1lkZSfOYREoawTALCBcOHozVN+w/SMmB2vXkxnh5zspurqbg+VC6n+H5QbG+3E0JRnqbwGko96U+Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(30864003)(8676002)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VvD/leaKnnWG4iP8vJcDgRjrj2Eb5fc/tdllqDxlg/dfSeiMS1fjlWsDa7Yh?=
 =?us-ascii?Q?ewHr7WSzdpHqBV2JGUQA8ul9U7n/wUDS9s+7LJJ8J3mgArteFiSDSCL6Jt0M?=
 =?us-ascii?Q?6z9+hSLwlLxvvbMJjFxAzzKNAbuPebm939/Jc3KES1GcMVXoQQLt1+s0WA/V?=
 =?us-ascii?Q?pbVZXU5qTZROvIlZdRnnuw0MgmbfGOduxSYWzQEodWP8LeInuku6khGYp1HK?=
 =?us-ascii?Q?/vXwxaa2/nB2NWYvrvDZrTgDOLAbjRF9EoVDOXL+6qO1YBN+lWOxlb0l7vYr?=
 =?us-ascii?Q?zH4tbMLGC5UjIPfFN90izEG27ePJo+ZnIRDjVp6Ngl7MPNAaXGywAjBT4p7S?=
 =?us-ascii?Q?X7Iaf14/x3RGR7WkVLikQndow4AwqKlcY3/AQ8hOTTFYBLmPQApzt3TsLTzM?=
 =?us-ascii?Q?dm6Q6rpqSTSgCRYemZ8mbTdo16IfK24fjGvRu5tjrbwWbicPBX6FlaIQaBFP?=
 =?us-ascii?Q?/e9ZpQi+9Nkft9vtsGluiktsRMrUVrXeHbhtOCA60hL0cotKdr0ShrtmGvi1?=
 =?us-ascii?Q?+XvQ0hv6mHWMDQAg7JieY7h7MLythClM+3lNY1ludZ4EvT2jmL2FMzSpKgK7?=
 =?us-ascii?Q?+BBzvzg8ZGQkPNP+B6XCAfZs9W6Hg7ve3yAlZDkzDxRLK3z3rthoqHvcRd5/?=
 =?us-ascii?Q?Xty6QIfiukzoG+xSlCbLA8YjlRDVmXl39Q3qHwQGrMFZMLCtE8pPpW5bhKA3?=
 =?us-ascii?Q?F9POvxRvIrfvdaLh9nALHw2tvQsCHWGC74N7QjZqXkb9790dSw0AM+tZ2kIA?=
 =?us-ascii?Q?KF9XrspgH9A+v4zJMF2Lwaf3dqrReh6KxY6CO0g4CxERrp/1Cwc2aews6bKI?=
 =?us-ascii?Q?gf+Pb5alZXyZ81vwC9sygK/mAFbbZHvRlgeBu/p7RKAZC0fgRyfhzW3z51HR?=
 =?us-ascii?Q?eVYSkLosxKCs4hRSvrxUdFtj61FeRGN+gEHcMM74oYi8qX0SxcQyX2FoRW4v?=
 =?us-ascii?Q?bxcFh0PskQZh4fhQ/ME+h0p2TeFJW7BU1r7/cAqnmcedATdVqYlk5G/7PuCT?=
 =?us-ascii?Q?CoolSt/FZ93xWKT2yD8fgQg13UJyckNIngJcsqHCw804EnKueaf7TdS0mxeE?=
 =?us-ascii?Q?StV9T0hBLHXqEkecA8xYie5HRqy/XhOQ/uIAoAqgZi51Q8IL3TCILUyyuT/9?=
 =?us-ascii?Q?fSt9ekbuDwKvoLC0hLMdd8A1IkBh39iNlYsyfvogVJPNjMn85igUe8byl9Hd?=
 =?us-ascii?Q?E9eWc2+0f1ys0+MG+VgRyVXW1fnMfs5jtPbP1ZUYNE8omLDCl+TYiQoLYM99?=
 =?us-ascii?Q?Nso/JZznhKhPcVD5YkmUWVttj3A16tV3+NvygTsDmtvJ133Va2ZMLhj1MHqX?=
 =?us-ascii?Q?pCBBKiIpAydfs80kTzxntkY/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa53353-d928-4eba-d769-08d8f6f79cd8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:22.4475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfzq7b4v+AKk2fU9mATFl8I+A/VaTPDHXwY9JgAC/tFIvmfyK/wr/GxCY4ZfN34MePLpGSfjx8YZRK3Ll1YHdts7NAXjeF2krRAVHKPyjAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: MC6YwRvVE2cJ2fZ0aOFc4pdcoUgbr6Rx
X-Proofpoint-GUID: MC6YwRvVE2cJ2fZ0aOFc4pdcoUgbr6Rx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This replaces the back_lock with the per task lock for when we were
checking the task->state/task->sc/SCp.ptr during error handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 132 +++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 955ca15ecf5f..61d73172283e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -422,7 +422,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
+	spin_lock_bh(&task->lock);
 	task->state = ISCSI_TASK_RUNNING;
+	spin_unlock_bh(&task->lock);
+
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
@@ -440,7 +443,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
  * __iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
- * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
@@ -481,8 +483,6 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (!sc)
 		return;
 
-	/* SCSI eh reuses commands to verify us */
-	sc->SCp.ptr = NULL;
 	sc->scsi_done(sc);
 }
 
@@ -514,8 +514,6 @@ EXPORT_SYMBOL_GPL(iscsi_put_task);
  * iscsi_finish_task - finish a task
  * @task: iscsi cmd task
  * @state: state to complete task with
- *
- * Must be called with session back_lock.
  */
 static void iscsi_finish_task(struct iscsi_task *task, int state)
 {
@@ -524,11 +522,15 @@ static void iscsi_finish_task(struct iscsi_task *task, int state)
 	ISCSI_DBG_SESSION(conn->session,
 			  "complete task itt 0x%x state %d sc %p\n",
 			  task->itt, task->state, task->sc);
-	if (task->state == ISCSI_TASK_COMPLETED ||
-	    task->state == ISCSI_TASK_ABRT_TMF)
+	spin_lock_bh(&task->lock);
+	if (iscsi_task_is_completed(task)) {
+		spin_unlock_bh(&task->lock);
 		return;
+	}
+
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
+	spin_unlock_bh(&task->lock);
 
 	if (READ_ONCE(conn->ping_task) == task)
 		WRITE_ONCE(conn->ping_task, NULL);
@@ -562,7 +564,7 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
 
 /*
- * Must be called with back and frwd lock
+ * Must be called with the task and frwd lock
  */
 static bool cleanup_queued_task(struct iscsi_task *task)
 {
@@ -606,9 +608,9 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	struct scsi_cmnd *sc;
 	int state;
 
-	spin_lock_bh(&conn->session->back_lock);
+	spin_lock_bh(&task->lock);
 	if (cleanup_queued_task(task)) {
-		spin_unlock_bh(&conn->session->back_lock);
+		spin_unlock_bh(&task->lock);
 		return;
 	}
 
@@ -628,8 +630,9 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	sc = task->sc;
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
+	spin_unlock_bh(&task->lock);
+
 	iscsi_finish_task(task, state);
-	spin_unlock_bh(&conn->session->back_lock);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -1726,7 +1729,6 @@ static struct iscsi_task *iscsi_init_scsi_task(struct iscsi_conn *conn,
 	struct iscsi_task *task = scsi_cmd_priv(sc);
 
 	sc->SCp.phase = conn->session->age;
-	sc->SCp.ptr = (char *) task;
 
 	refcount_set(&task->refcount, 1);
 	task->itt = blk_mq_unique_tag(sc->request);
@@ -1769,7 +1771,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	int sess_state;
 
 	sc->result = 0;
-	sc->SCp.ptr = NULL;
 
 	ihost = shost_priv(host);
 
@@ -1877,9 +1878,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 prepd_reject:
 	spin_unlock_bh(&session->frwd_lock);
 
-	spin_lock_bh(&session->back_lock);
 	__iscsi_free_task(task);
-	spin_unlock_bh(&session->back_lock);
 reject:
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
@@ -1888,9 +1887,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 prepd_fault:
 	spin_unlock_bh(&session->frwd_lock);
 
-	spin_lock_bh(&session->back_lock);
 	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
-	spin_unlock_bh(&session->back_lock);
 	return 0;
 
 fault:
@@ -1978,39 +1975,43 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 
 static bool fail_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
-	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 	struct iscsi_sc_iter_data *iter_data = data;
 	struct iscsi_conn *conn = iter_data->conn;
 	struct iscsi_session *session = conn->session;
 
 	ISCSI_DBG_SESSION(session, "failing sc %p itt 0x%x state %d\n",
 			  task->sc, task->itt, task->state);
-	__iscsi_get_task(task);
-	spin_unlock_bh(&session->back_lock);
 
 	fail_scsi_task(task, *(int *)iter_data->data);
-
-	spin_unlock_bh(&session->frwd_lock);
-	iscsi_put_task(task);
-	spin_lock_bh(&session->frwd_lock);
-
-	spin_lock_bh(&session->back_lock);
 	return true;
 }
 
 static bool iscsi_sc_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
-	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 	struct iscsi_sc_iter_data *iter_data = data;
+	bool rc;
 
-	if (!task || !task->sc || task->state == ISCSI_TASK_FREE ||
-	    task->conn != iter_data->conn)
+	spin_lock_bh(&task->lock);
+	if (!task->sc || iscsi_task_is_completed(task) ||
+	    task->conn != iter_data->conn) {
+		spin_unlock_bh(&task->lock);
 		return true;
+	}
+	__iscsi_get_task(task);
+	spin_unlock_bh(&task->lock);
 
-	if (iter_data->lun != -1 && iter_data->lun != task->sc->device->lun)
-		return true;
+	if (iter_data->lun != -1 && iter_data->lun != task->sc->device->lun) {
+		rc = true;
+		goto put_task;
+	}
 
-	return iter_data->fn(sc, iter_data, rsvd);
+	rc = iter_data->fn(sc, iter_data, rsvd);
+
+put_task:
+	iscsi_put_task(task);
+	return rc;
 }
 
 void iscsi_conn_for_each_sc(struct iscsi_conn *conn,
@@ -2020,9 +2021,7 @@ void iscsi_conn_for_each_sc(struct iscsi_conn *conn,
 	struct Scsi_Host *shost = session->host;
 
 	iter_data->conn = conn;
-	spin_lock_bh(&session->back_lock);
 	scsi_host_busy_iter(shost, iscsi_sc_iter, iter_data);
-	spin_unlock_bh(&session->back_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_for_each_sc);
 
@@ -2102,7 +2101,7 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 
 static bool check_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
-	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 	struct iscsi_sc_iter_data *iter_data = data;
 	struct iscsi_task *timed_out_task = iter_data->data;
 
@@ -2152,19 +2151,20 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock_bh(&session->frwd_lock);
-	spin_lock(&session->back_lock);
-	task = (struct iscsi_task *)sc->SCp.ptr;
-	if (!task) {
+
+	task = scsi_cmd_priv(sc);
+	spin_lock(&task->lock);
+	if (!task->sc || iscsi_task_is_completed(task)) {
 		/*
 		 * Raced with completion. Blk layer has taken ownership
 		 * so let timeout code complete it now.
 		 */
 		rc = BLK_EH_DONE;
-		spin_unlock(&session->back_lock);
+		spin_unlock(&task->lock);
 		goto done;
 	}
 	__iscsi_get_task(task);
-	spin_unlock(&session->back_lock);
+	spin_unlock(&task->lock);
 
 	if (READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN) {
 		/*
@@ -2336,20 +2336,37 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
+check_done:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	/*
 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
 	 * got the command.
 	 */
-	if (!sc->SCp.ptr) {
+	task = scsi_cmd_priv(sc);
+	spin_lock_bh(&task->lock);
+	if (!task->sc) {
 		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
 				      "it completed.\n");
+		spin_unlock_bh(&task->lock);
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return SUCCESS;
 	}
 
+	if (iscsi_task_is_completed(task)) {
+		spin_unlock_bh(&task->lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+
+		ISCSI_DBG_EH(session, "sc in process of completing. Waiting.\n");
+		msleep(100);
+		goto check_done;
+	}
+
+	__iscsi_get_task(task);
+	spin_unlock_bh(&task->lock);
+
 	/*
 	 * If we are not logged in or we have started a new session
 	 * then let the host reset code handle this
@@ -2357,6 +2374,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	if (!session->leadconn ||
 	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN ||
 	    sc->SCp.phase != session->age) {
+		iscsi_put_task(task);
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		ISCSI_DBG_EH(session, "failing abort due to dropped "
@@ -2368,25 +2386,16 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->eh_abort_cnt++;
 	age = session->age;
 
-	spin_lock(&session->back_lock);
-	task = (struct iscsi_task *)sc->SCp.ptr;
-	if (!task || !task->sc) {
-		/* task completed before time out */
-		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
-
-		spin_unlock(&session->back_lock);
-		spin_unlock_bh(&session->frwd_lock);
-		mutex_unlock(&session->eh_mutex);
-		return SUCCESS;
-	}
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
-	__iscsi_get_task(task);
-	spin_unlock(&session->back_lock);
 
+	spin_lock_bh(&task->lock);
 	if (task->state == ISCSI_TASK_PENDING) {
+		spin_unlock_bh(&task->lock);
+
 		fail_scsi_task(task, DID_ABORT);
 		goto success;
 	}
+	spin_unlock_bh(&task->lock);
 
 	/* only have one tmf outstanding at a time */
 	if (conn->tmf_state != TMF_INITIAL)
@@ -2424,7 +2433,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
-		if (!sc->SCp.ptr) {
+		if (!task->sc) {
 			conn->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
@@ -3334,27 +3343,28 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 
 	for (i = 0; i < ISCSI_MGMT_CMDS_MAX; i++) {
 		task = conn->session->mgmt_cmds[i];
-		if (task->sc)
-			continue;
 
-		if (task->state == ISCSI_TASK_FREE)
+		spin_lock_bh(&task->lock);
+		if (task->state == ISCSI_TASK_FREE) {
+			spin_unlock_bh(&task->lock);
 			continue;
+		}
 
 		ISCSI_DBG_SESSION(conn->session,
 				  "failing mgmt itt 0x%x state %d\n",
 				  task->itt, task->state);
 
-		spin_lock_bh(&session->back_lock);
 		if (cleanup_queued_task(task)) {
-			spin_unlock_bh(&session->back_lock);
+			spin_unlock_bh(&task->lock);
 			continue;
 		}
 
 		state = ISCSI_TASK_COMPLETED;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
+		spin_unlock_bh(&task->lock);
+
 		iscsi_finish_task(task, state);
-		spin_unlock_bh(&session->back_lock);
 	}
 }
 
-- 
2.25.1

