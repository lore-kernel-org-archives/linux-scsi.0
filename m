Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAF2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiJZXXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiJZXWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:22:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034A1DFC07;
        Wed, 26 Oct 2022 16:20:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMJdIH028928;
        Wed, 26 Oct 2022 23:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mZiCbYYj3BwR5jRhby1HS5WNLmwAPVuKuDiKaP7Bi48=;
 b=lyP56I98F9T5y/LiyAIwoFsqWoVtp2Nv+z017V49nXt7ETmGWMAYXIFMSimNU3IW7Tmz
 AtR3fkEzeRRUykLNsLbxqM/e2ijb4S2cqygkdRz8e2KnLnqbkRZ1yI9yNP8ZvTJqgEUy
 1J6MY8A8hmNRQxpKaVJVqJtIPWeeneHyTFay/i7/x38Xr/9ezzGZg1eF6n8WTSDx+X6l
 eps+kWsaXIU2ucpWX2bei1CDF7C6IzkGiwq/Wb/2829Dvsbk5Oki6AK8IxDdbYYom9NP
 Mo3EZdmqQiXSlM5qW0NVRQ76Hh1VSRzV/VQ++Yr7zsdpXLnu5hQfYaOwYqxZ4KO1BcoL iA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfawrrhf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM2B76011647;
        Wed, 26 Oct 2022 23:19:58 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagqduvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbOYH8tNHD8H5LN0DJmL0f+lWM8m2O/QTihWNvP/vP+2wjLxd3u8+yCjlV8Qy2+vFZNAlRy4vdh6X2NpOb9v2y4WOyDr/7hfwt4w2gLjRbBm5RQJIbn2qyyfq35mpoBi0ld4ToWUT3fv7GhhY5pgungSRQ37imC/TATUqhfRHs618n/gWw2i83gtr+W6f3flKhy43IE/ZSUYcnTv7llvbSJPnIJpEwq9FzkePNv7pkeRL9NYQWu4CjhpgSE7Rb6n8DD4eK/NNeRtntYxLy0/Q0h/rOvPWELOwPNLRnxp9EY53zI7a7zzIXnL8ORr5llQIbCEXWxQke87k2M2YO9TFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZiCbYYj3BwR5jRhby1HS5WNLmwAPVuKuDiKaP7Bi48=;
 b=JreLUYFFdkYVbKjrEI+VeLD6qnqPGZYypAGpOTYz6QpR4am530FHp45Scv6C5Qvxn/PN0FifnVLVJI94k1ZqmMITuhjz8I2OH8/NGhlgYwqD2Kv7yxltShlfIVJGg94l9im03obVrAQ9Qxv2FMW6ArI5EKKFgeqlc25LOLsRYlB45w2HASF6/IxVGjPWyeAnyvQhGHQT3eT01O/dfScyy1jQOLAphBGdIYwXYagX7pvVlhBxRDASMnCTe2398mBZxg/KRwf1i7slUUfgll2xkU8uywvsHZ9Ju33/mPFf2VaAjrF6Gum/tVFWLZpjB+4jfFkb+bs10jq1YCizonWi1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZiCbYYj3BwR5jRhby1HS5WNLmwAPVuKuDiKaP7Bi48=;
 b=WVr/QE0dlV4al5Ki73x8E+zXOUsoYQDFknMq+uQfMJ8Co3mBNtaQC4UhKkUVXi+txfZfNrD+vbedNcUu/opkpq89UglQh56m8cVBc4e8kPYVRPgzjXYscNEH8q6LhHknmWNdZ5p1FZCs0mNjiGS/rLYWUkZn0yltaJXbljZsqZk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 05/19] dm: Add support for block PR read keys/reservation
Date:   Wed, 26 Oct 2022 18:19:31 -0500
Message-Id: <20221026231945.6609-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:610:4d::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7b2544-e442-4512-d4f4-08dab7a8981b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IDBBhJrITv9lPB9kkUe8saGSkznGuh+IKsqWqa2QwFZku4a+UK8cp/gYCDkKfexzTxEdbSzC0EpmJzc4LwJYpNDGwz4QwGmMGQG5F10GjSJlw4X7C/kG3CYnxrRT6Ias05YU5wHFZBumgto1/qV67Ii5fNZJFT/e3gKMuXxruNDP3WLNtdkaaOevDq68lkQQKpsE7UNqePyqKERZoXvoCZlB7Re1x+Rg7uPI/lXXtobzRduhwPs/AxMCCpZv5pD0U345ANIbX6h37QIwrnjVouKOnixbGOsmktK49WoD+oZTSNUAiRdoGPiTrq28NqOFTgdD6P0uY+XOkHGVbn943el9TKqOb48gU3EcXF0LD4l64jTN+l8Bv0iG9g2hzSnOHtMJb1rfdoXAGkgWCYdrAlWATqbjl2fPLs7CpycQJ+sjJMbTxHywg1RLwt9Q/7gyHeVVOdYc/hnCwcSBTqaXfxcZ4qF4f+zPUKxOpAVyB49tqqOtf1NGkAr7GXfWwaeAfc808jsQFTh/mRRJwsckx/MvK+0/XSr+AR8ICXREy6ykNrgEMig1ImTRq+P7mmVR94TfkUCxPNZ/E3RVLYs7T3N/JlpLg1i2vNDCS+QvB1Xg1lyzMh4SFRpRJgAemiSaEDVbtGqZ7PYpyzPbab7GROlsd/KiI8bhlh0Rn6pWouku3PDr8CsX31Ss4Omq276rlWtF5Mt9FQ5ALtJOQx+c68KIULOCLIGv/yjS8/9ye19j6OAeQgaaSodq3kH614+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XnaxGl7WpN5nsbSJnrJQ3wFql+/EuUNs9DSKZbduSj260ongWVQl5rVlYW6N?=
 =?us-ascii?Q?r7Apt4uSoMmE8Xtq2MQW7ujqnjok3W+yc0YZsPlTdExJJWTuJpo4XS3Qzk2L?=
 =?us-ascii?Q?TssM3esEqDXF9DnUWInNkkHceJgnSkvMNt6Gy/D/iAwN4UZX62KawukIeB01?=
 =?us-ascii?Q?b2rA4f/15YpKsAgSBstVsCwU0w8BWmfnHHPY5l7x6lUa/F7p7QXFg4jijFxr?=
 =?us-ascii?Q?kuuH6FiFDUVHD4IKG7RF3EJclwJS0mYPQWUdzNG4ZvizdjKADx9KhY/KmMXD?=
 =?us-ascii?Q?sctqiY4+IwNhqMe9DyYXz7FGXNbbcbRylBrq24U8Z8oASsiHnjT+e15vHyo3?=
 =?us-ascii?Q?iAIEBiQF6hyT5QIiHcv4Rxoq+lCSNtb5Eqxp5GwCqvUH8HAcAcHmnBBUpG2N?=
 =?us-ascii?Q?+eFkZqt1RkgaH/LdDqCxuOaX9SHT2hvP1DyMYuR3AiOMdfcfLnuK/QTr7hIH?=
 =?us-ascii?Q?SgiboqKcC5TNBKPJxsY18N0bWn/HjAylbWQicKIyvLllZ00JW13AwWz7Gks2?=
 =?us-ascii?Q?VE1wCjfHjyZGdZ80zN86ZJyEeIFRBELJuZuQUftiMUYC+jy/gCCu+X7OzTuy?=
 =?us-ascii?Q?ghORQiikPIc8dbH5vFW2I/X2Pd2k9Ew55MmUFQgTHZxLYrgEoSpcfqVwC0Wr?=
 =?us-ascii?Q?azgJ9DbxWO4AoffYU+9zBPIpS1qGl+4lIW95m6Db0Ht5asyLhclphiqqdSbr?=
 =?us-ascii?Q?OYwYbci4W6geacP2JBlmNKAa/j6E0fgGQzXJdt2Knl+E44jROC+Suihc9x//?=
 =?us-ascii?Q?ja9BaBZ2VlGFUM3oJcHqJKiiXkdO/Glm6qG4K+osiaCnIWXY9+Q62opaOGLZ?=
 =?us-ascii?Q?PCWVZs12KOAx0zljT++qnb6i5U7/njrLExOkuV/1miIMvext2j43eEeMLJtO?=
 =?us-ascii?Q?/IzK6hUVIsygUDfKdXzKx11/4mdafiPy6H18LPp6HwIpxLUmyDQHeV6KCGZw?=
 =?us-ascii?Q?l0x+yECu6efwGAalNCO7+E8lxGTAxmJGNKBD4jiBIrLW8e1NymbxJJ0Gg0YX?=
 =?us-ascii?Q?qD5/5GBbyBtcWJGvJgF9Nn6k7ApfQtQ3YdCn8iHEgIHP1oRdXfDdd0kRq8mc?=
 =?us-ascii?Q?o8xks9dXEDE5kY5mUjsqT2gyRveesiZobWjSeAvdBtnz0uyIrzEpgkN4iUlz?=
 =?us-ascii?Q?hXJXFgUXYX2fam+ApoXOVorj8SNI66Men8JglGqL4F8EgDaIvRoDTDFewYtW?=
 =?us-ascii?Q?2H3qGN+dmH0ZwHz7OzdfKyFby5oNELeZ0gNzbZ99aM0a3Rzprr1IfQOEHAZ5?=
 =?us-ascii?Q?q+aQq9KNEnYO1yqyyT0RZH+upMmdN/t1tKh+KxERXr88jndlAKcUJMRW0rLu?=
 =?us-ascii?Q?C54guFmjZdshJiiPdsuN/c1SO8G8HPeY1/EQdP0VMEzeswYzMvdVPc/7yBOy?=
 =?us-ascii?Q?+SHGcuBJKKjXYVJqbHH4kbpnS5At8DCh3Ah2CReGS8KaOSsXnepfuZhYCqAj?=
 =?us-ascii?Q?R4rHl3A4/E/a5fJQdkkuxx37BogTFywCXkRIH0AWp3GBRB/y7BX0cI7U1Sn0?=
 =?us-ascii?Q?g1IUM8BqQZOaF9Rv2zP2g+DFIQ/fjYBgYXEsgVKNi4P4LDJel5z5kpZlERfi?=
 =?us-ascii?Q?tAB4rBXQfN9oQu1jr7ByEdIDjIekfuDm+7kv3HUuo6NMy5aFlsFzA/sSRC45?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7b2544-e442-4512-d4f4-08dab7a8981b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:56.2414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bjljV5aOXU7+8NSto4aj6DW/r+CSX+zeZZ/8rMoWRt7Tk7iyIbphq/KyOpO1yggMLU4ecc+3Rn1XEX9ywD0/eJAett1h8lLrFrthAlBvM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: A5dr16pZMHuDjGRcmnUhPUTMOdu339_b
X-Proofpoint-GUID: A5dr16pZMHuDjGRcmnUhPUTMOdu339_b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 95a1ee3d314e..f7f806890c92 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3312,12 +3312,56 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
+			   u32 keys_len)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_keys)
+		r = ops->pr_read_keys(bdev, keys, keys_len);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_reservation)
+		r = ops->pr_read_reservation(bdev, rsv);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

