Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53649C4708D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLHDK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLHDKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2755E73F71;
        Wed,  7 Dec 2022 19:10:17 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NNtm6015205;
        Thu, 8 Dec 2022 03:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BsP7tfVGMXjys0IoHNvkNmLrNNlT/AJq5BxMS4cn9ok=;
 b=haMSK4nVCetPnS/7qymvkqf2Sym+uiGa0B8WYpFRQ5DRjVcnpzM6aWs4A88i39q1OFxz
 knpj/Qt3BySvTrHgaA1imIqLrFSmCOAuhSHNq9Y2pOL/J3uHKtUfYDVp/lqrox6pmnd9
 90ZWjqFPt6YqiCnHsMJM/l7i/RWZsVK+V9aT6/d/RuIXOQ7Av4OesR4qNW2u06aPQ6Xv
 BVpM9fUWE8l47BJ6ueiZcGASxOabSBmgmxD6e9zbnsCk2FQjz/5HtHJybs/R3i4si17j
 ARTw5GVsfqLnKQW5Er87JpjmXxm08gFfV6J6sF2Nb8d0YRkdxWrOuHhkBvs9xukEUFR2 VQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maxeys1e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B82jsld017083;
        Thu, 8 Dec 2022 03:10:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa5yv0q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhA14n/XsfLjXrVe2k/AnqzUHYWPYrjcVJUfBHs7vq932HL5yhHSZ4YbCAdW6IAnb754+lNO4fdLpAye1dW8DAhJqNTZSZpLW0expu3p/sMROryXXfB167r6vCv3myy+3fJNPauxP9BRTZyiqDGxaIy+/xAlRR5/NOEDhmnSt3pGcVWqdp76fsFyFzBzagYlaHY/rlkleT45fAjvjPMHgfYg1OyrpcgLIjzFK7611tdHDxZocx7jSjcZsRkUfwihRMCCXLhsw22rzOSYZeTOAWs2hfUJWEArxEBaN6krl54/48ghoxtQ2TRaWPKIXXc8Rw9h0di91JdrODu5OPWNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsP7tfVGMXjys0IoHNvkNmLrNNlT/AJq5BxMS4cn9ok=;
 b=Rxz0SrX9itB9K4AGRMIZ5+kB5Kp4lq9YwtWBMc97NybjpcEJM20uTy2EbRpAVnH7RqNxFM4mzWQjBjP4Re/4kDU/T+T6OO9b2tUbZAx4Pt3PTov6MTaLNq9BUrBM+ahX42P6tngIlkq3vINV6f+x13zIl0GhDBCQeqKwlwZxXWDHeTW3bBpvZ68KA/RMnRsofr6dox3b1Kzn9q2tg7sx49FkYBcAbT2toGYkhrR05g9YhcmXSg0R+KCoOtChQ0QCX502uXsr1/oWn9UWVnrftkDqVjWYGqG7Jv9CyhQGialOBWsRbQGgc65gWdvUPFkNGzXlqZHrpUI6923tPZ2rbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsP7tfVGMXjys0IoHNvkNmLrNNlT/AJq5BxMS4cn9ok=;
 b=Nn1YIFnVFN7UnbUpNvWPqU1J2V7pcqfSMJoy/j9bh3seocXUX9/SWxwk+mE71TcISHCeBTma0ChYeMPgYjGWe5iRs9VaXsqWbg8u+h4Y5P4lFs2OY+FuosOEaa2PWhfUJQC6a1IyBQPb6cg6RhOwET2itHa6uNcb7GrqtvijBe0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/7] scsi: target: iscsit: Alloc per conn cmd counter
Date:   Wed,  7 Dec 2022 21:09:59 -0600
Message-Id: <20221208031002.106700-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:610:5a::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ffd047b-f84a-4acb-685f-08dad8c9b838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vujWvq0SZOOqiaSQhJItI90v55PQh5XflBJc5nG95BXWZpn3+8cJiODVT5fpEZwDk9lEOqyKnW2Rv/2f95A2mevjvjM4giWRJ2fgPJG9YJxGFvrv6FbfM4fxbLUWQV+o3QNDFTZpDY3E2b7S2VxRdNqW0sTiJEZR2vnM36wwyu/kr9vlFqvDN+hBkFWTxrCDXeXi2ON10KYDDbS2wV8ZmeBF5NGoCft4W/HjYr3yjcYRQbICqs/wNJsPs798U35xnA7Hs+Grn7pBGYSZLI0p/rco9pvkLwC07IuTiCnhQLsAHJ+zSg7vXfy5UA0eAoD87zcgmgH0DD/7iBqhiLO3S/U3EFBlOD6WHpawbpbjze2DIzsKpzARG4bfS7yVTGPbbmis4QRyKKP6jYVVWXRBtqaNvA/qFCGFqiMNd8FWKhsZeA3sy0DWD0jjgZQnz+/q39ytD11TLwlJASC/LyJ1xr9domVFAgZMO9GXbcKQfDhWIyCZaFOoOzZlelCWorndBAWKznFL0wRtsMp1e2WGctij+Nqj9f5Hm3M9dLLwlOEAanv+383OHyCL19FdZpKPFNrjCIAAcpU09Cj2uvkuKtBS13/UYK0BVepdMleBnpVmw7mhebiRr2bzySTlT0XwQrZCTgrmIh3Pwq0G0skljw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uYwnQ9bHdMqFy/j8tFA7pXgRId9S5GxZczQauT1E0HUXMLdDWveNeXEH4ulF?=
 =?us-ascii?Q?lwg2hh//M1LveUQMjJn8pOT3zwH4uKLSFkPauGSdPVOfgNA5C4ZAfRCe1TVq?=
 =?us-ascii?Q?Dy08g+faigE2kwS0bFbEUyhJ1K5Ifx4z+wdL6moFy2NSZDOnkA3UMzXYeIfh?=
 =?us-ascii?Q?3qwrka220bpN2B8dD3dJ6SKmVuUa7w2FZdaSdJCqCKvV//ZRrk/Uf2NHUMCP?=
 =?us-ascii?Q?9ueSa18d7sArVB4LUMMbIZijjmVxmEL5e60qYIRA1/ojvqmt0zPkBiZkwkUH?=
 =?us-ascii?Q?VGdjaMU8gg80NUirxzUEFsOUoAqfdSgdxviGTgoOrEvh8mMCIOqiBbKktgvl?=
 =?us-ascii?Q?0KutxmkuRTmP12H1yVlpsf5qhfpU63VjIEl5vc607pKE+1ZNt5rD1vDMdDCr?=
 =?us-ascii?Q?30UEiXksKL4iy2r7XkhbtQzcjgh41bSG7ettqd522iD3XSX3oe5pYxVV6hhn?=
 =?us-ascii?Q?A3Z7SqWSHuGdSfwAQj4y5WS4nxdfp82aRZiQEHC/NvlBx+imv3E7eK6TOrJJ?=
 =?us-ascii?Q?IutCPZfgCCeJUejPMRq2NyfwQPBw6xpZg9NC8u38lmvD4d9IAIW530tfpUrs?=
 =?us-ascii?Q?9q0ONvcK9DY+W+RlhqeJ3DTWCzz2EgS1m+EdNYr11I88KOLnNadu2Mq7LefG?=
 =?us-ascii?Q?ZhQme/ja0YV0B3Lebg2QufcVRga4moB8hJJdDBmLZAC9AuOAm1/C6d3/C5Qv?=
 =?us-ascii?Q?E9QppcqfgFfik3gSwd8i2fbibNtczO3mF4dW+ulFqboXEF8TXHqGX6Apr4bI?=
 =?us-ascii?Q?8IbIL5u2gQtHXAaBQS1FNc8xGqYTwSiibE7blZ6jvox1oGAKfyO9Bk0QIb8z?=
 =?us-ascii?Q?t5IbKgs59MEj4C0BzvFWvEprzHkBxUlJFgin71bs9PPvA5m5tezkAXgufsmu?=
 =?us-ascii?Q?MLO0WVU/0uFyGwSfSMVLEdDftFioZfKAN0lOUjarCmtoVz+ecbVtgfglJfVk?=
 =?us-ascii?Q?DfJ6oKCGywch/zZb6eBiC5tVwtVRdPYJ+NtybH32cNVGDD5yB9tZNrNuGRdP?=
 =?us-ascii?Q?Ty7qhvtS63cz7TXhO2z1MLMg86w8iIhc5WsACncbxuln6Ln0Eqe6b3DHMBcG?=
 =?us-ascii?Q?GHeS6BYZbYSGJuWe1KN1jclWsqt9nx3DNt1O1Hj/Rdy8uManzKrmVWd00hwN?=
 =?us-ascii?Q?XWS64TrN2Dm+8YMKMr5pEcOj0kacekKinIDbYVVVLEilNHAwQgwUJL49mW8K?=
 =?us-ascii?Q?lyWkE75SZXlQI86nEjPJysEzZsE9HCe5QbUsfNUKRD57IorijoUvbsm2VAFQ?=
 =?us-ascii?Q?ueVvbyCNMcqrOByTRIGR29WAyX1bYu37cc0IDJRPnIHtX08PlFKDEuIh4mZl?=
 =?us-ascii?Q?OOPg5GPKrW4iPHroh+izFSegbDIyiKbVQFYJHj4wOq4x0E0Ywf4VTSYqTDcK?=
 =?us-ascii?Q?SuSjws9RYSzzQCnDfa2+k5vn48Cs/yD3pAzSbbiSHfWiDoXlYsAyODIX6f+P?=
 =?us-ascii?Q?vkdIgwVTzpVaQoYjpAMoPlgu/Z2ocEvD7GKU8RKtXNDYlcxszhbJhwn/dVay?=
 =?us-ascii?Q?H+wuE0lQdUcYt68aOwqiMhf2+5fWmmZgI/P8o+p6HhnRq0KJvCdz+m73n0+u?=
 =?us-ascii?Q?3WTj5rjBP9LbFC8ADEx9uoIwt2y8XUxP/c67Daj1GwKCajxzvQXegit4aNhb?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffd047b-f84a-4acb-685f-08dad8c9b838
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:11.8483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe6iBwWHxBq+7Os44RGhO1tXFZtySSNLn6DDbGNYQSiLX6xcgZkOdJbBHtWWfF24Dz9BuVhnlgjxvPFRsUCHQJcIRSGQ02JMc/zTOoCirJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-GUID: gqzrP2aJcXgkPGnPyZCyUJM00i-SZmi7
X-Proofpoint-ORIG-GUID: gqzrP2aJcXgkPGnPyZCyUJM00i-SZmi7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has iscsit allocate a cmd counter and use it during command setup,
so the next patches can hook iscsit and iser into the cmd counter
stop+wait helpers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c       | 4 ++--
 drivers/target/iscsi/iscsi_target_login.c | 7 +++++++
 drivers/target/target_core_transport.c    | 6 ++++--
 include/target/target_core_fabric.h       | 3 +++
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f5d498c522e0..7a8ffdf33bee 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1193,7 +1193,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			 cmd->data_direction, sam_task_attr,
 			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
-			 NULL);
+			 conn->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2056,7 +2056,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun), NULL);
+			  scsilun_to_int(&hdr->lun), conn->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..274bdd7845ca 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1147,8 +1147,14 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 		goto free_conn_cpumask;
 	}
 
+	conn->cmd_cnt = target_alloc_cmd_counter();
+	if (!conn->cmd_cnt)
+		goto free_conn_allowed_cpumask;
+
 	return conn;
 
+free_conn_allowed_cpumask:
+	free_cpumask_var(conn->allowed_cpumask);
 free_conn_cpumask:
 	free_cpumask_var(conn->conn_cpumask);
 free_conn_ops:
@@ -1162,6 +1168,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 void iscsit_free_conn(struct iscsit_conn *conn)
 {
+	target_free_cmd_counter(conn->cmd_cnt);
 	free_cpumask_var(conn->allowed_cpumask);
 	free_cpumask_var(conn->conn_cpumask);
 	kfree(conn->conn_ops);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0db70e265d02..90e3b1aef1f1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,7 +228,7 @@ static void target_release_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&cmd_cnt->refcnt_wq);
 }
 
-static struct target_cmd_counter *target_alloc_cmd_counter(void)
+struct target_cmd_counter *target_alloc_cmd_counter(void)
 {
 	struct target_cmd_counter *cmd_cnt;
 	int rc;
@@ -252,8 +252,9 @@ static struct target_cmd_counter *target_alloc_cmd_counter(void)
 	kfree(cmd_cnt);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
-static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
 	/*
 	 * Drivers like loop do not call target_stop_session during session
@@ -264,6 +265,7 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
 }
+EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
 /**
  * transport_init_session - initialize a session object
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index ddfe2070708f..4cbfb532a431 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,6 +133,9 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
+struct target_cmd_counter *target_alloc_cmd_counter(void);
+void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
+
 void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
-- 
2.25.1

