Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEBBC43217
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKDXZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDXYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E8128700
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhwD9026577;
        Fri, 4 Nov 2022 23:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=nl179Z+Y4giOOfLRKk0P81yB7iZQAOVtwXZlPvb+4kABiUijzfzXImtXjIIQ5B+aspU8
 1NsP1m+RLiey0KVrJM0qWMg9mZYDlY8eXQjrCxmVvwz3WtI6H6TYFXj5aA6EPE266NeJ
 8UCycennQufHcaocCxSVRTPS/gJzx4AtuABWWWxegipYDUbtxdllH0hhWkGj6f8vjB/2
 nCgMo4aZz0WQgO/L0OXh6xVLf8c+8vbE5DsnhWI0hx6EicIEZQA/7WeW8FlyKu8zceWn
 AGwizSu8KyWDVAZqSNo5hG9WIbmdV0qN+81VLWjsx30Y/RNb5hYGwzTwvYW/YiJicYLt CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkdgf01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JQ7mi032064;
        Fri, 4 Nov 2022 23:22:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmqb6raeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwNtSLZA2aBtZEiFxn+E96f7bx0tGUYmBMTUaKsE58TCibiJV8xLcYJiYO75EMGEg3gVECSe/oc7EbGV2yNm4/fXv34otZ3KSBO839y2i/evrb6CBHBF1ARiXYJi1N4Ia2z9wlhONf9gUi7qdjylVz2st5UromZjBq3tl6AjPnK62MiZDmulkcW/SdNjAR7cOnG55BXtp6UlJ5GoUQCKKei4XuMiNfSyjiNoZzpmjAdRYmp+6CeP16dAwK2xp7ZYRy00Vlu7Gv/R567gj9pyfJ/oVVa/58HCqSyxtfb+izMVONSNNC9XvKzfCTSYTsYHK777pW5M3c7iofJGJLD8cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=c+BweR4uxFYI/Leila3AzOod4GG+rk6NU/BfH2C5CG2u/cyIhY1X1DvdBAgQcgy7ecEfmFTWuzMr4Nzt/AtWqVS1o4PTGD5gQWaGYy9+LsfyChKCPuVO5QqRLyy+ng3qU4W0BBF3odNGsGgCWZJ9GCnGefM6KRssy0XtyTl67Yzf4fbUsKAbFX/DKUH+k+J+8SYOZ3UVtltb3dGB3ekGTO6Azh8d1g6n/VTUR7n93tF3d6SmRhcqSRgzxg4CN1Cw9+OkcT5qyzyV++k7we3HEsCDM9MXFar5WOiQ8gzY2LHr4kaKTEsFxM3hCKsrzMs/5n2g0Fiex38jXrDKptNepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=C6t5rq94BFd0+4I2Yf+ut7Wo8ot5zzVFhpOhEOZF7siamDcqtj4SBaldGlG/nBew16PhKYr5jEnCdns1sCOKfnSAc9bhAMevKLjoWhYK/xCOyudPPzRq3XYtiRqArnLjkroEpGJPxjveAlVUp7+XnJ1OjVl9BbaZOGu42O42Zys=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 23/35] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Fri,  4 Nov 2022 18:19:15 -0500
Message-Id: <20221104231927.9613-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:610:b0::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 886b967c-d1b3-4b25-29c0-08dabebb6411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xhyY0MlW8EC4xSyq9+r+qX6ucRkbmih2T1osAYrN1lNlGrM8CDtO1xpPw35VBNAxC9bp7oGFFvoEt+ZLfHzU0BlHX2gYUWND5kF+0ECiYKqjWQpWTDDp3srrgaaECR5cmnY9RcfVpNOhxIYZHqwiH7PB6my0aoWC9ioDQIlJnA6g9I4RtWDKXUQr1u6IW/4HPDImLg/g8o6rGGyAbXntVOR2JYIKVekIiQns46fWY6gubwAe1KYw8xnNCVMGWm+4qraRVa9EfuYwAK7ATZXEHVEIO0Ac8931WhcZ8JTa1Xw46bkIa8oQQCCe+N6lk9fMBsk42Rk8DcD2Q/FBCiphvnt8uN4+Z+L2yV0fzVSe7pOvuGakzqoXf7Fi6jNGfgbFhHGHTDLMHYgWvTGmg9tdP6mnJPsqYNYatwd/VY6xf3nCmNLtQv/DzpDBsR0MtRDhPryzRyiPqfrxr7EoMm4AMaubbqMj+wzSuLzABQD3sOuHhfvOU0r0PkSDn8uIQgGZbjG3YuPGeBj/x3Lsbt+yF1L/Vh+j+h3KhKmLgleKHIhY3wyNqIZvbgoBKxL7O3MHGKbx29mQz8j81mWzG4Y8m5Z5g1D+7mR4bR9ZHG7g8wCA05+ToMjjsUpiuVuCexODwk7fX6kEXqGVN1ASzN35Mnql8a5LKv7XBeFz1ROpfnTeoG2A0IQB00MjR8fpOdfDeNO3aHlqc4QabIRieSH/LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wiAH4Ow6YPio58Iax/jzVp/94N1iSueSXwczEnr5BX/fyOJk//6eH53d9KKN?=
 =?us-ascii?Q?EjPFxhYyS1JVpNWw4piPef7mQuubIrrfq3gHwSbnTBDYsnkv2bQEZifSbYsl?=
 =?us-ascii?Q?n8N+CXbB/1DsBn6V7kb+8N6grw/vp/SnXfDrPsQO8J2mzXeYgrGIbSL32gct?=
 =?us-ascii?Q?j2mFiP0RlNKQyzCmlW3gJgmey+MgA2AfxAhuL7h3WhS4yH0lKsduVQS40eoh?=
 =?us-ascii?Q?q7HGKJ8FbB3rw0e/81L3YPNaAhh5PRrhq9xfeTmRZN8d+adui8VPVNPJrEB7?=
 =?us-ascii?Q?sEqiMYexT/GtVfY8/hjbSkPMtPF9rHF5eGHS3X9PsjWQeD7oXlUQarAIWvHP?=
 =?us-ascii?Q?5eSSadZHzs5dvUHkyS2wSadig6eskjk3KmhO38tnxfZve8Fd+wtUBTbdCxJs?=
 =?us-ascii?Q?qC87VfWrBayMWNq8oBxCmb+kYlqpEXD9uDPMTLZfqsnnLivJuwtuOdXVJ4eB?=
 =?us-ascii?Q?onCvx1xDmwTQSja3I6Wfv4TbyXzwOrw4AKybbtm8h17NM576IhmKG57HLu5Q?=
 =?us-ascii?Q?Dh3R7/rAQEFIIzRmsj6KR6K87NWmcQJyuOhzv6/h14AmYjvzlHa7cJiZwXF2?=
 =?us-ascii?Q?2eYmVKl5vP9mwviCbe1Qh4RLlMQAIY6PK7X3Su02OopuatUbFygNXNTAdsIo?=
 =?us-ascii?Q?fSVx7fTjaKvHTYwMoe+Qjh4DNfdp26GomM724rh7vXHOza7P0DCOfAUCoNHA?=
 =?us-ascii?Q?DH3YTvk5E5Gfngl8+4msL7XmWdxcYGBCyQw1k3iZV+Q4p1hvRRlgoz1OvoPd?=
 =?us-ascii?Q?Vim9tTVtf6OsgKHg5JDnZ8qaUZWURcfvRwbHfVXGpt0WkOnHJnyd7lcpJssj?=
 =?us-ascii?Q?JTGeEmR+PrK62+7Sx79fFx8Q7IJ0lZJYSPrXooqNegeE1bqgD944FMqyeblj?=
 =?us-ascii?Q?hIvn65qpBt0DbkddsWj5qD5CTnxg5zDDp0HHGGr2ioQC77JxEaLWebmsSKF6?=
 =?us-ascii?Q?oDdzbjf3o+F44wTDLhX3CDcWDJTSDX9SrAe9TPnGjhkkozsXy4OspXm8EH7v?=
 =?us-ascii?Q?xm3Ew3hUMiybG3xGYpi6AwJciPdjlSlw72v8dRF6iQWjh6XgGdqXRkopPw3b?=
 =?us-ascii?Q?getrQRF+HtYq1Q8W5l00fUeiAvpU/KimdNGCn4azMHxzjxwU8Tzx/xIp5W0c?=
 =?us-ascii?Q?BKlq16cirEY5MlJZ5UTv9gcAYwegrO6nMaNbhBluSSOVkIDPApWGbGcd/f2k?=
 =?us-ascii?Q?QdT+Y9sOA1Su7Pz3Ri2PtZRqwrmTj2BIJhTR8qgFNEgbagP1IJUIX+Grb48p?=
 =?us-ascii?Q?QOgjuf9uq9tfvMorQR5lC3sW1MN3GrRoxMrTgOV97PVufTRJYmQt0SxyZGmE?=
 =?us-ascii?Q?/Lylw+sJr+aG7e7/Dkhiy0K+LrzGLj2matE/AALVFDcYGZh2MMBqFZd2qNMc?=
 =?us-ascii?Q?BttBI1ezJkWwvqWz1LDGK4L5NJbRvEe9JotOuF4rFFSXjqd0n62DlSvPAmY5?=
 =?us-ascii?Q?ihCT4SulkwFb+lGC6rpRD9sOEGJ1Qbs7sI7CH788a3eZfTigAsylUz3YAm76?=
 =?us-ascii?Q?tbvQP7NGX3Uxb3AaZxRdVsdBIvlAy0zg5Jwr3DNNKC84CVospt9vfAFUHgdc?=
 =?us-ascii?Q?GZH5pNVx6psZyV9HmfUqlDUIG4NGkTaSZcJHl33/t0MAPNgzQYkssTQ0VsBY?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886b967c-d1b3-4b25-29c0-08dabebb6411
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:07.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ariPkk7t9AwIkeiaYU8x/QgKY0CSuQgPwKSn9qjP5XFE1XZUjBoVYrkHJwS3z1QLZuRbhqyvriAjthNE/F7V8NpyS5MCU7u+Y6fdJ+kAGI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: d9NsbyyyIhctXT62gw0dvvafvPLHMpRa
X-Proofpoint-GUID: d9NsbyyyIhctXT62gw0dvvafvPLHMpRa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 46 +++++++++++++--------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index adcbe3b883b7..8c09d512a415 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,8 +82,17 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -94,7 +100,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -108,8 +115,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -126,11 +131,24 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -138,7 +156,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -149,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

