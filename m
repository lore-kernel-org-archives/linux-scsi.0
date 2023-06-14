Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9A4EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbjFNHXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243202AbjFNHWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E512704
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k8mG015557;
        Wed, 14 Jun 2023 07:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OjS1bduE9UagQhlQyF/qwLnnO4QqggpSFnKAzNm+lMQ=;
 b=k/LeQ3PunsTJdiR5LSBeJ0DJx/H5Tcb8iOuqZe0T+E3pVlO6UpyY1gCgdhlNnSqd+7/3
 6czFIWmEUNXvugFAlRbDCdBPtGOA6y6Eduodpzgry4RJA4zL3huJccz33FBcOvXM/S27
 hiVMk/XeAvbFJ68R/gLIdItSFvf45XZ6IGJM8HRmcr/AZ3K1xOwv19DqAZ5QAReiJlHc
 1JywsadsNVmmBJ5aWdkIiqLfKOAprw+OR2ynCW1w7tGy0aJeiq0UqNHryX1NSs3LG+mx
 Is6DK/7iHbYGp7w56v/wRULWFM271eRa/bNkSaO9XOdyFxezAjK5zduJ6zL6K0SFkdSF uA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2apuu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXP021593;
        Wed, 14 Jun 2023 07:18:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cstAWDYRwmmPud8Mdy2ZKIWYXkc7FyHYTpXBrhTbqE1CfQ5aCSbyWXG8jlN4EeelP5UCVTDr5yVyhcHTlxm/M5+JjzYmKFOKx3sjIe3JXueOTWgRiko+GprN4mwQCNWLAJX4NV0FZHAUPRY7oRyu3WqugOzW+C3xEqAlADiuHyQ0CNfBF4peKLKBNZF7LNJybnvC2IWaD9DDP8okABTx9InzANojojt9Zl8CGRAvJ8k3AL4azijEveCBrq+HjInxb+t5bl+AQC5S6hMIpZbO7O5GGX4DVB/zb6wFjLJMeLOGzawqe20DX5qukMHuw8I7CHEN7UqMGviwlagkRTX+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjS1bduE9UagQhlQyF/qwLnnO4QqggpSFnKAzNm+lMQ=;
 b=UosvgUnenUOarUCBtXP3Y8h1czCnxAW/l8zfpoNTB3QuC1mJ9/3c0op39wtg/G5pXwUdAVry7O9178t69CG3Yv2NB6b5G5i1V5QsRZkYoH+Gjt6aHUNJ7PKYUW7WDwhcqg012tEUplk9LdYrFX9lT3344PFC9HvA6J1FCc/rhwDDOHTGQyH5rwUEUpP+ayXjR6pkAoX6buvniUxr10AqVVTJRQXATCebSwLxBJthvNvY/nXXXwRIxAF2Q4nwKCxTcSQC0vmz9DLLlgqWmlTxFr8ndAC6Ng+ZMbSjR5K9ADo7d52jkpC/oF/KIhEvnS2ag0Vfp3WPMnLAg9xX0fT7XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjS1bduE9UagQhlQyF/qwLnnO4QqggpSFnKAzNm+lMQ=;
 b=EvX+DShMDpI9b+z8wblbwIiwxNqcqeGCEAm2LQQ0s0LPPOywNR4iTB3MNG5pMyZp7Zz7Td3WHjwMfkb2d6IWHjKGvKVgw+G6PTAh+EP6EF5hK3YFHGaW8PpK1zp1kpTOYwE0lYAODf721wppj+JDQhss8EkCerxSJaZqEoqlTAE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 25/33] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Wed, 14 Jun 2023 02:17:11 -0500
Message-Id: <20230614071719.6372-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:5:74::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: a55f25f4-3aff-4df2-6eca-08db6ca77f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7VfJDmhmaphlgC2LljXmqNp+PlJZA9vMBsXNbaloLcSqJuXCcQo8wbJymnD7og7L/T+DLnsjf33fkELVnbhqC174S3RVu53NekXEclAUZ/XE8zKZWYyEcVUZXU68NeuEJcbt3tUmH7AhZcrlvd3SvWzlQzLR225ohmCPU2PTb0414/ULtdc4b61L4Blgwolx/hlOBObh0kQL0v1xpaBqWRInnOMNZuFaGNzT6vvFH5ZkSM+6fTJYMbb03UJwtaKbF94+rbK7kLi5a/QaFvArvooWayOv1S+TnMi/ep1WXXsvObFQcHxnYcP32O7XqZx2WehfU11tqrBvGgjhPlGZcU9AIRsaJhZdl5z5Ipi2zY3OufSIut27XmyeDLpb3PCKyRiyigKc6VbTGMXJnzZLELF7aJZNzsB3SfLoBFfR8Ir7qp4bkBxAYO9avKHH57GWOMg57GTvhzGl/mpYYIHcUKP1dVimyUVJ+j86YQB5wxTm9Z2KbhtpqosIv7De+5jTMCwVg/8r/QGtOSmeO2bjkRz9bLC7+xLPZbBa+hYsc5MFjFRSZO4tYEqsxNlyig1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vs+ZaE55FaqlCBU3nIq0hv6pPncg6vpZkICiynTaVltE7ryypne5qmbdSMOp?=
 =?us-ascii?Q?P6+ztxmQwOtA0TjSc00QuiDpst/sLPuGdw8QtsRz6xX0R0iJzs9WT68qM7aB?=
 =?us-ascii?Q?x8vfZNGreWU2WZYA+HnNvhA7D994lP92sBv+ZaMD1JLiPD4dRiI2JAgFOrPW?=
 =?us-ascii?Q?ltGL1WRJJ9U0OFUX1gXpzDE7UPBN/HSYyt8JIFxcg2e34w92ogGqOeXjYn4Q?=
 =?us-ascii?Q?VcHdUV4lmWRqaMlzGJmgERaqoYYQCL+nJPu35tj2byD0/8PyBaO4Ygea2hg6?=
 =?us-ascii?Q?3KjLNhx171pbwvsZQv0PnOevwNXtIQ63aabp7GBHYy2s71W1dAvA7ZFqkBRW?=
 =?us-ascii?Q?yPv7ZFf6J31XANLWQxsK6jE3jSkCT65eG+l30bGXMZnS/TbJZbdJ3nqZ5Gt9?=
 =?us-ascii?Q?x+SevnXkHrvfPzHlTA/Hc3rrOxCxd7mDvH2n3rb3IO5LiyglYebT7cYuVLjk?=
 =?us-ascii?Q?x4ocJW4UBHZRBlQp4oexEK0JnIt2DUtNZknAc5O3sdr0g+kz1rWAg7LBBIoT?=
 =?us-ascii?Q?21wqwnZn8lmZHqabKztKI55lNuCdTwH802CpMKSlDLj9FLRYuredQ5Mul2V8?=
 =?us-ascii?Q?/6TVuK3y9W9qoD7UnzkAHjKxB1LRp4chsbYVyER+nNkiMPBSapGF3i37+mTD?=
 =?us-ascii?Q?B+xNkakvR0zLG+gugcA89r4rkD7g+IdASdTX361i8UdQ/3QIgToW8jERa+9g?=
 =?us-ascii?Q?q6XpfrKnmU64KtI5c+Gzw376XI5Oqh0wBw1ZycKgMC/LVXI7DOjqceinCHu2?=
 =?us-ascii?Q?EWcIn2vb1Ykgf5YOq/HWLL9EkejzDAHHH4DIPARBFYYf7QslOsxn2In4Idok?=
 =?us-ascii?Q?vSqi8K9Gp2zBdn7EYnNkbXfHRceazgs/AtTuA2s10spsIGhigaNnQGmx8//K?=
 =?us-ascii?Q?lSwMxf70rZ+WIIdthiYGqtofiHOfDH5Yp7ALnsyy57+MuMyJKTSRfGGqs8Fu?=
 =?us-ascii?Q?UFcTGFoUkXDvOsthXe9gqZCkdasg1RWtoJ8tRJNyD7cqFYDS/eVk6V0x++GJ?=
 =?us-ascii?Q?C7bDuA1HdwQLfhm3TDJnmRhJiBvkMz+idaWNDUgQKW+G+tsnhILhHsJiY9V2?=
 =?us-ascii?Q?08bZu2LCxZigllbrkEJIOmSEgkMPnGNypTQq0H5G6N4xVI7IDE4SbE9fxLX8?=
 =?us-ascii?Q?Vx/fXqOJBlJrQUt6q13xqxwslE2sgMRam9lpmsiP0KtFBlhuf+tD6uyXjsST?=
 =?us-ascii?Q?a5yc3kluNSfsHHC3x0wEw27X+VByHG5kHsXF30TYtmQrkXmvslAGfXHulNoL?=
 =?us-ascii?Q?grcGn/TEAS6z9hPruXp+52LTOJTmQSJA/YNAOK0rwb5p7ggAfFC0iN/AFTWj?=
 =?us-ascii?Q?zFuEly4S4JU9GFLJcbm0Alc4DahwK+655Tq/1j+fzwSMmbZgfuZTLpYefhot?=
 =?us-ascii?Q?G8n8rOkYfDDUzdn3kgiJi5TfbePH9a2b3SWgS0lGgloDOurhSJo3b+5KQgRb?=
 =?us-ascii?Q?YMA7SLK5tLAjPej4mB0Lz0G0NqvwmmN45AS1z20rIAvmwmdLMNOkmjcegksf?=
 =?us-ascii?Q?WRo5793lIY6goOdwN9lbV+cvybiLbwwLEOgAAkOBwS/lPKMssEWaA+1FoxNC?=
 =?us-ascii?Q?WYpdo/HzG71zLLxQ1LQBgikKEmgkbG/rPr3nE4T+pS6bN3hl33ZlXT3/gvU1?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UxLOJWYRp7/cC1NSpdgyCI+DblUOX8gHfHOjd0208abI6xq95LQ8de7t8D4R1NElnY0CCW3CaBokJefadPBWqk7wpjjVkZOdLW3p93Po9FbCWI6vWhYZfr4vhqyoHMzkuN2/TVPyGxJ+Tl5pmpeLpo07VvfAAU+Xvp3CkGtZSq5AKzqXKDVdSwclG/0MKcTv8eXXXJz4OwswAlnqjZl/CTdVrG50GkEOn4v2jq39jej+UhSVjDpPVCLjHFAaFttOM2TMc3EV/bb7cfYusvbSWpmQouCiwH+XQEaSgs/vazVZ5eAY9cXREE5wcMLWT4gUO+sGZeZRgh+uMlx49lTLe2Y/eGxOyVe2Oo4JntUybQUugSJR/C82nKoNmkyf7s6JBC2HKEemq+0TPV43eIeUgCHi3fdMO8HsD6gi84g2qwAV2wSkGcbL1OY9cKhBRpxQVjVFhX+Kf26YQBlPnyH3WOopOMgXHQMv69lf0E9MyqfHjQykKRZolMQCf03MUUv4tP1KhAi42V42Na1Jxs13KflQ+KEYc7gY5Cdw/oh4o9//cwYoMNIGv5yTuOCd4B5zwQlOUdhBdYdc8ot2iIQWnMCJvvH9l+SHe3G1FOcT6IjuazUPK7FwDN8q1zN52VrkQJhu05x4gGvlNmrQTtVKPNOw1rKyrAM3dDXlpsWONP4VYc9b9K7zEPEd446JRNMD1j3RAxbgISsRq2luQxRdtiWkLcLPKpejzFswuIh33lcGnwnfgdv6g5hlq4BHT8OOIFhgTICyk23pXO8QtbRE3z4IQeptGFZrHqh2VVtsnqJWVzEzYhtw+MYMpwQXdbtFmRQ88Odeo11GP3zWFjx2RIGsI0iv5zHshrgJ2T2kV0MKdweUSU0UY9j9GtEiKYTp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55f25f4-3aff-4df2-6eca-08db6ca77f74
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:05.8086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQ87irjvxK1+s2zHEtaw1kv09QEZfkGLXrdFct5uDb5rw+tkBuyIfHqlAFbMnVZfLnn3Xy9liN7pX1Ws13IqdNVlxSVnPmTWu+cr8BgWsKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: QBF6LthnTXXoOE0ramjZW0X4rG8NLpwm
X-Proofpoint-GUID: QBF6LthnTXXoOE0ramjZW0X4rG8NLpwm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are two behavior changes:
1. We no longer retry when scsi_execute_cmd returns < 0, but we should be
ok. We don't need to retry for failures like the queue being removed, and
for the case where there are no tags/reqs the block layer waits/retries
for us. For possible memory allocation failures from blk_rq_map_kern we
use GFP_NOIO, so retrying will probably not help.
2. For device reset UAs, we would retry READ_CAPACITY_RETRIES_ON_RESET
times, then once those are used up we would hit the main do loops retry
counter and get 3 more retries. We now only get
READ_CAPACITY_RETRIES_ON_RESET retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 64 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 87450e14c419..f6f0e483cb13 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2557,42 +2557,60 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+	memset(buffer, 0, 8);
 
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
+
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
-
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
-
-	} while (the_result && retries);
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

