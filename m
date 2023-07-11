Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2926C001DE
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjGKVrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjGKVr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00588170C
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDFpu018370;
        Tue, 11 Jul 2023 21:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Mc3mpXbd3FOfQX+lGEaxBFNMeOgSSKNOXTfT7Hcgj9Q=;
 b=juPysZe5YiSc7a9PYVjmwDY6vCR2ndaG/zDLl46sDffPd0Y6qh1Tnn32v4BAxJ+cqREL
 Iihb4NIKk4RjpylGDfHANh4NjYNfWXdVm/KWVvFsdSpMs2/Jj/a0pHf+mnfToN9Xkot4
 65PID1k+6KHRstm+v+m63xMvnJktwGdeG8hTNtfr0HQGa5+Hdnpd4LEz/D4nWgl6A3of
 4UgVkJuTXOioeDHLUoVV/PL06fdDis0pdgow0PdlHRTTQoxBOIuiWB5TOoiAf4GUjhYi
 svVyH1ejhlK4BYxvv8Fdqc1CTJljfK0HFNYri70PLbD64NP0Tf4kjpy2wP9p8DkJy6dN IA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydtwy0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BLl3ht026865;
        Tue, 11 Jul 2023 21:47:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h6hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1lIBN0flUnAqh1zt9WN625eVVpjHFtCQ2QISrywhRb27ugGhjV2du6fjyBgQBfW3Sa6WOP5jZz8tV9Z7FhPwG3okzXI4Q7k8M+CEk3YbmPCuPSVLE8kSKNet0FgUCkg3QiAbH2WpBhTNAkO91wr9LHGKScU78ZLVELa7AzuDt6hGxELVKQkfM/PaZOaK2dSkDXrItP/L09P5aMaPmJ+izZJy17CThGBxmkH6rOEL2ETrQq2qHByk17jFAsXzPHYCl19BdxCjRekZxZZ6MTx0uUNcXWqVS8HiheN041oKQ4bm3k8D1r/llKojl+thL0o/JJz261u6GZycE4VqzH1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mc3mpXbd3FOfQX+lGEaxBFNMeOgSSKNOXTfT7Hcgj9Q=;
 b=Rl13RR2CJcdXjHy2Atr1ZQnON0mn+tJGkFN0bi2EvwJ2NCBPzZL9KZGuFZBAeWT/pkR7RUFbqCY8BzA5DuK5KOO5qETH031vR9axFJyvRNGlzHy+TJ9rMCFDDrrRPRa7VzltSHZAnvBbNBThoRSJbGMyIHYh0E2kLxYtE3K8373HdS+t+WACgw3SeL59eKhDbAqE9TW/VYWmZ4Ub9Je8AZmB7aHtM0s6v9B6OJoyBKxHi36QgicEqSW4QyLDI9Nk+jRkHTRZSjpB4W9FcBlQVFBc8GSqpSS32vo/qM10S8rL5vC3OeavmXkQse8Eq6AsA5JyM3jUHlx/rNwZ6sW+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mc3mpXbd3FOfQX+lGEaxBFNMeOgSSKNOXTfT7Hcgj9Q=;
 b=PPY91n2VAZHeK/a1cMuy2Xy3Qw3y6CUiSGBu0eK/g/jADuiDVvVYaA97Dct3LUqhR6g+ru33SXY45uDC3qyNZq4vDhWKgf5qS2CHB+R494rHMPYQxty5PdvH3WDnvQK1fwyzzrgr9Vxocu0A1ip7qvC9oyfdK4LUvChhYFUSeEY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:47:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 24/33] scsi: sd: Have pr commands retry UAs
Date:   Tue, 11 Jul 2023 16:46:11 -0500
Message-Id: <20230711214620.87232-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:4:ad::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c52f15d-391a-43b7-1bab-08db825863a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xp+82OD0Tpmo3KE6Cy+HxWMSzEajhSua/v64Di0tW/+3XO6L5w6dnEUSisTQuP7qaETqb7VrkyEIAwJrcdakrv2gxB1ahv1jn9NbBM8O2rCtTbd0338a5yKlVsenrMhettnKNU0ur+7h7REPdUXMgJVtEZ3i3anXV9bAdU24IZJdYYk0o9X6rRwqkTeFafWgVy0iRLl7ALdFQ0rptUYR8gBkksFlnFOip4aEKWLpvks9A/SJCYJssSNXPuJgAQ3ndwNQE7OHUvIFFmpezOfxe8QLDpViklUsQr6PfaYqtuEbMhhKIG5y4APy1+DegbNC5xDUM/B+SRkEv8nPHHica40OQWM8D+b43KBkM9OgYe0hUFfhU4ZdHr9gnRW7HOjV0ZEF8CXDxekMyCU0DQuDo8peJm0Fbc+7K07xU57i0tC+uLeKlzgrgGl3zoL1ldSvDclFCSJ1EL31fe9/A3SCwGGFLfUeelovaWqL4FPX+y1eXxhyAtS29K4C8jmg9p5Y/rtNJ8nhHaAz6wzQG3tiyk/TSz0TzhWXHphLaKOwhvTr2Gh/CdkV0KVnIdlgpg2W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(41300700001)(2616005)(8936002)(107886003)(4326008)(5660300002)(66476007)(66556008)(8676002)(316002)(1076003)(6506007)(38100700002)(26005)(6512007)(478600001)(6486002)(6666004)(66946007)(86362001)(186003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EQDHeejsOyk0uZHhJrU8FA/HvwwtUVYZP3tCV0SkR7NGeSpAx8PDEgQNLQns?=
 =?us-ascii?Q?KcPu+HEQMh7UKVMH5tH0g1C7YtoEdr8nA91uPmlsAVshqYSkGObyrI1Doz4v?=
 =?us-ascii?Q?JQloEMAIICYUplPAAGAHboNWG2CW7jaSMf6+4aFGW7dYHZTYmixzsH3G9xuY?=
 =?us-ascii?Q?n++cGCy4w10RieYfdvtuqyTHnz2b18v9GFh+8FVpO4bcgoDEZnOtTwm3kORM?=
 =?us-ascii?Q?NHxkXWIntheTUrYU+CmMzyHyAfWQPKJmcX8ODuFvEv/qx0ZE6InwPpVMgP1+?=
 =?us-ascii?Q?jEFFYY/GsU5yoVIw0i/fviCyj1IsWJqlHMNSY3moJtqCweecgAso6v/YTeMF?=
 =?us-ascii?Q?znTqTpE5bPOgMHaMFlksBbUb4x84H45UHLBqPrdAky1kKInFnKzOBI4nQ0XW?=
 =?us-ascii?Q?SGOMwGnKPmN/yjOBeHnIAvt19D86+fUx24FjUWYS9LaiuQSw2GVVHjLCBx/t?=
 =?us-ascii?Q?DpltJgLAP5+40opE/Tz2zl9l7FtqHaKiMv/uQCY8GQFZuKV9PDAcbyBT3KxO?=
 =?us-ascii?Q?OQhsxv7kP3DkyC7c/YH657iQPXEl36Hq0oO2DclY2Aq2S2P3oqKXeK+s6NxB?=
 =?us-ascii?Q?gHk1Mlbs7PLRBNfdlrZIZJUJm8fnRb7E1ol1yUG27oswvKK6LpqjZiRd3p8V?=
 =?us-ascii?Q?Ut0RGRgf06TSe+vVY9CknrhqN6NO4O9DHnDpQvn1MOoy4w273TNWXhCnwSWE?=
 =?us-ascii?Q?sUjbv9vVAfGC2yfKim5gxGE6WbXNLRXxhskePo9GNmTWFaU8aguyo4SASb5g?=
 =?us-ascii?Q?BKU8JQ6zZvot7+hbMfsZ38UWpxRFVtvrxYUKfK+XZdaeEYcDjodB2Oh6Ku7V?=
 =?us-ascii?Q?J7Aaq0JO4rQ+Mm5OzNbtUBVXodTLiGWVsy+3LDDdQW6d4CK0aXIKs5FRrWuh?=
 =?us-ascii?Q?CmFjYRXehfEsoJtBHUnNX8JBL4p62G4Ti95do+Xou7qfLVuKM2PvSyNzO2aD?=
 =?us-ascii?Q?oBnod069IEbibNeG3Yk/iR9DBkaHAU0/BBnaOF0UlizKw0pdc9HsyETsPJlt?=
 =?us-ascii?Q?4+3BtGCmG3wA7uw6V76nUZgs/+FAj4ZT7wzhvIkZM05ZzvFQhK45/PlCDGqK?=
 =?us-ascii?Q?NpZmOzNq31EY2Dc8/wizGP0QYser8hggaSCcCiy2VFQ0UxapFPppPjz+qLBQ?=
 =?us-ascii?Q?kw5IUp9XJDSqXn5MMe/lTiKpBfpGv3YUL+rxWUUa0Z7pB0dj4io7PnMSkW7L?=
 =?us-ascii?Q?Ql+YnnqWIiBOqbvmfl25s0oahW1tNYWSDGfEpRA3a6CJKzGGZ9H30G+ddtxo?=
 =?us-ascii?Q?rhB0C8WPIN0ggojVnC0h5UEIysTtZs/73vlokgjhSSQI6VtNzI3A6P//GHw0?=
 =?us-ascii?Q?+fR55mOFmnHuW+iPX/vIZ54Gur8/j0EdVr7V7rDs7hHLXRfcQw9i0EZMH3oR?=
 =?us-ascii?Q?JfCIcLGgQZE+NnqQeEvZ6rPlnAMJirkVomnNKkd00dcjrOz5fW2Tm8juYUY+?=
 =?us-ascii?Q?4me9yeXEATX7HlnRZykyC6DNNbD91/TsL3RLcvX3qsQyopbbWdCO+OMdH+wt?=
 =?us-ascii?Q?tIAqMOKhbLYLNLOV11f/qUfS1EX+KApcVG6zEbK7Q201BDeezeXxk7awBKpo?=
 =?us-ascii?Q?gv3C0i0AhElDmgR62DvQdlnM131YsPBRt1X59trzBS6xQAQrGerV4z6pN2NH?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tFEHpl9cgiQDwvDD+AOALHM0+wv/vmGce845RbjBGYRHL8y1i6MQANR+1fL0vv2N91bVuKCGFlN6xCzdYJSyYS/1RV9EaYwptHy4yJRcmK1SWvVU4tjtSVU+VDwTdy6PoocA1qKB9Gyz4/lkDM8kY3TDD0OjgR07laMIUdj1lxA0VnoiqWusQmCpHl8UXBjibTIY2W7IQZyXpZzjNAQGBy7GUY7VFr8I3WRj+KnotjaLlB7MXK0p52vEKNA8NV+yRQyyR8BGUPYjiXnvscxachdJXXW/MvwaI1MeP7Hoot+ZbBaQXxPe0Se3wdop4JfIQsahI39C9oULcwNtKOGT+ch52UqJs0zhaETuecCOPNTFY4PB/hDN4g1eWAsEEbTTghLbSyNJEZdBxB/0pZbuvhX4icgWJV+fOmdNbp/GEyy97CeDZwPxhnrmX/US3vBRVsHclUKHfY0yNTP0Dra2rAgIet+UKI5CzjSkgw6ZQzcqs+dB2c9BOdx6u6HMZTBOQN6Mt+FMg4nhutnaiicmE6TzYHmayhNvlrF27Qw1xlUn5YELuZFHA6yjpuD8j1NiOn2V7cyzmfDzKWGxNHd+gG93Hr0O8ttHCv7Uj87nmF5LQRgf+ESSG/AOVa2bs5tfoVBCpciSxDDZPp362f2CjXp+PZ4mCO015iePWfZ4eh/PpYNDgs5xO0EoGmWBiHyui00xZUBb8gF8CgjkXdWrvIHGfJqdMPw/D9t3or9cuqYNaOSHAuBPV6hFhfQuz8OIYWpLYDyFl/VfNjZlF3Tsp1X6kvfHXQUTVHGn4Kk8bYpXtDjQ9+rKqVLCeol8TbPS5gVxxIEnog37NVKne2Cmf1ICTlllXKmh4XvaVHPc/ros9N7Akt5jR1JOrFszue6m
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c52f15d-391a-43b7-1bab-08db825863a9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:14.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8QiWwxN8rfNBTe87SfMU8iU5D4MBDx9nAPDtNi096IkpMZwXM/fKW+lkiJzO1Xl77/kTddQuljX0Bp1KFKGT186XtIWfSZg/mNKkmqqlCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-GUID: SIhv6NCAEPyRRqyBi-AKOvUXziJ9H8nx
X-Proofpoint-ORIG-GUID: SIhv6NCAEPyRRqyBi-AKOvUXziJ9H8nx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.34.1

