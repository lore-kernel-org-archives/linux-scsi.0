Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0692C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5BB61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhDCXYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhDCXYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NNuIC162515;
        Sat, 3 Apr 2021 23:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rVE/f87u/MaZp4+kZPvkJQPJXH8XAAieEt+pvEUXr4g=;
 b=DmgvVhmPAFStaeVusFZUh6B6EqC7njPTLZ2NrI8Oh3zoVUQzKrzWw5g2HIHqF/aENzYx
 8SpVvlRM2lUoUfuQDKZ6dV4o0HZS0ww/za/ig0qWkflUX9AuffGpyzTOljxERzpHV2g3
 XF3m6hnSGYqPw3XPOM3+nTDQrAKSzqV32qC65gT7OhcnKKLPubUSWgwofO8oEb++GHmC
 eQRAWpg/it+/Byj12WKCe+3jgfSSUtx7cq0BXsz0dj5rGORQ2jkSd1ctrYShQ/2VdqKH
 RtBGxEs4AAvrC0hkab7jDV24zXjX1eMi0dhFikHB5yfIUwqOZ9F+3aJO/0hp0RJeKuIF cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtAc116931;
        Sat, 3 Apr 2021 23:23:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 37pfpkbskt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVjtTaHwBggV1uOQGcsIMWJmuM3c6Pisp5XLKaJalB+IcVj4thBE4AljEZe01/0hlRDaCoO8WS64hCLuiAYYYcHP8X5bRXnufXxpNtShhw04FaKDPtnHz0Wcd7V6x+Q0ZLcpd6wrPhK8NSfETs7CHNTMaJL9g0M/Af6Ub2Rjx+HyxQzRdDhdFUKz28FZVUiXagMEwixGxkCPLUBbgZ/IZZ8Vd8opysuNmo9rkhkdtk0VzhqhSguEJMIiaiF+5UFnc+D8kFzmT4noh8nRQPOFGK6sGKtMrDduj+crJ0gFODKbJIKg9OOrfuuelXtOWCOaSUpL+o48VfSoSQwvGpFFqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVE/f87u/MaZp4+kZPvkJQPJXH8XAAieEt+pvEUXr4g=;
 b=QVo3XN8O9IHGEtDcuhAU0MGHhU1Fwpcjfbv7MFFh8Q7Y41er919cdo1UJZ/HfOhhij6V8tbuYETqv9YJk6/8x6uaEg+12pETLRKnno+6+l5csSMrRsq2bETmMEEzSjdkUgP8/2WumGtw0yUhJUnqgHgCZUpLVO2QqG2ceEac+HG6CE3/GKRRPSV2HlEzMDlg+lywHNB0ArvB+KsoMTOeA+Fo3uRe86BWQfa1dnqEqhUcPZuVnFdQzin3+91i7gzYAs6wM18G2G95S5MCqKPZqtQNwyyLICmZFWzSFyo6S9BwFyXiUFIl8k48a/ZuIcXhb2GIesARxe+/VYhhzEHREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVE/f87u/MaZp4+kZPvkJQPJXH8XAAieEt+pvEUXr4g=;
 b=aVSr9p8KelpRbN7URU1i5tA9cVQk1UdmtC+cglG4Fdz2DB2XEqg/h0H013BDW0x+UC+ulGm4LTghjMHz6S09VSEXCkNYtQhkLaHxPLQJBo/IkUI2JohpVbLxq9CYMtiLQ38BacIzFbo9c364xKJN5iKftWuCkhGJ/UmXD7iSDPM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/40] scsi: bnx2i: implement alloc_task_priv/free_task_priv
Date:   Sat,  3 Apr 2021 18:23:00 -0500
Message-Id: <20210403232333.212927-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 562f06ca-76d1-48c5-6ca3-08d8f6f78b87
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB352684FDEA57CF8035DD8EF1F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNU/QummFQvZs1urzYMQpXvXJqBD2UjkzRZiUBWSvngpm8g1dA/FozmMHONuJakbbUbMFuVPuwUOf+OcewRrzOLOiFgC1H8acXeMD6yiCKXO4DLLsCoLe8HrzhTkwI1qfWxAVFOoLClSg/3sorE9puOd7WIn/y3rPLvqhQ1FP7KZEQHqAaXwWvOXfEnlBZ/ho621WgY5Q8eRUJRIr8Eqa6QM5Azm3X2umtFHVGymbFwF9BAyYOp/Dp0mxdmxafZKuvztcujXstb2YtSrQK2/+MnmCM5k9QGH40YGhQFZZ4gfrishZc/QvaUsTuXg0yp77F4Hpl4QhOvWUDr881WLfkxr4UrlYe8OGXguwziWL5cVBdpOU8JCQgz/8d5GUvsbdEham4bUEEZhRJ8k7rpc/x7owTnxQzXHWSnb5QKqHWFGWiuBC09cqrpO2sEkYOvrWxuHI64KXDszmG5vv6f6nhCQzR4NH/++mLwFPqbHCZj0kSasj7dlYxt5mIJvkJCywybNvi/FK6te+VpoYDEpGg6s9IKADfTkVyBWP9LSJoBan24F8vlbilXHdlCDuyIToa8pwCH4vwYKCpsU4xynfzUHnM5MTyMzcZ/UI1Yl3ZBzBsjxW4cHFSBooZIOHdVhDW5V5LOBfPX4DphzLNqS/88hHCqDp8Uh8fVHTJHCvEfjtBSuA49LkwoOIyN3Jr7nrzJO6DzPGv3tpeiOQuLOuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6LHSW6mRBQ4IyunTro+6IIpA0g/Y4dl0kV8ioe6C6quJ1qM2jQGyF2ELCVca?=
 =?us-ascii?Q?IOXsikTo1alzUVCKTIdjiKbSt7fpOsm7AsVdn6I/jdhNCxtBtWbXxqkvZJ5F?=
 =?us-ascii?Q?NqPx1MkolYcnZB8lpoSQk4yRXdLehqhb2TyJ+MVV23Ma+/cb8wzSMUoy7IWa?=
 =?us-ascii?Q?RiF6GAPbXEYTAR7kDB/mzR+VBkxig0YuRKyWyReQKfW0FV/MSbzoFWqpUOnz?=
 =?us-ascii?Q?NFkxSiz5SJIG9TSCqTlJj0BBopAnTO8qs78EJSAasMbTzVfCsijk6yr7NGfE?=
 =?us-ascii?Q?n14C17vnQpGaR4zr1lOz3Cbi0x1kccnXVIONOA7MfRWPASM+2JZYyHORv5ba?=
 =?us-ascii?Q?MyZxxtokIKXi05E5DDwnMdCbUzrUG3gbqvGRkeyl5ncUdpnTE0/VN1KYkjeB?=
 =?us-ascii?Q?14m/hoI6L7SrW9Zu6IHwqKR6fSWnNDpRnSJdbUCm2z1AyjsgIQjDB+/n14JX?=
 =?us-ascii?Q?7VlS3oRp3pR7eH6Hgry++ktTV7N6Q7TszBcO7weQ8zhFNun1eD3Vra2/fS4T?=
 =?us-ascii?Q?wPB+PKqhmt1TwFXE4FcrBnIBMf2aLn2khQ/x7vqmQsbQ9C1FzUh6WSwm26XA?=
 =?us-ascii?Q?3gA/vV1yfO78Fn6I5eXWVHuNq2C8XO0oXT2B6EZf2wOBqYc+rtKRhh6Dum/S?=
 =?us-ascii?Q?Y6gEk+8XprgESydco+YQTFmITSMYDZCQqWgbG7Vjq8ulCvgHhaQuPqDcucqP?=
 =?us-ascii?Q?6mpR7OvhwtyQs6BF+Zw0hOVy/kOHYFc7rFtVt+p3O0T0BMyxiAzvHRcaBXoL?=
 =?us-ascii?Q?H6wxre+RG/mWGgCjc21lKXckoyWVXkjFtFyTlzAIk+DrRO+TteN4iyxbHXiA?=
 =?us-ascii?Q?7hn16Y7XDwAYW54ul8DOYOLH/aIcadIpUHIgEAUCLHTh2oxButnxuv1TXc6p?=
 =?us-ascii?Q?tC6xJIX2Q+VA8qM328NgkIUH4VecboFg0nK33OOluo8sbUiVjR0dHRgbLTUX?=
 =?us-ascii?Q?nVAEhOntO5TCsA/zMmt8biIp8DEmEP+33TVX3Wpg3ia9rC9CgK/wNrqT1IIM?=
 =?us-ascii?Q?VFZsxig6f2AZyMasIDCnLMvp1WLmIdJxX7xFZ0k+6UqcppGd/hMdACiYJ26F?=
 =?us-ascii?Q?yxJajbkc0RWfZPxfhaPGl4n75wItRK7I0cSJHEHMLhD3hB81SSoL4Dif+dvb?=
 =?us-ascii?Q?urcmkih2KG5pz3goav014W7QJO1t9bmvPaHyDGSPwUodhuvWsMYPmY7TnfCF?=
 =?us-ascii?Q?df/nzVVVVIdJPxm/R82+0DMQ+dW0FtKX20rL4cyCQEG6T+QpHlnujt4nTWyY?=
 =?us-ascii?Q?64egfeaWjVb3VXsHh1jCvUBSBHoBT3zS/M8sAHLRnadyqIo41wwWR112u81d?=
 =?us-ascii?Q?vTF02BJ6Pyz3ShAn4jlMDTCm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562f06ca-76d1-48c5-6ca3-08d8f6f78b87
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:53.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Q+srCcUK0gdKPRvsyoWHJRPW3Z6rTm3JPn7UoyaRvb4D/JNNko1syjRPNZ6RSvvb7oEPUpVoxgPcYvR4m5KjpgGf85SEorzL1xvMdIE3sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: kfar7xrhTvhmEWH4lWpU5AHCSP5zkkiz
X-Proofpoint-GUID: kfar7xrhTvhmEWH4lWpU5AHCSP5zkkiz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have bnx2i use the alloc_task_priv/free_task_priv instead of rolling its
own loops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 107 +++++++------------------------
 1 file changed, 24 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 48809fc8f095..ce98112799ed 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -438,11 +438,9 @@ static void bnx2i_free_ep(struct iscsi_endpoint *ep)
 /**
  * bnx2i_alloc_bdt - allocates buffer descriptor (BD) table for the command
  * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
  * @cmd:	iscsi command structure
  */
-static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
-			   struct bnx2i_cmd *cmd)
+static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
 {
 	struct io_bdt *io = &cmd->io_tbl;
 	struct iscsi_bd *bd;
@@ -451,68 +449,39 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
 					ISCSI_MAX_BDS_PER_CMD * sizeof(*bd),
 					&io->bd_tbl_dma, GFP_KERNEL);
 	if (!io->bd_tbl) {
-		iscsi_session_printk(KERN_ERR, session, "Could not "
-				     "allocate bdt.\n");
+		shost_printk(KERN_ERR, hba->shost, "Could not allocate bdt.\n");
 		return -ENOMEM;
 	}
 	io->bd_valid = 0;
 	return 0;
 }
 
-/**
- * bnx2i_destroy_cmd_pool - destroys iscsi command pool and release BD table
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
- */
-static void bnx2i_destroy_cmd_pool(struct bnx2i_hba *hba,
-				   struct iscsi_session *session)
+static void bnx2i_free_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
+	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_cmd *cmd = task->dd_data;
 
-		if (cmd->io_tbl.bd_tbl)
-			dma_free_coherent(&hba->pcidev->dev,
-					  ISCSI_MAX_BDS_PER_CMD *
-					  sizeof(struct iscsi_bd),
-					  cmd->io_tbl.bd_tbl,
-					  cmd->io_tbl.bd_tbl_dma);
-	}
+	if (!cmd->io_tbl.bd_tbl)
+		return;
 
+	dma_free_coherent(&hba->pcidev->dev,
+			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
+			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
 }
 
-
-/**
- * bnx2i_setup_cmd_pool - sets up iscsi command pool for the session
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
- */
-static int bnx2i_setup_cmd_pool(struct bnx2i_hba *hba,
-				struct iscsi_session *session)
+static int bnx2i_alloc_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
-
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
-
-		if (bnx2i_alloc_bdt(hba, session, cmd))
-			goto free_bdts;
-	}
+	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_cmd *cmd = task->dd_data;
 
-	return 0;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-free_bdts:
-	bnx2i_destroy_cmd_pool(hba, session);
-	return -ENOMEM;
+	return bnx2i_alloc_bdt(hba, cmd);
 }
 
-
 /**
  * bnx2i_setup_mp_bdt - allocate BD table resources
  * @hba:	pointer to adapter structure
@@ -1286,7 +1255,6 @@ bnx2i_session_create(struct iscsi_endpoint *ep,
 		     uint32_t initial_cmdsn)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_cls_session *cls_session;
 	struct bnx2i_hba *hba;
 	struct bnx2i_endpoint *bnx2i_ep;
 
@@ -1310,40 +1278,11 @@ bnx2i_session_create(struct iscsi_endpoint *ep,
 	else if (cmds_max < BNX2I_SQ_WQES_MIN)
 		cmds_max = BNX2I_SQ_WQES_MIN;
 
-	cls_session = iscsi_session_setup(&bnx2i_iscsi_transport, shost,
-					  cmds_max, 0, sizeof(struct bnx2i_cmd),
-					  initial_cmdsn, ISCSI_MAX_TARGET);
-	if (!cls_session)
-		return NULL;
-
-	if (bnx2i_setup_cmd_pool(hba, cls_session->dd_data))
-		goto session_teardown;
-	return cls_session;
-
-session_teardown:
-	iscsi_session_teardown(cls_session);
-	return NULL;
-}
-
-
-/**
- * bnx2i_session_destroy - destroys iscsi session
- * @cls_session:	pointer to iscsi cls session
- *
- * Destroys previously created iSCSI session instance and releases
- *	all resources held by it
- */
-static void bnx2i_session_destroy(struct iscsi_cls_session *cls_session)
-{
-	struct iscsi_session *session = cls_session->dd_data;
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct bnx2i_hba *hba = iscsi_host_priv(shost);
-
-	bnx2i_destroy_cmd_pool(hba, session);
-	iscsi_session_teardown(cls_session);
+	return iscsi_session_setup(&bnx2i_iscsi_transport, shost,
+				   cmds_max, 0, sizeof(struct bnx2i_cmd),
+				   initial_cmdsn, ISCSI_MAX_TARGET);
 }
 
-
 /**
  * bnx2i_conn_create - create iscsi connection instance
  * @cls_session:	pointer to iscsi cls session
@@ -2274,7 +2213,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 				  CAP_DATA_PATH_OFFLOAD |
 				  CAP_TEXT_NEGO,
 	.create_session		= bnx2i_session_create,
-	.destroy_session	= bnx2i_session_destroy,
+	.destroy_session	= iscsi_session_teardown,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
 	.destroy_conn		= bnx2i_conn_destroy,
@@ -2286,6 +2225,8 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.start_conn		= bnx2i_conn_start,
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
+	.alloc_task_priv	= bnx2i_alloc_task_priv,
+	.free_task_priv		= bnx2i_free_task_priv,
 	.xmit_task		= bnx2i_task_xmit,
 	.get_stats		= bnx2i_conn_get_stats,
 	/* TCP connect - disconnect - option-2 interface calls */
-- 
2.25.1

