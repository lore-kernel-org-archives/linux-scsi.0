Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9E4C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 265BD6135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhDCXY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54914 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbhDCXYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NO7oO087694;
        Sat, 3 Apr 2021 23:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ImbL4qq4FQRhBzRuRRACG3YX+SFWbP/iZDnu9PSvmVg=;
 b=JQqYYXoIDJzjl3CUsWQl8bZs3ifLchGmfZVuhxiBerfHZfoDzST3f6Rmy9Zfsilaxpw+
 qzqt8yp+Ao6hV1HujxApX9IOSDEJUKHDqV7XzGceGibovIw0M0M0JSgtHNlY8GbiSZl7
 RcSJ92F/xLQq27leZJO5EbtpLTU8Gy+kjLT/8nwcBXN3mJLYA6HTJCVU2KyHrqusjsNX
 3SZG6R6sdIhf1BNfoL6eltX490rhHffi5D+AZX3RHIGyff+Sc6huvjeokj4GZdkwmGDy
 SdwIU7ZyjLQUAzkIXTnhRqz+onELC4mIymwAByYlImNLm8d8CqRx/ylKY3nInlj8MqMJ ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37pq66rcv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJrfA132130;
        Sat, 3 Apr 2021 23:24:06 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2056.outbound.protection.outlook.com [104.47.45.56])
        by aserp3030.oracle.com with ESMTP id 37q1xk81m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8HvHcalqxkE7li8RVnRa07wK/VWDfrQb5CL6G64c4QaQh7b7tt4Ju64avfRFPAQI4rC25dn0DrILrc629/8tbiKYKE0UFuadfZEh5hJ+DDJ7bXS1ssGiyjDwTU8znmNWPCAqGdXkccEZRD0BCvGp1JniRoxJVLJKz9bjIrjCY8aE00jHx/FJdSq9sk2mNCtn7R5un6tFumxnUtQvjq7DUShKoNmbuBjuAIeIwDPG0FAM+mVSZWfn1rn4c7d4j1uxSxIB3v2v5YjAdyuBZRgN5eGnDy1vZ1AA1U67SClc5UECV0Cwrovsasw3e/JlBXO3YFw2hulXGxaYg4N31SaIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImbL4qq4FQRhBzRuRRACG3YX+SFWbP/iZDnu9PSvmVg=;
 b=Vt83JOoHrHTJ6hDkvfViCnix8F+CEXL0F22jwhlex5pbFwy5DBog4WKHoU9ovMFCDho+mSzlyjAtQ6KE5KmjiSN1QazmpocFE//8wJOz84as2+yjnbjNwo1qMiO8L79inRvUIUH+JekJ9CcELEk6AKMgNkxDKNIVJTKF6Fzi16vhZ+lixyJGFOicdymNaViTsgvXr97VqbyvwL/vtVPIhXQAPf+HT3qxsAgfdrGGNR+IsHpJXqyxIn/BQHQktwJ8eAMo5DDUo0wVVg29Mf3e/eukJ7MFtYPOa20PTyEYpjDIj+JatlpOaMBQ9kHCSqsmpTfKEVJrVyfrUVp2ElA0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImbL4qq4FQRhBzRuRRACG3YX+SFWbP/iZDnu9PSvmVg=;
 b=LOL0FxgmYJ3A/PJ6q5ORuKLcT1OBCsFCGeeD/JTlKWADGZOt+CmUPkpUKnTm4o3E3Tozy5hzo1lDwugj0wWO/B/ceIx/fjGjE4tTHfKxoEPX4zMk+ZEwDnOrw4li85EysiDk3OX2KrQ/xFNqfaeuwDr/La/93ZvfRxva5zvXIlI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/40] scsi: libiscsi: add helper to complete a iscsi task
Date:   Sat,  3 Apr 2021 18:23:08 -0500
Message-Id: <20210403232333.212927-16-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fed46341-b51a-4194-a9c2-08d8f6f791f0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526501FCBC2899F40B4D146F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSIq7rNU2WlC+eAujG8DRY+sDy+jrhGF7Ejx8KEa0QQcR9gh+fjXrssgvgNb5yN6ZmR4/kD8TzRY/BMvcFfNy5CEPyho1NjzYcuGhe9vHCH7MLvNydTwf5DASUCBtCtZzOtzmJ//PFQaMrWizbp1LCqG8Fh6H4+Ik2gDhInAGkZHQjza8MXaLoTzugaOPa3p1RLZDH36SWkSsyFzhK7+tWKolV+/7oDQrp9VjDfPb7TO6tX/vTgHkN4nbule3P6EFkRtOaR/1+rW9NecYgfofDcFNII1o9I4F0Q4gE3ge/xhh89Q0/42i/3tRV/YVoJq96J5EEVwp6Dz69ziovaYB1jAHVN7U8CRijI17+xOiWG8CbOsgBQ5sWNroR2fQNXIAUYN0tPg/rU4NE1rzFr5KM1aTyR07GUgOIbTRvyYefQgzTVSgW0LSC+y92jFHmX+hTCAiFWRg6Hh87RAmZxVXvxWAbdBTG7yU02OvUGNzz6ct8P+t1KEiH7I0N4RhZUl56eC+H8J0/8VfvPA+cwp+/ESq4gkydmOF7rAmNbwyKZRE/c8xRQPdhVkRZwvLpORO8K7aSKvw6HETmPtH+cWQcligeYBnXasllAIHjB5VIZEkj29+9r5qNFazFqkPnP9SZQPcklvM51S+z/NWqNQIYrbZhAtY1jCnOoqyYNo8wpm/Ti6rYrO1TZNKWXVfSfL23lo0chicu5GNo/NnuldkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?67TmCPfT5tuiNiIsfitS0uIys2eUkJfrSAoayXOKmpeqJ6mS46qcUhj7214l?=
 =?us-ascii?Q?v7dWklFLBweALhfzaDF/KOC0Dyvdy1vv9GQqedLGh6F0j4MJxe36qrdYTT/t?=
 =?us-ascii?Q?GxNifVyegQYJSwIxRBzAsVkTT9LCjiPit6Y+GPBvhp/mS19SNlLvpbCWhytY?=
 =?us-ascii?Q?AIxBtu3xGiMESq33h3aAYrX7tXRH2g6JWrDqsYWVwD9yvZoEqgQZ1QmV+5f2?=
 =?us-ascii?Q?5QY9akfGRv0EbYmdW8wfXrWJJ/f+4oSydBAIC+0+egzjIKZhikfzz1wDco0p?=
 =?us-ascii?Q?W5JDpEmId2jTGpMq8qlLllP+8YTxHS4Wivag69BCxFdjGvOyJVyZchHSNdfA?=
 =?us-ascii?Q?ViNZdpg9jNOFLahVG+IolOzL+Braf+IcQxxtpLf7bwR9K6mF0gBlJL863TcG?=
 =?us-ascii?Q?/tbns3nYb4INF3dBCETmoPilSJBR38V2jxheKNGPzMVpzBiCT4EDu2JOraJD?=
 =?us-ascii?Q?e9SwdyUgeq2BKUfD73VRitZX95VjacbG/qtp3kg7ZyRhnqc6me7WZj4PZMTh?=
 =?us-ascii?Q?jD+y1PnmRmhjXT4tMesgIyTjxTbcpg65rB6Qazr+zMU8GB0lIg4Dk5baRJs1?=
 =?us-ascii?Q?wJDgbRfqJnB6tz83pA6DTFGDqKqD56/0nVs2SL5YEGEnCuSt4YG13uhxCG8c?=
 =?us-ascii?Q?liBeLwBHqD1NciaB/6OMD5gO5mcjZsF5ZIA+2k58Fhi/h6Mrqo83J914EU+U?=
 =?us-ascii?Q?Zhrs+Bmx3+Jf8SVek0AosUWM1RnSLArSI/4BxFyWmDbLVjVI61UWc9RmBdvu?=
 =?us-ascii?Q?3kwBi4E9lNlUdt+Va8V6trsOLgEdyz/f5DpNTcWcoZ/r1Zw8aVyk/RnYIFsh?=
 =?us-ascii?Q?ROmZC62gbzhhR/Vue4kAAJtPEasCESJ4xpCF9wfEA0QI+TC2asmbfgV3K2Gn?=
 =?us-ascii?Q?L12XAqQ2yzD7vjel+ngH5Qz2FGnhZKj+dQXoOhW+XWHuNUSfJzc9sE0/vVMl?=
 =?us-ascii?Q?J2TezjoinOekZz+DMhh4UvWZGHfB/4iBog/MmqHGtDDRKu2v3Jq2ox18XXAa?=
 =?us-ascii?Q?6OsuMdgPrAP0R+nsBP/3/ganiQPSIPis+fIquhxh5uPexYFIgG9X6CBq1a1D?=
 =?us-ascii?Q?IeUelM+YAHuGXYEbnPGh3zGRY74H6zLzOJ6by5HVruKH+ze7ko3gqFZejXdq?=
 =?us-ascii?Q?oa3/4Mjvv8RJKIprwVesR51vMJzijs3oUXHiAajvGfYwKXk42ki4a9TTBXSq?=
 =?us-ascii?Q?qwJ3jHJPCMFmz0yG92R8RG4iTw+mKgzKXzn8oCUHKOdq/vihISmBvChhPuxK?=
 =?us-ascii?Q?FDVICCY4IqOIDQBteerPRmPWTCUew5+qMioNs4UtwxRC1cGw4zCz1DmLtoZ4?=
 =?us-ascii?Q?2VlNN2X60tM5KN1ozU91Qqko?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed46341-b51a-4194-a9c2-08d8f6f791f0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:04.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc1M+LZOzDvH2P+ybeYE0ws2UQBj3qGbGxARJ2wW4u5WFXOjJpdcCmciSk8ybxXBSVGZulkpdevYzdkIPGqj+wWLdl5YC7qZwP6p5sEH5Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: OEt0M4Y2UbkMvbalyCvStGBLlgtZikIB
X-Proofpoint-GUID: OEt0M4Y2UbkMvbalyCvStGBLlgtZikIB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We export functions to complete a pdu and a scsi task, but for mgmt tasks
the driver has to fake the itt for drivers like qedi, qla4xxx and be2iscsi
which don't have direct access to the PDU that was put on the wire.
This adds a helper to allow those drivers to complete a task directly.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 86 +++++++++++++++++++++++++++--------------
 include/scsi/libiscsi.h |  2 +
 2 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 768b6cefd067..cadbe1d19344 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1148,9 +1148,8 @@ EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, int datalen)
 {
-	struct iscsi_session *session = conn->session;
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
-	struct iscsi_task *task;
+	struct iscsi_task *task = NULL;
 	uint32_t itt;
 
 	conn->last_recv = jiffies;
@@ -1163,10 +1162,60 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	else
 		itt = ~0U;
 
+	if (itt == ~0U)
+		return iscsi_complete_task(conn, NULL, hdr, data, datalen);
+
+	switch (opcode) {
+	case ISCSI_OP_SCSI_CMD_RSP:
+	case ISCSI_OP_SCSI_DATA_IN:
+		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		break;
+	case ISCSI_OP_R2T:
+		/* LLD handles R2Ts if they need to. */
+		return 0;
+	case ISCSI_OP_LOGOUT_RSP:
+	case ISCSI_OP_LOGIN_RSP:
+	case ISCSI_OP_TEXT_RSP:
+	case ISCSI_OP_SCSI_TMFUNC_RSP:
+	case ISCSI_OP_NOOP_IN:
+		task = iscsi_itt_to_task(conn, hdr->itt);
+		break;
+	}
+
+	if (!task)
+		return ISCSI_ERR_BAD_OPCODE;
+
+	return iscsi_complete_task(conn, task, hdr, data, datalen);
+}
+EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
+
+/**
+ * iscsi_complete_task - complete iscsi task
+ * @conn: iscsi conn
+ * @task: iscsi task
+ * @hdr: iscsi response header with all fields set except the itt
+ * @data: data buffer
+ * @datalen: len of data buffer
+ *
+ * Completes task processing by freeing any resources allocated at
+ * queuecommand or send generic.
+ *
+ * This function should be used by drivers that do not use the libiscsi
+ * itt for the PDU that was sent to the target and has access to the
+ * iscsi_task struct directly.
+ *
+ * Session back_lock must be held.
+ */
+int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
+			struct iscsi_hdr *hdr, char *data, int datalen)
+{
+	struct iscsi_session *session = conn->session;
+	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
+
 	ISCSI_DBG_SESSION(session, "[op 0x%x cid %d itt 0x%x len %d]\n",
-			  opcode, conn->id, itt, datalen);
+			  opcode, conn->id, task ? task->itt : ~0U, datalen);
 
-	if (itt == ~0U) {
+	if (!task) {
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 
 		switch(opcode) {
@@ -1201,33 +1250,12 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto out;
 	}
 
+	task->last_xfer = jiffies;
+
 	switch(opcode) {
-	case ISCSI_OP_SCSI_CMD_RSP:
-	case ISCSI_OP_SCSI_DATA_IN:
-		task = iscsi_itt_to_ctask(conn, hdr->itt);
-		if (!task)
-			return ISCSI_ERR_BAD_ITT;
-		task->last_xfer = jiffies;
-		break;
 	case ISCSI_OP_R2T:
-		/*
-		 * LLD handles R2Ts if they need to.
-		 */
-		return 0;
-	case ISCSI_OP_LOGOUT_RSP:
-	case ISCSI_OP_LOGIN_RSP:
-	case ISCSI_OP_TEXT_RSP:
-	case ISCSI_OP_SCSI_TMFUNC_RSP:
-	case ISCSI_OP_NOOP_IN:
-		task = iscsi_itt_to_task(conn, hdr->itt);
-		if (!task)
-			return ISCSI_ERR_BAD_ITT;
+		/* LLD handles R2Ts if they need to. */
 		break;
-	default:
-		return ISCSI_ERR_BAD_OPCODE;
-	}
-
-	switch(opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
 		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
 		break;
@@ -1284,7 +1312,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
+EXPORT_SYMBOL_GPL(iscsi_complete_task);
 
 int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		       char *data, int datalen)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5a5f76adbca3..8e01beba62f1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -467,6 +467,8 @@ extern void __iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
+			       struct iscsi_hdr *hdr, char *data, int datalen);
 extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
 struct iscsi_sc_iter_data {
-- 
2.25.1

