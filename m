Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806FDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B65A64E68
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhBQU32 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:29:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52960 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhBQU3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOe5s017886;
        Wed, 17 Feb 2021 20:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=vr2C/jOPfX7aMPsri3xoH/RkmbMraheLlfYAxTnHSlIgChx45gKq7x5e8Dv9zmha+6Ne
 31n6l0SzkarFKEw2D4QsD2teRT/K5mIVZ+ijYWcVA1YDiN3SbM/zGRClXbpd1cHz/7OB
 VpPW5ubkw2zq21x1lAKyYqRYYhb5issFzGgdacjtK/z4wyNnJJvWbrmKs6inBVZZVX3C
 AvZQ941r7U2ww1KWgcDG1C0BGKKJgjULzuOc3b5ZFWWK1EPO4AtBOOuGQF+WhMOZxfxr
 Uc1QOJUK84ErQ7xt8ctXrMMy5vYtsukfmYchmKFx+hvEbFxTmWM8gzRTgTKCKl5WiUT2 zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49bbwwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ61d111852;
        Wed, 17 Feb 2021 20:28:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 36prpykf3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEQrZ/f1XVb/ESGmOO5Pz2MpvaZM9zfTDxbMuQaaYNwZVgAgRh9CTRBFs8H2HHurgPS5jW5qxtUGwgWvZiDGleHQEHe+uVbHzai/Mz3PEIeNrLcBmGKr2Pi9w5m4kg0Okdd5fj5b1Mq6Bs+Y9wMEcAl/xEu30sFdk5mEexA9AKDMfWN9j+TyY2tFRid6UFo5qS28Fij0ixf0dYKoTtRPTWP1yPeqrRwdWVjanq3QullK7Ed/hlFw7ljlNAB3tITTKcprWhUi9mZdo4SAqJSL2cnU4lsRYrmnFPYuaptYyEOTEi2a3X7SGNhH3z+rc1vQOL9iAHrW/LqPIUc3jxbhdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=DNCoOIGwWkoGNV7ibHkO3ImzYi3e+iAqi1fml/RvYL7rLk2ovqJlm+9sK5X2N9mD4ND8uLTBdCOwwdQwmQUuRVhhA6cuyWtNNd7BuudVxFoEN4skUjlM3PVGeSCX+AnBdseDLanUqhfq8namzHZ+396d+V3iQK86DAJoFALqavVJm98GTRk2KohUp+9Xovf/EWWCLu3/2YxAGF4dbNhDuw/Xnz3hPVS8mveNMPxV0UpWENqn+qnhQ2kdoKjv2ICXrOysiz+YkbJrxwhU2oA8l8BC0Q05Tdn/NmkcTzbfxehVYrHr1z/4k2YFeeF72/e1bkvmDpzMrXjHKa1I28Eyhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=sM8J7FZE4XHUUpVKUMkZvM+MTNeSIMcnmDUSeg2fsBtW5U4CcllrR7usw+ByVspkoCjfR1TzCM8lsBD+mTYW6/jyOpJMtAmDW/VApPA47RER347ZWHfBkZBgF/F1KDW7EUPH7mYdmB/wt1rd3Ib12vmUSk4kQD+LNSldzx3JC9U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 03/25] target: rename transport_init_se_cmd
Date:   Wed, 17 Feb 2021 14:27:49 -0600
Message-Id: <20210217202811.5575-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84ba6441-a6d5-4264-81be-08d8d382951e
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101B9C2BF2251DF3C61A012F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTAkINjX0z5/ymTr3mC+6W9QLZ53nk0NsozxMI1GEDiQ4gFlFNcI+nHN+kkNRulcgyy0jNwh1mBA6sFP9W/6M4uFos40XeZgNnlr44uRyf8gC3aVaCnh7ILbcxduqMj/XrgAomPCVt72rDh8IfpHf0kYUDNyqFrY7+N/H38TkAqHHNhCFEO0FN+NhV4TUXkfKQHwlZN/x6iO/tDtBqZTX6SdG6gcvhl6AYFWQrySXoopcD21+yXqP5zJUO6AgquMJYuuAIyA81ULA4Yk73MQN0EUEQWZf2ctxMoGwdikAaFXtbj383rEe2PGdS/LiZh3NAtrRLydaREX2TS1H/ui9nAaWzkAVXNn+rdKvnOGCGgWZJVM9Cn+IjilRP/RcAGb7SolpUwFXRk7sY8wcYGWiw/M60OjfpzKFjA/aK+VIsNWWtzBPdDOePUS85buxaOX/nEPURLCS+CjJ4kY4/mj2139YsMsAOKzQjVei6FiMM00Tp6Gj0GCDHOsusdl94e7VbxqvQ53ZCbCAc43cQkbznA7Qm4szaSVEfcXKVJrxjK7E7ik+UX4On5oHIgVt8hPOmr/NWq8rIR+W+ITXcfQhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rTONyLHOckUcpuDTwzzAf38lxbYwNU4lhC3BOyVSGcKNwNCpz7uagLvkI00S?=
 =?us-ascii?Q?3+VYjuNe96/JYNJem0bQMsVET8e7iAqQLlfdMmiD426hlzlWXSJiJJIS8eJV?=
 =?us-ascii?Q?lzq7keVcRPzuOFcvsYrXEhpQPOBcpGG6q0dLY2/04qWpIMMrXJU9/Ko6djTp?=
 =?us-ascii?Q?uSNXSGhFQKPmZ8PvtVM9JVuTUk7H1roIagnPe4gkwPOqzs2Av57VnaSeqROR?=
 =?us-ascii?Q?aolu9kvr2AmV1zTocnoyFVjDeGZpljrQl4pal0atEq3YdGLlHgAXUgAkadjp?=
 =?us-ascii?Q?mvKeEP7TvbuVHbynTtwY72Tb+DiBoe4O8fcWRlD0nZinmV5Yjjn5WJtLJA0/?=
 =?us-ascii?Q?teIjxE5skcDLOHCLoOd9Jdb3cwuNay1dPeur5WNpsRqsBmbQjeUymxH5A6/j?=
 =?us-ascii?Q?Q+g6W6OzYxV063gcoEJ4wKLey+8zrnU4NaQn0EfbXPXTqu5ZwLktJlEv1JxW?=
 =?us-ascii?Q?GScgRZIDV+ETA3yBmf8+d9VZmbaP6UZUlk2hxqh5J2DPtADcPeFoR3j7r7/z?=
 =?us-ascii?Q?kkgzBDGIMbVmCbrS8Vqm9MiWCOT5q+OXwnldwr9p0baRvcw3gKPweAGPdFdU?=
 =?us-ascii?Q?z+p/y3pMILN2yDNXD49uTI5IFaoBejmN+asSghLztgfrTytcGRE/dg8yDs1c?=
 =?us-ascii?Q?4+0bkhy0qj03H3vSVxWv5FKg3QrtF3fk2kxlclq8lMDn2dEOyxYQjiR3umy9?=
 =?us-ascii?Q?b4PkVNoTaooxN6GP/FID/nak/Jjg1hd3IEYbt1RUN7EI8vBzX3deoTdc3xhn?=
 =?us-ascii?Q?88ypBrz8YtgoIysDZzCuJkGxHugKcR4gKblrXEPmsg9jwimzhwH+gHM1BmC5?=
 =?us-ascii?Q?7QX/1jf0Wy4FBU3r1sZc8HaS4yGjt3YsdpOWXR+eusdF+v0rtQcpbJq8oEKJ?=
 =?us-ascii?Q?MryTydZq3hxIH4bii/JGPaLwxAUIyZyyt2PuIVoSa5nb3eIvq4FWCEBgj6aB?=
 =?us-ascii?Q?PPPBvT1FhDNQaBVANJeRm8TRCr2nLugdxVotVJpVana9bA+p9n9/Vlh8Ac0d?=
 =?us-ascii?Q?620nF1NTerWJZUTGHjmysTRIE3vipxQqMlmmEpW9FLFeIHAIzTlSZUchcSth?=
 =?us-ascii?Q?ekAV/fYudYc6BinDXv2jQq3yjE9hLE9dEjL82EoPm1n1JdFypCvvjyowaq/i?=
 =?us-ascii?Q?S86boJ54l4IOeg9p//vxrpDKx154igCFF4l5YB2+rmTrRQO/aP9aXhTpKA2d?=
 =?us-ascii?Q?wmnPJTllOPVDO+Qedk3oS9PNh3mdiQWglOiruKTI+MG9L1e7bK9w5JF49gPB?=
 =?us-ascii?Q?9eAisMtTRSTDJU48cvHNmcNlpuPRjhs94GAOKwcV9yHL7WiNi+qkQaZBl42W?=
 =?us-ascii?Q?O24gIfH1e4f6/3AjJ3+BIRUJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ba6441-a6d5-4264-81be-08d8d382951e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:27.6377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QxG6bRiU8e++fUnnp27B488MvDYZRRIvV3ifNfyph7YerGO5MbUMq8WGXidBIU7DCJeYEgSajn8hj13i8OzyshZNV4U493LL/d/t1Kdtbn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename transport_init_se_cmd to __target_init_cmd to reflect that
it's more of an internal function that drivers should normally not
use (usb seems to use it wrong and iscsi is that weird guy), and
because we are going to add a new init function in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 16 ++++++++--------
 drivers/target/target_core_transport.c | 16 ++++++++--------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    | 20 ++++++++++----------
 include/target/target_core_fabric.h    |  2 +-
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 518fac4864cf..f2107705f2ea 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1154,10 +1154,10 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
-	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
-			conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			cmd->data_direction, sam_task_attr,
-			cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
+			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			 cmd->data_direction, sam_task_attr,
+			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2013,10 +2013,10 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 					     buf);
 	}
 
-	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
-			      conn->sess->se_sess, 0, DMA_NONE,
-			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			      scsilun_to_int(&hdr->lun));
+	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
+			  conn->sess->se_sess, 0, DMA_NONE,
+			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
+			  scsilun_to_int(&hdr->lun));
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b5427e26187b..013f4a5e8972 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1297,7 +1297,7 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
  * Compare the data buffer size from the CDB with the data buffer limit from the transport
  * header. Set @cmd->residual_count and SCF_OVERFLOW_BIT or SCF_UNDERFLOW_BIT if necessary.
  *
- * Note: target drivers set @cmd->data_length by calling transport_init_se_cmd().
+ * Note: target drivers set @cmd->data_length by calling __target_init_cmd().
  *
  * Return: TCM_NO_SENSE
  */
@@ -1369,7 +1369,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void transport_init_se_cmd(
+void __target_init_cmd(
 	struct se_cmd *cmd,
 	const struct target_core_fabric_ops *tfo,
 	struct se_session *se_sess,
@@ -1403,7 +1403,7 @@ void transport_init_se_cmd(
 
 	cmd->state_active = false;
 }
-EXPORT_SYMBOL(transport_init_se_cmd);
+EXPORT_SYMBOL(__target_init_cmd);
 
 static sense_reason_t
 transport_check_alloc_task_attr(struct se_cmd *cmd)
@@ -1623,9 +1623,9 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 * exceptions are handled by sending exception status via
 	 * target_core_fabric_ops->queue_status() callback
 	 */
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-				data_length, data_dir, task_attr, sense,
-				unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			  data_length, data_dir, task_attr, sense,
+			  unpacked_lun);
 
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
@@ -1797,8 +1797,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			      0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 66d6f1d06f21..e86cc6135587 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -615,8 +615,8 @@ static int target_xcopy_read_source(
 	pr_debug("XCOPY: Built READ_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)src_lba, src_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
@@ -660,8 +660,8 @@ static int target_xcopy_write_destination(
 	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)dst_lba, dst_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 410fa89eae8f..dcce6e2605f5 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1050,11 +1050,11 @@ static void usbg_cmd_work(struct work_struct *work)
 	tv_nexus = tpg->tpg_nexus;
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0) {
-		transport_init_se_cmd(se_cmd,
-				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
-				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense,
-				cmd->unpacked_lun);
+		__target_init_cmd(se_cmd,
+				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
+				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
+				  cmd->prio_attr, cmd->sense_iu.sense,
+				  cmd->unpacked_lun);
 		goto out;
 	}
 
@@ -1181,11 +1181,11 @@ static void bot_cmd_work(struct work_struct *work)
 	tv_nexus = tpg->tpg_nexus;
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0) {
-		transport_init_se_cmd(se_cmd,
-				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
-				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense,
-				cmd->unpacked_lun);
+		__target_init_cmd(se_cmd,
+				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
+				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
+				  cmd->prio_attr, cmd->sense_iu.sense,
+				  cmd->unpacked_lun);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d60a3eb7517a..4975c4d2a933 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -148,7 +148,7 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	transport_init_se_cmd(struct se_cmd *,
+void	__target_init_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *, u64);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
-- 
2.25.1

