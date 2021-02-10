Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B074BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8062964E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhBJE44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:56:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41038 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhBJE4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tU8t139900;
        Wed, 10 Feb 2021 04:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3EuffiF5sRnNc3qwHTF4uaOvGDDnCS1VAU16x1f3+os=;
 b=OkkmGOK0fdFyGIe2WmlHTG/7hbvU/BEl/4/Y99T15c95NVDqPaaOeP1hy/BU7zA1tXVE
 jqPPcCxvFSt7Scp8DZ7vdJjLo7m3DKKdlNiQCpMVOmatkKge7USRkYwEHAk1ktdDp6uh
 KYptPXJjzt6+lh8bqfYdvaR6VhVDUCpIYmf5hmYkz3+DVYCH97fW9FAW9VBSoSj2ioz0
 5mXTpPiVupN7kPj5K6OxHscq2Zd8eHm1t2FOAeHLQ7BvXjfxg98SYb8n2VfvW23f+B8h
 /eseTtERAh38dfS/jRl4kmaA+5R+bRSOSqVNfD82fjV5thnepbbM5j6hJqaJcKa7qiQ8 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uprdfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB7048727;
        Wed, 10 Feb 2021 04:55:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG4tcETgqafOaZxmWss35pfXEYcsay0uZcf6/Pga/Zt9gBWZ6x5qfBRrKwY5Jvbka7RjqXNjXXhMofUTUU9XrIZCBglpBkfBy0KQHH/RiR2iIPb5tsB9w1jCDcD8h1ohzZpeQCQAImwA0gMazRdZrVmHK/mVflwJp8+/jKHXv4+bvByDT+QOxOjrkGuyORujlrxO+9Qkqh4UNHQEshni3fZoKAVrZpB7fgkQBvXhVNRLr/vtzOFfhutEfbG1LYzP9AzRDW8O6kHZGtLPMKjMOfBcjg4hTb5gp7wD/7/NiAlFRAMJ/046XSziw2Q9ACMxWovWIADOvLkSkJiU4pAb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EuffiF5sRnNc3qwHTF4uaOvGDDnCS1VAU16x1f3+os=;
 b=IrMrtZxUSsR+J2qGg8o+OrRDQPpo0uHiKX8NTmLvJ3iiYGP54MXIYY6OGH0dHyhmAEQehyLb1EOwmUwwVSF4olrmI4ihWx4QQoF4Kduap6rhlAsTrgkh3dDzT+d92niPxtrIPKk3+LRlYokG1fsE/Mww/p9n/LCW/NPrCLFBZMzkeKLgOan/LvMwZydEcWe8xlbko9qJt0jmbLwnSG358gMYLLJP8jNQUnc/cJwZ4CuFWdAVt1ghekDto5C3GDa5AmsQRa1aTHBRvac54eAJdTzCRnYTEB/TKVFkZSpRJII6Agpy7Ixg4Q0BRuxpxzeYITo67ebu4kwfUk2189TqQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EuffiF5sRnNc3qwHTF4uaOvGDDnCS1VAU16x1f3+os=;
 b=LjHYpfMgGcAE8QaliGv7jfIOe6p/a3Gx2UXKEhmf1shUbqK3ZtDhj6HkC6wZmfm9KqQWHJrOBdZquzQJqQrbWZVomKlW0XgXH2VdSX3+PJX7cdZQ8ummPgCPtRrtO8BwqYC4ef1mv/j2GmODZWIG7sbB1bXWHiQra0h03R04udk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/13] tcm loop: use lio wq cmd submission helper
Date:   Tue,  9 Feb 2021 22:55:09 -0600
Message-Id: <20210210045516.11180-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b9aeeb8-e8b5-4af9-e62b-08d8cd8018a5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33660B0B8D57DA2DB1F07747F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWNsXVW3Nn+MS7+wS2mdfjiZdBhmAAibFKTypn+kNOBpyW5fXxAHnhQXrG6h6fwx0sblI5VezS17J7FD0JuT/WZIMNudKLlfcK0uK1f7ut64otBeSCo7xKfzy0aHGPv3ULk5VsvZ2Tl19R6Isibo2FlqQIxa21nC+QIn+uwY6Arm5/6KO47JE1rHcJaVXUcG4Kj06mwL5Pfkre1z8Vbuh6Ae91YjNeLjyT18L8l6H27ttZbuYfgNB5XUSqvPSy7sYXd2WcvcE5eA6l77f1uNofijLCdGwYtV1wPrFPssodK+x/XUctcYrqq/Dq9J2UenlNkSdgMV/5fmqhVrEb8tTO/X8/qKJLuGkAj1T80chJbBzSrRZ/e7M4thf7Atb4lNtlFAyNPfF3j64mMnGBt/Tc/5YpBfSvn2nhXK6cbaBkeifVgSAbaCO7RhtVfzBvyvrpNiyvnL5AmRKG8tK7wW0LqxzP8qaj0jJBqXCVhPv7o7Gxzo8SsXFpgCG1tVmI1Ckkrj495bDxH7MtBn9blxmN7jsOK/ws6xIJGJ4X1JpX/q0S6GJtGep66ZnMwQG/wHsQGY+by7Y3X7yLVu5+5xuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K0XKrN6dNmRf/W1W5P2rAhtNxXgfqBm5acdXCO/TW7X5cU0MMX/zgtTIj6Oe?=
 =?us-ascii?Q?35kbHfVnVy61LEmC1P8sDkGFz7fhgbrgMAXDQ1EFIj4Wn13nNs/e6PYz+UhH?=
 =?us-ascii?Q?LBthfxzuLx15trr/cehz2OKgHaPrNCGGv2RTJJG3tLqAP7d4yUaNTnViGrAg?=
 =?us-ascii?Q?YlrxUfapmurcGqH50T9d+IvYlxvnQZrqANs1D56dR/3AYryQMwCXTpBMwet9?=
 =?us-ascii?Q?wHhREwycvnIjXs81iK88A+085upoHUn4Cwk/4u9JrYFt7EGz7ALnUd0LgEtk?=
 =?us-ascii?Q?H/mxIpCziIAILdoG+wOSHVxBwmg3P0O17rHfeOM6n562ylAENiEOAFYnmU64?=
 =?us-ascii?Q?Ewe7TCpPPGf5ZbzHdo1OxZi4rOi8CmfI9LoBHcIVNuM+j0uBOQCg3AIw+VgS?=
 =?us-ascii?Q?dKdRDGSI3AHlDT9vSQI3dwXEf+M9dZtRTs9HGUos7FSmgapHu+ioBwx+DMyj?=
 =?us-ascii?Q?NbH0XAzvK1G0GREFQFg/45ObBpXcgDL9gxAmedmwwBJ+dh7vmLcLLCE2p/mu?=
 =?us-ascii?Q?LnMuixpFTfZPESN8m139QO42eYKQvjpjvDCZjak6/ejFSga1QykSBs0wtY0t?=
 =?us-ascii?Q?scsZYu1zlvWuSxtK89/FRt6hVj5oCLnPCUVgbBKycKOP3dNXAsmI9msPbK/4?=
 =?us-ascii?Q?EEToSeJ3lCgtiaLliB0iC8jR9bzDZyT9HMDYm+DIMS6OavD1WUPqw+ivVlMc?=
 =?us-ascii?Q?xCS7D36u+4q8L2Y1o7a1EY7g3M2OA68MFyL8z32LOrypFykerwoS+OxWc+H7?=
 =?us-ascii?Q?DQ9JKcFXosWC0GtgTEy1YFqXbd6xXndQgsJwPPGhqKZyNISZl2HOroOxHbpw?=
 =?us-ascii?Q?/X9bKq25vHcEPwR2St1LDPSM3s8AndxijZkESp5k2n3jTrwvuLWRlnPweomt?=
 =?us-ascii?Q?jTiot4LTqaVpDVM8QTVa3NkAmWDDbdnWgAJ9Ov/pi6rQm67y8iKNnoQ6ZnWN?=
 =?us-ascii?Q?wjKzZArnt1lsRM83CatfUszFq+9knxoR1t1Kr8VfHdTZK909jRdnmxL1tXJE?=
 =?us-ascii?Q?I7hfQyw8KBkrmxDzFXcryhtPSsjj8BHKO0OzAavrjjTkHyqGWETgwMPkqJuu?=
 =?us-ascii?Q?TovjqGQdO0bsNbYVY/h9eSmXDJAW76OrQgJHKZ9B86XFcVzpG7isZY2sMZXP?=
 =?us-ascii?Q?oat1r8bpZYnrgX+RYNju/kUX5oAeVcSosRCGnPO9r1KLMsD+oIfk76hsCD6C?=
 =?us-ascii?Q?1ICLNSrLmKs161dCf9H6IiRKeMAvu+kAT8JfAPhNd+sk5lH/APxHSd1ZSiqc?=
 =?us-ascii?Q?vTiV+9YzlE9dDyzGa3X4zm5wTKGnYABe1WsrlawVjS40s6j2BDsMOHn9sTL9?=
 =?us-ascii?Q?ChjFYKBYjRI0xU5h2f9xctJh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9aeeb8-e8b5-4af9-e62b-08d8cd8018a5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:32.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pEpj7ciL5X6FABuHb50Lu+12n8QEIAW8QgIAs8bkvLCTMu99iZSM2u+WtCYvS56/xE8ZRXf3qlKVsRpK1rhF7w9BL5Fsu7X3VEhOlw1FF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert loop to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 29 ++++++++++++++---------------
 drivers/target/loopback/tcm_loop.h |  1 -
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 274826a2b0bd..d4b008f5b7a6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -39,7 +39,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
 static int tcm_loop_hba_no_cnt;
@@ -106,10 +105,16 @@ static struct device_driver tcm_loop_driverfs = {
  */
 static struct device *tcm_loop_primary;
 
-static void tcm_loop_submission_work(struct work_struct *work)
+static unsigned char *tcm_loop_get_cdb(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd, struct tcm_loop_cmd,
+						   tl_se_cmd);
+
+	return tl_cmd->sc->cmnd;
+}
+
+static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-		container_of(work, struct tcm_loop_cmd, work);
 	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	struct tcm_loop_nexus *tl_nexus;
@@ -155,7 +160,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
+	rc = target_queue_cmd_submit(se_cmd, tl_nexus->se_sess,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
 			transfer_length, TCM_SIMPLE_TAG,
 			sc->sc_data_direction, 0,
@@ -188,8 +193,8 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
-	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
-	queue_work(tcm_loop_workqueue, &tl_cmd->work);
+
+	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
 }
 
@@ -1146,6 +1151,7 @@ static const struct target_core_fabric_ops loop_ops = {
 	.queue_status			= tcm_loop_queue_status,
 	.queue_tm_rsp			= tcm_loop_queue_tm_rsp,
 	.aborted_task			= tcm_loop_aborted_task,
+	.get_cdb			= tcm_loop_get_cdb,
 	.fabric_make_wwn		= tcm_loop_make_scsi_hba,
 	.fabric_drop_wwn		= tcm_loop_drop_scsi_hba,
 	.fabric_make_tpg		= tcm_loop_make_naa_tpg,
@@ -1161,17 +1167,13 @@ static int __init tcm_loop_fabric_init(void)
 {
 	int ret = -ENOMEM;
 
-	tcm_loop_workqueue = alloc_workqueue("tcm_loop", 0, 0);
-	if (!tcm_loop_workqueue)
-		goto out;
-
 	tcm_loop_cmd_cache = kmem_cache_create("tcm_loop_cmd_cache",
 				sizeof(struct tcm_loop_cmd),
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
 		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
-		goto out_destroy_workqueue;
+		goto out;
 	}
 
 	ret = tcm_loop_alloc_core_bus();
@@ -1188,8 +1190,6 @@ static int __init tcm_loop_fabric_init(void)
 	tcm_loop_release_core_bus();
 out_destroy_cache:
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-out_destroy_workqueue:
-	destroy_workqueue(tcm_loop_workqueue);
 out:
 	return ret;
 }
@@ -1199,7 +1199,6 @@ static void __exit tcm_loop_fabric_exit(void)
 	target_unregister_template(&loop_ops);
 	tcm_loop_release_core_bus();
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-	destroy_workqueue(tcm_loop_workqueue);
 }
 
 MODULE_DESCRIPTION("TCM loopback virtual Linux/SCSI fabric module");
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..437663b3905c 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -16,7 +16,6 @@ struct tcm_loop_cmd {
 	struct scsi_cmnd *sc;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
-	struct work_struct work;
 	struct completion tmr_done;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
-- 
2.25.1

