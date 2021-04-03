Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D36C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5475B61361
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhDCXZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45358 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbhDCXZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NMuiV099139;
        Sat, 3 Apr 2021 23:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9VWIMs1pYdJEFklfarLkvgKUTZg2zfIAAqxk53xO1To=;
 b=RHWOyLo2BPTdZ8lc6jjQbm2sg3jS5Lc761ZDEcThOn+h6orXBhQpzxbK4rrMQorE0vSj
 KM21Hb/vgyDkrLR5W1hw6Wv2+bGiJ+lkrEN6vfLxgqGGOwMgBDR1I0+62ASOXSOOWSb7
 ojmx6eGrnuxH+tqc2duMK2yLGBGMqt++GZ7rCF0W6n/aUKN79JnGI9LVCSe5L7xZiN9A
 TGBGPrGkcH5ielrki87GscAjbJ6E8NIpyTcDeohZNCvKrYZl9YIfgkSwN4qxcbaUs/Hg
 jWlRejuXs+gn4LlS7vNMdq39IalzgeezsQnaiGIJEM7aG65uS1SGuWslsFSgRva7Qblc Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBZ117020;
        Sat, 3 Apr 2021 23:25:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vic67x8qE1feEV8zCDl3TWDBIaae0Ua5cYjTHhA1tWud0GReRSqcDeBlpRqsAUqJ82SMcHGSxvvZpkt/bcXgUryEx71DCzMmHFRd0zcm9VKC4GQl+b8q4QBSRiAFAP8HMn6lVzv8Ags2a0613eUTPyzM+nKmkfhO+t5zbopwQRj9B2uRqgkNG4Q2Uw3+ZimF0AEdfGyOjh0yDp4Pt1E+3DYxkw5uf7jDuWospfXbrlqTv52Re99RZ+W1t1X8TJ2h0v0VxEcbNzT0NPMkDkEYY3PyLNF58oNMiEGUPkCFfz7gxcrFbRA7NSzPzlYwagoo/DRN6wctB8xgiOk4tE5gwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VWIMs1pYdJEFklfarLkvgKUTZg2zfIAAqxk53xO1To=;
 b=A4b0ma30kS/jRC7kBYW3VB8fipZ4/UmhOSSYxe+vZrGSOjTUT9t8cnxTX+dcW+FYeZCMaG/HXh07Dyp6jbDG40kkk2T5Ayx+1+AS58paMM3U9vrS0fEGZ/d4cjdjHtJVOsndUModV0p/x0eEjxBEL2d1pLSeSU8jhsKTFxbyRmqvlUWqMLdHwO/eKAYhJ68Z3Q6ZKJZryHCnn2v4FuSYbWLPJ2mEsoH2NoPrBOpyvJ70z8ciA+tEo9c/jlwFBLIkgHFOLabdpExdqViMZ+IcIQ0aXbFTZUrYajLpIWKIfr1wIYL18X87HCVBYDvN3nNRKdwP7mChJCfn/6SJd7P/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VWIMs1pYdJEFklfarLkvgKUTZg2zfIAAqxk53xO1To=;
 b=l+mOifuyK0lWaSAkeDobr+vfmfDhjdrCyeG38sCQLjosbrhxwR8Y/APIxPH2W0qDonKmfxZLmrF8+KZjAW1Nk1accZT9d3Cwo+F+061nmUPcWaxZ2Wt+PbrdkyUeoB4to6TfKHi2VGuTdSwvqaR5/rGh0+7FoiIv1Lh0lG0VCUU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 38/40] scsi: libiscsi: replace list_head with llist_head
Date:   Sat,  3 Apr 2021 18:23:31 -0500
Message-Id: <20210403232333.212927-39-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55233370-6636-4643-f97b-08d8f6f7a40d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431739A203A159B62BA5773F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+IeshdDbKELyc8Mjr/X+mCho0ze7m/KKkLT2rxg44URNZ7OS0X6LNbECk5tQsuzDGCM7DJgTmk/Ajz6HTWI+GBEeMD7xYFaODKR8MYkz8iAYujppH/2V9kgJhHtHrLN2j+2gBuGbllkR28YjDSWx4nCtIrFCBNmPuaM4TUvcInxDgEL7lDp1g67LbJL8CjNRuALcplegf6wD9mSBp6exbgpeVx0XMhlXRlgZFb0a4W4ESZG2s8/RZan3pmwEcTnyV4owZSX3bx/r/CBWHBsQBRUO1b8/h6u1j3VrG8u3aw4Xb2LHRnk+3P76e56dfIxA1Tgaq09QgPdLRaFRwFT9Zml/H43ckGJakFWL33So/P4iJGJ9+0FVbdpvrpow2nrJGUl+zhunR0wYpuYv1zKBn+4D+XADq6xDQcMpq2I7+GmiwGvYkxdS01ZK3spI18Apla3xfKl3CfJFW/+KSduv0aberoUfQw7BtvYl+oYu9a/GMsCfguYCunN+T5IgDjSNG1t1HemRhMs7VpfPiGUU21NHviKP3Pm6q3lfTjojWtzq0d3JMO4cSKcpGVHR1dQANlqzFXlUCRivMDRnO/uiJV46s/QY0U2+c08w52S/BNVk/xLxkZ9Ab33mqZZ7ISjV0XicCzXT/lzDhOPZgy8xKYDr5pLSfCg3JByENvOt7jiwK2iZ61RvBZMBI/SEDmv49MvL+1H5kG2/h54RzYl+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(30864003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PbCCOAm7JX8dBWtvMWNrkzvwPDQ9GKB8h7wDE+sbwf5gujQWDXV96H9D/rLf?=
 =?us-ascii?Q?U5vbjzr7bqPsq0cCw4llwtHQTC+DrU3BDeMfRauXAeGSg6KKjJG2shgKBVop?=
 =?us-ascii?Q?JODLygQ2hSCEXCFBd0FjMNLL+zi44oAiH5n8G/4tlPib02T2fBo3p76D+pk5?=
 =?us-ascii?Q?dV6yvnWw33D8hLkyyZprQP0k+xBLYZeIqVML11b64U2ttVdEuh8QHCJmLgR3?=
 =?us-ascii?Q?pC1QXAXaFJkEU9DW1U0/HGWaYg9+2NbepAXEC/OktWigVMFFEg9E8d85dTNO?=
 =?us-ascii?Q?sGB3Ic3q2m2PsKToGmaXPzC3iWqSKMrSZ4otzjoQYVKNO1FEWaojZglykCLy?=
 =?us-ascii?Q?yqgSW0MrImWF0OLO5WqFq8fHYDZM/537Vb+9ICCVVUZsadSWcAY9VnPPtwBK?=
 =?us-ascii?Q?p1C2HEYKNANHjMpWuN6WlGf+NKOzY6CHilyAtyJRfftmdSSn0mqbQ3Fh67NQ?=
 =?us-ascii?Q?fP9pGFP5WaXNWHLH1D1+gqdlC0MoVt6Njb1gSzOrXclbhN2LqjKuWS/TE0G3?=
 =?us-ascii?Q?ME2rzeJl+0XuXhMD8JxTbRrzxBCRKLlh8lqodY9KYDNvX3K6BejO3PC3frkF?=
 =?us-ascii?Q?nbgPwN9/D9y+HF1SxClXy4uPLKK+ZGg6iqctj9CIFDR4rYQvU6C1e/6N0DDs?=
 =?us-ascii?Q?jGMTDBet8GRXagnwlbYKNyGinzkQ/UmNQSURexQwVo6zxxnRcUwTiKlBCeBY?=
 =?us-ascii?Q?JPhQTRnaR3+8w4c3psy5MbTjEivgAW2qT0J1Kzvlg0H/7Pl++KHGjNjWEMTV?=
 =?us-ascii?Q?q88yFl4HBCsjYk++aD0fCJgqafRlboQJSZAyK8eqtUlsOdqCNVVJCiBC2uhu?=
 =?us-ascii?Q?2pSH44R26S7+wigHBz6fVQwYpL1NzpiW+kGCR24DT+zY2MJyYrLF3QADU4m8?=
 =?us-ascii?Q?yyKCyfhoa+oPvdw6K2HioRDOeHvpa7dAmE4k93v39fN1hY8PMYuaQktlgyJq?=
 =?us-ascii?Q?oH9gDq0KoQE1A88sGDP5E9ic3w/oKa/tmvrGZSvttMvrHAQlf3aNE1rvvrpA?=
 =?us-ascii?Q?GJ5jMZndpg+oGKJoCiyBYO8R7gZ09HyAZD1iaSb11wa6a63ryX9j4l+8qs5f?=
 =?us-ascii?Q?zv4deL8ulZo+/dChIUW8emWf0K7wWJhh060YUj5W5SHw3hAYF0QI8uIuSO7B?=
 =?us-ascii?Q?6MJo4Q68bAe1FLBhnRiiiy8m294J47GUIAF4pSlAFSWQZc/0P+D4uSEqHN4H?=
 =?us-ascii?Q?wkw/cSzcO2oInVNyMVBXT/URCpupzlt8yN/CpWj6Q/O5kAXbIGSV2gumDYFW?=
 =?us-ascii?Q?bOmI4GaTpSbzzkOD4mMwnx1CzmsZG49Es2xwJYoRetqeCX1F5Mae19a9bSfb?=
 =?us-ascii?Q?GaXYmtHT9Wt03YlV0UDi3gWO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55233370-6636-4643-f97b-08d8f6f7a40d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:34.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+cx1osfFx4ZF5T3XlznZejgXgKg1zNrOh47Inuixqv/oaB6re8Zqge6tEL57JnPe3SM5cVxAu+8PQqDOuOIHpbaMbHEwh69oeuf/YWdKDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: sYyvUC_jsR5WgFRDXXkOpEtQxYRxHYcm
X-Proofpoint-ORIG-GUID: sYyvUC_jsR5WgFRDXXkOpEtQxYRxHYcm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This replaces the cmdqueue and requeue list_heads with llist_heads. We
can do not need the frwd_lock in the queuecommand and recv paths for
this. This patch does not yet cleanup the frwd_lock because we still
need it for the cmdsn handling. When that is fixed up the next patches
then the frwd_lock will be completely removed for the software case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 248 +++++++++++++++++++++++++++++-----------
 include/scsi/libiscsi.h |  23 ++--
 2 files changed, 198 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1c134f721a56..1b4b6ee246cf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -730,7 +730,6 @@ iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	refcount_set(&task->refcount, 1);
 	task->conn = conn;
 	task->sc = NULL;
-	INIT_LIST_HEAD(&task->running);
 	task->state = ISCSI_TASK_PENDING;
 
 	if (data_size) {
@@ -782,7 +781,7 @@ static int iscsi_send_mgmt_task(struct iscsi_task *task)
 		if (rc)
 			return rc;
 	} else {
-		list_add_tail(&task->running, &conn->mgmtqueue);
+		list_add_tail(&task->running, &conn->mgmt_exec_list);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -1564,7 +1563,6 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * this may be on the requeue list already if the xmit_task callout
 	 * is handling the r2ts while we are adding new ones
 	 */
-	spin_lock_bh(&conn->session->frwd_lock);
 	spin_lock(&task->lock);
 	if (task->state == ISCSI_TASK_REQUEUED) {
 		/*
@@ -1574,129 +1572,238 @@ void iscsi_requeue_task(struct iscsi_task *task)
 		iscsi_put_task(task);
 	} else {
 		task->state = ISCSI_TASK_REQUEUED;
-		list_add_tail(&task->running, &conn->requeue);
+		llist_add(&task->queue, &conn->requeue);
 	}
 	spin_unlock(&task->lock);
 
 	iscsi_conn_queue_work(conn);
-	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 
-/**
- * iscsi_data_xmit - xmit any command into the scheduled connection
- * @conn: iscsi connection
- *
- * Notes:
- *	The function can return -EAGAIN in which case the caller must
- *	re-schedule it again later or recover. '0' return code means
- *	successful xmit.
- **/
-static int iscsi_data_xmit(struct iscsi_conn *conn)
+static bool iscsi_move_tasks(struct llist_head *submit_queue,
+			     struct list_head *exec_queue)
 {
-	struct iscsi_task *task;
-	int rc = 0, cnt;
-
-	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
-		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
-		spin_unlock_bh(&conn->session->frwd_lock);
-		return -ENODATA;
-	}
-
-	if (conn->task) {
-		rc = iscsi_xmit_task(conn, conn->task, false);
-	        if (rc)
-		        goto done;
-	}
+	struct iscsi_task *task, *next_task;
+	struct list_head *list_end;
+	struct llist_node *node;
 
 	/*
-	 * process mgmt pdus like nops before commands since we should
-	 * only have one nop-out as a ping from us and targets should not
-	 * overflow us with nop-ins
+	 * The llist_head is in the reverse order cmds were submitted in. We
+	 * are going to reverse it here. If the exec_queue is empty we want
+	 * to add cmds at starting at head. If the exec_queue has cmds from a
+	 * previous call then we need to start adding this batch at the end of
+	 * the last batch.
 	 */
-check_mgmt:
-	while (!list_empty(&conn->mgmtqueue)) {
-		task = list_entry(conn->mgmtqueue.next, struct iscsi_task,
+	list_end = exec_queue->prev;
+
+	node = llist_del_all(submit_queue);
+	llist_for_each_entry_safe(task, next_task, node, queue)
+		list_add(&task->running, list_end);
+
+	return !list_empty(exec_queue);
+}
+
+static void iscsi_move_all_tasks(struct iscsi_conn *conn)
+{
+	iscsi_move_tasks(&conn->requeue, &conn->requeue_exec_list);
+	iscsi_move_tasks(&conn->cmdqueue, &conn->cmd_exec_list);
+}
+
+static int iscsi_exec_mgmt_tasks(struct iscsi_conn *conn)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	while (!list_empty(&conn->mgmt_exec_list)) {
+		task = list_entry(conn->mgmt_exec_list.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
+
 		if (iscsi_prep_mgmt_task(conn, task)) {
 			iscsi_put_task(task);
 			continue;
 		}
+
 		rc = iscsi_xmit_task(conn, task, false);
 		if (rc)
-			goto done;
+			return rc;
 	}
 
-check_requeue:
-	while (!list_empty(&conn->requeue)) {
+	return 0;
+}
+
+static int iscsi_exec_requeued_tasks(struct iscsi_conn *conn, unsigned int *cnt)
+{
+	struct iscsi_task *task;
+	int rc = 0;
+
+	while (!list_empty(&conn->requeue_exec_list)) {
 		/*
 		 * we always do fastlogout - conn stop code will clean up.
 		 */
 		if (READ_ONCE(conn->session->state) == ISCSI_STATE_LOGGING_OUT)
 			break;
 
-		task = list_entry(conn->requeue.next, struct iscsi_task,
-				  running);
+		task = list_entry(conn->requeue_exec_list.next,
+				  struct iscsi_task, running);
 
 		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
 			break;
 
 		spin_lock_bh(&task->lock);
-		task->state = ISCSI_TASK_RUNNING;
+		/*
+		 * We might have raced and handld multiple R2Ts in one run.
+		 */
 		list_del_init(&task->running);
+		if (task->state == ISCSI_TASK_COMPLETED) {
+			spin_unlock_bh(&task->lock);
+			iscsi_put_task(task);
+			continue;
+		}
+
+		task->state = ISCSI_TASK_RUNNING;
 		spin_unlock_bh(&task->lock);
 
 		rc = iscsi_xmit_task(conn, task, true);
 		if (rc)
-			goto done;
-		if (!list_empty(&conn->mgmtqueue))
-			goto check_mgmt;
+			break;
+		(*cnt)++;
+
+		rc = iscsi_exec_mgmt_tasks(conn);
+		if (rc)
+			break;
 	}
 
-	/* process pending command queue */
-	cnt = 0;
-	while (!list_empty(&conn->cmdqueue)) {
-		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
+	ISCSI_DBG_CONN(conn, "executed %u requeued cmds.\n", *cnt);
+	return rc;
+}
+
+static int iscsi_exec_tasks(struct iscsi_conn *conn,
+			    struct llist_head *submit_queue,
+			    struct list_head *exec_queue,
+			    int (*exec_fn)(struct iscsi_conn *conn,
+					   unsigned int *cnt))
+{
+	unsigned int cnt = 0;
+	int rc = 0;
+
+	while (iscsi_move_tasks(submit_queue, exec_queue)) {
+		rc = exec_fn(conn, &cnt);
+		if (rc)
+			break;
+
+	}
+
+	ISCSI_DBG_CONN(conn, "executed %u total %s cmds.\n", cnt,
+		       exec_fn == iscsi_exec_requeued_tasks ?
+		       "requeued" : "new");
+	return 0;
+}
+
+static int iscsi_exec_cmd_tasks(struct iscsi_conn *conn, unsigned int *cnt)
+{
+	struct iscsi_task *task;
+	int rc = 0;
+
+	while (!list_empty(&conn->cmd_exec_list)) {
+		task = list_entry(conn->cmd_exec_list.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
+
 		if (READ_ONCE(conn->session->state) == ISCSI_STATE_LOGGING_OUT) {
 			fail_scsi_task(task, DID_IMM_RETRY);
 			continue;
 		}
+
 		rc = iscsi_prep_scsi_cmd_pdu(task);
 		if (rc) {
 			if (rc == -ENOMEM || rc == -EACCES)
 				fail_scsi_task(task, DID_IMM_RETRY);
 			else
 				fail_scsi_task(task, DID_ABORT);
+			rc = 0;
 			continue;
 		}
+
 		rc = iscsi_xmit_task(conn, task, false);
 		if (rc)
-			goto done;
+			break;
+		(*cnt)++;
+
 		/*
-		 * we could continuously get new task requests so
-		 * we need to check the mgmt queue for nops that need to
-		 * be sent to aviod starvation
+		 * Make sure we handle target pings quickly so it doesn't
+		 * timeout and drop the conn on us.
 		 */
-		if (!list_empty(&conn->mgmtqueue))
-			goto check_mgmt;
+		rc = iscsi_exec_mgmt_tasks(conn);
+		if (rc)
+			break;
 		/*
 		 * Avoid starving the requeue list if new cmds keep coming in.
 		 * Incase the app tried to batch cmds to us, we allow up to
 		 * queueing limit.
 		 */
-		cnt++;
-		if (cnt == conn->session->host->cmd_per_lun) {
-			cnt = 0;
+		if (*cnt == conn->session->host->cmd_per_lun) {
+			*cnt = 0;
+
+			ISCSI_DBG_CONN(conn, "hit dequeue limit.\n");
 
-			if (!list_empty(&conn->requeue))
-				goto check_requeue;
+			rc = iscsi_exec_tasks(conn, &conn->requeue,
+					      &conn->requeue_exec_list,
+					      iscsi_exec_requeued_tasks);
+			if (rc)
+				break;
 		}
 	}
 
+	ISCSI_DBG_CONN(conn, "executed %u cmds.\n", *cnt);
+	return rc;
+}
+
+/**
+ * iscsi_data_xmit - xmit any command into the scheduled connection
+ * @conn: iscsi connection
+ *
+ * Notes:
+ *	The function can return -EAGAIN in which case the caller must
+ *	re-schedule it again later or recover. '0' return code means
+ *	successful xmit.
+ **/
+static int iscsi_data_xmit(struct iscsi_conn *conn)
+{
+	int rc = 0;
+
+	spin_lock_bh(&conn->session->frwd_lock);
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
+		spin_unlock_bh(&conn->session->frwd_lock);
+		return -ENODATA;
+	}
+
+	if (conn->task) {
+		rc = iscsi_xmit_task(conn, conn->task, false);
+		if (rc)
+			goto done;
+	}
+
+	/*
+	 * process mgmt pdus like nops before commands since we should
+	 * only have one nop-out as a ping from us and targets should not
+	 * overflow us with nop-ins
+	 */
+	rc = iscsi_exec_mgmt_tasks(conn);
+	if (rc)
+		goto done;
+
+	rc = iscsi_exec_tasks(conn, &conn->requeue, &conn->requeue_exec_list,
+			      iscsi_exec_requeued_tasks);
+	if (rc)
+		goto done;
+
+	rc = iscsi_exec_tasks(conn, &conn->cmdqueue, &conn->cmd_exec_list,
+			      iscsi_exec_cmd_tasks);
+	if (rc)
+		goto done;
+
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
@@ -1732,7 +1839,6 @@ static struct iscsi_task *iscsi_init_scsi_task(struct iscsi_conn *conn,
 	task->last_timeout = jiffies;
 	task->last_xfer = jiffies;
 	task->protected = false;
-	INIT_LIST_HEAD(&task->running);
 
 	spin_lock_bh(&task->lock);
 	task->state = ISCSI_TASK_PENDING;
@@ -1862,7 +1968,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		task = iscsi_init_scsi_task(conn, sc);
-		list_add_tail(&task->running, &conn->cmdqueue);
+		llist_add(&task->queue, &conn->cmdqueue);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -2028,6 +2134,8 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 		.data = &error,
 	};
 
+	/* Make sure we don't leave cmds in the queues */
+	iscsi_move_all_tasks(conn);
 	iscsi_conn_for_each_sc(conn, &iter_data);
 }
 
@@ -2381,7 +2489,12 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 
 	spin_lock_bh(&task->lock);
-	if (task->state == ISCSI_TASK_PENDING) {
+	/*
+	 * If we haven't sent the cmd, but it's still on the cmdqueue we
+	 * don't have an easy way to dequeue that single cmd here.
+	 * iscsi_check_tmf_restrictions will end up handling it.
+	 */
+	if (task->state == ISCSI_TASK_PENDING && !list_empty(&task->running)) {
 		spin_unlock_bh(&task->lock);
 
 		fail_scsi_task(task, DID_ABORT);
@@ -3174,9 +3287,12 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 
 	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
 
-	INIT_LIST_HEAD(&conn->mgmtqueue);
-	INIT_LIST_HEAD(&conn->cmdqueue);
-	INIT_LIST_HEAD(&conn->requeue);
+	init_llist_head(&conn->cmdqueue);
+	init_llist_head(&conn->requeue);
+	INIT_LIST_HEAD(&conn->cmd_exec_list);
+	INIT_LIST_HEAD(&conn->mgmt_exec_list);
+	INIT_LIST_HEAD(&conn->requeue_exec_list);
+
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 358701227f7f..21579d3dc1f6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -150,7 +150,8 @@ struct iscsi_task {
 	spinlock_t		lock;
 	int			state;
 	refcount_t		refcount;
-	struct list_head	running;	/* running cmd list */
+	struct llist_node	queue;
+	struct list_head	running;
 	void			*dd_data;	/* driver/transport data */
 };
 
@@ -212,10 +213,18 @@ struct iscsi_conn {
 	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
-	/* items must be added/deleted under frwd lock */
-	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
-	struct list_head	cmdqueue;	/* data-path cmd queue */
-	struct list_head	requeue;	/* tasks needing another run */
+	struct llist_head	cmdqueue;	/* data-path cmd queue */
+	struct llist_head	requeue;	/* tasks needing another run */
+
+	/* The frwd_lock is used to access these lists in the xmit and eh path */
+	struct list_head	cmd_exec_list;
+	struct list_head	requeue_exec_list;
+	/*
+	 * The frwd_lock is used to access this list in the xmit, eh and
+	 * submission paths.
+	 */
+	struct list_head	mgmt_exec_list;
+
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
@@ -352,8 +361,8 @@ struct iscsi_session {
 	struct iscsi_conn	*leadconn;	/* leading connection */
 	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
 						 * cmdsn, suspend_bit,     *
-						 * _stage, tmf_state and   *
-						 * queues                  */
+						 * _stage, exec lists, and
+						 * tmf_state    */
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
-- 
2.25.1

