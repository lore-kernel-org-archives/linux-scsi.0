Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E192C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4EB961360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhDCXYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44894 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDCXYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL6XJ097803;
        Sat, 3 Apr 2021 23:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fvWNDuFSuXa+uODipADiXT59+MXzQwm57qx98S0kMX0=;
 b=e2Tjjebfa0JW4jaeV6863xFhYcuH9mROBMRPesWN85VELxr13sWU0ZA5zd+l5MO4/8uG
 mXLjAc/67YA6prqFKGr3cSvhoJffFtIO0KV4/yyXts4eSjj9hEc9LNXj9MhZY56+stZY
 cllJW5W0mZeAJW38ghbnYvsGrdf4Y9E/sNi+4LGpMf5U2ci+hhNmjnkE8gHB/55pmz2g
 ihwyA8k45PtsS7Mf8tnab5vNfuZEKzrNlufot2i2tIPiCd41RXQLDfL0Hte2bQYpjztF
 h3BU2WsgQR75s0Du0xcVZZrLjyfCuUJifeRaCm09nqzcbC7h8zTtLNvjHa1rgxFTnA+K hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7le130247;
        Sat, 3 Apr 2021 23:23:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 37pg61hu6n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPbScL+dqxHMUToN4yp0aPx+9nXqapc8awsPiVpT+mS1d0mc5ichrVwKiUVNCglKG+s5INNHk09w7vshy9txttq/v3JaFrZ+8BErNFFkdwWKaSUCGrIfTsT3crjuVcFYZGIaETdPezo0SXmnmrXoUY5Z2bQXKogUaF/xCdO5YPCfeola5W0z0RabZ5u26Cfu8Y05gSM3UDJSBRYlLq4PXYKNvIjTSNIDN1Ka90OpAuu2ddR+Nr2iP6cgJn0gNn33PKh7EGw9Y5BnoV9QiuZVt2Mysrw0xvIhH/+/KD+HlWpZuXU+o4CqOGOFnDr7Np0ss+GGGq6BXt2GbZT0yLSJ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvWNDuFSuXa+uODipADiXT59+MXzQwm57qx98S0kMX0=;
 b=NPfsExPDU2ZAMW5EfhaaZu1lDfHSywnRBxu0vzNz61mSoN0VXtVSs+VulgMn8GJMeLF/znX93/ivf6PLKVkfdn9VTJggZR6RM/cvnwqKElij3vBAyh1dmPXtv1kCydGk8aXCBZwyoTMNCS/PMkcKCYMF7BlTVhFjU/uspjpC0nLRYMubiP9Tz+SH0edbCZbwX467l4upC/4mAuCro70FZznD8kz6kQH5iITfxR/OcoE7D8h3tkTDWY1L41i+lx+1HKXITzW0RYAXwVGM93G3KTVlqXsHKx7qNszgwzTV+Gzuiw8Z/9JhdrHeyMajN2HEp1MfGv3rh8tZqV33OHKKVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvWNDuFSuXa+uODipADiXT59+MXzQwm57qx98S0kMX0=;
 b=o5R5hPtY9Q7JLgPsuFYmTHxjgvf+8Gd8z16+VcBbJitF81Md1ODsb2aSaNZAFjshtwtp//i1Bs0RT7hpy/8dNFBSAshsj/b5ALw6nuYJwHh1IyyMh/G2X6oF+m7ADzMPtl76MJbwrFVAkZW6++Xjbw2NwOlZHGqlVcGyeATJlY0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3368.namprd10.prod.outlook.com (2603:10b6:a03:150::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sat, 3 Apr
 2021 23:23:47 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/40] scsi: libiscsi: fix write starvation
Date:   Sat,  3 Apr 2021 18:22:55 -0500
Message-Id: <20210403232333.212927-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b432c93-b696-4831-261d-08d8f6f787ba
X-MS-TrafficTypeDiagnostic: BYAPR10MB3368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33680871A4D65C633777A50BF1799@BYAPR10MB3368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCu4JGFhJEgMhxSE8Zwi2kSG/zBQouD3Xi6BqJK85UFRe8hahW1PiwDbpfQ4YQU/GY4X4XVD02jKAKW8eXPwOEIIm7WAPmD8/lbpQwzUsGuy+5umxCvyzxQ1ltRSp2YdN9eI6V37Kt5A3CNaRartBYzk7Tk/fAmvDZdAHBRV8ot/tP95wZM9hSr571Jm+U1REOF6EaTYRhw71EXasU/dy/fmja2TstBHU+c7E0ev5abRTSZOJ3oL5fUwdnQ+bvPKxtrwirvi+urwZrp2GeC1OJQmU/xxcoYGCR5/uiqmBRjtebhGM0wPk20QVR0xQf/oQ+e1EonE8zlebVqe9+N6ymMo53dKQ6UvqdHZwc2bwcQV7n6STeM+wdMnx0JmalRQX2pyHqI59+mimYGdsiviDu3U0qU+wVLv7oFrKcxg1zgkz3WqO4WHZPS15buXJLcPxNawYWcy+6eXvwLdlBdoFgj8Hn+ndedfCL1SybevyeriZrongQwMWymCuR1bFJ/+xmY3mAVO3aw6b0gZC0InYyDe2PMDJTN173GgPLQQrb+5jM2brCDYkPuaaEESRyaGAb8VMl9G3BsxXbM1fgu2C7TEECsuXbPHujSGHkgI4mV7s6o6NcBLiP4mhVRHo4vNw64Bb9SfuJJYUOnhz8zrvBsGx6RZSB4ooPuWRO8JzTE4cdVkSOVZUCXbph/dZ731RHwmnc11bNHnpfGF3R/5Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(956004)(478600001)(6666004)(921005)(4326008)(66946007)(2616005)(83380400001)(107886003)(8676002)(26005)(52116002)(8936002)(86362001)(38100700001)(16526019)(316002)(5660300002)(36756003)(186003)(66476007)(6506007)(6512007)(2906002)(6486002)(1076003)(7416002)(69590400012)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NYJfyhYDVUP0KokVGh4VzTlAhyryMMU7dGBmoZrp7qv6om0nWn1malsOVDaL?=
 =?us-ascii?Q?aeLLt5/64rp7cvaD4MtyXY4U7z5Nw2fqNBeqIf1sz/tcGNXW/lhu+aDoHl5R?=
 =?us-ascii?Q?1ZkaV/mbAiZJy3ecL0XW9qgOWdeLWBM2RvvyEVP8Iro7wFDsK1r+NhvPiQ92?=
 =?us-ascii?Q?yJPf9lJAOpyQ0nFGxH9o3ndFanEFm65nKVjkjtnEddyZ3VTEED0qyrPnTgGv?=
 =?us-ascii?Q?PNW1ed7/zcgDH05fsw+oZTIEe/d3T8RbK0GJiyq9R7BIWDuE274jVILWaoXE?=
 =?us-ascii?Q?lkN44aNOaB4rAEZRB+KvDA6bEGhyZshXAwAK7vcBk9/lBsGpjAaulAKjxmq+?=
 =?us-ascii?Q?ifa+g2ORaZw2neq5+UZe3RHNfAX8JHYr2Gry3+d+IMqh0qGfCSKfkJsJr6Di?=
 =?us-ascii?Q?MyU/ZTeO8ZWe9EBV+HDMWe3zD062vyLqKnA9t+/iHjOcP6zt4aN33C3LY+5O?=
 =?us-ascii?Q?ACCsbuvfc5gtOarbotj/fKEb2UDJ643EnijlVdQudIMl0z3k9ntMKBRIuVNE?=
 =?us-ascii?Q?AvrmRmqaVcAv3hCvKx6DwEqOwgv/SvtH3ucQ36GYj30NtnM1Wd1xVaJl/D5G?=
 =?us-ascii?Q?ZUNOQeet+WRrXy+NY/9PheCv2CrZP6150A/YznBTINkUWAZrLlXcFce+hv7U?=
 =?us-ascii?Q?QnKqOxPuchz0cZ9WI8pq8Uz5JbmETCEZ4iHU9qUMcLDqF+rBA5vKXlq1nusk?=
 =?us-ascii?Q?njttgqrmADSwQ7uKs/7JqPGFPP7X1lR6GTDownWYYYrAHe0QpbnTy8Gf6Y5K?=
 =?us-ascii?Q?rGgt3x1u2D+PxzML9HZT7mclktaLFXqnHXDI6iXc6TjfbUdfvvoOqXkMihhm?=
 =?us-ascii?Q?Tlh3wViVK461NBgKyzDo9bTPTN8lcCAm+GQYlkh9mLbY9y3+Zdbhbk0SQvR+?=
 =?us-ascii?Q?KrUAwtOUogE7aWXttNJ+z5anpMORnVX4fchCQ0GnsdIR1yB3ifsmQpiRSY/g?=
 =?us-ascii?Q?k0vN0zXALWoX11tQzpbkY4+eFjwGZzcjmOsbaPRVRjwSXVTIewP92F1VGT/A?=
 =?us-ascii?Q?s93VmU/qAkSxlcBUlomGQcaGJNjvq3sj7NIILPemPqVeaBzapQkNBCT6qDaI?=
 =?us-ascii?Q?rzfsrQohEsbT2CN57yjZVyZSr4+e+BMO1MtPdOgdZyLTwuL7IKz94aZjl/j9?=
 =?us-ascii?Q?xBKvCeYf0ruF1We3mYXVtAmKhXqJs1khLqKdvzXsy9ok4kegk4pMxt66BAIv?=
 =?us-ascii?Q?PBf4AVcgbxXCjJ3LzWKlmmlP6g0zxfbckB4DgArWvCWNsR1uFTepkmsZ6dVj?=
 =?us-ascii?Q?Hc3M0W/eXfRey/o8A5AF2ly0TKQYgo8BDdLJY/k3wA09KQzFvpmh/N8ZwLMV?=
 =?us-ascii?Q?CC8jV3JOKdW1dXSDZdNR907k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b432c93-b696-4831-261d-08d8f6f787ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:46.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkMKTJPlF8nEO6hSiO+FUHVktJX3ySVEBGn2NdBNTe1YJcjB3JCT6tB3O1wgi7Fv3PoW6fOR96Z2bTLkayokvuCfj1qXXEAdcKkq8pIAyDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3368
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: 8RxmLf52uIcwxf_Jrabd7BdwOBB1x5Da
X-Proofpoint-ORIG-GUID: 8RxmLf52uIcwxf_Jrabd7BdwOBB1x5Da
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently handle R2Ts after handling new cmds. This can lead to
starving existing WRITEs waiting for R2T handling, if apps are sending
new cmds so quickly cmdqueue is never empty.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 53 ++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..643edc4eb6fe 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1525,7 +1525,7 @@ EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 static int iscsi_data_xmit(struct iscsi_conn *conn)
 {
 	struct iscsi_task *task;
-	int rc = 0;
+	int rc = 0, cnt;
 
 	spin_lock_bh(&conn->session->frwd_lock);
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
@@ -1562,7 +1562,30 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 			goto done;
 	}
 
+check_requeue:
+	while (!list_empty(&conn->requeue)) {
+		/*
+		 * we always do fastlogout - conn stop code will clean up.
+		 */
+		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
+			break;
+
+		task = list_entry(conn->requeue.next, struct iscsi_task,
+				  running);
+
+		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
+			break;
+
+		list_del_init(&task->running);
+		rc = iscsi_xmit_task(conn, task, true);
+		if (rc)
+			goto done;
+		if (!list_empty(&conn->mgmtqueue))
+			goto check_mgmt;
+	}
+
 	/* process pending command queue */
+	cnt = 0;
 	while (!list_empty(&conn->cmdqueue)) {
 		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
 				  running);
@@ -1589,28 +1612,20 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 */
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
-	}
-
-	while (!list_empty(&conn->requeue)) {
 		/*
-		 * we always do fastlogout - conn stop code will clean up.
+		 * Avoid starving the requeue list if new cmds keep coming in.
+		 * Incase the app tried to batch cmds to us, we allow up to
+		 * queueing limit.
 		 */
-		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
-			break;
+		cnt++;
+		if (cnt == conn->session->host->cmd_per_lun) {
+			cnt = 0;
 
-		task = list_entry(conn->requeue.next, struct iscsi_task,
-				  running);
-
-		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
-			break;
-
-		list_del_init(&task->running);
-		rc = iscsi_xmit_task(conn, task, true);
-		if (rc)
-			goto done;
-		if (!list_empty(&conn->mgmtqueue))
-			goto check_mgmt;
+			if (!list_empty(&conn->requeue))
+				goto check_requeue;
+		}
 	}
+
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
-- 
2.25.1

