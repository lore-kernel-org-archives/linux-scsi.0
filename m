Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFBAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 17:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2AB76113E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 17:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhDFRSV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 13:18:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbhDFRSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 13:18:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136HA9at030373;
        Tue, 6 Apr 2021 17:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MJNywcF86Uf2ZHvRPr3gscPj0wjAZMyzdfYQoQB3FSY=;
 b=B5nqLb5cZJ3Is54KZle8lIFKnONluw8kFInDctEmL77rvnu4vvJg20F2Dv3EfZka01WG
 gV3JOCYM37Mr6auL5MaZYRANHP/pP7oa1CjK+vF+RwE+r4YSJAPo38M9xp9lDst/2e0B
 tlRn9MVsjpUGWK/QNKhNiZ+ety0Y6oXdEmtPo7m5+OS4NMS7rwYjqf2/9aNhUgnxQHK/
 5K6pcEmw6v7JR8LsqHtM6BLlQWhtZDTuhtZbA0UhprAVscXA8mmheQE5M/6v0f8cVNpW
 S9AgJDpIIwOiBq8h/VwuqPNSv5wcL4yyx1wSOqsK6VnMyvdCCpql4PBPj7/EzWF/5pon IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37q3bwpajq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 17:17:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136HFEYd039134;
        Tue, 6 Apr 2021 17:17:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 37q2pxt23b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 17:17:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHlTC7PXO6fiMktA4SR5uZhNaJFZXFXRhjn9GW6vZJ+pPjbNrG4l++zY+WonfXAkbLXLH7s/LHfWQ+eh+mIHYG7g++sZnfOSx6fTm03+wWcCaXPTk90rG/L+E0DBD8wXmPqUpeZowcL5YYnRUptWOt9xpvVmqg0lZnxW4TPj5dSMsTND+1RxtTUBTJ0TciVFJEHUEelctCRP2s0I8oYGzadoOnzKxjD+Abfza6D0l433oGYvdExI8E0iUy0St+8k1hAX8XMwyZauesNfsHHJUFKQ98D66JfnFCEi/alvBFmVa8vKKfMHNHBZZmsDOqu4Thbiu6rxiWZPqrJojX1ugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJNywcF86Uf2ZHvRPr3gscPj0wjAZMyzdfYQoQB3FSY=;
 b=ld9npetHwrsfXcvnad34D/6rQnFy0evdTXGyHsgadBgJklDASr/T/BVQOwuSkYKpVJQ/1atBXGE+epER3q9Pwuw9UIFCgIBBOwHynF6ztVitjwuBcBzG9/+9AAN4+UWH8RF1toZfe9Be+Gqq/X193BsmGn3oncvAnnlXs1LG778gu46YC6I5JIji98+MYQUxxUT80cWjz5PluUO6sZc+kZywdA89tqJ83207vmlK1EQMT9ujxc34FzAmzAvodg1TNmXTndFpClFIPIcGIdaAfd4mY0282CVR6QSOphGsTosjzT5oaiuFIurkI9kRwUSnraiQkwLXFfw5MacT5OLmzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJNywcF86Uf2ZHvRPr3gscPj0wjAZMyzdfYQoQB3FSY=;
 b=i9ci36VZOVaUEcCZF4sxerKgYlF8HczC7bKtWIBGtBLeVq19ChqzW/LnhABwG0KP203Jwmwd3WuLXzEcWHMPtOtiprucWlpd3ogHC6AeeB/ah3lbuIhRziaFAWYzVaoRBI1vHmj/Jl7qp3n7OHQ0CpicmMqHgYLt7OJ+SyX2RAg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3062.namprd10.prod.outlook.com (2603:10b6:a03:82::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 6 Apr
 2021 17:17:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 17:17:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: iscsi: fix iscsi cls conn state
Date:   Tue,  6 Apr 2021 12:17:46 -0500
Message-Id: <20210406171746.5016-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::16) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 17:17:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a834c5-3b4a-49a6-3573-08d8f91fea2f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3062:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3062A5247EF332EEBE353ED3F1769@BYAPR10MB3062.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCs7G3yxzNXZSj7eNshprIYoFeDv/auoc9ydT3xyH0EGMazuGpsH/UUh20wXme49X39nIWr47TTo3mYKBWI3aPSWCHrVamIn4nwHqAocCkjE1tEcp6ph3r3uoiVzScE6/OU41gbCUZ/pii++6dIlbdXL2I+aSaIsiao2i556JHbxBzqlCTqD8RBNT6+Yjvr1XY2jJNmKw6LlHQTgzfuDqzUgrCn1zX4Z5uWo0xX+VLD7mmFAeSTKxLFIGrO+tNsMFGRfo9gErF3DJeli94ccYuCWYzBXbj7qzK/HvkGrubvcKxQlff33ieOH0Rpmcejp6IenT545aEqf/HsCKorlNFSmfFRmYGzv81eiPwa2Dc6S54nio1oA2PsbXfof/7tL+Y6WTs3sDb3+yUIS+4buEQGldtCnoTru2On4RVAvoyNRMCAgC+Ot3RKkl7NEXVA/8wEJcPx71ADxQQ0K6QBQurEPxg/amRu1yCpzWBN7UnrNNopnZsRJH35P7ujWgpa7bqHkXcCKqff5KbE0IWpsk0sp1ahS5GCyhKmfZsJwW2W6zoU6OIjUVVxEy70PQRN3Y37K+RZpXhsl5M7NHXSGmAl1aWElqxkpvVdHMtAQLJ4HEu/QCI4ER/JGvlzaTZ/hM1i9+MyRyfADwHW4kW1XdQoHYYvryBhZ8YT8UTV5Zbrs/ohYAHL3oLL2MeIVG7ZcgI6qsTU8xF7wyxXCYBxEouUpAJrjRUve2VGNMSFVo70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(8676002)(5660300002)(6506007)(316002)(86362001)(66946007)(16526019)(38100700001)(4326008)(1076003)(8936002)(66476007)(66556008)(186003)(2906002)(38350700001)(52116002)(6512007)(478600001)(83380400001)(36756003)(69590400012)(107886003)(956004)(2616005)(6666004)(6486002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?34b9s25qoPoH4PGU+5O4IHCJ9tO4qxeVH3kwUp0EMF0B6gx5QNpd1BwGcgkJ?=
 =?us-ascii?Q?9zpLMDqrBxZZ74slk78SJWmM0cr5WfkIxig0y087Sjx1Z03sN4Q2UB2hyoLn?=
 =?us-ascii?Q?zYBtsnLW4SAlx2XK/sEOWl4oBVJktZi9UCwK1dRToCFtadyFkZfJqJFTMyUo?=
 =?us-ascii?Q?J/jTjCSz7X3zB4mOBKemx9goOfUhkjKaol+0Ps12AyrcJZsRYQobhlsAjdoL?=
 =?us-ascii?Q?qO8BPwhO4WHVSSTzGOpGkTfVtgaVZpuS6AmmtCJnJmEoWxgIhrXTP0bi16do?=
 =?us-ascii?Q?PPCj/4HRSKIeH61eBpY/xDm4DJzebrk/w3NanobJol1mdex1VNuzgXG7S15U?=
 =?us-ascii?Q?d4f29gtcDyqkNP269nNmhzq38t97pP/yxynltzRTVxjQOdYxaHAd74KB9uLp?=
 =?us-ascii?Q?mwAeHmx91FxgjGivU+R8pH09lrxtkaRKbUkNyC/jL2NR8xNEp/QMmsmG83ho?=
 =?us-ascii?Q?AkiJbvNx4foYVztZBGxKeCVHtgypiKuJub3kxVMtcu1xkVjz5vaMJgNFBDSk?=
 =?us-ascii?Q?nD/9wF0o+tMGKpqzQJLr6PDgpFiZbMHTZPxZi2Puk67w0k5AukAMK5dHi7i/?=
 =?us-ascii?Q?b8u1ggKOTblLicSsDnwsxAUouPA40EO2h1dueP9ylR/vTxDfBnJCnl/GxUUD?=
 =?us-ascii?Q?ciMESdOJlABXJ3FjYKYD641YyvCw7KTixSysWYtc8pEo0poq8C95CJR1Updd?=
 =?us-ascii?Q?EvPFdZCVb6kETEvRRRObEwN1UNW0Bu8lgZKG2drstJvvMPs9esYRmoUQLejG?=
 =?us-ascii?Q?W5cjU7WZOx7EpiMvI5BiUsVPGGKNubGVSJy3MPJbuA7V4+SIzfQDtboTk3XN?=
 =?us-ascii?Q?4TGq+sb84G3OvFEPbnCEZAr+nK1JaF1AAduxj3sJ2lOTdZxLBTRgvQ7zLCIJ?=
 =?us-ascii?Q?faexE7ET9fbTP4ZuNDQKuWzRkcKOiwTnaMVR+WJj1Xb4hGpq9zvwuBHUWIwz?=
 =?us-ascii?Q?b9IuDI5ORZlFQndcaBhXP1BQLke7S5I9E1bZM/CS3uShNbwNIn62DZuKfUA6?=
 =?us-ascii?Q?ufRGSf5HfvPIUR3tHxomtbXeA+Ralbewkql/8KtO/Yg+HoibW7EYK3KD5t2s?=
 =?us-ascii?Q?lhw50ADpLnGeXdHMYkpoZk7O5TAX1K+NSXdZCHHWvmPI/wQyUQyp22pK8Jmf?=
 =?us-ascii?Q?C0yYlFtSWt1yjerKBLfn1KJTFb+0ZIp0IanPk7G4Ae5sqwnDnp/icSU+zetE?=
 =?us-ascii?Q?Tn6FcBnMg6eekY/0LiyiEjbdwfnEbKiovxWYX2uvpMo8+97mNI0NBRjumYZs?=
 =?us-ascii?Q?d9yZb0e4A+/uo2jm8OWe2C49uFSgmPocuDxIMm+zWyErztEOw+Yymdva5BpL?=
 =?us-ascii?Q?AJOh/U+r/E8+B5OPYk9CE0Ui?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a834c5-3b4a-49a6-3573-08d8f91fea2f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 17:17:54.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wH0Cj1DyINDHKC+tJfSmXxvmjmmDN8nsXcmMBC1bm3focjHwlWP4qomYzkqEoZvsEQd8HkREct556SPr8O9fuQ+QJD09IajYSKMdk0M1Lt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3062
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060117
X-Proofpoint-GUID: XlwjhQtcSAvL98EPFzP5jNnpvsplieA6
X-Proofpoint-ORIG-GUID: XlwjhQtcSAvL98EPFzP5jNnpvsplieA6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login
and sync thread") I missed that libiscsi was now setting the iscsi class
state, and that patch ended up resetting the state during conn stoppage
and using the wrong state value during ep_disconnect. This patch moves
the setting of the class state to the class module and then fixes the two
issues above.

Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and sync thread")
Cc: Gulam Mohamed <gulam.mohamed@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             | 26 +++-----------------------
 drivers/scsi/scsi_transport_iscsi.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..4834219497ee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3179,9 +3179,10 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 	}
 }
 
-static void iscsi_start_session_recovery(struct iscsi_session *session,
-					 struct iscsi_conn *conn, int flag)
+void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
 	int old_stop_stage;
 
 	mutex_lock(&session->eh_mutex);
@@ -3239,27 +3240,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
-
-void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		cls_conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		cls_conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid stop flag %d\n", flag);
-		return;
-	}
-
-	iscsi_start_session_recovery(session, conn, flag);
-}
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4bf62b007a0..441f0152193f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2474,10 +2474,22 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 * it works.
 	 */
 	mutex_lock(&conn_mutex);
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn,
+				      "invalid stop flag %d\n", flag);
+		goto unlock;
+	}
+
 	conn->transport->stop_conn(conn, flag);
-	conn->state = ISCSI_CONN_DOWN;
+unlock:
 	mutex_unlock(&conn_mutex);
-
 }
 
 static void stop_conn_work_fn(struct work_struct *work)
@@ -2968,7 +2980,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_DOWN;
+		conn->state = ISCSI_CONN_FAILED;
 	}
 
 	transport->ep_disconnect(ep);
-- 
2.25.1

