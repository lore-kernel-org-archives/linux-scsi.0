Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C17C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AE66135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhDCXYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbhDCXYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLs8l161540;
        Sat, 3 Apr 2021 23:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=aC8953mzsSDJbWNpC2hTfdHvgnMfNPphW+PPJ1mY8AY=;
 b=e+JkNBp+tp0z8WMcrm9q5xjq4BR1QAPqTnAVQiz276gh0K0H8C17wQgsnhWm3TCgy+oh
 vpsMrUSm94PutEapyzwkTFcb4CjdGU5+PB+S8HC9LWtnw91rkattmU5YP7B2sx/L9adz
 qNErhduq7luags/GjJhkZNzzBX5SkWVygQmJWwAI69z16uda8mP9QJpslJ7xZxybMp/o
 yQq6cR13z0OdpuitPVNjvikqmLdzTtazCES6Y3TeftVQHPMley8UizdeidPY3Tx2i/1C
 IMa1xHQMIqUCLhyrnWXggx25E4CCDm6pb1DNoDBbo4hV16mINFaBIaxfwH4Cz/NsomgU ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtWj117032;
        Sat, 3 Apr 2021 23:24:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbsrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjdBfo1UIpChwNakGBXEhFC1X9ajJGq+gtpAYMorN2LuQkg+yzewyOGPrcNTv1elhK08vlD96xKjjyZXbWG36vtwY7UBW4KbdL8IHgBIQlwvuS2mdVIBzwxdSAbjipovhhICWTG8HvVZ4jUUW/XFPq0Jx6eU53eW+gZ9EBnzpcE5cFjQqWH0L5qFwH9kIc5ij4BpKNtSpZbAc+MRHKHOnjjN12hkxZ9G+EXGQ1FtFN0lx1Xq8QzsxfnwVT36XrUpcowTeWnXU0Cdks1WuBAIDmKKH7WbdeyERTg09kFc3WMtZp6NgNox+kmGGKWBdY7E6IRa2kfYV9/hMr5boNr3ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC8953mzsSDJbWNpC2hTfdHvgnMfNPphW+PPJ1mY8AY=;
 b=ZkvToi2Ax5t7EScjWGr4J6KtOrQKnaIUPp+sQZSJDwBq5o/dAzODx1yo3PlSIw11VnBmrWD93ifsaEwkAYpBrMueNsrz2Q60ZrbV1g4Jw3Patvj7cD7rd+mVMZz19LdO2se9mMluMxHIwm7knohUASQtnA9BiQaYRVs5cEyx9O13LKcovKN+tab8sREVkYJ5deLq3+SEMKrQou26JHBQwT7gNeu4ORKg4BTaNduJXOyfSj6cQBKF2bjqKJz3rQQy9CJ6rI+HN8OwZv4g3U6Q97CrE+5b/2IBDue7//Vg7fM1p/vmP/tZOaK9FPUg9qheGQcCaMtjRp/U5fhB9c625w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC8953mzsSDJbWNpC2hTfdHvgnMfNPphW+PPJ1mY8AY=;
 b=Oo1m0PVO98EC9rFnWsjmR9wd6wuDPFQtD7TpjI7QFgSUtFfezuszBOM8IgP6EVP/oKf7hu0emex81/dTU7JB6SRa3oeKOWsZfC7+W04b4/YHXlNWjBJnTutxckoRjkLBcCxw/f2N5AAbJ2+RJmqURvIY98H/S84FLpt0IMbeR18=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:14 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 23/40] scsi: libiscsi: remove ISCSI_TASK_REQUEUE_SCSIQ
Date:   Sat,  3 Apr 2021 18:23:16 -0500
Message-Id: <20210403232333.212927-24-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee028ac6-2641-4f21-5675-08d8f6f79828
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431D46C80D1E231548907E1F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJVjCquGD5hpXgL79Qwp5arCkRCBSByet+D0AwFdx1w43U0ANjzZJLVTSxi9PJ+06/9C2n+EMjX/E/ZpbxfW9Yt0tGlTt7E114oFqkhFRaLT0UiAN/sXFB2bQCv3xoA2+Kiv10DZDFeOxlQ/81Rrn0FW+/mXkqXW2TK88H4b8R0IwRgs60QowvkJSP2gwD4xN3lHNUrnHG0SiKPtsa4NpvMRv6f+FgxZv0zfS47oNS2jFf5Ueh31oAmuKbynsiXPPmjmFzRFQfshsGHNSZ+H0awRyXKnkHDykOy0N/pxGPqidSd/c3ieQa6x1BqG7YFj9+1WY+qd6LBF6xDcFs8kbVFisw4hDkfoi7L+u9q9nDDeGJIll4k/0v17hoZUkLAvxeubXTTDzG6Znf/bDPhPLKuv1ng+HhAEKKFTErzNSentYX8TmHQdrSGMm1t3Cfx28aCNfBoUdub2+zob8zppHuPvzU+ixJqgknU15YSLH9I7ZEyHhGoAFIxr3i4UqbfKvzssK2DcJIxWFXvbucdPFtdoQRwQ0HrokkIIs3RMeB1YDOAbcGJtey0aE121nh9onbnOrewWv85fDsnCHIXl+swQSzHh+EO0wpoceklDDO2ztbPD/jwlTLGZGGTyXspv/tuuh5sKh0xBhMP7inat20FxE/migUTOnem4osLehJKz0WsBEubrd4HMSdoSBSAJKZ7QObYTzG2BnwyWi5KVoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700001)(69590400012)(316002)(7416002)(478600001)(2616005)(921005)(4326008)(66476007)(6506007)(66556008)(86362001)(2906002)(6512007)(107886003)(956004)(186003)(8676002)(8936002)(6486002)(52116002)(36756003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jw70AP2VlX4An67oregSfdoZ5jGdEgaae93f4mGCVX/8AT4AuFtxAG4bqjuV?=
 =?us-ascii?Q?OKPPJqsmD9ZwyRoKppucLc/Rhf+mASUji5rFSzidVv/Cz8t7gdkVpxQW1JQn?=
 =?us-ascii?Q?XD7tNCuwbbMjjTJABXJDGDjgGCHjt1GHz+ynhEV2DSuh/zfNkpZQ+/fYDS8v?=
 =?us-ascii?Q?cJ91uVGWG6o+f36/BphTh/TkXotW/WluiGjG8Du1W3XV6YrQ008bkSDfOoQn?=
 =?us-ascii?Q?VM5mTZZo+vpR8d+rSI6eJBy+KzRTHVvXojwCkFR9p04BiLMIJXjfwNjWdSpk?=
 =?us-ascii?Q?0O0InnUwkgDljHvJhxz0SuddiWvj7rZbJSMItmI05ygsCagZwZ6a5XNdN/0+?=
 =?us-ascii?Q?Q9HNvP7SK7/b3qNVzpGkk+/SmEscMOnMrYX6I0d3O5RgdBRbq+J97zJ6XFHp?=
 =?us-ascii?Q?s5vDNfKW+WlaDPfgpn8k7XFlKWTHqLSPDsnQxNdBQGeL+swmhpQ9bRp0haYV?=
 =?us-ascii?Q?41YukqcKuWrqg2EzolIIZRbC+5NZXx9w27Dkx1RfNyJzxetO3cFRe5Mbj2vF?=
 =?us-ascii?Q?XZXNuHTLZM656tMf9rIlmZHjRfk88Hty8lgNxzrqHhSgH+mVd3/CxyFjlkkg?=
 =?us-ascii?Q?iEs4rizwHMQiO6azIuxRrp8ot2xmIyEej7NJD0iTpMGDcStvsfTQAmKYi1NB?=
 =?us-ascii?Q?ltCY1SEazznjn4Wd2QpKc1sUPk3AUUsEx0PAUe3pma/c8iKlLhMZRLdm5sEB?=
 =?us-ascii?Q?zP+2/1mXa1R9l1cIexJVyquUjSX8Rh9rOi22kOET02YkRJ64gcNYpVBIJZZy?=
 =?us-ascii?Q?XDSm/56mgLqjlRNvBLYbA3AsPFWDjXi/7XZbJ811T9LXTsAb+aPFE2D4NErG?=
 =?us-ascii?Q?u3WV9p8bEgxYCbHefhuWwJySRDlYw37ZqI3jHoUYzzxSrYIAjL3xgGO8mtDq?=
 =?us-ascii?Q?MbXXzfgXL3OAO9vpCD5qjuyVLBhM0sKTgpti2KGjM2BVUVKDb+VBLgFaOfVf?=
 =?us-ascii?Q?54nAmuVtmmmDSQzmCGM4Hi4ESzYnnmyXUnrWLaV1eevy90iu8M31oVarv5jl?=
 =?us-ascii?Q?hPexK27xB98uU4Q5cp0+XbLugz4hRf5c6RuE+8A17ZPUkXS2fwC/Nwb4I/am?=
 =?us-ascii?Q?FDbLZeahgMv+tQKRTUcjgA96w8erEjwc0cfKUvGRKHtEmR4mXyDaCfgwEelx?=
 =?us-ascii?Q?1Gbj/EAUXxX1d79KUVLHIi33kn6ZJvuFW6mmgH8Ixhh1JqJcThXMZOXEDYIW?=
 =?us-ascii?Q?vpk1w8YSqjSzPmHGBH8yg9Ue00VxnvtU/5dbMvz+9LPHYJC+QSm0rV8La/oa?=
 =?us-ascii?Q?Mr94ecfS+UCrvu/34YOrCuJZGO+iVmN5wBfcTQQlWGnN0SsGQiKRpE7x8PCA?=
 =?us-ascii?Q?35+znsT02/N51pOQmqv3eF3r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee028ac6-2641-4f21-5675-08d8f6f79828
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:14.4919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HNzIif8cVE9VZRfGz+mAhyYbO+QE5ZN6T2VDQFCkj1xuBhGYJHYEjZJj0p67bYwG9oVmuX6gbIfApC5xZOwrEcrBJKa1CVtWJ3bfDH7F7Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: J_fkH0kTv3nKi82VdFAfKCcyzk2czB6x
X-Proofpoint-GUID: J_fkH0kTv3nKi82VdFAfKCcyzk2czB6x
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ISCSI_TASK_REQUEUE_SCSIQ is just kind of awkward and it's wrong. If in
queuecommand we are going to return SCSI_MLQUEUE_TARGET_BUSY then we
must have finished up cleaning up the cmd when queuecommand returns.
This has us call the final cleanup code directly. Because the cmd was
allocated by the block/scsi layer and we've been under the frwd lock the
entire time, we know that nothing else has a ref to the cmd and we can
just call the free function directly.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 39 +++++++++++++++++++++------------------
 include/scsi/libiscsi.h |  1 -
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e2f3217afdc9..00a25af9eb98 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -437,19 +437,18 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 }
 
 /**
- * iscsi_free_task - free a task
+ * __iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
  * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
-static void iscsi_free_task(struct iscsi_task *task)
+static void __iscsi_free_task(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
-	int oldstate = task->state;
 
 	ISCSI_DBG_SESSION(session, "freeing task itt 0x%x state %d sc %p\n",
 			  task->itt, task->state, task->sc);
@@ -463,18 +462,21 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	if (!sc) {
+	if (!sc)
 		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
-	} else {
-		/* SCSI eh reuses commands to verify us */
-		sc->SCp.ptr = NULL;
-		/*
-		 * queue command may call this to free the task, so
-		 * it will decide how to return sc to scsi-ml.
-		 */
-		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
-			sc->scsi_done(sc);
-	}
+}
+
+static void iscsi_free_task(struct iscsi_task *task)
+{
+	struct scsi_cmnd *sc = task->sc;
+
+	__iscsi_free_task(task);
+	if (!sc)
+		return;
+
+	/* SCSI eh reuses commands to verify us */
+	sc->SCp.ptr = NULL;
+	sc->scsi_done(sc);
 }
 
 void __iscsi_get_task(struct iscsi_task *task)
@@ -516,8 +518,7 @@ static void iscsi_finish_task(struct iscsi_task *task, int state)
 			  "complete task itt 0x%x state %d sc %p\n",
 			  task->itt, task->state, task->sc);
 	if (task->state == ISCSI_TASK_COMPLETED ||
-	    task->state == ISCSI_TASK_ABRT_TMF ||
-	    task->state == ISCSI_TASK_REQUEUE_SCSIQ)
+	    task->state == ISCSI_TASK_ABRT_TMF)
 		return;
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
@@ -1844,7 +1845,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	iscsi_finish_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	__iscsi_free_task(task);
 	spin_unlock_bh(&session->back_lock);
 reject:
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
@@ -1855,8 +1856,10 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	iscsi_finish_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 	spin_unlock_bh(&session->back_lock);
+	return 0;
+
 fault:
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 589acc1d420d..ceb01ef12002 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -97,7 +97,6 @@ enum {
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
 	ISCSI_TASK_ABRT_TMF,		/* aborted due to TMF */
-	ISCSI_TASK_REQUEUE_SCSIQ,	/* qcmd requeueing to scsi-ml */
 };
 
 struct iscsi_r2t_info {
-- 
2.25.1

