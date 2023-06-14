Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75585EB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbjFNHWk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243316AbjFNHVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE6E2683
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jpRR021304;
        Wed, 14 Jun 2023 07:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=wMvrcw9irRTIb//WU9tPFA+BMczXZIa5kiEo4MY/48k=;
 b=THhZNOYqnAzIHllMu+d15RE4xkACwAMZeAABaW7iCJAGUjUNXoZhvEGxEDCCrXLUJrSc
 mHnOBagDkWBYV9RcNn62Mgk/WKmyV4COe5cLhWUrGrAkhsjgAysRkCXAPuxsqoV6GlJF
 TMWBhbPJBvMIWqzicmOo74Kf63DLVxqfjzMgOcij+TEz7mlH/zQ7fty1/zJGH6umB+u2
 C6NOMfwJcPSVGXL9ThW7VPv2n5g1UHviWJ4G431hxpSfSdwK4J171ryLUGG3hYfZ1i59
 2jwZeyXkeThsRYQHEmRnPecrJMHhUorX6bpx1NmHSXEYVvP9PoAhwv4Ov1/WM0+SS2Wv KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E72JBu021666;
        Wed, 14 Jun 2023 07:18:02 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56ch7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KljvfNyxuZiCzsxqrtFUQkQ9uPhrhTVZUym0ofzMCnJkUvDpf1lBDxj8P0X70vqtlbiU6x5aX7Dv2MC1Dq8QfQSyVxD+/nhIrnCyOMOnl+/Idd3i0vXMhI2wmAlNiP3jqKGj+kVms/27/W0f2SS2dZTeCpQSCf8Ls0ScksD9Eh/HGRwFkU5vZDSCfTHz6GuFI/AqOX0rV4tz/9pnlCXSFqsyAY2pr/jxzBCnImOplfc8QW/meHSaaccxDfWJCtEsEOo+NAvt7LfsNKtBGEyqJt0r9wo9PtR2DEjVwm1MUaBi7qc8Zi3Xp48Cxof1iZOZslLH9QIMO5ObbZ8Uz81xWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMvrcw9irRTIb//WU9tPFA+BMczXZIa5kiEo4MY/48k=;
 b=RO9XC0Fts5wlbB3Ot7rmZtm11xItBFB+DWIuKKBjN9tQZ+DbGrhTEFQwxIvH436KzsP1ZZh+iBuuBkcIm1NzU3vZsAMED/epH7cMgEk9WLHSjmk3HmB1MSI1aYd5D+y+fEBs95ijEZH0400rugS1zVuxvvm2+M0xem0hTiYGqJPIw0B/Zrv5q3xQBDKJxM4/mD+Z3+J1VT5krxeg2K5w/gXUIHtBsQkWP3xnaDuNg/H8sG8SuT2IoyK43t5x4gLWkcSGFPp4ByzFArQP/h1k1zJGd3K7hFxQ6SMbT04741wm6zFw1L1aCeof+y2mnNNXu6l7SmS8OpIQyG0pAJHfZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMvrcw9irRTIb//WU9tPFA+BMczXZIa5kiEo4MY/48k=;
 b=TXPitkBdO62Om4ZT/U9FFt8l48+NStJ3gGbkwPduAmhYLFyi/qikEvKbb3p72E7ERAt1NKvyqC3/uwkLii1vrchU06RHVYpkYjtXFUOTRljUbyd8zdJ6RNhLZeo83v9bLwtg2edMR8ONX4p3NCpOi/20GntmXXn2zeJjQjYOmyo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 22/33] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Wed, 14 Jun 2023 02:17:08 -0500
Message-Id: <20230614071719.6372-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 9537c47e-93c3-48f5-7839-08db6ca77c2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ME+M+hrLV2OBulBvL0xsIzjr13FWdp2/UnxUhDqRyCh/9+fmqzlNx1TEzBhp7q+O6exLYclt1P/32VIVybKeeE5mRixm0dxo8XB4/Q8Jsdf4RsMTVv41Y3b1P3naY5DgJWTalPnEN0dswMa5oCyif7UWPxKv3bf5+8H1Er12A4in3Kalr+b5qJWslWrZV+injgPkw/v5Hd6f8nJyWteOPAV031gmgYumZiZ6hdeDS863Z1e7l55lpk0CEpQbRl7e2RYQo7IzQqEdJagE6krjDDmuUb3+D5zYbeE0PhRsHuX1CPMZZeqiHG+btZvnlM1SGu6bionPnLEYhX1TUVQMjqNQEcZdIzXJss1Xm75bLphuxAWTtsRN4Djorri7BFiKJkhSJ9NHjpTUu/XJ0xueIEquM1GcScgMuoorwj6C+X+Vrb6XDB8ZASDSGTQbdhh1uOSgq6uZu6AUe3jKwoMBy9i06eAU207i+QmwIfKOb5IdWxlfasgjZT0nnrmHHhEXpmqSfd2LQ4XQ750AEOE8XLIyak/1PtP8ibKWJKp7x7Cu0SVj3Av2pOb81umVXP1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beHh7wCLWoqv2FOid/DTeEYx28/FSc/2Z/eckmFSJxxco9hBjvIZn6Qzs+7C?=
 =?us-ascii?Q?/UdTOfySMfTs75OhAvL+jrUzAO3TzjOY9yQEyXYkxDXlmODdx9qUf3Jf15Ik?=
 =?us-ascii?Q?Uty+mlxsmQ1/UNnWdpHklxnWeRoG/J6NhNb1/n0HnEubkOvgkbkzc2DZqUmv?=
 =?us-ascii?Q?mhJ7YEVzJD396DVrt4XqnjrSt45nwSgZTzfqQoBvybExb3ai7io1r6oIzoL4?=
 =?us-ascii?Q?SNk4SkJ6MVRgvVjv4sOg3l1qNxtnlfmt+aVWutSpMGQ2586qznO6vJbdv6fg?=
 =?us-ascii?Q?cCVNKR68uSffBeomUzo/Lx6H4o8t+aJB+OfWCvSTCAJkDbgprkqFKj7MxVxP?=
 =?us-ascii?Q?yNuB7dZ9WS/d0wAyJzjspEdFiVVlSBece0dNL9c2M+YXoBBW/u2f3eAODqRz?=
 =?us-ascii?Q?0sRX4gRx48JHvRFCP5J63RpzBrWhOOtmkHlMRdUlZJzNevsTUMAjKHiIrq3o?=
 =?us-ascii?Q?AvDXWkCMNEvrj1UpO6vfu5VNO8q2P4KOuB/xfMVWP5+svjQNv4AZMsSvOEAd?=
 =?us-ascii?Q?ttQP4Hd2Z2CxRDKqp7A7Mej6OmFuc7d9RGldj7gMZybOr1j0i94tR+NtJq/D?=
 =?us-ascii?Q?Sm/f8RaEBflNDbo5OAVCV6pJJDRBAWDKzPpTiKujoetgq8MnUXHG7PU1s8hP?=
 =?us-ascii?Q?xyIReLOafPQj9cNElqbOHZpCZ/FBBsjeN90EMDxQvNdWrIpQHUJEF/E8Tn/y?=
 =?us-ascii?Q?iMI+d+WaspkU3IzDHjUdL+1ZwISew1lbiFwqyg9fdPOs4ylUDl4X8g6T6hCl?=
 =?us-ascii?Q?6/FeIxYZqaRNvoq4qbHu7PVAfJI9M3IA8JQK7pgwB9+GNsS3mmJO7+xRSPcs?=
 =?us-ascii?Q?TUd9xtLcebmpQxJgrjTtc7QPgJZGe2PA5Cyz38qQDsfiPqqjBETQxu6Skscv?=
 =?us-ascii?Q?Dif0Z+L7qjRblzafqI8wBPr3pQKzDgE/Q4qlrii+1i1eyj1aDvXc5srxIUhw?=
 =?us-ascii?Q?dizu5OA9gA1rhqVsRYuwB8LPKjOSRQifSg+mh62rcEIYP6bLudJMUV94i29R?=
 =?us-ascii?Q?RLQfLiZl/FVenkv3gUnPh3GKkRAQwp5Fxi6wKEXeIDZLRpIVYBFCBdt6Qhp6?=
 =?us-ascii?Q?ZnJ2QPj/Ooa6VT43eKpFRLgtXwS4X4nR3ZSfZ3ww+Oc/XeYQZdPWjBefiFRU?=
 =?us-ascii?Q?X/2IrFxjbQQl/GO4Wu/wH9RXSkvCbf2ePJc6UBlSLyAUrGZ3UtizJPevVhrK?=
 =?us-ascii?Q?A7Mg/7pHT0sYWZ8Z0NgF7QzMmet5ilkOmtVOEkvrDXkz6cydCIMrmKBn8DzL?=
 =?us-ascii?Q?qkf87Mz5LdlJNKACt01GEWrBw8sSwxNtw9qPqP6YzarTWQFmkoAF0GgPLMTP?=
 =?us-ascii?Q?4+nR+J2ddiNW+CxfpO2lp8pU+bcY4boxtYN0wO+wm/AHrFI/am7EkRTLMTqD?=
 =?us-ascii?Q?Nv5xWo0SSqD0tBJKtispzy0iJ16IzrLqMcqmjZwDbpDkSuz9ZKQwAHXEmg+1?=
 =?us-ascii?Q?XKzLmIjn6W8m+ib98QErxB5Qa1vPYi+p6rBLVAtRYf6EJMj0DUHoIjtNx6JB?=
 =?us-ascii?Q?ITStOf/G9WDIgFqYXZ/xYVOGJ8J8WuRY1xQ+zD/JLW/hFB3W460hxga5PfzC?=
 =?us-ascii?Q?b3Z+Eq0SEPJwFFbkmmdFW+xkuk5kwA28o5GHUN8vwPtPl8vqHjxjyqcPZHbv?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: E+MM1Gh6bYspMBsgFWT1riKyOCV1cyqOOCW1SUOEturLhMdq1tyP1iC80pVRRMn7wwonpVu0vQ4ztl084m4KqOcJ1nVK59Gh7S0mcbkRD0M20QneQxk9gyf7z42r1ndwrw6NWjh4XLvjrhqlm8jopKI+ATjdW+6i0xqW/wqyXZggVKaYNyC9SDuIFIkcSwZwlnK5pX+dHUOI2tyJ4GPynpytd4S/RrTAldhoyMSeCBlcnJib6yG+Dc9ExbS7s/34HPkMkm5mdnl5zooCfDgCrZSWty1js/9SqWTz5aqU4tUE0YddP/d/nmj/v+o7fBRXK3RSkxlx2/LQQD6w84tPHsCE/IUqzkw85ah3FJawnl9vE8jZBsBNMYNTBRnEbXKh+4ap7GkigqdQzjbL2wPGb/x2djMkibyaSDINwcx/bR83P2UPMCglZr7UlAGV0nifYT8ebaSIjdEHQuvIfNLcSBSupWe+4L0y2JCnFmTKH2gd9gY5hyYOhFsrVQOv0zjZLLH0LYIfYMd3QQ77RKdZLBps2BaZ9Px4GJuztay+KUKIDcHYZYgDCRnmUiKSDTFoBjfwBgz2+zXwNg2QlApaFM1PYoz9SoViQMmlD71mvwqQ3MweJ0MEWuFnQZ7spJes9XFw484/i5IQ0UtRD5oO2H/1Tez9S0WGPJtREt64MC+mis1C0VjxmMORCR1iwjglpG5O1xpY54IJJg39VZghOQnSC5COOWuuweXDRF59bUkKPqZXQGOajNvEoeY6t83JpKx7RdNWKQjhigxbp01UkzSwHWPTQXs3baXTb8B7lVMMrscFOb5XoBnlSWxCwyJ76+r85tcXeviaful8is6gy19rZwZRZDXgyn4jRYunnyzRqvhgxHGwuudVTc0FB5Sr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9537c47e-93c3-48f5-7839-08db6ca77c2f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:00.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzeRf9gRgUGhR3V0k1y+Yc7REBjA6iFVtWswkNXdW5A2VVn0Dz0fnEjySEKPWEOeiaN1C3nVPeFZ0ov8PXvyMiqFN+4W8rDY3cyA+JYjWoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-GUID: QUUdMt0EWpEu9b_gQaVkFzoPbFsI5IZb
X-Proofpoint-ORIG-GUID: QUUdMt0EWpEu9b_gQaVkFzoPbFsI5IZb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only valid if scsi_execute_cmd
returns > 0. scsi_mode_sense converts non good status to -EIO, so this
has scsi_mode_sense callers check for -EIO before accessing the sshdr.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab0d6b1835be..48b727b2bf1d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2967,7 +2967,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -3015,7 +3015,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.25.1

