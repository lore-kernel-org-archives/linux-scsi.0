Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D9AC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07644611BF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhDXWHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbhDXWHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Y8t151690;
        Sat, 24 Apr 2021 22:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=GDkkzTtxytpZ6zgGq7anNQ6wwOwUostgnsTvjKVgibw=;
 b=uBYn1pPAJUhelTwDV4PWY/hNYsEKA8pXmtkM7WoA4MYtH8ISVU2ZFYGX0tu/kqPnJBrA
 zAm9Vk7ccFMjWc1GmVifWkcJzxE3BQXgg0sE7fcBYT59DiaznpQ4PTIa8DH/mn6FY7+h
 fKHqYY9Ck23DclMeNCzh256X5AYpjHmqCtjtWaAY+SOgykK6MbatzIF8+V/vAJKELN82
 WjtRuto25lMld2PkUkTKVk6MKG1cweQIri02EQ6a0E94NdOfbabYSEyAigM698X3fh4J
 Ntqf45YvCCC++YWCNXYhKFs73Jctq9lN/PurPiyAKPbj+hmzA57oXhJ5TzHRJCdeFkVw Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 384ars0t16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM655K182233;
        Sat, 24 Apr 2021 22:06:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3849cakfvq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPq6wZzd92CGIk3HxUtbr3Sf1fRN7XdsyrUXVcWG4L3zzaVZZStcD/vj7UTeA5j8FmUFBEsz8yIo4S+V79GMYryoSFEqGpRL33ATaDcWk8VMvGtO2cuC3KoBuZKgQ9H96bweZYoUZ00dEE1JV7dNciGnK000ijhK+9UsEMlpH7hIWqg6/BrapUNnjcqf9I4Y1jjyeui3yJNrLvtKxV2PXpqBixhBvvFcdGfMtL/V19JF/IMC3Fjp+Ihh1IGNHXj62bZ7IcPIYF/pUZx59yrvHBCj1JGbuKt4wJXMQvAS0yAB2Wm3I8t/WUC1ibwvp5JTMFFdPW4ca4F6daqk5eqozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDkkzTtxytpZ6zgGq7anNQ6wwOwUostgnsTvjKVgibw=;
 b=RkYVzeQI2o/UIKftdCiXoPwTQsoLH4vHWpPgwci4s7sBP2BsqrC/2wkmCipRp5tIOkEFrjEaqh8JgCHJFRLoZC/8Dizc3XswuBviZnxJ/RU4wMdZANwpOWAU+ojV0bM/B58+0Hkg8ynZlFUpQjLPFTL4iT3XZwzkolDqo8HeY6QXtk+FiLbdyIMAiD73KBmvh2j2vsCegRmv7hPZNkW1GuocwD9xSl1q59fRlEVfy2majrreYFd9Va5ugvVFuMIndHLOapXgJa0FkMNoOX8cYU692dfd41MN4lf9/PX8xXwFXwYqRUdaA2HwOhisOR5Tnz8sp1yX413XEEZkTM6ZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDkkzTtxytpZ6zgGq7anNQ6wwOwUostgnsTvjKVgibw=;
 b=p3NoU0L+UQQ4niP2muRS9QrKw2wnMrT/KPT6iZD1EYeojfwPI7raFx5mMHUZWedn4MiEnTaWHzef2gD5LDVojMR56LVqNNb92T3JFijc8VDmXh8ju+OYxwuHCmiv6OXWVr/tlhT48DOFENt2Oz+IrvxNnTALA6y5UvV/7a8ZLl8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4493.namprd10.prod.outlook.com (2603:10b6:a03:2dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sat, 24 Apr
 2021 22:06:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 17/17] scsi: qedi: always wake up if cmd_cleanup_req is set
Date:   Sat, 24 Apr 2021 17:06:03 -0500
Message-Id: <20210424220603.123703-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44a145b4-e28d-4f1c-b3fd-08d9076d372e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4493423997B731BEE3ABAB88F1449@SJ0PR10MB4493.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDsSoQTh+pe77J58Z8qxboNyUufzpfTfwfhqO1gqTPaQEw4mTdtMt7GfvxHWA57bhDQJ3U/R1Ie4qLB1QmCrj0ouYGUBjhtryvmL74+8+NhiyjYgJwDA1grNLUKSCmepbvvrXZnD8Mn031GzI3fApKJ+nM6jX2VFPdhlMjKt0lsCdJP+FpZd5Yg+erZSi5mySN05wuY202Igr5emYtW6ws8af1uP5oL0A3uF2/ViAPV102Qm13Dsg9ZQHUUbsPClb8/AsuZKJuP9YvwB+R/qMXwvdJnGfQRR84gv6O+28kSuO2Hg2hs/y3LUMzymtPClKqA0DRg3GrpN7PBfg+lYIcNAXs3RFAw4QoLWXnunPYfXVC50EFVlOd9Lt5YtN7nzrRTGkA4Frog4zY2+KOecRQpXjdqfrM7eMaFSEd/aoj+I1kFv+bs1hvQNKvvFwI6t+EKPHlzDT4qkJJ+a0XmHwM1M1V5qGo6u1tQKVVnud9x8biCYGGeT4B/4kRlCL8SzRm6ZLlACclOAVO5uAFsW76vM/Wt13eS/ArwbgtuWFefCulAPnATTYRalN849ABMY6REY/3GNvbM+9YmpNonwx5/PxF30zhfl9ywUWIwOpBG2FZCvB8Vz8t6ey6QB6vtpi5gi3/SBfb+8dfHybNJYzuGTvMReSEa6PFcx9nhlnYI+bVBmqZSxeccx8rKlY5S4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(316002)(8676002)(16526019)(66556008)(66946007)(5660300002)(66476007)(186003)(26005)(36756003)(8936002)(52116002)(1076003)(38100700002)(956004)(2616005)(83380400001)(107886003)(2906002)(6666004)(6506007)(6486002)(6512007)(478600001)(4326008)(86362001)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bCo2qZq8sD7DcrvT8tPcJGbwWWcsqVYpucakgs8dwvxRB3KpT/n8KsQL4yHZ?=
 =?us-ascii?Q?A5ErhIW/cynahc+gkd9dw2vXxX3d8kd6eRPkYeboc7gZsk+Hywhm1pdZXELF?=
 =?us-ascii?Q?rOqcasm0SNgbZyJCNx1D5Ck56sXBZY93RayLCWWmyFY6Dz1FL67aitT8Jvag?=
 =?us-ascii?Q?v7RnJxMIUwKA6McA+qPr068E5MuGEmpe9YCZl9YDcHiN6fvj8trOTn5e1c2K?=
 =?us-ascii?Q?kIsfho8PbJLhV+V74vAycbzg7CLitSccop9k1S6JvSwUBLTA+goHYHfjIz3+?=
 =?us-ascii?Q?exNhxIa8IVyIQTtALsErLOabCrtooXwPxMlTGn0D52sCdkYjrRybwY71TFOh?=
 =?us-ascii?Q?JsOiC7Sy3Efv6hrX2NFtNYkbThRe8FotF0CIZhpTDKYJh3A7v66lE8UWNpS+?=
 =?us-ascii?Q?877eN5vlkIV/GkjayL1m1xP216/bZY+6N1UFgPa9uZuuP4zfRQU/ZaWRW9aR?=
 =?us-ascii?Q?RXZIciujzBgk4kH13rqkOk7bIRFgeBwFPevitmQhOWqw7JsfirhXEFXyQBYn?=
 =?us-ascii?Q?765XpTWDyvVjwokt3j2V4BLGNCoxv+erd12cx1R7zp7cJsfzuXBY/D3UJpuP?=
 =?us-ascii?Q?sE8+pn8T3sTdN1BEm6Qah6PIe7QJYRqtGh0j7y972NCsUlFZDzrl8nOKIdYo?=
 =?us-ascii?Q?xntJZ3HDcKDxcXqXZuO2ykGw+8PwqfGEunHZ/OXddJ9pZmeZNpKEqIW5mCF7?=
 =?us-ascii?Q?V2/obCTVvShdD0tYWzQ2rt8fLuL7Z9gw+1594iNMUWkH5FPPOlNhOpOERio2?=
 =?us-ascii?Q?WSWk7pTv1xwaUkI7gicsiPzot+h8dyEwNYvrfbFOkmlFzthEDtvpRtKeO3D8?=
 =?us-ascii?Q?ovtfd7AMur+ZIFuAI6IDyctUy7d+2iIbKy8ImMpfnGM41yfEiUU2z/kwslSZ?=
 =?us-ascii?Q?Wp2aOazS2YEQ9rzMaeCDzio1voyUBed2ZnHsWpOEGSNMqMsWJxIHIMSjt7MD?=
 =?us-ascii?Q?QtV42FqkYHVYKP0Fk0Tl7wwKnppQkNssY08pbTLtCTUdvIzqW/uoBkLLaOoY?=
 =?us-ascii?Q?BkSg1ZvvW6VBSndZRWjRD7WxIYUFDlCSL3UZeuJeASbZTWxbWn+peeiVxOqX?=
 =?us-ascii?Q?SXdNepvRmtq4nqoRoZgX4+Ao40AAyUK44U4lGm1UmFyjf0bz9b86CzNawM3k?=
 =?us-ascii?Q?CF/Moot16KHyjAPhaYgFoKZFh/p8aCPwP+EtE3wsGyHUBkEss/cO7A/8frC+?=
 =?us-ascii?Q?gzJA9/gaSnwbWkd7iEBW9XPXdRcE9+rdicojm0pKYCHNdwgwn75SUAPLcsOA?=
 =?us-ascii?Q?QA06VhwDG/StGSGLdWI1beBRx49zWc/rfSuNGc1kFme5YZKhWSJS3v3szUav?=
 =?us-ascii?Q?E0kuLdBRWscpcUHrQ8I8npP+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a145b4-e28d-4f1c-b3fd-08d9076d372e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:31.0152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dD/V9RzCDnHau9KwYImx6CsVTagvjAPyq7IIuzD65V5E7JXskasTPNWllRAY9F1oEqdGwXroJhk7Xl/Yxf3u8ys2rxeUhHc9UzwuU24K5J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4493
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: RuHNvYqLgvyxp-Kj9DMYeWHuCbtuzcf6
X-Proofpoint-GUID: RuHNvYqLgvyxp-Kj9DMYeWHuCbtuzcf6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we got a response then we should always wake up the conn. For both
the cmd_cleanup_req == 0 or cmd_cleanup_req > 0, we shouldn't dig into
iscsi_itt_to_task because we don't know what the upper layers are doing.

We can also remove the qedi_clear_task_idx call here because once we
signal success libiscsi will loop over the affected commands and end
up calling the cleanup_task callout which will release it.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 03feabcefc7d..37547618743e 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -739,7 +739,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 {
 	struct qedi_work_map *work, *work_tmp;
 	u32 proto_itt = cqe->itid;
-	u32 ptmp_itt = 0;
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
@@ -821,37 +820,15 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 check_cleanup_reqs:
 	if (qedi_conn->cmd_cleanup_req > 0) {
-		spin_lock_bh(&conn->session->back_lock);
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
-			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
-			  qedi_conn->iscsi_conn_id);
-
-		spin_unlock_bh(&conn->session->back_lock);
-		if (!task) {
-			QEDI_NOTICE(&qedi->dbg_ctx,
-				    "task is null, itid=0x%x, cid=0x%x\n",
-				    cqe->itid, qedi_conn->iscsi_conn_id);
-			return;
-		}
-		qedi_conn->cmd_cleanup_cmpl++;
-		wake_up(&qedi_conn->wait_queue);
-
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
-
+		qedi_conn->cmd_cleanup_cmpl++;
+		wake_up(&qedi_conn->wait_queue);
 	} else {
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
 		QEDI_ERR(&qedi->dbg_ctx,
-			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
-			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
+			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x\n",
+			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
 	}
 }
 
-- 
2.25.1

