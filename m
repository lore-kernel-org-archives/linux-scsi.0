Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6348CC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3253F6115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhDPCFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46244 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbhDPCFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoYn179298;
        Fri, 16 Apr 2021 02:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=jKHV5eVxay1vbyt1mAjUPNcYZpTup5LTF/24Q2CMtRY=;
 b=xfjCi2OFescXWhGq1oxRrfjtNIU7ZBByyd5L5J/5pkJwVFdMfhabblK+eOWmOIR1ll6i
 4URKUQQCGq7Fif035mHPniD+7jPrv/vO51JHxiBIcPbK8UuRAN4svoOwHeazuQGuBLDs
 E825mvh+XI6gF6FxGOYt/VQAyrxKRc/dazDz76jr3nXWlLBoHswZjZ++dESYPWfmW+0p
 iOHz0nmbGM6DR94FmgFG1tDBZPFhuYwceM1D5nE8pPuNqwEwPRIS5tpYBcdWqtPSu8Vk
 JwJ+ZzBLAgDQVzfrTjEmiVYkChjSCGfQsA8CoLiissu1vyjjJ3wpA+Oo7MN6BOJKpjsP Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbqsby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoQx008624;
        Fri, 16 Apr 2021 02:05:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 37unx3snyv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCZJYrZS3DBEUGTNB0jAMt+IQJPzil04NwImDeo1pbQ24ptgEn8ChzyfOJoVU9OXFvpX1cl5WCWLlFx1T+pQHUUfCwdxaL9d4OA1ZuOMDJtqTwGDUuWY2IqrMJKe1EYgvPsCd75ixBUpsVsN3BLe3Ucj0vQuwZXNU69QR/+b2M+nvYUzxThuF7A6LkGORFHkKGR8yZEDeEM6EVgTqDSS/LSz4HTVQI7Nv0AdyNkkickhL935oopjKEideZQhcgfcKgem4b65+I7o/pBQIHT6SiT6Dcixmm5Z/NbnzHUnY69qpmPva4jvwt504kby2EMyrAPGfDXuCbBwhh6uuu7xpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKHV5eVxay1vbyt1mAjUPNcYZpTup5LTF/24Q2CMtRY=;
 b=Kt8rowt6AEqPDHXdD3s8XFnatqRc1OQnmZBb5cJDZpVe8PJFlmLKp8db+qWhDakgHx0Bn1Ff29F0Fv7knuHuELiJE3VPCBT7tb4M0J9Rny2K/pR81OVh6wRH16b1I1yUJYnvvVbJD9/4iQzeBzAykMoMgxf0qeplNertp28lOA6hsCAaB3rKO8ejgnIoUo4EhX3sc1r1UfVstypw7z7BorombanGiVFckXOusmCIMPd8DmPSuCVvbqFPEf3oTE5uIGYbQd9TCSMibY3BbsYv5BUXjtP8LVPgas3mvDSkH0XfxV2CJ+1Yz8XaLr7/Gvt9GNnR6QgmdtTQeshFw+viKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKHV5eVxay1vbyt1mAjUPNcYZpTup5LTF/24Q2CMtRY=;
 b=ZISIhOceug6QOz88ZRfNM9y0f6chfUZIZ/O0qCrMNWxt9EmxNJgK/AnmmjF2rWhisl8i4/oTRjIR+xDKiNZ1kwbNOyQ2JKkCvxxJi3S0dbrsNo0fKoATatGCuTA8zAHMckt8l+x7rgO+h1A+HO0VceXMbv52dznY36ENzGfrnYA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:05:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 10/17] scsi: qedi: fix use after free during abort cleanup
Date:   Thu, 15 Apr 2021 21:04:33 -0500
Message-Id: <20210416020440.259271-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eee421e0-73a6-4d09-ca86-08d9007c0a43
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421FFB1BD5A41C699BD2759F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0X/JgcyJ6N4u5y2Sr9ED0YtC5jVGAVKrTS5Nb2aFUcyJsbNlOKjIPxhuf4nl2VjJmxXICMkWI+w4dRXoXXK2SxOxMIrudRYPMsel7Xz+1kaVIEjGJ4k5F5nBxEYQrBOPP+Kqu3CrC6sxIPZk6sx813K+XGUjToV1T4C5y+V3HNuZN8A2oQ+M/379pfK/DmfNhm8mccM4ihiD7ELPwOVexnVPtFsWMv1tVW1tW8ERjl0r7wp3OX5QYeCWU8lUYFZtLTjDDI50TPOa43trZ6+Xm+VzoGbcVBji5Mgd2Uc3N1Z40KIUSboEvbNby8WTxsmYTnwnQ7JyS5WpbZ25S80MviLtNtFDqSfA5RQNhAfMbqkEIo/YCLosxwGXSkEth8y277Trk+tJ3b+g6bYbXMv51gp/Sq/seoMX5FjqlHrISxRhf3npvc7wJnwWMi6laLK8/Tz23TwkLR7oVbiTXagAsEhxLlZCscltNakEKBOJs0c/vVhpxP0UqNXbSH8fiBrtCJx2LOB33lU3VLMph4ezGdZkhOVhgddeG8PmTWf06T2sQtrkMtQVcG1YEol7QKAcW9kMj6ZGivpTW5agmTE7Ac3Nccxld0xzXM8ft5Mox285nDoThAY4WPIgjx2lU+89bLaPLdtkHy9I3gEFYZE9XHdyEKOoHd3m+UKljnbfPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+7ORy1bL8EoC6swL0rTTnBcy8AdjQcd9oarqL3XV7aHYubg4M5b3s/01HB9a?=
 =?us-ascii?Q?Gfw8UNAFUN47BhBNZLTjNFnP0qC+lRidlagGeLuNFjAVwgTPp1mDrglZXLMP?=
 =?us-ascii?Q?yDkiBEGFSBFdIa5jiNe3ha321qECk5PH5efyU+NqNnB2UlYhI9qXx0l2p7Mi?=
 =?us-ascii?Q?caZg+mjw9OEp8e0kKOSge/7+zGQbevd1GReldJ8OUZyC6tsZhGx7UWj9Z5HL?=
 =?us-ascii?Q?KjYP6S7Yx1DuIPC/W6Bt/6p9s0ohiJdTUKuUx00x/de2hH6rBlQTCPvJXB1O?=
 =?us-ascii?Q?W3r1utP732CdjVDpZ51urh1rE4ajeAcXFv5T2JcbOJfBuhTvHTH5xqzx5JFR?=
 =?us-ascii?Q?ctK2+6d2Ay2x1qgwqy804Fj6q1KmdjOP9TOQmS8o7ZY1p6ZA441vfIJb+rl9?=
 =?us-ascii?Q?Rk3o8BVI9b6J4727SUPW5FawVQyPsDhzZikurDYvP0jLewm+M9DQy09ZHlb7?=
 =?us-ascii?Q?QBN1+MUUCBXKCGa3clO9Tw6t0BwpdPjvB0RZ86nN45goamvv+F5ERFum/hbc?=
 =?us-ascii?Q?cD9yfAX5a6EiVrI1N8+U93qqSoiw3epTLs8KlyVEk6D/sUwZizUqUFL/mqLX?=
 =?us-ascii?Q?efIf0L+2Vhn04JKmSPKn1bQOvSq1tMZFwsT1XzjQ5cKBlgaaF5QNBBQA1dxg?=
 =?us-ascii?Q?gs4+9M9MUh6H6B+wKeW+ZDWLFz69RB06PBpSJaUGWAzlPF8c8fubbEDf+ZIW?=
 =?us-ascii?Q?PfMY+iV9ZvIMZMWv0F3V/XAWkUhFyqLHKiMU0MtU664nPNgCSoyuLWlxX8bk?=
 =?us-ascii?Q?/4izOL2MTGsKmt6enaVl003huxW2ezs6kis0bYMkLCLuml2qGd/N9TXDF3mD?=
 =?us-ascii?Q?mBUJdezvKhPeNdAoa53ttkP3LX40QOznSMln4M+SI5I7M4I+k/vkHzItDNEb?=
 =?us-ascii?Q?7wTwbpzwmcHYdWK/oQRNpdfx+9lKNXFaMt5YixeS/8r4vN2d3OXsHS1UTiI2?=
 =?us-ascii?Q?IitDvcouRK4p3yAaWKYpTsLlulCI1iOFOnSOmqou5t3v6RF60OEE18REXZnQ?=
 =?us-ascii?Q?o8pZUqmX9NHFPIkMVr0vzcW5pPNviqWRmnvRnNLldAtDizmPwcRJCHIWPiSd?=
 =?us-ascii?Q?66+sNuOLa44uOFlfdEr63I1qkDA795XvYwqh+9xuq8mobLfNpOihMmwBDN1I?=
 =?us-ascii?Q?2es0tx9yUQTr/LMrT/UeALniWqtc+XsvW+UJnOVCp0wv4nIP7Zq790ziFx81?=
 =?us-ascii?Q?eylMNbJH7PwwjicawXXfDoJEQ1amRp8Rt4/RFOweDyhnkostO3R54IBeXq8s?=
 =?us-ascii?Q?I9xEOKmr5OhKIhynyPOaOpYw5kLiKLlYqYBKUe7buZ/MkZjhpVoItuDP+JCG?=
 =?us-ascii?Q?CGJ7vhicDZ/XJ0AhNn1NyucZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee421e0-73a6-4d09-ca86-08d9007c0a43
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:59.9654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUOMtdFwvp6Cz8p8/9EU5WymbuequcpA6pjc7ktd9fPW014ydrffWED+rNtH3bTEIx0hBuuKmf+nR2Lur890R/c7XKXtTaVoF1v440PlQ9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: K9ne0cdVoz4AgjcYQJ_0qJrnpF8D0PvX
X-Proofpoint-ORIG-GUID: K9ne0cdVoz4AgjcYQJ_0qJrnpF8D0PvX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes two bugs:

1. The scsi cmd task could be completed and the abort could timeout while
we are running qedi_tmf_work so we need to get a ref to the task.

2. If qedi_tmf_work's qedi_wait_for_cleanup_request call times out we will
also force the clean up of the qedi_work_map but
qedi_process_cmd_cleanup_resp could still be accessing the qedi_cmd for the
abort TMF. We can then race where qedi_process_cmd_cleanup_resp is still
accessing the mtask's qedi_cmd but libiscsi has escalated to session level
cleanup and is cleaning up the mtask while we are still accessing it.

To fix this issue we extend where we hold the tmf_work_lock and back_lock
so the qedi_process_cmd_cleanup_resp access is serialized with the cleanup
done in qedi_tmf_work and any completion handling for the iscsi_task.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 110 ++++++++++++++++++---------------
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index ad4357e4c15d..c5699421ec37 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -729,7 +729,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
 					  struct iscsi_conn *conn)
 {
 	struct qedi_work_map *work, *work_tmp;
@@ -742,7 +741,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
-	struct iscsi_task *mtask;
+	struct iscsi_task *mtask, *task;
 	struct iscsi_tm *tmf_hdr = NULL;
 
 	iscsi_cid = cqe->conn_id;
@@ -768,6 +767,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			}
 			found = 1;
 			mtask = qedi_cmd->task;
+			task = work->ctask;
 			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 			rtid = work->rtid;
 
@@ -776,52 +776,47 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_cmd->list_tmf_work = NULL;
 		}
 	}
-	spin_unlock_bh(&qedi_conn->tmf_work_lock);
-
-	if (found) {
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
-			  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
-
-		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_ABORT_TASK) {
-			spin_lock_bh(&conn->session->back_lock);
 
-			protoitt = build_itt(get_itt(tmf_hdr->rtt),
-					     conn->session->age);
-			task = iscsi_itt_to_task(conn, protoitt);
-
-			spin_unlock_bh(&conn->session->back_lock);
+	if (!found) {
+		spin_unlock_bh(&qedi_conn->tmf_work_lock);
+		goto check_cleanup_reqs;
+	}
 
-			if (!task) {
-				QEDI_NOTICE(&qedi->dbg_ctx,
-					    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
-					    get_itt(tmf_hdr->rtt),
-					    qedi_conn->iscsi_conn_id);
-				return;
-			}
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+		  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
+		  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
+
+	spin_lock_bh(&conn->session->back_lock);
+	if (iscsi_task_is_completed(task)) {
+		QEDI_NOTICE(&qedi->dbg_ctx,
+			    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
+			   get_itt(tmf_hdr->rtt), qedi_conn->iscsi_conn_id);
+		goto unlock;
+	}
 
-			dbg_cmd = task->dd_data;
+	dbg_cmd = task->dd_data;
 
-			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-				  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
-				  get_itt(tmf_hdr->rtt), get_itt(task->itt),
-				  dbg_cmd->task_id, qedi_conn->iscsi_conn_id);
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+		  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
+		  get_itt(tmf_hdr->rtt), get_itt(task->itt), dbg_cmd->task_id,
+		  qedi_conn->iscsi_conn_id);
 
-			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
-				qedi_cmd->state = CLEANUP_RECV;
+	spin_lock(&qedi_conn->list_lock);
+	if (likely(dbg_cmd->io_cmd_in_list)) {
+		dbg_cmd->io_cmd_in_list = false;
+		list_del_init(&dbg_cmd->io_cmd);
+		qedi_conn->active_cmd_count--;
+	}
+	spin_unlock(&qedi_conn->list_lock);
+	qedi_cmd->state = CLEANUP_RECV;
+unlock:
+	spin_unlock_bh(&conn->session->back_lock);
+	spin_unlock_bh(&qedi_conn->tmf_work_lock);
+	wake_up_interruptible(&qedi_conn->wait_queue);
+	return;
 
-			spin_lock(&qedi_conn->list_lock);
-			if (likely(dbg_cmd->io_cmd_in_list)) {
-				dbg_cmd->io_cmd_in_list = false;
-				list_del_init(&dbg_cmd->io_cmd);
-				qedi_conn->active_cmd_count--;
-			}
-			spin_unlock(&qedi_conn->list_lock);
-			qedi_cmd->state = CLEANUP_RECV;
-			wake_up_interruptible(&qedi_conn->wait_queue);
-		}
-	} else if (qedi_conn->cmd_cleanup_req > 0) {
+check_cleanup_reqs:
+	if (qedi_conn->cmd_cleanup_req > 0) {
 		spin_lock_bh(&conn->session->back_lock);
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
 		protoitt = build_itt(ptmp_itt, conn->session->age);
@@ -844,6 +839,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
+		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
@@ -946,8 +942,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		goto exit_fp_process;
 	case ISCSI_CQE_TYPE_TASK_CLEANUP:
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "CleanUp CqE\n");
-		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, task,
-					      conn);
+		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, conn);
 		goto exit_fp_process;
 	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Error cqe.\n");
@@ -1374,12 +1369,22 @@ static void qedi_tmf_work(struct work_struct *work)
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
-	ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-	if (!ctask || !ctask->sc) {
+	spin_lock_bh(&conn->session->back_lock);
+	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+	if (!ctask || iscsi_task_is_completed(ctask)) {
+		spin_unlock_bh(&conn->session->back_lock);
 		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
-		goto abort_ret;
+		goto clear_cleanup;
 	}
 
+	/*
+	 * libiscsi gets a ref before sending the abort, but if libiscsi times
+	 * it out then it could release it and the cmd could complete from
+	 * under us.
+	 */
+	__iscsi_get_task(ctask);
+	spin_unlock_bh(&conn->session->back_lock);
+
 	cmd = (struct qedi_cmd *)ctask->dd_data;
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "Abort tmf rtt=0x%x, cmd itt=0x%x, cmd tid=0x%x, cid=0x%x\n",
@@ -1389,19 +1394,20 @@ static void qedi_tmf_work(struct work_struct *work)
 	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
 			 qedi_do_not_recover);
-		goto abort_ret;
+		goto put_task;
 	}
 
 	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
-		goto abort_ret;
+		goto put_task;
 	}
 
 	qedi_cmd->type = TYPEIO;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
+	list_work->ctask = ctask;
 	qedi_cmd->list_tmf_work = list_work;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
@@ -1434,7 +1440,9 @@ static void qedi_tmf_work(struct work_struct *work)
 	qedi_cmd->task_id = tid;
 	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
-abort_ret:
+put_task:
+	iscsi_put_task(ctask);
+clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	return;
 
@@ -1455,6 +1463,8 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
+	iscsi_put_task(ctask);
+
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 39dc27c85e3c..68ef519f5480 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -212,6 +212,7 @@ struct qedi_cmd {
 struct qedi_work_map {
 	struct list_head list;
 	struct qedi_cmd *qedi_cmd;
+	struct iscsi_task *ctask;
 	int rtid;
 
 	int state;
-- 
2.25.1

