Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C142C433E5
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 206682076E
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d1TgNHyT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hzbcsgQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgF1XCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 19:02:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2007 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgF1XCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 19:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593385320; x=1624921320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VQdZjUpGpzPxTBS+Y1rg+pb4zhbVAOjXX96uDCZCMzU=;
  b=d1TgNHyTVo8Wdyc4BRMCsrkeMxL6Wu0lQgPNAI/W7ks0nTvr/iK+hb/V
   5rNEU3aURI7biLR5chXCVRFVAJUwMMLHjDelcznc+i0GWeZC13X8bfwie
   Cxw6jt+MlvD36WnzvnvswLStZdvXri60F2xC3VLSLY17WXL3X5tE9O98x
   JFjgF15plHGqCn+bswMxG7NJwtJSxr21/tYUzo7/SQuW3K15YqkazvkbC
   Y4FN0TGx42RgXx5bqlHHwrludUVC2saviqOvKbcxpNyoE/QQdlXaZ3nE2
   4TLV3GzL6i9FTuGdu+Cl0wIACeSGzmWZdzmuccVrYqqBhGySFVNRObl+o
   w==;
IronPort-SDR: Nxi5Y0bAdsNKzewJ0Qqv+QrTWj4Jt4IvNvOb7EumPX5j6YJrhNFWcU90Gy/vopFoSJnx2aTMdC
 myOrmfyCrqmLnroHUqvdbr+lh/hrmFkH1v57pYibXEM0kSamm7mGWwFC+9TuL8AAVKVCZWXcVK
 pPUYUHw70qa9my4wO54tS8A5ozUklDXs6VYEHo6+8TtkjxzXnS7VzfAdAhVxpL80NFSj8Zxhvz
 8hDJAVOmd+2R/llOzyXvul51ZXTMn3QRYrAezvB3GSyRQ96cJ4BbBxsEP8Njv06neQN+x5cq7b
 wZY=
X-IronPort-AV: E=Sophos;i="5.75,293,1589212800"; 
   d="scan'208";a="145457407"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 07:01:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ee1pr3cN1X7COfXGZq3OCstTjC6leRU5WaZkH+HvNu6ou0H2kVRkQVfNcqa8O9XhNO2leFqypuhm+oEXqKrXa0y25TPLGjavV/VaUATn+0h5Sfv3NWsRQ/2wlFenanZS8RdfHUi/D4H0yRjEyGKRw38azSX4FqKJx3x5GYYhiPXIbC1vl0+3F9DPclUFxOdrhmvyNYLTx3bSZkXx/5OocN51xW3gjCBZSoXAu6PWmrbNCQPQCFWlvTHOGAUMI+1d2APj/t69m2nSZqVjyPVwBNkIu2YPPgqpJl1GGGmAOd4PtJC2zsMoVpx2VXdxH9Wulq9Xm/HptdDgb345GcwCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3IMlmPpP8bNkwD8bNTWv/UTt3aY69ikCOLCRsL+ux4=;
 b=i2d7ZAG1wKS9S1h5XQDZX3roG7XHiR4jYzqI/jUpCwQwZldnrq/wHd7sO7rj2449oBLlao82BwGYsRgNy7bivoiDuvWGdbwiViUu8Tls/WoR98BeKGyobJ53Uy+Sm8Qk21G9Bq14axJHVT6JkGcxVCAseY5QXqIU5BsyoWTyIYkUnaNF3oArU9xmxvZ8mBl1z/75yARE15AqiCvZSeHUipRrdguwBdGzEg3aFccATA87CQUYgyvcy5WSvHfbFnQ83Lb6XUE6AdpsfUDWab/LNX92qHxXIZgC6dQrLnE+U+mj4f/kNvtqPordMu5KozXcXhOxO6SmEg2uXU/egvhLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3IMlmPpP8bNkwD8bNTWv/UTt3aY69ikCOLCRsL+ux4=;
 b=hzbcsgQ9Q8rWCY5DFWUY8AXb7bPfmVn8zVeMK5FvbMKKtAzuVa3xaFEn9FrxTKM9Mh7+5q22MKswOIzq6MB4DWCPSgCXzPFw8ErnqfJdqPfWI9pRWx0J9MfeTlv+HHUYQYIH+lL/OVJTp/17IC5XD6qWApRSEcFTMmmRt8wd6/c=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
Received: from MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14)
 by MN2PR04MB5965.namprd04.prod.outlook.com (2603:10b6:208:d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 23:01:57 +0000
Received: from MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e]) by MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e%4]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 23:01:57 +0000
From:   =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, damien.lemoal@wdc.com,
        niklas.cassel@wdc.com, hans.holmberg@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
Subject: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block Devices
Date:   Sun, 28 Jun 2020 23:01:02 +0000
Message-Id: <20200628230102.26990-3-matias.bjorling@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200628230102.26990-1-matias.bjorling@wdc.com>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:203:69::28) To MN2PR04MB6223.namprd04.prod.outlook.com
 (2603:10b6:208:db::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ninja.localdomain (87.116.37.42) by AM5PR0202CA0018.eurprd02.prod.outlook.com (2603:10a6:203:69::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sun, 28 Jun 2020 23:01:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [87.116.37.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ea5eda5-a4b0-48e8-ce3f-08d81bb741b1
X-MS-TrafficTypeDiagnostic: MN2PR04MB5965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB5965AD06C3B66A493677129DF1910@MN2PR04MB5965.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ctj47+tfFFkkjPAB2ypCVK8ZsBJ0UR1L0KYsLrhs8Amfzf+dB11qRbJ8T4j0MdFbNVlXtkak16S8UlaSgloVfYfGWDrb7RLf4Ue8VS+QydQngV03piLaoEpUYw/925Q/XeOGFcUIvuVnYeCgBDJdJbsKeCczXtYUbx+c/Y0YY1QdZpO3O8tN98d65F9PnOPV6BMd45sPJBnQf0z2+SqtD/EWwq4wDwNFBmRjA/ZgpplglqBIUnY9kqzhGDqqZvy9Q5jouvGX31gFkj6HtykGeqSLw2pGzpCefJ+01wTOlCXUnIMIozXh5BhJ5HFeyN9PLk/PM5dI055XDqyDF8IM6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6223.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(39850400004)(376002)(6486002)(4326008)(2616005)(956004)(1076003)(86362001)(6636002)(66946007)(316002)(66556008)(66476007)(30864003)(186003)(6512007)(26005)(6666004)(66574015)(6506007)(8936002)(2906002)(83380400001)(36756003)(5660300002)(52116002)(16526019)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: h7teW06JigNX+KSm4554LpriddLUKTHB/qFxKbmkf9DC/ChMO5oNXo5efLhmgnbya/xgcJ1b8LbJI6nXXeNcPr6gPxur9K5/0YrGRDYbHhLWBXWNjRlqEVzqZmyboQM7BBk3paByHoqIVefG074gVuMhRP54Ke0q0KbDGSmm8PtP+uNIy6Opc9UuC5Hy5qxOMlLpXxdQ21o1s/hzKaMYmNyFWKF60jpo6QTMnGrTQlWMo2YmvcJxORjVIXHG3l1S5W81MT4WpUHgXsQqiHqBGh8ETK7oKJtJt8yfqPh9xnQR97d5YzfkS97MXfQhVSNqGHS7iz3FO06f6OB4p/NZ39KiBFHlKW32FpoEBb8xx8A5HY6OpkE0nogizbguKDWXEMvFAErHFfUWUr5R5ezVI0p488vh/m1tLKYFBROFaLURoQT2Pq5S9vIxCptmETWdpyhG3fIlgVih7sSfUcf28Kbju1tyyaCQeLgwjI4BAaY=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea5eda5-a4b0-48e8-ce3f-08d81bb741b1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6223.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 23:01:57.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTjvcw8LB3fy39jTPL5hHZyj0SDWk+hQ94TvLGm20BtChx+G0F50nC4T16H11RRfY1OUENEjuFPPYmO+fD2+KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5965
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NVMe Zoned Namespace Command Set adds support for associating
data to a zone through the Zone Descriptor Extension feature.

To allow user-space to associate data to a zone, add support through
the BLKSETDESCZONE ioctl. The ioctl requires that it is issued to
a zoned block device, and that it supports the Zone Descriptor
Extension feature. Support is detected through the
the zone_desc_ext_bytes sysfs queue entry for the specific block
device. A value larger than zero communicates that the device supports
the feature.

The ioctl associates data to a zone by issuing a Zone Management Send
command with the Zone Send Action set as the Set Zone Descriptor
Extension.

For the command to complete successfully, the specified zone must be
in the Empty state, and active resources must be available. On
success, the specified zone is transioned to Closed state by the
device. If less data is supplied by user-space then reported by the
the Zone Descriptor Extension size, the rest is zero-filled. If more
data or no data is supplied by user-space, the ioctl fails.

To issue the ioctl, a new blk_zone_set_desc data structure is defined.
It has following parameters:

 * the sector of the specific zone.
 * the length of the data to be associated to the zone.
 * any flags be used by the ioctl. None is defined.
 * data associated to the zone.

The data is laid out after the flags parameter, and it is the caller's
responsibility to allocate memory for the data that is specified in the
length parameter.

Signed-off-by: Matias Bjørling <matias.bjorling@wdc.com>
---
 block/blk-zoned.c             | 108 ++++++++++++++++++++++++++++++++++
 block/ioctl.c                 |   2 +
 drivers/nvme/host/core.c      |   3 +
 drivers/nvme/host/nvme.h      |   9 +++
 drivers/nvme/host/zns.c       |  11 ++++
 include/linux/blk_types.h     |   2 +
 include/linux/blkdev.h        |   9 ++-
 include/uapi/linux/blkzoned.h |  20 ++++++-
 8 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 81152a260354..4dc40ec006a2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -259,6 +259,50 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 }
 EXPORT_SYMBOL_GPL(blkdev_zone_mgmt);
 
+/**
+ * blkdev_zone_set_desc - Execute a zone management set zone descriptor
+ *                        extension operation on a zone
+ * @bdev:	Target block device
+ * @sector:	Start sector of the zone to operate on
+ * @data:	Pointer to the data that is to be associated to the zone
+ * @gfp_mask:	Memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Associate zone descriptor extension data to a specified zone.
+ *    The block device must support zone descriptor extensions.
+ *    i.e., by exposing a positive zone descriptor extension size.
+ */
+int blkdev_zone_set_desc(struct block_device *bdev, sector_t sector,
+			 struct page *data, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	struct bio_vec bio_vec;
+	struct bio bio;
+
+	if (!blk_queue_is_zoned(q))
+		return -EOPNOTSUPP;
+
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	/* Check alignment (handle eventual smaller last zone) */
+	if (sector & (zone_sectors - 1))
+		return -EINVAL;
+
+	bio_init(&bio, &bio_vec, 1);
+	bio.bi_opf = REQ_OP_ZONE_SET_DESC | REQ_SYNC;
+	bio.bi_iter.bi_sector = sector;
+	bio_set_dev(&bio, bdev);
+	bio_add_page(&bio, data, queue_zone_desc_ext_bytes(q), 0);
+
+	/* This may take a while, so be nice to others */
+	cond_resched();
+
+	return submit_bio_wait(&bio);
+}
+EXPORT_SYMBOL_GPL(blkdev_zone_set_desc);
+
 struct zone_report_args {
 	struct blk_zone __user *zones;
 };
@@ -370,6 +414,70 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 				GFP_KERNEL);
 }
 
+/*
+ * BLKSETDESCZONE ioctl processing.
+ * Called from blkdev_ioctl.
+ */
+int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t mode,
+			       unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct request_queue *q;
+	struct blk_zone_set_desc zsd;
+	void *zsd_data;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_is_zoned(q))
+		return -ENOTTY;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (!queue_zone_desc_ext_bytes(q))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&zsd, argp, sizeof(struct blk_zone_set_desc)))
+		return -EFAULT;
+
+	/* no flags is currently supported */
+	if (zsd.flags)
+		return -ENOTTY;
+
+	if (!zsd.len || zsd.len > queue_zone_desc_ext_bytes(q))
+		return -ENOTTY;
+
+	/* allocate the size of the zone descriptor extension and fill
+	 * with the data in the user data buffer. If the data size is less
+	 * than the zone descriptor extension size, then the rest of the
+	 * zone description extension data buffer is zero-filled.
+	 */
+	zsd_data = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!zsd_data)
+		return -ENOMEM;
+
+	if (copy_from_user(zsd_data, argp + sizeof(struct blk_zone_set_desc),
+			   zsd.len)) {
+		ret = -EFAULT;
+		goto free;
+	}
+
+	ret = blkdev_zone_set_desc(bdev, zsd.sector, virt_to_page(zsd_data),
+	      GFP_KERNEL);
+free:
+	free_page((unsigned long) zsd_data);
+	return ret;
+}
+
 static inline unsigned long *blk_alloc_zone_bitmap(int node,
 						   unsigned int nr_zones)
 {
diff --git a/block/ioctl.c b/block/ioctl.c
index bdb3bbb253d9..b9744705835b 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -515,6 +515,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
 	case BLKCLOSEZONE:
 	case BLKFINISHZONE:
 		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);
+	case BLKSETDESCZONE:
+		return blkdev_zone_set_desc_ioctl(bdev, mode, cmd, arg);
 	case BLKGETZONESZ:
 		return put_uint(argp, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e961910da4ac..b8f25b0d00ad 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -776,6 +776,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	case REQ_OP_ZONE_FINISH:
 		ret = nvme_setup_zone_mgmt_send(ns, req, cmd, NVME_ZONE_FINISH);
 		break;
+	case REQ_OP_ZONE_SET_DESC:
+		ret = nvme_setup_zone_set_desc(ns, req, cmd);
+		break;
 	case REQ_OP_WRITE_ZEROES:
 		ret = nvme_setup_write_zeroes(ns, req, cmd);
 		break;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 662f95fbd909..5bd5a437b038 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -708,6 +708,9 @@ int nvme_report_zones(struct gendisk *disk, sector_t sector,
 blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns, struct request *req,
 				       struct nvme_command *cmnd,
 				       enum nvme_zone_mgmt_action action);
+
+blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request *req,
+				       struct nvme_command *cmnd);
 #else
 #define nvme_report_zones NULL
 
@@ -718,6 +721,12 @@ static inline blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns,
 	return BLK_STS_NOTSUPP;
 }
 
+static inline blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns,
+		struct request *req, struct nvme_command *cmnd)
+{
+	return BLK_STS_NOTSUPP;
+}
+
 static inline int nvme_update_zone_info(struct gendisk *disk,
 					struct nvme_ns *ns,
 					unsigned lbaf)
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 5792d953a8f3..bfa64cc685d3 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -239,3 +239,14 @@ blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns, struct request *req,
 
 	return BLK_STS_OK;
 }
+
+blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request *req,
+		struct nvme_command *c)
+{
+	c->zms.opcode = nvme_cmd_zone_mgmt_send;
+	c->zms.nsid = cpu_to_le32(ns->head->ns_id);
+	c->zms.slba = cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
+	c->zms.action = NVME_ZONE_SET_DESC_EXT;
+
+	return BLK_STS_OK;
+}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..53b7b05b0004 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -316,6 +316,8 @@ enum req_opf {
 	REQ_OP_ZONE_FINISH	= 12,
 	/* write data at the current zone write pointer */
 	REQ_OP_ZONE_APPEND	= 13,
+	/* associate zone desc extension data to a zone */
+	REQ_OP_ZONE_SET_DESC	= 14,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2ed55055f68d..c5f092dd5aa3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -370,7 +370,8 @@ extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 				     unsigned int cmd, unsigned long arg);
 extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 				  unsigned int cmd, unsigned long arg);
-
+extern int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t mode,
+				      unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline unsigned int blkdev_nr_zones(struct gendisk *disk)
@@ -392,6 +393,12 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
 	return -ENOTTY;
 }
 
+static inline int blkdev_zone_set_desc_ioctl(struct block_device *bdev,
+					     fmode_t mode, unsigned int cmd,
+					     unsigned long arg)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct request_queue {
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 42c3366cc25f..68abda9abf33 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -142,6 +142,20 @@ struct blk_zone_range {
 	__u64		nr_sectors;
 };
 
+/**
+ * struct blk_zone_set_desc - BLKSETDESCZONE ioctl requests
+ * @sector: Starting sector of the zone to operate on.
+ * @flags: Feature flags.
+ * @len: size, in bytes, of the data to be associated to the zone.
+ * @data: data to be associated.
+ */
+struct blk_zone_set_desc {
+	__u64		sector;
+	__u32		flags;
+	__u32		len;
+	__u8		data[0];
+};
+
 /**
  * Zoned block device ioctl's:
  *
@@ -158,6 +172,10 @@ struct blk_zone_range {
  *                The 512 B sector range must be zone aligned.
  * @BLKFINISHZONE: Mark the zones as full in the specified sector range.
  *                 The 512 B sector range must be zone aligned.
+ * @BLKSETDESCZONE: Set zone description extension data for the zone
+ *                  in the specified sector. On success, the zone
+ *                  will transition to the closed zone state.
+ *                  The 512B sector must be zone aligned.
  */
 #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
 #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
@@ -166,5 +184,5 @@ struct blk_zone_range {
 #define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
 #define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
 #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
-
+#define BLKSETDESCZONE	_IOW(0x12, 137, struct blk_zone_set_desc)
 #endif /* _UAPI_BLKZONED_H */
-- 
2.17.1

