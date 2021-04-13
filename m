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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8366AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3CF61242
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348755AbhDMXHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47256 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348739AbhDMXHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMkgul169379;
        Tue, 13 Apr 2021 23:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1e3/v6DvZdELplq+Wgzf8bzd5omWS4+YRI9kqXEZZo4=;
 b=yqvL0GzVqcd+Te6J4RSfNPKdmPfrXXs1n9engiQ/GQHJlVX5k2qjs/olJJ4JZi8+TIba
 a8E6PCXm86HDoseBaDmaA+N25gmbEJ2Yhchf7bzC6wEnX70kXCj05ZV1HBdBv2/tsSyd
 3Y82rbZJKaMLnveFyF67plOtRnbltpvgniSncbtgfnZ741dl8wIdyCSUbaSESmPyu62j
 ViGKFEOAam7NvEiId7heT+zoofNx3KWDdLbt2Mxvr8Ji2SiBWHjgtzSruBmhnzz7vCo8
 gR3XpmaHY4DC/TVGeTVllZ7Y48Ej0cSNF80/aK95x1YrkDkCoR5W958giNGIkWbnT31y RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbgswe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMiLat064242;
        Tue, 13 Apr 2021 23:07:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 37unxxgjba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adHGudDtP9Sj4H2VxKxvo3Gv1k4Tqb3e2NHA/xYWFfxXPmyE+EVeMo5cbITfWCDsa3j+x7sOLLBvRZze3z3tJNdByPSmLquuUaUHp5Q+ME/IBTE0HiyxWJ1rLseTa/Bg+TtmKQR3deHzNFjeZJQUrkGU+gr0YiIzwaeNI9DaLervQuq9EP++9TNBzsKKE6aBZ/f033kYtt9IA9nqixPvRS4BgsskUHtf/cK0WsgSRPjVFHd8uMiVsDru/m8XBF9GjkRTEHFo79CIZhIS10tNqdMnbytip41VXnUjAm2S3j6f9QHlXBD29ZE0YMW7MneJv9Zs8riWTgwIhScDYDtg7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e3/v6DvZdELplq+Wgzf8bzd5omWS4+YRI9kqXEZZo4=;
 b=YaDeD7vIGiYxfBH6rLcqhjtU0ow5a3Vn/m0csQtDNcuia34qQQBWYY6BOXPm+3ekId6fmMWBHXzX2+c8uNdJQeY2G+fmqO8JIoXJELhz524CR+cLx5sUHw0abyhWY1vMzIjH2L7iuARKUY+sjWX5/sEk7hiiT8AKsZO+Qo+kpmhwrRHPBwRqLt1I/1W3jUK7BM/1EK3jtRT5zPQM22nHhjsdmpQnEVhfJCrnm3m2CiXk1moohbslY7AAAG1Cw2CVmH/e0VAoiqUJkq55M73HG7rBLCzY3TZwFIISjlLQq9RnrQaUfIP/iDT/5nexosXNTk7cD/yZ58dNCLKNi/5l8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e3/v6DvZdELplq+Wgzf8bzd5omWS4+YRI9kqXEZZo4=;
 b=F2bUZDgIM/wCp23T3vrNLcQpKBScdrANYuenO0hFIjceCDa02vYaGS0rKbiE22EhJTYphjUKf9CIFNq71sGvES2SSgu0uPIuAcjvqd3k+wjVxmg/OYLGfXtc+lReYfaMQ9zKc26PRQ3rHzwp3cUmjQfR6ggUz/BVAdg7lTLDxVI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 13 Apr
 2021 23:07:07 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/13] scsi: qedi: fix session block/unblock abuse during cleanup
Date:   Tue, 13 Apr 2021 18:06:45 -0500
Message-Id: <20210413230648.5593-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c01484ae-dd79-4aee-e338-08d8fed0dbfb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB365386545EC9F44AD2A68F88F14F9@BYAPR10MB3653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJKNH70wzsWRqBF+PI+p45xzR9+Y4VU4Rxk5OcNqlD8ltBBtpCLqTVknbshla623UQYCim6El2nKsEa9s5d57d0VwE4OdMSkrkN9oIDM1Mz0REeF7UkC00d6vE6g+ycqApCAJVSgpn10Gnx6cQL/JIHoIPcaN+2k4xVX2FDwK4l0mt1LLO2Ry3+0YX+TNk1m4iWoQKaiY3qnNti1u3SaeabhSSsCon4aoc8JU+6aYtRis5hPsZXXMVq0EdPLa4cUFSyUQ4e7ZOIQV12CQC8q0k99ALu7EM9JaSXCLMNh5Q4m9kaZgo4ZVxjclpGMh0PM3ZP8gV3DaA2KBOv0bV/WiQZ77q3xlT0c34Hb2WgU3/MclpSsAyzfbdblbigEz5cWSwEOZkCvmpelJLdQeanWBFbJHXOv8/bklw51K7KYMoZ0BupuWuGGThBAtVZ74dS9Wyf/T5Q3xKJutr4vpw74ffQlt4R4C7oqiT0U94YyZPto28jZyde93yijG0Ia7jHwdr7DbBwUMa2xUPVIh6aUul9Er9bJaWSFJ/2W1te0T2be1e0aXo6CiOGAbcmT1Mj1c3gZYjBzvvLGiDmTK2/zBtzDDHGnJPRFj6tmer6q5nGjpzpJOv/AWPFbgEU9NvWOdWeqCedz9Cu7XH8brDn0M/XLn5xwjUlEy2kOP2P8wX7Z3pr/4C68mf2IbXbsme7V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(83380400001)(16526019)(66556008)(186003)(26005)(6486002)(38100700002)(8936002)(36756003)(8676002)(316002)(38350700002)(66476007)(66946007)(4326008)(6512007)(5660300002)(478600001)(2616005)(1076003)(86362001)(956004)(52116002)(2906002)(6506007)(107886003)(69590400012)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g6M+jvW3MvWB37QPVvyt50efCSl76k00wqsXBA1x3wA2aDzvMbuxERqjgP8R?=
 =?us-ascii?Q?E/5/x+b81syi0WOWQeW0npR23+SmWqdSq3q1k3bfQi2tJLj6OoX9lnqOUq4U?=
 =?us-ascii?Q?gu5Lww3OOMWVhb/w143VMAaSjeZDe500oC6hPZk4RfnO5+WwZhjDRa3yeqZg?=
 =?us-ascii?Q?3SU6qlMIthnjJnFjfxRclx/gooHYIBNrW8neoDxexq+DdHsnQul7suN7oksx?=
 =?us-ascii?Q?OR24wH/ecqPsjGnOTmRfA3ju88I6A0M3SOQcXNkaYgGg8v9TD9np621vqppz?=
 =?us-ascii?Q?2D2TG0u83hX2kmfFJcNrTQmxqGDxJJAmAXK7tPjEj3c8zAJmaLGVA6QEoTuU?=
 =?us-ascii?Q?IX1kZZL/PuNifHiUF6HR1AQiV7BZk41tVlYDvStrRQ2ve+0kNI2mLkEmwSPh?=
 =?us-ascii?Q?ZWtGWOFpSlWaB5PwOov7JaQPs1tqVzLZ0WJDihcHVqY/X5Gd9KE+aHsklyv7?=
 =?us-ascii?Q?Br2K/8QTeVAShT60mCjLMwVMJy7//gMc+fHq6M38zcIglO+pmG8UkRkcKsAT?=
 =?us-ascii?Q?XuwXO34k1JgyrTw8rfz9BgAy8Ffo08qcIYs+0oG9/GJLXi4tpZYdUi2Mov2B?=
 =?us-ascii?Q?bLWQlm9d8LcTYoi44iKOiz7uO5Rm+SpZUYIFoPXIy8ZMywqzmcR7z44Uh9mH?=
 =?us-ascii?Q?hqAQRLNpSK1eMCeZnFtBH+enSwa4oDyk/XXJE1PKJr1+gvKU4tzj3qeJJNUQ?=
 =?us-ascii?Q?T1juevytLjTteAbtS0+oInQGyHYxD/H8ocCLUQRHKLQAtgH5DVvElfTEW8mG?=
 =?us-ascii?Q?SjMyElMrU42ISL6ZH90owvcr6i5h3RhSGbM15Qr9whGlMg0hAK15FBTRk878?=
 =?us-ascii?Q?XlWx+5o58ZlnWqxZCN/3HprK2pUDqK+I4MPAgfDrRFwpBE/Zdo6oGCuOL7Eb?=
 =?us-ascii?Q?f/ixtQEAQeduUE+hEExtPASvPWL+XprgrZ+HjGOx6GoBgc2ufpcRZU9tuzaJ?=
 =?us-ascii?Q?J1GrOKPhE4ipEKH+EOgvae0HWXOtyHgt0du50mri1J/l7ifm8Q4asy8crvTm?=
 =?us-ascii?Q?zzli7Py0898I6pEzFkHkmtwPI6dcFvN4wZ4n/KYQr+I9jkQrDzqXmqzU44S9?=
 =?us-ascii?Q?MC2KXzBhh6MfFb3XAh7tsVBHtCSSvUer9N3fqhbzlfsoleujzPCInzOPI0nk?=
 =?us-ascii?Q?FBdFDsBs+00K8zny97e8vCFFx4qXpWz/XvVnPsWYtfFLiqo984/nvImsDvDT?=
 =?us-ascii?Q?wX2+uRkmd/dkq3AFtR0R3uyhovo0nz14vzuxnU0YCZwPCflj5d/ZjuNd8NJj?=
 =?us-ascii?Q?szlPu+20fXubN56VBnavag5ZgUs75J1nV587HKeA//RCHU0yvf2HzvaiIV/2?=
 =?us-ascii?Q?bVG+v/BEq6jRq1zwNPnCyqqz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01484ae-dd79-4aee-e338-08d8fed0dbfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:07.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgJjJJ+HWWMvmJhHeOKDaL9rtZyBOLb0PFxq0OTBxPH3b7BwI0w4mwfzupo0XifthFOcgZiZf/yY73+RgjwLk80pWGkbspw/VpdPGRj/ojs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
X-Proofpoint-GUID: ZumhTaExEIa7ZtYDbYp_bY9VruCo9CIG
X-Proofpoint-ORIG-GUID: ZumhTaExEIa7ZtYDbYp_bY9VruCo9CIG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host
while it drains the card.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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
index b06ebbb3ed39..9a2d9a29fc01 100644
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

