Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4190C43460
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E2561360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhDCXYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhDCXYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJjFC039009;
        Sat, 3 Apr 2021 23:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=UdOEpYCwx7+FBXgC/RRYfTA1ZnDFIqhvNcDjQd4hqfA=;
 b=PkZk7w3RQQ+hy/1O7/+RJDAJWnlMZikycIh0UnDhd7EZUqMFvwdwpFFMwqyQyp7Bx659
 sURs35CapJ+9cfLiZHyHwT3dZ83143YSZp86Qt2RaShUU/gUwQZ08n4ICTHQ9wG1QuZV
 XKDohYzASHfUoLFPAuo2ERAYJonKUl+yTLuSbEKWtIEGV0Ffcdxf8CGnO63YMfA3zkvX
 tDZBNcazOnFfXAmMhHQVZBZUs+gnQHdZMLfO/gQddCwshitehrbTho0X2EkKSFE1y8uR
 PBwKsJfDiAjgfCPgm7lCpLsp7Hlsu3Hde3kBhV/VgKUqRykjN6wKIgB/3Ibv37VAuICi fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37pfsrrsgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJsFl132172;
        Sat, 3 Apr 2021 23:23:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 37q1xk81gr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/34NnJjwpJBh356UJ/HwiXstRbzmNH+0YoG/1dqXkQJTevMGr8eFILSrg0KkUOMAM0Y51lkjuNio2qaEHmgWgRNaHXBqSC1L0jMhpY3GjQFbU1MckIEncbLdbZGg7W1MeuDPTbeSs483ot3w5d6DF2irD9CcY//bSS9LI7GBVyjNYfA0WsVdXzra2KOeRSHZUvYJ49i+QgT7pibgMyyO+8qYcufHtEVD92Jn+fCpr9g6md6HVg+MOaHlcxDTayNCFfLneVd+Q4HFr2a1wEkOBxrPUa3bZkr2sSFLp+uqgVaTlU3fBQhMo/PKwl31WfZBvY4RSxXQ9EhVjbwgmeGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdOEpYCwx7+FBXgC/RRYfTA1ZnDFIqhvNcDjQd4hqfA=;
 b=RW2ohsvjuVPZtlQDJ4FPnIs84Si0qjto6KTDTQuDsAL+6iKLnvh/wEhEWU7SfSsQfRPRvE2a7s5tyY2/WSRlY9EkdnQV/zQg9NWX2EhgZs2gAoF3Mm8wotALJWAJYh1otGXeItczwJNeQz5WURltLiXPpA+QREFT3wormzQyfl4WFGzI+1Wkvs/TtQWicSiKsyN03coXSr6I+4YKNYb3bBh2avCxqWie3KjXBhULU6kein1oCAr1zTX9JoWXgkRjfsQazYXXZjflWte1weE+kHjYNkzhkogKIdtVdzCMx3CKNxWsEHuRmnHjKePxO3TCrf37OHJOGYF92jO4VMrSig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdOEpYCwx7+FBXgC/RRYfTA1ZnDFIqhvNcDjQd4hqfA=;
 b=pVrwRAFwaVCfkPWrDEfNCje/DsnX13zQuay5R1CtdvwkdO88d1IhzwlSczyWbU/QOc64GsVimludMJZMS25kcj/AEPYjhFBVukMzNPO5G33W7Iiuc2tJJ65xLTszeQ7lMhWhj3v65sFS+5uRUrrkYeaNeRxdgeSVP+UhwGciDkE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/40] scsi: libiscsi: drop frwd lock for session state
Date:   Sat,  3 Apr 2021 18:22:57 -0500
Message-Id: <20210403232333.212927-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfa59101-c6f3-4013-c6ee-08d8f6f78941
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526E502A13A217FA6A53A4BF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nS50YqjE23kkjaSUUqAZ75NYYFdqWLqems6ZSaENXktGoTzSgb0V+mguUlm3geoxUD5XW5GvDI4R+EfczZozkRWG2UvPAN9ojCafV+obgto6l5uYjIeIyDcTT/aqmQ0kvUNdivB7GIzmWEu0GQLHP6Lcc8NjIvoOt4qjkCMoUEddilJPE/iCtoJ2cKhRmiADDRJSR/caJWJ5SoPLU8Fif6Z5ItPkZZUHZXTFm30+tVG0ZdQx62z0pjX9Np22x4noD5DkXWra3AzqkNAOY7R1cwat5wFfPyWiMuNxtOOn+731SyJxhINurd01gwF0I4UfbU0vbdK6Uha/o6gywLKNXka4Isxq/z34gHco6E+K/6cXlaIug+wkgAtoki7qDm4BAMkjxzlHilGhCByQDFbyaZHoL5pmgc/k6H772wg7GMUOymilhilmXSPHV4N3XSuYbOoBpzxV66Q9hyv2G3PTV7W5QmqfUXNMVXqjzbkYmQFC05C6A/d0yvXs7lOZq+ZuHDK79mYPxG1EvHfamiD98VNhDPM0WOydc0CjVqBf/ToUQrURjXVkDjTwnGy7flUvgwEJYaCfOe6QA5PKl04esq7we2G+G3YyzqiEa2VvEeUH/Qrdk5upAI22TbYu4RHrHUIaYhC2q3iutaT/4yfFzT97SDx7DQCpRy/S1E7AidPzJPYaSTrCcOhnnvNgjiiyhJbiy4Fvkq9bBHKPqBls3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(30864003)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g7Nme2pHvARn39VT7mPHcufFcYZppOAoiRlVh48Q7PUQAnsaTzuPW7v7O8bU?=
 =?us-ascii?Q?39PwMRDILPk6hzZ3SCLqndZzfzMggxAQ6DfVNqncih5f70zQ5A992aeoPf0C?=
 =?us-ascii?Q?oqYfgoT7kul0SyGINDddqk+zAsohTG2/3bNLVijfom+P75+Gr1o4jIDnFwL5?=
 =?us-ascii?Q?fDVSTWNdhZfAmgK0lFWsYw4WiCnINKYcOzHMAfFHRki//xfF8KbrYOKJ9Asv?=
 =?us-ascii?Q?XEuTVMsvxXonGPguY9003BtObpxGruHELuauonyN0uE5Ic5bRQNaF43rX5m5?=
 =?us-ascii?Q?lz9P9tIqKusNSSD8FAOb5Lk00MsUc9Fu/97Zl2hgTDlECEJCS/dXa6bHPhbS?=
 =?us-ascii?Q?OVNl6HqsSeGrmLoYgYeFsCY+L+k3y1tNJsxKQzoslD6czo7pfbsvRrMLDjfS?=
 =?us-ascii?Q?qYqQ0bMYtMKGIjIlrUeJDd7DevertxgBB4C+20/BVpW1sqgRrPsouoV1N+pT?=
 =?us-ascii?Q?1h1O0OusuSGalU5ARQo3z/gNYJz+Vtce43KbyF5Z9PRLYkI0mfduOZF4rAKo?=
 =?us-ascii?Q?9RLlVBVgTRfzjtBlDoal3BXFzI6RTP7xTTIMW/vC5FSVmmwqqQkJm6xetHiP?=
 =?us-ascii?Q?gR5FCmf2sEfU3KuDkvXtI/uaCDvjZu7xOWzExPO1XixvZ82IXvOfQyW7d2rr?=
 =?us-ascii?Q?ZcjFmrDemHHL2VOVLGqyHTMoq5ehPiscCtlqyxmN0mOSwYZHQ1H9ifSLVCFC?=
 =?us-ascii?Q?bY1DKfOLFjmyD/asmJxAvpJCUDYMWqn4GC142Jf5imS99f0UIpq6PZ8wHSaI?=
 =?us-ascii?Q?IXTLuX9ypHWnxL3oYXCbBlh0Nhzw8XmUnYSD7XEIvDBR+TPbk8zDRNrsbaiG?=
 =?us-ascii?Q?Nx5CdLOQjjfCDAjKyIY+Qp6t1E1GgDbQsAS0vU+uAv2gm1qkTbLVYFCOKNOo?=
 =?us-ascii?Q?2cS+hslWn47X5XwXjutwcvkCLyBNRlpxuuhmK2Gl0pV70yleC6/phdiUd09l?=
 =?us-ascii?Q?Tg7h7euqsxJwyQ6koOWOo30KMAnAc1HdA0huaN8uCLiA+SUHMN+xLDXeySDc?=
 =?us-ascii?Q?/tx10OzeqIYmf2mUCkIoP+DZB6Z3HklNk1iCaB0LYvOsJFbhH5ngYab/r3BT?=
 =?us-ascii?Q?U/soDm1K87RIb/GJurJ8U2v0WkdDauXmtpL3p5/bnzKgnEHfojxV+tZTMi18?=
 =?us-ascii?Q?xnBakN2ttjJ+O45P1NNL/Dzq8EQfx2Q70EqkUDUbO7Yqn0bVQobFLAIAh6Ic?=
 =?us-ascii?Q?Z+m0EFZdQnlbz74RPjq7h2oTdiZFxxtZOXDYrl/ofaNLsR8BRVyAVQtgFR++?=
 =?us-ascii?Q?swTTqTmFwi3yA1cIUQ2cc+cwvf/NiyiiiXXO+ypJOSvfVKIWwpY78SY4u58f?=
 =?us-ascii?Q?GaCEfR44UJH4+u9dfy1bf9TW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa59101-c6f3-4013-c6ee-08d8f6f78941
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:49.4688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvloelexzFJRGR9MGhNzodBXy1zGziih0cJL6ZyVbCnxnba9Pj9Q9ppbJRIbulHZ4VCV4BWsORg7Moscx5C4h3H4BNsrWuL179z0vsbUSJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: kzFU_LZoyXhBlIBtWOphLLPPa2kp_rdX
X-Proofpoint-GUID: kzFU_LZoyXhBlIBtWOphLLPPa2kp_rdX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This drops the frwd lock for the session state checks in queuecommand.
Like with the transport class case, we only need it as a hint since when
the session is cleaned up we will block the session which flushes the
queues, and then we clean up all running IO. So the locking just prevents
cleaning up extra cmds. This patch is a prep patch and does not help perf.
This patch and the next ones are going to chip away the reasons we need
the frwd lock in the queuecommand code path until there are none left for
software iscsi.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c  |  3 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  3 +-
 drivers/scsi/libiscsi.c          | 86 +++++++++++++++++---------------
 drivers/scsi/qedi/qedi_iscsi.c   |  3 +-
 include/scsi/libiscsi.h          | 14 ++++--
 5 files changed, 62 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 56bd4441a789..18d0591e4dbb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -285,7 +285,8 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	session = cls_session->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN) {
+	if (!session->leadconn ||
+	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN) {
 		spin_unlock_bh(&session->frwd_lock);
 		return FAILED;
 	}
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 37f5b719050e..48809fc8f095 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2056,7 +2056,8 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	if (session) {
 		spin_lock_bh(&session->frwd_lock);
 		if (bnx2i_ep->state != EP_STATE_TCP_FIN_RCVD) {
-			if (session->state == ISCSI_STATE_LOGGING_OUT) {
+			if (READ_ONCE(session->state) ==
+			    ISCSI_STATE_LOGGING_OUT) {
 				if (bnx2i_ep->state == EP_STATE_LOGOUT_SENT) {
 					/* Logout sent, but no resp */
 					printk(KERN_ALERT "bnx2i (%s): WARNING"
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 94cb9410230a..7b83890aeb7a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -633,7 +633,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
-	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+	if (READ_ONCE(session->state) == ISCSI_STATE_LOGGING_OUT)
 		return -ENOTCONN;
 
 	if (opcode != ISCSI_OP_LOGIN && opcode != ISCSI_OP_TEXT)
@@ -662,7 +662,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		return -EIO;
 
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
-		session->state = ISCSI_STATE_LOGGING_OUT;
+		WRITE_ONCE(session->state, ISCSI_STATE_LOGGING_OUT);
 
 	task->state = ISCSI_TASK_RUNNING;
 	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
@@ -679,9 +679,10 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
+	int sess_state = READ_ONCE(session->state);
 	itt_t itt;
 
-	if (session->state == ISCSI_STATE_TERMINATE)
+	if (sess_state == ISCSI_STATE_TERMINATE)
 		return NULL;
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
@@ -704,7 +705,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		task = conn->login_task;
 	} else {
-		if (session->state != ISCSI_STATE_LOGGED_IN)
+		if (sess_state != ISCSI_STATE_LOGGED_IN)
 			return NULL;
 
 		if (data_size != 0) {
@@ -1368,7 +1369,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
-	if (session->state == ISCSI_STATE_TERMINATE || !conn) {
+	if (READ_ONCE(session->state) == ISCSI_STATE_TERMINATE || !conn) {
 		spin_unlock_bh(&session->frwd_lock);
 		return;
 	}
@@ -1395,13 +1396,13 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 	struct iscsi_session *session = conn->session;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
+	if (READ_ONCE(session->state) == ISCSI_STATE_FAILED) {
 		spin_unlock_bh(&session->frwd_lock);
 		return;
 	}
 
 	if (conn->stop_stage == 0)
-		session->state = ISCSI_STATE_FAILED;
+		WRITE_ONCE(session->state, ISCSI_STATE_FAILED);
 	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
@@ -1570,7 +1571,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		/*
 		 * we always do fastlogout - conn stop code will clean up.
 		 */
-		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+		if (READ_ONCE(conn->session->state) == ISCSI_STATE_LOGGING_OUT)
 			break;
 
 		task = list_entry(conn->requeue.next, struct iscsi_task,
@@ -1593,7 +1594,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
-		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
+		if (READ_ONCE(conn->session->state) == ISCSI_STATE_LOGGING_OUT) {
 			fail_scsi_task(task, DID_IMM_RETRY);
 			continue;
 		}
@@ -1695,6 +1696,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
+	int sess_state;
 
 	sc->result = 0;
 	sc->SCp.ptr = NULL;
@@ -1703,7 +1705,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock_bh(&session->frwd_lock);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1711,14 +1712,15 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (session->state != ISCSI_STATE_LOGGED_IN) {
+	sess_state = READ_ONCE(session->state);
+	if (sess_state != ISCSI_STATE_LOGGED_IN) {
 		/*
 		 * to handle the race between when we set the recovery state
 		 * and block the session we requeue here (commands could
 		 * be entering our queuecommand while a block is starting
 		 * up because the block code is not locked)
 		 */
-		switch (session->state) {
+		switch (sess_state) {
 		case ISCSI_STATE_FAILED:
 			/*
 			 * cmds should fail during shutdown, if the session
@@ -1753,26 +1755,31 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
+	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
 	if (!conn) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_FREED;
 		sc->result = DID_NO_CONNECT << 16;
 		goto fault;
 	}
 
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
 	}
 
 	if (iscsi_check_cmdsn_window_closed(conn)) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_WINDOW_CLOSED;
 		goto reject;
 	}
 
 	task = iscsi_alloc_task(conn, sc);
 	if (!task) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_OOM;
 		goto reject;
 	}
@@ -1803,21 +1810,23 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return 0;
 
 prepd_reject:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 reject:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 fault:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
@@ -1885,8 +1894,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	 * given up on recovery
 	 */
 	wait_event_interruptible(conn->ehwait, age != session->age ||
-				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmf_state != TMF_QUEUED);
+			READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN ||
+			conn->tmf_state != TMF_QUEUED);
 	if (signal_pending(current))
 		flush_signals(current);
 	del_timer_sync(&conn->tmf_timer);
@@ -1895,7 +1904,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	spin_lock_bh(&session->frwd_lock);
 	/* if the session drops it will clean up the task */
 	if (age != session->age ||
-	    session->state != ISCSI_STATE_LOGGED_IN)
+	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN)
 		return -ENOTCONN;
 	return 0;
 }
@@ -2025,7 +2034,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	__iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
 
-	if (session->state != ISCSI_STATE_LOGGED_IN) {
+	if (READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN) {
 		/*
 		 * During shutdown, if session is prematurely disconnected,
 		 * recovery won't happen and there will be hung cmds. Not
@@ -2161,7 +2170,7 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
 	spin_lock(&session->frwd_lock);
-	if (session->state != ISCSI_STATE_LOGGED_IN)
+	if (READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
 	recv_timeout = conn->recv_timeout;
@@ -2242,7 +2251,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * If we are not logged in or we have started a new session
 	 * then let the host reset code handle this
 	 */
-	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN ||
+	if (!session->leadconn ||
+	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN ||
 	    sc->SCp.phase != session->age) {
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
@@ -2375,7 +2385,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	 * Just check if we are not logged in. We cannot check for
 	 * the phase because the reset could come from a ioctl.
 	 */
-	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
+	if (!session->leadconn ||
+	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn = session->leadconn;
 
@@ -2434,8 +2445,8 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = cls_session->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (session->state != ISCSI_STATE_LOGGED_IN) {
-		session->state = ISCSI_STATE_RECOVERY_FAILED;
+	if (READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN) {
+		WRITE_ONCE(session->state, ISCSI_STATE_RECOVERY_FAILED);
 		if (session->leadconn)
 			wake_up(&session->leadconn->ehwait);
 	}
@@ -2461,19 +2472,15 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_TERMINATE) {
+	if (READ_ONCE(session->state) == ISCSI_STATE_TERMINATE) {
 failed:
 		ISCSI_DBG_EH(session,
 			     "failing session reset: Could not log back into "
 			     "%s [age %d]\n", session->targetname,
 			     session->age);
-		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
 	}
-
-	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 	/*
 	 * we drop the lock here but the leadconn cannot be destoyed while
@@ -2483,21 +2490,19 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
-				 session->state == ISCSI_STATE_TERMINATE ||
-				 session->state == ISCSI_STATE_LOGGED_IN ||
-				 session->state == ISCSI_STATE_RECOVERY_FAILED);
+			READ_ONCE(session->state) == ISCSI_STATE_TERMINATE ||
+			READ_ONCE(session->state) == ISCSI_STATE_LOGGED_IN ||
+			READ_ONCE(session->state) == ISCSI_STATE_RECOVERY_FAILED);
 	if (signal_pending(current))
 		flush_signals(current);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_LOGGED_IN) {
+	if (READ_ONCE(session->state) == ISCSI_STATE_LOGGED_IN) {
 		ISCSI_DBG_EH(session,
 			     "session reset succeeded for %s,%s\n",
 			     session->targetname, conn->persistent_address);
 	} else
 		goto failed;
-	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 }
@@ -2538,7 +2543,8 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	 * Just check if we are not logged in. We cannot check for
 	 * the phase because the reset could come from a ioctl.
 	 */
-	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
+	if (!session->leadconn ||
+	    READ_ONCE(session->state) != ISCSI_STATE_LOGGED_IN)
 		goto unlock;
 	conn = session->leadconn;
 
@@ -2892,7 +2898,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session = cls_session->dd_data;
 	session->cls_session = cls_session;
 	session->host = shost;
-	session->state = ISCSI_STATE_FREE;
+	WRITE_ONCE(session->state, ISCSI_STATE_FREE);
 	session->fast_abort = 1;
 	session->tgt_reset_timeout = 30;
 	session->lu_reset_timeout = 15;
@@ -3070,7 +3076,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		/*
 		 * leading connection? then give up on recovery.
 		 */
-		session->state = ISCSI_STATE_TERMINATE;
+		WRITE_ONCE(session->state, ISCSI_STATE_TERMINATE);
 		wake_up(&conn->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
@@ -3130,7 +3136,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 
 	spin_lock_bh(&session->frwd_lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
-	session->state = ISCSI_STATE_LOGGED_IN;
+	WRITE_ONCE(session->state, ISCSI_STATE_LOGGED_IN);
 	session->queued_cmdsn = session->cmdsn;
 
 	conn->last_recv = jiffies;
@@ -3216,9 +3222,9 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * the recovery state again
 	 */
 	if (flag == STOP_CONN_TERM)
-		session->state = ISCSI_STATE_TERMINATE;
+		WRITE_ONCE(session->state, ISCSI_STATE_TERMINATE);
 	else if (conn->stop_stage != STOP_CONN_RECOVER)
-		session->state = ISCSI_STATE_IN_RECOVERY;
+		WRITE_ONCE(session->state, ISCSI_STATE_IN_RECOVERY);
 
 	old_stop_stage = conn->stop_stage;
 	conn->stop_stage = flag;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..0a85b347297c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1436,7 +1436,8 @@ void qedi_start_conn_recovery(struct qedi_ctx *qedi,
 		qedi_conn->abrt_conn = 1;
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Failing connection, state=0x%x, cid=0x%x\n",
-			 conn->session->state, qedi_conn->iscsi_conn_id);
+			 READ_ONCE(conn->session->state),
+			 qedi_conn->iscsi_conn_id);
 		iscsi_conn_failure(qedi_conn->cls_conn->dd_data,
 				   ISCSI_ERR_CONN_FAILED);
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..ddd4b9a809a1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -328,15 +328,21 @@ struct iscsi_session {
 	 * can enclose the mutual exclusion zone protected by the backward lock
 	 * but not vice versa.
 	 */
-	spinlock_t		frwd_lock;	/* protects session state, *
-						 * cmdsn, queued_cmdsn     *
-						 * session resources:      *
+	spinlock_t		frwd_lock;	/* protects queued_cmdsn,  *
+						 * cmdsn, suspend_bit,     *
+						 * leadconn, _stage,       *
+						 * tmf_state and session   *
+						 * resources:              *
 						 * - cmdpool kfifo_out ,   *
 						 * - mgmtpool, queues	   */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
 						 * cmdpool kfifo_in        */
-	int			state;		/* session state           */
+	/*
+	 * frwd_lock must be held when transitioning states, but not needed
+	 * if just checking the state in the scsi-ml or iscsi callouts.
+	 */
+	int			state;
 	int			age;		/* counts session re-opens */
 
 	int			scsi_cmds_max; 	/* max scsi commands */
-- 
2.25.1

