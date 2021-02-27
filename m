Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57235C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2052764E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhB0RHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:07:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46588 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxoSh033390;
        Sat, 27 Feb 2021 17:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=W7a9dP95OiWGUv5gpHZY/GXyov1cleb60cqGsRMvZVhJ1IWHEh4FJpsaefk5c8uqacMe
 zKfJnFbWJJ9IJjA8v7ucoItrZUn5WHFe2kznP/fV1pwOLf6Rd8arBeuM3MoC9N6YBIyI
 ky0z9FJogTb3BPrdHXz8v9O2Sh8TIjWbQhD8rNFYkVNEi5MOYVuFK7YcGCIhCar/ifBn
 RZ7QMpdfSLxipkAbWghTDadCC3k4lHDuPcyIwMf5rQZ/wnBsui0O/QZ08LmsYVgSVXgm
 d6fTCiTpzLzhtsKeFVtUG7wuCCGkESKmRuXPQn/94Au9Mtl6i6H4K7zF7I7eakKPVYp+ mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmY115709;
        Sat, 27 Feb 2021 17:00:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eu5nKTx5WDl7xV+hC8D2EL2drroq/2VoLWrQGGP2SIsxHdC7nlWJzkNRY4lCzQHcXVF6vs+qtJVW/oOashMJZ9LdB5v2HHdz2j7hFgY5vlBFrqcdXg9L5OFxVuX2iC9oyfLZc5RQWeefL9gxxiOrttPWg6xIoIxYtgKRDV6ChWG2hK/vDCOhYez00JxhtLRjeNJij8VghyI09hiwJtJO0D2bxYf0WY9zjfR9Y3KDI5Mob1Ptfycu3Gc56IT12YCXZlHlSH7srcVab9MYc9B7TUYpZEPeu6xX9ldMSDKo2ZoYrG9e2jNKPuB95XaifSzHMVC8MjBI/ShdoXUlUFyPzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=JPE2T1SVBIiOrMPldFOR7FoVzl5ExCl/6COSFeC5OBweJGah1BI7kzBseApuv4DBt11YBnTSu9ro8C0eafUyT7I+Zp1wKgNfV/q3CTTLvMDQztXyb5SqY1CMEoTQZL8ArGzoakW9luAQ0WuLJk0mBgbVxNBX+fsTTvqBPSrmJ+M7f5fFxqGcArtpwZSKaO3tRvIeFo9bXIb/lt25mH/25eoLnuqI0o89u3MwJQuMtEglX24yL0umE7utTpEqs862pXd+fUu8iK0wGI00IbrgwUTaCAEWEhxawibsdRnpGujf0z0KbDCdwyFOpc0w5/CxAC5Q8yZfbMfYjaMBUKx5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjgPReFSRffGv6tKdFo9A9l/oA1V9dfNKG+TQ18QE4s=;
 b=RZIHTltVTFoTDWEizc7oLWKToEEvNH0NJcx1n6tgHMGNJbDGQRIRhOiQuXfC1UC95Toxi+QCglp4ZeuPAG7dQ8t4PDBTr5Ggm8sBRGk2LTpJu4sKYF4MrR966XYNUeE3fh8aVZLqMzyteaM3O48bwNbscy9lQohhWJ3sKybfAM4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:17 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 03/25] target: rename transport_init_se_cmd
Date:   Sat, 27 Feb 2021 10:59:44 -0600
Message-Id: <20210227170006.5077-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3244b26-51dd-4f80-eb83-08d8db4128b5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB34992C7E14F2369C391B795AF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUzEYdzxHm5dZmrn0WQBFYovJ6FnKEo/j/Q8rWclr0hpTxX0Brms3hz27VhPMZEyT+SgZ7OHWb7b86LqU21MmQ77/tOK6q28FXy8HX4sTxPtoL1Zj37uuyCnGzlJTLk2CGg2LtUiC3y021s8q/Oo/P7iJvpk3XkqL1bxPpNc89mxJyjugb9eylbwEJTV6tBNUsY885qCIAWSMbYsV3Ivuy1Ys0YHMrJBQPGTW1QWotG1GAi9rJ6ju+QY8cKudcj40aVggL2Gym9DgRR71uPzDuLgmW6FJ4G8Hcaly8kcIh8PUcvy0i9sMAEZERKChsy1yo1eWn7K5ajol3G+XmivWdJMI6JacuxwcfRlfGMtr0dVV0ofYfDWVOvD3cSCRzBtXgjsFY+047Cs1+UqqiQX+/l70N2Bq/eTX7t5LRHWlcDGi5attpgsMyUJuPQwE2EkB9OKbl54KkVKYo778Mpihb2znwlOg0cmJS5UGg78H4mrkVjTQo3CwPLu7H080wOd01euK9diL2KAsWmHaclHIOc+QfFnpohJf51cwiImjWF4qYoNpuvtVwRukeolWexbmZIsuCMXjzG0jYPcbTPNCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XxbkoPBjaIdTs2Ltm5W8ZoLvv15g+2PbZEuWUZAMXScJf8iul/KAGh9x26Or?=
 =?us-ascii?Q?O4T8YcZa8eo90eZL9NrmLTWSIkxV3ixMIHsq93sIRZ/TV7+06xrI9byZWytW?=
 =?us-ascii?Q?S4Ooc3ntV9ePQelfh43nccLv9+hpyUxVmUaAbloudrCzyy8qvyo338NOUVQJ?=
 =?us-ascii?Q?Rt+9qf2rOrDevMMS8PoteXMKcnY7dS5UV7NEb1PsBhtOGbxxXYUpSEJ83njL?=
 =?us-ascii?Q?DPH4zJQ9a+D1TiaIGi93j8yyTq/L8KX95d2s8z6wMkBWUtcZn/IYGNb3OZA6?=
 =?us-ascii?Q?4PjC9MY/+VP62ToWBUaJSs2UZ7KglzqT3jxjrPgECmEN0v1dgaE1JSYCavNi?=
 =?us-ascii?Q?onaDUqh/8i/Co6+RFi8EFIbAStRkGZ+ezntUL91rL/oobGH5gyXAo68BUQWD?=
 =?us-ascii?Q?G7neBFnoPVMwMeFl/Gta/EJTpxiaf6QN4VzFs7anN0HY9LFnNXNS2xIhTSup?=
 =?us-ascii?Q?HYeOsfIRgarMQgBbEsgi1mYgKj9Ye1DDYLukBf1OO+S0beovuZ2KFnaLCtO4?=
 =?us-ascii?Q?pbvSTp9HsyzZrDsE100XVYy0y8nm7E5p3i78MIIcqQHNVrIKrZpUEOiMTm+f?=
 =?us-ascii?Q?T+pW86mhbcQqNdzb3m/9w1S4SeNQ3DTGCeS3u6RCW43hMZEL6EMnjuBZY8ZX?=
 =?us-ascii?Q?ll/hA0p67HT21fsAjJ6iWX2/b6j9pnFKg9IU71yIvIhrvLdygufpDt5bM7ho?=
 =?us-ascii?Q?p9ffrokRd9Gxc9RyuCChlIdaUZeRIeQOfx3sGFce0UzUeMidZKwtZtZ74Znl?=
 =?us-ascii?Q?hfnvwVsUxsGh7uhNbrxTjZa4FaB/1zi0WM/Eq61zs0wSqadjct1twXp9afTt?=
 =?us-ascii?Q?1mdUzzajdMLvrlNWvzbokIr3rhAT8iHy2TDHZvG8Yt1ShZ65fbOzlo9oDXXv?=
 =?us-ascii?Q?yqp5VTRrkzD96RcOdSLBLRFewlLVvwQo2axZqzZTFYhfvcW6dAXU71Uphy8k?=
 =?us-ascii?Q?cXV5tDnWCdf6U9AYy5YN6yIgglrOrqemQaIXJO/g6Id8O31zWFhexamkOFMQ?=
 =?us-ascii?Q?uxIHj2KUpMcbrzl1PzuTWV6Jq7DKvuGwH1zhX6SjKHZwlf6Umabw76SaKLhy?=
 =?us-ascii?Q?skARUJpniHiS53yOuJeuu91kYjD8lPWoiMgyC1Wqwil+C3HMYVN7WHwDM/jB?=
 =?us-ascii?Q?rrmRp3SgX5+7ZaWWkhxKGUik9l4/Mt5+1XKT4LHNoH4sgN134uM1dUUBti4M?=
 =?us-ascii?Q?JOfQ8RY6TOvDDakv5Jhvz32dxfepB3KB42rVgVlGawSa3eNkXjVrPTvn9kBM?=
 =?us-ascii?Q?zaHVvy9fYKOFY+nhsI7h6ISwqhkG9RJwXXR8N4bLTQeai2ePCDhKc8kjbywh?=
 =?us-ascii?Q?kAoY6r21KM5oqVtX6ERhkQ9h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3244b26-51dd-4f80-eb83-08d8db4128b5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:17.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv2y/+purG4hSE2DcvMZ5NjLsOiukcgIJB6oQFMcgM+/1DrLMtwYGzX7D56hY+nIEJFBwVo0tSesS9ObFdy8V8dT+P74aColk1lHrLc+B+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
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

