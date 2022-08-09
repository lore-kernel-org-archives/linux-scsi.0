Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DF7C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbiHIAGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbiHIAGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540291A054;
        Mon,  8 Aug 2022 17:06:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwJlE007174;
        Tue, 9 Aug 2022 00:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/TzcLLpirNHEMgXOA1hF0oH4Yee+JcwF5zEzkP7txHA=;
 b=D0wEqZNeuPbf2fpP1nzZFrSYIn8zCRVt9yzpusXqaBtUtrNyDSoTcwG8J+7gmOUqih+b
 F5XZR6ABWGek+aVMprdUZUwqoBvYXSVojPijneIgIpnDP2230JEIB5yowpQD6XchV5HV
 Dm2+mE4sN2bBSYEmBkFVq0wtX5un2uD9jmKpSTU7m3A69et7Gnz5HmNJmMnpcNBY4TQt
 xiHtbEks26lA69BcfRgCTUqyYMaAWs64VPwHbMQw6YunxKuNLtCrmVJlv8Na6t2Ujvmz
 4ZZSlo+exMhGgqBHRezdnytaWlkdlbC6T/2lQhM+PqgcXaiyc26meAt6Z56PezW43z7j 8w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hMc032819;
        Tue, 9 Aug 2022 00:04:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2cbp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nprv8ckLudcK2qB7srbKqd9CL+I+2r6WLp9CSBRryHwckPBqJPIPr4h9+OLaqBnyoSm19WDdddoE3g4Vt5+Ipr1+QAIJwZFekJ4qY7ZCJ2HI1e1at3NXENJs6lsHZ4Rcfb52r3I1rWFxnkMdypnkUckgi+rMgTJrk2+AGElF9VH+5kEQMoJx5dThs1mWaQc7iM1qf7K4AqX/uY5bil4Xo0InKRUcUS6G27U85GN9xc7MHBVd0tbbSqJ88t9ANdi2TA31O2XBiFLqYwFFbAT12X40jEamA1eEtx9NryaZ/jNwbrkIy2RX631qbnW669MAgPqGSYbnbQiOaS7/P6ouTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TzcLLpirNHEMgXOA1hF0oH4Yee+JcwF5zEzkP7txHA=;
 b=fhzOgepxG4GdgCWr4851W4iIciBoD3A0SvQ3PhLFR4FAa1FByZ3AibwupxPIco9VekGF7T8pXpGy5eWBQ5BgOLFfSbimUcZDyohf9AIoBI75GcS0K8zwzbFLGO7TmjOD7Ae5tObAK081UFWsTKxHY0kXry+9tp26bDlGJUrnNu2E6yTj2B+OouMmnOGExx9T5HtEHXVdwZbB7539WHQhkK1ounzGbfIno5Kpoxq3RBQ6GPfsH1UDpHPXHvcMI5F9aNyLAwV5/ZY+pfBS1W8yGFDobKYYTjnhNykPVzcaU3LjQUPEzobFQ7xpJWEJogDX+5HUETYLG2rVv/hg5uQmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TzcLLpirNHEMgXOA1hF0oH4Yee+JcwF5zEzkP7txHA=;
 b=EpJPL0GGVnqad93rrYT1Tl110z9+viIW0zYlYcVrh3Dk9bRGliQGJvjXjk1r6gs7q3HAmK01N8rxZlBPA0D6hwK3dYlAEpT63rbFrA+k0bWetNOFSo5UB46ECuZgo1ShH3RYOd51pRwfVgIBi/d3uMihUOoB/bl1chOMsTmnqEg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/20] scsi: Rename sd_pr_command.
Date:   Mon,  8 Aug 2022 19:04:01 -0500
Message-Id: <20220809000419.10674-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:610:38::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 888f022c-bcdf-4486-5180-08da799ab7f7
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uOkE0tHJOvcHrLB1gvu5VdlN7G54Dz9d3d8z5TSFbDDBQf4Q4X2IlTy70/xZVzIBfIbasrw5y3ihavLS1sKaAAuw7u4qVfDcXRgHFHojbAemLuPPNgJgQABQuPFzLjGyuY/KPPGAQ6J5niyQlyxFocHAyKzHrGvC/GXeNRQrXpERGv2MtVJb+V+AGrpFZPM65AMT9+UBOQ9dCR7+K58zM6Tg/fjNovAkRETOzVYOeZVao/90JW2cM6bnvkB3oW/v+QZodPIiFyoCii2sSq/3JOrORFEil9jqzbUNmVyIsGiYYEYo7UGMhfcGhcP3plSEOY0z1ICiMcYy2N0lCsBTSGZSEsOuRT3qIrrL8Bf1mUNRFYroj0xWIeFaMKUQnGZxFd2an7uyPIvSz4r7RkHuIW8Dr6UHucm31zrnMAT8WqRNHzuuUlVm5GlCKY5BMODZZGnEN/gpxbQXkxEcaLAkI5VqB1yv7ZinHzgRYl6jZcVFJHP2ED237Zc/q0bX7ntqVES/Uh4t0/6CWPEDlD68sCvin9TZNEZxHDuTDLQQmuRQaE4bGizi83lgZERm+H8+jWmxZxJ4/YT1kdvIzJtkqAYTCRC/JKjqF53RELsKheUHFO5GKYiJHuzVr/gKYhjUUO5PqJ4xZ1Inh3nycheq3Y6e2M1m9InBtVfGniWMZQOaun6wFNPWus58boqqHV2BOVOQhySjRmBBK/rTii3rZqH/oLTX2GiGnXVjIEl8GfAqmZqOKsdxwCSgEj6cKUKswD0gAfo1ROkGFC7DWVqUyYdxNPgF5cJaZc9FRlbxn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bW1uqUiKivVvpNup7FuMLb9Mw7HgqtE8ElxiAVRbFxFhat8ZG6ECmSlkaUAM?=
 =?us-ascii?Q?O1jnLQXKz2XnutUbVSwwJFolBZJZeK7PWIpELsD/8ADaKXphiERXjnjcjxZN?=
 =?us-ascii?Q?SDwjYb+zjmh3KRDazJ6D8BlrLAoUMX5GfZD0VDd1QaObNykLb8umcUAhTcig?=
 =?us-ascii?Q?73shqtsCnxj7nwQ2F135YwaerKi3xjSJJkqrJm8BewjYbagwkyJRCZgmMu4I?=
 =?us-ascii?Q?WMFvrPb2QmHgAn9HWfIcR4SmicMZCr1YZt13CBKqbOTHfyHT49UeQ4K+o7DR?=
 =?us-ascii?Q?V9Hl+WOE/ssdkDLeSZQBkFRd3bOIDcDP5uw7+4jOi0YcPFb7OoJqAGoCQnnz?=
 =?us-ascii?Q?tvCKLB2iOOJD0qtLP6mfs384G/y4RDUzWDjhlH3wJGULL/eD63EQ0TrJXkdX?=
 =?us-ascii?Q?mWT37MhdfTfMIkMwkIANELnhhduk9M7E9Ce47q6TTeB+XqybU4wQyH6mBXDN?=
 =?us-ascii?Q?IC525Q2JqNcV355077yJ7o6ryJCW5kJgxfdIGQaF8bCCrWuXA1kH/v9kKHMb?=
 =?us-ascii?Q?GUpCsdUZHkFz5a8MDJJzSzjyQN8UXK9aSegUqD0RJEJ60IKqHhRaiHrWPerZ?=
 =?us-ascii?Q?p+O2HdvpReirizFL0Gm3PH77JuHqYjtNzi09lFQp6aazh7Aa5WN3P+5wb/u7?=
 =?us-ascii?Q?DBwkIykzPT76xXfxssizNo6Eou3LplD3oKkBX0IY1yuE9BBkk8UvB2jHoex/?=
 =?us-ascii?Q?12QhSqzRZBNdoxHhWMAwESB72o8oZE8JeXS4BfpsK1dELpNcxYUlWp28+23N?=
 =?us-ascii?Q?f5wg/rAqt4Nw9vo8/u0GNhGr9U+jlzueQWKJoHrxu5QSnO4ouhugzvYNi/l7?=
 =?us-ascii?Q?L1CdS6vNljMsi7TvmOy927Xkh7Tx36DxP3fTZ0IfqqkJuQF/PDSrjeYPVmjw?=
 =?us-ascii?Q?NFp6ij0jVsLLlYlERx7MK9se1LXmO55ereh59WqTWBUB9gYmecbYRlw9PLaS?=
 =?us-ascii?Q?Nijlwn7bwnmSIHfQotO9NSbxto9otghQC8rk2Q7KF4y37JlVWQwmRBB/4nBL?=
 =?us-ascii?Q?egKsgpVbJBC3QfwxR/UeLgfykKAU5fcBbyh82mDro48t7ecmopHs/CWdBm8R?=
 =?us-ascii?Q?8EHjPFy0utCcyh/FssV+uavIoXOlfrg+yaUp/LfZ8rjUeYq4Tfs48RGnloch?=
 =?us-ascii?Q?Krg8D4pgQJJKOIt7ZYYUb20L5+KwC9ikXBBVsY4rQA5HNfhI+IT9tItMeFNH?=
 =?us-ascii?Q?9euLXiWHuUZ9a5s3KfPUTBACBpTNSfwxTcUgbesSm2huu77/tcRgalLxaQfC?=
 =?us-ascii?Q?h0/jmptPHZuGZsbGu+JgI8G+vnbfl7jC0xiMnH/7Ox7Y+sqOXYRbdeGTfjtJ?=
 =?us-ascii?Q?4/V5rHj0oUWCGNDpHKg0cOtTXq+WdjUb/XtT0tff+tW2wEqW2qcFi8eo7Ona?=
 =?us-ascii?Q?HzvHBxVZ84dgU4OjKNoQA4KPb8EcrrRkcLgd29ippxDrrjsb3Run1ULdfBHQ?=
 =?us-ascii?Q?JfkqCfFthPjyBqry2LdRzBeT0H95QQKvRXv5pfcD5x4YMS4GPEDGPbWtHqdO?=
 =?us-ascii?Q?odHOAyN4YFDfyNFHooPzaeIIuZCGzHnlX5RyOCYpR2WKD9tzEbI4VBdDu84m?=
 =?us-ascii?Q?dOKXnQFZ8KBMh0CH2mSRhrBjLoCaDbwglzodJtBpAbRgpLeXlrvYqEv+IeQq?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888f022c-bcdf-4486-5180-08da799ab7f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:24.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXSPriSWbeDDS05iHg7sZDuFnfufZPvB48I2DTQZ1VkPYY75wYGrpmtl9hW3yEoeFnywJdK0FsGKU1qgXuZR0Q4BxDV14D8CU6qzkMLbCvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: bGrHAruvhI1AYZ1Z1WXe7RRfx1mFhe0E
X-Proofpoint-GUID: bGrHAruvhI1AYZ1Z1WXe7RRfx1mFhe0E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sd_pr_command to sd_pr_out_command to match a
sd_pr_in_command helper added in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8f79fa6318fe..18ea9ea6bd68 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1702,7 +1702,7 @@ static char sd_pr_type(enum pr_type type)
 	}
 };
 
-static int sd_pr_command(struct block_device *bdev, u8 sa,
+static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
@@ -1738,7 +1738,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
@@ -1748,24 +1748,24 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 			     sd_pr_type(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.18.2

