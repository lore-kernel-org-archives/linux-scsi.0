Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CC7C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKDXXt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKDXXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8882160E7
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7dQ014044;
        Fri, 4 Nov 2022 23:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=no4PE5ebOc9JmtWx6EcSDPOU5QRXvgEbkye8oOC7shE=;
 b=OrlF/jajpMg9V1WHVMC9DZq0feJIUkA/3TdeuHoV/h0CDr6eKUI6lcuIsN92fsJ0BGu1
 6h5hJKu9QC8T1Iwa3hUEe86wMoMkUfzzDll4v9i40McxnE6+c5z3xtH9/Bdr1yeoBRFS
 NGiDZhuH5orPGFnFXXuRXyzMGFPb2fFHwy60VPWOtxCYioAGssAGYmTfUma0LYESGs/I
 okurmUn1DBiJVhNZzaIVag7+0DcAJBH7RCZo5yboVrkgzwK40nMf/mKp0sl0ifChwy7f
 iFjRLZ668Oh1/8Rko0BGKgGseYVpyFlhboSN/IgKt5y5OTotDfoJeSqYpB/KZShMrHIU 9g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MI2F3012011;
        Fri, 4 Nov 2022 23:21:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8cpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II/Z1j3kiAW3wDHRntqfXI0BA0f4PIsNYpxs+au37A5lP7Png4QJFScIOVyUJcMK3F+GZJa2LShqT4kAuFNIX/fc8RXLPOrkOv3B4o4Z1sX1XhujG9BCbGz8HKCeOxHUJKpEeIG0ow8q6nj255IMQ2KjbLrp0v6JXuTH36+YRT85eA3a7CfudtajZbLij+d2p3bqd/alF/6cqoXT+69JrC5cSMXxB2q7+wiZScwxLaBxSVrizk14JzsYhkmV8USqnMuiWMuqk58SXBJYjCtvxiflQ1S0NG4Za9vvh2AqeO9T1UwOKmijL+XCLAWDrbaeEEf19SQX4CPURRZ3MPlDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=no4PE5ebOc9JmtWx6EcSDPOU5QRXvgEbkye8oOC7shE=;
 b=bN7iAjhpiyZMz6XqULW3rop9L67HDP0F2IZQv4glu1Sy+54hrUyHUwWGXsYd3fZi3xAeYBO3QbMfl9c4she8zXMNOQDAHqj7/q7Xg7kwoABKWY0tcj3A7LqVfQZTsmc1Ty2Me3fEi1LQ6j+iP2ub54U/BTOMpIKdwwyXeSlE7WkbzEqhgsvdBU0UNusNMaaCQiHJGUC6i6X8GvjdB5Kfam7ir+WKWS0knvZFw9Gd9ns2TQZGZenfOfhCHRDYBn0uSdmPa1jhnTGhiKgB6MT3yu74FabYgBN22HPeSOrIRTmQtwvyIKyoaxYjjvYqMkSx/GqnpUBb8nbA4e+xejjDAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no4PE5ebOc9JmtWx6EcSDPOU5QRXvgEbkye8oOC7shE=;
 b=BCCvDqlS1AXQR6/JZCNSzcHATq/TeGKVlG2jgxOgqYACQ7LFe2XExm8PV2Vt/fNKXcNTyt/0cJkOoSTv6tC4/QxJtzzw9qUFz9YmhQFIxfhwh2Acx5IdNGnGeWMZ60SpuYQj1BCpJ1zv9napP9hzVG56v4hzMKAxc4Knfkdg5Pc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:21:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Date:   Fri,  4 Nov 2022 18:18:55 -0500
Message-Id: <20221104231927.9613-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:610:e5::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: c66f3150-0a40-4a0b-c05e-08dabebb4d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDiVHjqEsKz8pdckBzyIB8dDbsv4K22fUTffyzijrXpNa9VDhyxOqeIEp18u7TBcsae0RW9YL8NeVNpofjatrzQTGOgfsQB0ezY9VJHW6EYLFH+keCiG1ZnrNzVwBrQRJJYh4ITpkOV6LPWirKxWf5eMDu+kmz0yhShSJjO1qNvGj+gRNFZKPSWEXDei5QrRwJrUFDfIsyU+tp/+CZRDM1aJTpd5H+ZxUGJcIPoTmsByGQ3Ow34T6R3eo3II8lxyCwnOj8VJjGXwpypT/Np+i8QlB5xiUa9qoxuX3ZCRJNJHucn7Nx34SBVoFkw/7GgDD62VLjbMTlkM9aDw0pTAOZT0z9stcbXWKTMkDc7LDFOY1pVii097k1Mk0ZdwFSQH6PswUDykALVjraQxSvFc7euOJDIN1s/+rhSxaNY2QQ9RbRmx2dltlc5dozyl03WBz2oO9ZtthKBpticOTtj9BLtlrtce4LVRUGyHl5zZQRXsZH5SSuDo+6z2CBemxBiSYicHsqNwmZsKRXBCtwPPPqk9fPIoponO7ZLu2aoB45ClcVPy6+v8kKdClCjBUGDGV5fbgpnM6JjVXjkK8vkwzhz4cDUMUU5gkSF6cJRMzfbeMgfY2Mqviq8ROEPGfXl4qvuMu7wPwvPVBz9iaK4jlGzDO9K/ynhQ2wqEKb2QYf17XNtd+twGlcfVK8gplvEaNQB8BQCrQABEog7xRMpTqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x9ZSQ4Gq7SR2gv0QB1iJYRWPS7je4E8YpCYvM+gcKAezA3rWpbVLnkwQIs3L?=
 =?us-ascii?Q?WR9fNHCjT4ORHBdBXNq1j4vgazk6I4af4Jngd7gwGxS9BJkL4kQ+zHIKsNjm?=
 =?us-ascii?Q?Jsz0bKBjB9S0LMANKo43HNhmjPrH5SzpW26eK7qIL9d3fpqVbjvYZMleL5Ak?=
 =?us-ascii?Q?zR+SbplSYGYJC5XrnylF60V2X4O7HAcqIdit3azJw1BsIRbyheJQMJeG6x4T?=
 =?us-ascii?Q?/xSnzqPzm7SEPJ1ODUV1V1KQdoNgQWMa5hqNmwb4o0H0935FIC9SOIju8vVA?=
 =?us-ascii?Q?HdLPQRYYLvMk55TJfpudx05GwfHmP6k6Vxi9XYOtOWpdLkkNMQ552alv692j?=
 =?us-ascii?Q?OWC+xKPysHnRxrBnhbMg1tsamnjQt/IvvY8M4GOC72IRL7SxJncdn7FEV3ju?=
 =?us-ascii?Q?22l32aiWrDNRdmsUkQIi9HBxYFwGsiXS3aK0n5Uhp933Fn1cWFv7zI8G9O+8?=
 =?us-ascii?Q?e4Mcpnb+V4NkBRB37gHLl9n6sbgZw33chDsa3haEmpBF4Aubn4J1yTlLtOli?=
 =?us-ascii?Q?gMKMVnEnbbiupD7XZsJEh8t20g99rUBl0uJs1giaVViE7MdXLsCLa+0WLFbH?=
 =?us-ascii?Q?PfHuPpfhVPKBT/AX0lewbbRd2Lpi3CW5tcxVugtbo/ocdhUK3zz0gE+EAlPb?=
 =?us-ascii?Q?QEEISDAm1OM8/JT69NYMVa6wPyYrk9aUsmuMmOUnDNLeJC8gcg0DPpK4adBk?=
 =?us-ascii?Q?pj3SS6N01/qYE7CDI+ijeq0A5EgJT94FvQF20gsXFnp1WLXqFLxxLAaUb4xl?=
 =?us-ascii?Q?qb4OHat1yUlZD3QTNUj/nqAgCzu9sQbyqnOZPNpRN58+1ZpISf2ZbrJ/9NeX?=
 =?us-ascii?Q?0SuOZ7p+hp3S+QgfdbfZTWOxnSidgjySPQuc+41Y+sF3Fq+LRTOY+O/9HzEz?=
 =?us-ascii?Q?xEiDzFazt1KJD8XgppwHzi6NuMBaTR/k3h7vC2602qoYs0NTfsFV9q5+5z3y?=
 =?us-ascii?Q?tdu4Xx5sS0+vQmW8CbTWI/EAaDUTKAZFVAoCiXTsfDJ3MIMu6hKY+aSutecs?=
 =?us-ascii?Q?eQgDhfgyaY6Mu3mPA+GKnDYK6IlK4yDPp5aZzXLI+wJMdjrpS5Wjwg46NyIa?=
 =?us-ascii?Q?5UEfsM3mvs4uMncSWn81OoXpBmEijFCRXwfcFZeoan0igtqVZASvPmDZ0sAo?=
 =?us-ascii?Q?GXURXWpw1D1GwgnyNLz0jCz5XicCOB1rhsAhr/kFoD3FriofNih1nF3TvUod?=
 =?us-ascii?Q?8xCvrH/34LUViOCYXqONMlyAixyZhikpv+rG4lK/gfcMIZaTUb5tghR5UL0K?=
 =?us-ascii?Q?kEzPUpSUKERahoQIDeCatPV1E4hOOhDO5rRWFQCH+AS32t3r+BvHRrI8F+vD?=
 =?us-ascii?Q?Shay/xPUj81zbEDFdAslABFGS9bsF7N7J3SNWBXXPQRX7zXV81UNzeyyEOrw?=
 =?us-ascii?Q?vSkRSzoNEwcSIUQ/h7j5liaHIvmmXqRrQ5ko5QhlAFACbo72FqjtBgHkXE07?=
 =?us-ascii?Q?hDPgBftq1JR1Z1r06aiTlbD9DCG4wy4MYX42irVBXMzYuJBuEI/wo2dZqCfA?=
 =?us-ascii?Q?oStoS2KCWaEVCt6o1hbERTxX/qmk2Duo/nBtxltjdMhguM6BEVWgz/hwBZPB?=
 =?us-ascii?Q?XmwQbCL1w8qBAbt8n6P+ztlLUAo5EEyB5c2XpJBGYKFO+wNomvIzw6QfMp63?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66f3150-0a40-4a0b-c05e-08dabebb4d80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:29.5885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyiDbXV2gk04/Q0fe3vUbko0wfKRz1zst+I0qO4wBvNifqyZZVrQTQipAZJKYwj6UYPTMHBo8U6FrbxOCCBj7hKf5CX9tWuizHjdoquxCWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: 52SISrM52wGB8NiLPq5xjZqZkwuYWeK0
X-Proofpoint-ORIG-GUID: 52SISrM52wGB8NiLPq5xjZqZkwuYWeK0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in args. This patch adds the new struct, converts the low level
helpers and then adds a new helper the next patches will convert the rest
of the code to.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 69 +++++++++++++++-----------------------
 include/scsi/scsi_device.h | 69 ++++++++++++++++++++++++++++++--------
 2 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc1560981a03..f832befb50b0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,55 +185,39 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
- * @cmd:	scsi command
- * @data_direction: data direction
- * @buffer:	data buffer
- * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
- * @timeout:	request timeout in HZ
- * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * __scsi_exec_req - insert request and wait for the result
+ * @scsi_exec_args: See struct definition for description of each field
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int __scsi_exec_req(const struct scsi_exec_args *args)
 {
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	req = scsi_alloc_request(args->sdev->request_queue,
+				 args->data_dir == DMA_TO_DEVICE ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+				 args->req_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	if (bufflen) {
-		ret = blk_rq_map_kern(sdev->request_queue, req,
-				      buffer, bufflen, GFP_NOIO);
+	if (args->buf) {
+		ret = blk_rq_map_kern(args->sdev->request_queue, req, args->buf,
+				      args->buf_len, GFP_NOIO);
 		if (ret)
 			goto out;
 	}
 	scmd = blk_mq_rq_to_pdu(req);
-	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
-	scmd->allowed = retries;
-	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
+	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
+	scmd->allowed = args->retries;
+	req->timeout = args->timeout;
+	req->cmd_flags |= args->op_flags;
+	req->rq_flags |= args->req_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -246,23 +230,24 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * is invalid.  Prevent the garbage from being misinterpreted
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
-	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
-		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
-
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
+	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= args->buf_len))
+		memset(args->buf + args->buf_len - scmd->resid_len, 0,
+		       scmd->resid_len);
+
+	if (args->resid)
+		*args->resid = scmd->resid_len;
+	if (args->sense && scmd->sense_len)
+		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args->sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+				     args->sshdr);
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(__scsi_exec_req);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 24bdbf7999ab..cd3957b80acd 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -454,28 +454,69 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+struct scsi_exec_args {
+	struct scsi_device *sdev;	/* scsi device */
+	const unsigned char *cmd;	/* scsi command */
+	int data_dir;			/* DMA direction */
+	void *buf;			/* data buffer */
+	unsigned int buf_len;		/* len of buffer */
+	unsigned char *sense;		/* optional sense buffer */
+	unsigned int sense_len;		/* optional sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* optional decoded sense header */
+	int timeout;			/* request timeout in HZ */
+	int retries;			/* number of times to retry request */
+	blk_opf_t op_flags;		/* flags for ->cmd_flags */
+	req_flags_t req_flags;		/* flags for ->rq_flags */
+	int *resid;			/* optional residual length */
+};
+
+extern int __scsi_exec_req(const struct scsi_exec_args *args);
+/* Make sure any sense buffer is the correct size. */
+#define scsi_exec_req(args)						\
+({									\
+	BUILD_BUG_ON(args.sense &&					\
+		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_exec_req(&args);					\
+})
+
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
+		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
+		     _resid)						\
 ({									\
-	BUILD_BUG_ON((sense) != NULL &&					\
-		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	BUILD_BUG_ON((_sense) != NULL &&				\
+		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_exec_req(&((struct scsi_exec_args) {			\
+				.sdev = _sdev,				\
+				.cmd = _cmd,				\
+				.data_dir = _data_dir,			\
+				.buf = _buffer,				\
+				.buf_len = _bufflen,			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.timeout = _timeout,			\
+				.retries = _retries,			\
+				.op_flags = _flags,			\
+				.req_flags = _rq_flags,			\
+				.resid = _resid, }));			\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return __scsi_exec_req(&(struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = data_direction,
+					.buf = buffer,
+					.buf_len = bufflen,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries,
+					.resid = resid });
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

