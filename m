Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BFFC4167D
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 23:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjKFXNa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 18:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjKFXN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 18:13:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CA2D75
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 15:13:25 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6MTwsr006184;
        Mon, 6 Nov 2023 23:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=x96mgi41Q2cTbb+eKo6QeaOP1IiD723EHMBKFzr4CZA=;
 b=oYNVM+QtIvLZQfuQh1379JKGufFzcnYFJybJk0cJNFwysRwWuZc8krVYGGnE+fxQRHbI
 NAYZsIf3YkWegoZGLT3+JhB6UYLbvA754he8BLIuhPQGSgqmZpGK4hYuDDPTpORu+P/p
 D8/ep9ITWEhYlzNfo3nfeDjjpbmiPBx4C+ABYyoaM4jvCMwqSoSf1EYDBuEnBiZokxu1
 56ZX8+22BEwOizivi742hUTX/ayrX43WzyEpF7KK2eHddgJBokySBqShxhTmlW88y/mt
 NGv3zN7EYUfVZkOebixSVMfvitURpRIrNghuegL6vjzCBrFpeHXnmA5cxJdvU+/OCFLv Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvccnb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 23:13:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6LuX2A026888;
        Mon, 6 Nov 2023 23:13:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd5xejy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 23:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEh/taAb91MQRERJ4x4lK9VpzwmcSR4f2ac+gthXni+sNqcbhZwhu6dB7M2lVuVsOaHj0i15Ev7qMwAcNPZ8lowXaPW8pQaDJYJrr2zsiAIuqEKC9lC8nm+BrHC4OA03gxk7zDBBNMJrQ9IDoCq/kAWgRcjNFr1gIcF76h/nYAcZwtTYE+985+vORHfC22ko/ZIdJHS0FzJOLbkU3njrMhzTn+vKE6fRi1e38/whwwqFKMeMCL63PZds6hvwWHvkH0yNeBx4PB5wXr8JfaevngkY2ETTzSrAUeZQu7PBqwwa66BnX9WBuCSTg4dq5KodFnzkBEdPsT2+GzBFyGQqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x96mgi41Q2cTbb+eKo6QeaOP1IiD723EHMBKFzr4CZA=;
 b=anAfqzzFZCveR67g2GoxHLhPbJklwh5BT/SGfkjzHRlNuweNbFs0pOjnr9x7XZAKFontRU/zNoi57hUXLKUnR5cUOH9zhs17NEI5sVQ1kfnvPIqIzd92naQSMwO2QZ/2chtqOr5NhL9q7SC7bkkTYexHvYAIgaPVsAFpQnrTYEtr4G/WX2ynb2aYQsoOghLoAP/1KNEbOiOOuXlb6IP/sP9LJw1eK2OX+x/NKSvwIN91g2KI9vhIo/4jV70a9HykwdFb1tcHSnDVR6WHXHohNapBERi/Bl5uUMU0zU6txN3EwovWFIQXz+THDZCH6jnFJpPJ1k/wPMNuLZn/Ah9zcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x96mgi41Q2cTbb+eKo6QeaOP1IiD723EHMBKFzr4CZA=;
 b=CiLBHtcnZtzQDYokl7FWb0gSmPLkKUf+NQFVY4qXPArz3LjrI8IXPfUWCEqlTeH+2KbVnDJ2DommhAnhioGyBZs/9xzI4ZdWTBf9UKYO976eU8gmSbNPy36FcluuDZsyNJkIDQoMCH+UggN2gIxEDL01lbFPy+nLPB9Dy9bm7pk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6161.namprd10.prod.outlook.com (2603:10b6:208:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 23:13:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 23:13:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Mon,  6 Nov 2023 17:13:04 -0600
Message-Id: <20231106231304.5694-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106231304.5694-1-michael.christie@oracle.com>
References: <20231106231304.5694-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: ad66c36e-738e-43d4-c902-08dbdf1df2eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efWZttNb4cdBFgf1FIEAyKDkeuIlFKi/wnjtkK84wzTFY76kEmvzoz4Z6R3ITabgoQ144Ft2ZW3G1EKEOJby5+QBQ/5E7xTRq1m9DfkR2sS2bBKiJNazRelj21cBy7HcUVFbP1T8JnPCh1TgUYIi6S3Ru4jKV/4CzagDv2aWkNEmvnI0tczu8vYWQPxoCmVk7Fnm6ci8Cfe8VECLj62TBrc+sF5MKt+FfNvu8hHARABQou8Xz+XJc3WhVxRW81U797U5qj5Cybs29dPrZiRlLGHYEYGyC2xUNYZxJGwGIUCGrN6ReHqJ2Cfg5NkYNJM1Al1ncxb5HF3PbNMeAoqvJfLf7cR7lb4VekWCziIN5RQ3w8k6lUU0IkHYVyYSCvNawPBG2JQ6WrMkbI8PLEy/o0x6+CoNCmmlDF/SJiUTKcK4a9/e8u8+Af/J6/EvmwVex3m/zGg4dsJRAk5IGW7Ay4xPX+JJ1z3EhbfxTnDzMXvqT4mB/J9Yv+7wxgKrlkh25iV/aASbt0L++kX91X4pHaSG8MBvTZlsOA7PaEx/3wtHHq2dwsNYYY5tkVq7yQtf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(346002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(2906002)(41300700001)(478600001)(316002)(66476007)(66556008)(1076003)(66946007)(38100700002)(8936002)(8676002)(4326008)(36756003)(86362001)(5660300002)(6486002)(83380400001)(6666004)(2616005)(107886003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/t9ltJ/UZrYZouX+TJ12+uc5LnYTmQ387nD1oM/+PQd3BVXUwybj0fj9MCyl?=
 =?us-ascii?Q?I/KBzmwXDZ7kzR1dXOATbhEEsB065t+GNpV53MuYHjjLmRS+LD55Rcf8cwdM?=
 =?us-ascii?Q?s4P1LrM0cNaVRyWB4PCowrghO1/CNA4PR3+r5aoh2OzyFNdKdXaGyoW4J+t+?=
 =?us-ascii?Q?h5AOPd0CJ4zVkMnFAm1TcriEpcyVJSqyRIraYhN+t3Jtn30DBh8SqrSHpap4?=
 =?us-ascii?Q?gq7kfR3r8sefc4ry9f+TNgWxjw4JAvE1LRfKljGJY0miileoGxJY/V8Wg1Ei?=
 =?us-ascii?Q?6td7WUw6f2STuIZSYreFgHcgEUJx+BVcoi8YNZIcuxRO6p54KHiGe3pX1P1R?=
 =?us-ascii?Q?CqbwqF+rZ61Eit6PcZrrAynV5vvSK17WJzVnyWoZW7NRATkKZrbSf69tiNDf?=
 =?us-ascii?Q?mzoYPhvUP3akgtAd3eI5QBdRELAacxRA7zEXDSO9dWOpvkiJvuaGpj9s2GSz?=
 =?us-ascii?Q?XYilh0bhdubHV9uaIbW0zR4GTUiilu7o3gCRjIG0kEpc5voztdIHdqiypsMw?=
 =?us-ascii?Q?GIunf7Bkr/fLjaEpNnuYq3xry/ioJSzxWlzJdnPq+Wa7ZMJWkDolemBm0DCa?=
 =?us-ascii?Q?sFHS1Ohv4cx4mre+quy2dSnm5PEvt+1tcWYEuG7hAfvodQtlCVDirJWaZcTK?=
 =?us-ascii?Q?fiFmp6RX/aXeoKpNV7SHavz0Ho9z1W6aO0YRU+EbfK9TgJP9gUsE5hA4CaLd?=
 =?us-ascii?Q?GcFI5P37sz3p0ejY47DdYSPp6M1RS8xvVnK2xJxZPzMfqkkmtbTT6/sbG773?=
 =?us-ascii?Q?s+OAFkcVMG0gjvw7KTBrZV29ZN5KEusFkkMz+1zjx0H8rvgcwd6cqp/e9xm7?=
 =?us-ascii?Q?ORKoWCBunSKp4nrZhxD4Ol7ewjCk4hX7+WPN44nnNWo9YZw2y01vcYDcqA0A?=
 =?us-ascii?Q?geNRgg7c2r6SLrwP5HB4qOOxORwjTI2wtQtHJ0ifmYhDrmX+VOcwfg+6S1+5?=
 =?us-ascii?Q?eJpNXG2h9wSNEXGAfQMixxajxTKNigbLT0tlHz6QBH0W3co0HSLokPycSfEo?=
 =?us-ascii?Q?MP//AFY+DZdolRhnsQZvEM1FUpyJtud36F0CiU2stdRBnJMqxr7skYfBICKq?=
 =?us-ascii?Q?a7KmeecPXbUbrqnQlPVVC1bZXCinruva5TSigLXqm1KLL1+vI6/Ab2d/bTOP?=
 =?us-ascii?Q?8sJptR849ssnf/80YsUNRD5VIkAE2VQiyS856Y7xs6JxK1TB8s/N4P5EVYmx?=
 =?us-ascii?Q?OJBv+51KIxLPvnv7/14y8H4gF1Sh48huMrcPozeJlX8ETNyhgc19n+HOpFoq?=
 =?us-ascii?Q?QfxLjjxS9xQlIeynAClf+uGUDwok+9zRU035+axRH4qFWrg5d9H71bfJPSXF?=
 =?us-ascii?Q?1Yz+lQ3foQexZsJ+vXSbd4bX85V3swQkRifv1XoDUbxFI6xRBMF3PuJwQ6LJ?=
 =?us-ascii?Q?aYMW1gkDd5rJY7XrkU6n/to0Ij2NSWmLYiIsEd9v/XuMI2IqBcu5ucOLzuCO?=
 =?us-ascii?Q?L35meuxlkDxGut9mzGWrDJ39inVOgwZMp7UFssqM45KMlq0uGVNxkPxxXZYM?=
 =?us-ascii?Q?FLLZ9w61998Wm9faB5Quug3AuAdraJK3WFgXQ8pRjEMJa/kqiS1bFAEC2kSS?=
 =?us-ascii?Q?ymn9J25BH7xY7mFR5ZgdsOPTNvoK9GerpZH+pdEUBEEBWcdJW3t5zWtccKlk?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WbMndbs81kKOy7H8UbvdSOUzyWpg9OIZ4UvDt4jEHtQdlMaSp1csxgkwyha9veKFnikXIZfgiwf8jRE9CSTJWkhoVvC+1p890pPWd8fnGyQEesNmUyjdbmHRfk/w/IB8JQQCi5072DOg9rUrbdlhndORpLHpKESL9xmcTt9k8VQPoQ66CIYIUAmDb35gKjXJo8L4tt/zwBGMemljIqMur3RRfPQCyc9Zsuzm/c4+9Q3IYQqBw8uObTmFipJddGVe5cFSP9pw0L0pElyizpvyziI5pfHaZdDzr4Oh43WG3fokvVppkubO1Tpw0f2fupjrBO8a0yMqJCUAoLPaToMTAtE8dOj9ddHFg3p+gVZ/1FFTI4KtdM6vYFcPfvlOZZ/DgjkgsNDUbgoc1KwsUbidOCkQUlpk9bxnNvbnzgm0pfuVIMmqJ9wiOwqId1J3FIHrbEIpUp1y6gJ6kD7xWbNqDp7btRsZOzoNSs5/urGcMdZe9Yyy+LEfF27XHKYbNesaKPxzwfH/qy2lmx0hakjnPYxwcTdnCxn5C2Ziz0D0KzrsA6ohQn+emEF5fKLVgOx0+VqOtl75FFqgDDhCj60aliSjPtwXJeu30kIRvYiqn1DN6Jh76LZZFuwyxV0OiYkSeyWL3YmnkoJeO5Dz9no02oJhyTWfTCD60sEyt6pErNWIpxEd2+FxWUMl/cqbBjU/75kR2tuC9nnutkp9kaXzLuVeMynUCkkvkIv4IRsSrOZWycFlCzPHqFck3Hyybc9zLuXTwLlwp48dXVTzv6+JPVMepFhyJuhNPnhgYkDd47HDZWXxi5DsGkeCL/U3ek0RWwXrr/QK26NsFOvTNhQ0LHTTIZXGEn71UCOjLK1AiHz4due9Qayh8M0A4XfIsHq1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad66c36e-738e-43d4-c902-08dbdf1df2eb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 23:13:12.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /f9BKwWQ7fi/ZZpyQ0PVL6v1AmONjeBXjGt30R7lMrTP7u60O2mrmtv7ae25FcF7gvJROlnaTsvaQMn6y/2rd4Qf//xyROLPvDspB+IMgXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060191
X-Proofpoint-GUID: iMd5paB_2-Nq222z5gF2mFwYeKY-Mg5R
X-Proofpoint-ORIG-GUID: iMd5paB_2-Nq222z5gF2mFwYeKY-Mg5R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. sd_sync_cache will
only access the sshdr if it's been setup because it calls
scsi_status_is_check_condition before accessing it. However, the
sd_sync_cache caller, sd_suspend_common, does not check.

sd_suspend_common is only checking for ILLEGAL_REQUEST which it's using
to determine if the command is supported. If it's not it just ignores
the error. So to fix its sshdr use this patch just moves that check to
sd_sync_cache where it converts ILLEGAL_REQUEST to success/0.
sd_suspend_common was ignoring that error and sd_shutdown doesn't check
for errors so there will be no behavior changes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 530918cbfce2..fa00dd503cbf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1643,24 +1643,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1685,15 +1682,23 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+			/*
+			 * This drive doesn't support sync and there's not much
+			 * we can do because this is called during shutdown
+			 * or suspend so just return success so those operations
+			 * can proceed.
+			 */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return 0;
 		}
 
 		switch (host_byte(res)) {
@@ -3853,7 +3858,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if ((system_state != SYSTEM_RESTART &&
@@ -3874,7 +3879,6 @@ static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
 static int sd_suspend_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3883,24 +3887,13 @@ static int sd_suspend_common(struct device *dev, bool runtime)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
-
-		if (ret) {
-			/* ignore OFFLINE device */
-			if (ret == -ENODEV)
-				return 0;
-
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
-				return ret;
+		ret = sd_sync_cache(sdkp);
+		/* ignore OFFLINE device */
+		if (ret == -ENODEV)
+			return 0;
 
-			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
-			 */
-			ret = 0;
-		}
+		if (ret)
+			return ret;
 	}
 
 	if (sd_do_start_stop(sdkp->device, runtime)) {
-- 
2.34.1

