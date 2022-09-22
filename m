Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EF6C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiIVKHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIVKHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94515B6565
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3s6Y006449;
        Thu, 22 Sep 2022 10:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=RdrkLDWQ3DsDLbcHnzyDTnE8C6MPuiCWmbDoFaywF/Q=;
 b=JTU+UajovrB79HWRbRuBE9sgcK39iAA7XlwMhDYSpfHP2ydh7RbbkTQmXpk5KlvhIQMA
 z3yxyeg7pvu7Sv3DlZBjORjv5yJTU8iwsWXDBAgyTg45Qb8DHOl/NMWWSaDoknb2ZknB
 KWwAKMhl0bOEqTkuc7iFHuJao3eZCJyAaEnQWUvgeQqoM2P/JHsuU2pPv2fJPeZX1y/r
 GK0BLCiI9IugCVq+P67NJF8pXKFnpTr0YA235Qv4cYGf02QjGkQWye9aXk1820FhiUQZ
 5hafXinkd0UioFeknAHgD2+QVK6OpAGz9UI9RIupZGsthCfQui1EXmfCUzv278iNhGYt lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md277-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8liXG035391;
        Thu, 22 Sep 2022 10:07:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4dyqc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+5HprN3PkPqh20OdqNmmSRJxNsGa5zIKGxROl+On4NoSw0jifcbM+CzpaS/Qv1GAJRzJqkViMXfwNvf4l7sFPCqWIdtYbcfLt7H7VN4KldhUPkzorkXSgdagPvWVIIpkn7PLxSD3yyBbPyUr8VS8b1JbWLxcChZR1nSg8u4JZBH+z9R2gU0G0lgbAGVt5TpiHB31aEofpE/KcZcxZwuoXUVCU+rDqVXLjRyj9mVV+dIE5vaiuPJJq9qwfkL37DgGEjTt5J4l54U9FspnDBtR08Sh+HIwgCWkJRNPBtTQCYPfHGAHCun6E8FFPUxQcnLcV6N9ZAoLjlUes5fpElCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdrkLDWQ3DsDLbcHnzyDTnE8C6MPuiCWmbDoFaywF/Q=;
 b=VP8HyM0ZTyDYzg7cr3Qclv1XtXjQcNyq5Afo7zQznaqnnhxrHsqpNXtmVv930c1bH87AlQZH2qdmlRSRxWPro4/NHSVD0eDJRQRHWXnBWCbrWo4CPY1fA5uPWcA6ds1RjNfkZhwGZ+5fIGEWbvf68hhS622raVt/7suI5yCGkT1goCNYKwazqjYoZs/JmtW8EJZzRvneeS7/Yl6nSswOxd6EVQS02jIaP1+DSQ/zKaYP3Jd2TexHfFw+KzA+jFW9djMs/V1Tvyr/Zm0WW6K/X6bIw8sKNyiVBE/B88OEQQExK8Ia/TwPtqsRk8ORT/iZZBot3J2Y4qZcMd45AI+bHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdrkLDWQ3DsDLbcHnzyDTnE8C6MPuiCWmbDoFaywF/Q=;
 b=Xpp/5k7ShDtq38s+hCqnM8LbWu8NQh7BD7LlYKisoUgBSA5dp1OtEmCv7Ao+p449gOS6njisLwYO53mkwz3taF3AGbcRtXWuIN+O2uOxtCVcuu0WA5ShEMFM2FoH16n6MlC/N6mcF+qdDvBeoI8YtiMAPFivGRS68J663ZvkX6c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 04/22] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Thu, 22 Sep 2022 05:06:46 -0500
Message-Id: <20220922100704.753666-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:610:e7::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: aab0d53e-acba-4566-246a-08da9c82389d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6rmEZjh4JODspJQ1shxBtdAoOZI4kpevOagxjwKkiWbiWCHs127Ji+knTJg3c3D/vmEZ96VM6iR1+MtjYAvrIXoVV2kMmnaBEU4t8uxeqDcywe2gT8yFRQecYSNh1AtG5w/gwbp+vY6IGDXl2lfC4TJ9Th6LflfhYPGaO1XmPDkGkMJo8ChBjLRzfgBaVPQ3MAvowQQUvVikLb2pkkUhXFLb9L/krUyl9KY04eQRdruFs8dHlaQ/vR7CL+8Lxa/td99fKrYqHaUb2VHUW7OQTGio/zb/B9WZ0bSGgBmsbsSO8k9rGHIBWDGoDL7QTf817tdbwtXB85sASSrjtjaIgKpFeHBZEhrVpnYrcDVPeBLIsvv4hNcP3SRBeD7czqiHLciUBdZybH/Zb+tPB3tYkv/vIFhkLSSCtEwO/Zi9SsGvnquH4PVO6Nq7vx1ze+JO5wV1AUyx8aUv850h3zxEQesSSbYaZNZtx6K7fPnSrAnOLLHPzooeghZUsvIkxXqfXTmtJikscpkltpi70dImRKJyZC9yEFs6XEOSyOjLDWlxi7kI38XrOz3c2E894+0NhwlHg3PkuHK2O0qULEBsNWwL0x22Ioz85P83wLn11HcyohTZxYrsi8DfJqDgDRlwar18cPMbEz6K7OyEq/ss/8WbhGT4marlYzNTq0FhrBLMus/kPDgvYD3S7mU+wDmVHUSf+QH+PVWrvzeGPxFfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmEqe/1YfSE+Voi9i39XuWDrWUOREzCCNcjoOktmdBW/gA/5/pB+sdma2ZAN?=
 =?us-ascii?Q?kn2/IyEHjcuTZQg6tkZKT5mKw5u6VGnkjUIyyN8dpzo+RDr4dOiyzxUwf05n?=
 =?us-ascii?Q?aCNt8oqj2k7unQs35s3E2pCGTeLtjR8n2Ueg9yqX6EWimxArgBRd2g4eF8YG?=
 =?us-ascii?Q?GYWCPzoy1tP7y3OIntN9lGHos4Snwl+BgQMRR0BN6z8ciJCqKDt3uMVF/BKR?=
 =?us-ascii?Q?XrB07kAWRqyCYJ6Oa0VLIGembny1f8SEgocO1u1WbHLw+l7cEHO8uolboQTh?=
 =?us-ascii?Q?uTdIKcAb4qFgwTR4g8O5/rytnA0AqNbjoJqyCwCGMUj306MXP4wMXsNdyEV3?=
 =?us-ascii?Q?JWuB25qhPFT4adDdshzrKD1WTHto4yyIw/BWYz0Abku80o5JB3+VuO0Njzwj?=
 =?us-ascii?Q?XzBcY7QgDjthCwd/+ewsS3lAtZ/f8f0XBcN80IJm7Lc9yUy7FRcnLSgtA/Ty?=
 =?us-ascii?Q?b9G7kEVGc3cQ+uzsPJ9O6JcxecEDd5g/rU6JwKTztypPsGfgonz72qPKEO7x?=
 =?us-ascii?Q?qaiGS3q6Xj5/Ljbptqm958xw39eW5pQLgitzpTe7ZRBcH2WYVulK7X0pfdYu?=
 =?us-ascii?Q?TgUVF4qw6rYipESGMAuyMX0a2gMjc/lsV4zHfcepf1QrZqlxzKLz9G68yuf0?=
 =?us-ascii?Q?WOdD9frp8andKcDSCbnSTXg7deNrRpxi0oA230yb5jZMTVCea5fOLPdWCTuE?=
 =?us-ascii?Q?bcBVtEPSk7XXvdWUZD07nkW+6d4lc+NrwAt1K6U4HZ7ZJA3SNDIyNZgINdaG?=
 =?us-ascii?Q?4zFwt6bUjDMzC3QDSIp7uWbvIel0ROBKtmfxiYNczoLc0xHpI5w1FnUtVnlb?=
 =?us-ascii?Q?3ozSS+j1h89VLsdKjIa7R4RxevrnOAfD+ZeRt4YRPKymkPbkUAHQiYkzM8Wz?=
 =?us-ascii?Q?SQrv9SMgFxgh8yHuC4eplHXOoCPBQJI9P1UWcebYvc3KJs3LHNxTaUZpEqYq?=
 =?us-ascii?Q?QULRgam1j3xuoGFwDoDUwvcAmS/F2OGfxw2xvHGd/cEeZ6FbS6oCGZCkgW4R?=
 =?us-ascii?Q?wrRZXiTeONpctHCLYQIA9GONjd9v0Ct+g+jXEREFcVxQ4CoBE0CqnYIxkmqp?=
 =?us-ascii?Q?A/G5UQl7i9z3TT/s3laGEUzY/m4iI5MMIssK0VNwbE9iZx0uMrq59Csi7g6j?=
 =?us-ascii?Q?hBmPua7YFyw28EXWnvgTzs9R5v31MLLDh7rtvAqdG3u8xf57cYdaSDZ1NWKr?=
 =?us-ascii?Q?zkMyK5XpeUj/1qqbT1SJZg3PT/1g4GIF0eyHeQXyTZGcdqZwnqsU0i2S4aWM?=
 =?us-ascii?Q?qtjaZjHnMU9mj0CfhtPB+7dulwTLUm4G9WgeRjdL7I3fPS3//a94eIqg5VmO?=
 =?us-ascii?Q?OwrS12NGyKllo6qMZeHs5m193j31u779fulDvsR64UOiAh00eGynDbYAN5v3?=
 =?us-ascii?Q?k+XdjwcyLdu3kwn6kgQdxrTvxPevvARZYFJstiFOLj/Jqt5cvqa+IB/hCGqC?=
 =?us-ascii?Q?CfTsHEAeJwT8jPwld68kcPMMB1CJybq8IdpNeK/exZOHuJGx9O8nl1LRZOVo?=
 =?us-ascii?Q?aTGt6dG23aS7erXW1U+AJzNVhTAJsrYsOX5GdjyAylsuof+rKbTO0XJbmFHY?=
 =?us-ascii?Q?jWSRF/nUlWrVSRMX/yCSJSXroOFUgZzp69EfWpe9h0JxXTo39A2DyYb+9XDp?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab0d53e-acba-4566-246a-08da9c82389d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:13.6944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VlgqJON3SVk1Jt+LvJtivS2kCBMuR0s9yK/ZjIJ//moNSCeEuUw2PZ4zeJxRkx+7dqKOUbOupLfxtCFaK+QhJQeuaFJZpNsGHt+w+BluBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: 1wNInW4GwcxhBMfthUNo7lRXfEeg7Xfw
X-Proofpoint-GUID: 1wNInW4GwcxhBMfthUNo7lRXfEeg7Xfw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 41 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ddaa9e7b3e34..08eaa7ddfb97 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -649,6 +649,28 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int response_len = 0;
 	int pass, count, result;
 	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	*bflags = 0;
 
@@ -677,28 +699,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid, NULL);
+					  &resid, failures);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

