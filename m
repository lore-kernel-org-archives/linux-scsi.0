Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48649C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiI2DIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiI2DIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:08:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F6D1257B6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:08:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiSHQ020728;
        Thu, 29 Sep 2022 03:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=i9ohR6VgXWqz2KMob+NzCYs0/N7uYohoU273/j3z6t8=;
 b=mAFM/j6wKuUe4BzFVX1CKlLCXIWKszWWLJ5kUg9iUfBfkmNGwgLn9ryfmqb3RpBqJ/fQ
 zmxqhVaSBZHV1RXDCvqjqdO/BfdcZJZImTJz+77TdZTFRy/MXKogWL/jG2v6IDB8+0r0
 e+tWYWCaevRnFdPhJYJfxcsgLTKX/y1E/+s0rxdbWI9LzQghqvceXLoUMKrDiqM7HCr3
 Drt22rHQh1TwaGC3Vxx6YZufsiSHOMMHWqOtDOlCEPNoWUOxwb6rcqEOqzy2SeXJYRDh
 zh//jiOZq/xM2e+TsRkCjw5yE6HwTxRDtkHtR3/rSsqxvD39MZfPTBaNmT7jNsm7ivyc og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgpc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:05:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM7Zpl033772;
        Thu, 29 Sep 2022 02:54:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22qw5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfLwkMHSHacPQsSIXmXfUoEQWg3Ht4RRjGLJoz7SdhoCBbzeyRzDcIjKEF1RRfS3qtrlwY23zz75ymFgFDtBP6bqPrGijFXy+jcprkoaMtBkqzmdiV+5WKXlc15KuajpFlTKYh7w3i+3QfuPiIAuNBvlKgXvb/vSVQ9wG7bdDiIFRiNgPX16AQMTGsSHTGA7eNSIo/7Eqp28QXObotcMcapv6fScsN0pAZtU9NFMW/b4qNCLxkO0k7MYEEznalYoAWgxMgUjb1keUExMYpEUQYUgTKvbSRFrh3Mx2w0QFJYISBxpwiTPoC64knzHAfOLlBTSh9If/eQhc6rRMjSwVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9ohR6VgXWqz2KMob+NzCYs0/N7uYohoU273/j3z6t8=;
 b=c3MSMM1yY9NF/7kcMpbPDBYOJs0IO/+syo8wgI8yUSV8d3ysgJ7IytGTijabK2c5AnyR/DeloUQwdB7z9CYliMgrgy6VPb+rSaoCDW9XdGJ2qODewKezv6i2mMEYVjrQn9mxdXgPkI404mdCaI0xW3AfQG6ZKFqKzzahXdgCZNcyUOxqiVIPNORJoFUQLX+kAT11i0jGxSUB0DuK366uNPootUfH/dAhI2fxAB6xh1ldM1jUmeMMaLn06FfMCc2njEvG3muCLl2CxFLBkjz1hRUc5x/44GSYxpiiPVrYNaeK/JJiIwcF/rgDeyRENg3qV/lxy4a2C2+cWyQ/qgVUMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9ohR6VgXWqz2KMob+NzCYs0/N7uYohoU273/j3z6t8=;
 b=TOqSL70UCxnabLQ5mMnfMX336rLjoOLBcB1ZRMxpzKDMQhNIQT0VD3EGly5QLYRNwcIguydioCozANMmCOGUgDWW3PDNi3qSjGEIqRxR03Vk6wmmwmAAOiS0SuwOUiN5uvyJ4mjG9Kr4BYlybUw53Dz59afAhc7gRf1f1uwoUTQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 26/35] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Wed, 28 Sep 2022 21:53:58 -0500
Message-Id: <20220929025407.119804-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:610:54::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f389efb-7281-48dc-0822-08daa1c5faa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GYnOLA7qRt7CY1IjekJmoOxfUA98MfOIAhnT22Sfomeg7IAVMPME926PCHFbKkeTZSZyS14w3eJ1Z8HK+0z3dt7/R8mpDLJiOpLetn8toQrEGU911h/jbMHeLa0rP5jehXGnq0vLWEYBNONtD/TTEwCa/NcxarAQ9KmHJBSx0DxbQc94ss+kvakw6aNgb9JW24POVIJD/xySfuLvhWbbmksFTF5eGZm/rJdb/2fBtE7mPqgEBdeoN5EFHvODOCaQA7QtE/YtvQlKNFjhST2uSMdD77n0M5f08Jf/XTRB1uGYGfzaZhAJffkDaLN58EwGjv87hWAHDsFD84YTIGnKkzr2izj6BnUWmaaSRY6gODGralJOVMCkjq2pH8mnqc4UhxcxRUfQKhdXdt+2W+ZAjb/Os5gYREOlz+PwcjrceFw2cpLuN2HOEWX4nTPCI68l90EHPu7DnXe3zEEVgHtCMAwxD1Rl/ThkN1Qr2c+AHTTBVJz/+HHxS3xUwmHww/5mBbzn4tNv0UPmPX3qeeUtVAG/Tk6vBRo+BmNWkWkr6a628y9eF9u1jdgGwXlyrpqdcv//wt8WAdQZnDSR8hWNtofxZ23Y/QTm63VXgBpSenIi9L0av+oAYDKEoiye20iHEPfpVzlUtZNs60bJSCRrIUw9gqcPTEk5ezmAeJcMFXUV8Fx2DhYIGJqh8woRdMLtZoCCDG44n3y2jGl+nchHJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLY1og3zgq8LZOSyX99t1JRs3I+ltgQXC/NFwSok1vTR6kw61wviMA2dpgdS?=
 =?us-ascii?Q?xVtyjSJ+3DlDkgPrsrRSm7g0eICUkg+6W6jy+gq8GpAVGbj1bGK04pBmqQ8g?=
 =?us-ascii?Q?yOIF+sCtYlasSKaZ0Ih40ZVLGVTxO5FKPqSV35S9QW3inpMFxFzkapXLTt1A?=
 =?us-ascii?Q?nS50xWv5eajwERiCfFOU8AUIa1VVSZx9yU001a8Y9nsOhgVndWng6wojfPrp?=
 =?us-ascii?Q?e7QOA3VnrJ4PDJxkzrDlPvZyWw5oB6lTkKj/rz6zCK4WELWuikEpVvyn2wUg?=
 =?us-ascii?Q?CSmoQSLTNVZafwxxFtVuV4KhtE0LhWGUfBOmqpl+j9RP2MftKhnulq/QMX4b?=
 =?us-ascii?Q?9Ent6TiZPCz7u0JaaEFzeHGAP4HNTZS0RA3YhlnNfHM+HSbPgKlveoyY6WoG?=
 =?us-ascii?Q?rmgBKYzaBqyrl6IBWfFKqzoNxxysk9ommXx41LMahQtx6XeBf84MuwjQ7273?=
 =?us-ascii?Q?NrUmppNLMJPV+yPJ6tdMquDPLcgaIZtwWeyJec4D/NMLFS8GqvL9YPReIyaZ?=
 =?us-ascii?Q?FyWbxp/KLUgBA8DmhYFRJ/p6F++w0DLXDFaWwpIHbq+cF/EX1koQnTtjDGc9?=
 =?us-ascii?Q?VUHNPUZvGvcjx1F09RzaseNVp/uBDlXtETyMhuq+m+0LUMddMlxSskIJI7/G?=
 =?us-ascii?Q?eMXWKbZ9BlSOmpWL/iTnmOTNp0e1AnVbCTQZwPeI7bwof5w/bNXERZr7zWGF?=
 =?us-ascii?Q?lkGUTvQK/m771zAzgcVK79cgIm0g2yUEssT6K8Wv2/BhcVUgQqfwIrEhFKH1?=
 =?us-ascii?Q?AE0TP9xMPVjMY1dxejs8hoTDeWig6oQTZwx29xPBBLsgoCbqu+xnqOYXWOq1?=
 =?us-ascii?Q?yKvVZgZu/RipvXypCuJ/vVpHK8mZEFwuT6xp7ElSY3djfsqAgzOpOJlQbQXJ?=
 =?us-ascii?Q?aIAz52JNC+y28OyEIjquYrFdhnd+u1QErD99ojXxfQM2sgSPXNseDCNabkFu?=
 =?us-ascii?Q?ddenGcI+2coJL1vn0fE+/NjO/mnihP+h51XuPBafBj1EKF+IZpP4GDUi/zWA?=
 =?us-ascii?Q?Ru5M1wNZWoZ+vZ+s4IPE/cJlkYoUWC1ROamHzcerIHXCtdT+7evxI4FTDcvP?=
 =?us-ascii?Q?L1TK4vQSA0qp+GNSO0K8l3PnhSPZbILiLQAM3pPsiUY50RXppcwPA72FxjY3?=
 =?us-ascii?Q?cQhS4zD3J68higOCY10QEiPJksAzY8Jas0X8hSVwTmNBI5G2TiU5gJD1jvS9?=
 =?us-ascii?Q?Ck3jKljxno06Cms319DxBne7WYHhFSj9yuFE8Psvi863cqk4p/W1cqgU6JSG?=
 =?us-ascii?Q?TX2Q2qPYG5frGMZ2ZYP2lMmImCganFpYNaEOIv6FRapOM1bD4v1b+dV0kG1N?=
 =?us-ascii?Q?jBEQ/4KvR6uNS2w/WxNsduV6M+HzJ9bWTxowqjvGRozgfwACrcWslmC2YAt4?=
 =?us-ascii?Q?gPy9yYQ9/t99fzByqG9I2SMbnSd25CDpo5jx72YLML7WEKz0f6gNRq18ZmgV?=
 =?us-ascii?Q?1AE1D0FVfQ81TFpTRxAT/DejypqFVqyJpvdg91V5o3ZH5LERPuY3zY0aICv+?=
 =?us-ascii?Q?kFvltxYNCEGB9Z+91dnVsZEw4ILGkWeG5yrDjYD+tzYsQPhLyQvsBRysv749?=
 =?us-ascii?Q?iOXxw5cQX4w3dB/qoCbd9q9iloq9sWUsoPXYuNcTg3jvFjmkcTd9OjkGWA8/?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f389efb-7281-48dc-0822-08daa1c5faa7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:51.3319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mg9wqS2qR61R/YAwH/e5m/cw0kcotHPExbj6o9fDCm8mq/Oif13nb9fFVFqAKhLS24gqsGUeEyjxEfpytyTQoWWABPGDKQ/3/4IUJibUD50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: Mo_YRMBSU3WUQRJhttvi_9Nk00UwyxDi
X-Proofpoint-GUID: Mo_YRMBSU3WUQRJhttvi_9Nk00UwyxDi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 56 +++++++++++++++++--------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 55d9b13b2f8e..ec5b0f562cf2 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,38 +109,42 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
 
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = dir,
-						.buf = buffer,
-						.buf_len = bufflen,
-						.sense = sense,
-						.sense_len = sizeof(sense),
-						.sshdr = sshdr,
-						.timeout = DV_TIMEOUT,
-						.retries = 1,
-						.op_flags = REQ_FAILFAST_DEV |
-							REQ_FAILFAST_TRANSPORT |
-							REQ_FAILFAST_DRIVER,
-						.req_flags = RQF_PM }));
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = dir,
+				.buf = buffer,
+				.buf_len = bufflen,
+				.sense = sense,
+				.sense_len = sizeof(sense),
+				.sshdr = sshdr,
+				.timeout = DV_TIMEOUT,
+				.retries = 1,
+				.op_flags = REQ_FAILFAST_DEV |
+						REQ_FAILFAST_TRANSPORT |
+						REQ_FAILFAST_DRIVER,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 }
 
 static struct {
-- 
2.25.1

