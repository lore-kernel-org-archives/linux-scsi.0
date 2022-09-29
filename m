Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7DAC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiI2Czj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiI2CzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6C14056C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNif6b020801;
        Thu, 29 Sep 2022 02:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=iwZftbIb5PPL/9VsHO/DaF7STjQpo38uaXQohxnJPlE7br5GUEwq7Zb0RnQQ72xw1Jrl
 tGGy7+jsAnUx2YGSWUD4RBvcufjIQy9g7YVoRBRloUigUlF88MutWg5vwqUT4udTwy0i
 3lWxzIC3QzUoDVjzrTw3CrzYs+MLGYMqj817wcSPb44tcX/U7UjIHK2clBuXwP64wtOZ
 SZ17JrVZEHBYLXryolXWN5z1GvgZs2gRa/UHg1YIth3om8/mRBe2iYmqu414R1Ok6QIV
 edOqM2cEmiLRkj6A5rBwseCBhM54658+Hk6baF78Cg1MBdQdFcHyyRqINJpijcUeCuel AA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SN2DnS039536;
        Thu, 29 Sep 2022 02:54:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT8cekclzvTIWLgfLEUYAPNcrlhrKffOSbzEjfRPtDbRnl/S+vLzDVnaFpa33ktV0XkJSOm/hUjQK2Qzdb1aV7pNZetiuQ7nSCDoby+eFM0hZo/hWit5GVt0djJmIRmLBpBtR5EELIpFZvrSzrafauoFpNPvBkc7uxjRN2swpuPfwnAG8Kfa+5GNJkJTNdQZ42lMRq+BSAqowgLYuw9R0zRaD8mYoid22sZ8O9PCKzCLsVSUHvIECqEfrdCg/kPnbxqwm5NG7GRpcTgUY4evdsa6oHmASflqIlTPjj7SPNLoC81K5EhVQDZUrUeHlDb4ie4gNkA/LYG6oPH6CoZJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=draCO/65LtXHNU1uxcukKS+6PsvqpiHMNvgbaZjdB0EHKLcdvxTeSIw/3fXOIsaMHBowWfNWZ15JYUmGyXBsq0y1LFSp2+774n8T0VVVWUyDP9D4tA3bP038uJ6vwen8j1oY6m68ZRiSHjMWyBIfAT7X1P8NvNCMx4taXSuizErI8QNLBo4GmHeowQ2WhYcyBNeVmhazgoQdIY6QLCymBduGmAjSkS+11+T3tirMddHLJ1j8qRF0UCP0SiJr3mAcd+SV6Fo5BYfodAPBy1IpqH9AnE3l8etrdkIrO+87UmrLuIpK6dUrxWbgWqxlkPnuRxt1ON0cHLdki7zD0Z0wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLNiwb+Rz0d36Znq1wimxZORUdX0+ai6fN8vPhgbdwU=;
 b=njCuw6O5nQ7dNfh81+FgG79vgCWv3iB5aJd+9YZRLgZsK4CawsxBL3IpWISFhRDD68eil2cdnMLPjuqv+av+a3afYBVkmLWbO/8xQec01DjqbOditH9Igk3zDwgna6ckYCCSLMCxFgfov/034yotUX3QM9Hc8MroY59G2r7Mdb8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 20/35] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Wed, 28 Sep 2022 21:53:52 -0500
Message-Id: <20220929025407.119804-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0016.namprd19.prod.outlook.com
 (2603:10b6:610:4d::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 1334a6e7-3249-46a8-d718-08daa1c5f5a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QO6us+w4JyT6r6YUefLPDSpA3dVqJX04vtHzE5knNryzvTWiqZz9stBiP+y9KH+FcHPaNnpjGGeDgOzMhw1U2N85T7XLeBKh7a0VSCAu+Jm1FhxLdOlgGnjR4lhKiXc3naT7H7yA3E0aB1zcZkrH7sIZghrBGoUs+VLbW+fw4NptwKCVW3QwHZHC93wsVzf8obsnejdHz+dfrV4O4NZ052jGGrRxi83gP40D8Y5GW6cGzUYX8AIMnH4wwVrxx4yNOnQaG+qvaia/Vlfjt/WMHKUGLb4M4ViDzCNsjOmmCQSa8u0L5XvWT17JHUBS49s1sIKL90CqBnOYFfSaoKoC7TeMj0dLl4xhlZM540neLYukpKagmp2ir8P+8cKdwLXE7sJTN994KvI6VG06s5pokFKkyBGTuciMiPxew9xH84/tgrUm04fgjeZZJ3mRN4ig0TxUhngl0I12XhN0SoClxurXp1Jw4WfaJmiZd+D8RWdD7GRSxSVdcWyjwPDgIrmUbdMV+0pRxKaIfCf3wdYwZEiVhC7LqlMvNNfFVZtnZSnAZdcUizJfEU6QyHYIvDmXUWQWI5wSyh7R3/VCgGbd55UVfZHdXrl9XI3rolPgUC0Cu21P5YI7lCc1Yi1OVJy6wUERkSiE5VytoQLe2YlldLXED5Raj+1UpeTeW+I33O7V/sQzYsud8dj0n88leEe81P6O0qgzjpApdSeKtYzQJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rgjWlPcbhqDikgYryX9LBjrcAeVAXcKIZ4rxTbe+tf4YOjTAFzorBxQnkmcs?=
 =?us-ascii?Q?/G83QBnTD+LrWtVdkv04Q02RnvTipFSez/L21oF0h3pLKRiMLglFPhu8bY5d?=
 =?us-ascii?Q?oLHdHAylqK9rq355zjKNr0LUmfz9GLZ+a3WYJSdU4c2r1QIzMfoDQZlawg4e?=
 =?us-ascii?Q?TEFXQERv1M3yyIhHE2js27i+8b2HvzBo+d1aNc9ZKX9u8FbEHDsluKcnt9Cd?=
 =?us-ascii?Q?rvO8LQjPSpet8vK3cXKvmNxyRnTF3BEQWEIp4m+QXLKPZCDj2NIL5nPyBMkO?=
 =?us-ascii?Q?D3Kw7jDnjZn+5S7a1k3Aa1XSQdvDQWxnCuh5U1bI00vIxUCksRT+PrwGGpKi?=
 =?us-ascii?Q?vsPa4cZIOuCPZ8SCUHwVJsWS6jYk1swFCdul3dpexk6TTH2qwm47W5emjPfB?=
 =?us-ascii?Q?QuQ/j4x2rw5rqbTOtyC78LWP7csl35EtUEzSgboz0IXFfGPl09R1XRQg7bTB?=
 =?us-ascii?Q?ePaYDYnEhGXUN3WoDdVaSZ+f1bckrFdDe84QcEpslBYe/OOHy8LCn3iL86v2?=
 =?us-ascii?Q?/i9WbJu0WQ+kLaV84qUouQaVQ8s2tVtbmFamhEkdYoAIXO/oThCSOcf2PNWy?=
 =?us-ascii?Q?j1sx33gfuhHDNsC2HE2tDRuuB/Q00P8J0I9OwacmioJs344krlYCxTJts1u3?=
 =?us-ascii?Q?OmGaJtsPJxmxBkd2QxXEv2LQYLUgzp0oFgEWFshNJosM28+lk0Sg7zfEDYZQ?=
 =?us-ascii?Q?TtDdLWeD5J/xSAmiV+Z+675dxtyGBjjTPVz34VDTeeY1kpdPrlP10oa25GEc?=
 =?us-ascii?Q?jDzvKxUgd/Vw43ar8X8M7amUDBGb+4pY6q9dLEomw2vtCmUygJlJmdBI9Pld?=
 =?us-ascii?Q?Mo5c7XGldQUvH1noVGk3yj8lnr1QW1nv0QUxc1DQ65w29XasZiDcPh0YVW2s?=
 =?us-ascii?Q?gJ/HPqkZSmAAkMB7/g8WBYg8uZC8E5L/22eT/S6zBhYBvsz757sjrpGSyCFz?=
 =?us-ascii?Q?VyCec6ND0XcArwAZwZIkAbfQL4oN5asO7BBqmfy1p/Nk+/v7fOXzWyt9MH0C?=
 =?us-ascii?Q?cQukJM+kBd1F5INWl86rvZcPPSpGbNTBDXyclilICDq1dTLXw5rK0XB6nCW1?=
 =?us-ascii?Q?6I4KhhbDzEBMEJrSfzIbOkPUvBhnhNVGmu7/idkAPX+ixDDzyzQNrODBJWmb?=
 =?us-ascii?Q?ceWEY5ANMC04/Y9Ce0co/AZAwv3BveHV7xHneqI6Y8vC5dd8OBL7mBqXKljL?=
 =?us-ascii?Q?sqA3k4hc1Qs+UNLGhpVuGq21HmxuGOjFnZqNhwovqbh4NEpN9MBMoloYhUMQ?=
 =?us-ascii?Q?nElf9ECUvQeTfHOHpl7wjqCZpJBiqRj47GgNFGhsno3HqQBtAruOGAAlxBg9?=
 =?us-ascii?Q?kM++dzgud9FyHxg19QEd+Foz41D+uCLyqV0jrtJfgjtOQ1QK+t1uy+wtfsbM?=
 =?us-ascii?Q?0eEYuc9KT206SWW1/5KDcNqoU/G5B510CdS4bFkVx4xvGWRsC4ID1XBRfLSh?=
 =?us-ascii?Q?Tu+w2sjvxC0QrroIz5ewyQhT09LFMzYHSBTDncmbucDliOhdm7Hj4xTPL5hj?=
 =?us-ascii?Q?4DKhJoUDI5MyPvUZgV+FilR2RJpahaAyjBHKvpeyE/Vlecql1TzOUW4rQXaA?=
 =?us-ascii?Q?1bj6Kp/VincaG+2Rg8t3vY5Sg8NvOjjUwj1IhJjSzDoPfRhVErGmr4kgD2KP?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1334a6e7-3249-46a8-d718-08daa1c5f5a6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:42.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffwVgjSLs0tLDDZ3mXlXbx+P6ktofcw6RQrYVUARRzhyiNxg5kGgOubE1U+y+l6NLnt5WNs0tRiA+hRT/BEQZCJ9zMJilM4QvA0hx5W4Cps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: QzyPjQK8GS7XA5H20UX1VXioEiIkYe_v
X-Proofpoint-GUID: QzyPjQK8GS7XA5H20UX1VXioEiIkYe_v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 44 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58edd5d641f8..83f33b215e4c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -654,7 +654,28 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result;
-	struct scsi_sense_hdr sshdr;
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
 
@@ -686,32 +707,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 						.data_dir = DMA_FROM_DEVICE,
 						.buf = inq_result,
 						.buf_len = try_inquiry_len,
-						.sshdr = &sshdr,
 						.timeout = HZ / 2 +
 							HZ * scsi_inq_timeout,
 						.retries = 3,
-						.resid = &resid }));
+						.resid = &resid,
+						.failures = failures }));
 
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

