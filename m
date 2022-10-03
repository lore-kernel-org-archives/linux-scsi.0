Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21760C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJCRy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJCRyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDBD3F1F6
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOYgI015780;
        Mon, 3 Oct 2022 17:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JMMWtd9DwyGfO1igmZaTVNwQ0aJIzfeNWlYS/fG9Gkw=;
 b=Hxg4Ofxmye7j9Em6uV+tkiizzhMpMBqBIohLqct8Nnlmc5jJYWx8en9QsmDfQwnmQ2r7
 dKXFho2KpajKcZZZ4KMkAAwMhiUtwS7rqItmEFKlvom3Oynqj5zByNFNzPziGr5+TocU
 ENThEgyhs7Y0c8nQs1fCXKXAhXF//SjozGfdcXGdbVM7z0aixoAopLLUEpwU9UWfifrh
 OVZLN1VYpgbtrQxN4TFAhBHSUn28gnjY9GlawytX/4VgcoXNHWWyeXBZ51pchnvamP2D
 Rvd1PDQa33QvwTf5D2KJvcQzCvA7oPv3Sl+WejaHSifK9wCL4h1sYRsVsoprk7uRFJfy AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HXvHg008322;
        Mon, 3 Oct 2022 17:53:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03q5x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMqL267o8Ts33O35IvyhVBr6C7CpA6GYvw4Mv4+pkpMqoyBRH43i9DZAh1DaNa4OTmi7cXE4wSK6IFDqxvOjtCWj0FvJbpWDLWhqDKD6wH8egcGegRKumEthHzoIbqPE5H4aLo2QsMm3TltUwiBqyOnvKCYeTMLGL/1yjjp2YPy9b8Q4stZ/bRYXRJKkCwk0DUFUqW/hKwjllca7jfUsxVUw/HX4TBpjYb44dHRx0AU8FH97v4nK2RNNQ54E7BYUfMclp7tJYVWpWvOZQqayW9h/oFe60b/qzzv75sbaSKvyQGXWMoM8KzRaKqmENWoydknOjtMNbN1SWke0u4lk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMMWtd9DwyGfO1igmZaTVNwQ0aJIzfeNWlYS/fG9Gkw=;
 b=QWifzdWoQqW51oJzQydGgi8sHoYzhRM7q6JVw0nl7HC8wSXKGh6xE7ADp9wgUUDi8zPjtFbE6S1XH5Y5NEvYMo569Mx21x/b2qGDAPhyQAmy/zRnxkUAgIPGuu1Gy20fT9dmmYHh87KR9R2TrUU5l5Ny2NMczK1A2QDstCzqqL45em+PYKVWTYtP9/+8KqCulIrN/MRKSp2FGnkyHE3wsXp5ngzr999cGddwUo0BFaJYy+8qAkIwGKCWMqaxyMspe2Wt5lzZc1YfsBsbR/PVltIfw3YKGpgTcDe0BOFNAzUrn9jhuARvrPsGQsi3whQ0UV9CunP58ynoK7xpNh3D6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMMWtd9DwyGfO1igmZaTVNwQ0aJIzfeNWlYS/fG9Gkw=;
 b=k0konUG5fMoEDaQ91IHzczYdDlqbWPEvl1n3GObkNNMHzsTaebGmTXNbWaoNsI2l1AUhzoIbv8a+8QbtQ2lDq8cVPQjxwl4PwhAqZdtIUR5HUMqfMUlgCtR/seMIlVG3Ofoa8FutFO4doFvCl/VBAHR9mqQifTQAusdaV8XT3fc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6824.namprd10.prod.outlook.com (2603:10b6:8:11f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Mon, 3 Oct 2022 17:53:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 17/35] scsi: ufshcd: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:53:03 -0500
Message-Id: <20221003175321.8040-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:33::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df87baa-31d5-4d79-fa48-08daa56839cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSviX/H3gqbeL9oBQ1o/BrlXdTEBPLP+x6IvB3/l/rGNT8qkE5WQO8DmzIn3+WI4UGxdUpyxZ3fUH6WaBxulMQ27gMSFq2LIFhnPqE1CTS7kXoICV70FeYzo4Ao2Q9vUMnM0hi3RLMXYCYrxOUcyQMf8LKwoRAvQvmKNecLxpnUIajnLnSAsF2nBa7HtIK25ZZwMRM3k86rW80y5jKox+c8sFKSzX8h7SsXnK3K1LVD6yZ9TCRmyCUcBVPTBh6H1tWTd3/K7cg7hQtu/gjkXfKX0JZeN5aNAj3UwaFe2hF5qO143sOD0Qthctp0cZMka4Zz/RYUd7bR1hq3g41yCWJKLa8/dBC9qzuShudFv4vKhILIXN8a9DIF0hxgbczDQIAF87nc90WhouIEz0jx9WkULVaGsNJUN23z4L6NKjR4mZA7OpW0xaohRe+L6olVo+Rw7DxR8MSk+SKjt3c+82l1nkwdq3IJJh7hKbPpp7Pqc38TWtm1NUbCN75vjxFrt7QUK5vi/suJJQoI64AXzOcQcXbxPCdZ7Gese6Qua4NcCX8xM4+JFlP/bdNTxkuHe3Sirgh3V9CQy6+yininqw+cWsW5Zh7hDeZMNUZeBP1B1vA64Nqqd7qUZAhB60n0490dtASMqAAgr3X5f/lyMoNmUJTQeXfSugt2aiY3RUlFVJ/tdjzXlQ/xAZJFa2fl7gSiDVSAgPChqFZwSLi29cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(6512007)(6486002)(1076003)(478600001)(26005)(38100700002)(66556008)(86362001)(316002)(107886003)(6506007)(83380400001)(6666004)(186003)(2616005)(8936002)(8676002)(66946007)(41300700001)(4326008)(2906002)(36756003)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LInCykvvp2kx9vHhfO3ZFIGeNMMoTq0DljwPCSFq2DcPkAkjtFiFQ5tkMVMd?=
 =?us-ascii?Q?6IArESWyaZfQlQifzRmKes0ZS7CGHs8Wwz8jK0+qJ6ld5jEEp3I3YNV4Z0YR?=
 =?us-ascii?Q?3h0Wo6u1TxNsbZikid/jY1zjeY/bW4PFJAt1TB7ys4tVW9nHV5Y6KnkfCp3Y?=
 =?us-ascii?Q?QDb1sbFpRumo4c0D8p2kPR9MxrsZo75BIvvmNQg6wBIoVq4eIq2vwVmEiQcr?=
 =?us-ascii?Q?yxKTlQlKpRD9tvBi5XKDHPKATF+p/Xq8rUpVHZ2uz3NBIOIHlhc401pX1JmM?=
 =?us-ascii?Q?2DSHHOe/qBGO76y++AR13/60WgVW5k4j/86G177S2hBEHBkV8b3Z5riNqwf/?=
 =?us-ascii?Q?XmnLXfR90BapmUg90vpT1i2WIywAb8W8EZS/o0u0uPtQPo6SiRBn1x/IqSas?=
 =?us-ascii?Q?6yts0X2/dwqbc/ybT29TgIGR9AnnPRDLeY3uSTKwZuweQA5OusHezEWyYcXH?=
 =?us-ascii?Q?jyMf7fILqbZq+qCXeDl+7LgphlbuYaqZi077Rt6TxD+AfuohFIGtUQvHDjOa?=
 =?us-ascii?Q?u8s8d4YSx1GRV/B4DNFpf8NZ1gcElVf/s/yuk1xrUgskHaBAjtu3vPN81HDN?=
 =?us-ascii?Q?nlmhqlHCR2XFoSXeDGQ0nhodr8MtU3I+LrW6v/mkoLI5KBQFBHQ55FGDAeH1?=
 =?us-ascii?Q?sWbTKKeAZ4n023qoeiGyaAG6MfujV3xPX5w4drsH0JJur+t620OroonHhRHJ?=
 =?us-ascii?Q?E8ItCCmYyam5PE9tjnEmTNVDLCF1ws66LwzATRqIZk2GzmjqIG4CEyowh1mg?=
 =?us-ascii?Q?h1d7FsTFSMu0r7EC7bnunHCRodvxMAozuZxp7ohKbSczlCVMaUgV9i/r96Dm?=
 =?us-ascii?Q?20YOOsYkjWZJg/K/H6feflqCYs1gJBKA45s8JpefSXURmPuLAIcMtqDxBcPq?=
 =?us-ascii?Q?KS4jqLyWF2MBr9Gw6JrgGJr4MQ/KSX8K5dKSQS7/nJJFcgksV1fc75cTHUUj?=
 =?us-ascii?Q?wkrPBnnIGSyukBGQee5yB/jrnnupor7++xXG5yEWWUDweDih3Rwm0TKL4GcR?=
 =?us-ascii?Q?ERslkSeclhdq9YMZ6WucElv7shlD2gYXNGg2sneri+FlJ5hpuVwI1iHYMjmK?=
 =?us-ascii?Q?KToaYhDUY0v4jPHlhkcycMVTPAIWkvz6kGHs18do5iz19NdiDfKnxmQOglju?=
 =?us-ascii?Q?Irn0dDYBSZXoIL/NNWt8/c690ImOVcRuEC5Alk1IjM24iMrbZyLDQWvE6ayk?=
 =?us-ascii?Q?z1K0ptCs60XO4KJAmPsSd6iAR65Cp9pZKYCV5S8vD3msggJ6z1A68Ng5BIJs?=
 =?us-ascii?Q?WoRwD7oW7iVjVCsG4Tv6zEZiHlbR2UIiTA/4YUzHffPZydZQ93SD39u5Xl00?=
 =?us-ascii?Q?p0lnvJlLBmT1VKKXPOFhfoyzxQQQh6BQ4qAr6tUgCHLDkANFfBlQR+kIUl/R?=
 =?us-ascii?Q?NumYVyt06H9/4EmicH43SH95Z8dzj5sjJsItry7XsFc6tyXZ/aFWFZTXBJvM?=
 =?us-ascii?Q?n3hxnxrhRVzDEv+DcW6d0xoMwVV3df2i6B4nKaZsYg2ne/U84O16hfLMbX/m?=
 =?us-ascii?Q?bosWAt53i8nzYvQFmmLFh8MDiIkvvQvMMUZhnmunRI5UEgttK+X8XPG98gPt?=
 =?us-ascii?Q?jfVPRaTCw88XW69MujpE42q9jYu7vH7fI2dywNHGd6exvgEk6Z+lxPCrsfa+?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df87baa-31d5-4d79-fa48-08daa56839cc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:49.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCjMN8J+aOobT54pFtignRXkdqVvI0tKeygdnqwlDwep+pvuPd/Rkewlz4JgD4VcIy3yOiKlFf80afPq2rJeUHXe1jNW9TRMyXkWcnwx+yY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: gPVlRs8gZ8g2LnKd_xeHJIxPnQVsFHTG
X-Proofpoint-ORIG-GUID: gPVlRs8gZ8g2LnKd_xeHJIxPnQVsFHTG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Bart Van Assche <bvanassche@acm.org> 
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a202d7d5240d..fdea6809ec5c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8781,8 +8781,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		remaining = deadline - jiffies;
 		if (remaining <= 0)
 			break;
-		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = remaining / HZ,
+					.req_flags = RQF_PM }));
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.25.1

