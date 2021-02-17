Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC99DC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C66B64E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhBQUdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbhBQUb2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKNl5l190231;
        Wed, 17 Feb 2021 20:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=vZuvKihdkgl5CTOz5TouzYFQ5sdHmBjDkEU29iNi872Mme+LBPViWp6r0gVM+b3btOPI
 mju0vX8NOmZOkZwFcK0r12ka/MaCNFKyEarZCCmhbi/Ht0zwIeuUgcXqmdipE5z8lNSC
 RhXvi+iQ/lEZ1uzKh5CIY48Jo4JJDF6Zc8KN15IQ4W7nd6TjEB4Vx1VZVkE+SRtf1ZF4
 d76Fa3w7/nzdEk4psGVHxD899yRLtq0EXDYThEvYFJqbXkvXGuorM+iSaCx1OXpd6NoQ
 O1QJrqzdozAm3UxUsmvdwYBpLJM+dLWRDceaSQ6jSJYN5DuWcNCdMp9+BhsMnlrGwr8r hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ6rN111860;
        Wed, 17 Feb 2021 20:28:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prpykf8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V26VXiAARiWx62AEOE0s3GAGhsP8oFrDQc/gx1YZ5EkT8dFr/E7WWlXYxzDxW8bQo6uAxcgvFfjcV5Cyki3zC8RX5UDRSMdrVH8CNrndQqRxLnIkZl3cipnFv3+EddwFUk8WfYE7S0m5LiOoWXV7Rtiv2Wk8SEMe6okLmNV2w43sZOIBShIUy5ukHbC9ozBcZmX08TrEY8Em7DZ5QEPhcv1YJoMVMlCGGJEJa12QeZClMs7pGpexoeVYuNyVsb4KdUbBwRLLcqS1o1cX3gtwsA3oQI8uAIJk3ehbGBb78qneDkqcqYur7zLmntZDrID/AmXpa8kFHJPgpfa+EduyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=FSph5Mz8ug7t4W5L9Rk2cb0afOPxER8qGIdaOvYhiGYNMheQvf5WYExOogOfzwSuC8UlN9eQbs3+mjXnq5ozR2rWwbywgv43yRnf5itGl1D58OhK+L6AGdCVIBW5v9krXWTGUesQkt7Z9bXAVr8avIJdNEOAF9/BYFLeKzvicYTYOftiAWx/4R46Cgu8Ds/InySIGD5u4fmVArQlk21x3qPui+w3hcEM13dxJ9mBC04xaPt5jm4AzePv9AjyzVBrfiC2elIB97UYdCZuM4yG+1ikVF9munTxkXiKZi2Wt2xWLxJpE3z1cQISf7Ys4t0ANXsZOlbNklTK9p9vGNiVFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEzbYzfKix+PmW79toGO7JSjYwGZC/E8Ru7vqxwNZUc=;
 b=XlpTnG42g9FAQBCD6ZvmuV8LKS3dJUGpnOEEnYKyyITADaqP+c3rdE3gOnt+H8zfXNMo6qJaVyrx+yvHK+LmOAE8kP5T+p19/oCtACDSf65+ikqAV2DyjA6kRQfvN9VzAJ24Gte9ifEBMYMsS88WpwYC/pMlhhLxWbWJub214Fg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/25] tcm_loop: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:54 -0600
Message-Id: <20210217202811.5575-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d140a86a-9390-4015-14d2-08d8d3829b60
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101CC6FB32165C5F0CCD4ECF1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFBTSRt93GS28wju/w2n//p0pXDfpjS/S1uDKdvq1hm7QeJCt2Xk+fg5kZ/FGpcFTpVyTeFcqa1anUbpwfbYVqCu6camVC1KmiDqIS4E8UWwk9Grow+13V+o6cd8chZUA+tqwbvFwRyPIcvysjzY7JSs0ZHJ3x8MJGZAbzwAkfWl3krvEzckLXRF+5wz9fu6d93wMd9M4jDrFSkIIILhosvaDdI3z8WyBC8PPUZHC6M4TSqD/iXLBCAyi/n2c4UBHS6hLv09K4GROQUMBR5ePSAJjpjZhVvImwx+Y2oFdvLxTZDOgH6v4kfPxxJQXMYSBC7bM+hPtqHBTcmRuagdqJsayh1HlR6nIDCk58wD01Kcv4zlZWKtzI0awoNSadPbxC2qL9a79L7IsO44IPNRkVzfLQjCMOobkwaYhMn4uVEoUyB6UXSjBZg6MkxqGHux9wuLlNPCuX+vWSa4nkgFIEX3qeCwMcr9CJCD8SFMXYRaycxlJAyj3PEEy3Fa5D6jLmoPbuyL0mnJONJxznAPDWLG5Mw6q2edSSVBUHtEBhaTBhqgrCaNpz1ckh4N1vxE/yVsjqsKysgYD05gggCFdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S8c+fl7GLYz+jbqCjvKHNABR5OkUxfc7Sr3kOSN1/mze/1IDTXrVnnKOS0EF?=
 =?us-ascii?Q?ECDrMg6B3suE5j0N3Jn3cHVxBVi5l8QXSrF1ffzQGqG4nOxOTz8AvK7rc3bi?=
 =?us-ascii?Q?Ts4uK3UXLk2FADxkCK9uoyf7D21TaYlz/XhV9wMB41ec/e+Qjz5cozuy9sfp?=
 =?us-ascii?Q?b6ZS8SQq4ZFH+fm1+57Ui9V5Wmi4xAjDBLqRtgdufqatuX9MhLlGbMoyKAm1?=
 =?us-ascii?Q?Yzz4w5wbuJ1SLWEEOkpS7gn23PLhU0tqlLzPY8bTKsr4i0vTOGAr2XCWyO0e?=
 =?us-ascii?Q?C2PA9/HWlpbinWbch5bBRlQbSOCMnOG8yWnu0b4glCxeKBxVIaBZJChnzfm7?=
 =?us-ascii?Q?3AJZu5w6wkgToGtjAkhbRhA1huAZvTxW+jQaYtXL7nMsTl9wAKl2IrUAsGRj?=
 =?us-ascii?Q?ZFy7bRBYzlDa6nryt9YllDW3DtEzMBduO8JykKIV1WIieiR3kk8eOHyrU05y?=
 =?us-ascii?Q?PiVRzATyRogCp0bIK8m9nN4mOG0RNLCwfpKodW/+60jqHYdwtOYvefanEI0w?=
 =?us-ascii?Q?LIR1/xvc6nlskFsrz5eDToK9iKk44d0w+asR3PX6SkylzpxpzHEqj/4UzWdm?=
 =?us-ascii?Q?ZNpgZppoGtT7D2IzcZAZbCWQwDjO+y/Ykd3Glo04OdfPhsTFuo8WsQa0zOm5?=
 =?us-ascii?Q?TmlzyamfAUlpk5mFJorwjjYcMAKYCpsk9nwJshQUp0XuKyL6WkHt5p0LCweR?=
 =?us-ascii?Q?2NkhGsRWeZzJakYRIyY7ecOq+pFkTpGEVy3I+WUNzwRaoNUHxlE4ofpAPIIK?=
 =?us-ascii?Q?aoQSe5hpKxsjCYjdd4sjZm65td6fvr4Q6le0+kLvTUBtfwclB4zeIsyU20pF?=
 =?us-ascii?Q?TqKajOEfBCze2Dr/wLNsO7Ic7ZN1l/oYsmoIp3ocO7Ybb04g0TcuwtN0v6cu?=
 =?us-ascii?Q?tOfqoyJ3Q6EER0gWnRU4FhFJRE0VRhMWHG5rkwSSUG81tiLt0oRKyyMNHI1a?=
 =?us-ascii?Q?tRNH6ptns9z/9ny6H/lGghlExbpm68nKuxhYHnQntrQCasfJbI3Mc3I3g4fB?=
 =?us-ascii?Q?TaMKXVnZI91kOpu5VadsIiUjPjJS/6Brc3br08A7Ge/mjthGwl78UboihDYq?=
 =?us-ascii?Q?Dt3oLdhKTuOZ9u2Mz7xE8o2R/ZO/Pk455ktAFH+ZZMSFK90VRVjOXonHc5cp?=
 =?us-ascii?Q?4lzeg+DoMleUFNA8g43JE6IgtCW/oiVV3Wro3RJjSQpw2QmysQ6VlQV6j5+9?=
 =?us-ascii?Q?ORFZuKdQWNtYHuKX3H7BaEFUm8efSYvQ+nacFgXUxMazEWPU/v14U5UAgnFJ?=
 =?us-ascii?Q?JN2t7TZBo6yKJQQNw3k254gg9zvrQNUBxxGKDQCjLEjXJJzKEbwgLj/Zijvs?=
 =?us-ascii?Q?vhbXgZmA7rVoZpxRDODYwoGk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d140a86a-9390-4015-14d2-08d8d3829b60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:38.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQpNAI8/0YNclj7RYOX+PJWJA1TFGIEcRhRa/SUN1XVTozuQINKjKrhero1Bet1tOEQNbYzh8qLij8kcT1e4KGzykvMW7yHXCizlpyHriwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert loop to
the new submission API.

Even though loop does its own shutdown sync, this has loop use
target_init_cmd/target_submit_prep/target_submit since it
needed to map sgls and in the next patches it will use the
API to use LIO's workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..461f4125fcab 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -113,7 +113,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
 	u32 sgl_bidi_count = 0, transfer_length;
-	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
@@ -151,17 +150,16 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
-			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, TCM_SIMPLE_TAG,
-			sc->sc_data_direction, 0,
-			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count,
-			scsi_prot_sglist(sc), scsi_prot_sg_count(sc));
-	if (rc < 0) {
-		set_host_byte(sc, DID_NO_CONNECT);
-		goto out_done;
-	}
+	target_init_cmd(se_cmd, tl_nexus->se_sess, &tl_cmd->tl_sense_buf[0],
+			tl_cmd->sc->device->lun, transfer_length,
+			TCM_SIMPLE_TAG, sc->sc_data_direction, 0);
+
+	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
+			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
+			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
+		return;
+
+	target_submit(se_cmd);
 	return;
 
 out_done:
-- 
2.25.1

