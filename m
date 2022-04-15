Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E2FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351737AbiDOUUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351639AbiDOUUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:39 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5783EDE917
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:10 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 32so8442854pgl.4
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHzpvNk7WrzAdHMdEOJrpFlW1R99oYNdwevzWs1P1zQ=;
        b=E9bwqBRdDCyi/lynTLdry9Zl4iZkpocwP+GGB805PTW7anQwUy3WVn27RFRbxIXNMa
         MtcSNPPxppztFwLykiarZoxp12EJnRWEpIUqqFW04djYYsIP+UsBDlsWBdgc/3D8KTZF
         EOnasQ4u7gL3tYTXAK41VUZYYrNeiZ6qb09iqRVGDJA+3cwdJJm1Pcu2LbMWOg4ePYS7
         xPaR/oyI4sxKWQeWx+aj0h5Re9Glhb5WlpD3foR2p9X2uWwVPXbbGIv5ayTaST4Gx7J/
         GrvsRhWjDHkHlnSOoWsw90xp81ae3Uro8eA9cFqlYPZ6Y3WRyTo5+qRzSTIbr6JPJVQD
         TcIA==
X-Gm-Message-State: AOAM532DTwNItbA1GloWe66PxcmD3D4VJ0ktIZgJYAm2CL5klAk0Poae
        JBPSR5fOY/CXiWiqOM4AqAk=
X-Google-Smtp-Source: ABdhPJzmSDQAQuvQmt4fipTJ3i8uFjNDE3KODRZH+jEmAZEunz4UR7SbnBM8OUw2I3JPXWFFcPRQrQ==
X-Received: by 2002:a65:4203:0:b0:39d:6f6c:6b62 with SMTP id c3-20020a654203000000b0039d6f6c6b62mr556059pgq.78.1650053889783;
        Fri, 15 Apr 2022 13:18:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 5/8] scsi: sd_zbc: Hide gap zones
Date:   Fri, 15 Apr 2022 13:17:49 -0700
Message-Id: <20220415201752.2793700-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC-2 allows host-managed disks to report gap zones. Another new feature
in ZBC-2 is support for constant zone starting LBA offsets. These two
features allow zoned disks to report a starting LBA offset that is a
power of two even if the number of logical blocks with data per zone is
not a power of two.

For zoned disks that report a constant zone starting LBA offset, hide
the gap zones from the block layer. Report the starting LBA offset as
zone size and report the number of logical blocks with data per zone as
the zone capacity.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: Reworked this patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.h         |  5 +++
 drivers/scsi/sd_zbc.c     | 84 +++++++++++++++++++++++++++++++++++----
 include/scsi/scsi_proto.h |  8 +++-
 3 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2e983578a699..e0793e789fdc 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -95,6 +95,11 @@ struct scsi_disk {
 	u32		zones_optimal_open;
 	u32		zones_optimal_nonseq;
 	u32		zones_max_open;
+	/*
+	 * Either zero or a power of two. If not zero it means that the offset
+	 * between zone starting LBAs is constant.
+	 */
+	u32		zone_starting_lba_gran;
 	u32		*zones_wp_offset;
 	spinlock_t	zones_wp_offset_lock;
 	u32		*rev_wp_offset;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index fe46b4b9913a..92eace611364 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -37,7 +37,7 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
 	case BLK_ZONE_COND_CLOSED:
 		return zone->wp - zone->start;
 	case BLK_ZONE_COND_FULL:
-		return zone->len;
+		return zone->capacity;
 	case BLK_ZONE_COND_EMPTY:
 	case BLK_ZONE_COND_OFFLINE:
 	case BLK_ZONE_COND_READONLY:
@@ -50,6 +50,12 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
 	}
 }
 
+/* Whether or not a SCSI zone descriptor describes a gap zone. */
+static bool sd_zbc_is_gap_zone(const u8 buf[64])
+{
+	return (buf[0] & 0xf) == ZBC_ZONE_TYPE_GAP;
+}
+
 /**
  * sd_zbc_parse_report - Parse a SCSI zone descriptor
  * @sdkp: SCSI disk pointer.
@@ -68,8 +74,12 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 {
 	struct scsi_device *sdp = sdkp->device;
 	struct blk_zone zone = { 0 };
+	sector_t gran;
+	u64 start_lba;
 	int ret;
 
+	if (WARN_ON_ONCE(sd_zbc_is_gap_zone(buf)))
+		return -EINVAL;
 	zone.type = buf[0] & 0x0f;
 	zone.cond = (buf[1] >> 4) & 0xf;
 	if (buf[1] & 0x01)
@@ -79,9 +89,25 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 
 	zone.len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
 	zone.capacity = zone.len;
-	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
+	start_lba = get_unaligned_be64(&buf[16]);
+	zone.start = logical_to_sectors(sdp, start_lba);
+	if (sdkp->zone_starting_lba_gran) {
+		idx = start_lba >> ilog2(sdkp->zone_starting_lba_gran);
+		gran = logical_to_sectors(sdp, sdkp->zone_starting_lba_gran);
+		if (zone.capacity > zone.len || zone.len > gran) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Invalid zone for LBA %llu: zone capacity %llu; zone length %llu; granularity %llu\n",
+				  start_lba, zone.capacity, zone.len, gran);
+			return -EINVAL;
+		}
+		/*
+		 * Change the zone length obtained from REPORT ZONES into the
+		 * zone starting LBA granularity.
+		 */
+		zone.len = gran;
+	}
 	if (zone.cond == ZBC_ZONE_COND_FULL)
-		zone.wp = zone.start + zone.len;
+		zone.wp = zone.start + zone.capacity;
 	else
 		zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
 
@@ -227,6 +253,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 						      sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
+	u64 zone_length, start_lba;
 	size_t offset, buflen = 0;
 	int zone_idx = 0;
 	int ret;
@@ -254,16 +281,33 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		if (!nr)
 			break;
 
-		for (i = 0; i < nr && zone_idx < nr_zones; i++) {
+		for (i = 0; i < nr && zone_idx < nr_zones; i++, zone_idx++) {
 			offset += 64;
+			zone_length = get_unaligned_be64(&buf[offset + 8]);
+			start_lba = get_unaligned_be64(&buf[offset + 16]);
+			if (start_lba < sectors_to_logical(sdkp->device, sector)
+			    || start_lba + zone_length < start_lba) {
+				sd_printk(KERN_ERR, sdkp,
+					  "Zone %d is invalid: %llu + %llu\n",
+					  zone_idx, start_lba, zone_length);
+				ret = -EINVAL;
+				goto out;
+			}
+			sector = logical_to_sectors(sdkp->device, start_lba +
+						    zone_length);
+			if (sd_zbc_is_gap_zone(&buf[offset])) {
+				if (sdkp->zone_starting_lba_gran)
+					continue;
+				sd_printk(KERN_ERR, sdkp,
+					  "Gap zone without constant LBA offsets\n");
+				ret = -EINVAL;
+				goto out;
+			}
 			ret = sd_zbc_parse_report(sdkp, buf + offset, zone_idx,
 						  cb, data);
 			if (ret)
 				goto out;
-			zone_idx++;
 		}
-
-		sector += sd_zbc_zone_sectors(sdkp) * i;
 	}
 
 	ret = zone_idx;
@@ -580,6 +624,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 					      unsigned char *buf)
 {
+	u64 zone_starting_lba_gran;
+	u8 zone_alignment_method;
 
 	if (scsi_get_vpd_page(sdkp->device, 0xb6, buf, 64)) {
 		sd_printk(KERN_NOTICE, sdkp,
@@ -599,6 +645,28 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 		sdkp->zones_optimal_open = 0;
 		sdkp->zones_optimal_nonseq = 0;
 		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+		zone_alignment_method = buf[23] & 0xf;
+		if (zone_alignment_method ==
+		    ZBC_CONSTANT_ZONE_STARTING_LBA_OFFSETS) {
+			zone_starting_lba_gran =
+				get_unaligned_be64(&buf[24]);
+			if (zone_starting_lba_gran == 0) {
+				sd_printk(KERN_ERR, sdkp,
+					  "Inconsistent: zone starting LBA granularity is zero\n");
+			}
+			if (!is_power_of_2(zone_starting_lba_gran) ||
+			    logical_to_sectors(sdkp->device,
+					       zone_starting_lba_gran) >
+			    UINT_MAX) {
+				sd_printk(KERN_ERR, sdkp,
+					  "Invalid zone starting LBA granularity %llu\n",
+					  zone_starting_lba_gran);
+				return -EINVAL;
+			}
+			sdkp->zone_starting_lba_gran = zone_starting_lba_gran;
+			WARN_ON_ONCE(sdkp->zone_starting_lba_gran !=
+				     zone_starting_lba_gran);
+		}
 	}
 
 	/*
@@ -664,7 +732,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 		return -EFBIG;
 	}
 
-	*zblocks = zone_blocks;
+	*zblocks = sdkp->zone_starting_lba_gran ? : zone_blocks;
 
 	if (!is_power_of_2(*zblocks)) {
 		sd_printk(KERN_ERR, sdkp,
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f017843a8124..521f9feac778 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -307,7 +307,9 @@ enum zbc_zone_type {
 	ZBC_ZONE_TYPE_CONV		= 0x1,
 	ZBC_ZONE_TYPE_SEQWRITE_REQ	= 0x2,
 	ZBC_ZONE_TYPE_SEQWRITE_PREF	= 0x3,
-	/* 0x4 to 0xf are reserved */
+	ZBC_ZONE_TYPE_SEQ_OR_BEFORE_REQ	= 0x4,
+	ZBC_ZONE_TYPE_GAP		= 0x5,
+	/* 0x6 to 0xf are reserved */
 };
 
 /* Zone conditions of REPORT ZONES zone descriptors */
@@ -323,6 +325,10 @@ enum zbc_zone_cond {
 	ZBC_ZONE_COND_OFFLINE		= 0xf,
 };
 
+enum zbc_zone_alignment_method {
+	ZBC_CONSTANT_ZONE_STARTING_LBA_OFFSETS = 8,
+};
+
 /* Version descriptor values for INQUIRY */
 enum scsi_version_descriptor {
 	SCSI_VERSION_DESCRIPTOR_FCP4	= 0x0a40,
