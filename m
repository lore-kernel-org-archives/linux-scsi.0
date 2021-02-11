Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DEBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E264864E2E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhBKMcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:32:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhBKM2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCOwJB050824;
        Thu, 11 Feb 2021 12:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mJLOM170UOVxs6KEy9JlX5oB6OXlJ1nwsdmN9GE7Xx8=;
 b=eeWCdI9yUuIo3hqtcAvLexW92oMUg4gO1ITkypFfw/h9WU3cLFxVOn3urZK7mWxuQ6f6
 TrL/lIZgZ6TOFXrF/N7DvxQstUbEtaQdCWYYZAFTs0eIty2KOsxcHVgj9kq1QP0DSETW
 iVffMg3eI81OVwjSO+QQKw2WsIfobQ4kZCxZjRitPBhxQuenE58029C3RwSddBauHXGi
 9MbxOamm3R9Owms3sqhjdy7j5JKLISimCxLKaKeqq74hQLJagOb9p4NZeoEVCuwnUgdS
 MJWex/8tw71m61VYeo6XLM4v+z+lvtmeBKyeI943qeuHOMMSfk5iFw9Ma65XNK9qwp/N yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36mv9dsej5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCOn9u068569;
        Thu, 11 Feb 2021 12:27:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3020.oracle.com with ESMTP id 36j4vu69v3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Skh+cTACdZXDqr9s9221snHcz4UAKW1W39MT27tpi4cm52QZcLiIgdYY5zaYeOJd+NGaXXbErJCiRHVDU27tzjxEfOG9L7XqFMdP2Z9k0iV6651XgywyL2zmi7h13XGM2BNQczZCc9gEiVWYbnI9i87Ts3EmN5WfeDqT1+zcFzP1z6axeHVGVM5GSAC2uUs19Wqkc2SWEW2atJ9izPbbZ1UHvh5hsbvpdNs3RUIvlDduRB+lWQaE3dVN7cjQ+A7GJbWVKsyTqElP8CQcblfOvY7FKM6WeLt4Sl2P9mvsEeuHMsZxXDpw4QjEVyIKyYVplDZxGVDwCPCY/OBpVhdnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJLOM170UOVxs6KEy9JlX5oB6OXlJ1nwsdmN9GE7Xx8=;
 b=PZeptEGtGVZ+X34JdARPQtc4+N1mztUIvEEtw+WF6TGCa+ogEmC2Em5HRgIqr31RIvnVTB9tqDweblKO2AV6BhU3WOwFP60tBvv6wEhFDKnGKlLbq0+CWpDFUdMtluxOeH07kxixuE2WL98FDqVKHyQf5GCpy+db1Dvwbjyctz384TObO3+jcgmh2t2Z3FqaVBQY18OB2o11Fo09FY7RbtQAOSpFZqDANAyemKwupdK/lGQY48QOvf+bs6RainoQmATp68F1e177tY+o++dcTZCsGrRHxSW4gH+pQNZsM+xOyezggyX8vy5e5jVuGXYz0ShtHT0j/edt1IB1iBgSHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJLOM170UOVxs6KEy9JlX5oB6OXlJ1nwsdmN9GE7Xx8=;
 b=OGQDabzVEL2Qhhw3iBwPILG9bO1N+wTLQj4t5jklYYEnLAQZUQ/BOsxg9yvvAteZV7iXEzIzF5eb0oJslLd3yE9VyhjvAwdHknjyAYvudbfo/rrfBYvImHuSsTbI6riskzNV0sxGmWlyAkpTAXOvNDDgn2HQokBlQXzpRCoOfX8=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:41 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/14] target: rename transport_init_se_cmd
Date:   Thu, 11 Feb 2021 06:27:17 -0600
Message-Id: <20210211122728.31721-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 591a21bc-70ac-4574-33a4-08d8ce886cfd
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB433939F7E3080F19136AA849F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pvLOWCkuWgD4wjbQs+SlF3AdxSPULLvl0ZmlbglM7z/63mhjWK9XC+DXCw/fWOMeUbvd23Y6BfpcUydPbmMGVNVy6zVNTRCruracKI44393jaIBu90gsfUnPtYd/kr81jxWNx0XO7V50xUxYWE+dKN3/dMRHD8EYKjKtlgBxKJZmZiZltur8fZo3QLN1Yju3wTRXbc/ndF++lBQu3muhgGOuuIX4jz76nxtEhXi6tL04GzoVKdXH5OLhJfxlEUPTg2XrXDhaq8qJfjNaKo/WtNxhE6+2rd73P2kt7sNhqnxu0oziaiHWvONCKH9LIED/wvW5IsU0pCtD2V5DayfzMDUKXi6EdGQRaog4hp/qdH/w8HsUSdmEq2ZJJqpdimoWI9yMImqaDtWtyFEfDVOtcsGrup555U8zXSMs04v1cQ46ncY1t0FU4cA8siR/zsUTStMEYTHwxh1DojGGLT3uzYOc0JhJqEvrXjtsOcl4Ikgw0emtFoksu2gVZLqcbhLSiA6STFIlZOlobnEtMXKVGAtNw5XybnY4NYdJYF8qZTneo3R0h7I3o+Dev81Enzv3ZoBGic503YEIIb9176J5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GJBG6e/J+9G1UumfKC2aLq5mD4XL0InYTh+LSbkV7kmsEGTMt+54wjymy0pH?=
 =?us-ascii?Q?7Zi365CieDhHkNFpuXqxES6hfcFkWX1L1k/n4AZhxuuRMOsP6Pduq5ESx+yz?=
 =?us-ascii?Q?3z6nE2QhGEcESOVuZCZIGmaZBb79eU5sb+CaEx5AnBi4TbB7aZ2DRSKBwCgn?=
 =?us-ascii?Q?egtbZeQmBx+uF4iJRc6chBCut6DsVIF2ZadJHs+fgr5hLBh9Q7nzNouJqnrH?=
 =?us-ascii?Q?Jzb3Mlpy8qc5dRjffPliY/f7bjaBj71N2Dxjy7kPR6UF8/PRziRRmqFWVrV+?=
 =?us-ascii?Q?92Yg7mWisXxzFKerqgVEn/3FpKM8rliXcCqveV9UFg0UrEbJ9TV4sScLr+g0?=
 =?us-ascii?Q?LVZTLvvBzDx8m5Xn5IKSq4RlyF3ryM+IT7EGnkNRV29ZHpdz4u4JvLRlhHFf?=
 =?us-ascii?Q?P990YTXga+E7+qpTHRtgKUfDi2tmc70LCErRJapz5CAD3NB4aUGkW8+GOe96?=
 =?us-ascii?Q?Q+Kepfc2CzTbeaC93wVZDEZp17OqySB0XEefKvcRIisKm9oXWvIP5wjhShd7?=
 =?us-ascii?Q?D+EPrHu1UWedOrAMh49yChfkh9mwvyjxeT3HYIb6DueCDQLiMVNrqfQb3Ay1?=
 =?us-ascii?Q?XloMekDBrGk2KRK6wkoe6W5s1htYdU/tD7ok1AqzM/N2ensBp+A34Neik/hv?=
 =?us-ascii?Q?4Lzw67GpqYuy3Z3W9C3iUp4JQdW0++/T3cTTAMTO/9LUOGupx7gZEpFdQe+s?=
 =?us-ascii?Q?UYYxHnHq+u59d/u5r5N71m924KL7SkYMemnZPxvY9g9nT3o2uaUnrcNCeAg4?=
 =?us-ascii?Q?QmgikEuvI7ESDVBZpiJyDS/s1y3nAQmr+O+OZ6Jy0Jsrdio6uriAkjqML/yF?=
 =?us-ascii?Q?hJe3sFJcWbFz2u9wo/3RqW4rnPE4PlYqYoZZ7YKl/MAgYMXtYEUgkbjM/WKH?=
 =?us-ascii?Q?DSDQAfZ0rEkVwjNTWxsxmkwLeXjtzJgZF4nyvez3KuZGUg77lmtoYkP4kUic?=
 =?us-ascii?Q?n+fvFzpYmhLMOKuwD/HphSDy3kZrHtHho2HJR4uohSpiMe0ay0PhYOqvnGFL?=
 =?us-ascii?Q?FRMpUQLuiDh2NwFHB3jKnjMF282AEpHbrSyrhc54rPdXaOkK2XBtr8wpntHw?=
 =?us-ascii?Q?cVEBgqVxQqEyJ9RX1fHotICC3ndOqMjctj32RTPSwwCE2fCJQFF1MmMpXDEW?=
 =?us-ascii?Q?0BXmYRXwyMFr5N7N7DAf0uct3y+C0abpaG27aVf+I2LHoKcD5EIUr8jRsBz9?=
 =?us-ascii?Q?JtxCYuNrUZe17p2rHQnPp7DV7oTXrY4vfTCk6Zv/0e8MkfW9kfgumWHP4FlS?=
 =?us-ascii?Q?7p0JgGFQrzbIpWV2j3Vc/K7avybX+uHKeakzJjkTFXPEhkWsSKP9b1Mj6V0e?=
 =?us-ascii?Q?Y7UICGbmBhD1CUWScHe5hZ1S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591a21bc-70ac-4574-33a4-08d8ce886cfd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:41.4251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wb0Dwfw2tKNqydXUAA0LaLw+PkwJapr00JkXVEnhdb+yMiWXo5HsQG/mma/cLk9aqTbt329tFvMcaVMrru2pXisXGhdjOaJxB4aOBNYru3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename transport_init_se_cmd to __target_init_cmd to reflect that
it's more of an internal function that drivers should normally not
use (usb seems to use it wrong and iscsi is that weird guy), and
because we are going to add a new init function in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
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

