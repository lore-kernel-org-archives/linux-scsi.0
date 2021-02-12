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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AD5C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E9764E39
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBLH2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhBLH1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Phwm142696;
        Fri, 12 Feb 2021 07:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pRdQeo/sTOP/QBzAAVhwIqlkUihfgmwl0EDnTreNh9c=;
 b=PXPfm96kqRyMb1GaWVu1ciHAnflzpjCu2V9LrPx32gvGoPlU0US/gdaXVhvYvSIgALdZ
 Jt4hKrRt0UO7Y27gq7WvqOSCVt4Z8ZVrWb1hXgYPDu6M/4PFl3bQJwz5dNIJBxLdks2l
 8MjaVjQmtjPKrwa74/VKLOUtc9NCdwboPDimeUQwHNRacK1rB38WW4INQ9aWZ6gnOwZY
 qMZJrMZcF4ck5BJCyxJt2qRedOPidvNpLWlP2+7CH9JkAze7bXDWWVPpt3BBfYx9AjmE
 db/9P17wFvWW4iSrn0IzzLaXCBcXTSTFyrOoEY+SEnJToFJOjiilhAcGjupb5ejuirMO 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuQ012963;
        Fri, 12 Feb 2021 07:27:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/gCW0Y8cQHevLd3uC8njisJRsFY5rbabWv9R25G0PRRjCOXf9g8LP+IG8fzGg94FqyB4HsHi83gIV3RPaobmCPf2SqCdHIwKHAbjptl2EoOQ7yLdO8IQfKBQJSDMnfqiqPwgU+i2bXewv+q9soOV99f7g+b+Iwg84+9upa3GEJYQy76z7CCS/xjVZc78pZxM7oJuW4JdibnQ5ZtuCnrc7ckTXDDsbT+IxE4N8C8EQv7K8UTZIvmY4VugOKFF9MI+6atZfkVmRnTlqSjxrXgI1iCLUTbu13LbxOioUldb11WJaf5zHxwklc/2WPOfcMdQCyrAPpTIR5wbltZ3T3Q5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRdQeo/sTOP/QBzAAVhwIqlkUihfgmwl0EDnTreNh9c=;
 b=aq8qiJxtOZaEbsjQlSj/aEbE5GaMWm1RonQ4UvscXnTM245lY09OAIHwUTr798hvufhpeGF6zBOTj3TUzgbB/xzDhc0E+EtvMC3POslpp2sWyD+CarHzQXnm4luwhwBIVLRbKKsgRx6aOgqcVCcNTi7CKDqUiymfnETRqy8hn3/FF5xyddNRBFjcI6ZY8r6cNHZ6YT0QJNgO68XtyGzxiUop7a4w4fXz8G62A5Y56LiiuNCtmLM9NhQtPvxdavfm+36EA5EZzpBiLc0bzZgx/kJoaJ8eW4W2FLs+qfmchUGOAdSDFYSQnmIsYk247N5TOWntC2kwQYnO0Z2C3wMdkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRdQeo/sTOP/QBzAAVhwIqlkUihfgmwl0EDnTreNh9c=;
 b=ghyHt+cYjXQgRjD+9bauc7bGdj1ShMI4WnM0Gn4LR9ShE0GLRoqzmYdZxtv+OTEWy53lRBi8YQZJHx/uD9rqTtr7vHK3+K+L4r/9Z8r8KYNnMHEq+bbvHImpmCfj0nimOK/ZATPg2qLkQ2eZyA9BROnZC5UtDjY5FK7te8WWJo4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:00 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 07/25] qla2xxx: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:24 -0600
Message-Id: <20210212072642.17520-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb60b18a-6362-40e2-ec0f-08d8cf2795ea
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254834CF0B8964C523F45ECF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiI7YOFdW27R46BLcEhoZpdph044PuDQyXKoMS3JuoYUbrco31V/md3KVp+dZQeQOR/qCxRw6ImCkYs3cxPZp7/z4zeztkfSuZVTMm9mX2nXXcRNTbFN3KLEiJ2MuhbRxJ3O+PNGeummbzob4+TggWp7rq1KY8yN/ke8WzCekA4BBAsqqaSk6eQVYG2ZOXqgotrje4IfGpwn4AtC0qLmvygOLe6Qdb7FgL7XSk8UJJSa93VhmS1uUJFuVhQ36AdaAqnajs51aJ1SCkxwhEkEJjewD+dnHfVOWpEleToGihMAkMwwIkxwU7mrHNDooZ9iLjzv5ag/aACPgTAfkNuMNMQvI51P08Phd+H28OGoNvPxOIq8/8VbP2kbW27YPG557H5sX/O+e/wNq3GFpnsr8jAgCxHRRmocCYnpengEb/YuC2pNMmHXvzni7g5wQr8uYfsLUb9Ufo18pb3U+gedaPy+zotyH46fzaLvNLXf5w88tRMgefzoPNEx5vZSH3wPz3BebmqN8Rfb0ELQcNpb2vmg0WcCe22hbaqK3l1hZ1w+thYRcmaRhsKlLqxEZ+2feJeqQEKb7R/Hw2SdV1Gx+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ghUwlXkdeGI9m6Ayen3QKdSIimiSRVFPZDiEcurhoyrOoLMH8drpQp/70fdt?=
 =?us-ascii?Q?UuWTpEU8ZVCzZwlnJJnZyGxCMEatReRcONmIVR4+uRStn14RA1ykdg13o/CF?=
 =?us-ascii?Q?/XTlw3lpiaJVdGhV6QpQ2t773iH2nLAhCGV6xsMTJHA5Wfm5mzsQeGHYqrUi?=
 =?us-ascii?Q?NG2OiklvmPgKEDsicvaQzxxnDIduT132BRjLZvHwU/TmHSWMQ/WorjHUTZ1N?=
 =?us-ascii?Q?IXCj8t/s16OtOzWePFlDtquPcpb4M8sR0FmBAKuuIvAV+Zw4/Q87wh7OiON7?=
 =?us-ascii?Q?85+QLbzCnjHEzIXygHhjm39pfKFcKpAgr2yA2s0PU4EPCy+bCH4FDoq2GxDb?=
 =?us-ascii?Q?RgdcwFlg3aJWq9iQ9RiqoB10jMjMm3dVDWXhqGYSgF2NHG97AssnUqieyASr?=
 =?us-ascii?Q?5oXeFi/MJL+8zPdBtrQmPSCb4l0m5qY+sERjuelSNRElGUl8pCLwEWz7n0tm?=
 =?us-ascii?Q?dH4DxcEPHn8Lq/4Ig60Bv9YVUuD4f2AaQbfV0lwyDyaSixSq7i6brelxIbf+?=
 =?us-ascii?Q?kUC9BtxQGUHQzcq4Rkr1dAfwhVrlw35eIgDOjaYHoWdO3rnJ2tCQBthqve4P?=
 =?us-ascii?Q?HOncpbYubAKF8lbpShMgHxaEUZS5VI2arfzjwpE74DCC9vuOsPUNFBl5WSgv?=
 =?us-ascii?Q?/OYvmeU2RnOCr+bsCbYLFO/g52Ebq0kA2L4HhqbjSsbHKOaZRsfiA2DWAehf?=
 =?us-ascii?Q?+ZHGWxL9akn00iMRY7hpAaxtBdI2bLDNOzWf5lVJu8c20S9MyTuGC795d/Z2?=
 =?us-ascii?Q?hwB8TZ9iv+hqSKYRTlmBFt7FNXy5ELbIVqTzi9LiR4fLQ8x1IzBhCrGvwRwU?=
 =?us-ascii?Q?HG0KJglOkAGiknCzQa9aiPYZxZoSoQnmUXLwyDbqSySVB+r5+lpHP4O8s8mg?=
 =?us-ascii?Q?r2yZTXX/9+eKqnKvaBGlDP4B/onqqlAM1OtZN3k6GAFDXZT/vPQXvbBpSXz5?=
 =?us-ascii?Q?BsJmH4M5zgcmkn9vA18nxricDk1iDs91aI/veQaRwws3fb1iiXjynKQWenam?=
 =?us-ascii?Q?H6Wh60nuIY0Nhj8ahc5NJhVkkrXp6ta1SQ7KLq8ktG0vK9PjK3I04/ECsIN7?=
 =?us-ascii?Q?EgDjtg6hnpoOjWgaofEF+A5ax47Se6ye72enfj31TnhaqCkausJBvVnTtmmf?=
 =?us-ascii?Q?6Xrlp4o5c9zE08RvSWtiHwX8NKPkSnuKgZH2toQH3Kgd8j9WBHsQXMN9SXIG?=
 =?us-ascii?Q?26jjwlvUUDeZEV+NT+A1+LKHLk3luI1z6YQCi5MoHDi1wXmt1ZkFqKz82BLI?=
 =?us-ascii?Q?EnLL7zSTnDBX+00kcAUIy9ZiOlHEMGOPDnixaNj31dphTgClavC8OaetNw6Q?=
 =?us-ascii?Q?Yk1o1E+AuGS0ihid707nGosH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb60b18a-6362-40e2-ec0f-08d8cf2795ea
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:00.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8YEWHGiDqpQ9MV0Q7m/EVW9Lj9mjaIAg4voSKD34UNzZM3IANiGSuWGetzUDcDXOQ9RDk3leR/EUAOIJSEAujh/UYwSeHdR3IG7RlnVJ4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session.

tcm_qla2xxx uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b55fc768a2a7..56394d901791 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -451,7 +451,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int target_flags = TARGET_SCF_ACK_KREF;
+	int rc, target_flags = TARGET_SCF_ACK_KREF;
 	unsigned long flags;
 
 	if (bidi)
@@ -486,9 +486,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
 	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
-	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
-				 cmd->unpacked_lun, data_length, fcp_task_attr,
-				 data_dir, target_flags);
+	rc = target_init_cmd(se_cmd, se_sess, &cmd->sense_buffer[0],
+			     cmd->unpacked_lun, data_length, fcp_task_attr,
+			     data_dir, target_flags);
+	if (rc)
+		return rc;
+
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+		return 0;
+
+	target_submit(se_cmd);
+	return 0;
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
-- 
2.25.1

