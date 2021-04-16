Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B090BC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8897661182
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhDPCFk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbhDPCF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xbch160408;
        Fri, 16 Apr 2021 02:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gKtUmlvzr+kwSZwxmjsWRFmuONSWaX9lL0U/isq0Z6I=;
 b=lsp/hqI+lQ0v5f86UN75DUy2M7phQoyW3ic722C39rluIPkKqbG2VRCtgW44TY4ss0v7
 bKd/Y6UZdgSs2cpAT6CymLEuSiU+09BRTVt3yejinloN4WrTsRDiHseQ1LtAfRudSFHX
 8ZGsPWFyg0YzAJaCrHGMVZElJPTagVnns2DfhfMX6hCF0vCVrofjYSqPUxx5/ICoXscQ
 SNKBFvgkW20xAmsp7MMOfZt+SCOd2VLFM3eZ4dug+ybrgYvay23IDfBGII0UlJFpB57h
 gLtuXU6EpAmnz1MuQ0dJ4BSQAZ9TswsS3VII7mp8KZsTI4s+xTKWQjE7w2bBvvTTZx7T gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnqmfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xor0008605;
        Fri, 16 Apr 2021 02:04:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 37unx3snxg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erxBNE84JoDT4xVJlf//dZ9olokSRPz34EtDn9nlElzxIKSqoxHQOAEaOIq/TuycdiVjn6er2LxclfV0BusAnPOU1RBCi2BaTysC3RVP2fmBHngVYbmhjwrZS7U6XNCnsi9eOtgpnNx+YaGKqaep3XZTsd8DMyj0R6c8pIEqKRIvpzHsUXIp8AAW/4rPlLoS+z9/01zwTZMlQkIfIgWqJ2Xe3PjdEnGm5huVebJr3vbqusRMZROHh/W1qcef91Ww9n2r0+OJ6wDtzoTpFAW6LfKMOnvw6RjvzMmZHADnIU9S603d4v4pmfNryau8Tm9QkYnZ3yBXeBsCuXSoWyNYiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKtUmlvzr+kwSZwxmjsWRFmuONSWaX9lL0U/isq0Z6I=;
 b=Bg4pcv9oP6zu1ZG0E/Em7HDZjscQ6SS334bWk/0zb6OyWa/uzdmR5dLP0ilcAubThfrnFjtnQlDHuR7ILDVru5kuf4GsgLNByldEhNR41PLudQL6sZ7Qd9GMc6s1F2NEWOVlmwjMmueT/UG3+tJp4pHQOKGUnpCZse9lWrJCPNaRPY25nV0yRsyx7bzzHi9SJ9d8rsahUrxEY9ixAlcVqz+xuQRlJw85prs76/1kEfLLVPK2xHFT7tGn3obEzalGqN/WxyyJPdF/h+ArIYPvP2Q+7PaApYhV5HDoZ5XuZ5msJZSaUjORpuWF0kzWWTkM6e/JGFvW/UZklXnQ6AZh2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKtUmlvzr+kwSZwxmjsWRFmuONSWaX9lL0U/isq0Z6I=;
 b=RfRSBjTjOGNZ9YHDY+ZwHnttkZV1QKO20EzhdJL5vNLjC7zXa3HvuMjIrwpVNV+v7+mPoPjzYcGZAA/nVssracLRPzNZvJYOarWF74tgKuIHMKKqiPWqQGThELlG8CfS3i9AMqSXk7PvC7HKStsv7HIMuaDSXcIzHWlG5qernpQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 06/17] scsi: iscsi: fix use conn use after free
Date:   Thu, 15 Apr 2021 21:04:29 -0500
Message-Id: <20210416020440.259271-7-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9303412d-307e-45d0-0c74-08d9007c07bb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421EA0F9B7C62822071D2DDF14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lk7RPs9W+jPWfSioPaP4aZsrL5wRBUXrtUl0flwKEQhiqTObHelUY2WP8iKcBzx9OoCJSKiczRaDVuCHvN1yEyHEWtuILkO1V9n5xiXsQBTOm9nS1rR7ceOrpKnZmvh1d8gAeKgpqhmLKeunKD0i1ku0zzvtVghsltzkvY7BaP44/H+RbX7B9An4MIcrwoKaAxtflN1QHbPlSdxJZX7poMccMk6hpMoXVqImXbRzJaLlOXqGvZH3ibTXYAqMGOfbx08k0RvpySzu0c+b84eHCGtKwtvRICBU3TqS16WrSnZPWIw1P7U9EHxkp4v1nFk++gXjIIKanc3Jg5srmwecsJxHdedb5fBXh645JKveAgpVGwqhzzY1h8KvHWlof/6e8yfc7DadhatVW1GLOcepAHs0HUu0eOtEbMYvHlyrzPiKS/5vqU+z+91SUqnAaewWMThA8iWlkn7bItiBbqyRkVX0SHbrREJ6q3ADQYUkHmKSenxULbY0KQz65cLEfVmmT5zcWNyKyctEeHh4kusjhCBtsWKDawuG4rroATtCWSnSulzAI/l/6pz0+xgGcQebRunDZXrd4/o9vSkCmILkPJkIhK83dErxAHBijBnQcT+jKz7rv0daAh7uOnXtYD4934W8oKbiz9bVtpefKpQV5ZPFJyl2WPeGZPK9romuadyZh7fpAnFdYOEfKEd+c/F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(30864003)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sVMlHhfmZNhI3gDhmP3aT/9m8xqkrkhltx8XkfHBXtWAeukWi5GFQuZsX902?=
 =?us-ascii?Q?J3H/Udvjc1UWATU/33CQLrYOXGo+F0Ow93lCh7x9ORMCQhLDqQ31CcYA8+dQ?=
 =?us-ascii?Q?9r6/eHKvBFAwpGioSKmcDrHDD5SgOTixQB9LrGtQCqlN9oqJyaXEBXFa8sOL?=
 =?us-ascii?Q?N9/xHSj86Cz97a6CI508cFd7ZPqBj8lFq7qDgb26vHp+QupsmoQ38nh3hfdU?=
 =?us-ascii?Q?9B1i3vbvWpFCuR3anP9h+il2VNLrB8dzrGLiT5iw3/2S4GEw9E2+PPgGYEWV?=
 =?us-ascii?Q?ZrjXrveSHX4C9+OTha0CK3oVhkfxWpFJkrjrHZcg3Xcod/cpa8BBAp1mkb62?=
 =?us-ascii?Q?i6QslGQ2oJgAKnR+62wxM5mqFhpqHAfX3rTM5CXzgJUXsFXXaC6LdIA1oQCS?=
 =?us-ascii?Q?QHB/7dag/d5C7QbQxaoVygdpjqAzIsnjuEZEhXroojTUi9jLr6HBLp9sTKok?=
 =?us-ascii?Q?ZCa6JrCYp59YeaUSeFbc6QMJDV6LgYt5LeXoKtlpxyqvCowRtq4FdA3JgtTe?=
 =?us-ascii?Q?aNG0DzQFIwddcrWMGCuZt7u0chCjpbgq1FtIQXBlglVDllFrbCr/WmdiV/ln?=
 =?us-ascii?Q?K18yQBhPyFldAlJy8d8nCCD8WvtqFgthWq9RcG6Bv3/BdjfmqBTVwNhWPsnu?=
 =?us-ascii?Q?IgVrnckFOdf+7Fl3PCrBlKw+Dt1qG6ihdKU2z8Jehtg/M2kdqTPNpZTHf9Zq?=
 =?us-ascii?Q?9SqXbHGw+JlabllcFnDkVZQujaSuvNCxKuEjUU00ixUdjvYY5f3adG27iNQZ?=
 =?us-ascii?Q?inz0y0AuqXrByutKdp43OtJ2B340oXbCWV3GgxYuPDUo6gFErmoWJl78ewXZ?=
 =?us-ascii?Q?FGx748zDNSFs27kHRWJKftUph2LuiuwWOeUzxGgR9sITvvGdKoj0c2rWdPzU?=
 =?us-ascii?Q?nB5DQ1WF7vPID/vHQAgUIBzQqK5tFoSgX5/ftySnhwY0n/FxZ+bhlB/iSQEa?=
 =?us-ascii?Q?ACMlLz8dEFTI3NmN2Lv6Hs8R6PqIFv59vxBKGE1ffcXqjZw6doECqcLOp2SB?=
 =?us-ascii?Q?kJSkHrwWORip8EldTMY6L8icIgqn2/u6Td+5ojjwiSk1UfwHx6v+SNco7Vgr?=
 =?us-ascii?Q?5hhtmOqAo3ea6zF7bDQuEDeuuXb3LatSkuVMA9cLdj78incF2gpct6a1yTow?=
 =?us-ascii?Q?EAo2NzvU+8kwSOfrCqQzCHWnh7RqcaP2ZyfW4nDpiYYWohxdixmA3zX0Kvmo?=
 =?us-ascii?Q?sfey3t9DovCBEQyTexDd+p96YsDKcXEA/lj0Cir4CFbxPo1XhUUHBz+jhvAr?=
 =?us-ascii?Q?NjnM9WREsS6CWiHI0LQBvFaOr7f5VU52AU1Xzwnt9nDbuozIs5UeOMHZhULc?=
 =?us-ascii?Q?Z/eEE8oQ5oStw6H1FnF2MW7Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9303412d-307e-45d0-0c74-08d9007c07bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:55.7368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9W6+6Q3Hamn+lgp+fbY4KGkccae6f+4wPY4uxi/EhrrBVVoOl1VPzCXx9OxrO/m7t5QhjJs2NiSkF1e9owZabX50jU0zFt3qwwHAuRLySI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: ZlmmgFFTL6edTEenoAc9NxlIYTO-_egr
X-Proofpoint-GUID: ZlmmgFFTL6edTEenoAc9NxlIYTO-_egr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we haven't done a unbind target call we can race where
iscsi_conn_teardown wakes up the eh/abort thread and then frees the conn
while those threads are still accessing the conn ehwait.

We can only do one TMF per session so this just moves the TMF fields from
the conn to the session. We can then rely on the
iscsi_session_teardown->iscsi_remove_session->__iscsi_unbind_session call
to remove the target and it's devices, and know after that point there is
no device or scsi-ml callout trying to access the session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 123 +++++++++++++++++++---------------------
 include/scsi/libiscsi.h |  11 ++--
 2 files changed, 64 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ce6d04035c64..56b41d8fff02 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -230,11 +230,11 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
  */
 static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 {
-	struct iscsi_conn *conn = task->conn;
-	struct iscsi_tm *tmf = &conn->tmhdr;
+	struct iscsi_session *session = task->conn->session;
+	struct iscsi_tm *tmf = &session->tmhdr;
 	u64 hdr_lun;
 
-	if (conn->tmf_state == TMF_INITIAL)
+	if (session->tmf_state == TMF_INITIAL)
 		return 0;
 
 	if ((tmf->opcode & ISCSI_OPCODE_MASK) != ISCSI_OP_SCSI_TMFUNC)
@@ -254,24 +254,19 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 * Fail all SCSI cmd PDUs
 		 */
 		if (opcode != ISCSI_OP_SCSI_DATA_OUT) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] "
-					  "rejected.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+			iscsi_session_printk(KERN_INFO, session,
+					"task [op %x itt 0x%x/0x%x] rejected.\n",
+					opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		/*
 		 * And also all data-out PDUs in response to R2T
 		 * if fast_abort is set.
 		 */
-		if (conn->session->fast_abort) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] fast abort.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+		if (session->fast_abort) {
+			iscsi_session_printk(KERN_INFO, session,
+					"task [op %x itt 0x%x/0x%x] fast abort.\n",
+					opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		break;
@@ -284,7 +279,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 */
 		if (opcode == ISCSI_OP_SCSI_DATA_OUT &&
 		    task->hdr_itt == tmf->rtt) {
-			ISCSI_DBG_SESSION(conn->session,
+			ISCSI_DBG_SESSION(session,
 					  "Preventing task %x/%x from sending "
 					  "data-out due to abort task in "
 					  "progress\n", task->itt,
@@ -936,20 +931,21 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
+	struct iscsi_session *session = conn->session;
 
 	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 	conn->tmfrsp_pdus_cnt++;
 
-	if (conn->tmf_state != TMF_QUEUED)
+	if (session->tmf_state != TMF_QUEUED)
 		return;
 
 	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
-		conn->tmf_state = TMF_SUCCESS;
+		session->tmf_state = TMF_SUCCESS;
 	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
-		conn->tmf_state = TMF_NOT_FOUND;
+		session->tmf_state = TMF_NOT_FOUND;
 	else
-		conn->tmf_state = TMF_FAILED;
-	wake_up(&conn->ehwait);
+		session->tmf_state = TMF_FAILED;
+	wake_up(&session->ehwait);
 }
 
 static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
@@ -1734,20 +1730,20 @@ static bool iscsi_eh_running(struct iscsi_conn *conn, struct scsi_cmnd *sc,
 	 * same cmds. Once we get a TMF that can affect multiple cmds stop
 	 * queueing.
 	 */
-	if (conn->tmf_state != TMF_INITIAL) {
-		tmf = &conn->tmhdr;
+	if (session->tmf_state != TMF_INITIAL) {
+		tmf = &session->tmhdr;
 
 		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
 		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
 			if (sc->device->lun != scsilun_to_int(&tmf->lun))
 				break;
 
-			ISCSI_DBG_EH(conn->session,
+			ISCSI_DBG_EH(session,
 				     "Requeue cmd sent during LU RESET processing.\n");
 			sc->result = DID_REQUEUE << 16;
 			goto eh_running;
 		case ISCSI_TM_FUNC_TARGET_WARM_RESET:
-			ISCSI_DBG_EH(conn->session,
+			ISCSI_DBG_EH(session,
 				     "Requeue cmd sent during TARGET RESET processing.\n");
 			sc->result = DID_REQUEUE << 16;
 			goto eh_running;
@@ -1866,15 +1862,14 @@ EXPORT_SYMBOL_GPL(iscsi_target_alloc);
 
 static void iscsi_tmf_timedout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = from_timer(conn, t, tmf_timer);
-	struct iscsi_session *session = conn->session;
+	struct iscsi_session *session = from_timer(session, t, tmf_timer);
 
 	spin_lock(&session->frwd_lock);
-	if (conn->tmf_state == TMF_QUEUED) {
-		conn->tmf_state = TMF_TIMEDOUT;
+	if (session->tmf_state == TMF_QUEUED) {
+		session->tmf_state = TMF_TIMEDOUT;
 		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock(&session->frwd_lock);
 }
@@ -1897,8 +1892,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
-	conn->tmf_timer.expires = timeout * HZ + jiffies;
-	add_timer(&conn->tmf_timer);
+	session->tmf_timer.expires = timeout * HZ + jiffies;
+	add_timer(&session->tmf_timer);
 	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
 	spin_unlock_bh(&session->frwd_lock);
@@ -1912,12 +1907,12 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	 * 3) session is terminated or restarted or userspace has
 	 * given up on recovery
 	 */
-	wait_event_interruptible(conn->ehwait, age != session->age ||
+	wait_event_interruptible(session->ehwait, age != session->age ||
 				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmf_state != TMF_QUEUED);
+				 session->tmf_state != TMF_QUEUED);
 	if (signal_pending(current))
 		flush_signals(current);
-	del_timer_sync(&conn->tmf_timer);
+	del_timer_sync(&session->tmf_timer);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2347,17 +2342,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto failed;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_abort_task_pdu(task, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
 		goto failed;
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		spin_unlock_bh(&session->frwd_lock);
 		/*
@@ -2372,7 +2367,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 */
 		spin_lock_bh(&session->frwd_lock);
 		fail_scsi_task(task, DID_ABORT);
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		memset(hdr, 0, sizeof(*hdr));
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_start_tx(conn);
@@ -2383,7 +2378,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
 		if (!sc->SCp.ptr) {
-			conn->tmf_state = TMF_INITIAL;
+			session->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
 			ISCSI_DBG_EH(session, "sc completed while abort	in "
@@ -2392,7 +2387,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		}
 		fallthrough;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto failed;
 	}
 
@@ -2451,11 +2446,11 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2464,7 +2459,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2472,7 +2467,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2484,7 +2479,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2507,8 +2502,7 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 	spin_lock_bh(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		session->state = ISCSI_STATE_RECOVERY_FAILED;
-		if (session->leadconn)
-			wake_up(&session->leadconn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
 }
@@ -2553,7 +2547,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
-	wait_event_interruptible(conn->ehwait,
+	wait_event_interruptible(session->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
 				 session->state == ISCSI_STATE_RECOVERY_FAILED);
@@ -2614,11 +2608,11 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_tgt_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2627,7 +2621,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2635,7 +2629,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2647,7 +2641,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2977,7 +2971,10 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->tt = iscsit;
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
+	session->tmf_state = TMF_INITIAL;
+	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
 	mutex_init(&session->eh_mutex);
+
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3081,7 +3078,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
-	conn->tmf_state = TMF_INITIAL;
 
 	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
 
@@ -3106,8 +3102,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
 
-	timer_setup(&conn->tmf_timer, iscsi_tmf_timedout, 0);
-	init_waitqueue_head(&conn->ehwait);
+	init_waitqueue_head(&session->ehwait);
 
 	return cls_conn;
 
@@ -3160,7 +3155,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		 * leading connection? then give up on recovery.
 		 */
 		session->state = ISCSI_STATE_TERMINATE;
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 
 	spin_unlock_bh(&session->frwd_lock);
@@ -3245,7 +3240,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		 * commands after successful recovery
 		 */
 		conn->stop_stage = 0;
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		session->age++;
 		if (session->age == 16)
 			session->age = 0;
@@ -3259,7 +3254,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_unblock_session(session->cls_session);
-	wake_up(&conn->ehwait);
+	wake_up(&session->ehwait);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_start);
@@ -3353,7 +3348,7 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	spin_lock_bh(&session->frwd_lock);
 	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
-	memset(&conn->tmhdr, 0, sizeof(conn->tmhdr));
+	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ec6d508e7a4a..545dfefffe9b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -202,12 +202,6 @@ struct iscsi_conn {
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
 
-	/* abort */
-	wait_queue_head_t	ehwait;		/* used in eh_abort() */
-	struct iscsi_tm		tmhdr;
-	struct timer_list	tmf_timer;
-	int			tmf_state;	/* see TMF_INITIAL, etc.*/
-
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
 	unsigned		max_xmit_dlength; /* target_max_recv_dsl */
@@ -277,6 +271,11 @@ struct iscsi_session {
 	 * and recv lock.
 	 */
 	struct mutex		eh_mutex;
+	/* abort */
+	wait_queue_head_t	ehwait;		/* used in eh_abort() */
+	struct iscsi_tm		tmhdr;
+	struct timer_list	tmf_timer;
+	int			tmf_state;	/* see TMF_INITIAL, etc.*/
 
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
-- 
2.25.1

