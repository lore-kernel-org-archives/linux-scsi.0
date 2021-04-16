Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB82CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3EA61158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhDPCFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238017AbhDPCFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G25BID099295;
        Fri, 16 Apr 2021 02:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=WNDrRE/Tk7hCvS0++2e2OfdORr/Cs1c/8PDND6W8eCepWkjRaq+6soNPQDEf9W+VDz6p
 oIHHLQPGSYI2KAdqHYgGT67sPMQ0vnn2nqbqDF6KbPZOD+F2WsD+LIG3f35GVFyKTEpI
 OpQVyodwo7nxUmACTywzC5JIFAMPU59GITvupIqAW0l7ycSN2M385+N0ywpL87H9EYVA
 dN0vZVfYHdWcsUi+Y36PjYfpBdEvvxB3NcIS1KVDX95lQF6HdiOlopYIsimCsWgn1YAF
 5HP9TJu6fJsp08BCpW8LgHuOxhvnXVgVD7rtd8Na7eupTZmVjjEKefe77m9D/7fTMA1K mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xuPS008904;
        Fri, 16 Apr 2021 02:05:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 37unx3sp7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkto3ZZhQh7kHGzGqwUzPoYtJvpaq4BmOLACVRli2LUnsLn0+SNo+NF28Qa+C3FPVHldvQH0XRqYR/TZhNyvdV7QvH7k1KBJu84g6FaQz2m9TCR/AR2diCJb+06lRSPZ8wMiQt8ivaRKBDGM4bxxnu0kKmaKBMujYfX0VBt93YAia5773mOkq+JC3ekV7eDrfjn0ZDLcehHkGaTLigsZmvFj9wq5vPDoN24onfsBMlQHpIpsf5w6E+1rd5++5JGYGSQxHpJ3GgMeIrJfyoD8BAMjZuO5+rc61rFMEXp0vZsse6aPwH3QgVDHc8bIBLJ+DbIbptKkBtXCVO4uShvccg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=RhwKr4sKNX01SnCMDQYa0RyV5pMl1q3uPzykEPUvir05la4iKql4GNgF9LGURCgv8nB8IdL89eTaaKDEMYPvkUaHht7dwhdt5qzNRvigIoWrKYAilfgE28XKhHWzi09JGmKXj3KXsQMfn2/tXZlB9yQKm6HfyUjUp9oLPDlUhwNcIoiH/3actR2EFkBmmpUMlgkxjVrHQQfwM+W2ikxRAjSxHGSaEWnGRbfGwZQw8J0EU5JnuKqeebNx8jCJi9+tXp6ysiEzx/X6MhcYZgV8mfahl+TOnWw1yzIkoyifAPgmleC9sJpXt/9r15BG71fFqvxX+fuywzmc+JmL29DGaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=CNaR1DAcU92yLeXpA4QhCUFzVEWz5NwP+WXjs32QWlzu0b3LloNYqRghmxkHT3zwFjQvL7AhaFJXWAmL6r8i5XOxKsLCdpwlOAG6pXNgM7fiCO4xoLqBfpEYsMNplxLrD1bdBsuiKDevlMBqBIoMVekeTZe/Y1pku2Cd3AlF39I=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2423.namprd10.prod.outlook.com (2603:10b6:a02:af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:05:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 17/17] scsi: qedi: always wake up if cmd_cleanup_req is set
Date:   Thu, 15 Apr 2021 21:04:40 -0500
Message-Id: <20210416020440.259271-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cbe8285-c602-4a69-356b-08d9007c0f54
X-MS-TrafficTypeDiagnostic: BYAPR10MB2423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2423961C046F7C2DC63A9B3CF14C9@BYAPR10MB2423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uif+9ekSA4TDqgCO0n7gK6nP6k5st43yYEQ/wyyLNr7KoZ7uo4vgzn+QECEwAtIffAJtyPW0MW0G3vUE9j0FAe7DjgJmDPlvKucU/V1e7TsrFLyAqmGaerNuM/awlgjJXNav1BatdNtSAVPAWCGFGk0QWpUVvSTo55b4CKH8Qo14wmviO8uibfutmF0S72Hvxt+aDy1jLivz9iMxHupc/Cn9IvrbZyZW8kwK7z5g7kt29pLSp2zGZYgHSp93Ku05bs6UecfKfji4gw8ZvuhmXINZshEHxfiZ8gb7Xgg6JKqCWVGY7pcCLy7tyMRQEJhqt82E9exyzsUjW+vLTtQPuJaPx+fpfNL938icRNShHW0mIMheYGGAScECPQLEbRwHGrHsdXJrOsi3ZIHXtLzhU5/CoHjtR9a1w/NFPdoSo9i91q01ieLjYACLCPHeddrEw4AXJvWYk7aChc349KvwEUy7FB6jnVDZP0hfVzAN5gKSTb0x4f3MPNKTX7/yhHFl3Jd3BU2p/WHap1+iv66Zhmj2nwgAZPDUv1Id0EGpF4fRb511t9nyvjnCQcOIrk0HssAU0GZaxg5qpKBtSlXc37gYdDWGYPRvxPDJ8irc/7AcnHcuTSL6b8czvF+Ysy1BrXFDzh2u6i7OuNyoMzqbrKYaQpDxFDa69vABdMvEOjLBJf3IlPlONjXpUY0794EP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(5660300002)(478600001)(1076003)(66946007)(316002)(8676002)(8936002)(38100700002)(4326008)(38350700002)(107886003)(66476007)(66556008)(86362001)(6512007)(6486002)(69590400012)(83380400001)(6666004)(16526019)(186003)(26005)(36756003)(2906002)(52116002)(6506007)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rU6RYm6ttm8uSXV9tJUzbr1zrIeBzDySHN3YfIfVv3znWLkPtPMLcJ0P3lce?=
 =?us-ascii?Q?dRAZmiMtAORkSoDAo2tChQN/RAgzyhQENoSDw7jpenv2FZ2hbEoor/sqQ/q7?=
 =?us-ascii?Q?cvdCEWD3DYvWdrS22gvQmQ6ot/OoKndNb64ghMmh8u5qqCOzHcvrI7LDwV6q?=
 =?us-ascii?Q?nK1J6agmngG8GnMGxpdszovbHYiBcGE4Q/TiuJ862xoMcIjJuMTZFLrZTXQI?=
 =?us-ascii?Q?wEASZA7Hb6AKSLhmLw7VE8nTug380wrLqCqW011+nGVsKxJuumJJstKZGb3o?=
 =?us-ascii?Q?WMvITd0xlnUXrN1RdqeHg3qEtiI4Qr1Flys83VVY0CAE18B2n3SmiUFqUokd?=
 =?us-ascii?Q?9CDe47ToD6566I569Dle7qQfiiPwlwDDSV0vyBVO/TnfEZPzESqjVhi36Gqo?=
 =?us-ascii?Q?ivLt8Z6QVrPKlhNmO2gKfc/1Ljy6hyQNzP9Q0YRDchy30zwKwWsWW3++v798?=
 =?us-ascii?Q?TDtxczdMbSZkh+1s4JliqmnnES+tEOW0sY9/b5Dxy5qgJEhwfNrFJBpHij/Q?=
 =?us-ascii?Q?IMj/uyXx+tggNMesHFqJkQTw7InAfPBS6mp2zRjyoHQZbMybG/r87f+MYXhW?=
 =?us-ascii?Q?wa31FADcC9IguZDOk5ys7dDQ0STkx+m86ca3CedEh0+CO3fuOKWnqODJPEMP?=
 =?us-ascii?Q?XVwCNrxxZCaIlBKW94Of8e+HCFRiikFlj0FNUhJPStAPkOjr80jDkiUYPmBt?=
 =?us-ascii?Q?jRhUJP+1eSvlhkT8oEIUeIt84tXjefcsbPnEBkk4kqbwsfMrMwdM4kaSgUHe?=
 =?us-ascii?Q?21K3Pa30wlOfk6bFbC7jwSgxsGO0Sk2nK1D7GcT8RnfCemvMxi/nC2sSntOW?=
 =?us-ascii?Q?VyJkWjm1qwxOA/EHbtrUbyjhY2s03Wnspc+PwzzQ9VDHC5CaKg/iIhkQM4jr?=
 =?us-ascii?Q?AzzA7RDQ4mHPIVH0mOInkgz7Q/iSlTNd7stRtWQpC2CknSXufmGuLqidLuA4?=
 =?us-ascii?Q?m7EIXuwMneEnSlE4KWKTJDIAcRhEfJ8ZlDvqfHh7CzvwmCXSC4TJra02ssbb?=
 =?us-ascii?Q?ynWryJPAFYq1/vT8QObLiuf3i7kb2FquHCmWiio+ZNwkIfA/tCO+8WbhinkR?=
 =?us-ascii?Q?oezIEjekg5zruXaoV93jaG8jxxdDaQzXemqLjKO9LT1pkwnQ2VtlgcfF07FL?=
 =?us-ascii?Q?4FHXGs1F2TuUsyPg6iUJ2wi17lK/Pgzec60pDyWtoYoPGKAGwd1mK4nhMZJ7?=
 =?us-ascii?Q?sePxMRDhzIJYoYC/8EFp6GYU8lLenWd4DOe0tBHop1DdUghumCjmP4iEddPc?=
 =?us-ascii?Q?IfQljaqi8oddAmGhAIN9yFW+0TgJZzE45I78+fvovP0F15NcgGXU8wv+v03Y?=
 =?us-ascii?Q?CRHUbUQydks58XJR+Edc5jwt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbe8285-c602-4a69-356b-08d9007c0f54
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:08.5655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAXbjcjoN1f0g5GBz2ToHS/PaS1nG4n7ReMFrcwchKKAQJxfLtS/W/sYmGclRh5KErQIDqEZHl5MACrKKyTD6T6vFESV2LreavgWJZ2b/q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: 8wRJbF8lPPV3XIoo7eLmlDWZOX1cg4JB
X-Proofpoint-GUID: 8wRJbF8lPPV3XIoo7eLmlDWZOX1cg4JB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we got a response then we should always wake up the conn. For both
the cmd_cleanup_req == 0 or cmd_cleanup_req > 0, we shouldn't dig into
iscsi_itt_to_task because we don't know what the upper layers are doing.

We can also remove the qedi_clear_task_idx call here because once we
signal success libiscsi will loop over the affected commands and end
up calling the cleanup_task callout which will release it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 13dd06915d74..13d1250951a6 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -739,7 +739,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 {
 	struct qedi_work_map *work, *work_tmp;
 	u32 proto_itt = cqe->itid;
-	u32 ptmp_itt = 0;
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
@@ -823,37 +822,15 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 check_cleanup_reqs:
 	if (qedi_conn->cmd_cleanup_req > 0) {
-		spin_lock_bh(&conn->session->back_lock);
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
-			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
-			  qedi_conn->iscsi_conn_id);
-
-		spin_unlock_bh(&conn->session->back_lock);
-		if (!task) {
-			QEDI_NOTICE(&qedi->dbg_ctx,
-				    "task is null, itid=0x%x, cid=0x%x\n",
-				    cqe->itid, qedi_conn->iscsi_conn_id);
-			return;
-		}
-		qedi_conn->cmd_cleanup_cmpl++;
-		wake_up(&qedi_conn->wait_queue);
-
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
-
+		qedi_conn->cmd_cleanup_cmpl++;
+		wake_up(&qedi_conn->wait_queue);
 	} else {
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
 		QEDI_ERR(&qedi->dbg_ctx,
-			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
-			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
+			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x\n",
+			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
 	}
 }
 
-- 
2.25.1

