Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99490C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A346117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhDPCFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbhDPCFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24rHe099197;
        Fri, 16 Apr 2021 02:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yMNKw0a1L4GNo5U7GM4S6fPfZGqis3ORMcxPQCxstb4=;
 b=vMD309CNgfqxBVlvcj0jTW75xxjloqxrEA0F8UuIJ9gFC7Mbnl5EZ6FQ2Mm40cFIpV4K
 C2kM12M1YTEmz0lg2e6KdwUGSPjFnd42jaKzS8ayAGg3mgqcOe4OU1CwAVwq9hitR71t
 XUqqRPaVF5bzoIe4SsBif/yx9WhPjHyFVu5Pln6An8TtYhlrRa/eoMT9ipmu6XSQxd1r
 5cK8bHY1MK/c/GbO2A2xTcBlzNLJjcIX3puSO7IRRAMub5wc0LWOFsSQQjGADUXo1CKi
 LcacXKDqCPBrQVwUT2nOu1RTQus8JBmU0sPH/RJlJgCe400V9m5eQE2cB409luTrqnkb 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erqpej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20eqU001150;
        Fri, 16 Apr 2021 02:05:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 37unktfbgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlrtIRjVGxV2am6A33PP+EfxoksgXcgEHBsz8YJ3Sssl8WIs3M2anT5+0GmZ7j4B7qMTvG8YffzJno8T+6J1e5bsbfKbb363Jy/9TscrdAVG/lhwem3kpKMqqAEffgBcAEItQLkI571Ge25+rnUKfQkrdopeV+5Jj7A4luWcjJaRgoUPwF9fXWnscZqTBOXiCKt1a9757hn8AgBckzou6owGW8w2QpffxSXxchQO2tds4ZlzpzRzFRDFh/9GcCf4aJxLYTuTYigxZDzFTeTsWhlWc5hKKNvnVORJcCc6bQ9mYJnBzlOE4PKG0EIXo7VKKtT8KMQLioyWz5+2tPRlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMNKw0a1L4GNo5U7GM4S6fPfZGqis3ORMcxPQCxstb4=;
 b=InWIfYp6nDFnJOef7IZI4Uj/Fx5Z5lLavcKXOu4Ga0M0nyOqz/xy3CpMI0Kes1Rjrql1CXOrJmEHGLyNM7o/D6djeMxy9G10cJ8HpJbCHN5Nslt6boxsx49wruntGD3RHlIiZdFnZyvH7oi2At9HCNSRyWFsfb8CoTn7tA0zAd2sfKjhg3Kt9zCrYIwYQZNeDL1XeG3mI6gdEEfLi9STcsiWq96tNXMg9QEsGzW3LQafGaKFeXSzb5o8x4UczPQZ2HqDWV+TmSXDegCyZzS0MaG2LwBLQYC4RHRN4WnBnQcvBJ+6Ro4TXW/V/XQp1rNoooIhbXBqv2SWs86dwGx1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMNKw0a1L4GNo5U7GM4S6fPfZGqis3ORMcxPQCxstb4=;
 b=IX3ZtNXLlCXK+ZIqvsZANCtunqBDFwXBG5ZXrQj0oDaD8Ytx9NGbtAp0RJKxW86S7myKsf50hArRe0QE5Oij+zcRYGJjM89L4jIuktLmR4nPHWmcdkbXX9S2OhF1ckpFAHFSTDTEBtu8KMFSN9RlyJV7dcXzs8tJLVy3MYR550s=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 16/17] scsi: qedi: complete TMF works before disconnect
Date:   Thu, 15 Apr 2021 21:04:39 -0500
Message-Id: <20210416020440.259271-17-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cde412a4-94e6-45da-9ab2-08d9007c0ebe
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33184A0A2A533883CD6B53FBF14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uFUfRrr3LUJmyty6Wy+fKNEvNrbJApGyzxKM5nF0Ontc6kBZwlUpG7Uz4DgWPFSngDs/ncyw3TytzmLlW+luDLqOdTd6rLSKyHqcIUGdjsJZv+iHPoeqjYAA9JUQj2aV5ai1AAyDApVGuKqnvpfL9SM439WRy4emyveZs7wWQLD8pVajMQiAVSr5P6x17cYokQw9s9mYFBTxrLt5v1OLpzOF5GyKF2BEsx0zvuv158aZl/lMoh6JGjxZeC5+ngoPBVrDtYMb0b/NjMZTU/PhG33wy2U6ZzQ56KVfJwkXbIL2+cLs3yGBSWi6H/Pt1O4aLNn76b39qnzeW0Dzvmzsq3x0qmx0dJcQcxhwr27DofEjadIiaVaOX3NWiazQ5GVya6ALPsRKgWnLaQsaNLMsl0/P18V/Ic8K2+tUlKD2T4RJQ92uq4oGxADFIBaNtTN71lAIqoA147fFfk1U6e5pQHrdv+URFVepvEFiMemf9V36fmfm/75IBCTyEUEzElf8q168bus/cXXUrm1HKsU9qJOQt2owuVtTry+/rH1DXZSuPnw4qtxHsZVLWropSucdpkVwicdvthkSsX5wjvv44TKZdzlEYmnBpcMjZtsENMBgRp1EXgNpNDZAEQKV2FcpgEUvQmTQFEuhX6Z7K67H+p7b0GJrE/7a7/JGu3XVrLpH0GtBYUAxGy9znfpoczCW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q2gPPLSQaKbfHcBhfbl8yUVkbMleLDAeMHI95saFu8/EreDoNu4qUghRQjgD?=
 =?us-ascii?Q?5gMfibA5myeMp7gbRpFdIrvTRzi2t+YHik6IiqHxDy5vZ5AzLiCyyz5cqucp?=
 =?us-ascii?Q?e2zGchHD8wqd2TBBPDk9YzYGXnWObHWY1NAuV0lWuPTXCERUCBTfkO6DHtDg?=
 =?us-ascii?Q?UrF7Y7rSoQQyaY8sqrG7tmFmJAYBJ8sV1VC0rrrwecDH9ls1JNInwaiF+zku?=
 =?us-ascii?Q?PJuax2FYoXtOPIn4AbwcDFuXHUty1Tfdv3/C2xso4wSwEGXAcYk6fj7RriYT?=
 =?us-ascii?Q?ctNKmk5D6ZrlbCZVvPv48ZGM1R+apLBm7yGZfhYweNFxSa4VG02SIFG11ZZF?=
 =?us-ascii?Q?rgJB5LMdI7vJUgAbGUlTt8EKzipzUw0sHty8VKK9IACpc8zSTFlXdycENj5q?=
 =?us-ascii?Q?rIbLp+gYpK8d0iBY47LVPKKFgyn0K7JpLL8zkVx1d2Hxkr+mpvVRlxTdnaDx?=
 =?us-ascii?Q?NTn4y5iC3406QqEaA5PdW3TZo/2Q6ODl614sYQjJp3D5AHYJNCP5rMVa52Hf?=
 =?us-ascii?Q?LJNLBc7vJfmCaHda20NhsdorZ7lG8I0htx+9sOh51RZ9Vizc7N15FTeuBmN+?=
 =?us-ascii?Q?oEHlyZUhNutWZTMcRcYkLeYVnJl8dVGtDTxt6ltlGSv0+xVENzYTphrUECd+?=
 =?us-ascii?Q?owcbzjUxn3z3XFGPwu+VyA8CX6+dfXTfd/dfC7PO8fPrvrKjrWR8TelrdwbT?=
 =?us-ascii?Q?Yqi49HChEVVqnDxN3ytY3G43tZdEQLlC+2cjUVDIElb4yAE3geqQ4XsQ/oN7?=
 =?us-ascii?Q?N99C96gAunRp5+pMeiXqIdViTF6k4AiBZNVAJxLqcA00KWmyDdk61NrFIBGe?=
 =?us-ascii?Q?/yPiiRMvmTpzefLkIukFjjx1cd6UsIZtzFHNt/+8xF3RRCjjeHZn6gvG6GsJ?=
 =?us-ascii?Q?AK/1CfDIQeja3MLnWTnwmuKnjfezakzpl0Gi99F59PCngtufHRxN1lI0H+CL?=
 =?us-ascii?Q?sq3Z3OaTPfYe8M0p1pte5RG4Kq92kJaPOu6jq1riiQLyP/TWyR+fp9GHDfHB?=
 =?us-ascii?Q?DGeWWLz2h7Nfau5iDxXqPM4BlQFbZyqlboSO3dExXLErW3O2G0u8o9SPrGq7?=
 =?us-ascii?Q?JRSSbaPQpvUXc5fLV1Czwd1jIqItYb3g4lgZwMM04bQ7K2hOufeqpu4mBb7O?=
 =?us-ascii?Q?+K+VuVk+ZNpNyI+SV9Dop1yYtlKu9qSrtuxxt1A3ckjt3cBfMNARtZivZbv5?=
 =?us-ascii?Q?y4iiwI99E7agtMIDvXLXZWhplLotis0FEvexCvK8AtlmcX0asZzkFllkkb+K?=
 =?us-ascii?Q?2BS7FM4964HN1RTVwlFJnZElO43F58Z/IUfjVcF4LidcS9FVu0cqHhaZZIGI?=
 =?us-ascii?Q?mZ8kdobSPG/NoH8PLzwnU5Pw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde412a4-94e6-45da-9ab2-08d9007c0ebe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:07.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ns/9qxa9PO08GNE5zXf3ErtxUxwRexKBD26pKG2019velSU7mEolGlxyaEyuYHffDISmaQblXTDP79lBr7+0yy9tQ0ODS0rVY9QfDfprFks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: 0RLpDr_rNR9W0O4HfMjd_xrd8sgwCOlV
X-Proofpoint-GUID: 0RLpDr_rNR9W0O4HfMjd_xrd8sgwCOlV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to make sure that abort and reset completion work has completed
before ep_disconnect returns. After ep_disconnect we can't manipulate
cmds because libiscsi will call conn_stop and take onwership.

We are trying to make sure abort work and reset completion work has
completed before we do the cmd clean up in ep_disconnect. The problem is
that:

1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work was
still pending we would not see the bit set. We need to do this before the
work is queued.

2. If we had multiple works queued then we could break from the loop in
qedi_ep_disconnect early because when abort work 1 completes it could
clear QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
work 2 has run.

3. A TMF reset completion work could run after ep_disconnect starts
cleaning up cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
-> qedi_cleanup_all_io would might think it's done cleaning up cmds, but
the reset completion work could still be running. We then return from
ep_disconnect while still doing cleanup.

This replaces the bit with a counter to track the number of queued TMF
works, and adds a bool to prevent new works from starting from the
completion path once a ep_disconnect starts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 46 +++++++++++++++++++++-------------
 drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++------
 drivers/scsi/qedi/qedi_iscsi.h |  4 +--
 3 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 475cb7823cf1..13dd06915d74 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -156,7 +156,6 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	struct iscsi_tm_rsp *resp_hdr_ptr;
 	int rval = 0;
 
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
@@ -169,7 +168,10 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 
 exit_tmf_resp:
 	kfree(resp_hdr_ptr);
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
@@ -225,16 +227,25 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	      ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
+	spin_lock(&qedi_conn->tmf_work_lock);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (qedi_conn->ep_disconnect_starting) {
+			/* Session is down so ep_disconnect will clean up */
+			spin_unlock(&qedi_conn->tmf_work_lock);
+			goto unblock_sess;
+		}
+
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_resp_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		goto unblock_sess;
 	}
+	spin_unlock(&qedi_conn->tmf_work_lock);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
@@ -1361,7 +1372,6 @@ static void qedi_abort_work(struct work_struct *work)
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
 	spin_lock_bh(&conn->session->back_lock);
 	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
@@ -1427,11 +1437,7 @@ static void qedi_abort_work(struct work_struct *work)
 
 	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
-put_task:
-	iscsi_put_task(ctask);
-clear_cleanup:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	goto put_task;
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
@@ -1449,10 +1455,12 @@ static void qedi_abort_work(struct work_struct *work)
 		qedi_conn->active_cmd_count--;
 	}
 	spin_unlock(&qedi_conn->list_lock);
-
+put_task:
 	iscsi_put_task(ctask);
-
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+clear_cleanup:
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works--;
+	spin_unlock(&qedi_conn->tmf_work_lock);
 }
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
@@ -1547,6 +1555,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
 	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->fw_cleanup_works++;
+		spin_unlock(&qedi_conn->tmf_work_lock);
+
 		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
 		break;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6e4f7c427af1..25ff2bda077b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -592,7 +592,11 @@ static int qedi_conn_start(struct iscsi_cls_conn *cls_conn)
 		goto start_err;
 	}
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+	spin_lock(&qedi_conn->tmf_work_lock);
+	qedi_conn->fw_cleanup_works = 0;
+	qedi_conn->ep_disconnect_starting = false;
+	spin_unlock(&qedi_conn->tmf_work_lock);
+
 	qedi_conn->abrt_conn = 0;
 
 	rval = iscsi_conn_start(cls_conn);
@@ -1008,7 +1012,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	int ret = 0;
 	int wait_delay;
 	int abrt_conn = 0;
-	int count = 10;
 
 	wait_delay = 60 * HZ + DEF_MAX_RT_TIME;
 	qedi_ep = ep->dd_data;
@@ -1024,13 +1027,19 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
 
-		while (count--)	{
-			if (!test_bit(QEDI_CONN_FW_CLEANUP,
-				      &qedi_conn->flags)) {
-				break;
-			}
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "cid=0x%x qedi_ep=%p waiting for %d tmfs\n",
+			  qedi_ep->iscsi_cid, qedi_ep,
+			  qedi_conn->fw_cleanup_works);
+
+		spin_lock(&qedi_conn->tmf_work_lock);
+		qedi_conn->ep_disconnect_starting = true;
+		while (qedi_conn->fw_cleanup_works > 0) {
+			spin_unlock(&qedi_conn->tmf_work_lock);
 			msleep(1000);
+			spin_lock(&qedi_conn->tmf_work_lock);
 		}
+		spin_unlock(&qedi_conn->tmf_work_lock);
 
 		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
 			if (qedi_do_not_recover) {
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 68ef519f5480..758735209e15 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -169,8 +169,8 @@ struct qedi_conn {
 	struct list_head tmf_work_list;
 	wait_queue_head_t wait_queue;
 	spinlock_t tmf_work_lock;	/* tmf work lock */
-	unsigned long flags;
-#define QEDI_CONN_FW_CLEANUP	1
+	bool ep_disconnect_starting;
+	int fw_cleanup_works;
 };
 
 struct qedi_cmd {
-- 
2.25.1

