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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC00CC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F6564E39
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBLH2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBLH2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:28:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7NpC4169882;
        Fri, 12 Feb 2021 07:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=Di38g0EU7uFYrb9BtwQ5QOAAxOBV3jvEwwwFZfYEaPSBAK/dKlkNfZwQpzYAkJeZAbKW
 XNJ4HVUag0G6XNLWbLyVnqSgjqjOApr/uKtEDV8Z107qkMbUlUG1w2w6aYmMGabIrHZK
 xGynzmYIKxOpvi12SAAE514tu4x7CR2rGmgStYq+jnaD0FUMoTq7ZYqgugNBrDgZExSY
 K1N7ofVd3hcKFm/sxpc2yIUD8bBjeaP2+/mozj/DpUfnGvg7JAVpaZDKpxJ3gEGHRHEJ
 rCwf20lkWtEPTL2evHYCpsGqkimap0E6ceC+jmCTZsMXdlhu0rH2KEvcY8Y2ei9ReiJ1 xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrna556-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P9RP168446;
        Fri, 12 Feb 2021 07:27:07 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 36j5214tpg-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOn4g8fZd3u5TTMPXMyjnpGtDOcywwX82now8j16FCyDaiXbvY4Lu0E6AlvSd3z0n/rE1Gx5cn8zSqg7xqvtt2afNrCSHXCyyCdXzLX3cHQkk/KINs47yENAskyj1JUgr/C2/AqcDiK0W+ZVfbYaQoKAehAq6F0s+xuRnXBXQCdyqvcj6jHwjDFzJFhqjpakQGYBYio9/bu5iM9sUCk7pi+Ln5Oe0aPRydck7l2xpzXI4MVI9p1QC2y145AEy7OSBOyicFOwWx5ir5ol7pxPKLkvK0qcfr01kwNHohSMB4vb45HoDWZWMHJpqIfwGOF5UaCaY7g+dM1db/43YUTs4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=ll5WFSKOrsSAtCQpW4qL66tP2VKcnRi2/k+63fIXkN5mD53a4C/OwbuxDDdR/R/eUg7WEUNN24qrbvEdNKl/mllzRd95Z9AFoX4OF9FmAoUs4pf/F7cJHkXtxUtdTl393tvy4A1qDN75FJvaj0ad5sR4ap4ZT0M3b2eA+g/XWRn1+713nwO/w0u48YYzLPbkfHnWScMhgYW1rB6Q/XjA5zwWoATg7W0HCOmuvdNSHVfnJzM6bqU1kydMutoV0ubMjVx/dSuj1jlQcLXETPk80nF7oSkX0yKI6k9iU9cJa/ADDLXAsXMlsz/cfaIeAbNngAm+tEsX/ijdvxD0lLZ0bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1frQuRMui0cZxPjQIOFd5O6A6GKjiwmO7Nx2OJyie0k=;
 b=znpWf2ubT5YYhvnLGh+TeLc5x7DKZZwrbCccHcR146fIAPAimoCr5lsiY8kcnuQG1DGTCs+GIAvscSTnB+FP5WD7Ughu08geMYisUGcDhJH7jPWBm81mF1FmDYgUmLPPrzT2uusCTcePatd5IzTALWJ9a2fOyr22r2+ErCndoTI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:06 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/25] tcm_fc: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:30 -0600
Message-Id: <20210212072642.17520-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2080e538-cb08-48aa-b90b-08d8cf279971
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254B64438BE6C22AE173E78F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehw+zylvly3IUoQmvx1DgW05Rb2wOy9d6jWULC7cme+guOtY8RS6q39dgrwF9iPb84jQkR40e63A+eASL9/o9Ce6aAdm/ES6VxeIqlsDCw6Xzrmv4mSTZM+8Xx8bIY4pjjJ2/Qsyu/ec/3jB8Gzz0IpUD7cG1cxnrnrbARHHK1tjkziTJOA56m7gTuNBJ4cYNmbgFg6FO5L5h+BlHMhOHi7B74IKRr66T+lSZTjsBfnJnFDgnmRNSaU3ueOylv4FXwIQfUC8QgmaK0S8HljKuwseznGT4YkTwgVhlb/b3LJDVvuSb5XAKGXjDhPRanF7IGMtEmT5wuSvOpjY5u6Y4n4uAUUgKGb4XGlS9ZIu32xJlGEYNS5Pq6ltAaLCCzD+Yn0SkU7sae/BGyGxrEVYlu6B1F8GNecml65l2eS9sYP6/YcJkGE61dW0uj5RX+8SMQjB8BBPdXYs6BnXy5asTb6/D+NGo6x+slz7hl+AcphiKW+cLXw9f+kqi4E6J8uk27UBfOm3U2OVZO3L9iHrKVPN7c3ycTrNRWulY7eeqCKWIxScEiX7Du8vUV5Y0EAspo9Pwf2iJeKSFMQjsCu3QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hsYwM9xO98xSBirt6/QqePkGGZdFPAkGwjEXvC7mx86P1XmFyIitksnvQq7H?=
 =?us-ascii?Q?QTAmdLtT0OT2IH32aOMTOqY+OOuU+e5vTZpu51wskA0PXa5W7zpAB9g/93To?=
 =?us-ascii?Q?Ayl5w+GrP7J9jxWemQz65ScPGupzGXGM2gBxCP1KfXDTZ06PKI7LvJad/TDg?=
 =?us-ascii?Q?gJik0W0Zhnsg00aDmtBx7vXPtPKGMvTPg1kQ+v3OvVWvsQGTuCio7MVySgMc?=
 =?us-ascii?Q?mJ7ZSOy7IgOz2RdxQ+ApowNITlk/ygPZtsVobyBXwebsymFq/P+3cC+uXIdw?=
 =?us-ascii?Q?VAF6lM2oCkv+mPq/Rnp13qiwAo9tiigwjVgY5Zn+P9reg2Hz6liTGBdrX1WR?=
 =?us-ascii?Q?PnuNWXP31tTnjz95N2lTsUXeCkNMLsw6G2oYxIDrkAhGByCN3gkHr8ccGJTu?=
 =?us-ascii?Q?rzJpTh8typeFPx2hYzBWSqMw/qLq1x15Vnbw4xnojRQPRxK0hgT8GESOMO34?=
 =?us-ascii?Q?b5AjnTAwR/LcNAFuHR4JxzSnQkk/hlt6EoZN4OXI55Zm9fefU0bZFmtpxkH7?=
 =?us-ascii?Q?1MwIKIUS0AsmJu+mFlUrVTibMtAZD/MdzYRYeDv5VncvyDT5Kueq1gC1IaYI?=
 =?us-ascii?Q?8C9HfrQzppjnHe7/eN6xGikurnudk6z/gJhOUh3vQVI0Yift8GEaoXug/BTv?=
 =?us-ascii?Q?shALA6/83b34XQnCZEeFwNQeheRmNPpGiVkqZMp+6BeT13pvFqgYqNDfgYRf?=
 =?us-ascii?Q?I/p3KrCWy8mKOxP6V/Vca7DZBtAfetGpGf1Wb6my0Wer8U8sQi4fM4U/udtT?=
 =?us-ascii?Q?m2zujLrmsAtaneVtPRqXdoXEA7fwtkOlXUQjTHcOqY6oWZVDXD5qo0wanrGl?=
 =?us-ascii?Q?V67ZIXbSIZo46Y7FWgaagCPz61/SUOb+MX7cmDrnRVot6cQldjqY4I+Ex8Zr?=
 =?us-ascii?Q?K2xkUz+UT6Aq6nEixwtQg+gJ996u1+KltXshyl+W8YpOlhX6NELOyMz7y93Z?=
 =?us-ascii?Q?eO1z1bZfARqsgLIJ6X0OYGqFbsSM0/Ves/WSuTRIVLErKr3e7ZvsEhSc4uvp?=
 =?us-ascii?Q?YeEQzOjaEFC9iU0O+iEiz8HBJyrthu+UwstHmiQU+TvJedaBYqZpRZ2SeN2I?=
 =?us-ascii?Q?ESEgw7nE0lpZrLpPcA+kgyyR3rFVmT7AFxUGKA1QE+yaqpZzpPyq3HcwZYpW?=
 =?us-ascii?Q?Ep7N7x9YR9roHuSWssbznuYpDWOmshWl+5tCiGfz7QKqg9cgtrTumzcDGY9A?=
 =?us-ascii?Q?5zbGVCaA0cFPDiuF8KzLOaV6LXPfEKxtz+3ru0yEECukOUTg2yjJq9F3Istn?=
 =?us-ascii?Q?PnKxQmxQH/+McxAZIXg3h7BPj4xPkc9McJTyhgCplcZrf5zYkAlvEYQE14aR?=
 =?us-ascii?Q?eT4wK9kG2NPnxvNlWl7+ydZP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2080e538-cb08-48aa-b90b-08d8cf279971
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:05.9405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL5TI7CCOMoOMjyZuWzFwwNoeSdCs9LKSGbEDihWxDLfuDPyCMA2eWPwkGy6cD+DADAYH2kS9C/YE0w+YhDAI0rlbkO+VfmwWClcNxvhBWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/tcm_fc/tfc_cmd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 768f250680d9..1376501ee3d0 100644
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
+			    &cmd->ft_sense_buffer[0],
+			    scsilun_to_int(&fcp->fc_lun), ntohl(fcp->fc_dl),
+			    task_attr, data_dir, TARGET_SCF_ACK_KREF))
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

