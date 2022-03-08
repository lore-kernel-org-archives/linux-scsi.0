Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AB8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiCHA3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiCHA3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C331EB7E3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:10 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L8Mei009301;
        Tue, 8 Mar 2022 00:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NkCLkD4MmjyDdDLtG67HYxRigQCWPWgbMU7ilXgdNCI=;
 b=lrmJT2MgkGJQXltuQxEyVAB7569srGnLPzpIdoSD20FEVxGeqjdLL3yT2j5WL9dMgJNb
 jZOp6zGd/rBVQX0xVlXrs7aUWAt3BnJji6XFC4h5DNxTc9qnEIQSMgZiBo5UfM8tGnax
 aDdtk//YR7tyYkamhIAmTb3R/OtBeIEGFstruapxDcwfjFJj9rxf2ERb6PPsgphFLAuS
 sMnJEU09gPp3TsVtMJqUDafraJN5XE9xPlGEEX8Kxk99tQ4CpwV4J4R9LMN9LlGzgjt/
 Xytvm2D8dFH82UEh2YviyZtIGnigYeWKI2hYeY59bwnHUkqLShe4EJ3546dyTCoRxXzG IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdf49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKl1134578;
        Tue, 8 Mar 2022 00:28:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiMwRZ6aioV+PaZPbUA3zbKmGcpjKteORJ0JA27OI2x9L3DQs5uFekXUak+9FU2ADVJl7KAbRZhvq3goFAmXobJIqLBaCJgyJJVT4kmAAyAjvrF0KWfgVQrnY4ZVRFlPiWqwQnbQevi6w7Lp4BYbHhPtSYSicFBdmoWr2ddShIDivtf7V6ItWLtqSt4Qj6BiLuKeqS4oAf435m/BrEpQx2NGIcPK4Lb9nZSV9KXHcAnDczcChG0btZl1hKURlc7gXrv2LyLCcMwhghKvkMRhFqBmNeysvQT6LW/UpZBvVpLVB4cgfTU4Ng4l3QgNFabTQY/RisKIDMno6ZOrz7nBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkCLkD4MmjyDdDLtG67HYxRigQCWPWgbMU7ilXgdNCI=;
 b=kUc7OuMpSnpvcCEgj/FXD1SkW4WkJyOJ7JUr834MfQqPd/O3VDBmrqM0RsBqx1HM8hIci2fDVxHbwMI9W+rx1bqVvtts2iIMzUS0ZsXkV6rMeWtWGTa4EpcUg7BcADKArRQT8EjlLUSTh9kIX2fECdII5Q30fa9UDMRwfFnGfkcBmuCBA9bjI4BkPaJVcfx0w7E2Gc/Yz+78M9DyaNdAbvOb9AygIPIpOE+LNUyiXgimw2wxIDJUvHq4kcF7nHAsUFIhbf9J7gdTHTKnGeF25BjJy61KmeFBuJ/8RGYfZW5aos0cCSKQkFOzk2URh1ijYM3Bj7+1BMSjOt8Z18Cvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkCLkD4MmjyDdDLtG67HYxRigQCWPWgbMU7ilXgdNCI=;
 b=BXRj5wjdRol4FIb3nl9xQOF8fJBYHHrD3I7Oq9j4OZ5NUejAK8LghGUWI2mVA+XcMx5jNgMJF+Tq9jRA15mvNE7lDT0OWDcV8D3JdfTRFYUfG+amAklKX0u3soCbUdzLPng2IsxYxt+RGGSo0BUj+quuxrdjvEGJxDDzphhnVlc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:28:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/12] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Mon,  7 Mar 2022 18:27:45 -0600
Message-Id: <20220308002747.122682-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 605cdfef-e320-4978-4abb-08da009a8025
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB28096D8CBFC58493CBF9A8E2F1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2YYWxB9S2JWhek2pd7y87slL5xkOdJL1mG6H5whVYhSBIVe+BlyrwMkU/9nzcKIW03eSBkFP6FbmSk5RrrhUAx5iZSdjuHyyUFLTd7pztL4HYvFirVBiy59a15Q+y4qniboB5DHbM4yA008Ciz0i/kU9mrB9orBT/AvLM9vCDZs6swK4g3W9L5J9XtkiaFzPbpdov6MSiqmYU7ds9v5Il76SQUrd5jlYaj/QRlU7ckllHZ3q6RsuytvqlHLrNBkRaJC6maKYnSlnq8D3bo0raVqYTLOS/aw32fIs7u2voSNZvFw7JZ8ctMgB7r/jMA+sPWcD6NqLdcMMYN+kowJP5at1LJ9f6IWFC/JrCFF+EkpKsBKPiIIBa2VVsi7bd120riVbMI31n0haX+ERNnXi3Nw3nhYPENlso34PsKGZUSGPVRXsOGAxkc6HXSjtc38guDRsT/iBP1Y0pnmTW0wqvXTLrI7kNe9IlNzW45x8OtMGUsAw6US3PvBhNo2erCR7OBtluKIedvFJD6M3hy2SXwlkFDzQV4YnHdFXGOjD71taDQHxj6N+UisJbBxcpQBFCoYWrqvoLMLk0M/rUElxXZV+CXM4wJZzZNEciBx6cZ+SuGgrGTP9lnXkcKKOuObYIyRo3K9pSTMBMspT6TUiHlgAztSwdjMHMoa1v/zp2ODNLNUtgfzDaE2hVtoCiNPQqaQev+hcZhcs9eKQ/BXzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D6gtXj9aBJdl3RoF4otb150Tk/zFP1Wf12DUuNFqPf9YdfbpEi7F6tUtUFJZ?=
 =?us-ascii?Q?vZbSO9uqTk8aAHlDv6pdvNwA3oaxqOVjbwrC5KMaTq/I+mI3hob2kAucgd3n?=
 =?us-ascii?Q?mGwrt9Cws+LJ6dDw2MPW5MNbH0xlhCRRiRFhy01aLSlkJN21tbf8DsXOqr5p?=
 =?us-ascii?Q?VN1Tou94Ogf4sqLjXY8tk0WwHw+D0sRYiBNx7wwh5q4lTnHCkwKtw4pgex+L?=
 =?us-ascii?Q?/Zaq7M8xg1Qi4LfRD13zNF1nmpvCb1wUCcXb5M8dv1Cdxvvo234rX5I+3YSa?=
 =?us-ascii?Q?jarHVYH0XbmzFsMhewJIA1X2KQw/v5nNRXTBp0Iypzr79IVk0qHfemUDzHic?=
 =?us-ascii?Q?lGJ7KJp1zIvQqnx5Dn8g9J8nMQGIb4LbEcXp2/u1s9Pue5U4JofNH1WupEjW?=
 =?us-ascii?Q?rQic7jEi2qEzoIvsLA3dXLSyJCpWcJ2Q60ORZQMGFQ6+pr3mIz2qAlJ4MT8h?=
 =?us-ascii?Q?C63jdy99OvzaAozQcOVrXKar9Rpn3PHMms7Vsai5PrVXJU09mbmKjYct/FQ0?=
 =?us-ascii?Q?UJDgMw4T2BRPGHnke1IoojUZ9lCEPLfLfp74UKb33v0HPs+Yt0SyCAsLAL+7?=
 =?us-ascii?Q?kmQ8QEWbyEUB694vXQPVs0B95+rX7iG9lTgIcDfVhIQFz9C4oBFRGK2X0mOZ?=
 =?us-ascii?Q?Yr7BTNbnmVsPUjH9pnsRhSVLjmWwCKVb27Ux679l3eotC77lxK54AMvhGDvB?=
 =?us-ascii?Q?DvU60Kfg7z9Ti9JHXITJu8B5Zgq9V+8YBihoS5PfpDSqiW5CdjVpULpAl5o0?=
 =?us-ascii?Q?4ngHv2LZbyp5k/CoBwAcXE8MOl3yINF6bzruRRYNsGRznVPqJtsYMycBfuBO?=
 =?us-ascii?Q?1RF9T+lm+S/Pr86aZ+dsugrf6hSBjtI94U5sZkL2xk9k2LsP3CU84eWHO1QR?=
 =?us-ascii?Q?y5HS5rK3ie8KvP7HO2fw/GgXc01DNI3ZGYk2MHmKzQVqfo+2G9OhhcBB5hLf?=
 =?us-ascii?Q?DmhL6zghr+cT9sBpwvN46YBdaAv6V+hZwx77v9Lz/QV3c/Uw3jnub4ruPImo?=
 =?us-ascii?Q?va4bm8wg036CWYZ6PmiYha7kynPMf6j78D2Ulz1KDHJdSK4Y9QkK6q3IgVH3?=
 =?us-ascii?Q?7q3uN7c1c51d2NEDaaTfp/DZkBb8emWKef/CQUBiLa+9hJGrCNxFAq89eoAR?=
 =?us-ascii?Q?PSbePI45CsnEHVzGr2furfGOyuI5XdAqy19tvsjSeYR0lzLoBVGDI+IbqDSt?=
 =?us-ascii?Q?TXe9SyiSmmPtqcjpTPtuWdhSObZjyV44ND1syH26rU1yuGprgrhmb6lM2iat?=
 =?us-ascii?Q?evqQjZi6ImqWRTyMd1IPFO9rHuITB57HQQWCoCJPCzoMW0UTioFbnLxOlFaK?=
 =?us-ascii?Q?rwe7lQY6sDwLZVqh9TK5pe1RSKImw+LOvq+cNDDOOEQ8FqLqklOi0atReDlz?=
 =?us-ascii?Q?QTtVCARt9xrEBjWanTD7SllWpLPlvJ8qmV2pWc8J80y7jFHF4CUG25p1DljO?=
 =?us-ascii?Q?D95Gd1rDKEhQMv1YG/fVpl4jnS7b9AQlrmkGzn3lNpyMe04l4R+oaARGD+7G?=
 =?us-ascii?Q?cQaeJELjVkQfTfD6EpmPvh690U5KG9WMPuS7URAwAlCrA4jIdai+Hvbat/Ac?=
 =?us-ascii?Q?+MMEa1eT0lotuHCWXeMupVCE45W+VmXwkD3AE5ji6x4DbASOFl5uPIFk1owx?=
 =?us-ascii?Q?o6Xhpf4ay6SZ5KkOl26kU2nY2auqRi7lnANDEqJMFIdcb/AhmazvN4VK+/ua?=
 =?us-ascii?Q?ehzJgA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605cdfef-e320-4978-4abb-08da009a8025
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:28:00.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUsCsILEzWL7dBAqxrGnR1zMuurnwL9hpzUl9vBeBD15eZjUKrU2kLtczGacEpm9ccoGwZGPtJZwAmHzZDLwIu/Zm6JwJmujlMyhQOkdm/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: ETnuCd2TxOYKOhE93FhiYTQFo7DJiDD2
X-Proofpoint-GUID: ETnuCd2TxOYKOhE93FhiYTQFo7DJiDD2
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

