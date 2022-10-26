Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9980FA3744
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiJZXZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiJZXYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB9B12D25;
        Wed, 26 Oct 2022 16:22:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM4n90014902;
        Wed, 26 Oct 2022 23:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lwxJjspookBRDQ+6qgBtiy3Ib1EVtq5L68TekynWJAY=;
 b=0rxInKBe4rrJn7zYG1TFvlNLAeFDZCn85FLZp2mMYaBUg0vRwV8NcxLFyQcT9pK36i/M
 rDZag3BXCp9lQc2VF7GH2hG0YScZBEhaHySPsJVoS5cgsA/X1kyEqKDlBsYIZjfxjBGM
 Pl0cPZJRxfySkoiEF3oUMJiYD2udQhexx6JI+M39XhpRBfD6xEIo02uoGcWEqETfYkvk
 go20L36+nOh9ISe/n2DRiSn2kGhNWdpCXveKl0co5lSSK981C8zdGvnGt2oL9h7TDjwg
 UzG3FcfiBvnEHYCurkX72A6yrjvcDOoLnY6gsYITUlUcDUNJU/TEn5zWWyFCrGwTjd5o 0w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLkbbM006786;
        Wed, 26 Oct 2022 23:20:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrr0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZIispEE0AP8OIuKrQmtTWC4ODKeXAgYmUalDRbhe5Wum0Ry6lhcu4UowxWjG0RK+fDVwgYWKL9ZjDewHyxdSqFIss6fAlA4jakiJRpO/0g8HIVWGLnih6Jf93TTapgJB8Scldf9v5ym9a6qQRKR4P/YBoT0K0o/aIE6lfgI6fljiMF5r5VWYftIl3fHa1vVz6zYxcA+O+Cs/7GWOmrdMjZrCcrdwIvRyCdh2IFOwQbe6A1n7tLtSR6/kfxfEa9WD6ATDzISODEkY5QMfqUB0PCyNv6DrDIy5mob9nkVIaYcvnDqmQG6wyCVzQaTD9hcZCl85rOSvYgVWMIMgIqqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lwxJjspookBRDQ+6qgBtiy3Ib1EVtq5L68TekynWJAY=;
 b=d8amXyBomKtlrh8j6Uv0bc7DREJ8axpBIZy8/Px8CYHkIZmGIm81N3/M8b2Qf/WbPdE3Sm5esXqY2EcQnIsZ96CIsUEVqaZHLJcRG5BZIEOkLXHXWaA8m/YjN45bLPzSlzU2OZmdmsU1lV5707Fp21E777t8L6cZ9CpEhxrldyI9Z4uXF5ahpayRlzpjxEXhJOTv8cEoWiZz/TQfo6ynQ9+5YebZPGFkYg57CHNOMtNn+NB+FvMzNUh17PfC8VQHM7er1z4hklOjHMe+GveDw1IW4y9DoqxrB5YB2g8YldfLKhwgu427JHVc6miWj7haMxUdYZsZmFoIKBg89lPkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwxJjspookBRDQ+6qgBtiy3Ib1EVtq5L68TekynWJAY=;
 b=sVGy0BNjXlzGHqI5x+HaUHdzPdHfsCV/FUgpYiHMRBQCqHb+Emr+3WMq2gDqNucmVAgPr9LT2mxO8S3hkA6Y5jitpNavPRyO2rBjfp5QixYZ0BaGG7gLbGw9qMGtyBBo8fGV7ewnJh30OoSEvjkyOYGa1J2hGU30dR7asleIqV0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 15/19] scsi: Have sd pr_ops return a blk_status_t
Date:   Wed, 26 Oct 2022 18:19:41 -0500
Message-Id: <20221026231945.6609-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:610:4d::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 62feba7b-ee7a-404f-f4bf-08dab7a8a0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgSfj75cxWukZaSz8fvI6LNRWj6MmmFNFIb/7SBkaVAVKFUSpuE6LHPHSxpKHmwrWn/FQqS9mj92svoS3aWKeOHYB2IVQ/A4JbBNG6YV1Fja8o3y35r6cyr/2guenRMMia0ecvo2S+W9AsyKPvk7eEeJ+LOosyTUY3fkY/Pl97TaHZy9mVYEMu2598+9gDgb5k3vmHcXF55UxkbE+xFOw3rbIfO81PMnErhvKFkC6aktgvqsNy3OCacAX99z4kux9JO+2zPd3zD+FOwz48Qe9RZ9sJ82UZudUY3t5Bjr0xiAGdcUWLkQwnELmEmgKZsovA0lLSU4IzQfVCQkz+V3xnwZQfomByvslM3tNBtQ1zupSQY1q9zK2TFv2OPt0pfHTL+Bk6DHmIEfqFZugo9nXuNO18BbVLzxKYObRtthNRcSzetHM5w/hRDjRLH+42d1IGl8ocFYkYB1WUnY5mJrKab0aKhWMg5FTL0wpO66T7QCKqqIsj3+Nd/HF4arNbC7ZsPgTicCCfe8APf6u8fTS3jvAiIEFHmJkSdl5VCFFhBc9kq41DvDYqXcnyoAnjwhm9Z8aOXYnavntvht+0/BGb4gHr+cyJ42Z3SL33n1t5aiUQJXj/icZZLUN792XjaUvcPuflRqcidw/YoH3QHcYrr6AGig9mQRRjrS9rNtgRHuzcuZlBILt7c3vE+MJwoR151sFJPKa9rJtjTkmKcVI7wVUp1c+qCNs362l8XWxfTiPadKn54oc2AUuOhx8TDl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vRPKbG0XkAKAHTtK7WESs3MuAhZzQUzZPM/9u2/n4lIZUr5rpLZB790lcMRe?=
 =?us-ascii?Q?dSwaOZ094DrHsq8B635LhdLZ5VfmHASKMDBqRywwyqsL9YsDCVcdGAKGNk3q?=
 =?us-ascii?Q?kyFn8we4wWb+QylK1rSeiDHzhQHna4TlFrrLQv8pH+57PlfqjrQ5yU4gYupD?=
 =?us-ascii?Q?8bWn48m2YxwghtVfyjV61wDYBPc5uuMl+YmLeBC+GqtxPU/CZqiPptwsJHqj?=
 =?us-ascii?Q?adx8CgYDtXwLIOwB4xBhPAh/O4lFrCO9GtjE0LAfPsdSRNEPcO8veZCnHnI+?=
 =?us-ascii?Q?ReZuF4sLGGqcnPWeArAFlyHpiNZBAQl04feF9Dbkihu4xOU1MsqFHF7DFNIX?=
 =?us-ascii?Q?9cEQkJwwqiWcLl1eIAU25xznYQ/GlNhAz+3QKg83UneS+rHJoghClO+4wmK+?=
 =?us-ascii?Q?cF+4skitghUVXA4PNKb03Ifc5UfzTn7iHZJePKuu5q6HU2aqLzAOPKuWmDZC?=
 =?us-ascii?Q?XASw2gu6V3KQtCnRlPvm6BQKI9RBQRyryMSG9eARej5aMzBw7hO9oBu7/6az?=
 =?us-ascii?Q?xMBiBz11KUysANV5h+4YWxH8WXl1N031pHNP8QyTewQhE5mnwQ7s8em/UaEe?=
 =?us-ascii?Q?cDazsiPgskcE8/su4wGiau7fFoby9LDYRvDIyLt2EEAG4jdPQAwvTUcnOHsz?=
 =?us-ascii?Q?mwwGPgNVlMJeXRlH+3+qdQbqriOeFSaaz14xLMZY85wxXTL6L0DMik12Op1r?=
 =?us-ascii?Q?S+NOHmRaafoFgUiB4zxqEoQd77/7TAJXtIRWUdk9STRYQETZjnXkTzwGd2fg?=
 =?us-ascii?Q?esbSWhVEweG+RnAIU9K6AOqIO8J1pZ7DsIPxDv3P8nOdWdYMAscXl8lujLUQ?=
 =?us-ascii?Q?SCdQBTiEog1TNQWTWiMIf11XOE+n6r6HTR3ewmMkUFvMcWWwQinwFpEwXj95?=
 =?us-ascii?Q?p1QpJGRFJvQfBHfXDsToYalq347lxNDkQvDPWBwOT8mF4c/atOGhAag2bgG3?=
 =?us-ascii?Q?3phN5gPLW542gONzXS6LsFioJihEfXpe44ydhi9IsAu3Dtk9/kdUI/dAg732?=
 =?us-ascii?Q?bGIKtsy5A9dSVhqXPOV6G0yM2+SyZYpOxO7NTGErqKmITH/72efKOzhQSDc0?=
 =?us-ascii?Q?ZerSr1uoOpbHqhHrJBwnKgi2thwIf5CQxwY+S+FwbNdFOft8nZHb1PJXfH9C?=
 =?us-ascii?Q?QatXTMjqIfFvcDyR5lrDR2NQXmA3s5n0q0HJVW75ml5SLwoyKTWU7x3vazgk?=
 =?us-ascii?Q?1C5/Q+tQJdCc2JyT58OwuwCDHySXhr/0gD8c5EyTWIsRTp38qUV4K0MWBDhz?=
 =?us-ascii?Q?qk8kAgtNMaXvZS8yCBk4UUQ7n8V5BhCUUU2r6o3IYKNActRzbEpEDRvX9MEv?=
 =?us-ascii?Q?5Qh0pPgUr/cJrflDOu1oMD20lKvwNq4nXdjL9DPozrp7WE8NAuKxmkR2sbsx?=
 =?us-ascii?Q?qEiJgw7QpoMy+KHSxyspv+R7Y1sWgw9f5wkbgKX1IhMK/u3jq5VfkmEN4bkN?=
 =?us-ascii?Q?+u0owXSRXqJemuajLmtTkoe8+GqOOOpDhTqJu1dQ9s6ME34H4O9nYamnNbUI?=
 =?us-ascii?Q?kw5V0zrVeLCK4cicFx2nKNmH4DtazMO7oFmCYCTBxKuZWEwQ/itfpRrfm6/r?=
 =?us-ascii?Q?NAU78cghoAV0NtMGXeLi7/wb7yQwQPm64T4xKxgVu/6/7aSCX6wrW+VkTjVE?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62feba7b-ee7a-404f-f4bf-08dab7a8a0a5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:10.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VS2gz7mKvBk6MDjbfqtgmx6Z8C+P+KVFEjHjnnWtpt2dnN9PWWWeDb476JSI8r6UpwU0O6hWMbXgHfaur8Bsqiukn21ZnOvkXyQFFo5H+3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 34PsbxSuCgEPiYoxgOqvXkPTi4Ue2jlk
X-Proofpoint-ORIG-GUID: 34PsbxSuCgEPiYoxgOqvXkPTi4Ue2jlk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a register or reserve hit a reservation conflict upper layers like LIO
need to pass that error to the initiator. To do this it has to know the
device/driver type so it can convert the return code because that's
currently a device/driver specific value. Instead of having the upper
layers figure out the device/driver type and call a driver specific
conversion function this has SCSI do the conversion and return a
blk_status_t which the upper layer knows how to handle. This will handle
the reservation conflict and in the future we can handle timeouts,
transport errors and sense errors if needed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8a39f25e4470..44d25194ff4e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1696,7 +1696,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 }
 
 static int sd_pr_in_command(struct block_device *bdev, u8 sa,
-			    unsigned char *data, int data_len)
+			    unsigned char *data, int data_len,
+			    blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1732,6 +1733,9 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1746,7 +1750,7 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
 	if (!data)
 		return -ENOMEM;
 
-	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len, blk_stat);
 	if (result)
 		goto free_data;
 
@@ -1775,7 +1779,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	u8 data[24] = { 0, };
 	int result, len;
 
-	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data),
+				  blk_stat);
 	if (result)
 		return result;
 
@@ -1799,7 +1804,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 }
 
 static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
-		u64 sa_key, enum scsi_pr_type type, u8 flags)
+		u64 sa_key, enum scsi_pr_type type, u8 flags,
+		blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1844,6 +1850,9 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1854,7 +1863,8 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
-			(1 << 0) /* APTPL */);
+			(1 << 0) /* APTPL */,
+			blk_stat);
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
@@ -1863,27 +1873,27 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 	if (flags)
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, 0x01, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
 		blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, 0x02, key, 0,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-				 block_pr_type_to_scsi(type), 0);
+				 block_pr_type_to_scsi(type), 0, blk_stat);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key,
 		blk_status_t *blk_stat)
 {
-	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0, blk_stat);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.25.1

