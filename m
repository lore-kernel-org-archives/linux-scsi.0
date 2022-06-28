Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA407CCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiF1UNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiF1ULz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:11:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3E2D56;
        Tue, 28 Jun 2022 13:03:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBcSa006374;
        Tue, 28 Jun 2022 20:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6782uCgRws/oZZR0w+xgF2N9igQAqYZ3Y9IlxYvShjw=;
 b=CLYhCDoFeUkuYOWwM9itUHVuudaaJ+LjlI7WOAqlgyrQxGbRUiM6ChDFmhSZW0LiKod3
 PAyRmJIF3vjcXiLZdbAySthIRp2jPwfIO0okey6gYkDxqmplOY5CnyaNdXrj1r+G+VpX
 BQWSKoXX0LhToZINa9bIJ17Sp1sGeSDo5rEz+UDRL0j1bP87xNSWBxeLhMPOEN2+aJRL
 kbsM2xiLgJuBzSxdjKycXChbfohexysCAUqFG87cCjnD50SNGH/vZO6mHpjhT2KcAoJn
 X60e/fMOtDjsYnZ7sos18aROFdCMUY9Jd49ZWkUdjJt4641vRo6Cp1E8Jjfzdgjx8Wit CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52f6n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJt5vJ033186;
        Tue, 28 Jun 2022 20:02:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt88b0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhXE14oih5J143lVUgtDUm0gSSfZitB3vSz14ZdC9mmlbyhNnLgvLXtfjdga58wAqW0pnz+LKFKVbMRzwBui6uVH8E0lIrXkt9yLhhsQzBMrD/G1z+YlMHOE0M1I7uRjF8v4M1uWqQPWlnQ4raxlWRVBxZ1MWKpPAeRQtleXWCc8N0oLkDuTDwigfPb0Lda/V7Y5dbymfzKaICeyzxvffJ13cDORoKo9krkIuQZM3WvhBVz0mZRhTEwsKTNoZpDuEVbpynGvw58GkeSohteApX+qzuGsUbkt+wvJOJwWoDIRa4hfCbTrsW1V20ae9RjJBegh76SREWMUCCYiNhtDCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6782uCgRws/oZZR0w+xgF2N9igQAqYZ3Y9IlxYvShjw=;
 b=IS+9zO7caQLFABCjHJwwmCrw9ZaedU/kBUh8pHjg08cATYV/X0rT6xYf6k6f83ZfSRKvAn7AHVNUPVUp9PG9E6ThyKj/EvaGgngDTBdUt2ifbNIk5MPjVf1Y5NmKNNGI6Qr1bQxqvB8H4kv36IBdx/LSkeRcAyoWawRLFIp7WEvCeWBIaOkQMCXzu0g+buitlFWe9ACvtY3SyXS3B71Q+dnG60wJOeCxSdgeIv7816gbQ+BUOV1aoJ9jH04FQNsSV8uPbYasEGaqRDmPT+IW0YMzZrMPtUeQhWyhuu8i/agJ7ryxAz7FuQ8sfRTb5pR/eAzfEJdeqzuKm0VYft8WKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6782uCgRws/oZZR0w+xgF2N9igQAqYZ3Y9IlxYvShjw=;
 b=X77lmIaZ8ADgc4VYOf/5RBsg02ORjYYKRIo9eMMP77+9Fcu5TuYpxs6ypynHpYD1YBNPNSjEOF+MV1WV3d6A8wvumVO5wwCVJguW3uu1QNXq7Z6A5I0xMhQJQ5+OEkjvhDmrcsrDeXSDfobW17Ge3pTlrlMohUwz/u0Bi14Baw4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 3/5] scsi: target: Add iblock configure_unmap callout
Date:   Tue, 28 Jun 2022 15:02:28 -0500
Message-Id: <20220628200230.15052-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f35a96-7b64-466e-9580-08da594127ad
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHUw34vpyTkzkTkm/D17aowCuLBysNyFBHhwXYgxR92nuXP2U13bSdQc8W/ILK20ZCjvW2Nyq0yBLHlm8nhDyLgupSIY/+W+UYBox9O9GGMpsxAEYISo6H6JHMvg0xBovMP9XaiTQhqDoKrpx/8L092SHOCfLNzYT726L4TaJgt4PUKp0KEuFGp0O9Z7cnAMPr0XwN30Xq/CBTFzPxtwjyrDJMLI30BlTloPhfmUrC/Xo0ASiLYiRq8lSamP/Xt1k9WUSSgiYrc35/FqnszUsJVVFYGDtwvi+v+IzBvry6SmmaZZ/AKYLQfhJ19FuIAYMpnOedJAz9Gro7qt9kMbfDR4h727PHjVX6KSezEDNT4976oLBxv/UPBKTsDUoF9zQRaFe+czRwuncfxK48ZAVHhTIMNMiLYud9Uu2b4oS4cVD8eq/0PdkhMvmDCLIoU9Ba03EpmPKgln5Q2ENLKtlVXjTqBrKUg6jaup4WU3WCWQvV8I+xOkpjXtn3GF0JK9qZ3AmIvTtX262bT8Zgc7xA3GroNzdJjDPuYp80WisWrmP7zIgDfF/fWErhmObTnRYUnXa4pyp7rx22XG286+MMFwGR3TnELDvBhdQXh/bI+9SPyxTRJyi63MA4meqnsCHBKqPm8GSaoCN/2TpvtwdKIaLpPxnA9J/LJUzGO8qFNOyE/7kREPSwOlPP518smKYKcFs+1fJiUSx6ptN9CZnalfhgUE4fmihSQ3dxOA9R62iVw/c1x04PUzyaRtHa5suBuKfYmDVEAF1CmT6TGEXwPy1Y/Hy/7ecvNq7mvUpF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(83380400001)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(54906003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4326008)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vfNBmFMkk1fKWJh/UZM4om0KH8EO5T77EXgtBpn65EYHW7CmSsElXMq8pb9?=
 =?us-ascii?Q?+/bAqjK615xbYy5X9AKgpPHFzaJw6bkHljXSjMbV2ps8NnDXe13udV+jQMzK?=
 =?us-ascii?Q?ZoJq4a3iKCYB4wCDLkMMCRv9sHKj6RbYULIAyX4fJ4V77WBTiwAPPwxNJwod?=
 =?us-ascii?Q?myfOms3PWSDKmNODxVtqoW+n1jDzVk++IT9qccEIotgDCGbQOgaHJZcNe/rd?=
 =?us-ascii?Q?u1DUq+6zYnD6+JjccrsDO7zwWn+XJ/jOyZSZMX0lv5F3DzUM/iJaFDaiZfdD?=
 =?us-ascii?Q?vBDOoR1mOD36U9u26rtAzDSDvUDbwmYH7Na1EjlYtdCdxQt4UtOE7W61q1f8?=
 =?us-ascii?Q?4dAH+xGq2N+iKHftNr0VPBzYCjTuqtOepBHZ/uvBU0c/cXPrXlO1nZR+b8jo?=
 =?us-ascii?Q?1mmv1IzNhxSQDdx9QCpMXSOiYtSmHQasUzY5eIBGeCDdlM2IksiStAj+/vx2?=
 =?us-ascii?Q?d8uga4/8H7mKe6isJ+5FygkIBMuz4MxaxJnW7ofg7HLpVf34Tjuh9oDYGbcZ?=
 =?us-ascii?Q?yJSmk3KnHIdSzGGwct63xTcTl51ZBWlgwBGgOTkXyDoTqvTHnzwU3HLEVEG3?=
 =?us-ascii?Q?J2Z7OGci6kRlSPi9aYjPXd015OCAVfqFLtbP/r3s+Fkos9js6+KVe3pB77Kx?=
 =?us-ascii?Q?oOzz7rMx429mDH6xo3ayUVzumVNM5N+19/xbv4cVDm1hfn3dPxHIJJ/BbEHV?=
 =?us-ascii?Q?KL8LR/6CUQoM9vLceITfD5T09uu08d13KHhsrzGJebARmoOarImX2s/LEw+k?=
 =?us-ascii?Q?B9sK9qKfpiqi+zRXCniWOxuw2mfMotuqKnsyRV6xM+v+CdqeY7f6LFvicpoK?=
 =?us-ascii?Q?Fdu9UB00rYF0HhDHQDE5npg9678lezDdfkv0NBp2VV9sIbWRtQwva+9XfXUC?=
 =?us-ascii?Q?NZK+/G9wdxDwcSYZxrPRcyKJzI/znpJJ4mnkRi7DFGJ0gx8wCtYNJP09WjKC?=
 =?us-ascii?Q?M3OqQLLJb1LxWZipvETVdgKEkDRHAiy5gNLRib/FUtLVrHi/wV+zBsmTWb54?=
 =?us-ascii?Q?3fDejlGV3SLx0Esn+4rq/3us1ZtZoSSjRDErOq6bC2JvYRmQWKTx5WcvGiAr?=
 =?us-ascii?Q?9IKjGGKMOsN1zj6MsMbX9r4tT5Wkvl0CywuIQl7g1bU5Rd/9dqSCTtdQeVCo?=
 =?us-ascii?Q?gG9Yicm4ZGOaobceve+5R/m4mHOOfu239+Txi6ghWrxs41fra6WbhuemRupb?=
 =?us-ascii?Q?5LiusiyP/rSIGWGHB0fXq68gDao0RPhQK943McHKzPUs0EdOoMzzmMq6+BcX?=
 =?us-ascii?Q?4H8A+84BwX95RvuUpoPWLj5wQdHHJ/BTbwlz17vpwilpaZznhAzyNQHttC7w?=
 =?us-ascii?Q?kqXvbwCsNB8qQeUF/wytLwKVT7Bv2BB7Uqj1d2/fc9rJtKe5T5UKvQdxoRA4?=
 =?us-ascii?Q?fkV5tg9B3ukChFZEWxf/EFgsMFF+h6b600M082mi2tcfkOoAlNaWMTcmXbJz?=
 =?us-ascii?Q?MPSqGbhRyl2HdMM5oJEbWLzo4623n2lrbYh0HsnApVT9d2Z0ekndNCkdtEoz?=
 =?us-ascii?Q?WIBrG3ou70XLV8njq2rXhyW5nr9g9rZKwwdI+qaK0nTBFi6S5egDA3dQvUGg?=
 =?us-ascii?Q?6lV5KpgTjJQGtSH9vzSw3PwSSGTvsrUAsq7Y+PaaMMVV1GbFY+IbCgyOUG4V?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f35a96-7b64-466e-9580-08da594127ad
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:40.1655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inDQtlQvycPEZVBmOE3G8RYGDBaxI10zzuvnZEdVQ7qzxPGH1aHt7w8hxHrkEUVz6/80HXN1Paojmqbu3pC6qeoNNtzxOEdpXS0KSmo6sUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: tGuPOTzciTMJ57bw2oowM-HMgDvQEJ-D
X-Proofpoint-GUID: tGuPOTzciTMJ57bw2oowM-HMgDvQEJ-D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move iblock's unmap setup code to a configure_unmap callout.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1ed9381751e6..7bef97097b78 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -76,6 +76,14 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	return NULL;
 }
 
+static bool iblock_configure_unmap(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	return target_configure_unmap_from_queue(&dev->dev_attrib,
+						 ib_dev->ibd_bd);
+}
+
 static int iblock_configure_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -119,10 +127,6 @@ static int iblock_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
-	if (target_configure_unmap_from_queue(&dev->dev_attrib, bd))
-		pr_debug("IBLOCK: BLOCK Discard support available,"
-			 " disabled by default\n");
-
 	/*
 	 * Enable write same emulation for IBLOCK and use 0xFFFF as
 	 * the smaller WRITE_SAME(10) only has a two-byte block count.
@@ -903,6 +907,7 @@ static const struct target_backend_ops iblock_ops = {
 	.configure_device	= iblock_configure_device,
 	.destroy_device		= iblock_destroy_device,
 	.free_device		= iblock_free_device,
+	.configure_unmap	= iblock_configure_unmap,
 	.plug_device		= iblock_plug_device,
 	.unplug_device		= iblock_unplug_device,
 	.parse_cdb		= iblock_parse_cdb,
-- 
2.25.1

