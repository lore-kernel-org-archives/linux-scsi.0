Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E36C47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4E661404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhEYSVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:21:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44310 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhEYSUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFD1m124705;
        Tue, 25 May 2021 18:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=SKJ2pVTnMxki5PmiXY2g34Ztx4tNsql5sDYUWC2lhZEU7JGjQO0UbUF+lH815wn7skbL
 EGx299ZlT9CuImWB+yykqzX4BcZxjQOvcFaWNRur/nC4hhy0sY57baiFrFKr+6GUJHAP
 ue1QdvlFFNaxUFkngNvjKjFqL6ZyNTGAhsLUKqheVPLYnh6X5+t7VrzDzpOIeLFrKRXN
 5eLTFWlyYxuTQD9dqQkJQlqTRKY6ymT0PhVwkhPfJE++lRm5NEfNjAEaT5fS70Ap/3da
 mUvFu04/5M5Tn8TmrQUb4WUG5ao/E43nPOQNGKevlNHGVYl/okQYlusyp846HsBWp+mh iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfceysf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFGMq104688;
        Tue, 25 May 2021 18:19:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3030.oracle.com with ESMTP id 38pq2ufk67-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsEZYP959ujnPdK4SL+leThmjRfaVy52KTNOBHCvukImzDYjHmD/0gbAxVd8/FUoMlRXQ/A8zLxrESKSxxHlSHejF/5Ajk6815MvMRBvtyP9F5WugtcEbBrxi9vVG5j3IMx6AC+Ne8lPUvmq4Z5Z6K8JyrcdD4TCQ8FhCk6R+jx8e1XJ77O3JIKBhhMYR3OeELX7NIh16Htz5QbyONwg2spy9fKBzAucR7SXKZNKA6b8y+SR9x1rTyMpCDW/PHhO9UlJT7GeOhVCu9HZ+NYSiHh5inypWimEUCD1pjUIwzFxEQEmibpwrCk/ovaUBzFhh389S5EKF0lQrC+ZZRTTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=QGSmc7e42baVlhn1EKXsVi/VZoykphYUaBP3shsHX750mMqccAwN3oJn3NgeCO5YOs1eZeXFRhwiO+yWKxwLdoS3qwXuPr20ROWaXjpZUr+HqW/wIcqkMNmm91CWqiqinagODR7+SUzl9VU5lsZpxkM2tN8+vz4QjE6vNgGQFjh/UxbrZcLNaui08PV0dwsolCbrVz9P8G3jatTXQ9V1Rmqz1B/qQYc4FhXFVFjU34wCzfGgP2u8NSoSEsOrE777vW4GGoP4dWjwQAtlwCISzB2mjIXEB5nYrFMzmyx9sxu5wZPk9dToNs5/kBZB28CdaVJ0ru9PVhLsTVwUxQMhBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bJhRCqGwJYNcTubNpggQo21ACbthDTKA+4v+JvH81o=;
 b=x+wfTXC3U+L3UV9dWueSXv/aPVFIjz9Ccr8TmyF5O/6oblgaZ+2evHaDK13L/gaRh3VFSqqtNnzv+I3W/mpUFyEcC3grZG/g61lY2fmqWWTCPATq+o1cqPaUD3tjp9RmdDBO5o1HwxR8BrKgNsGBZI73Oc/xCUi/IJuglNE+mpk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 28/28] scsi: qedi: Wake up if cmd_cleanup_req is set
Date:   Tue, 25 May 2021 13:18:21 -0500
Message-Id: <20210525181821.7617-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46b1adae-0ab1-4933-36a6-08d91fa9910b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891ECC752B2D0DFA2B8EE1EF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5lCvM8AZA+BvCt0faQFndb1qOL43G2h+hF0vLGopnIGBR/zh4twM33PT9FWod9+DIL8UAG328luQaLusf4iCKE4hEWNP9XmTO+kK1sUSTMLHLqbqLix6taAXLJtjugNuXUIiGC7Bwq/G/T0pYCc8FrIhGY3L9x1OWeiq5bUxjNMMsyB+eh/xcnLiRNTPq++BCvJwj0S7ihINgNVsEP+VFmeRXf0Qt6lRaWVsFrUu85xHg3PBBkDwCdNGKTfGeqkTrGi3xr6vWIzzWD0DTm4xQ5FhSgioHp5L6XvRU75K6u+ojTX4VkITSs0qbXd91ad7z0PfLycJbtJ4pHsq1qMSIRv4m7fn/ql9ngWgIfFNIIifxFyPdXfZ9WYaZr+XII6VyIwpIvzLm1uACn48/Q4KQCynUHUjaDMnUPEPu9QXAluYENilu4suWSMahKvqVRYFXB1WgBs4+Vno5iSWSJuKr3FeAYnBRPdwewtwCF3b4zlc35WXN27XHySsliJXWCN+Ls7Pqu79UMZ6W8vJoWiK782YLrABC2n8/jAmH6GCbivPKpk8dhyxO0hfUhVDzhE8tK48WjNsr8KW+aouD0WskemQ4OcMyiq62Z3PN6MvkLoEFTiBLDvYlf+Z7dA0hQtE+KCxY8HlJkcvgVMKeTrfExxqOXGADIAoydQq0UGbIBU0X9IppEqgqcIbguzX050w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iY2AXlVBTsmPsuu/qvZ3nbHHXMiSxzcs7unKqPOAyTJcXdr4jM9Hu2TKvMwV?=
 =?us-ascii?Q?YO5jml2p2s3iGLsCpDH6jg7Zfv7l5cFffCSZYmoZLoJ6QifQIUxorzHmjysn?=
 =?us-ascii?Q?BHBVEetpIedmi/KsjdzCN69qXOxKXu7NQCsTiYu3rmzEhZkZXkb98c8hYIYG?=
 =?us-ascii?Q?0ZTqbCg1Fh6lCRb8oFyoeVdnj7/iZAk4q5XfZi6D4brvD4ZqZEqQ/1Aua4eW?=
 =?us-ascii?Q?EJuY1IVfrwvXQBp2ns5sePRBp5tQxcGK3OrAIZ4iIbXIOmcA3MeNzlF17Egk?=
 =?us-ascii?Q?tZsZwHh8rW+UW4o9CoK/l37MuZbeiqhumytSLjktQE+vIXd6MMPXrIeVHXp8?=
 =?us-ascii?Q?F8ZB9DHdj1X+8ruV4pnQlg6ZUHSSyi14LzQrbjHFmBt6L1UBeajEQdVEDtro?=
 =?us-ascii?Q?imhd+S+zPWI+IgJ+NGQ+dg29hksXGfYLDuefEInYu1doB1DCB/TrQ1m6VIFy?=
 =?us-ascii?Q?R/uUCV3Y+x+QPMTcypCzW+J5zcT069lqxuCRBaztsRjwRQUl8onkSIw+BlmD?=
 =?us-ascii?Q?3M27WXxf2W3GfMPnnRiQ4VZWx3GzxVbJwJEhD6psKjkK2TRRd8RPkxf2IyY0?=
 =?us-ascii?Q?zvuE2znerbSi4prWVI58PFU8IA+RYrZyDmbHcWf7Qso14PBW59FvjZtI6jSF?=
 =?us-ascii?Q?cw/UIG5rKcMoxFW7/ZQrlB5JVM0NYjdHSQwmdnbupKQVk+goAOEkk3FvxDZ2?=
 =?us-ascii?Q?WQOgHBVFxkufUZtSLlYoxXj6D8dHHkZW8u8h6DwLqDTW8nRLXoBpbGDUMaxt?=
 =?us-ascii?Q?j+FH0evSqzwyVjrCjSnNE8gom6VB328zkUXfvi8csSCwS2I/42gdr2UTqqIa?=
 =?us-ascii?Q?mj15mgOO1kDk/tyIISKmTt2lg6U7PiH3usRK12Omx1GDpNExbfjJiPftTVoo?=
 =?us-ascii?Q?KtQc3pq/dEO6l/pKJOJyVKh62ejQ4zqjR/JvlARMsRZUcMXJPD0hRloXFyV2?=
 =?us-ascii?Q?TWQYyW5PhFZ+qKCxFCHMv5QwUQtnlB5hlF16cjUxOfMrSRGG/cT2M/twwnRY?=
 =?us-ascii?Q?4BrDd+WrLumEUMA5yylHpFq6hbcMEIaGQkPA51zGPK4Dd2hYel5CoxfDnro9?=
 =?us-ascii?Q?xq3gmK7e761kvO+lKdVjpnSbdYZ1PKQuM+nHaWGOAGTF97auN0Pve2UQ3bbF?=
 =?us-ascii?Q?tR3eB5CmF0wGb44nq32j7NU1ind7gmt7ugsNsrQHg9C0es7Cn+af7F6F9YGU?=
 =?us-ascii?Q?7qpyUpQc0ilXl5v7FEjz/+6DTKaHb+8D4EGv46C2BlFl54Ic9dSbyNnDU07K?=
 =?us-ascii?Q?+kWdFoIU9Ci541j3v67qV+A3SizkDaztdpAwtP4pbb1qyVeExQURJTvQuikk?=
 =?us-ascii?Q?QXUcV6ALMhZMgbGHTAyPsR7z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b1adae-0ab1-4933-36a6-08d91fa9910b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:59.5359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36swPslmq15huMztpOiRl5N3vVMknSsV4KN5sP/e3KZ4Q5nyA/8BvOwFNPZ9KSQUom8iVyPUk0R2jiado6klqfyWIFmDeWCJCZoUCczIw6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: nKp6orXgg0UJ1BpH8AEbiHuMPm6UPLT4
X-Proofpoint-GUID: nKp6orXgg0UJ1BpH8AEbiHuMPm6UPLT4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
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
index 3de1422ce80b..71333d3c5c86 100644
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

