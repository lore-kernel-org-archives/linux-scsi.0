Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5964DC47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B50610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhEWR7z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhEWR7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuqae164339;
        Sun, 23 May 2021 17:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=EmD5ql0JeBCY4sG5cOzSOhQMIBPlQnQhYFs/LzsA/abVhXLCej4xmW3Q8tqsNE1UhLdk
 U7YLWLf7+oANFxe+EDkdQ1uE12tHiLySeBQilOv44w2fhuca22xhAEve2Hsv/JwYATS3
 EZVpSm7PvbBePtt2p6ellm0L1LoojaidggsN+ckWBHGBVfu3HJFzDU0imHHYcfK+dhDS
 LfoT8pQmTYUHGwaoMOBV8bhCsxHVQGGthgYHlcQSW5jlCtSKPk0vV/q4d+K5CK5U6G44
 wxh8itB1AZfVDJJGi+NzCRfQPtgzY8jhmOW/8gNdRJvqdwFfOwfxmClFnCG2G/Iwgw2Z EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDp161766;
        Sun, 23 May 2021 17:58:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewVsIIzvsAIOsYMnvpv/6eHeh4Z2PsxuRvgRtiF/VQbya0grGWNQTcVgYHTkCFIHzzCSOhr6iGLM2ORX+hMb7dr7/XSsBwStRkvbrZRID9gLiOZnUxkAlgQ5IqXuk/eXL1/xjgJjfPFqT1S0n1R1+oYCm5Kr/zEMTkB0115QnmvNIws35hh49Xn/+a5ufSp+RSVj4T7gCE2W4ZtTSi4mqb7WJxhu5AWXgstZh4J3bv532U5yRrInjPps0UNPlUadMM9PmL8GioZbmNpVfm/A1bD8IZty2pMJVO8+ZLCHly8q9EVtCEr8V6Zud5NfK/9K1DqhNcYy4reGnb02hNQ22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=CslIsAwm4KEKaClO5jjTsgltYgngiFsKq6WGdZufxrWWmqQPneRbJkpwQc36RCwc0qqhUTQEuvdYMcB5RXaWUSuY74+LNxDXryd3uIYgZL58p3pTk5jXxOvBlxgk3cVg7ygWRIVnnSszqlWKcKyxph6QbN8RE0gwUI04UWniTrFdbyPIWlkuGtAo03cg63OAXHOCoGMAV57/7orjmR9kNpvawGuLT+IjsBKdbl/DMFJwyXMOERUta9kmm4Yd4xl0ZoP/A64vY3ZOuuebCDG8lGOzVvpAbsNkdTs6WDERG+USok2nPX5PBFUJQAdZDjOjpNLEjiCTAtvU2hl+4Yst6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=z5/doGpwi3V0MS8igSh+DRoK/mhj1Z1BfnFiUQG3suQZ/ydIP8Pdf0e0cl3dC1BOFCtmBoeFNBXKkkJujaO2zCpW7Dbwu4tvaY2QhMc/BvbBISJR5NtPW2MEoK5PNKA3mgikwdFUDLTb71U+tikeYCYjPD+f7B9r8FJ8OA2g5/U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:13 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 22/28] scsi: qedi: Fix TMF tid allocation
Date:   Sun, 23 May 2021 12:57:33 -0500
Message-Id: <20210523175739.360324-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f11823fa-7e12-43e6-0c7c-08d91e145542
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32391294401498C4A5A5B9D8F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJEnl6HinWZo//OnKeXUaCNe3goLjZC9KMifvcdcE8CS5H0G62vnjFLH1IZz7O84Tzmdbuaircmcus0VokP4jFqCWSfYInKKAb0VuIeHjnxAhDbJmiYOHuuh/OupQ8Fenix3sHPim7ybmfXtMUglB92cWUzDfzykqr0kHYax/tjMb1IiFHYhNbT3Oncm4jMqRAs/5onTaaZrm86eRbAFPwMnZe/ihDXSlLulZ9vekebASMRPxehIhHMxeZb/wUnYtZlFP/KllyeDQwSvErF5KDD8JlINrHL5sXvvQCWpMgDpHbksemxd8e7mgYu2NyfTPv+xT0cVq01jEb47LdXU0N/c+WJc0OzJOYFkBRfglJKKuiS9axisT14PruVDwDY9UF7ZxttC/joCcPlGaoi6ghvoli0lMN5XjHdVxv5vSzlAl+Q63WcTbow5qDaEgyffXh226PfbElsuEtq83XjOHiOgRdmg7C2T0xpccBnhQKVATFpSy9w+XKMoNbVrFMD6DEgVM5RXpNaN0VrfKSQr8UXo2VBMKUmUnb5Nx6w+uZ5rrekOj6ptvAHHNxMDqgoW1sZAHJG3e8CzNXCYCmlbmbctm8AyL3spNw1oMoX5Keo2fWye9AUAlrtzSpptLSMM16TDAyLzDIEo6OXYt0LmUBtGpZC+q26loC1pvuaTIN+y+eMH1FNgZ7plPTF9jJw6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QA2aGrixxSIKskDW0/UZykv4lswUxyok3dGpeXz453X9qJkAdxfYiVWQKihe?=
 =?us-ascii?Q?fdeUKCwWNjMj95XjtEv1e/iWUSNAuO6ImNk3unR4pl1hufBfmAW7+heeYO/E?=
 =?us-ascii?Q?DazzUnrXUNecY1EdPOtXwg8q3EiOohLcCSCaKH4kUdOpnaF+sARB7cMKzRfO?=
 =?us-ascii?Q?h6Oc1Tw5rhqtwlcDUih6AXW+dh5iOq4LORyGgRRbZqaVvn0sGjvVAiiMwKms?=
 =?us-ascii?Q?CqtZ6FbfPHYC/AHkYaXxZDhbTqnLQBd9c/9KCiS+aOon+3wa34dIS7J/5bhb?=
 =?us-ascii?Q?ujeJ3aqV91jWU1ho3ajeTQKJPPDNBbjcuUSmJ8MEkoWHZYO21wCKdFoFYEux?=
 =?us-ascii?Q?VywJ5KnkGBUTu/zRXTJHXtt4DI3jffxLOqYI5dWps4sfQ7Qro2LswMl609h5?=
 =?us-ascii?Q?Mmrb0pdX4i6fjBtihc6mrn0NH1zc6sc97VRjGDl9CvMZPFZvlZ1NXpvpi+Qf?=
 =?us-ascii?Q?pf82ctFU0X1I6MOqVclbbncjMsDeSb01pPnu/IyNCzbiFBWFskKa7matutdH?=
 =?us-ascii?Q?ikSqrQIf+QS/3gI56/sf7xkMl1oQOxtewlnbAdMP8h5S5X3SZmD97EeKXsaT?=
 =?us-ascii?Q?+hv6JfCK0Moib2yW5hZXhMIGNZLfSIDd2YzhfgxEV2TWAkOb9Th1KNTTU0uq?=
 =?us-ascii?Q?nZtaBBIqGUThRlpe5EKQRCwqHEYg/ONyTONq0LrsDEjtSBEy/UmAzKtJHFfQ?=
 =?us-ascii?Q?PJWf8Ks36wFwuT9Nn9j/pcpDszKQs9chovVWsR5ueK53JQs3PwQuRv3lD2Ap?=
 =?us-ascii?Q?5AZ4EzhMeKJrepcsHwvK3kjp2Yl92SpwMx11WGM80Cu9gKaF2wlteZF2y/5g?=
 =?us-ascii?Q?HzN0NL7i69qUQSIjH2JzdlazC30O/nQ3yeRfheL4IwgIZwWtnCV36X02fiKV?=
 =?us-ascii?Q?DBdzWrq0zHrfZgH2bmTQvJa8qUr5xyNSvceYHXKgLdkV4+xiCC5ie+XBI1JM?=
 =?us-ascii?Q?RgUIf1KnUjkuOnCkpgjaWrWLfmjGO0/xRG/XXFS13/YgTpLmf8EnAnOxrjgx?=
 =?us-ascii?Q?mZ9mVPOsdsIXscq4j9IOEMeS40Y+BuwuhFDRLTZ1BHN00mQKzB3PakPd0ieQ?=
 =?us-ascii?Q?JbzUandBHc9Rt3M1g1yC/3GkgABO33pCTagSnUuFBQIhzjPUEXBEn7NOkwgK?=
 =?us-ascii?Q?ZV/nGEEO1HF67AcjvvEQgkEF76Fb+tRY9m0IFyQ0TA7XO3sb0uu3wbcgNtoq?=
 =?us-ascii?Q?X06uQzYQ0C1TLGghZCGG7IflnS+JdoAH668nfAuKAoLNvwuyFXv+C7xvPK/z?=
 =?us-ascii?Q?RN0atnmbd8iX5Q1jEuRsgDhrK6++niMmQ7UQKKvgFD5JkoufI8mbs2mf/64D?=
 =?us-ascii?Q?+/fNv98ywmyedEqFCIMHXDZp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11823fa-7e12-43e6-0c7c-08d91e145542
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:12.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6fnmcviufDnmhGlL6MdVwkSbZXKACTZP1eFc8TLMDbXGEWMe5iJ8GAc+Vc7xMsLghBPbFnaPI8SPZlr5uEBGDAQSvpCsXR1Ba6K/5TKoew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: vdRWMWkqric2vLyunkmy7OiALtUmErTa
X-Proofpoint-GUID: vdRWMWkqric2vLyunkmy7OiALtUmErTa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid
allocation from the callers.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 61c1ebb3004c..6812dc023def 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -14,8 +14,8 @@
 #include "qedi_fw_iscsi.h"
 #include "qedi_fw_scsi.h"
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask);
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
+			  struct iscsi_task *mtask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1348,7 +1348,7 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+static void qedi_abort_work(struct work_struct *work)
 {
 	struct qedi_cmd *qedi_cmd =
 		container_of(work, struct qedi_cmd, tmf_work);
@@ -1361,7 +1361,6 @@ static void qedi_tmf_work(struct work_struct *work)
 	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	s16 rval = 0;
-	s16 tid = 0;
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -1406,6 +1405,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 	qedi_cmd->type = TYPEIO;
+	qedi_cmd->state = CLEANUP_WAIT;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
@@ -1433,15 +1433,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 send_tmf:
-	tid = qedi_get_task_idx(qedi);
-	if (tid == -1) {
-		QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-			 qedi_conn->iscsi_conn_id);
-		goto ldel_exit;
-	}
-
-	qedi_cmd->task_id = tid;
-	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
 clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
@@ -1467,8 +1459,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1483,7 +1474,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	u32 scsi_lun[2];
 	s16 tid = 0;
 	u16 sq_idx = 0;
-	int rval = 0;
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
@@ -1547,10 +1537,7 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	task_params.sqe = &ep->sq[sq_idx];
 
 	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
-	rval = init_initiator_tmf_request_task(&task_params,
-					       &tmf_pdu_header);
-	if (rval)
-		return -1;
+	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
 
 	spin_lock(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
@@ -1562,47 +1549,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	return 0;
 }
 
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask)
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
+	struct iscsi_tm *tmf_hdr = (struct iscsi_tm *)mtask->hdr;
+	struct qedi_cmd *qedi_cmd = mtask->dd_data;
 	struct qedi_ctx *qedi = qedi_conn->qedi;
-	struct iscsi_tm *tmf_hdr;
-	struct qedi_cmd *qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
-	s16 tid = 0;
+	int rc = 0;
 
-	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	qedi_cmd->task = mtask;
-
-	/* If abort task then schedule the work and return */
-	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	    ISCSI_TM_FUNC_ABORT_TASK) {
-		qedi_cmd->state = CLEANUP_WAIT;
-		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_work);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
-
-	} else if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
-		tid = qedi_get_task_idx(qedi);
-		if (tid == -1) {
-			QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-				 qedi_conn->iscsi_conn_id);
-			return -1;
-		}
-		qedi_cmd->task_id = tid;
-
-		qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
-
-	} else {
+		break;
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		rc = send_iscsi_tmf(qedi_conn, mtask);
+		break;
+	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
 			 qedi_conn->iscsi_conn_id);
-		return -1;
+		return -EINVAL;
 	}
 
-	return 0;
+	return rc;
 }
 
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 116645c08c71..fb44a282613e 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -31,8 +31,7 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
 			  struct iscsi_task *task);
 int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
 			   struct iscsi_task *task);
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask);
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 			 struct iscsi_task *task);
 int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 5304a028db0a..0ece2c3b105b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -753,7 +753,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
 		rc = qedi_send_iscsi_logout(qedi_conn, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = qedi_iscsi_abort_work(qedi_conn, task);
+		rc = qedi_send_iscsi_tmf(qedi_conn, task);
 		break;
 	case ISCSI_OP_TEXT:
 		rc = qedi_send_iscsi_text(qedi_conn, task);
-- 
2.25.1

