Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549B8C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8B064E79
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBKMey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:34:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhBKMam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:30:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCPtFL050954;
        Thu, 11 Feb 2021 12:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=bRMukegXz2fmJibGm1wRff10RRcD80Mk3Pklmn95x/s=;
 b=o3MnCDfen2XDbHWtD0uKZAuQUcDVlvjX56EULqb3yNK5R/Hh+Hs+LuF4JoBrR9rPMnel
 4Jd39/0QflZkisCAXHCHLZtMoPKD2pk4i7ajkyrCemdt5WQLUB5aYZvt11yCqIp7dOwy
 RUOUe4tugtvytJKjgbKopouQCQXYjXyefXKURVfTeu9hMZvXBKNaSbyoIoA9hBM15h6q
 aPL6/3jsvgqj0pqAFi+ieg2ta8m1S5kKtq3t4KG7g33bevnnn1pHLhEWD9GpfDhDYWUb
 K1EhECeJVg7MKPbT34ecO3CpfynWi9B8nXoL38IZ+3QD7HLAtGmSM/7coQZSeC4YrfG0 mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4upws4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ2iF193594;
        Thu, 11 Feb 2021 12:27:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 36j4prg5ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyiRRjfkWZK0d7uArGHQi1wjSoYujRpmAyCttgiweIaDns8chAcr6b8vKviRp+jMK0/J8PgeYsKqnRYkJVZmCGps6VSRc+cnv8FvOieeYMzwHstWDoN/x7ogVHD/0qpgbdKrN+5z9X8TL3VFCn0ClDQQeIclBz9/PWxNC8BkqAUPq6fWwz+ZTe24CBBRTbEwM1bTHMJyjRiIEMxj7IR4+OZm+waq5slZHtVSrPnZSnpqUeG98tXi6mPn7YPcEddXnfOKx78XKEPmNzF0CnbfoI3+K9zJg/6ReGLzxSuDtrvrhkruyrfK4wl8DKJtL8vcGL4gjqgwMUW/+0R+VyFAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRMukegXz2fmJibGm1wRff10RRcD80Mk3Pklmn95x/s=;
 b=glj3pW2TN1ALqVbhVBZ5GOygPRX496HnPasvw7v/CnD8wfEiFpzl3QgaQ/nzmd40ZYVmLUZ8un6Ch8rJbS+XWULUk9q1DkQm57KSMjHuSqP9lba3/h2PY3SQV9zt0S3moBMwXUHdRq4K8gzXfQ8NjHMWSTrVjqTXvDbdaQtKoERitnRNy3yNnl9qDuUmNxasUpiI7GMZXZn/3C4zEt3r55dMO6ejWqqHTDyuOEF4St2433VW9j+aAusLxp9a/QdyB221BqNOsVqP7/9iEi+9w5IjAvcB5ZdfPrzcqEvTD/CWqGqci0Vu9a3NFyaCc+ncozt9cbPwcZq/ReiSqTRvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRMukegXz2fmJibGm1wRff10RRcD80Mk3Pklmn95x/s=;
 b=Paf6sDkyPWgsPni2dcv4JoaknZXxJJJPeS88/dA6UZ+QlijrAAY107gXm7HyA/03yqoOyl6+LPO6qoqzwjb6KGRwlwkd7hvS538Aiks6O4RyYdV/VXSy/6SKSbP03jzso6AHHrMpzVUX6syPNNV8TvMN45Ei6jodUDIgR4XqYkE=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/14] tcm_fc: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:27 -0600
Message-Id: <20210211122728.31721-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5391b207-7031-44eb-f401-08d8ce8874a1
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339B53006CEBE905A405CC9F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJ/Oz4bv8E83KrU9d9IUbB5hjhmLzapJSvvO7bTh7k9u8Hw3QUJqFAuBe90HMS9sOcfk5KRFzNqJLgKC9I4YPinh/N3DMs/Z/CiS/UO3lj7DMiPeX8MXeAXEsyrYz3lRHLIY1Xy6KLuPi1dV2+nStaP77tdbdl6KwS7mgcvydnl6GrGLymRNuIScqmukeXbt9EyhDE5DxGvO+rPPgYu/c69QLjOg2DmhNOmioGtSAWwPkjc8sEireciacD5Cz7zSbYdb6+sxIQYxzCJ7HpnnaZQzqd5B2toQO/6oFV9qhsEd7oOqSkNERmfRlUrJdve3F0DKzc63G1ZKOF6WVOwCJZjImsXHpMk/citA2WAy7Y/GSlQ2Uttbj+af5O4siJFQlpvb9ItgV8wfTJD9zPhni1O77GUSmd4x9Ga14TeFfTR3UTSeSecnfanjFB/f+lWcCEN5Bz43i+voua+6Ty809QgIjVuj/lcKwd/DMfVSK5t1yhd3rhwlY2xMjw7yrGH68y9TfJWzgizeHnLHvD3+5hMcCPlapJc6cYBl1K6H1lVgv84uXUmrIRfqwPUbcG1m2EDlMP16+MtGaAuMN9tP5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6ZDHEy0S9hiZG5OAd4nbnu69ADr9oN56Q1lp7VtSemXG5pxQrXbXIlDdgFX5?=
 =?us-ascii?Q?EDzAyjNUogvR9GJ+f7ThyUR6T1ZOzFV/zD2CuWiw8PtvYOlU3B3TxxTjnNfi?=
 =?us-ascii?Q?kL9ePxmCXqI4f8qCfq8fTEuu0vr+L4eEw6EGRG90ce2gWjj292SKoTcQdVJ6?=
 =?us-ascii?Q?L88z37e1TXwZyQ5hHoOAba6XNHHh9mgjUAQgF1WHFcC97ktcwFWmaY+9QC8y?=
 =?us-ascii?Q?WZ2dSB3rOuKCgCYssREzVfj7DmNujYEPNVHFJ+ls/9XmlereWcWq+65r+1EY?=
 =?us-ascii?Q?IvdaK6MA9ZzPRvkSDk8Re63s2VZEwGs8GiFlprK5AwQ5iSCZwIhxXqdO2ovz?=
 =?us-ascii?Q?sAgogLE8yx73WWaYFI3jecuVzdBwkLue+T1QmV32pmLPV18/8Hxv9fRateBq?=
 =?us-ascii?Q?6gzhWiZmgdqTLJlpJvQ4ZLAGz8h3zzpzphaRfabx6lIEO93d/799JR3xtk9K?=
 =?us-ascii?Q?y9lrRu13K1A/PoL0WN+j/Ix5ZTfzjBgtHd/YMRqDIlPCT5XWZ0jmlh1wgbE2?=
 =?us-ascii?Q?lwI0GC+x/6IX0/2D81c2YrCJLMUWgglHAKCdErizVUNvbjHBoYoeTnfzMpNK?=
 =?us-ascii?Q?1BrWIKzf5czxfyhpRFhdWEu6AVcQTZvTOtf5c6VuowhraEqiV1PNlwtgsSCP?=
 =?us-ascii?Q?bstqjuv3hLK/ZE8AVv8UfbeLyUSe/eE3IqRUclg/WKsj4S7c90QqnSaMcb1y?=
 =?us-ascii?Q?LXM+KkqIvhf/0ATNzPTLLVaTq8RnttJwtHxmYY9x4pjAySIa5f2DOzHuyzU4?=
 =?us-ascii?Q?rdGLNU+islfWoXnEETNl3wqUi3e+aCOrQsZXAYCf0S8tiSHhmwlMwVkOYFFa?=
 =?us-ascii?Q?ODDaBg18+MUAjpMENeJNo0Bnj5XkDTEJN90lDKriAIesQAnhBs/Cwiqa2Kkc?=
 =?us-ascii?Q?mNT5Wtdok22w3mHoCrpgFQcvOxjcs9W+55plBCPuPb3jUua4PGCPFSlDoTHs?=
 =?us-ascii?Q?aq9fhI8lxQ47n3AthDNbPw8S4To54mv5eO24BdW2c82SAkAA1vOpgXrn77Ne?=
 =?us-ascii?Q?fz9YxZBJ7aTwF/bKD+riJzZU3YH3tDzJZwFlYq6DS78uDTDJmpp0f5VMWiJg?=
 =?us-ascii?Q?pkpPP8LnN4nsnFfShIOY2AlhxW/H6a2OzRcNFLB5QzOoU/wzaP7eOGF5xLEf?=
 =?us-ascii?Q?8Xj3Lp/jBUGt/4BMmkNcYoLV68X81WzkUke74GFBO9vRtKKrSLYzddisJgz6?=
 =?us-ascii?Q?uLPNWoYahKFoPHJ2j08fSm8Wo1dJEe635YW7dgqZMu4gHLiI9LJnSOi5EBlQ?=
 =?us-ascii?Q?FWpWUHFQWoxEojK82YLTR+8xYkOFpjqukluXuYLKGr2qCI+OuzIvdthA9O0o?=
 =?us-ascii?Q?HpH8XU7fNsNG1P9SvN/JUeCN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5391b207-7031-44eb-f401-08d8ce8874a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:54.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xQSMi4C4A56Jnv8oTWsDISwaT7kDaM/wqgq532+KlpK7I12joWMCKM1NsuDrzGNtw0oPYRnq7wU0O/kgN21uKDDsif6Ys6PWjWfWuI8AbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session,

tcm_fc uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit,
because target_init_cmd will now detect the target_stop_session call
and return an error.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/tcm_fc/tfc_cmd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 768f250680d9..75b258fb727e 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -543,16 +543,22 @@ static void ft_send_work(struct work_struct *work)
 
 	fc_seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	cmd->se_cmd.tag = fc_seq_exch(cmd->seq)->rxid;
+
 	/*
 	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
 	 * directly from ft_check_stop_free callback in response path.
 	 */
-	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
-			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
-			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF))
+	if (target_init_cmd(&cmd->se_cmd, cmd->sess->se_sess,
+			    &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
+			    ntohl(fcp->fc_dl), task_attr, data_dir,
+			    TARGET_SCF_ACK_KREF))
 		goto err;
 
+	if (target_submit_prep(&cmd->se_cmd, fcp->fc_cdb, NULL, 0, NULL, 0,
+			       NULL, 0))
+		return;
+
+	target_submit(&cmd->se_cmd);
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
 	return;
 
-- 
2.25.1

