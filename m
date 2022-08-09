Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE68C25B08
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbiHIAFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244660AbiHIAF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:05:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132F2CE8;
        Mon,  8 Aug 2022 17:05:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwVuV028542;
        Tue, 9 Aug 2022 00:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=rcF+RP5XqM7VBMdB1jarXZu7SQIMF6K/XJREfnamanI=;
 b=GZhAlaEmgCapfX62kepLbokG3DNJH2m1p9tUt1AGhKMixF5Xy7c9THPOeyoAJACh5mMS
 QTLWx7x96s7RXD6TVpFD030RiKOcb47g9iJsdq33Ld8JyF+n7qSmG3jxr5U8kKg+kXxR
 Brnr/teDxbdwQvQCh3R8RwRSWMHQuLB0PG4Z3gFaWZrdApfzmPQQJUFJlpCH+D/CYGA/
 kw2SL2kGdRNfMSuzlxPTHWGDS57AjXF/Z9ynY0y/tJqGS4L09J/Y99N+yDfEocCwTjaW
 0+6taYHc7rlbzJwXjDMgobAwp/71ZLR6sZRfa43uxfZGNoHJ7l6xvYdrlb4sHze/3OeL Rw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hseqcn0mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0if4014103;
        Tue, 9 Aug 2022 00:04:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser8emhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8CwNdR/ffNcrQzeeeBglp73qzx6FBRMvFGcHYbHFhvomvcee2QIcxGXwLnLkvrn1AXKCVlTrmBYLnaq881XlFcebe8KQZds6+iu9wZ+Yn6NgGF/8AoSsbR1Wxy7fQ9MFF2GMb7XsD6WLJGuj1CuwvDoiKVmO5Z2SBtD0jvwD9kEV+6lfq6M7ZHcgGi9KJEyfXo3cy6gH3AnfXVaeaF34jXsIBQRaMcm78IpYueV01rWyGkZX0etvo/nRM2yIPv1O06BlLjLgGLjiPQugb+dWMuYSfdcUunq6BC0Kig5zPw2c6hDYgjygze9JuzgMugEmMXqJUidx4kzI0kDNv1yJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcF+RP5XqM7VBMdB1jarXZu7SQIMF6K/XJREfnamanI=;
 b=jd4P/i1t2ZrblpsiuOW6aKjsNsC8elC44PFhMEVFCnlo8c3iBLTZVA6wEcIc5l09lba+85U+zHyWpg64tEvSjP3QBVxldELRKIMYuiWNX7d7zVhNDWAvpQx578o1tlAg4VYkdvIGNXsXu+wndnBfAe1lbafpMaHJ3f6SftpGGuIqx4TsRrL6ePa9dTOwrInurnFHFND+2IK4OhqWQIwO7rfQlETyxFQOl5MNjvpEaLoNQnIyX8MaxdesyrgN6sUd7EanO1dQfh4T+c7gsM933cK4s4Dq1Zn7nBPFzBv7UjH7cP/3EXvf0x8vV2eVniT6KyFDPYMe5hf2rOn6H1eNeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcF+RP5XqM7VBMdB1jarXZu7SQIMF6K/XJREfnamanI=;
 b=vqmSdhNKW1On0VXDL1ZoFD31mGRHAQRleFxg5FZ+rLoNzqRiy/+mveK1djWkAks7ij/X1BGFxN5rExBJo7P86MeoyY8Jzc+t3WR1NQK+vJZCPwYvFCtDBcxRkJpGXIS5jcXjtMpRXMcrvESYdOYuK+dddyw+dhj1T63+wc/jhoY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 16/20] scsi: Have sd pr_ops return a blk_status_t
Date:   Mon,  8 Aug 2022 19:04:15 -0500
Message-Id: <20220809000419.10674-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:610:59::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e1c2df3-de6e-4612-dacd-08da799ac4af
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/1GW7KuDsLs7WeMwueB6JREcwwT73ev/U76Xy+0HO1xlzEuWuvXQw+Qje5TT5thxDrBgqQWvo1NU44jMoPSevWVdUaJCHmS2vZBVM74JNYs8i+Dt2Q6VKujD5CXODzvln2+IDUQeXu9iqam33dL8JBNoKh7v2Svpk/Xl12xF1Pme1cSZ+VVoX/2SgdmIBBP8hvZmrDq98VjZKRSFbzc/J9NUxbg627Nb/dER2HZ7/Xcf/8sZdLqNw/LBJuSAqBXkG8LsBGLUy72IsbU9Hj5+DiCmRrlhST23Y+aRuk6Z5bHwh3+R0YOS8bH6qPhZIUVYHCI60zrYlmRl2vSCFnCeL6zNWSDPHUBbeNZ+4x4tWJZ5A5tYl6YxK1wBtTxYePqaydHtLkYXL97KQvECObG0E5ASZn/4bWvMAeTnx3MizoylX85LGn2XeuhgGQR4BkescaTP6wM/n1P4Cg3qX7A7oCFDWJ6zvscs832eJXARligU3geNFV5UoVMZvRG2//pWnvdIXTXZc6JiIPETtPHDXuQhZMfJh19aj5/7ugm/e5A1O+VzZKSDxxP8p6LmfyMfjEv78IVv3OgX6x2mytaot7O5fqGOCFWMyk1LcV/veaa1VQ5gbIdkmFZLKwSIPgOV0Rg2NHS3Ev20Mm7FroghfglcmO4hLNfbaxJP8bMkQPi1Ca5M4P1XN2BqzTDDDwP6DmQN5ep7EY4yYcd7GxjOn0qwBpkRXpricTvPT44BYOGPu+zVVgoUdGLJapaPl588HxXi7JyHn2y/Sa990Ql0vx8X+K5cqSY+3j8KSY0JG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?scM1GqmpTc4LsYdtitXVJnVVUSZ2B1dsgIA31wBla5C7e4HaEfIm6bBRcPv+?=
 =?us-ascii?Q?aIKKhOII8KrmBM+d1eapeVdoZ5bQ5ZqWQ30NY/zwuLvaJYQa8htPgJStFN1H?=
 =?us-ascii?Q?F06eMgfbDhuRWlRFCD6B1ycxF/AsL7HCwXD3H+kjQoK67nYTZUrXwQraanVS?=
 =?us-ascii?Q?vdY6JwG3+TAG8Nn6YCk1VRTBqibc5CMoKcFNGgUSRkjFnq4XyA/QgdlbYcTJ?=
 =?us-ascii?Q?0P92qUxIZKLOvsHe3qSNZ3bU11aZOIoOFPqFSpm2K71joObv1wEY2I9b6afv?=
 =?us-ascii?Q?H2eN1eMWngvaaLzqY/QbVfqycuXdrX67FaS5dUvh92BAfIAPS4UWOWyJ/2VA?=
 =?us-ascii?Q?ud7u4StB02SavKqjHVIj35MRPN36ZSzFNerPPHdESejwa84CnL7t/B00J76X?=
 =?us-ascii?Q?0NGvsNA7RgIED5SLkpU9oiYs9TBTsAoHQuxdBLks/oqWNkZ/7Bn7qglkzj2N?=
 =?us-ascii?Q?k8AFVvm2qgHaxDeHfKcjK7Upm7rJNhvSWDxMa/a19FlKxRkscs5UT/KetNSA?=
 =?us-ascii?Q?wdJWka4GSQzkVfedrz2uLQ16p8JpJ2Uv+b3Ozcuuj5ZPlXEKX3J7GwlDHj7J?=
 =?us-ascii?Q?X6eMSna/gSinJ6b1Tcqx1nnHEk8C4q7Vdhtbzz0y+Fy7LY2coyePMr5L0Dzr?=
 =?us-ascii?Q?yjsfZnOtue+lroNfwRzqVnw9tWSFslAa7cbfqyGaeOokKQHJkpBixGYY8eJr?=
 =?us-ascii?Q?ZUYMbv3l7ctLgY47Ut+jPLE0wRFE2Uoe97Uo3+UEkkv9ORWZ5j91s1tpqjOD?=
 =?us-ascii?Q?xJs12tAVt4dEckQhUnIVLS03JAx+tmOmIGTrFXHAA9jcbFQpyx6sfqYv0BGh?=
 =?us-ascii?Q?rjK8bR5PPcEcxo+4dAhYEXkR+pyLbAVhxJYQ3m7XvfCuZVglUfS0KtTBbvcB?=
 =?us-ascii?Q?DRCy96QAfHmCqIM7U7/ZOmmGMgbHZ1hF7ZF9d+iqyXcXzVcs2LOVvzZ1hcin?=
 =?us-ascii?Q?tRhFrHjuc6EXM8jXmBvTUt9klF7XV6aIsf5HgfS8dew8jEyDpQkxv9Sg3vt1?=
 =?us-ascii?Q?uDfE0m7B3CgYFVMQkc7diVB11ZVuumV4lrkaa3bImttMohKH4FF/JXXVIysc?=
 =?us-ascii?Q?tiU8cXjlZI4Gs4kZoNXO8j5C7PaLyhcFj0IP5xYz4oQARGmvz1oSB1TL8BJU?=
 =?us-ascii?Q?RcaF8a35WNCfmzCIKdCpEro7M6me7b4ms+eSFSY+ld9hiIpJDqlqEQvadYt0?=
 =?us-ascii?Q?QNE3pzObA8BV2Qrjx7QggvPZiCYmvCdoYSybViiRDrjd8yClDRQR61aZFc2k?=
 =?us-ascii?Q?hPLvevvgTuqTEouI99UH6FcvyTwL1B+5l7/bMaDMOiqvic+tNe7toKALQrOl?=
 =?us-ascii?Q?mvBwZ/3TFxZXclvJjzzkPk77mdCJruVj6a+mHixyzzbtppnma9TM5WiRSgR6?=
 =?us-ascii?Q?s5H5WTVdCEtU56u5kFK6ZBEVtSZLmfkVi28/D8eusmlDS1JmZzcDd26dpNO9?=
 =?us-ascii?Q?2m4Wa4m3wlFhRPjxaA3p9MRnCGIgDkpnuAFLoqr8ToEF5BoR+lga3k+KIbU2?=
 =?us-ascii?Q?ykcK8BkwuJQVNkOHIdANSDg7+g6cWr6d4exqVnfH7wd1GGZVLPQgnR4FysEM?=
 =?us-ascii?Q?aJkx6ZbIpbKtEnkWc6ChisOnU4dsxbLUDzASwJpjy92ybPoPdAKgTUR1S5km?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1c2df3-de6e-4612-dacd-08da799ac4af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:45.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkcRt3rUE67iHYvlYrJUs66CyfeG8H96Q6GBzQ62cIoLEY55hX/k+Jy9rjIdhOt4uM4Fu2vOKTcvQzN+R9UC3YQfc3GMGcjDkOo5OFVDAo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: OT81z6P8j08-tVbkdrnIe3ptuUH7nlob
X-Proofpoint-GUID: OT81z6P8j08-tVbkdrnIe3ptuUH7nlob
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the sd pr_ops convert from the low level SCSI errors to a
blk_status_t.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 61e88c7ffa44..31b4eafadc44 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1686,7 +1686,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 #define SCSI_PR_UA_RETRIES 5
 
 static int sd_pr_in_command(struct block_device *bdev, u8 sa,
-			    unsigned char *data, int data_len)
+			    unsigned char *data, int data_len,
+			    blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1710,6 +1711,9 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1724,7 +1728,7 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
 	if (!data)
 		return -ENOMEM;
 
-	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len, blk_stat);
 	if (result)
 		goto free_data;
 
@@ -1753,7 +1757,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	u8 data[24] = { 0, };
 	int result, len;
 
-	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data),
+				  blk_stat);
 	if (result)
 		return result;
 
@@ -1777,7 +1782,7 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 }
 
 static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
-		u64 sa_key, u8 type, u8 flags)
+		u64 sa_key, u8 type, u8 flags, blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1808,6 +1813,9 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
+	if (blk_stat && result >= 0)
+		*blk_stat = scsi_result_to_blk_status(result);
+
 	return result;
 }
 
@@ -1818,7 +1826,8 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		return -EOPNOTSUPP;
 	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
-			(1 << 0) /* APTPL */);
+			(1 << 0) /* APTPL */,
+			blk_stat);
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
@@ -1827,27 +1836,27 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
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
2.18.2

