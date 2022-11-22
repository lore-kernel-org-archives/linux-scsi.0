Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459A5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiKVDkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiKVDks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:40:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1837D27CE6
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:40:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2aZKO032413;
        Tue, 22 Nov 2022 03:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=roUGKk2gor9foqRszzEFczxf5DqXee2mBc6sRVbi4TI=;
 b=NaJZ8zQUFsBhXhiLXRGhPBMH6ZNgmdqJCJDeaLPvXL04aYQCAoWp+VzNgkTb0sx3Twq7
 u77SWjT7/jaogGHYbZ23vNSWB2zmu4NilIxCZadD0miLpt40ZrLtRKgJbgGLfJM01uKr
 KuP77z/et75nbWWshi3wJ4X2nju644Vv9h9VBcvB69rX3uzhTygruX4CdmnrODJ3zp74
 z/M00t7D6thMESj/PeGivJlu5CK5rraTmBso4G75Bvp8T7DkXjV/4Cb7PgWpmED3hzTJ
 H6XGj2PYXt8qGrY9466wwjBMzC3gGpjF9vxEv4vcGCfhRTg/EH5tptwfFmc/7Id1znw6 PA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0xye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM1DseI002220;
        Tue, 22 Nov 2022 03:40:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkbgdp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BesNK+FCG6SL5I6M7Mn2hGDOuBoCBJmBJ7tKyETWFIMWAyk0TawdqZNdFGE/hnLjcXlXg5rnmB0YugDkfcIqCca7Z7MEgZkU7+oP/taOmMU/E4ZvdydwqpNeSB9lxZ7Lh6WOzi/5PcT4NaP3nV1c+I8QazNhdL6WJQw2qR6n6geEZy6M9hfDjPmnOyz+CNLrn357gtJvPiWDq1bCQKacSipQfAAxzyA2vc5cx7KV3GIUniEIu1FDHSezNPcSCBNi2LNrHH0HZtW6SsOoAy+nkFHzK0liTjwgzIKxNyfFA3U01EW8X/V65NEpNvLIryVxFaKcXvo3uew2w1TX+AT3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roUGKk2gor9foqRszzEFczxf5DqXee2mBc6sRVbi4TI=;
 b=nojThiVYr1ohZ5eSeaAJ7dgO3kNENXTKAMAzDc4PtzeU7Uz9c1jcFafvbRYOtiwKYaZfqHNe2n6WcPhoW4/kaXq7SMQn7zUOr71f777cZzeJhJCwMUrNP9BCZFuCWRJ9+REDiIppiHg5yT5XfPeB0ZUbYhv0KiRyISWD/2n0NGTgO6EPeT3f42K4uk9cGzxvwrz70iTdVyBzKig6YwtwkrfhF3fdCOQSGuWRR8ylhDSBR+5wK9AhMxmaQufvFUTSmF3avkrqGhW0pqnXDIL51XBGt4njOWEHSmPAYfVEfsVA1Ek4lulKea217bu/Dfexz0zNmaPWS6Nwuah9Ono0oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roUGKk2gor9foqRszzEFczxf5DqXee2mBc6sRVbi4TI=;
 b=SVpmPd007hGA9hJsjkkFwDSTWnn/+trAQJ+bmScIpxwc4Od/g4UaprwYsSaGD5sDOBwdTbugONeWepcbrZWIoQV2lNf9CxmFlqQSz3q1FJtq2s39aBx6yE6CM4QLUhVCEINa1ut8n2oUWbS00B9o66TGfhPaADwqL4f0nytYVyQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/15] scsi: core: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:25 -0600
Message-Id: <20221122033934.33797-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 58dd4874-6091-436f-043a-08dacc3b5001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lepao+MEeUv7PNWS/LfiXsbEYQcy4vxlpXpSKfyIwCKOcHygQEkDzpQ43vN5LP1tKz4iM569oHYNYlIKYRVrIXHik4IBTxtdmTQTslOn4/Mfz1eNMOaqaKxEwvTjSKOL9rwT1n8z1sXvkuXUJhLOqctmraQ2vhyHj3GcgPD2yYvm0cvc2bhyDsEPrG4907IgaPwRrRYepSTf3qE81HY5wMIzb7vsFYuIWwVDWUM/XYq/abXTS0TMQzeIoRA9lp7/AY3RNw1DSRUrbBjYCiS6cBDCNty3kRSREi6P/48qqILeyLrcvVGNXKuEQRfizNaW+hVJZFaBgGqvKbkBSqTm7DGqs7vfWBG3cDFKQAQZJnKJJOyHa2ze4lru0UOxCIGYIWbAxvvl2jnhUee/tpozqzHRcDTola9o5HigQANmoEGd1x2HtEAfVr1IDdq9vrGekVz1kvoBO2paSc7oa7f5zH6aXPq9XpG6e1qU1Zy32iRsrtsP207SuR7J4vGglJrm3Ue3m7YcsbWNXGIWXx8+Na8oB0iHFS3CSelpa3BVFF46Mjn2hXW3AgCw5IsFVNisYQcX0bPzmZmmFcJfWjmmoHw0ugf31hMtveIC48locR/KppANkL8oReQC3Ajdmf7Tza9W3wGVWli3tUJK9btHKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBqWZZOGQF69MN31X0Jrmu45+j+SgbzYcR3C+ANqqsMaM1TaOO+USC8PCwoi?=
 =?us-ascii?Q?QaCkX/G/dL9vU3Gx5xsjWrCpPCbt90rG0wb1JrSitYG2CBaHM17CAeKEh++U?=
 =?us-ascii?Q?gV2Pv8qrggUIobmh0oRgJU+kxtuMadfu6PyqrQn5A8WSVUTgeio8P7Gy11ki?=
 =?us-ascii?Q?4isv6uwX+MG7f2VNd1LgjI4GxJ7XZoclRvZgVOVqtIxLCxwXDRVDn3h56FKg?=
 =?us-ascii?Q?QvGZ9tcltdY+dS1EbY7K1QQTdKVY23AG8SsdHAB+g1BMxg6yDvrol+wCP8BB?=
 =?us-ascii?Q?gMapTaoI1q87mHtLQJRBDrkliicxKlD6I3hegK+Aq1toT1yP5VfMIYUG6ko2?=
 =?us-ascii?Q?o8vv/iPA4H/fccTK07pmYvJm3LuqtB4l8Va7TjWalNuN9RnyJPtBwMucW/O6?=
 =?us-ascii?Q?X1qC07VlDNezKDCv2tyUz7vzPliuQqNSjJs6wucY+IVujA7wGZAAXeZYiTXe?=
 =?us-ascii?Q?169dI91VpxUblX3m5jZnIHAzuS45DF8emUn54WMVOao2LtPQ04rKtA7ZRAyN?=
 =?us-ascii?Q?iCH+Ug8ofOYzHZij3/76X53669/m2qVAfgwbDkucTJzDJcg7Xg5lsQjB1w33?=
 =?us-ascii?Q?tbEVPNtZgfYCuIDjkH6zMZwEz+rs//T0nWECWqyIX+Z2uXDWgh2u/DFrAkdo?=
 =?us-ascii?Q?+s80avAf9Ocu51FrlcKgkv8Xbkco79Vb1RdFBQLbA0taKOpShbhQIIGWzsLI?=
 =?us-ascii?Q?WVG/kShO5VgvVz84gyc9peB032AgkTIR2cgYXHc9uQUARD2WTDArITneKi/3?=
 =?us-ascii?Q?f9SxaOIH6ahdLvyVNfrk6OSHiZF5d/Kh5MHONYLGhsHe1HVfHwgcKq5N1Jzu?=
 =?us-ascii?Q?E3NDKbGIQauaoKqxHXzFjhvUS/H+blfri68G6TgzovvLs0gIAhRUA+txaiJS?=
 =?us-ascii?Q?3ezesji9VJroh8/9P7WdvdRFzI86ApVFOmpHcA4euMTAhbcOr3OQQlIRMUsr?=
 =?us-ascii?Q?l+q95yrfS1ZwSVrjomXOqlav6dmpNBtLyf38q0/jVD/hOmLyLkzCo6uFUoDv?=
 =?us-ascii?Q?iGPgIlihCfDOto0LfktVimjbl4yWSC4rrPfNIJJAyWF5wYYI76OKAh8VTA7k?=
 =?us-ascii?Q?ktadnpiBrf+DdWfGfY3+lKyoNSQBMt0G2lczIymnKy2yBiuwuu9KqGhg5wQw?=
 =?us-ascii?Q?uhWRZ6y16fspXXCW+7UMzPAQimyB/2aGQVjBkX6oD0GV8bwfIlsP0OcCNzWs?=
 =?us-ascii?Q?lIRSCSwHZY2T2OzHM6Nz6FdS4yFTCc0VdGtAMlnc87npFX2Q0L4a7V4v1+FT?=
 =?us-ascii?Q?72xU9OKfY2+ppaf/+LS2n6+bel/Ar9g+BUS3jhjGLMQAfsu0aq6Ir1Dt/VRe?=
 =?us-ascii?Q?knq+v5V7Eza4ystFMNA/Odd+t6O6mFVt8Wv8/+MX8Bpkw6t+EQj0bN+I3mJA?=
 =?us-ascii?Q?cAEvtkiuCWZxQEC77Cz9/R/yAdnQP6waZRYb6f83YUdsiwdFN63A6xPQFB+K?=
 =?us-ascii?Q?3Q8ccKuzmDcEGkT+kaHeR2Xu5YqP2DHyqfXjtVlLT8kIRapeaMcwvqBS5AYg?=
 =?us-ascii?Q?9bdExi4Vs7VUzxtkMELLxlgxs8NN2fmDXqAM2e2+DAq2dDyxDVdEy6lAdQ3f?=
 =?us-ascii?Q?+ozm8DNg2KaxoaTuLeIk/KMp9WIIOeXj2Bf/KIrsnIgz0bLOFQOQnQ9U2zK4?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nRQ0w1WeaTfJfbTrqJFqheyx64OxWFm4ZkUUOlFYXGTbM3TnrtQD1jz//dk2vFrOWU3wHqeJ4rGh0vnmbx+7ITuTK4JBJYJHJZnoVpuQlEKpMRTUYon8zVxQrnsL8J7A/AYaYkVF1y0rRv8Xck92C7N1u6QabwqTzyiG8t+5hIzTxW78p4FCt6IbXDfuveoAfdnyewfNtAcBP4jjvo1kgrlgfY56jLPGOpoTo4J/MurdKN7kz4PlCooQJJFztv1AzA4smMymXSHTvKo0TfGQaRQjSxXC7BDTdq7AJ9FNPR4Bi9pM34yGbNafcEMhPUrk2cqHjRj897TkQ+SD8ADDWYsDZxbuukVardleCSI/XJ9+CiWGm+xj+E9MIwsENWJ1QIw0AIwVIHM+75PcdvDO/o+lY2zyXK4z7G9kksTgMVvxnDhw6z88nwYrb3HXKgxWl1DdpHNjDN+8y6nyTdklYDPSJ3nt/uh8zHuzYwmGGnBFG7dlL/3g6i/Z7Fg0VI12DedQ9JnGEE7XXSBZO35Y92/prhv43aKJFEt1x/DjUo8aw8oI5kmFzcvbSKnyZkQUdXIsQXOdd8YYWl8Yw+JfrrWmHuETqMnQUGzdKdqr+WOJKnbCpeY6XL3h2jBd1uMOF3VrqCoNRqmg2Fc9+0/MmZCyuUaCJeBglcC+gJDuGkpJg57skTjYgFLctCQwWOa7/J3B9XgtLTTFufrPkkyxTSjUXWjBH2TL0QLBxgz2v7msVOtN82DdDgGUtZlU+y6EHbBy3HdV+S928sJAu1NuzTeBaDpxk+wm1zQ2BjZR3ruVqpbsUaUJNSSMo8dmzj70KDNuXNubTqa8MqhaPuAwbc8YsSh200yclmvKZbOoxiBxDrD0uxlU4iD5bC6E7US9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58dd4874-6091-436f-043a-08dacc3b5001
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:34.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/IK8Guz0UTIbu6PFNzm35gjg1URiInPho0LDY8/81UWZfLoO/IKzFONmWx5NOZ/Bu6gC1VTmB/3K5f/22IpbTIvVNBNRtiEKyyFT35DbMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: 69g2Ku7i703Zfpk0-7R25403OD_3Ou7x
X-Proofpoint-ORIG-GUID: 69g2Ku7i703Zfpk0-7R25403OD_3Ou7x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert scsi-ml to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi.c       |  9 +++++----
 drivers/scsi/scsi_ioctl.c |  5 +++--
 drivers/scsi/scsi_lib.c   | 17 +++++++++++------
 drivers/scsi/scsi_scan.c  | 22 ++++++++++++++--------
 4 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..fc65d64b7299 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,8 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = __scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
+				    len, 30 * HZ, 3, NULL);
 	if (result)
 		return -EIO;
 
@@ -531,8 +531,9 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
+				  request_len, 30 * HZ, 3,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 8baff7edf7c3..6956849bd1f1 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -73,8 +73,9 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+				  retries,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 327eb2df5583..403bcda8ef09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2130,8 +2130,9 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, real_buffer, len,
+			       timeout, retries,
+			       ((struct scsi_exec_args) { .sshdr = sshdr }));
 	kfree(real_buffer);
 	return ret;
 }
@@ -2195,8 +2196,9 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer, len,
+				  timeout, retries,
+				  ((struct scsi_exec_args) { .sshdr = sshdr }));
 	if (result < 0)
 		return result;
 
@@ -2280,8 +2282,11 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
+					  timeout, 1,
+					  ((struct scsi_exec_args) {
+						.sshdr = sshdr
+					  }));
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..1af75cff9489 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,8 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	__scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, result, 0x2a,
+			   SCSI_TIMEOUT, 3, NULL);
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -674,10 +674,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
+		result = scsi_execute_cmd(sdev,  scsi_cmd, REQ_OP_DRV_IN,
+					  inq_result, try_inquiry_len,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+					  ((struct scsi_exec_args) {
+						.sshdr = &sshdr,
+						.resid = &resid
+					  }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1477,9 +1480,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					  lun_data, length,
+					  SCSI_REPORT_LUNS_TIMEOUT, 3,
+					  ((struct scsi_exec_args) {
+						.sshdr = &sshdr
+					  }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

