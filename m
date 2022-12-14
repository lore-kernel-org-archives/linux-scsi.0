Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B2BC4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLNXuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLNXuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D1846659
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:16 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwmke025815;
        Wed, 14 Dec 2022 23:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9+cE67WzofeCnO814dtrZv6j8MFFN4aUGWehf9HlcJc=;
 b=SMo6JLmr7E/0AFcdSc//PbSzAKaj6h/SuQdo//+Rg4AzX1SJJ0GRUbxhNNTv+CDwF4+X
 G4qvj4ggLpEb9n1tRiFeIgVVbQfy2+wok3vWf6MmAX4y6uCiwKRu1f0LC/21CR7AxZ1V
 YtpGVYsp1Cun083BWGFRwsKecvwiXI1Ojs9MfuUDtP/zpbsZUinn7Iv6qQTw8U8iXbIN
 RK44Jw6SGrLN3quzHIH4EBqXwbPlqjLQRnBQUuNR4F8WVc+p4KTplKkJkBIDULzh/wLn
 4eZPVMEnPN5oonxQembr+CJ0DZ409ceWQImzDrCkWE7Zy5DbOvKgIo4hsX541VMoLpjH 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewuq90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEMGp1L004050;
        Wed, 14 Dec 2022 23:50:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewunma-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYn1YQrHWA2jWxJwxmNDm/YAG82qoz65d14ZAbyAQh43/jeFgpnEUtqQHOTgtw3XoHLpYWTOCTe6EsJnUFQhItQuiwfqwksL4RpQMHFg2pY+5KLM1VoN3TNQHjA7wWODLGJBbIvm+Hnauu4kjyWOpIcR3Z468Thl8oHZYr4DPCRjtFROjsbl7kI5itcz9U4N1I7u6hj4CcQWQ5jgZnh6+LnFCSwVMb2qppifwEzOSQcnC09X72doUUlb4b1f8BOyvF2n0IzS6dgAJzDHugZClm8jKRY/A5eO1FAoQgzDxfNLBcCccVMNXVj64D8a9OqifekyCJQ/nKNmOasE0GtmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+cE67WzofeCnO814dtrZv6j8MFFN4aUGWehf9HlcJc=;
 b=Per0Q5WThj8DRIXLOHR/82PsOwRblRJYeOCzAwq85SkqS1hLl8KpJX8eC5jEEhTuyx2Gp7ehBrRf78FiL4S+TjMOLg0ArYfvas4bnzqhilzPQQ7xGmbSyG/KBrarj9QD68dNwJLxEMYOavCqQBzHx/6fY36S6+KNpZUGYWsWWa+mbrX8rtNIht0qODzuTPd7LTf939JhQDjD4zTMqBiba4/AKAFh/r5wF7ASfBPCHWiFYMtbKSJ26vXAL686AACAsfVFQv9ibNv+PGfX5/kAis7mTW93Nx1LJta/INOiACxvHgDSdLmAX/NpMasZ6ItFPadPPryPBtGEt90+Y5WsYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+cE67WzofeCnO814dtrZv6j8MFFN4aUGWehf9HlcJc=;
 b=Lbu2e2P985XpZ8Pyz9XJhwkppP2UHD+8n5DBZhbQQSrInC3YavHa3U5ax2u54ZiPi140XHH4KSvgl91HA9rh80ZlmP8unNhOFH0xtRJOfCqH5HLkbP8nKSg0qVyQj65GrIvIkWFjWjh8oPgJlQIZqBRTISGThqnQ5JLLlpRKerA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 01/15] scsi: Add struct for args to execution functions
Date:   Wed, 14 Dec 2022 17:49:47 -0600
Message-Id: <20221214235001.57267-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0072.namprd05.prod.outlook.com
 (2603:10b6:610:38::49) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 00578149-efc7-434d-25e2-08dade2decdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9j9YJVJHKuS8IKR8sRlLe02XMm9ecLUiMW+3ljKclgTL+MPkkXyHentFfvjRHhDnlC4NCRI8o4mAb0n+N0wI2R9LOnPrtLW+KXWUJCWDaXTQKJMXsqLyYAbfg5I8mvAqLPn4I4BWsEI2Y6TLMdAXMzmUuiGU/aEwUkWKHaUCPl4LChvzSLhH9GS2/BKoqcHEeaLtTYCWlM8WFKugh3SpoYoorTwsoeiJaob1hxrlRd3Vop4HeIz7YHUXmP7yGwJSnCr99cMY0rq15E80zwTiLL/qVu2IokkiO6UtQT1aFrQhxE4lISi/SYYRLkZOxIr3MSzbQaOfZR/UtmCyd+VznFQB1LGhlqJCFHKLbH1cCAWpPXkSA2BamGjWGUY4s9BUfJUogPSyj1OHhuNelqwqntOFYUJ9mv8ZBjP2qWbOwVQWLgXgH6FUu12YNRWLwLxZUXkjlA1zKodVSYtMO3PPc5gT4U8yJxB+CoCO6cbCgD0GWUqCHKUGowFaCzJdhJ+IyWT3rJrsXpNGlG3nrEXRHEGhd+ijN+36uEhf+0RlWqutgsixqYTbVBYBerVq7vVA8jkeMeF6A+PmX+kxLxYMoN0iq6ZTWW4s7OPsSC/IFcEc5Erc1hWQ6U+B7KfdTqvEMhyQRgEM6XGUrTzpg8aww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ScV7WuOh/nm0o0r2Y1XXozfWpVso4t7vPd5Jzw1KIG3RJP0O1Z/L67xGU9U?=
 =?us-ascii?Q?WFIiM/ilqOU5jWpBOAfmBNhonZAymXeLbHesYLdfpXS2ljZAHbviMp7i3+lN?=
 =?us-ascii?Q?qkfbb3l8CXZLEhZtjANirxX6ngNRgNM/R+30eSYJabd+R0yp3ICSkKJAL7vQ?=
 =?us-ascii?Q?bV0Yq76/3rvE+MQNWkiFySLCDzPZ5UvEMCOwlMcb2oGZd1pswhTeWHOVQ88L?=
 =?us-ascii?Q?SVI6O/kCdbFVmSENXLfrKa6IZlucujxdbPdpvexYdiJWivp6Cr+ZKXdwoDQb?=
 =?us-ascii?Q?ZbKhMjRU0B0gWwf3OXnVbRDb52PnJVEkH634JhaHqbqMhuc56yYq276CYIUI?=
 =?us-ascii?Q?+QWZIXCvRqA69Qf2CE7GKJ+LZRKCG0NAisLHE2q5yz5SOktVcPkD0sfx42oy?=
 =?us-ascii?Q?KaHqgWy+QrQb6qXgBlK2nd+3abWhI6Srb3BhE8X7jfqwj1ADxr7KUulK+Q/k?=
 =?us-ascii?Q?JcjVViNaAb1G8Tnwvzosmw265MCAUh58mHG1YKUeFRDcaZds9Y3TIskaoBD7?=
 =?us-ascii?Q?sGA+Rnikb9NSMg/QR6rFXrEEqOdbsPY8E+TIUIYpWnHecL5psPFZ7Qacvel8?=
 =?us-ascii?Q?VsmEdjUG9Ac9Dgz06YF3N9RokR+OyyMj5rlvE8nrZ69W1AYaPfhLaaXXuV1m?=
 =?us-ascii?Q?i65zfQqa6tgbjQHsQxKawy5AWUBLnLHZ9w6xKzFcJat0xLPywRDXmRvfXrHK?=
 =?us-ascii?Q?8zxbqF2ecWvtGp2Mzb7eykxUlWGUYi0U8n1l7ca4Cme+BW1g93Wpv7g4IFhn?=
 =?us-ascii?Q?cAaOu1cDxky8D8aGyzwoM3lC/KMNReWnXHk7DV7ji1MqIybeKpibKrC2L72U?=
 =?us-ascii?Q?HOXyKMTMSqacy0sAJsx36KY8UpaSXjhQoRirkBJyaQgMDUd1hAmPPKpNHZKY?=
 =?us-ascii?Q?s4IPTzw5LdgZqzjJDVA8qfBTqcjVKDFsX1STYc2qeb3GO4W8Lp7ySlB/JL7q?=
 =?us-ascii?Q?CK1OuRvZUL9mQuLfYKwopBS5ElXx38jLw89Ifslaiia0lcNd8lVinH7v10pz?=
 =?us-ascii?Q?PODoczrG4wpLBP4id36VSUnhyeCpntlWNK//Pv5YgazucIfKA0BVlhYdMSZQ?=
 =?us-ascii?Q?oljWFOFruh0mwqQ9Q2mGCXpaKDhOG7iva1DD3HR9S6f1Pqk2ELkj+Syyk196?=
 =?us-ascii?Q?RdnR+9wv/irmSVlAtVeaLwA2bum8ruswrOwNxxNnnpp1gmPBNxOF2YmdG+Ac?=
 =?us-ascii?Q?ZrDNs52uImVkQ85Mc6nxEKglg9vxZbpPmCSUhfRHTSp7fQmYZp1sKIfQnRtO?=
 =?us-ascii?Q?J3AUlrgIBppn5ktvYs/heWuberNX59ArQD17MKPVcyo4do8V9+C4CSLzqFdr?=
 =?us-ascii?Q?a9UZK0ATOUZGq0ZQfzzjZdennze9qg7x74oEuDkhRIPI02GqhlfAI2LQ/Qtx?=
 =?us-ascii?Q?GwlvdJwSjTel9sjkiTveYrgxLlvTI2UBP2k2dLFxXsP5N9FW+Fca+ROQmuey?=
 =?us-ascii?Q?GeYFtAZLCYe/Avsv9/Tf5k2rRfJd5/GxlQzDHzYXjOPwen4fT+9VtpHgmwy+?=
 =?us-ascii?Q?ZQ0n7eyyAZJhEzfkrbXuAY19ufCeCTZfeb6+HEEdIgWRpoiBq/8Y+s7B0HeT?=
 =?us-ascii?Q?k8Kdo/a3+OZCHVIieNpdwdO2JoWVvhAC7ClIbuRdU+93ZtWrthIqGAmPGt8w?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00578149-efc7-434d-25e2-08dade2decdf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:05.7319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ay0U2R6FSZy09cxtLoE7LOwWeNaTUwRqVL/ERmUKNCQ9Maa1I1/m/7nKiKCGbBDvmDEJT4OmqKpEQkHxjYhyJ7C8yuPmpSX+I8C4xaTZWrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: rleV-Wv1e5E4kY1ai2-gN6O4td-O8-qf
X-Proofpoint-GUID: rleV-Wv1e5E4kY1ai2-gN6O4td-O8-qf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in optional args. This patch adds the new struct, temporarily
converts scsi_execute and scsi_execute_req ands a new helper,
scsi_execute_cmd, which takes the scsi_exec_args struct.

There should be no change in behavior. We no longer alilow users to pass
in any request->rq_flags valu, but they were only passing in RQF_QUIET
which we do support by allowing users to pass in the BLK_MQ_REQ flags used
by blk_mq_alloc_request.

The next patches will convert scsi_execute and scsi_execute_req users to
the new helpers then remove scsi_execute and scsi_execute_req.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 52 ++++++++++++++++++--------------------
 include/scsi/scsi_device.h | 51 +++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a29d87e57430..7baad7ec8887 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,39 +185,37 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * scsi_execute_cmd - insert request and wait for the result
+ * @sdev:	scsi_device
  * @cmd:	scsi command
- * @data_direction: data direction
+ * @opf:	block layer request cmd_flags
  * @buffer:	data buffer
  * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args)
 {
+	static const struct scsi_exec_args default_args;
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	if (!args)
+		args = &default_args;
+	else if (WARN_ON_ONCE(args->sense &&
+			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
+		return -EINVAL;
+
+	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -232,8 +230,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	req->rq_flags |= RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -249,20 +246,21 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
+	if (args->resid)
+		*args->resid = scmd->resid_len;
+	if (args->sense)
+		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args->sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+				     args->sshdr);
+
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(scsi_execute_cmd);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3642b8e3928b..f6b33c6c1064 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,28 +455,51 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+/* Optional arguments to scsi_execute_cmd */
+struct scsi_exec_args {
+	unsigned char *sense;		/* sense buffer */
+	unsigned int sense_len;		/* sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
+	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int *resid;			/* residual length */
+};
+
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args);
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
+	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
+			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
+			 _buffer, _bufflen, _timeout, _retries,	\
+			 &(struct scsi_exec_args) {			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.req_flags = _rq_flags & RQF_PM  ?	\
+						BLK_MQ_REQ_PM : 0,	\
+				.resid = _resid,			\
+			 });						\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return scsi_execute_cmd(sdev, cmd,
+				data_direction == DMA_TO_DEVICE ?
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
+				bufflen, timeout, retries,
+				&(struct scsi_exec_args) {
+					.sshdr = sshdr,
+					.resid = resid,
+				});
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

