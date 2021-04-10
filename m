Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B96C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F14610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhDJSlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhDJSlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIVUxA006095;
        Sat, 10 Apr 2021 18:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=cbCl7f+B0puW2+Dn7l0hLwo6r+MNxK4uqKGnzfS1xZc=;
 b=pnDp2iBYz5+d1sAQg/O4oOTFaeEfnWbyRlTKJhZ6NB94lm9UzxODLRNynnYmNF0z2294
 ibrgXRCuRBZjRG/HPZMjFDkpaULhkyQuyVxTm9FxfQjaoao60dvivgfItUMrlROlXmGR
 +kbLWFwAS3YjwZZbnHGdv1STfhYfP/jpfN8mN/GEc76U/nDI3woApAI16NK+StzIyY6/
 TJB8C/+n31suaWB2Yx7Qmh++DmS1dTUKHqsrDMNA4P6pFCoc9/9JsdNAhapyqBBu5z2t
 hDtNyFt4bi5sgA7fbyeEkxPk6zmdfvaMwjtXNe6BBD7cQI2XIj0A4Y0Cq9CNBgQfStOo Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nn8r8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AITiZE176788;
        Sat, 10 Apr 2021 18:40:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgNWnUWa6DZnJUp4EZVtj7dI2M93fGq9T8aSa2nmfsDmSs7OiCURmElCNAFfhuC5MTaIBDlbJAlwh1ZGXYP3kN5rYdQshorv5G2jDZxvbmDHD0OeD97dN/gDL5kZUV9YvqCH7XQ18zJXG7eLzqRyvRnpybMmTSidPPKwp7xWs/fe23el6hvbZJ3RTxGH6GY0fXGK5jDvFZcVJfiLLHUVGaTX7ySTLxKdpZMlR++lMhTmE2Hn9C1lMvOpHlr/nPZhQ72EWrWQDCiu/W7PRGS1piAnW7X1rwMTXpT7DaO0BS4bucIvHc+uQ9urxbcqltvUs9d/YkRG6XosCPJy76ujIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbCl7f+B0puW2+Dn7l0hLwo6r+MNxK4uqKGnzfS1xZc=;
 b=EIaohTJbkEx77CHbybJ3LnLNemmbPtfyjns+JaELZXM7oOvNRMyEAgPyXRhjqE9i6K2PUz058E1HQJj09gjTufdDwpY51hoRdYnFHqlScLGcZ2ff0MgM8Ek0WmTc+ZPawrlTQwODTMC1XvUYekxS6ZnhmjTiGioU+zn6tV+QLk42Dd/wUzD2rx3YxnRLUNFrYmMRPv45uggeO/J8jDJ4NN0BcMoQSADG8/CyllgJ+8FvqTqcG97n2e+9waXoeebWFaM6netDEqvBu4iEw1ImF3hgGvVpHFXCqPWGZdZ9KlQN/2kuQdVzWHeK6RZVEHgkJu9M+pvEZ9T5K0xVSaBn/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbCl7f+B0puW2+Dn7l0hLwo6r+MNxK4uqKGnzfS1xZc=;
 b=noGFvJ6Y8GPXxKB2JQagLbC0jvCYSgIYYUR9IzL6leNMNigEzpIff4P7BjQjStGra9bMeXIRCX4mtn5/h9TcVugrslne8eudXbKmIxY/kw2ctVsd1V79PPKrY8GerDH2BA8pN1+TaStDWYvplab1G01Q9K8ETblXHSi65JrQacs=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/13] scsi: qedi: fix session block/unblock abuse during cleanup
Date:   Sat, 10 Apr 2021 13:40:13 -0500
Message-Id: <20210410184016.21603-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25e9e5b7-0549-4691-45f1-08d8fc50214c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324013C16798CBBD8040BC0F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMg29wautJI8mDGyby5DlruKM7+wuZb1/Z6Uevl3y9FNeP4Vkq9WBZApOvP9BtxExHUFVpF32DFQeLo4y3FrHJYsHcb0ObgZmNi16/4Sp5Vyg2IGLoVG3noHM1i0dqkhbbfeSWFmNnPHHF/QT1IYG9Dc3LTOjEfmd/zjKE1W2GzPYgipItkQNFF/nu1gRAdgNUmVfY/vrvewH4nwfmqsG5ODsrF20j7kdOc88T1TU9hfbZSUsrqp8LcEaAwUtcyzhfv4QKmJt0jDPg7kYIkj+ILd+Cc7AVNQnzBNIF7OiJRENSPLCORe6uBCukL7HUy9CuW88Cv7rpKj5t1yiFhSmX8TWBZsS9twMAVz6pyCZyoBJqUJ2ButsHo/G+3AaeJxXL1WwhL4oDwOmOxHUTglopNeSbC87ue3i6qpJbUAm748MVr6GkcYfrhzIddObjEW/OksFPTTAWOJVUcDdfeGeew4Dtq135SFbluXWoCPewOiAgPCVozWO1rDgdo3Br020d5UZPyRHmP6y2ZpkW2VE0P2/oaYkQop4k1jnNt8c049bOGk3qE6EJyln7HJJYZt9RigmgYL1lZkoFrnCknDYgy8ObHSJM+kXxMrA0VVnCYykPG5435pnvobDIFr9bVQkKY0uG8IbroaS/uTBc6A0gT+C2ZNztpvPBGxSivs+tvB3mi0+mXL0XQQDpnN/kg+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iYHlMlmmNn2X9o1hnNDfC4C2t7o/OL4IZHpB54Qr+3wUMEjtFceqgJGvqmZc?=
 =?us-ascii?Q?EsTk1C5Cu1KHNO5gVJwBBKHBIr6aXJ4i3c9CHXSVc7/oanrI86bgCpBIA4qE?=
 =?us-ascii?Q?zV5E+nROYcrPdT0vfs8Iap9uLxbYslMLg97Tkyap+R/Is9k/bZ9/3kXEU6jt?=
 =?us-ascii?Q?5tBqjHgWzRv4ogu4n2YaPrJOoABh5VwnAtMBAVXV7z1VoZpgjdA9bmVfRKmo?=
 =?us-ascii?Q?JGZp2Z/tRoLfmHAAR6KBc3Z0upq6/PG5gN61yyYfvS3d9J1+N8pYh5am7w3T?=
 =?us-ascii?Q?1hHLZ0VcfZlQOk6J3EYMZ6vUHPW+5IOFnE9nSdkiYVFo2h1NZXWrCOfvmgEa?=
 =?us-ascii?Q?9rSt3mlFXuOqH6+dc+hc+ezGAQprRc5uIkl/pd1sNB4p2XF1sPdeQv8Gp68B?=
 =?us-ascii?Q?oFHTnoNx/D1+hoePCPr2m36PRq9hYUFG4iA16YCuxevQ1lF6si1DXVxhy01m?=
 =?us-ascii?Q?hhDQMq2F+YuRDmkOC6VmBPneOJl3AIcCGci3RcYTXNf+MHoOl6v34uF6v1yT?=
 =?us-ascii?Q?Joiy282uMQp7ltaFsb8ZVnyphGEjVzP0PohtnXjFMSAWzg5rcyQ9dP4C3Vud?=
 =?us-ascii?Q?u8UiGbhQWXHae1YbCaocFRCOBujSqVDrmZWqY1eVOb8/XxCsQfVsx2D0+t1g?=
 =?us-ascii?Q?49qX2cstE7mwjfVMFeQ1IFNmAgr6V4ALTPd6c2e2xo0zr/y+Q0ezTzUc4scu?=
 =?us-ascii?Q?a8O2wQkulgUIbNgKdlZ/hcW9s2IXIq171lFyyPYRRY9Si+T8NhdPUilXNMdC?=
 =?us-ascii?Q?Pzd5nM1xvvU6zDumQ5tDgPRKRRRe59IN45a+zhJN6OKIPejlBpunDMo1naYy?=
 =?us-ascii?Q?xGjXpfZ+p22Xn6bCT/DOzDy9Tx6qwbLLPxIlWwivqgj+MHeJzN36R/TLGad9?=
 =?us-ascii?Q?LraszfWqOE8KcxGM7ePoNMI2ARcmcNUnjV0UrguRohfcjnHISPFPTjgiP/tM?=
 =?us-ascii?Q?LSG+JVU+pEiYuKWxioTsKfg7Ymx8Hhb6prSUauYx/Kp/W6APz9weaK99k0au?=
 =?us-ascii?Q?mSqLCqbDGWCFjqWt9pPG3hDLu/cLbWcx5+UYDnYBFViEtJONZjRHZqKXL5pU?=
 =?us-ascii?Q?QfQRyIGhH9Z6lO96VZdqJWZK3IIvrbL09sCSrhwxAMHVqKPQiUT/oo34jDzV?=
 =?us-ascii?Q?kbUHHNN3zhFJc4x8WH7yAweTzs1RMmHbo2EnKFEM3r0YLRGC98MeKmj68JU2?=
 =?us-ascii?Q?CZWg0kL78P3/ECkCJqJaO/nwTwrHZg3XKyuBkEA3CE+Bj27FMU4nk8Y4eA4x?=
 =?us-ascii?Q?Q06HZB43GmqptY3yxt9dqEQEDAMjAgKd6SLL4b72kAyCrXa8BbtU1cF9RSw0?=
 =?us-ascii?Q?Wx+KKi9yEWIvsac/70Ds4yAi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e9e5b7-0549-4691-45f1-08d8fc50214c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:36.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEK9YWVlhhbprWm4OAnDTDg/G7XLCd+RAhK/iPGX9a5CR1mjvctw0ALOQRrKxKmijT+CMUy/QE7fftTe8Ek9weOeFueBpDQXuqLlODrYuwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: BRiy7i6jcmIxBMWV0rlDmyzrAQ1ESIWq
X-Proofpoint-GUID: BRiy7i6jcmIxBMWV0rlDmyzrAQ1ESIWq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host
while it drains the card.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi.h       |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index c342defc3f52..ce199a7a16b8 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -284,6 +284,7 @@ struct qedi_ctx {
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
 #define QEDI_IN_SHUTDOWN	7
+#define QEDI_BLOCK_IO		8
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 821225f9beb0..536d6653ef8e 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session *cls_session, uint32_t cid)
 
 void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	iscsi_block_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 void qedi_mark_device_available(struct iscsi_cls_session *cls_session)
 {
-	iscsi_unblock_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi,
@@ -789,6 +799,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
+	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
+		return -EACCES;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
-- 
2.25.1

