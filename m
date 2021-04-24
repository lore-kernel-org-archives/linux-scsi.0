Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80766C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5518161264
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhDXWHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbhDXWHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM5P1j004726;
        Sat, 24 Apr 2021 22:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rmTXdr6Aeq+KCTHxUd67/gc4kKaf0WHYZyeGyiBBcPA=;
 b=KS5M5lYanWM+pIJdLUrQ9j6dd9lmxiDi+nvf5yExc/9cFgotQzmyJhOXCNLnMrNMmy9M
 JZJjVWMltGcLMwIcJsUJ1a5Tdmm+zYDx5rWkV9E7l4u4Ep6RbAaat/pfP4QW/ko1wEd6
 wCUDE51PUq19Q/Q6WS48QtB3h2E0Yeyi10Z6plpW5jjQM8j1sVdNKj0kjjNDEzS0M/t8
 k17LImRC7jIOcyAjQT+md6eI4qsiCntAF+bCrtCNOiuNsmlq8TTcZjmZsQZV6zECK4c7
 cuNZ+T6FhCWO9ViJFy+0/vwRyej2Mxnw0G+/PDExTfg/1sa5P9prUYeBso5Bat8eiAPL QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 384byp0rkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM65rQ182259;
        Sat, 24 Apr 2021 22:06:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3849cakftw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3zt+OWRqCY/hZbtlg+Pg32xUXkKcpraQyTfpE+oaSkMQo6/KDElED4J5c/4UWDj+U+brzXDvClADKh+9P0xJL/NhSCF1jMhcucvPoNDdh0ZeArnRL1VgUFbaWHSFLR9EHvZ1z/NyuTo/nKrv4YgsniDg3RNtbSROPOmxVP7IgxzA+V7628eLvqKDvUzR3PKN+ZszIw2WDyuWuAPmKGMNBfoy6ExpsXwnWro3dvBuVqPHAjZlOgoIT7EjLN91T7N0NlxwuXcQ3Adh4bAWmegDfJtYzlHnVkSGMmp9wsPqbHJmvYAhg/IKI79YIM2WIA2AWvKN6zmKOQSB4F9dWx4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmTXdr6Aeq+KCTHxUd67/gc4kKaf0WHYZyeGyiBBcPA=;
 b=XrklIs5hzbj7JmYb99Drjrx8EchC+y6fgyjUASRsnX6EaOOLutMYbYMdE8P+ErOj5qXr3p00O6hjKAUWIFH+YzVQz7kOPIT7gbekuHXd9xV9qSlQOZfgo6paXRa5xKAmwqbZSd1RbtttS3VSNu9HHGi9eG9mHJ4gq4kQUlRRudoHCvnJWV1ERYem9hqdkCp7dQM+/Wib9e7QoUR6vhV2hbCnzat2yM2UOoF3SdkuJRYNOeFlZqREVxO1Vgqx7vZcQ2ME/7MzBdh96Y6S1GLX4SSUyugKx+V2c8PFJZ6TAQSnIwT0EuBFtreufKNacxPLTH+wkJ8H7ZxFX/FWmObsqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmTXdr6Aeq+KCTHxUd67/gc4kKaf0WHYZyeGyiBBcPA=;
 b=gUg3j0mUcT1gXFDN3MghNvUs37sPG+UN0wmYCPFHwtduTEUT0M+mAZxke3ILiTKmy5DokvYhinUClJmOLJBllYDkxXpX0rHfsy+rHRJlSSUP2ULwbRKGooXt+Iy77O3jKPb9+zqjdh4Tb6fc1etHnRdjiFc2yRHrcoV8IJW9jzc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:22 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 09/17] scsi: qedi: fix race during abort timeouts
Date:   Sat, 24 Apr 2021 17:05:55 -0500
Message-Id: <20210424220603.123703-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5885e91-a462-4357-4123-08d9076d3210
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB331771FCC84A0016AE12B1B2F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: paWf01H06Ar5cog0+D0fEnmAExKwPvidJUuOcgyla+Wdqb0C4qcuvMaDqGADmg0mjcf6+eOxXGwKASo0rzSKHmE4GhOSZHVY8UV/AHG7xtMeH1eqLNd+KxhOWwsJ/cJexJzyiLqK0Au2HPYXZwKKcWp5DP+9YBr+r20rSl4lUYw89zXjOT/HOF+yaPye6XQMYazmCP8bZlOZp0YV+YFzfTrpJcNHIPTG2prVB9E9v5+YB3ytSpLTl5b6wdTFg+4Gvq9PjS8DxNGvSBEollGetxHh0XsamiQmlRFxdySh6VcXGI1R/1Kj0MK1ohsPakqoVjm17FhRaMOYt3AZtCO7NDcLSQUR5h7eD+8n3GunbjlkvsyCjKOZ5vwJdf3KNt93OfsBjLwdMPpuO5qWsH8ki4oy8h7b2fTS/azXpOWZtBU1FeVgnhWlDrAN7sdQTkQ1UEwhgxQNr13vKrLF8zqgOe1YdtGHM8m8KY6AC/VPYQXkqGdeVW5fxNp1T5xMUS2aH+pDKkNODmTfGcgNUzJs5jPcX6kla+xvzoOskN2S5jgjVqdjy20/EmkoYQa3kqoAnEc9ILZXPt7vwA0ltQx3pNou3CrDuqx/oveL6rI3eKatbv7mYInWPmwipWreGZXsLMFHF2a9ycdEAaHrjTvi+JTeRF7PxrGghOC77QKj9AZg1cfqABostUXWEC2fhnjp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JSHajzlD/Jy9NXHxDIj48hJ20y7cywz+O8xSEEPMJR5/L7VHQ4JQiavKPr8L?=
 =?us-ascii?Q?u1g2AcDK+cldSsaRS+StOBt6DNuR/8W4BNie+kK4xPVDLVoSqoOJ1OdqH1s5?=
 =?us-ascii?Q?9btuf7ZhYpLPRk7TbNfOLI9L4DCw44d0AL9OjmiDACM/ryksTkr+sGtjvkNT?=
 =?us-ascii?Q?+SzPipmd8GONriXHfdlzy1mmw9xIUodg49enyiU26d1ccKVoDN+vyqWQHfRM?=
 =?us-ascii?Q?A/ZlkQ2adOfVI2Vlg//7hqICvmVG2cUatZaEz4wecMw3wLeIgSJj8hp6u4Yt?=
 =?us-ascii?Q?WZ7x77ExXDX2nOE8bI6oj9ACmOu2FEi3HTuDUUfE/i1s9uUUhQ39zbbXjDaW?=
 =?us-ascii?Q?ChDD3drQlQTx7uAQ1GbKTh38yXI8M6QRuhzBpmqPqpVc2x+kvZUviUJ8BMi8?=
 =?us-ascii?Q?RTgcsIYQezwbOaUdIyyjtSWBwqh5AjrLSSPhkT8gvoxOEI0RyZIhes6f+ctI?=
 =?us-ascii?Q?hnXJ6Vqfv4iYlYtSZNQQFMWIPu7DKqQ+c788Lzm3EghOOsYwIWqU1LoGtGAE?=
 =?us-ascii?Q?JoSh9eiwuxxr13kvvvF0LIJvpHqLzr7t+ijk+Jl8YXwGfofQvSJvSsaaf/qe?=
 =?us-ascii?Q?y7icq4U39FHPito7qjAo0U2FT5JN8BYipK3+CE1pQxTD283Y0J7t54MLw1tb?=
 =?us-ascii?Q?8cZJ8JZeMTlvyiJBgYZdsqwYZ3jfc49a3s4azBfsNkEpzu6/S8FFhu9jt/cv?=
 =?us-ascii?Q?uGK2EdoZD9Ba468TcvKwwpSPR6GzhaatDg/X/YpFF577hZk/dEbjpJNBMOd0?=
 =?us-ascii?Q?dgObFXXUly5d8xQ4agE8VZJJXk4NiOLZRBQhjs/4hyNccUpQiriCOx4ClH6s?=
 =?us-ascii?Q?Pdwf9RKtnzIsZiUcEOTFBxV6esThIREWhPhsg7uZx7f7fPuwKYiSm1sa1NYN?=
 =?us-ascii?Q?mDwB54FVGaIW/KRfcqzZMS+uTnqkcCAvDbTmwrgA5XwZ9I55eE3/PYZTWfjE?=
 =?us-ascii?Q?Nlskcyt8b2hxRjOgFjhfglkKgHmILsKe+zpaOVUQYmRvN5eNmFya/eWPyqA+?=
 =?us-ascii?Q?XgYtdEX0sf6CBEcGCYYsMOZ4mlIPXTHdR2fMIKByHnZrBJ7oo03OJq9J02Wh?=
 =?us-ascii?Q?oUVFLiRdBnJxfvg2jT3JdDagab8rV1yTlSodp2aA0ccOJMhMsDlJlTlAIrB2?=
 =?us-ascii?Q?SVF6bugC/3doKzGwdmlEc1a+suatQ2ore+eOCf7TySkRoVJaLbNatmsO2KtG?=
 =?us-ascii?Q?+27h2irk/0S4OBsXlnL/ZeE+FiF7+n/Bz6MonMMRz7jq6r/pcQO2P6yKPSsQ?=
 =?us-ascii?Q?3eYUhjAjJ8xjUfZliAqZAMIEYt9QxrTt5wmLQC7oBkpC2YP1czrAwJZstYOm?=
 =?us-ascii?Q?83iu8sNX8yd7ScRDPOJ4v98d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5885e91-a462-4357-4123-08d9076d3210
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:22.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d01K5LAPRpdPJce4WZ3YS/bpnfcpZmLCWL9eexjKhGiS+c/K1zRTJeFWRD0r6FVF4Gv9ZrvBZBip/tsSuzuyedH0hWootBHXPqmjR/GTtys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: hpuZ_reOaTX4N1q_sAOrE26fdD6uNEI6
X-Proofpoint-GUID: hpuZ_reOaTX4N1q_sAOrE26fdD6uNEI6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the SCSI cmd completes after qedi_tmf_work calls iscsi_itt_to_task then
the qedi qedi_cmd->task_id could be freed and used for another cmd. If we
then call qedi_iscsi_cleanup_task with that task_id we will be cleaning up
the wrong cmd.

This patch has us wait to release the task_id until the last put has been
done on the iscsi_task. Because libiscsi grabs a ref to the task when
sending the abort, we know that for the non abort timeout case that the
task_id we are referencing is for the cmd that was supposed to be aborted.

The next patch will fix the case where the abort timesout while we are
running qedi_tmf_work.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 15 ---------------
 drivers/scsi/qedi/qedi_iscsi.c | 20 +++++++++++++++++---
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index cf57b4e49700..c12bb2dd5ff9 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -73,7 +73,6 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 
 	spin_unlock(&session->back_lock);
@@ -138,7 +137,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
 			     qedi_conn->gen_pdu.resp_buf,
@@ -164,13 +162,11 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
 	if (rval) {
-		qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 		iscsi_unblock_session(session->cls_session);
 		goto exit_tmf_resp;
 	}
 
 	iscsi_unblock_session(session->cls_session);
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
@@ -245,8 +241,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 		goto unblock_sess;
 	}
 
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
-
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
 
@@ -314,7 +308,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 }
 
 static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
@@ -468,7 +461,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 		}
 
 		spin_unlock(&qedi_conn->list_lock);
-		qedi_clear_task_idx(qedi, cmd->task_id);
 	}
 
 done:
@@ -673,7 +665,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	if (qedi_io_tracing)
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
 
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 error:
@@ -730,7 +721,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 		  cqe->itid, cmd->task_id);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	spin_lock_bh(&session->back_lock);
 	__iscsi_put_task(task);
@@ -748,7 +738,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
-	u32 rtid = 0;
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
@@ -779,7 +768,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			found = 1;
 			mtask = qedi_cmd->task;
 			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-			rtid = work->rtid;
 
 			list_del_init(&work->list);
 			kfree(work);
@@ -821,8 +809,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
 				qedi_cmd->state = CLEANUP_RECV;
 
-			qedi_clear_task_idx(qedi_conn->qedi, rtid);
-
 			spin_lock(&qedi_conn->list_lock);
 			if (likely(dbg_cmd->io_cmd_in_list)) {
 				dbg_cmd->io_cmd_in_list = false;
@@ -856,7 +842,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 30dc345b011c..416202bc4241 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -772,7 +772,6 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	cmd->conn = conn->dd_data;
-	cmd->scsi_cmd = NULL;
 	return qedi_iscsi_send_generic_request(task);
 }
 
@@ -783,6 +782,10 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	struct qedi_cmd *cmd = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
 
+	/* Clear now so in cleanup_task we know it didn't make it */
+	cmd->scsi_cmd = NULL;
+	cmd->task_id = U16_MAX;
+
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
@@ -1380,13 +1383,24 @@ static umode_t qedi_attr_is_visible(int param_type, int param)
 
 static void qedi_cleanup_task(struct iscsi_task *task)
 {
-	if (!task->sc || task->state == ISCSI_TASK_PENDING) {
+	struct qedi_cmd *cmd;
+
+	if (task->state == ISCSI_TASK_PENDING) {
 		QEDI_INFO(NULL, QEDI_LOG_IO, "Returning ref_cnt=%d\n",
 			  refcount_read(&task->refcount));
 		return;
 	}
 
-	qedi_iscsi_unmap_sg_list(task->dd_data);
+	if (task->sc)
+		qedi_iscsi_unmap_sg_list(task->dd_data);
+
+	cmd = task->dd_data;
+	if (cmd->task_id != U16_MAX)
+		qedi_clear_task_idx(iscsi_host_priv(task->conn->session->host),
+				    cmd->task_id);
+
+	cmd->task_id = U16_MAX;
+	cmd->scsi_cmd = NULL;
 }
 
 struct iscsi_transport qedi_iscsi_transport = {
-- 
2.25.1

