Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAB0C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08352076E
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i1znPR9b";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XMUtjM7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgF1XCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 19:02:01 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1999 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgF1XB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 19:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593385319; x=1624921319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6R5hRxO5pHES573y78eR2zYl2qx0XNUrhAS2zORDx8o=;
  b=i1znPR9bJjszibxs0VJTHxLXGucoBIguKqyxCt1mYjwcMCK2gdPN2J8p
   4rB7lKybWtA5e14RJWlBwqCsMb9GzxG3LNlrF3OjJiDJrpXMhAyCnS9Z4
   v156m7aLw1rojxCmD5KPtKOykT6acFIk/lEWO4xfgfNPEvi7pKkBQzzPD
   n7+UH8ywMYt7cU4pND66lYaCKDPG0j62AHlHGfccb3qzRj98aPKNz3UFq
   F51z8rLw4JZOUp6W1e5i4tGvN/s63gRFB3myy08xzZ4spvm8XEcTbOcmW
   FOy7AcIyQjzG+I3gveYOXLMh9BLBA/Iv2KZw7LzuX9iaQlMtvkvt70fvF
   A==;
IronPort-SDR: n3BgWbi+MfLUbXDsk7UJZxHPzc4T6hBtmEgPiMQDmiEMdQefie9cYV4jNz2KIM8JYGdw/LliqR
 RsDGoCOIrhDkwb7dmZ73CB6Vrww+DkFbw4yskECAJP05Zdfrd8gvyUJ3nQC38mDIzT/2ZhCAII
 Pzu1yJDOWSdDkAbGI733KUEWZcc+jUPXhIKpKkidIB9GKGLNaEhC5b90xHp0/Wgmtf2CkhmZhj
 0NXmgmzhmq3A+jO2tw0kKRJ/leYwKfHmcmjDNKvdQE5H2QD04ETe7cvRUXpBKXpePR29nCrpyw
 njM=
X-IronPort-AV: E=Sophos;i="5.75,293,1589212800"; 
   d="scan'208";a="145457404"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 07:01:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvDWMqcG1qBMHEhLRzXZgdDSPEjIzkTEAHwSxXBGz8bUAmoDoN7L2DN6/xQVylejw3Lv3GhNRfmvoq5iolCA0bSqkne2WsM9bz3tbtkqVihChCIaE/2ARDvty+Zu1oHPOKv0hleZD6nRxMyL+1Y5Eh5T/IgM4PWiDKAh5JNhabyAIid86Tr+NnIjt2JAvpoA8iMSdNSv7I109+ktgwCUymGWdf7HBlo3eB4sEWgYQ71OuU63o8oqJaQUugraq4oPGqmBf/hs7b5NAaar4zbuw0BQAhXHjTBcMGVdPPQM622LnW2/F5kwhhncB/5UgqglWiFCeW6jCmRZbrh4RHC02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7+JJRNW97go7vUzT8jmHwdxEl3RqQU3vUt2BlPb8sk=;
 b=Ot9tkSa6cbex4DBafwebF6F+3l/3pebqgwL5xa1C1FzvWS8kMSD4U1WebJ1/9x5Ke75YRKfve3BWkB+loDUeM8Nhk+fLsilSxZf8sukrkaeWAV3JoGycw01Oy/pGQw9xwZNU8QOPWIzShg8PEK7tP2dbRGsrtf8vtB6c66/l+Fo72h3hMquhe5rKE7eHQgJelspyabATTdxqXM2Zy5mv8+jeI75faGposM2SHb1xWop3WQfNxg45n/2ub8Fxar46sR7dUR/GFPq7wLvSqs3qgVrSLwdeGmQ+znl91k5zy0PEDqDK/ZAGV1QUcU9mL70yDg3ZN1AlpEVVdtsq58VraQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7+JJRNW97go7vUzT8jmHwdxEl3RqQU3vUt2BlPb8sk=;
 b=XMUtjM7OdVyggSF+PMyY9Km5BASJFNReSGlavsiKhFRu2oEq1gjfEiE7pHKmIxY4cTqH2d1d+v7DJQzMaUAIREi1B1uYq989j65sZIRpQRK7gU/x9tX8F0zJcHdibZCIaZ7qYN0nXTj6VnjWutkptwuCIuI/G93MxO05Byh+rqU=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
Received: from MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14)
 by MN2PR04MB5965.namprd04.prod.outlook.com (2603:10b6:208:d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 23:01:55 +0000
Received: from MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e]) by MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e%4]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 23:01:55 +0000
From:   =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, damien.lemoal@wdc.com,
        niklas.cassel@wdc.com, hans.holmberg@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
Subject: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Date:   Sun, 28 Jun 2020 23:01:01 +0000
Message-Id: <20200628230102.26990-2-matias.bjorling@wdc.com>
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
Received: from ninja.localdomain (87.116.37.42) by AM5PR0202CA0018.eurprd02.prod.outlook.com (2603:10a6:203:69::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sun, 28 Jun 2020 23:01:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [87.116.37.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f585e8f-cffd-45e5-c3e0-08d81bb74050
X-MS-TrafficTypeDiagnostic: MN2PR04MB5965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB596579903861205923225480F1910@MN2PR04MB5965.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKR43QHdEXIfKFk0m9qyfVh4SIOxveSCSc4IvOkBJ8hDuSmFKHxJ5zs+v7RTYAU1JzyZheuuP7i3Pi3YHfB8zb0wR4Cu7GIkQplIlZZqfvll4OLoTBQwg/v6QC8ox2AAx9CdeuD0Ti5kHS+05G/MWB0Ooysb0mgZzVjtnPzT8rKkZ72m4pDgmO9oa76BuNXILlC2sTuprv2z7YwC6lxw8ybEhIsGLXBHKudEaigLQEVLSmuizO7aMiRICmzWUdYzvA+pEY/8ZJ0kXPCVC1ZJdnyB6HiyLK1+zjnwpEyEgVYIFoBDIcMDg/iqOy/cHthTe2QJK8FNwn6d5ONWjY0htg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6223.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(39850400004)(376002)(6486002)(4326008)(2616005)(956004)(1076003)(86362001)(6636002)(66946007)(316002)(66556008)(66476007)(186003)(6512007)(26005)(6666004)(66574015)(6506007)(8936002)(2906002)(83380400001)(36756003)(5660300002)(52116002)(16526019)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JZ8omU0OPk9LQ2SfWDhc0EKtpJ+iY+8yohEIv98iq9WMWU2I9JNzTidvOtvcQb7tWVqDXf6nrihheZhUBSDt9DAGWFnD5tUh/v9ioJTP2s2NBGsCBn58YGiD/9H4Kqt5sh/ezo/HNckCkO/PXFSXnL4rBnQ6+LdQLG4J8Sbgj+xe0Sy+KZDZqoFi/nAIZNu4+KpT7M8bJCvrvrXgDyW9FkJFhGHjw939Ue4hnSo6nz64geKj7N7eVJ0yTYMBBeCTZFWMF/RYlausYV2RLxN8b6sINnz/f04dE2YrdIpohBM3yAeLaD33Qz6wsjJL+8IFE/HkvWRQu45VBzJqjrmqANaFpT5vgT/wxKYT+VkUr7oBMZcv3cfAaRnAATmDdQZjJXWdERNs8qA5px5Xl4qZ4h+n0+/fXQCJqYQ2HOSNcVyzfxx1QYWQDKsuQKdfBl/1KA44ntTsunfzctlAmUuMsjyYXw3hx6G34qISFJ65P54=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f585e8f-cffd-45e5-c3e0-08d81bb74050
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6223.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 23:01:55.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4d1o6t8W+53hbqD+qznTL+L53KPlmx9pyQJomi2rZRUKGR/l8flWaJiZaSpSoqC/pdlvAuSxAI1tdBjLzUuKrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5965
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NVMe Zoned Namespace Command Set adds support for associating
data to a zone through the Zone Descriptor Extension feature.

The Zone Descriptor Extension size is fixed to a multiple of 64
bytes. A value of zero communicates the feature is not available.
A value larger than zero communites the feature is available, and
the specified Zone Descriptor Extension size in bytes.

The Zone Descriptor Extension feature is only available in the
NVMe Zoned Namespaces Command Set. Devices that supports ZAC/ZBC
therefore reports this value as zero, where as the NVMe device
driver reports the Zone Descriptor Extension size from the
specific device.

Signed-off-by: Matias Bjørling <matias.bjorling@wdc.com>
---
 Documentation/block/queue-sysfs.rst |  6 ++++++
 block/blk-sysfs.c                   | 15 ++++++++++++++-
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               |  1 +
 include/linux/blkdev.h              | 22 ++++++++++++++++++++++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index f261a5c84170..c4fa195c87b4 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -265,4 +265,10 @@ devices are described in the ZBC (Zoned Block Commands) and ZAC
 do not support zone commands, they will be treated as regular block devices
 and zoned will report "none".
 
+zone_desc_ext_bytes (RO)
+-------------------------
+This indicates the zone description extension (ZDE) size, in bytes, of a zoned
+block device. A value of '0' means that zone description extension is not
+supported.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 624bb4d85fc7..0c99454823b7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -315,6 +315,12 @@ static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
 	return queue_var_show(queue_max_active_zones(q), page);
 }
 
+static ssize_t queue_zone_desc_ext_bytes_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(queue_zone_desc_ext_bytes(q), page);
+}
+
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
 	return queue_var_show((blk_queue_nomerges(q) << 1) |
@@ -687,6 +693,11 @@ static struct queue_sysfs_entry queue_max_active_zones_entry = {
 	.show = queue_max_active_zones_show,
 };
 
+static struct queue_sysfs_entry queue_zone_desc_ext_bytes_entry = {
+	.attr = {.name = "zone_desc_ext_bytes", .mode = 0444 },
+	.show = queue_zone_desc_ext_bytes_show,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = 0644 },
 	.show = queue_nomerges_show,
@@ -787,6 +798,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_nr_zones_entry.attr,
 	&queue_max_open_zones_entry.attr,
 	&queue_max_active_zones_entry.attr,
+	&queue_zone_desc_ext_bytes_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
@@ -815,7 +827,8 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 			return 0;
 
 	if ((attr == &queue_max_open_zones_entry.attr ||
-	     attr == &queue_max_active_zones_entry.attr) &&
+	     attr == &queue_max_active_zones_entry.attr ||
+	     attr == &queue_zone_desc_ext_bytes_entry.attr) &&
 	    !blk_queue_is_zoned(q))
 		return 0;
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 502070763266..5792d953a8f3 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -84,6 +84,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct nvme_ns *ns,
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
 	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
+	blk_queue_zone_desc_ext_bytes(q, id->lbafe[lbaf].zdes << 6);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d8b2c49d645b..a4b6d6cf5457 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -722,6 +722,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	else
 		blk_queue_max_open_zones(q, sdkp->zones_max_open);
 	blk_queue_max_active_zones(q, 0);
+	blk_queue_zone_desc_ext_bytes(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3776140f8f20..2ed55055f68d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -522,6 +522,7 @@ struct request_queue {
 	unsigned long		*seq_zones_wlock;
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
+	unsigned int		zone_desc_ext_bytes;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	/*
@@ -753,6 +754,18 @@ static inline unsigned int queue_max_active_zones(const struct request_queue *q)
 {
 	return q->max_active_zones;
 }
+
+static inline void blk_queue_zone_desc_ext_bytes(struct request_queue *q,
+		unsigned int zone_desc_ext_bytes)
+{
+	q->zone_desc_ext_bytes = zone_desc_ext_bytes;
+}
+
+static inline unsigned int queue_zone_desc_ext_bytes(
+		const struct request_queue *q)
+{
+	return q->zone_desc_ext_bytes;
+}
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -784,6 +797,15 @@ static inline unsigned int queue_max_active_zones(const struct request_queue *q)
 {
 	return 0;
 }
+static inline void blk_queue_zone_desc_ext_bytes(struct request_queue *q,
+		unsigned int zone_desc_ext_bytes)
+{
+}
+static inline unsigned int queue_zone_desc_ext_bytes(
+		const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
-- 
2.17.1

