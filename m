Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F75C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJPUAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJPUAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ED6220FD
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrK015579;
        Sun, 16 Oct 2022 19:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=hgybD9ni4OjlZZj4/P5Fjcbcn7n8NoB4IrvjShEbCwLNoyfOc1Mjo++RH30Lzd1mKJFJ
 Q8+nGomniaE7KGilGxxOGt2pplRd5o7tiSt09K0neZts4E1L6RXjyH/KT0cu/uBVNEvB
 sEycKUNFpV+cX+R5qyXcpGy/L9wOuqavadM0EZVem09ZVDHdKIzZh/gGj9qVVwPc56/R
 FifRXX8q9FyXFOe6MB0qx60+LqHn0y/cqx6pFvEY5Tkv4UCtJ578b5q7UmNUrs7mpVFy
 oHUIQAz5oE/xNekZs80hM4yJJJtGNP4vEXmgVj8bGgQmnQkf7CrsjUbtUTqLiibkOFdX xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g79m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAa7k001092;
        Sun, 16 Oct 2022 19:59:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgfm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgbY94NAPfXV4svo6Ya0UtFMi6au0OT9C6RROJHJ8SS1Q/Gta9ZPqh7TWiXrN+Dz6rGdvIprejZXrOC9fMGVKy9Z+AltYuzd8Iglzbxou/7g1v19geHDa/anNqxGp0gfY8QA5wUz4UC2XMEn8ze3QuqdRpJzu4S9uhLWBWbco3EH4ooIiX6HaqYZl4EYiPGoeDQaOJFfA13FcdHzH2DrrEs0LyTnr2gPS0I7+MUQ4HucjLjlEhRBvdsJNWWXg5t5VG02WAglpb+uAGCo0b189Sc2itUbGv7y738xowZ0Z2zTttqW+B1CKi74etQwveOPgHEbA73bDj/jgvPnMvabxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=VBYPlr5kygy57BQPGn1sACuKQBb3ThcgEva2Xy8dWHCHNBbqsJ37OE5f18XmBGrGWfKdumgI1PU3B05hNdw/w5SHpNExw9VSmTIHOWLKIiWLoSbGBWiwojmK90SeSfvMJP1HmnPa87UFARlGAzUoEKB1fIqdziXzg5o2ZKwiD/+9eYIf4YTLPwKXsDiq7BVgBrlIacR7GawnHf8MwRM+vS9+KDw2x2VRa+5CsFRHUPjcq/YVGLv+OGfaFOW7MfzlyBdgjNlRC/LpMWmXGygk2TmjAmISYoogY9f1GA3mawWxcA5PIoEcTNDxvw80FsrqOvj4y9U8JxgW8i8uHwrdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKN/3na6/yeB6BRg9V7tGq/OT9G+2mZyp24rh/u+TKE=;
 b=zAGeaPFbwhqR1S2qhrnQKgA5y4YJIaN4GKxpcmPCn4z0ILonUdBezNRQ3WZYId7QZeLbG3kUgVbHOHvI67KMftk/u27b0MVv7jsGryeVPsBmA6nz+CQzVIPVFXPrEmxu+W/OHlZHeRTDAbzsTyHJ1sO5gKOf/o5HZwOnVO+mJig=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN0PR10MB5909.namprd10.prod.outlook.com (2603:10b6:208:3cf::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Sun, 16 Oct 2022 19:59:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 03/36] scsi: Add struct for args to execution functions
Date:   Sun, 16 Oct 2022 14:59:13 -0500
Message-Id: <20221016195946.7613-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:610:5a::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN0PR10MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0bdcb6-e7c3-4ecc-00b2-08daafb0fe3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ul1+Od3FYODAU67JhRk9LC2pOdsAnLeqvlCwQjyTkmWWHKMn6Q+Sp7mbHhxjcWL4yTmP6x4zQ/95PrRw3doQWVF9+2ggmUqdxRWhEVsRKPCYidfU4FEd1/HPwVCg4a6dh50jWH9JPT9OnB2es+ZlY57woVvHHWiFPOVLFNu2H8m/5yHamQmjHANQ9YqdBa2Bz+O7KrfCDWCD90DOtQEoF8cZjHCVMFq6jg2cxwC6fTzk3UZawi1CzQcPgy8u2TJ6xx94Cd2iSm7mFTIm5XM5LotDF9bPnuJi5qO7SHFgMJggUSnifGC7Wsd9/kOcO/zqjnbxqRHSWq7TEZ9Sg4t8Roh6drdXlb2tQB1syJ+Q8Vo4yTveqF6JkS8KBr7cmNHCiWGsnWHNCdRgHGeMrvTi5lOmOvFcnqVlYOl1y2cjFy58PSTATO/v+qqDs5bRUHmqQwtO8jz7L/V2f/yZ+iQlEcLzo8ZJIYtTR1jlfuxDzmcJsVrCuvEuOXI6eZaVwdp8hcNAJoRnGEcln/ccUOmuXQLKGzgg7fz2dNiKJLzDCDgajV1AKnFdO2EK2/Ml1XKbEAMJvie9cUSylpnTcjMN1cYJYKbrp4WK2g1op8Md+kuiSaaprXUPCA7oZLMcC3LNtfPJIVDDLvoZVPEPklcKmtjvg1Ecm1iQEddljRAdnEm1q3nI+nPDVriDsJhYS00gOOLb48Uf0tA1kn+F4SGNYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(6486002)(316002)(6666004)(478600001)(107886003)(66556008)(66476007)(6512007)(5660300002)(1076003)(186003)(2906002)(8676002)(66946007)(4326008)(6506007)(2616005)(8936002)(41300700001)(26005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GerLQtULP6+T0le9adGawHaC0DiqqQ2sruNiFQ8anoM8hF1aP3fOtL2c4ET?=
 =?us-ascii?Q?xSdVTBYNCgnmrDu+ADkm4ZAj+8dBB2KYYp/W1ncZp98JvfF56gFWvsA+f9as?=
 =?us-ascii?Q?nBqPIHwg0JQzhEKlowUQzq+EDB0ICb/SbEf5fFv0cfOVEhmjDwaCufkBeOdN?=
 =?us-ascii?Q?+vTpuw8bYCAWC5Xr9950p8PfQknII5V655AzFWigp5NMOtY5BxQIYtWbQEEE?=
 =?us-ascii?Q?iXbFBQM3GdZfMECyY5dAPJ1D3btzDo5QmiJbijoiqo2vNj7HankMmng9VqtT?=
 =?us-ascii?Q?hL8QBm748zwJNmEeMHwDHqHS+GmnFqqUlgXzatOFmuZ9GIxSkfUpnz3Fk7G6?=
 =?us-ascii?Q?/rremQfWr6qE9RMBNInNpR2kjzfs8gUcxjfVPWN3CFi8tJ6CVhvMn1TLm5WM?=
 =?us-ascii?Q?SqnbJEBy1B3fINT0iiIvsAh7ceRTg4pb9UUZ7Hef2cwcFoftjtImK948hrye?=
 =?us-ascii?Q?7vfNyGzEuuSH3XX3x0Gg2rDUOyS9juIe4w/sGraXtntXiF4qzh/Fh3PRxKL2?=
 =?us-ascii?Q?hKWOrQF+8l1joRNBcHPSy9IHU0qh0SBU5xq2QVV9G+msY4AL8tqKl4eJqORT?=
 =?us-ascii?Q?lsX1FTfDvlI++odhD/zuhNVZIvs5QCq3WxDZIx3dZQpZfuoT0ri5HNo9Ny5k?=
 =?us-ascii?Q?oAPiZakb80KsNR3FDFqv4FZGiKsEkhonwFYG+a10eGGU4y2mk1kIKo2WhB5B?=
 =?us-ascii?Q?WhffafzefZhv8lt9R6X6TLxekzzBwVVAdXoNZY38PwldiHAe+6JiW4+sbf4H?=
 =?us-ascii?Q?smBcYdPIlxVwBxO5HC2B4xXho7gKbwaTIHpMTQk4CLy8NDCiyY1ilh2y5i/H?=
 =?us-ascii?Q?KA8PSeD4Bj6uUQsgwh1puhgBP39270gBgjrbtIPOWOHlpJhIoPX3bfQg5ZOE?=
 =?us-ascii?Q?ju7CTw6oVpTvH4+1nedWYmwneeYpUs+5b+XvPnzXCcGNQjFe+HTKewP2SvCp?=
 =?us-ascii?Q?7rSndrh1lZV+xaoEMu2HKY0fDp0whIquo+NYYpssEKdDdzzOJ/4IYg5jeMwN?=
 =?us-ascii?Q?ne2ox3AHPKrBfBf3XXNvFnm1Eq1rzinIOTQIpJjEcYW+Jiqz6ehmDz4g8FHz?=
 =?us-ascii?Q?PWy1OBqsnszTPKg2IOP3j/CBxKt8YPVu2jgGcc47CRjfB/dtfYkz7V1HNQGh?=
 =?us-ascii?Q?Fc7nFddUto/Oz0szMTNerFifX5zKGYDaJqkZIcH896ewu2kOdhKWbSE6AWZl?=
 =?us-ascii?Q?5zgJV5xjnMubiw3iX/duYrYbbj3MfoBaJSWzOT6WKXU1s00jPa/ZFQKG4Vjw?=
 =?us-ascii?Q?Cb7MzL+dmHWytKdPoyN53ridhywyRDl5J0Qi7sR5rhTyPx4uOlUFyYemcQlr?=
 =?us-ascii?Q?E20X/G3sT0M3WHopE3Cfe4WhaJnrqjVxIw/JEV5IAlCBnJTA1ZDA4+g8O6en?=
 =?us-ascii?Q?Z4ckqcHNJPCQMpQQwN/XGit616IlTavLr07I+btNy1jHGarDCXNgSTZoNJNm?=
 =?us-ascii?Q?tTiIOFxULh1FWCZIkE/ugBFW5o/ZCe/BKMsgOejy9ube8BJphyCKS2x7R6oO?=
 =?us-ascii?Q?tfDKkut/Eh22Ctpjd3Y8ckEB+5ZMXg25CQqz7suvmGR30RuRDbH9A0gAz+Dl?=
 =?us-ascii?Q?WxKjojWUeuDtTKb40JB9ba3zpRosUYI4sLGtpQoIMCvcWSZEft0ACOJzs3o8?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0bdcb6-e7c3-4ecc-00b2-08daafb0fe3a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:54.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWZfE9w1yNZRQTO+a8Z47xt73f2cP4jsENhjS0kT4P7vw25oLau7cB2cYX3jOEg2Q6nz/7scxC421NroCttiHQGCX5noGpgx508av/Kf0O8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: VrzlRefTBD4OjqV_eR1Fjir2WeLTRJU5
X-Proofpoint-GUID: VrzlRefTBD4OjqV_eR1Fjir2WeLTRJU5
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
index eae438d53ac5..f0c55e2621da 100644
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
index c36656d8ac6c..d49a7157d7c1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,28 +455,69 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
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

