Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D05C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjKNBjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjKNBjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3652ED6F
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsK3X001232;
        Tue, 14 Nov 2023 01:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=YLAVZFR6W92PraPFqNDj0LFsq+78M51bfW4+SyxRJbmFGIcTUb1eylFT8PhSx0MjdhOt
 lYpHYUZiByDARNSsWoyeIpD1eoQmkTE0jK4D1ls99gyoqvPxbH/C9ggXxojeX8QSf2gr
 BvVIAi0rGjCOVuEpLAXR6+T1NZsS8a4kVCpMRFIe+4s1v0TCqpjJF9HeJTvhrG7fAZz6
 LJMXvTHjNfRUzEkhvnMDOhNsc11qiP6lXO4Lg9ktRUuvAYCX+AWvTHzM59pqb1kghXLW
 3gOAFxZCtkONI0sL1fMhH8TgwBUfIb8S/WXKfZPckLOW0MuPSQOSYIhdIl7cLkoE9P/+ qA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd44eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0btSf020722;
        Tue, 14 Nov 2023 01:38:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh0h6hb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKImpSynu1niJNvpLE3GxFaXdyAUPKi7dOPyliFG8SybuC73oNRkN/yiHRWbsOxVQWpUknp+2Tgjc7XEKOnuGspM21dNRO+KifR5zCT+qR/MSF9KxxldPvljugn/6gQWR6SO0j4+jhCNYeEwcAzffAG0WBJ3dJq9zzkqiH0wcTrVgpCqdFSnYaOIBiacrH6Hf1FbNGYhB6ya8Y5Q3rQ/3jiLPseDVlPXfMnoj1dTUnz9pig5QdTmxB7kn8k+bWynSFP6yRlpVjBjikEPXkE+7HygiADqTqRCUTElb0/DIk/J6uEb/2uQ8vpA/vklWiptsSC9QRNLDL9MjouQS6pNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=VBZQotLLSSWF5OjNAJHz2l1veSTOpwcRg9ZRBUewdPPBsN9EC/hRXiMUdWegza9xcD8vOVMwfnmYr6XjlL0qFAlb1etfmGiIGwjbPI/n3q2M7v3yjic4RjT5ig7xv81COTctn6ozyRu92m1sKg+WMQq8L29/xnoK0YhxhcEsbf+SSgWtqnhWaASaTcYfGn1OMbSKTxp8ijvEXu0ZUGV3iKatZurGc7kPdviH8XGRTvEqQ9mWjwCQYraNJE8RWNK6ndYYfieJ7h+NHGKFcPHx17qMNBG4UK2eb7ug/syD0UzIC2xBGSWo1emBfu1y+m2t4xzLsvFd4NHAhmYDjVJ/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=qNuBLgbH0TzZYJOrTZ4QfOA3A1k122/SIo7Eh5KKiSEDzoDE4PMsudsctaImCUkhGupOksWkyY+pcAdT5YsJ0xWuAbtFwy4k9xRdM2XEQSAPI63ajsZ84XOycveDU5QFa8+9+XnMlXViCnLBnF9PA6qvehloldqfVJ2+1oHFxQk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 09/20] scsi: spi: Have scsi-ml retry spi_execute UAs
Date:   Mon, 13 Nov 2023 19:37:39 -0600
Message-Id: <20231114013750.76609-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: e9214d5e-568d-48c3-b7ac-08dbe4b25845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWIyQSebHZxUlwUQfpr/ItNsEPKY4iRhsDMAxNYzkNSeHCDS5dDgpulryOj8y9shbgELwuO/5i9v8mBnaK10Y6PV3nM9ARxhDapZ7uCMqIYuooYzzqCsvMdDFMmjqfcgkKcqUP+ux0d0ClGFRQpii0M3Ja6itEZCCKIWSXsL0Mztln52/AEhFFuhfekldFu2C9u+oJbku3T4pq5fTubBLjbrj1ertKu8aMJTZ6JJUkRDbhgNApe3K05vUJQqAPAeuT17/1u/d55ynHemafvuVxuMyqgreQnO34R5nMoq1fleFGr8KUsa3NuJPU6zTjTEiATx1KfW7L9ksoaoSKiNlJLNFbnNsdg5EFyWMnVgiMkhv0nvkNIBB6YM7Y7/1IZeb8uPYHZP7DB0s0h9gPIY7WLrqWyEcGjj+LX3JUJK1PtPJ4A34uGiX74edhDVDzak9uHnbr0eQTWTI+Vrim2zPmj0TCC/9sTuVZ3C9Sfp8vBrcswe5+fKzKpWIycEC9o+9JOD5RXCtlBtuPNq+q3MoPPduSln0J8IRCx5oCLezDgL3CKulzJv7hihEiBdCVsD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y5RBsva2Oyn0AjG5PkKSPXNHc/lgUlTBb15/GqW3kro42kqoVCWXuZDAo1KQ?=
 =?us-ascii?Q?emn054Spmb9jul7xD8AJ9SD6Mbnbl/Mzax97zV/Im9row9NdNH96GzZTeumJ?=
 =?us-ascii?Q?6ieYSqAMoypFLzU5SayUiYAXeYbsqmvSTrCR6C6a7GQnBBe6qJ4/nk44KE8H?=
 =?us-ascii?Q?RYLOmFjFJjV0eRnFmvnQoPfX6hYXuLgj7VdXO0DlKqm4kuMTJ8vtnHM3rUAO?=
 =?us-ascii?Q?0DMaZs4Az0H2Hi1+T6JTtFTmkSBx9sW3Yt0m5pEqfIFZaTKxeWMP44ZO36Bw?=
 =?us-ascii?Q?ACvAo7D94eVUXQcDJgpzI4y1Vrq2SpqPl8BHPOg/v+mV0ANaDoSvL2M5CJ+s?=
 =?us-ascii?Q?gJwneZRuHLaZtWApxhSq0Xrmsr8P1fTi2q7H9MckHM9nSwrkG2DyGQKy8bKr?=
 =?us-ascii?Q?euHZrd5XGS7IZrrUqo8HTDCfBCcAYDtnde/EkKnOFaW3NuCy8q1CGlDmxuGS?=
 =?us-ascii?Q?VpacUuv/13SY2zxBgujFBuuDiRQXvD70/qzLEBELb3Rz3/dWT0P0nkHfsIae?=
 =?us-ascii?Q?bbPyZpchvF/1O4d+xhAXkD8kfKRtqkPIfNZ2D/4HH9nBraMzi3m4Ly56MP3P?=
 =?us-ascii?Q?OVa576PTFl7aKRuKbC9ihcLaGY0j4OA+pcR6RNd9VIezwmh8/nYp9McK4tAy?=
 =?us-ascii?Q?sNFIFiT8P4tB7p1lucxXz93ItPgW/9umBkKTs3QMzatppl0R3Sr545wwBhPJ?=
 =?us-ascii?Q?KqYbLoaOOHm7CMpCFqljmT21QgqCg5Y6HURui2rc70tj5m2hXznTh+z70Rph?=
 =?us-ascii?Q?/mNjiqNfmFxSWLViBCCBpOzRZgnFUBzGIUosn0zuLaTKVp7LfZgRPdJFo39A?=
 =?us-ascii?Q?n7UGpTKCMNYfdKey7Oqe9b+YI8olbuYC+gJeKa09LajJPcc71bM4Plh+ZvKk?=
 =?us-ascii?Q?FdByf7eJNlhnkA4HXRK+A51gBkc3DHUPKiGUBTvrkyrTEAKgS5VuZLJwoPgy?=
 =?us-ascii?Q?ymxa3O+K9XHql2PM2HSEAjoSLD4FGbGhD6VyJqaQKACezhsJBOuStYlue8kz?=
 =?us-ascii?Q?l/WCiW3DcHkVQL9T+4dEeB84yJLcZ8vgBc+LKW3PsDtaeVmDPJTe99aybhQe?=
 =?us-ascii?Q?LEOxbI459pBRx24FeDrLPhOaGbfksfgPiX0KyZ0Qf0Q8EnESDElS1Cej6wxH?=
 =?us-ascii?Q?tT64p1HlE0RVADxcF73aQbjDqo9u6kDeobPGqBUMV6KkEn0IV98ckLw8Mx48?=
 =?us-ascii?Q?tWusZD+pSdey02eDLfC3yI9uUUw8uSkowAbkZqmdN1um/x3uerpwA0u3BjYM?=
 =?us-ascii?Q?xk7RtjbzNK6/rY9WNW2cqn4mloH4CjatppWlvCuxIkDaQ2aP3wnniqqlcWbR?=
 =?us-ascii?Q?P679iA8WMsJdo4N7zWQdhD4uZ0ZxcL8WH1FcYRPcKBHdPqxFOVM8E3nUvUO4?=
 =?us-ascii?Q?kyZMEaj9Kt6FNp4WezJdIghG0ym+xAdGkDNgRKTBm0wGzBBxPT5LTIpVxtDR?=
 =?us-ascii?Q?wX7M8P0Rm5qxngvpujxXah94obQXhEE0v7BFpFRoDmIkFO1ESoiReIoZ5Q36?=
 =?us-ascii?Q?TevxMc3cMigppDOo/uPzyBaattePOnmZ85ZLu2pKh6u9h2SiRUuJKIC0RGGi?=
 =?us-ascii?Q?n7YCRYgJNhN2BIojj5FoXveFRDfpkjjdOaIF15fxpJcp0+v/0TqTqfXdzutF?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: T+YHE9Uk1GQkJMxIDWPQmhgGiOcjbZUEpiCjAMXhXStyXI1dpNKG1VmxsB4v0dZHVoc+rF7nrWbWgYmWvSzmV0sYQgrtRqbMKs5+p4+LgBNDAGhybyc+WMYyAVMduJ7MkeemCa8erSlKWtXdYhDhOxchvkFAEq/yG+r/UR1qdThn6lUvGV2005KdBq/eq9kGf7QaU7IO+763+BpFBqpLt6pdzuufoUCTBhsOeLVoSpuYJLj68iHY9HrolIdSDGb+0+w8gDkr2+WOcuq9NXvCPImVF4fzUB0hIyP4f3UZcdwsaJXSNoYdTrfW2arsrJbIxdQnn5vv70AQbrAcjAjE6toU96n+rCwc3Co7qkowPLsErT9LFcqLnTOzoz5IPZKosOzCxJFpaxeEiTaqltQ2qviqJWzPPFHI1m8b4KDOer4Jii3ypzhzL72VIK+RRkm7ePxSFrGWmnM/irQAesqoWcKc7mxqV8V4sbYvQIZ3XUCxRM9wTnvBDcCAvyrwMj7J+IB0hqMJ7p1VTD0euXh+rFFZoqLLtNz1ymLRe514wr4MsT2FpKbLbH6A9lOulUUqelZ6viSjWSPPWHnuflCUo4zArWHV1OW46dZL0HvD90b4yFuDot8WISYIs9XZno64nC1u3KqvBrDYZieQ/p3A5OI7VPH0qQk/0kMQP68lHF+zj+4wTBf+evYyxNq+mWF0xOL1DmDsegQQ7cXnR/ACLDGW7WEnCXvHVK6ExfhSFNd2PVoAbFWTOPEPcay+OH2FiwcuGs3HTx/Fe35vMC2tivG+AX1eOalyeYuX10PA/etfbKD75t7tNFotIZB5ss32EKmRtAZsN/biLJIT0r8UMKeV/bPc4FKOKGtFulbDlLbFneDNnoDAzjJoK38iel4g
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9214d5e-568d-48c3-b7ac-08dbe4b25845
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:04.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8iVdQTOh0Q/x4VGLrlhB1XYfkc/lH5ozj6YW99JFsJJlt2Lj4nT7rnMjoCFYhdqLGDNiwdYVd+ncT3zf58+4xkyQsjot7cs1EHRwhJVQj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-ORIG-GUID: O9y4m8Mf8GMY-zXCqRKpdfH_fRqrO_3s
X-Proofpoint-GUID: O9y4m8Mf8GMY-zXCqRKpdfH_fRqrO_3s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry UAs instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f668c1c0a98f..64852e6df3e3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
+		/* bypass the SDEV_QUIESCE state with BLK_MQ_REQ_PM */
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = &failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.34.1

