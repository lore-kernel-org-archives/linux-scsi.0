Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FEDC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F9261360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhDCXZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbhDCXZS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKHZH085514;
        Sat, 3 Apr 2021 23:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=U2mTF9UezzjXpeP+ud3NyxCmdd131DTUyBKAbOpFp5c=;
 b=qfnYRQMP1rG169LqjefmFL7F0JDXT79/F6MbneBA92UBVgL4+pIWQZ47kYmoSDnDvpiq
 Q7kYwVJZLCHXR/1H2o391krsV873Ie6UDUuCrG4dlAKVfWYLVP4fsi0Xqq1ngKwP8jc4
 qpJZrhOnm/qUhmao04gbzB68iJWtdBxij6r8fHvXvgAJ8V57JTzyZ2vFKHIcjV9F7/Ki
 qqNeSbdu19ru27cnKvB16W1QHyVoU6/Dc1MZ7/nGxr7OE5dKhVwMT4pB1eRnW/RI8O0J
 FUrLuHZft+U7rszkyHHAHfXymU929a2AO/4zWdhLc1BUZ1T+Jww7TZBtabw943G5URuR 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37pq66rcvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBa117020;
        Sat, 3 Apr 2021 23:25:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvDLCdXzWmdIjYNfUqZdQ7Msou5c3Xc+H1tfNYD/zBrqjDyFkGprPuWs70AfCxtm3ngSowYIH///P2KmFPtGz0CMgGv3t+E8pJwjAnBqiUzw1qKLX46BUFE89xWMDOdec8KIItEuoyYsnL+yzNxRaOMK3NNkUJAXBTpESgMcpc11KYlEkoBoh/cYiz7GxdIq6ob74vs7QMRWUiZKf2bbsSqwISZpbeDu6j+BW5EyDxfu5r8fSutkFkVQrScmWunLJJCoWQ4FTsR9Mp3GdnIj4HtvtxNw2S9oZs74nZFHnwp6JMYkUaN2fB9WptXp2BByZrHFM6RduJcSQzkYY6JgPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2mTF9UezzjXpeP+ud3NyxCmdd131DTUyBKAbOpFp5c=;
 b=PBIgkreoBIfSGk6DSKmeFEreiotdw0F1B/Y2p8JBnmXnhLgrUOPc9Qtt4JRxpsN0Buz3MFWlzDpU2QARdnSOxe1QanE7kpSFC0C+giweIh+sUTYwEtuemeBdjYAEqKJLssYqgVuCbc0ww3XRKeBiCL3uMF1XcMwudrIRibeKgO9yv3vj5oOznKoNo+5wMkmq09rg18r84QBcV1+tmdK47PSUfqfbmL7LrnMIGIeyQLdHOqyZYaGcsbyiRqTEXBeURkaASXuPKi4qPwSvvlVKMRGm2LWzkLFORUL8CKevGkf/M7sOxkrXrgMxo8K+r/aw6dXkBCwW6KLm95sf2spbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2mTF9UezzjXpeP+ud3NyxCmdd131DTUyBKAbOpFp5c=;
 b=Jr1BEcKfJzhtIZDDQdJkaDax1mgaQWSXnSe7u9Dp92QqF9Buge3dJzAf/7ApgP8udvWMTG/ghfkImw+0pwGFHrU9QlTCpJQ01x7LLkw70slKcB6YHz0C3S9QS2/Y0I7SE/TPNO3GNdbhfXGc1xezj+owuGrUQyo9yPgTEOdNghw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 39/40] scsi: libiscsi: remove queued_cmdsn
Date:   Sat,  3 Apr 2021 18:23:32 -0500
Message-Id: <20210403232333.212927-40-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b85518b5-a580-488b-c9ca-08d8f6f7a4d1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431BE1A17BBB0C762688267F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PLf+KpJ1mISML64XMiSacpauCDk5hNfT1OmICixZzMCwpbv3yCw4vI2JZWhG4Tm4G01kaut88LD7onNOQq/CERcg+ZECQoa66aaHBJLWZt8pnngE4+3gvQup21nERLCv/YgIP8hi5yTCx7+0kJ7yKNnQ/3VdGZ5m6lqbn6MvNWjj3QKNZzwBbev2fg8oPrKdeaVHNgJxZDXKczNhY3ENqz6kuY6J38MUKsKDZ2o91TZiyIRXYu9VpAG2nZgeO+qU4q0rHCCnbnC4lf+olxqmoagWwqX7QCvY0pr01B69CqAFxfHCql08lzhQwnFIXunuXjKNyMds6z/QY5YZwQITzDZopg/8V3g7z2SFDXWqoTKx9D/whFYXiVaA5F+kxQ15tvkEN1PdhzDztrqwowDF3BNJBQkypd1pcyEHBc8yJpvyC18SBuM+FUjFPHnJH+RrUsXJbLA0WdslRqtKUrr8Ph5Oq3eCp6oPI+sE73BK9/Dtq66ilEBK26e385CIlcixcjXOWOKhL9ERn7rIkYi4hJRAYAI0QZHIdB+1JRA3945gPk9Q14C497ZcTii+iW/5OD7aCLhuwxbPtPUjaOXl0qwp+GkEeUSf8VD6ZBxHwkZdqmNX1ARIX9dIOB7/nHnOSqG0Us+qblZEDq1XhTAMB/VdYSLmAGlSALg3dvwpgOQAjg6p8omiimUGYAFdMWVoFMsw1gQYulZv3BzPrpcvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(30864003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3895Ytg65wqzR/4tSPya7mTAnR9sXDaQMUThrjjZIs7E99EvdkF8PdNdUQsI?=
 =?us-ascii?Q?VNh1gKyinTSp+EIco35KcJmV8mrMzweyqCZ9vCH4y+7LbbfgpzH7zs9/0x6M?=
 =?us-ascii?Q?gN/N/cQp0edkqX2hmSiV6kG6mlmaDU7V2NRyTI8GXiQA89eMYahgMZvp+YWR?=
 =?us-ascii?Q?+FHlFJ1kx5zFhbk7eEmgzCHI63UGwsVJxzbiIPpVjT49hxYLWkZmlYUPMuDy?=
 =?us-ascii?Q?lfackdmarKWqd/dJgURxVt6xYw2mVuU0JEaeEpo0QvzpL5WKPe6xaLnbpHqZ?=
 =?us-ascii?Q?hfRUxkNqg47p55t3RzBU1pw6Nnx8xLJsseHOuRiEASjcDMUg6aua1c43kkw7?=
 =?us-ascii?Q?JCxzKG51ShSlp9TtBONNF1bm/BGEv8bu3YSj23x2j4ySm4pwp5ptmuskr348?=
 =?us-ascii?Q?AlZoRZ5dazGOJnwGDjL5f7nLmHoO50eGOCi7ZPC/4/GQi/rigSakVsCBTGrE?=
 =?us-ascii?Q?cgFmm0eh3urvnwirgOVX0SPY/6loALLf//u2izo7iIcwU7WFUX04KL+wSIjH?=
 =?us-ascii?Q?JbI2ZhfCbfhjPjPPPctnw03Md/NS5aVYjN+QeR1CFH5FTen5SBtMITsoAo+m?=
 =?us-ascii?Q?b82nY12/WBpXPR36LgGbnjTcBFdXrs4wXbFo4Skratl7h5Vv38Yal3/WVKUh?=
 =?us-ascii?Q?N2gE7mVPgm80TQgmnSne/WVSlhngYGfNEZNuCHqpnDcitp9NBL/1EjjaghGx?=
 =?us-ascii?Q?TVhAzew5FTMXNZA/ObR03CRpEnBr3mFesV4ANNMjIbrypKb/1w7zEm2PElSf?=
 =?us-ascii?Q?sqAubUnYN+rLBXvXJqousTWjwuZyXG01mJ6d2K+7iK0AdiQ44OwCbp/kGC3V?=
 =?us-ascii?Q?uY/fuufFMdEJxiiYG6HRwE4J0iGbrB7/M+XxpzUpVn01Cej8VmEtYVLNKvXz?=
 =?us-ascii?Q?yG/l9fsXANwclNWZfDK18YpI1VsB++uo+8zjxNZ0rE4wkSqS4RQxizElhdF8?=
 =?us-ascii?Q?HuFUgqni8GuIyvHMHjRm3sLlsyhs6lKbEYUGA68mv9Am69ISb1WMacR1UfFk?=
 =?us-ascii?Q?R8+BlcgksvLTNRFYNv3zeItj/mR+kha5R03ei0MycLPKVzTxrQmqwSqf0i4R?=
 =?us-ascii?Q?SX08lMLO4DDMDEomKMdlj1Ogxer3jVeFrdaYiOdnJS7tlK/2ZRDfSO368G61?=
 =?us-ascii?Q?dRlnZ3UPgGGf3/om5k4e6wGEhRIPNhKUbcWg0cbN36855jbMNTsmTHUBN8jY?=
 =?us-ascii?Q?cPJ8WBCgiN8gnVqt3nGd9QjeyZ36W66sYhTUT2tSfQ0BMX8eDWJVSMwpsseZ?=
 =?us-ascii?Q?FKZ8bc3OtRPKnvFBdqE+Ku+h4EiP3l08gtfzIVZVQf9FYPCPgKzQM3h3OxVJ?=
 =?us-ascii?Q?AmLY/d3DgwnsZ2cYBjqDUTnW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85518b5-a580-488b-c9ca-08d8f6f7a4d1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:35.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIEu+YBT1ovRhbRQeeFa3tf6poEmT5iyRcU3+PjCKMopBMGtVY9zClNa2egwJmy16OMBtyqyPSUnysj9O6CfQfkwx1A+OTQ2Tj/B8XzEI2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: kyB9S4RlPtsdcr5ies48I56LuPhzGjPh
X-Proofpoint-GUID: kyB9S4RlPtsdcr5ies48I56LuPhzGjPh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

queue_cmdsn was meant to prevent cmds from sitting in the cmdqueue too
long, but iscsi_eh_cmd_timed_out already handles this. By dropping it and
moving the window check to iscsi_data_xmit we will no longer need the
frwd lock for the cmdsn for the iscsi xmit wq based drivers. We also get
the benefit that we can detect when nops open the window, and IOPs seems
to have gone up for the cases we are hitting the window limit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c     | 116 +++++++++++++++++++-----------------
 drivers/scsi/libiscsi_tcp.c |   4 +-
 include/scsi/libiscsi.h     |  12 ++--
 3 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1b4b6ee246cf..dd1e1963dd05 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,9 +93,30 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
 
-static void __iscsi_update_cmdsn(struct iscsi_session *session,
-				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
+static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 {
+	struct iscsi_session *session = conn->session;
+
+	/* make sure we see the updated SNs */
+	smp_rmb();
+	/*
+	 * Check for iSCSI window and take care of CmdSN wrap-around
+	 */
+	if (!iscsi_sna_lte(session->cmdsn, session->max_cmdsn)) {
+		ISCSI_DBG_SESSION(session, "iSCSI CmdSN closed. ExpCmdSn %u MaxCmdSN %u CmdSN %u\n",
+				  session->exp_cmdsn, session->max_cmdsn,
+				  session->cmdsn);
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+static void __iscsi_update_cmdsn(struct iscsi_conn *conn, uint32_t exp_cmdsn,
+				 uint32_t max_cmdsn)
+{
+	struct iscsi_session *session = conn->session;
+	bool win_was_closed = false;
+
 	/*
 	 * standard specifies this check for when to update expected and
 	 * max sequence numbers
@@ -109,14 +130,24 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 		session->exp_cmdsn = exp_cmdsn;
 
 	if (max_cmdsn != session->max_cmdsn &&
-	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn))
+	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
+
+		if (iscsi_check_cmdsn_window_closed(conn))
+			win_was_closed = true;
+
 		session->max_cmdsn = max_cmdsn;
+		/* Make sure we see the max_cmdsn from the xmit/queue paths */
+		smp_wmb();
+
+		if (win_was_closed)
+			iscsi_conn_queue_work(conn);
+	}
 	spin_unlock_bh(&session->back_cmdsn_lock);
 }
 
-void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
+void iscsi_update_cmdsn(struct iscsi_conn *conn, struct iscsi_nopin *hdr)
 {
-	__iscsi_update_cmdsn(session, be32_to_cpu(hdr->exp_cmdsn),
+	__iscsi_update_cmdsn(conn, be32_to_cpu(hdr->exp_cmdsn),
 			     be32_to_cpu(hdr->max_cmdsn));
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
@@ -429,14 +460,15 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	spin_unlock_bh(&task->lock);
 
 	session->cmdsn++;
+	/* make sure window checkers see the update */
+	smp_wmb();
 
 	conn->scsicmd_pdus_cnt++;
 	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
 			  "itt 0x%x len %d cmdsn %d win %d]\n",
 			  sc->sc_data_direction == DMA_TO_DEVICE ?
 			  "write" : "read", conn->id, sc, sc->cmnd[0],
-			  task->itt, transfer_length,
-			  session->cmdsn,
+			  task->itt, transfer_length, session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
@@ -547,7 +579,7 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 	ISCSI_DBG_SESSION(conn->session, "[itt 0x%x]\n", task->itt);
 
 	conn->last_recv = jiffies;
-	__iscsi_update_cmdsn(conn->session, exp_cmdsn, max_cmdsn);
+	__iscsi_update_cmdsn(conn, exp_cmdsn, max_cmdsn);
 	iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
@@ -593,7 +625,6 @@ static bool cleanup_queued_task(struct iscsi_task *task)
  */
 static void fail_scsi_task(struct iscsi_task *task, int err)
 {
-	struct iscsi_conn *conn = task->conn;
 	struct scsi_cmnd *sc;
 	int state;
 
@@ -603,15 +634,8 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 		return;
 	}
 
-	if (task->state == ISCSI_TASK_PENDING) {
-		/*
-		 * cmd never made it to the xmit thread, so we should not count
-		 * the cmd in the sequencing
-		 */
-		conn->session->queued_cmdsn--;
-		/* it was never sent so just complete like normal */
-		state = ISCSI_TASK_COMPLETED;
-	} else if (err == DID_TRANSPORT_DISRUPTED)
+	if (task->state == ISCSI_TASK_PENDING ||
+	    err == DID_TRANSPORT_DISRUPTED)
 		state = ISCSI_TASK_COMPLETED;
 	else
 		state = ISCSI_TASK_ABRT_TMF;
@@ -652,7 +676,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		 */
 		if (conn->c_stage == ISCSI_CONN_STARTED &&
 		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-			session->queued_cmdsn++;
 			session->cmdsn++;
 		}
 	}
@@ -838,7 +861,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
@@ -938,7 +961,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
 		return;
 
-	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
@@ -1258,7 +1281,7 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 			  opcode, conn->id, task ? task->itt : ~0U, datalen);
 
 	if (!task) {
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
@@ -1303,7 +1326,7 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		iscsi_data_in_rsp(conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1312,14 +1335,14 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		goto recv_pdu;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		/*
 		 * login related PDU's exp_statsn is handled in
 		 * userspace
 		 */
 		goto recv_pdu;
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1329,7 +1352,7 @@ int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		iscsi_finish_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1479,23 +1502,6 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
-static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
-{
-	struct iscsi_session *session = conn->session;
-
-	/*
-	 * Check for iSCSI window and take care of CmdSN wrap-around
-	 */
-	if (!iscsi_sna_lte(session->queued_cmdsn, session->max_cmdsn)) {
-		ISCSI_DBG_SESSION(session, "iSCSI CmdSN closed. ExpCmdSn "
-				  "%u MaxCmdSN %u CmdSN %u/%u\n",
-				  session->exp_cmdsn, session->max_cmdsn,
-				  session->cmdsn, session->queued_cmdsn);
-		return -ENOSPC;
-	}
-	return 0;
-}
-
 static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 			   bool was_requeue)
 {
@@ -1706,6 +1712,10 @@ static int iscsi_exec_cmd_tasks(struct iscsi_conn *conn, unsigned int *cnt)
 	int rc = 0;
 
 	while (!list_empty(&conn->cmd_exec_list)) {
+		rc = iscsi_check_cmdsn_window_closed(conn);
+		if (rc)
+			return rc;
+
 		task = list_entry(conn->cmd_exec_list.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
@@ -1934,14 +1944,14 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	spin_lock_bh(&session->frwd_lock);
-	if (iscsi_check_cmdsn_window_closed(conn)) {
-		spin_unlock_bh(&session->frwd_lock);
-		reason = FAILURE_WINDOW_CLOSED;
-		goto reject;
-	}
-
 	if (!ihost->workq) {
+		spin_lock_bh(&session->frwd_lock);
+		if (iscsi_check_cmdsn_window_closed(conn)) {
+			spin_unlock_bh(&session->frwd_lock);
+			reason = FAILURE_WINDOW_CLOSED;
+			goto reject;
+		}
+
 		if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 			spin_unlock_bh(&session->frwd_lock);
 			reason = FAILURE_SESSION_IN_RECOVERY;
@@ -1966,14 +1976,13 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			reason = FAILURE_SESSION_NOT_READY;
 			goto prepd_reject;
 		}
+		spin_unlock_bh(&session->frwd_lock);
 	} else {
 		task = iscsi_init_scsi_task(conn, sc);
 		llist_add(&task->queue, &conn->cmdqueue);
 		iscsi_conn_queue_work(conn);
 	}
 
-	session->queued_cmdsn++;
-	spin_unlock_bh(&session->frwd_lock);
 	return 0;
 
 prepd_reject:
@@ -3157,7 +3166,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
 	session->cmds_max = scsi_cmds + ISCSI_INFLIGHT_MGMT_MAX;
-	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
+	session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
@@ -3409,7 +3418,6 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	WRITE_ONCE(session->state, ISCSI_STATE_LOGGED_IN);
-	session->queued_cmdsn = session->cmdsn;
 
 	conn->last_recv = jiffies;
 	conn->last_ping = jiffies;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 92e84a19b100..c38e39b1546a 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -496,7 +496,7 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	 * is status.
 	 */
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
-		iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 
 	if (tcp_conn->in.datalen == 0)
 		return 0;
@@ -559,7 +559,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
 	/* fill-in new R2T associated with the task */
-	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 
 	if (tcp_conn->in.datalen) {
 		iscsi_conn_printk(KERN_ERR, conn,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 21579d3dc1f6..12bdaee3b87e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -310,10 +310,7 @@ struct iscsi_session {
 	spinlock_t		back_cmdsn_lock;
 	uint32_t		exp_cmdsn;
 	uint32_t		max_cmdsn;
-
 	uint32_t		cmdsn;
-	/* This tracks the reqs queued into the initiator */
-	uint32_t		queued_cmdsn;
 
 	/* configuration */
 	int			abort_timeout;
@@ -359,10 +356,9 @@ struct iscsi_session {
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
 	struct iscsi_conn	*leadconn;	/* leading connection */
-	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
-						 * cmdsn, suspend_bit,     *
-						 * _stage, exec lists, and
-						 * tmf_state    */
+	spinlock_t		frwd_lock;	/* protects cmdsn for offload,*
+						 * suspend_bit, _stage, exec  *
+						 * lists, and tmf_state       */
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
@@ -474,7 +470,7 @@ extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
 /*
  * pdu and task processing
  */
-extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
+extern void iscsi_update_cmdsn(struct iscsi_conn *conn, struct iscsi_nopin *hdr);
 extern void iscsi_prep_data_out_pdu(struct iscsi_task *task,
 				    struct iscsi_r2t_info *r2t,
 				    struct iscsi_data *hdr);
-- 
2.25.1

