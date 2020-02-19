Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E71DC34022
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 06:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB3F222D9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 06:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aZal/8jw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgBSGiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 01:38:03 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36923 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgBSGiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 01:38:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582094283; x=1613630283;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c+I+TDP9jK+0KGWQwetdfzzSxOmBCdAV7+qo9+XlbkM=;
  b=aZal/8jw0XMWHQMtlKkuDR/RD8Hszmr7t71ctrnM8WgYsUhkd7lBz1Ii
   0lK2AhqK5HESyzmGwPk83l4hjxgsjuNYCMwia9/Ldzt2ns2STcm/q8QR0
   EjqkxM9QirO9x81vvp581j3noFZwUzG0WuYnm3ufSGau7usKzayKGljrU
   eEZZ6Ahz5zEi8CjEmX84e+ZFlvfZBZ6tSgzyrUNNjnctJjzzSqxLAV4rB
   ku6ABFGXROn6mluPLUcqdg6QP3j8odIU8dD6XiVvQyIBhYDjvi+5eml5K
   g515PUYzor8FemDfOWFCY2STGQD234xOtXl84L6Ppks3HnjRPbjkEXKDd
   g==;
IronPort-SDR: YKN/O0atSSd0lmMLCpwv2+ALYu1YSg5rFGuxquVLihUEaYtgNci5ESaasp+7XMb1TlAZTuymMv
 7zkSGsRkODCq4vmO+sdtGBkY0iwARRarY987IJvHvmCRevhRVoVCp1oHJOPC7ZxU1cILBnIL4b
 KusNVwLAZKMabWlu1q3UTzHl1pDZbJXMM/wtXK6FNxSSiBkjrYd5XtZoVuMXkxMrSNg+kJwSaD
 55+ecGqAVPkEnGmArj9diYy9tHE972r8uxjWt9nC6o3xtGYwohPTMxIPqy0td5URtsGGbwmweT
 ycA=
X-IronPort-AV: E=Sophos;i="5.70,459,1574092800"; 
   d="scan'208";a="130687642"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Feb 2020 14:38:02 +0800
IronPort-SDR: HDFFMLWFnLXuVQx1iRhxu+BIQtiWjGsJmikJiClhYSYcxxq6GxRpi/s+7pjRVLHVY5nSR7tE8J
 44xUbGSNCLN84tV62dzxYSZjOSsJ2e8of96d8jhMDV+DphPe3FXUI7xF18uRbf5VG/160oH225
 J5TyMxx3C7ryfg0Zr6Ok01HyK5JA8gbCRtUlZP6FU4imeygu97udLQmzqfpqJFv9V04NZ/CvTF
 qVgByT/E/Vk53ziyrunG8WBPOjMaJNSdB2mE5AOY2VvUoRCmDyLyjnApAU4pkqyYZPwXu5VNTS
 2TtsOq08czzrTbxnnFUe9qQl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 22:30:39 -0800
IronPort-SDR: Ll5KS+d5mRZqhgrHRyXjFumXMVkIRay4Pe2/8gF++IY1WVHCr4aOzOIts5bKTQdh9gpiOIpqKS
 dv/qTlUaDBKXUhfQfEyxSG1WbeRvlDDPS+iHHtNipiuLna7elWVs6CE+Zy0muRifFga7CAipce
 azmnt8dWVDK3Xdl5bR9HviS7AxxBNpOQyKqGvVHdISglYyiBPNrIa7IC62MtBLvdIft25YAt+o
 WdDIfnAjcW0EtfJCPWwClC+6bSQInoqYokigO1I5+1B+/gYfuAc3RhVzQZs+P3myNiQV2jsHkD
 j5o=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Feb 2020 22:38:00 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd_sbc: Fix sd_zbc_report_zones()
Date:   Wed, 19 Feb 2020 15:38:00 +0900
Message-Id: <20200219063800.880834-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The block layer generic blk_revalidate_disk_zones() checks the validity
of zone descriptors reported by a disk using the
blk_revalidate_zone_cb() callback function executed for each zone
descriptor. If a ZBC disk reports invalid zone descriptors,
blk_revalidate_disk_zones() returns an error and sd_zbc_read_zones()
changes the disk capacity to 0, which in turn results in the gendisk
structure capacity to be set to 0. This all works well for the first
revalidate pass on a disk and the block layer detects the capactiy
change.

On the second revalidate pass, blk_revalidate_disk_zones() is called
again and sd_zbc_report_zones() executed to check the zones a second
time. However, for this second pass, the gendisk capacity is now 0,
which results in sd_zbc_report_zones() to do nothing and to report
success and no zones. blk_revalidate_disk_zones() in turn returns
success and sets the disk queue chunk_sectors limit with zero as
no zones were checked, causing a oops to trigger on the
BUG_ON(!is_power_of_2(chunk_sectors)) in blk_queue_chunk_sectors().

Fix this by using the sdkp capacity field rather than the gendisk
capacity for the report zones loop in sd_zbc_report_zones(). Also add a
check to return immediately an error if the sdkp capacity is 0.
With this fix, invalid/buggy ZBC disk scan does not trigger a oops and
are exposed with a 0 capacity. This change also preserve the chance for
the disk to be correctly revalidated on the second revalidate pass as
the scsi disk structure capacity field is always set to the disk
reported value when sd_zbc_report_zones() is called.

Fixes: d41003513e61 ("block: rework zone reporting")
Cc: Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e4282bce5834..f45c22b09726 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -161,6 +161,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -171,11 +172,15 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
+	if (!capacity)
+		/* Device gone or invalid */
+		return -ENODEV;
+
 	buf = sd_zbc_alloc_report_buffer(sdkp, nr_zones, &buflen);
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && sector < get_capacity(disk)) {
+	while (zone_idx < nr_zones && sector < capacity) {
 		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
 				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)
-- 
2.24.1

