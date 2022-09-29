Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC03C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiI2DHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiI2DHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:07:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C51257B6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:07:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiJbw023231;
        Thu, 29 Sep 2022 03:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HZwk+uqr5JjRoOW/mBTKBGTe+n3k5sgsMwGLsngr8B8=;
 b=qO/s9zojS1+s7aGPoTNxa2jV9+LQ7A9z/diaKFC3EnFKXq/nqYvdw+4JtyVwfbkbgR6G
 LaWM3/mWcGiYP7A5RAWiUExWJsoJUZZIMHynlvl6RWhxI7TXwhJ6WzmGomIHu/Z0OIvF
 sYCvrxXCp/x5RtF/ZST842Hkcn9R7ml0GvkUDeCEYP2mBjzLm5QV6Z4WH2W2D973ENSi
 0oswto0HxxLn9A4KIiSHeq+i+Cd84ujsJP5EbZoVsi6m9dW++rB9A/+qyiYNuJtC6qC1
 0ZrqqSiwLJ7OB1Naxcuc6xZd+WOjTp8MUE6YD61JLUVqHt7h3ZeKsQGTbnjAFAAY0r8N KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpu394-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:05:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SML3Vk033548;
        Thu, 29 Sep 2022 02:55:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22r08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggwXiTuxTWFVyYYAxI9Qz8ms6BFguKvEYYxAyxWL4wHT4pnS54EHjGAqQObMcz3SjXtjmygNFXrPa4PX33HSqAm1sWFY9LmgO6KZhATEwBDmw0/UMcQizjF90xye5ajB2dS6+EX76nwxVaIleM1x5PUbD8YixsP2aqjiMqSRPLWvzMSkeMhk7ItdAARIpqcztnU4+RcDsXUZbjo1jiKKZ+zzmZFOL0M48HpK1zXK+MBM4o/lhX9K0Csthk81ixDYGdclH/tRjB2LxOUoNF6fA5m93cyhRrq6lYOCJh8IV2r8ofqigqHyOeAhDV+Hwnkm1ETm4jaJFeRJC2iJt9lBhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZwk+uqr5JjRoOW/mBTKBGTe+n3k5sgsMwGLsngr8B8=;
 b=fV09jvAwg3wn+RAIn+Y9ZgdbJyi/YAsvl7BWoxDUwYkdtKUUuMz6DDnbH9XtNvWG3vAnwS23k7JqGynRGRhsJ7jJ+9f6+SfUTkrNgBbQm7Hki9wJSHpi18ufyZUKWNytr09+0tl8MoJaMmTn7wwLJzy0IIr0gG+vfgepA+YbMu/c8b8gjs6ycQX0CSbQDifkp4idIp5qazQrvsqNoZK2yHLHEKwCSdU7P0jgzgIREProOXobJaVv3TIETwrFlGfZAwiaehemdauPQFyfJwj9TFFjaL0ZESCZXrnQvLtFI1WVcMN9hEODqDggsZag6m/5eUGgJcgE+awychy3EiqLcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZwk+uqr5JjRoOW/mBTKBGTe+n3k5sgsMwGLsngr8B8=;
 b=fWe8FYsYd22EesLEqMAo19fQW0u3gwKWdxoHY7/vDnwmWzT/A/cbjNcqLKYxDpH8xSeYoKVwTWco8boyWILeB1BaCO2XjJfhN/FwX/SP8BnS5Dl2lwO8TVRCm+CKHUVvcIFXUl8kbejK6uW90BcjbOFwnVMVYKCk+wIOaeknCik=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:55:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:55:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 33/35] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Wed, 28 Sep 2022 21:54:05 -0500
Message-Id: <20220929025407.119804-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0002.namprd19.prod.outlook.com
 (2603:10b6:610:4d::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: df6cafd5-6876-4a35-33ee-08daa1c6010f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzjBA9kx5FRwlGLP9AByFNofSl/pgVrWnuV1CwPyKKrjESAD9FDHscmesyNydlANx7WFGjZSDyCqze692W/uTxrOwn3qPcv17D25oz1jBLAIVeVSA82+F8e93PHza3GZhbAWGsID7Zl5uY6yBsL8Uqf/QzR5ERfFwglLHYuEe+qqEeS02LScwjw3TljyGP1GBCY31V9+ElWR+zcLlXSj5gy44lhVTEFL/J2j4Nvr2X93CiZjvMzJNG+ly3yzoRBPxjUHdOFih9SHWZGZysBJSw67LZu2Bnx1BoRCFRjR5cngIZE/8smuY8sVbxJIAeTWWdZtWdr9qCrOVNQvN1DNbq+XAIhq3UUQlIT9l8DbqVZdHLhO36bsoy8ClQ62KZTnkQOS8DnyX7hD5jLmstgTo2mwEg6WrXFkth7GFTklva/EZ1TDEWaH5oqOCN64DabG2/XVP2enGoyGbvHjiH+fgTRLU4RFNzkgnPCaJKVamkLlPpNMuXON2t+LOb2+As7nTpXNXAsI0Z3OmqmLECLP66PZwtqLqGkuvBS8eif4+xjDScyFQsgYpqdOi+QRgFvl7C5khh2jpck+Z3tiZhxvS4IOnhmFoAReDmuh+i5mnxP6It1fDsiocDb6EiDbSlzCOUowm7QnPrpdjpTYSzbI+m46sL6opnOeTRk5FSv/d0xcGc+NvfdNauSJzZ1I4VV6T7YJCNelH5W3cSp1w3XQ6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PvWE1q469hLMkLxrEHEu5AZKbuqwO3hCx65MCot1xeSk52z1BSqpD9uBdL7y?=
 =?us-ascii?Q?gf7XH869MFOnU1Ng8cjS0vL6VN/yBlJVZlNudIAk4DTOrQl71ItMYaZ6V6zr?=
 =?us-ascii?Q?dMYjD1HhkgahqBY9+cU7CflONK/Z93q4ldW+9N2rR9c2j27Rv64I6JUEA358?=
 =?us-ascii?Q?jfOdXUvFrJjqZ8kzWT+IkXIkmr9VYc7aMoqsJJ8/xgN9mERsftlwUJKz1esx?=
 =?us-ascii?Q?WU/7jXDfI4zeysGy/DGDDTLNvQEdk7XcbONzsiGU7s2pM3IvYk2vIMMsMeVF?=
 =?us-ascii?Q?Wiv0Qx5xvRz53oaosrEJUHbdl109/6iCpXx+SeYORZErOLMQxHwIVtnQWAZG?=
 =?us-ascii?Q?0Uo3SHhpnccVYkMkYoAqaZBD4i4YeQXNmwJkMnCbujl4+HHyI6E0Hn/dr6jR?=
 =?us-ascii?Q?2+0sEyGmQm7ddlw6pn6dnONjTdZSfpbQ/JOy9qiBlLpVLU6Pz0TJE/GE5xtJ?=
 =?us-ascii?Q?Q55mrT3cOMzykrujz3JsB00GP/52wVZy9iQQsjiVpLTIlhm53xZtHxbpj37h?=
 =?us-ascii?Q?pLAq0ImiQHj22TuhSEPg9gyMF4BSU7x/1KgOSYkZ2UjNM4NHRGBCsadIofjB?=
 =?us-ascii?Q?9Z00UB05HPnVmjlxLDYRYUPH5gKil5HJcf/8RXjyl3g4HH/CS4nB7dWf88Xs?=
 =?us-ascii?Q?lz92CFFVEeKQ8IeF9TvAawiqglEAJ/9W24gSrhi/C64J2T/R9gTNcz4hbuh7?=
 =?us-ascii?Q?d/CxJYqabBmw6NswW2LqVpUC1Q+k6gcl9EvTkDEWAkvMzK5p6kosfpX5Wql1?=
 =?us-ascii?Q?Yakune35FCqOxM0enAXuhJ2rXCWqT4Xp2jMV6g61HfjLgSjWy0oZgRpnUJDc?=
 =?us-ascii?Q?e35dS23wzh5NHjXzizYAVsnXHXu5XeL0tYAF07E78KgW34eXTQOID+M2zEzr?=
 =?us-ascii?Q?VB81vb3BfkyyGQcPs6W93R+aHfgupFXL2Z0mTphY6sdxSjfbeS5L9Imo6YeA?=
 =?us-ascii?Q?G50pVMMfrN8qO4AeH+Rbhjld3R473piE0gPa0GGnTQMzX4HdvJT1G2aAaxVs?=
 =?us-ascii?Q?+IgHaY6+yU28XFA7+UCZEWbdz5ZQFYI/u/A4G+JLMXSMBZI0d1BFpyEGL17a?=
 =?us-ascii?Q?0ayvTTZOP1NVf9UZyZxe0cr3zhjkAQRtXAzugIkOPW+ZJC4b6Je5CUM55s6x?=
 =?us-ascii?Q?xReYO8pWrsnJLp5LbipX3Lt7vXiLyG2Ds+hLfHeJWgkulE3pJpqr+o9Yuhgu?=
 =?us-ascii?Q?Ju31PHzBfr1F/QpQK57w7KcfOZXh3lidYbQKL4czH2CjI21qhVfd67JMeFdn?=
 =?us-ascii?Q?rSpNtImVxavyCd0y8z+F1TlSMymm4rsBUbhkwBhoPhIGxil+Z3O53Fe8jpMI?=
 =?us-ascii?Q?xJdT4LLg7Nhy54RLZAfhK28ryfKxk7mE+l7dxzeZAfEr648Sl1qagAjzzSEJ?=
 =?us-ascii?Q?CNRemZpTtM1xzwhKnD8cjr4klSPzXXulTH17wU36nS5siYSZeVGaRzmKRKUn?=
 =?us-ascii?Q?wpzX6sLdyISpkfv5ze8H5+GEDR3DyJSjhHdraAOZJheJF17cspVtvGMX+BAv?=
 =?us-ascii?Q?W5LDdjLTwVF+wxh88zqbLsFdAykiR+Ae2zSzskA/4GFr/yQ9mhGcA4xEQ+br?=
 =?us-ascii?Q?Fb484dRoRyJMlt8Ldj3ocv6RE9Nr7z/VcJu2vT6lVVI/blNYiHhDNfA8srUo?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6cafd5-6876-4a35-33ee-08daa1c6010f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:55:02.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83v80bHLSHj0PuQU1FPie4zFYx5WDao7W/z3oNRDpTypNTjYvJEeysqujX5FCiGvkGzYr/btDptd/iHVaaHB43ExMYvb6zwTTifbWskoVnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: 1eYTPHECECFurpN38Rwp0kcmk-5Ed29Q
X-Proofpoint-GUID: 1eYTPHECECFurpN38Rwp0kcmk-5Ed29Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c90722aa552c..d8b31c0b0125 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,23 +87,33 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
-
-	do {
-		ret = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = DMA_FROM_DEVICE,
-					.buf = buf,
-					.buf_len = bufflen,
-					.sshdr = &sshdr,
-					.timeout = SES_TIMEOUT,
-					.retries = 1 }));
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = bufflen,
+				.timeout = SES_TIMEOUT,
+				.retries = 1,
+				.failures = failures }));
 	if (unlikely(ret))
 		return ret;
 
@@ -135,23 +145,33 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = DMA_TO_DEVICE,
-						.buf = buf,
-						.buf_len = bufflen,
-						.sshdr = &sshdr,
-						.timeout = SES_TIMEOUT,
-						.retries = 1 }));
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.timeout = SES_TIMEOUT,
+					.retries = 1,
+					.failures = failures }));
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

