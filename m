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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEA0C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D0364E65
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBLH1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:27:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59514 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBLH1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P3mW177047;
        Fri, 12 Feb 2021 07:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=PcDMkIOGiiiNNCS4SxqjW648dqtIY2qb3MzjfLpuMXY=;
 b=qyYlFxbvANLaNVBdlBgZIVS2ByZEOM7VE6TJNorG8se9NgpexpqDJZL1AnE8BN6dHGEQ
 V+s7DDMlPN5WfbTo6ZgKEKPHLTqQaAm7BSdejHAqwgCKYuF/qg0DhQvqiRG3HVltJxUb
 VyrbiVSMh53GKtTAwp3l2hVWGEmVyTFiUtw/h/iNL74HS5PzlwiO7kIT6mFG77OFO9+i
 9Pj4JZgUJjZz7EIamWMbKACEN7b8D4jpaQEZ+pAUA0HD1lmGEHyaKKXMI6MSwAQ6Idrr
 J42oucESMQB/DGtudk+QycYX05BZVgg/DPlAS13nO6Mg4PbOzNFxCSND3l8bz8TXePeQ bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmatavq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdP022757;
        Fri, 12 Feb 2021 07:26:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 36j5155a2x-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecxm1KhLomo3P8wRqY3mJ9yiSjSCq6AzFKlJKWTbtbfHqDAfQ1upB+4FRZHB/RtXGjgoMT21aGoNnPs5k3GdnaHmID+zAEcL/Pihz2GRC0delZR7tFNrsPCXsFSmf0BX+PKg3G7tn0E22UxrfXyVcA30KtPU8XaHNutwbM/GkX7TPCSTfduG4sga9LwTS3ezGKVaHyUValPoFIZ0SWdUxZcmfySFHi1iVqbc7g5TGZinnpAB1tazrB5ltB48Qv6QnVzqnvwczX68WOy8XOXEA4UKoNMYBDYe4ONBC5wlRnVZfTqddCvt/iy4bhyIZiN/xdwKcLOczo+w+fwYL5meAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcDMkIOGiiiNNCS4SxqjW648dqtIY2qb3MzjfLpuMXY=;
 b=LRR0gjtAG5dL0LRBbngL9/IWtC0ba7cCdTzGVZ7BLJsI3WLUXRyAuUe6ZdGGRpd6uTGtVRDf/5ZQfQmsx4bTSL/h6DoswslzEbLAvqWfhx+qDWiN+BfyRiV/6NeiAMRng7TW0ZqOtVb8WC6U+3S/PBzQdR6rUbfZ1jszuPtSr+6AAZId0NQcSTgQ3y60WXMA0/I5rD5iK3JrbWLaZjbF6HSmc2GQxNYwIZ08CUQXC/sYKhJrWGcjY/qX/Q1D7kliwaKiq+sBs9rXL57sjGXTeeMx3/4YxalIsi4Mnp3IzbrVODyyXuL4bP76omfO/MppA/02Ez5YAqPwPEa37eqkew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcDMkIOGiiiNNCS4SxqjW648dqtIY2qb3MzjfLpuMXY=;
 b=RtlvNtVQgji4MH1ES9zqnZhnJYLMKaR4pKUBIhxfZR6+f6cl3jv3iFnW5sqnZuprjjSh5WxK1POhN7RfpeB6E64vi+DI/IHxeMFnlUSKpZvWNDFA9+GMU204W1sGJi/stINl2H/WFFEInV+h4KJetZGEG0uugwFUiC1Bz2A4ldQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5256.namprd10.prod.outlook.com (2603:10b6:408:12f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 07:26:54 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/25] target: rename transport_init_se_cmd
Date:   Fri, 12 Feb 2021 01:26:20 -0600
Message-Id: <20210212072642.17520-4-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0ba6ef5-51fe-41ca-8b3a-08d8cf279268
X-MS-TrafficTypeDiagnostic: BN0PR10MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52566910B5A17FA370C6E11DF18B9@BN0PR10MB5256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /S060754TmRc54AQ5Hcu8NpJiq3Yk6sTPYriWNMj6h1+NutAm6Q0eAwnUu+vS+bdT4Eahfn3nGKwjiWP3EHGUeHV7sjTh/8vzgsiKStbOgLY3W/IaGMSNqMFNbHK7wXoPSZqLZt36vjl0pCXeBGGyBflNr8zo04hVmAPEeXzv+rQJ4KJX+NqVd7KS5vRTN8lDnqTPC84lmrUy9A1ictnG76mWer9uIHBHyHkOV+QRdQFEMUyiBLJng8Ba37YMuEvaUkARBBCjBTt+5xPHloL3c84Uqu3gTveepFPiGg3g6xZbuJybIOc4zOrTDjcCRuv20jWoBzz+X2m/FkY3NolSAa4PdCuqMYZUx0GHXNQowqc3v2wHjIT7/uFaBWu2AdzYUFrpS2pz5igLgPXKkt3D1G2XyaGJ0HTK2FLgnkslnSSfrPsNX5u/fQ+BNtH+NUwHwjpuXZ2pBEEie9y+evQe3n25eIE6F5f0jkO+bMQzjodrg1y4HZ+VSZ4rmLZg2LkLBHB5CxWBYxKCJJc69rK55AcCiW+BlVcLSQQYlSEvK/fcVTs2sLDg+lfdMp/HfzrD+lf6g2FPh3T4ioDGxKWog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(478600001)(1076003)(107886003)(6512007)(83380400001)(8676002)(66556008)(5660300002)(316002)(66476007)(6666004)(8936002)(69590400011)(4326008)(36756003)(86362001)(6506007)(16526019)(2906002)(186003)(2616005)(956004)(6486002)(52116002)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XnTwPOHA8gl7AQAFNBqbyQ3lHxg9V4YqQDImiyDSOQBFwByTeqk1Q6WulAoS?=
 =?us-ascii?Q?1VVGyqKvwIIFTms55BHEVVS76FbV+p/n33bUqIVKuZsAUunsSCXgt1hxiJQf?=
 =?us-ascii?Q?G3bg5fsAUEnAW8augXRkn5nCvwephqZ4ln4K1nTceoTPtQrmpJPEDJfy2mY3?=
 =?us-ascii?Q?a22Mo8Y9JADNuijHV/1wFobOndTShHTBVmwxIcM4Paxm+I1TO/6A43cUuzME?=
 =?us-ascii?Q?FbUFId0OSUwRgN2FFkjSp1XSmhhSpW/AhQ75aMepb6QXsBbEHQvsTvJuCIT8?=
 =?us-ascii?Q?mcVaHdvUEMkXHDLBefOlS5U1V4LE++H7qkSjlT4zwSpxOTFosEhd+N9WEdHO?=
 =?us-ascii?Q?0/Q0wc2R4tuoM0OtiIvhaRPjL4T4Emrx0tNJzttHKKxCIncNkTDdxguc0sHs?=
 =?us-ascii?Q?uQqCVfwawSkmFJz/t3GobPfBApZyPhvJRsScEx73ajPMBHCSNhnbpT8jwK3f?=
 =?us-ascii?Q?8oHc7IEEC2/HZliScgIbeDBs86GH1qAQRlJA2VvV+GQhxPntpLtH89bh1xLw?=
 =?us-ascii?Q?JM3ohIEPBeR8yb5wkFU4cJvZTJFJE6NbXmPJ9QCy8mWiRGd2EklYvbP57NDO?=
 =?us-ascii?Q?3s7+UOmfA9IhGs3TkVrAJk89KlDQsYZnVV9aybnenRzrxl5aMcdvi0gFDAW4?=
 =?us-ascii?Q?D9tWb3w7QhKxHDQ7G1YxxevytdH8kf43JbwSbk48e8AnTOUJoIMKvuMx4T3+?=
 =?us-ascii?Q?eSvPDVjapdb61Ig8hV6aFhZDuUvLHnwNNZfyXA4BYrROZx5Q6cl5q/81yCYj?=
 =?us-ascii?Q?iQBKhIqmB2CSPBopKz/SgzgaZNBIztBQJENAj84FSTz7rOzklGWuMYa0bm9l?=
 =?us-ascii?Q?OLf6NyzKOHOhsb0bx+Z4MnFmyxFDfctVLULzCTNZLHjkPgqxR8axZMeuBGze?=
 =?us-ascii?Q?aQmt5o67jsj7x0Epb03L28rlAW8cHyXdAautBklc7SqPISBQntdit/gyZVwf?=
 =?us-ascii?Q?zcZN51lrCoxAiV5MJBHwXqWjkfwfgHoUXYk5uLetYW7F5a8A/hqMSTDLNSQM?=
 =?us-ascii?Q?wBkwafyiDQFDV33ftQ5NnHqz4N4O0P0Jm49axGPijnOUFvj3jj1RcLV7N650?=
 =?us-ascii?Q?5xUvVm0GadBU8QDqxaVSVbrhWcUFkq0Zz8lA9DYBmh9vHbn59eXIVu7N0XU1?=
 =?us-ascii?Q?NznQfNZh4/giI1cB2yFz7vNGNYfwRbc8hGENKCdUHBrbgs4e0r1fYvpwAoDS?=
 =?us-ascii?Q?AMMqiVT+n0jiII6XFbz2s8VNficWQUhgLhLOA+3j3E00BXf/CzF3FlL2rcpC?=
 =?us-ascii?Q?UOfY2AB1s9JvyXKwgF9kFAWbGPPFmiotI4nxW2SDTvHLxIYS2P5WCfHLv10J?=
 =?us-ascii?Q?q4IsTUKflF/zuyyDbgPfu23P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ba6ef5-51fe-41ca-8b3a-08d8cf279268
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:54.2602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7ooEqBaBnaYpJEGbn8Q4RemO4K2NbGYe0vZjbZvrKr3ZpiKNU1YrAcnbBrVOV0a0N1pS2haZsc1NFY3YFXj24//vN6H9a2j+ZsDIvHW9o4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5256
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename transport_init_se_cmd to __target_init_cmd to reflect that
it's more of an internal function that drivers should normally not
use (usb seems to use it wrong and iscsi is that weird guy), and
because we are going to add a new init function in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

