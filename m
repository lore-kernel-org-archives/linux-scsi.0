Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3441EC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E639610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhDJSlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbhDJSlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIVWQL061789;
        Sat, 10 Apr 2021 18:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=H0L+idsUyGGnntyXnzdbJG8jPmadYFQhLi55rqjMp+U=;
 b=Aokt1DCKADPkfBYIwSZpXd+7Di50txJL60SolJWHEju2R8J7SYTJ+0eT/rYVXShDRHuW
 vbQxlbgRh8pSWlCRdioArsDCkaAzpOTcI3p/SayfA2ejJlRp91Fn2Rdmt7qmmKO8ajAs
 IkRot8HNsvJmxqAxutK0L1VS/VSjbyq/I9hqQuin4VwWjrg6k5o1Bbiakue4HqWL5hTu
 JpxtVek8NBGC7kGq7bWsWWSoFnCM6AyJtKmGDilmTnrnp62jKPcjEluFHX02RNPx+w1e
 t4fSmiI2cueg+F8JeCzpfRtGaF4c1U4X9j7LOMoI1/LmP9npjuzVExqaga6JodqMPV+d bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3er8stt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIUZZa190276;
        Sat, 10 Apr 2021 18:40:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 37u3g0fee1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhtZzEJpMfTwNIxnitvknaEJajz/p4sKKo/LeuewbnCv34Z7HPtjAspix6EX/QtZxkh+G1961gRC/Aat4WAxLEQLau863WBWaPVDAX541K9/n0PmOrXhGjcYtKQqOWsuaiMVNQ+v2lYDWGFk2JAFiB+ZrX2IBHGJsRof9MYEMsuAuGF/KZHRyevqi1Cg7LPcdNUGBg8nn/Y/FKkYIXjfEP2qfX9nnH0a3NZZDjJyfxO/vPK7GVOT3u5EVzy91yJaTlWZaF2EsWHRi6gbbNITKdzCIfw1frvPJ6K+MxSwjIJ7yobEzUCGFwzBFPZv2AbUVIYgjzXg+YoXvck+Gl5IHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0L+idsUyGGnntyXnzdbJG8jPmadYFQhLi55rqjMp+U=;
 b=IF6YG34GbpxtXOXeddtT5FMfOzfuVdzOLyXKfsLFv1ph7FAoS76fL3SUaBr76TydN7J91j781qP++SypNVuWenV16QkMaMo9kceYg8qhmYAFj7/pXzXxywzi6Zghs81jaLBrOxygORKox3/2fQmCoogz4SpEmTG6FPRy4hgJbVLL3vD3MprKxzkOlj8hNAyGPkEPpfSUxMF3/Enooo0WpxrlaTUW0ytKM/GhaMS2KLt/gtpj0wUi8xQ9bmHzyiEix1sZyC/HbnACCtGq2uBEvfW22Hivsm5U9ip96z4hKl/7oCoVHMXvBdl0hm5rSIBjnptLPSDz/N9koJxmivwGGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0L+idsUyGGnntyXnzdbJG8jPmadYFQhLi55rqjMp+U=;
 b=gdVJImUDy0TD9fYx25h3oAb/czHk3GiZ2dlCJfIisiAH/rQzvSw7Rad4P05fjvD0+jhlc3WGfb/AXoHd//ycQiRMGt0kNK/7eBxw+hgSOFkaauwwXdlWsMnJrUzbTtb3VgsHWFYAYKgKmh6uYXOmGH/jEnxgGMI8ntCiuekbbtE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/13] scsi: qedi: always wake up if cmd_cleanup_req is set
Date:   Sat, 10 Apr 2021 13:40:16 -0500
Message-Id: <20210410184016.21603-14-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fdd8e03-9f57-42ec-b244-08d8fc50230d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB432401A6A3FAF703099B416BF1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c1EUfu6nXlCBgX4fZulymCvefegAeunn4QGLnkMyPfcfKUc/jsmzNK/ONQkh9rmkhbgzdekjx0Tdnoj/ooqOq9BvnteaUIGvFBjsXIEUALJWgZUn/mpAJF3KqVTp6U2NobekKZVDqLtNyqdjGxTZ9ezmz9XICF8r8uzPpjwlllQBHLI44KMJ2YMI9cZN/FjcogmQt6IIYIHu2CtCL2TSbnethLxDhtBpD9TiLhJzCwEYhKfEmma8hVGvgVut4ctPiGnwYI2LfUlxpPubDDEaDP5ihj6z+k5qo0mYffRRUiJL6NMAwLb1TSq/SZ4ruLFe62PO2w6nRFWMJdW/lysUmdaof+p11drm3VkjKFAzmju7rX0CKxL8urefasHeVFZTX7BE07YBk4920GYOJD0/dSIW2e3CZ6ke4agG5RYpgE3v/o3Z/KztAmOTwnVFTTtA3p94CBeWrkrKl/uz84hHdDpXJe69dfdrqA/Vm48XZLL1aBUEuNoKpFmiC4BOFEk+RiqcVUGFlIv9+VOMCKzFl9cM3AVeOyHT9c/C0nAqAivLj+83+05p5xZaSSURyNWhvMsbsnQt5dDzVmTdhBN7EPI4VWHbEDnzT5bvyhpqN+Gr8ac3evhG8J6qmI7c4VynSF/4GmcJ4m8d8PsTd3X1DmYgs/znkubdPFawflXcafe3Dg+qyJU4CJWjeGb4pf7D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qmImkUM1WTL+GvdAF5DS0BaHZuva7/j33bMCz3NNaqFxSDsXILR2f96YJMXE?=
 =?us-ascii?Q?vQgs2pzppl1ayu2r6kkvcRiOFhXTG5i8ljKfXT/SGczc2NN8a4qd/UHTfGYP?=
 =?us-ascii?Q?hSQtqHF4wxkEsPby+aFBSqOhiZldlVsABsgnFZAXkI0X7DEU1Dh9Qjj55KRD?=
 =?us-ascii?Q?FaG1QFTdLBJNCr0m2hs8hcSHgtRDJ1SBoF+gkprtqbFQ3Tq9i4tjvmRAKYos?=
 =?us-ascii?Q?kLh3+gxvTXN9ICaHtAg78sVpN1u9nIBZlpBScGlmcvz6kyhFM+iN9fZF9nbs?=
 =?us-ascii?Q?SZajWlDk33PERDo+bi+HSwpgp64NnAL1UEzSbsud7h9vl82Cvvxs+prWd6T6?=
 =?us-ascii?Q?obPI9rngs7rGIffvzgU711T4M6Ad4s6LSPYc1ifZ3t39RUGJK5UfGgXx92z0?=
 =?us-ascii?Q?+00+r+cJVwdfD/0sLhCX2TnZDXaF2r6mfPyMFJoK5bZXsBPw8UGOCboj7rRW?=
 =?us-ascii?Q?UsKotDMQH12ZApOSUU08PRhvHt/vw7JtE3DuAdjh2/gw9/g2PL8bnlpnHkaj?=
 =?us-ascii?Q?uFgpw7ji7cft8xMojYwfDwLPpEm2iL9kgLbjhDvieMxXtMEjv0rxz7KwfQxR?=
 =?us-ascii?Q?VvwCmE0JTurfisy/gdhWwcTHUmejRamZEULhWCYQPsnrjDSToFuazeAuDfsE?=
 =?us-ascii?Q?/vr+Hal2jC06YKpCD6nzBHE/ZVIGhXVwEYEyVE8+GrHNkPhj1LCo1J/AzFPx?=
 =?us-ascii?Q?JMXDVhnnU/t3ieEw9Adr67cpUdy+EzY8Q87MiSXJLCMuZvQeuiurwT/iOOu7?=
 =?us-ascii?Q?9h3kKg1WDuYso1ROlVHMp4qtiR47L/t1BSqLDlK58ExsCPTftO5bnyoVDphZ?=
 =?us-ascii?Q?oKITNi/0Dx5kShRE2Amsht5rstwKp9TtCfG/ztTS9BG6nGaZ/cpwQ5hXUFh4?=
 =?us-ascii?Q?+7JT1Ty42h4XkzA1om26doGva1dce6tbecNVsg6bdbNxbyD4TmYRnMWP0Z0S?=
 =?us-ascii?Q?PYY4j9AsSo8FRa/GHAxZjd52upCaH3b6/mFUf4CWfo8vSp9chPyilXKWng67?=
 =?us-ascii?Q?yBaH57C5a78B8Tk4EhgWZ1CBCRLN+B4K4wmt9LmxzIFnMvIgKTAcZzvWesXM?=
 =?us-ascii?Q?A8Arg4RC+u0//mYc71c3diaMv2nocN6DF2IxoSbGooG0uphU0ISoJBIh08bD?=
 =?us-ascii?Q?rV3gTWAPqQaGvbIeD+UrQN2aIi7y8mHsj0GUzipZjb2sD9xwAU/IsYr4lcRB?=
 =?us-ascii?Q?F+6ARGNa42It8Dn01YLmenTZDW3WRTmz2d6q/7E0W2ecxT058mAM3AzDqksv?=
 =?us-ascii?Q?KxpvF4U2WbjIRmUdYcmWOIN3J3fkHOZxLAu9LzPxFCNMEd0xdxz+26x48Wrj?=
 =?us-ascii?Q?whQkOsb4ChlQhr+cv8C7c1BN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fdd8e03-9f57-42ec-b244-08d8fc50230d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:39.0307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRyNEAekpJNImDOCPBiTNahr0tRfQIxmpLxvsVjky4amXm2dSaNsYRmv1TfMbQkg+IH8qKTif19t+PCDyvrAIdHGDXyZ2oDGW/BKFgT0cK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: OXbbuleHTu4u4O53JnXmTIlg8NxkEFpA
X-Proofpoint-GUID: OXbbuleHTu4u4O53JnXmTIlg8NxkEFpA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we got a response then we should always wake up the conn. For both
the cmd_cleanup_req == 0 or cmd_cleanup_req > 0, we shouldn't dig into
iscsi_itt_to_task because we don't know what the upper layers are doing.

We can also remove the qedi_clear_task_idx call here because once we
signal success libiscsi will loop over the affected commands and end
up calling the cleanup_task callout which will release it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 13dd06915d74..13d1250951a6 100644
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
@@ -823,37 +822,15 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
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

