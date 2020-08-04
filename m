Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5364C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 14:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A897522BED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 14:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PxF2Nt+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgHDOZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:25:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:40484 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgHDOZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 10:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596551147; x=1628087147;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g54ozquK1jLtvuCLIfwfk49fNFnAVVUTpr+KX3jwzV0=;
  b=PxF2Nt+aNt42br2StULPyOlAjAwU6whcqa6VXtrXNWQexptH2ojXjeVJ
   X7jy4hqxE6UknoBBGOzPpyJKKjd8eSb0D0HkoP6woejsQec7Fi/dd3J9N
   +Gp4Zd0OX+YrqOmz182XzhfLgKZLLYYyA2dJpM4n/rcn7qdX+4aISXkNB
   hLiDSqfYqeITDYkldEBxx1CHkrS3GG+0AUKyTXz34Jo+dHAraHAenuTfR
   eAyNhYdg+NA93cco81jFRoG0VjR/nCjwN5SeJPpXKug0vwjDxpX2q5/Xr
   pfcMb3CIA6cvTP3adQLx0laqR74ZWGHD/Qthd/8ZwQuq/MBq6TFHetXyK
   g==;
IronPort-SDR: quS6iIeaYneC10cp8o86nATr/pXQXOjAgV4atuA9Ihi1YZ3u+PhO4u/E1FR7sA1hXXx36tM5Ly
 LQGVWM4/iQx/UtMo5lzhB8S8wxPZSqDBq4m73TzoOgw+9FjUdBL8vAigTfEsF5PIzkSPwRQBCp
 25/EmI54Ny2zgQFvN1gWEEWYvyOp5vOOUtzeYWmE5aDl4W8dzd0VRDDpZKgaVQzZQ60JTU+++Q
 J5+0ayStocj1PmkGZCGvhlQFvexHXmSJLc+l8to5QGA4xq1LJ6k2QinOwxp0MvJ6irFL/t1qNW
 6mk=
X-IronPort-AV: E=Sophos;i="5.75,434,1589212800"; 
   d="scan'208";a="145351584"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 22:25:46 +0800
IronPort-SDR: /tsVBNQspKXMesZElEPlDGoleAyfD+c5xonb93yqoEx6HLC8o1hVOSegGgYOnFaCVZNjd8T427
 SFKRd3tk4vOg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 07:13:46 -0700
IronPort-SDR: 81oM8ProOHcmGpjjyicTD0pYE1zEHRoXPV4UD0ZA3A1BQRDK1hfSwWzVVSuRrk01li6iQ9pKZh
 Cn7yDjBBfFyw==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Aug 2020 07:25:44 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH] scsi: sd_zbc: prevent report zones racing rev_wp_ofst updates
Date:   Tue,  4 Aug 2020 23:25:41 +0900
Message-Id: <20200804142541.17126-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When revalidating a zoned SCSI disk, we need to do a REPORT ZONES, which
also updates the write-pointer offset cache.

As we don't want a normal REPORT ZONES to constantly update the
write-pointer offset cache, we swap the cache contents from revalidate
with the live version.

But if a second REPORT ZONES is triggered while '->rev_wp_offset' is
already allocated, sd_zbc_parse_report() can't distinguish the two
different REPORT ZONES (from revalidation context or from a
file-system/ioctl).

                 CPU0                             CPU1

sd_zbc_revalidate_zones()
`-> mutex_lock(&sdkp->rev_mutex);
`-> sdkp->rev_wp_offset = kvcalloc();
`->blk_revalidate_disk_zones();
   `-> disk->fops->report_zones();
       `-> sd_zbc_report_zones();
           `-> sd_zbc_parse_report();
	       `-> if (sdkp->rev_wp_offset)
                   `-> sdkp->rev_wp_offset[idx] =

                                           blkdev_report_zones()
                                           `-> disk->fops->report_zones();
                                               `-> sd_zbc_report_zones();
                                                   `-> sd_zbc_parse_report();
                                        	       `-> if (sdkp->rev_wp_offset)
                                                           `-> sdkp->rev_wp_offset[idx] =

   `-> update_driver_data();
      `-> sd_zbc_revalidate_zones_cb();
          `-> swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
`-> kvfree(sdkp->rev_wp_offset);
`-> sdkp->rev_wp_offset = NULL;
`-> mutex_unlock(&sdkp->rev_mutex);

As two concurrent revalidates are excluded via the '->rev_mutex', try to
grab the '->rev_mutex' in sd_zbc_report_zones(). If we cannot lock the
'->rev_mutex' because it's already held, we know we're called in a disk
revalidate context, if we can grab the mutex we need to unlock it again
after sd_zbc_parse_report() as we're not called in a revalidate context.

This way we can ensure a partial REPORT ZONES doesn't set invalid
write-pointer offsets in the revalidate write-pointer offset cache when a
partial REPORT ZONES is running concurrently with a full REPORT ZONES from
disk revalidation.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6f7eba66687e..d19456220c09 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -198,6 +198,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	unsigned char *buf;
 	size_t offset, buflen = 0;
 	int zone_idx = 0;
+	bool unlock = false;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -223,6 +224,14 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		if (!nr)
 			break;
 
+		/*
+		 * Check if we're called by revalidate or by a normal report
+		 * zones. Mutually exclude report zones due to revalidation and
+		 * normal report zones, so we're not accidentally overriding the
+		 * write-pointer offset cache.
+		 */
+		if (mutex_trylock(&sdkp->rev_mutex))
+			unlock = true;
 		for (i = 0; i < nr && zone_idx < nr_zones; i++) {
 			offset += 64;
 			ret = sd_zbc_parse_report(sdkp, buf + offset, zone_idx,
@@ -231,6 +240,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 				goto out;
 			zone_idx++;
 		}
+		if (unlock)
+			mutex_unlock(&sdkp->rev_mutex);
 
 		sector += sd_zbc_zone_sectors(sdkp) * i;
 	}
-- 
2.26.2

