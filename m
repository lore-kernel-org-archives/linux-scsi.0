Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66202EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbjFNHWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243328AbjFNHVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB83B2977
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:46 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k4Cb025459;
        Wed, 14 Jun 2023 07:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=yUvGxWjar6knFmBgty4E7PijHuv9qjsAlwq5V5gjAHA=;
 b=TSKIjIubwUStnKhD26OJtlvR1LHE+r5OM55UBSm44jyj52YWq4ePWZElibmsFQraLHmb
 AtAMLSEyvnRfJ+yXfxRFTZ1ccdDgMtDNXmAsayc0sOioPXFkgDuI9wrt14v8VC7Ggldg
 Gz47v7kBzTVuYDEsaTr+Q29GEAK/5rZEc4+EiLosbWy7RIp+MecyaxfxtU5E1Ifh9Vp/
 B/j3DMiPDGrD7XeHw56yK68u3VDQMx2KE1hKuao62HIDx1ki9ddunLQLpkMy1YcKBiiK
 mKiUY4p8v0mkP3hZDDEafFBdAV+NurIXWfygBuLLRF+ZMDy9QfS+jotTv4I9Hgt3hOd6 Bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d6vqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6D2Kl014002;
        Wed, 14 Jun 2023 07:18:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4x1kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzoKYs+iEULsptaNHEd5yG63Sgtq38SrXME79HTQ4MZudvBRGDjbp+WQfXVnKJh34jkRq1hV5brEgAKZkJ4MQdkBllHtvGq8cA2Z2joJ5XqXQvvigksFBXNnxhydSYjU26TkInZkXrEcShWiq23yIKzW0Arx50hQLAsI7DPdrXxWD+n5wtSeiMELoYJ1dmlsqKyoESi7lEkNeZz13MVTAIRqjgCgIICKRlfKX2q9Rl+Cp1C/Cncl6EfADmXd75AzaIfZf3we78gjuliBFE4uepv1mqtPLSAEfQ0OY12FE1nRodW4pSIWWzTPTZK9XQzXwxULL1dzrkvm0RsEV8BNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUvGxWjar6knFmBgty4E7PijHuv9qjsAlwq5V5gjAHA=;
 b=NFtxWxVpJ6Q9PWBb9GfdNqpZ7InZ17CG2zZZf3s41+WGWLUMRHRazebq51Vc9oyBJwhhqwGitawpllYGkbdG93C78Bbo1QTvEI5+CZBADONkx/jtT96LMrEr6S/V781k1nspOBQFSwBrHalH+SEgscLMC8S+DfZ+wujJd2AJjgCckQ/WVnupeX7Aaicr1xhnmOw7LCW46LR0Uwti8MxTb68/DRpNgcFiyeR+2OH5VnGe4IcFegQuskjDJXPyAAi9hfV+67EmtPXi6N7ee3U0orv+wJwT25Y2DF9RXxKeVjapIeEX3Z5mCJ4y72XrG2/VrvVIAQ3bouUSRU78+qDpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUvGxWjar6knFmBgty4E7PijHuv9qjsAlwq5V5gjAHA=;
 b=XyDNaESo0VIGHMmlbqUOWK+zDU376w/WcRO7B0WE6G5UdtMg26tlD+ICzYzifG4rE4sBdWdhIzpUu4ZNz2zRuZDkDTs7KZlNJj3m6UL0tdg59ltmZLOWyiaAwk1M1zfw969KqGn8BilCQzF+0mQHpgcIxzfidwjFrr3DdcTue7Q=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 24/33] scsi: sd: Have pr commands retry UAs
Date:   Wed, 14 Jun 2023 02:17:10 -0500
Message-Id: <20230614071719.6372-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5e963d-804c-4902-71c9-08db6ca77e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8eUvLAG7jkn15zJXy75tR8TDLtITyf5+vNrUe2W0+1Ww7/Sum+co99wdyL4BhQxygH8gQB/9eU5Dmu8e0sapkTPBWEbs38/aeCGnNbBVZomG0/c/pw2QK2nfS8eTUDSvb3qBDNetA5Xz+FxSa5+pHEb6mL8AxqFLTk9T+8L5Z1i5+OzuTksRvbq/+6uPec28rWeJXoAWd1JQ2ylOmSRdYgsSIJ4p/ZOZxypybYzFu30h16SmlWId25dZOVciXPUnh5GpPrBBT86rMwKTYAp21FxCn7kwRHrB2PDlqo4az28tdB57ewvF+cs+praQCxAkJCeBCYwNxc/8GO7tKVXmdvmACQEUEQeop9RslmYmARWJvqATMrZCnOs2xbk0/Y+Yt1JYBgCV3y5WueGi4LJz3ZHcCmuW/yPjSfOXLkZpRdreMosqvdFvVWN/eCLWq/U4NBmpTCZTNUr03CtldBW8fPhYtv+DRSDMHjHoZM8SWJv/+iZMOUhWVopNTI2OHAOIeijHE1YxIecK5CX5fAm6tlNiRWwbYwiJMCGkqrl0zw1+1mYHtu2QTbEd15bff4Ho
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpLsdsXoJApKDnFwjMpJ2Ja4qteXsWVZ/Evk5GWXDBUc/PceuAMBE/pZxFVk?=
 =?us-ascii?Q?2AnsRuJ4/YyhwKN/13Gov6LmZCw07LHcPaY6oQemcAmnDfYgfBvteR57yEVA?=
 =?us-ascii?Q?mCr1IPkA4AueQADNFT1hIdxwbr0uUsdoWOhUX1zeGq7nLXq93Kf0rb8d6lyB?=
 =?us-ascii?Q?aIYVSjL2NNi0r+UAhv1G48CZwAMrUPbYmb+UNPF+J7FI7z9JRoHMgdA3K+bO?=
 =?us-ascii?Q?qCV9+IoRi3T/Q9604sOv8rRu9FBelXW/m1papqVZQVCAOv7IKQrPL3AYTFos?=
 =?us-ascii?Q?xnrH9zuuUCgZ9cX5LEuzJVrrhpeWxwQkLV8/wQVxnBPjb4xIJr+UuB8upOJj?=
 =?us-ascii?Q?/OSg6W+k6iwLCEVhr2JamKoBPs/+HlNU4DULooSAFde6Zm2NfG51IKkqLHh+?=
 =?us-ascii?Q?MTvHyw8j6ysr05uah2cX8k3dNmJnivKeMZ2zB5adHDlVWM/CLPY8zZ0I5RUB?=
 =?us-ascii?Q?TUdytlKRA7bnKK5TSVvtQHdgg/HbdtROOndLxqC0sMIQ0V5am1XVlEKvV9I0?=
 =?us-ascii?Q?u7D1a0ny1+axDIFqIeMqT7TnUL7Bwb7Ug23GpxltQQfpRmo2RPmBw9f1YSAd?=
 =?us-ascii?Q?aJ32gpLt4bTbmIfRXlgKvbunitF3Jr3K6ztBKMIxqYBOL3PfhPSWx0ngpEEh?=
 =?us-ascii?Q?GKD/Hk6WO/kQOc0SSFw7xY9ggckJHaqAB4lT8eupXWKBD/J7gaa0eSzeOhWi?=
 =?us-ascii?Q?u83KRoDdmE3mKmISkHxst/YvwKnOVo8s3J3mLvm2WttkJ+J2urrSLShameO0?=
 =?us-ascii?Q?nbkNw9rX0dxQZoCsnckbiTs7h4WNj+/In40rm9ujmAP+RtHHRWvPbn2F1g2E?=
 =?us-ascii?Q?T6WKXgW8xvp0MuTE1yMSU4kcx/fkZFneDDu2C/0ueQCBvacO6y8tbh2w2cff?=
 =?us-ascii?Q?arGjeqLxSRp77l0q4JDGmfrcTjmNxY8T4ZDGryjLrbfvUhqe0pymk2WbFDb9?=
 =?us-ascii?Q?QHMhw9beM0hwFaVKtHlZEIoYAibkomtrreXHbqcW8uoqcHScXX25Z7THuSTJ?=
 =?us-ascii?Q?qH2Dvzc/j/XbecuDCub+oGYIoSK69aZmsvVwb2IKW44FKdOUHDSfXJ5gRlGO?=
 =?us-ascii?Q?uoD7WIgLFqjFNUxZRt3BTnGr49I36R7HFj93ILvTzWMWI+mEq7zLRmCDonu2?=
 =?us-ascii?Q?gGRzNXRiG6jNTsrPjvTDcn1V58O5ObecjC+poNoI7IPbXL2EnYemIlYnuaFO?=
 =?us-ascii?Q?QZtysIeIbNcuwkiX1PnrlFL80GyVH+14De8n3zNtGbihSE+fZUWmTrIKY39w?=
 =?us-ascii?Q?tzLafUV/c8w2bVDclNTODodSRCixY81o2gsjEsjg3NX6gmgaWaMje7I1BrIc?=
 =?us-ascii?Q?TmQu4qmgP2LbRUAHORV0suCghSMypv2d03jJX/5eSt1eou3IBrsXBaZk0mME?=
 =?us-ascii?Q?Dp2CVGojJjq1VFSVibxHVDAVqiq5MYm+4sFa1vW0AVCYplNWlHmDvWPF9J2z?=
 =?us-ascii?Q?+RifWg1nWW7rVQb4ji+0/Gyu2UPoaX6LUz5CiYXUuzYe+SSVCWIvKalQJUsC?=
 =?us-ascii?Q?6UFf02NgLLoyV0aUhZyAaI1b9Ii4psYGbBAHsCoDGIUWQXvWuLMLyNZvwWw4?=
 =?us-ascii?Q?kWVXX04A4Y9ey8MoDAhqIysAXby7Mj16FCFLWB9dh7Gq5RIxsrBaHQG+RsL1?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yaXzkV75xN1kM6n1SOoLuXRvzCNCnOOsC3t6rzXbGMQra6gVF5/DKdL9ugPVxnT80moLcBSoecIfn/0TVcaTjHAQXs0zTlRmv3tDVy8o5SWVGcK1smsUKvxg7PdJW1/07NMJ9E9i3Us1A6xIqeWC/GJlm+5BnRgXdBZKpCyYr0ePOdLMKJqxl31NJc5REq0/z05Sr/iQ/J3UOJM2t1f66hojjgdEWpAPbGhIaW25MpHShK/oEp1uFeizkKSiDPlnIoWpqgL5ty66DtVeYdYWFZrKSfrVpsWd5qv9C+kl62en4VxMnAulX3c7/HabfGiCKkh10Q8iJRMszGsi4iMbUgU6pZgbzLf0BBP3hAe3J6101gPC1VKkhoeJrK81uA1NeFYauRKg9yjSTF1Gq3AOs+GESMXg0Db8BMcY/wPWwlzvPYOtj39z57UEPQDgfiQxUqjnPVVfKVX3RTQk7rxDVp9hAs9qTV+oEHuMl1I2ONUcjPvIPXC+Yz/GLws7/W0utQ3uXg7k/qaRZxN3/evT7oSlie2mj6pVAAxEyM5MsN9faKT32FH/Ls9XEqVh0FPV6NFORu/EH9hFg6Cw2kLz/yzhELuP/jdeaWKglDPC5vKqUDkoKb3R5T0JC9G9g1OEQUncxrlLlpkRncodpdgCf+Bq2m8/NFOmfJI7yTd9936eVEnzNjDuV2UMWBt47GUs0Ifb3AixSulHF4kNNcNl10EU+F5HISBrFZjyyAK/aD5toKWRkxQeytYOhbUg4ccBGtKtKuCt1RubS5U0n3xLP5smsJ/P6Ok6EiAQrL+MeaJaOHqhTP46WBDvmKM00nitpQXjhLykXmadRJrMOCpaF54hOSneEx4foH/TQqPCyza6v48H22P2mmnPrQtB8155
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5e963d-804c-4902-71c9-08db6ca77e7c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:04.1486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdcKJhioO2oFVCLm68OrQgKG0RN28nLJ4wNXEd7FDOutB+b/e7mhEPhKBoudIOAf/f1NBp8iJe5+JNA3pl5nPP6uy1UBccId9cgB833w3wI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: ItFyUUpiRQRTY97Bn0teMUXVm-Yj6ZNs
X-Proofpoint-GUID: ItFyUUpiRQRTY97Bn0teMUXVm-Yj6ZNs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 48b727b2bf1d..87450e14c419 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1754,8 +1754,19 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 
@@ -1842,8 +1853,19 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 	u8 cmd[16] = { 0, };
-- 
2.25.1

