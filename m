Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EA9C63709
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLHDKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLHDKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4633D7720E;
        Wed,  7 Dec 2022 19:10:19 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NOYFT016849;
        Thu, 8 Dec 2022 03:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tMEturm9ATL46t8iTK9TWpa4sFH9MXGZtnEz2lAVJYY=;
 b=CauN4DyTO+5o7Yz+rTSf1t0B5+2L8opd9o4vafobXDiXl0Xj1VY+tklV5XFLgjGr47Uq
 /PsWbeij13NsDXnr1LGlDte+7tZgvgydtSkFWdU5BkOixsIdJs8YvD+fonff4kjUofU4
 v8Py6IkyUiz1R/tSh6J6Uk/icP9+LgKvq147SJWBKlMwEhg7k5chzabXghXAZnRgdju0
 7oLMPq4qlz0NfYeo0SeU2g8S34cEte+GAAdNWmFoXPqhegTHdHf3qSsQhQR6D69Em3Dw
 +/a+jHP0GWBhBAoeXNtYRPhgp+biY+GeDA2mhxgDOb64WkoPNbD4jK0MlKg9t7vhyhS5 vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maxeys1e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81Q6h8033770;
        Thu, 8 Dec 2022 03:10:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7xmkt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtP8BU9bkkBaO6p/J8gMrcOtgVDeD00fgknnVC1wNr+n8WqinOgwWV4q+yeD6dS7GtjVafLtoz5pnPcNboU4GjpQgNzNQwktt/kmRdzoFrUTMej5VrcFKgiWhDVG4XWKZGBKNanyceeOlETnSoUTLidLkFB0YLQB1VPc5SAy4vhX0bNY9ANJBagr1YQI6/9cHs3Y96xGG6YiibR+EMnzTU8/P3L9xQg6iiEdoHV0rmM2LPIpyYzzmd7rIDkU3Cc/joFU5Y3KstXUx3PMbXLzIW0sNQnvZ0MzsP0i4iCtAv6TMjTskciqGE0YSCLcisG6DPI2EavFkVhmW9iGriSNhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMEturm9ATL46t8iTK9TWpa4sFH9MXGZtnEz2lAVJYY=;
 b=AdWZIepNCEOx4+R6D7Rt2P20NDX/bTScCTFsN298edICxrppxTfciGsrBTGRBTsNcHdiBGJgISZGfgc91vD7njqHahqz+6JwuWwq/SpPjLdLQkEkMOQOPPv6mvhh6qDC0hpXTvaIlrg0FO0Qmtjeb/xWP0Yxi+rNbLkckbU2RAOw89yfNzDd9Xp4HwYH4yEG9r/BubhzrVkqHXG9/lOrE5Zb65UNJCgIcbz6rh6oRwBq7MZN31q3Ofqo+FuUYyfYCy0QlaqHAu1UGKqJ3fk5IAWHN1YdZIIoW2WMx9TL0p+OMA3x3fC2QRmfynPHYAxADVkNnHAOzdK+8GsTVmmohw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMEturm9ATL46t8iTK9TWpa4sFH9MXGZtnEz2lAVJYY=;
 b=S/JbMxDZPtU5LpD+pYF53WNp7z7yCW+mhcwU+4P3Jk8vuOlZU4lMh5n8g2OIUxuwBEBCKSDQCO6SO8mugl1IL6qzP93P87vHKfpgOPghXw6Z2vEhel9tiqccQcMY+7zLL5qyYeWDFPn9B3PAtiJvNIzt+RYMYUUa5lHIbsKdSHQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during conn close
Date:   Wed,  7 Dec 2022 21:10:00 -0600
Message-Id: <20221208031002.106700-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:610:5a::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 1264909d-307e-46eb-67f4-08dad8c9b962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40j6Te1oOYHrkecpQpdoths6oGDOUT+oeHqDsjhUzAZCsVSrZng9gkx6beeU0rkRg+W8tif94nH/O3t9WCjuWbHVWrmlwcgZcdafGL0qqeEuVQcLoxjuGexQdN7Wbzyk2XDJKMird9+PY614Vm+KglPeKBo7ybVEi60FeqJmi4XmDW9qB9z0QP6tc0nTiuJwnzYCkJ4bm4KGqYGEtt/xD37JtVGC1NnN0m0H8j/gmUid+oDc0AZOJJJSHSRiy3+BrhlrLDJuppP2Q8flV3j7lxQ/AlEPBo/JEzLx2bSvN3l5gXwiQjY3nss7QWfbDo5zZsoHl8ToEExMs683yEBWdplF74do0ZzBhaqrSaikK/59YUXLBAs9lI64oLL+KrMbbl3Q6c+MWecypIt5MprHawi7GSo8pyuq2h9LWiWJq6D3uA6Xy3WOd8y0THVBbpZzQYvc9RgPSuqQ5ZMCJdz8BoQoYV6WI6086MKCrRg7mGkP8BdpE5Erye+dQQoDljdks/2WaaXyDSmSjV4jhwNTjK97Sv8Z9b3Hp1Vdy9Di42zn9KV4OFkFSEAor8m8F4x9gDzGjAOhvHE9KkkO91En1VmhYOtehStMQwoaaxX+wGN4xxbHKeYEbsF/A7vocRPrJu6YesdmoREMJh0Cv2/ERA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fbRS8zguuxeIQbxVGduGuuPkFqjsmUTE7GHy8O4ZluNLzlhH7Gz6qXDl6unl?=
 =?us-ascii?Q?gYzUIXU0/xJ6wHBWGoaIxq6Dczux/l96yWCIPdI8tQ1QRAIM05/01X91068I?=
 =?us-ascii?Q?+vtPot7Sqxt1ljaod7oio0E1qne57/t+hVTqI85/YfLjxb5W/cemLzBu2Q9F?=
 =?us-ascii?Q?t04t9gAX9SzPyy1CR548dAYxCYCcinIe6yXnBHgxj+Nz5lLMjoe0Vwge/6qQ?=
 =?us-ascii?Q?qxi548cV7hIDdQVeRUWA+X/tkTPEN7kuxRXUT7B+604gvjHGKmapxhIDc6Oc?=
 =?us-ascii?Q?dG/MdPptnLibka2m2oJ7MRN0GaCqU1U4BXJmpU6wBtZuCYvTqux+FMKdh4du?=
 =?us-ascii?Q?S9/hGii92tuzcYlT2zA43GtOQcH9CIS8uyD7mwfvWJ/9ES3UYBD6RJBd+H2m?=
 =?us-ascii?Q?UL3YRHm9jXHN4jyQFld+CDFX05bCsDHvWXbydK84vSDB7LXiraPkWEz+dTKJ?=
 =?us-ascii?Q?gUYP0a1xXS2LB5SGtGydtmesAHQv4P6Yc7a5CVO7xUA5kJgMksW8lDB6koGd?=
 =?us-ascii?Q?SKBvvwQtqP1EIjezFZ4ih6dGjHMP4kgMqSBs8G/NVQXQQrYKq9wQ6jBM2wOp?=
 =?us-ascii?Q?azu++rRJCDrd3tHG1K+hYvJZS+WXybCY58QgQKyDdgcmxykhGcN+A7xLi3H+?=
 =?us-ascii?Q?2T9Aj6Jx3C8Ch/3XLbXociOgK7V3iROJptEEEB5aAAuZR5NF6rFsgtktsATa?=
 =?us-ascii?Q?fTEGhNnga4eMfx5eXubWgKUg8Rjgi8kMYWfRJtCypdk5zV6ZR3vKDJwqxSED?=
 =?us-ascii?Q?v+zVydpiwSUljNqm633Ug7ML2e836CtAaLWDvq5kno4eRPI4bueCBbb3vBdy?=
 =?us-ascii?Q?xv7eVFazSJ46NmYkkmrQJVVEI7MXTOixX46AdxnkFDwaQwNXYqN1Vu4nYfY/?=
 =?us-ascii?Q?5YBmNjS9szvmfE5DmcKgOY3DnqnKtxzctA1yIp40x+d8Cab3O/TE96fnZmwr?=
 =?us-ascii?Q?ZQxE+tjf4uchKxXHowShj7tPeDXBRPOrbZgajcEbSCg5OickvonbOgAKtj4N?=
 =?us-ascii?Q?/KpkfWcbvU1NtKHzUICu7edK9NWlxmh21CGdZzqCeKHv+mr0HI5DTKb3mb1N?=
 =?us-ascii?Q?ljn9uxwxTENoJ1cwo4X3W0lMId/tHV77jix6/sjPMYKTFImlnnzDhSSWmshO?=
 =?us-ascii?Q?sPEBQcqBo+iIz9WVPrmJxEGzDMfTfSuxw37jh/s82Wiyw96gHa3pfuIucBAR?=
 =?us-ascii?Q?Q2OsCNbaCm5od6Hz+7AydLIzLNL1qM3ThXsgotwl9yAEWa+BycGOkQ0DNjZM?=
 =?us-ascii?Q?j++HhbT/Z4iD6qtXWvPiJUbqND77AJT95mcaYVG9giSx/bYsi0tQBdGRhMJ4?=
 =?us-ascii?Q?D5Il2ZaLynmZlFpKYtdMJrmkM+sbU4GaAgXBh78Db336yKWP8SmPuDK911yp?=
 =?us-ascii?Q?RRTpL1yHXr4EgZvdu2+2669blGvpRavKhyccAeRJubKKnJL4qzr0wJC6Lypo?=
 =?us-ascii?Q?xRR58jzEKSdhQWwoDEe1mjaOXMTXF5PJO2fiDJCt8xkDV3CH8eRW8WCAutve?=
 =?us-ascii?Q?fHsn972wkH5Bl9xdf8e97oSPAv/sIzomq4jh1RMJbR0Bco3tuS9aqbNgNbLE?=
 =?us-ascii?Q?srO/6FS2rvLl0811tYGu2gknALdkrP2dltjEzq7BebO1f85hkNnl/yw91p0E?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1264909d-307e-46eb-67f4-08dad8c9b962
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:13.8012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Wdeavs3ThpSRJygqqdfbtc4RbNueDeT/4lkNkcx1jM44SN5KQNSrlS0UHF+9GGkzLSTmK4Wk/6x0+H7MM49gMLzdJMgxxb6FEZAcgV5tLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080024
X-Proofpoint-GUID: N4OkJQWJdnWkrpNTYibFJy1QzxxPy10I
X-Proofpoint-ORIG-GUID: N4OkJQWJdnWkrpNTYibFJy1QzxxPy10I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes 2 bugs added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If we have multiple sessions to the same se_device we can hit a race where
a LUN_RESET on one session cleans up the se_cmds from under another
session which is being closed. This results in the closing session freeing
its conn/session structs while they are still in use.

The bug is:

1. Session1 has IO se_cmd1.
2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
but then gets a LUN_RESET.
3. The LUN_RESET on session2 sees the se_cmds on session1 and during
the drain stages marks them all with CMD_T_ABORTED.
4. session1 is now closed so iscsit_release_commands_from_conn only sees
se_cmds with the CMD_T_ABORTED bit set and returns immediately even
though we have outstanding commands.
5. session1's connection and session are freed.
6. The backend request for se_cmd1 completes and it accesses the freed
connection/session.

If session1 was executing only IO se_cmds and TAS is set on the se_cmd,
then we need to do a iscsit_free_cmd on those commands, so we wait on
their completion from LIO core and the backend.

If session1 was waiting on tmr se_cmds or TAS is not set then we need to
wait for those outstanding se_cmds to have their last put done so we
know no user is still accessing them when we free the session/conn.

This fixes the TAS set case, by adding a check so if we hit it we now call
iscsit_free_cmd. To handle the tmr se_cd and non TAS case, it hooks the
iscsit layer into the cmd counter code, so we can wait for all outstanding
commands before freeing the connection and possibly the session.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 13 +------------
 drivers/target/iscsi/iscsi_target.c     | 13 ++++++++++++-
 drivers/target/target_core_transport.c  |  6 ++++--
 include/target/target_core_fabric.h     |  2 ++
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b360a1527cd1..600059d8a3a7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2501,17 +2501,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsit_conn *conn)
-{
-	isert_info("iscsit_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_stop_session(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2559,7 +2548,7 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
+	target_wait_for_cmds(conn->cmd_cnt);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7a8ffdf33bee..1c3470e4b50c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4221,7 +4221,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->transport_state & CMD_T_ABORTED &&
+			    !(se_cmd->transport_state & CMD_T_TAS)) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
@@ -4244,6 +4245,14 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		iscsit_free_cmd(cmd, true);
 
 	}
+
+	/*
+	 * Wait on commands that were cleaned up via the aborted_task path.
+	 * LLDs that implement iscsit_wait_conn will already have waited for
+	 * commands.
+	 */
+	if (!conn->conn_transport->iscsit_wait_conn)
+		target_wait_for_cmds(conn->cmd_cnt);
 }
 
 static void iscsit_stop_timers_for_cmds(
@@ -4304,6 +4313,8 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
+	target_stop_cmd_counter(conn->cmd_cnt);
+
 	if (conn->conn_transport->iscsit_wait_conn)
 		conn->conn_transport->iscsit_wait_conn(conn);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 90e3b1aef1f1..8bbf0c834b74 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3174,13 +3174,14 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
  * target_stop_cmd_counter - Stop new IO from being added to the counter.
  * @cmd_cnt: counter to stop
  */
-static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	pr_debug("Stopping command counter.\n");
 	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
 		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
 					    target_stop_cmd_counter_confirm);
 }
+EXPORT_SYMBOL_GPL(target_stop_cmd_counter);
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
@@ -3196,7 +3197,7 @@ EXPORT_SYMBOL(target_stop_session);
  * target_wait_for_cmds - Wait for outstanding cmds.
  * @cmd_cnt: counter to wait for active I/O for.
  */
-static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
@@ -3212,6 +3213,7 @@ static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+EXPORT_SYMBOL_GPL(target_wait_for_cmds);
 
 /**
  * target_wait_for_sess_cmds - Wait for outstanding commands
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4cbfb532a431..b188b1e90e1e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,6 +133,8 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
+void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt);
+void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt);
 struct target_cmd_counter *target_alloc_cmd_counter(void);
 void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
 
-- 
2.25.1

