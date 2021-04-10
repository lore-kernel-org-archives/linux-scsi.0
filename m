Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30755C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 068BA610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhDJSlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbhDJSlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIWvmr062886;
        Sat, 10 Apr 2021 18:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ISn7D1tnp+l+n9AyUewEqsxwOqlBE2LpAyd/Vn0A4mQ=;
 b=fIPFeDXqr0BDkpYoVA8lMD5NISKrvmuXB+Pp4MWT4DUDBBPrLHmF+Ozwo2yxxSg8c7HH
 06OfoojdwRyZG+JHBg/55ZNCLrka+PlgpHpc4x/fFZZBw+G9yigIZchKV9Mfr1099+6P
 z47IJpgAlEaWnhQHMdvPbjst2kZUd15o4+qGAOvj9+/clLXotZSC7xNsHu9kuHcRdytN
 m2jokInI8rY5NJHjuCF4ZbbjGzNeTgWkc6Fc1XpkKefVo/0LjttiwekW0aQnYNv9fsaL
 i2s9oxrBU6jYkk9mQll1mymQ4fJzr5upSXwwOvGDRqglJVPKHFWo4Ar/OIP0OnYdOdQG Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er8stp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThid176766;
        Sat, 10 Apr 2021 18:40:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4dr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am0rXoSPyPSLsGx0cDxM4PXuiLwP9YE/5/HKpBxivKULbQhQTdoRyiTBsaGrlv+CjIAyM2XJIuj8yvYibvfpsmU0F9kM21lniP88BTTpCnQlKc0uXNWD724RW8VV8jGE4pgyDzMYtMVGYhLTlQEdj8Hx5hBDFGNXIjGz9L+kDyaPehcIrBy0aXGnW4+lai3nys/mdmxC9rtkQE3wgxg/7y/xcUolQ5mP7zoGaYpwtUIj7bFTbkjg3jJAvYlDsPu3Z56wTTtAB8D3lcFx0Re4f5HKkpK9AlvZw3If1OqkiNEl4MTFhiYx2JgpScnrj6XKr2q4VgSXD6RJXKPG3xm++A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISn7D1tnp+l+n9AyUewEqsxwOqlBE2LpAyd/Vn0A4mQ=;
 b=aBoyw5EpbWngGgGxnh/miSYJ13oQBASIL5iNZXDhUnwPayUBabWLpolLgxmvTsd8X5HkL0BJ2RGNpOwAG6arN8sBmls3UVOcZGww3Ptd88t/pk4SSEbwzAdC6/DLYpBOA8zl+gx+lSbcW1XOAQULrSh/CiwASdO424caCNhfMde8YacIz304MCWqIwWlAFUKugJFuUCPEr6TqgWhcZUAtXdI1r1/K01HSqcZwgOcqwCmoSwgq1kvjyqFxPS49weTn4IsFT5y9LVjFy4EsQtXoJnhuRdnKLs3mhnJTj29d3bmz3jb+r8gRb3Fcz9e35BkHt8o54U15Qk0HDlxx5fAHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISn7D1tnp+l+n9AyUewEqsxwOqlBE2LpAyd/Vn0A4mQ=;
 b=goXffA8HRKkywNMuU+780/J49ygYFPW/oilsvs8IS5eGzfkjz/iYWHsQ05dVu8xG4FKh6Q/dpQtt/RD4UcbT5ufm9u/zr4yXCbF8GPNkOW3X6k/jDuXKsCzKinGZj26VfhbJ7kaXDMFz34fTGcr2ESjC1s+jpqbjz7iNKLj59Hg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:34 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/13] scsi: iscsi: fix lun/target reset cmd cleanup handling
Date:   Sat, 10 Apr 2021 13:40:11 -0500
Message-Id: <20210410184016.21603-9-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b14394cb-a264-4ffa-859b-08d8fc502021
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB432430DE84ABB3EDD2756E26F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uSnv9b9TlQcR6ffe1sIzJD4J2fz4QHj60I+9YcDbLuGsXgE4yO8OSQWtcFwBZ2JLQWAdWpj14Nyk7VdjAlWs7j5lYen9RKlD9MzQdH/aPiQcSpoJIPZ4qFMnyWG6gAYbpYVwvsC7PReVWPgF/YGf6ryHN7X4TJNpmRtLRKmEYrNoJefu4apdbN0OeUj3JP0AfioSpKq8aX267N2EAYF0Yiyz1GV6T26/bYdUE/l3u8JHRGj6o+t511Lq6gW7t0b0f2ywy6jBuyqUx3qxfgDfqmkHY6o8qFQDFRZpdd62ssI37DeJpcN6db4YE1kRwbpCaYoOmsuEyDMPVzj15r52VFKetQBkyxzTkDBybjzmG8kmfsoKOh94f3+hGSLAtEgj5OKEIYo8I8IaJFt5Vqvou/f6gOV/k/LWX2apQxgaCK8H4+p7yHpUgO/eRZm/cEJ2gkrH+j3Zp0fC7YjiqUPVleOanAcxsf6ioqJ18nBwYj0a/QdnOVh6lFZoc7SQLLwu3MI0gLcEEiZvt2BYBkZuhgYYS2snnQC2cTnhXogIHXdlOaUHd1vRwsi/2oG8NV7qiH/spwJua5SyaSpNvyKRKxPMipKc6G6rGshVOOUaMLKLdMTP4rGNVIsI7fWqtsw0DQoRpJT4PWjiw1hHhB95gWEpTlfy6dYqBlJs2jjZL8LF2W0iYOWGjUx70KaQfalb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IUHuhZbFUQC2RtoRbpk2s0988QECdL4WW0R4MnEygxmudjRM2h7OZN13ZTrZ?=
 =?us-ascii?Q?0NI0fCRbZz47C+WuoH6kcCImNvj+9hpREesHyjh+Vx5nsV1WulR5ZUh3Rr9A?=
 =?us-ascii?Q?Xi5vip7wRjPyDExhT6YMycwOqX5iP2FWPuY1Pl3akYTxT2Tc0YUY/iHmrIdj?=
 =?us-ascii?Q?tDz7Wb4cMYbDQ2OzRkiWpBuqRj5BZGnrsRyxG3izQbyDdM4i3+gYeVQ/ltBM?=
 =?us-ascii?Q?3A8GNCMMTMmtSbL5csBXQpjrxINFkix8pzwhc1EVAiQdQoxJdOxU0hd15rvV?=
 =?us-ascii?Q?jXWRp+VW1zVfMnln4lnCLzvZ8izAOg9pNIr+P80B+tqNiuwQBB3oEMUtF5gF?=
 =?us-ascii?Q?oobeElDvyzpWeptQPeyxfr0Qbp7+4yB6JrfWdpsSvIfetJjJLaeV2/1imWTm?=
 =?us-ascii?Q?kXnCYRKMCbqFkDM6XYSZLIdeDIDnRmyBHWHX/kEQsRfpyzM/X2LiQ53zl51p?=
 =?us-ascii?Q?e5hG+pSrbySf9EE2sLMjFtzOpfmgnjogjtTsWGZ9KpQBmKGFWfk+FodCLC+N?=
 =?us-ascii?Q?mJbo9x28KieLfz2/SYzTFkc2I+L7QZWJ2CkbBqCivdHdcvcXSxNrN3QfPAt0?=
 =?us-ascii?Q?OlwOgGGFfWUbX9e7ilUqneRj3o0dF70WCcCxnNeNqjBfla2uFXb7TiXHjDjX?=
 =?us-ascii?Q?3g5IjyAxdjpA0D1JIQJ8V61CnDsWBFjAZffHe7a8uDKdTpi5L63XYHPviN5H?=
 =?us-ascii?Q?kO3IOovVLG5MCk/bJ5Fb0XEawz/THFw2liaSEGe02J3ecQSCjY7USPXSBhzy?=
 =?us-ascii?Q?35Fe3tnUJ8HKwnOA64/wf3T2V67GI7tJoq+4CwQDbU4Ubydohdk78Yskbqk5?=
 =?us-ascii?Q?w6ujtLAd91LXpY/juf4HtmL5i+2doKDqN82c+l4obartSMmloZdtyiKxVoJg?=
 =?us-ascii?Q?U9NKnVGP11hthiAH58rRi651yH5LXSIkPUAhKavD+sT/uv1Ve+V9++SZtiPP?=
 =?us-ascii?Q?LSQPywF1MoHWCJsYeI8PYmY9UYzkojraA8kseoEBrTxXDTNvBhezMQSCWCyR?=
 =?us-ascii?Q?Y+LGq0kVXTyzK2c+GfHy5W1P+Oa66UX1I8D/c+qgirut3JuXruhkQhTvZx67?=
 =?us-ascii?Q?Z3DtrWuaKIEOGuvey72ikwpBbEPrLXR37z9AilE4B7XJXRNKWwc07pcTKZ+i?=
 =?us-ascii?Q?pV6VPARZLCKzUgmMMCgcRulOmasoMYKQApn3AtFfBqViCk0uexmh43hD2gTW?=
 =?us-ascii?Q?clblF7MHDzORN76PzTWeKV7u5OyaUtryZyL9f0rUdBG6ZXn7nGE9DUsWkVbH?=
 =?us-ascii?Q?2gn4QYl9/f5OHn/Rk7uCEESNRfJ2GoYh6ZTRDAuDPygibPcFGRbZZK+DCdlU?=
 =?us-ascii?Q?Y3yfbv8z+za6wszt1ZQyVu1Z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14394cb-a264-4ffa-859b-08d8fc502021
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:34.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Hy2L3shB20mqIjlOcvW/ePoHGFlzErik/1tRFNMh08lYxue8R9AzcSY7xK3/VCE2E9yCRatT+0QKcJlA7rH9Sm45AJag9cYCmJ22F9K+6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: KMRjVygtAVY6HGbmxtEzsF2JcmfNKImS
X-Proofpoint-GUID: KMRjVygtAVY6HGbmxtEzsF2JcmfNKImS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we are handling a sg io reset new cmds can be queued to the driver
while we are executing the reset. If the TMF completes ok, then when
we cleanup the running tasks the driver and libiscsi might disagree
on what commands were running, and one layer might cleanup cmds the
other didn't. This has us block our queuecommand while we process
the reset, so both layers know what cmds are running.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..c68afcca51a0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1922,12 +1922,11 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
  * iscsi_suspend_queue - suspend iscsi_queuecommand
  * @conn: iscsi conn to stop queueing IO on
  *
- * This grabs the session frwd_lock to make sure no one is in
- * xmit_task/queuecommand, and then sets suspend to prevent
- * new commands from being queued. This only needs to be called
- * by offload drivers that need to sync a path like ep disconnect
- * with the iscsi_queuecommand/xmit_task. To start IO again libiscsi
- * will call iscsi_start_tx and iscsi_unblock_session when in FFP.
+ * This grabs the session frwd_lock to make sure no one is in queuecommand, and
+ * then sets suspend to prevent new commands from being queued. This only needs
+ * to be called by libiscsi or offload drivers that need to sync a path like
+ * ep disconnect with the iscsi_queuecommand. To start IO again libiscsi will
+ * call iscsi_start_tx and/or iscsi_unblock_session when in FFP.
  */
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
@@ -2365,6 +2364,13 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	if (conn->tmf_state != TMF_INITIAL)
 		goto unlock;
 	conn->tmf_state = TMF_QUEUED;
+	/*
+	 * For sg based ioctls stop IO so we can sync up with the drivers
+	 * on what commands need to be cleaned up. If this function fails
+	 * we can leave suspended since the session will be droppped or
+	 * has already dropped.
+	 */
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 
 	hdr = &conn->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
@@ -2384,6 +2390,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		goto done;
 	default:
 		conn->tmf_state = TMF_INITIAL;
+		iscsi_start_tx(conn);
 		goto unlock;
 	}
 
@@ -2528,6 +2535,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	if (conn->tmf_state != TMF_INITIAL)
 		goto unlock;
 	conn->tmf_state = TMF_QUEUED;
+	/*
+	 * For sg based ioctls stop IO so we can sync up with the drivers
+	 * on what commands need to be cleaned up. If this function fails
+	 * we can leave suspended since the session will be droppped or
+	 * has already dropped.
+	 */
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 
 	hdr = &conn->tmhdr;
 	iscsi_prep_tgt_reset_pdu(sc, hdr);
@@ -2547,6 +2561,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		goto done;
 	default:
 		conn->tmf_state = TMF_INITIAL;
+		iscsi_start_tx(conn);
 		goto unlock;
 	}
 
-- 
2.25.1

