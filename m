Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA396C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391389AbiDUSdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391179AbiDUSdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:36 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB834BB86
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:46 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id n18so5648528plg.5
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuCs1vqJY4UaDr670U24z1wPqlN25fEf3ZxbjscCIFE=;
        b=temNWAZQV170t9SujU8Etrf0J234dNB0YB3W848a1UarAoZhnynnrTUfGjGTwG6Fnu
         g4A1hNJJRcVs40JhCWUulyW1TaW4oztcoMQmP8E+fq/TtDicWLCM4jliCToWtFGEY5gl
         1tqLVHU1eTjx7+JYgDk5nm9ljEuEB0+73uiNd8G4rwSGwJ7UWknON3tCvPRosqPgHXS2
         I4pbJt98lFMhAXIP+m5Ud/TlECHdcXcEGOuO11/5EdZnMVPdcek8TRfC86rGJjl2AaW3
         0J1LLFZ+b6roHlRqSc1YEhoSrkpsf5ACqtEQ4RyVQwYMiQckDQERpMmarxTOE1h/dAWR
         Vdog==
X-Gm-Message-State: AOAM531FUjih4YZGKVUPr75cOSVfG9NTTI0QqKrcif5LHp384gC4IkmZ
        EvRbOqWMMpA7WkhBT1IbiMw=
X-Google-Smtp-Source: ABdhPJy8I0x8AkWU/oLPkpXx5JxcSYG0zW+nWOFisVwjGuJtKsHBtk51ngh4QwXR/8qz2TeabueOVQ==
X-Received: by 2002:a17:90b:4f82:b0:1d1:b8fd:7e36 with SMTP id qe2-20020a17090b4f8200b001d1b8fd7e36mr11881796pjb.194.1650565845533;
        Thu, 21 Apr 2022 11:30:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 6/9] scsi: sd_zbc: Hide gap zones
Date:   Thu, 21 Apr 2022 11:30:20 -0700
Message-Id: <20220421183023.3462291-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC-2 allows host-managed disks to report gap zones. This allow zoned disks
to report an offset between data zone starts that is a power of two even if
the number of logical blocks with data per zone is not a power of two.

Another new feature in ZBC-2 is support for constant zone starting LBA
offsets. For zoned disks that report a constant zone starting LBA offset,
hide the gap zones from the block layer. Report the offset between data
zone starts as zone size and report the number of logical blocks with data
per zone as the zone capacity.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: Reworked this patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.h         |   5 ++
 drivers/scsi/sd_zbc.c     | 105 +++++++++++++++++++++++++++++++++-----
 include/scsi/scsi_proto.h |   9 +++-
 3 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 47434f905b0a..d249933ba69e 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -99,6 +99,11 @@ struct scsi_disk {
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
index c53e166362b9..5b9fad70aa88 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
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
@@ -69,8 +75,12 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 {
 	struct scsi_device *sdp = sdkp->device;
 	struct blk_zone zone = { 0 };
+	sector_t start_lba, gran;
 	int ret;
 
+	if (WARN_ON_ONCE(sd_zbc_is_gap_zone(buf)))
+		return -EINVAL;
+
 	zone.type = buf[0] & 0x0f;
 	zone.cond = (buf[1] >> 4) & 0xf;
 	if (buf[1] & 0x01)
@@ -78,9 +88,27 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 	if (buf[1] & 0x02)
 		zone.non_seq = 1;
 
-	zone.len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
-	zone.capacity = zone.len;
-	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
+	start_lba = get_unaligned_be64(&buf[16]);
+	zone.start = logical_to_sectors(sdp, start_lba);
+	zone.capacity = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
+	zone.len = zone.capacity;
+	if (sdkp->zone_starting_lba_gran) {
+		gran = logical_to_sectors(sdp, sdkp->zone_starting_lba_gran);
+		if (zone.len > gran) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Invalid zone at LBA %llu with capacity %llu and length %llu; granularity = %llu\n",
+				  start_lba,
+				  sectors_to_logical(sdp, zone.capacity),
+				  sectors_to_logical(sdp, zone.len),
+				  sectors_to_logical(sdp, gran));
+			return -EINVAL;
+		}
+		/*
+		 * Use the starting LBA granularity instead of the zone length
+		 * obtained from the REPORT ZONES command.
+		 */
+		zone.len = gran;
+	}
 	if (zone.cond == ZBC_ZONE_COND_FULL)
 		zone.wp = zone.start + zone.len;
 	else
@@ -227,6 +255,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	sector_t lba = sectors_to_logical(sdkp->device, sector);
 	unsigned int nr, i;
 	unsigned char *buf;
+	u64 zone_length, start_lba;
 	size_t offset, buflen = 0;
 	int zone_idx = 0;
 	int ret;
@@ -255,14 +284,36 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 		for (i = 0; i < nr && zone_idx < nr_zones; i++) {
 			offset += 64;
+			start_lba = get_unaligned_be64(&buf[offset + 16]);
+			zone_length = get_unaligned_be64(&buf[offset + 8]);
+			if ((zone_idx == 0 &&
+			    (lba < start_lba ||
+			     lba >= start_lba + zone_length)) ||
+			    (zone_idx > 0 && start_lba != lba) ||
+			    start_lba + zone_length < start_lba) {
+				sd_printk(KERN_ERR, sdkp,
+					  "Zone %d at LBA %llu is invalid: %llu + %llu\n",
+					  zone_idx, lba, start_lba, zone_length);
+				ret = -EINVAL;
+				goto out;
+			}
+			lba = start_lba + zone_length;
+			if (sd_zbc_is_gap_zone(&buf[offset])) {
+				if (sdkp->zone_starting_lba_gran)
+					continue;
+				sd_printk(KERN_ERR, sdkp,
+					  "Gap zone without constant LBA offsets\n");
+				ret = -EINVAL;
+				goto out;
+			}
+
 			ret = sd_zbc_parse_report(sdkp, buf + offset, zone_idx,
 						  cb, data);
 			if (ret)
 				goto out;
+
 			zone_idx++;
 		}
-
-		lba += sdkp->zone_info.zone_blocks * i;
 	}
 
 	ret = zone_idx;
@@ -579,6 +630,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 					      unsigned char *buf)
 {
+	u64 zone_starting_lba_gran;
 
 	if (scsi_get_vpd_page(sdkp->device, 0xb6, buf, 64)) {
 		sd_printk(KERN_NOTICE, sdkp,
@@ -600,6 +652,29 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 	sdkp->zones_optimal_open = 0;
 	sdkp->zones_optimal_nonseq = 0;
 	sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+	/* Check zone alignment method */
+	switch (buf[23] & 0xf) {
+	case 0:
+	case ZBC_CONSTANT_ZONE_LENGTH:
+		/* Use zone length */
+		break;
+	case ZBC_CONSTANT_ZONE_START_OFFSET:
+		zone_starting_lba_gran = get_unaligned_be64(&buf[24]);
+		if (zone_starting_lba_gran == 0 ||
+		    !is_power_of_2(zone_starting_lba_gran) ||
+		    logical_to_sectors(sdkp->device, zone_starting_lba_gran) >
+		    UINT_MAX) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Invalid zone starting LBA granularity %llu\n",
+				  zone_starting_lba_gran);
+			return -ENODEV;
+		}
+		sdkp->zone_starting_lba_gran = zone_starting_lba_gran;
+		break;
+	default:
+		sd_printk(KERN_ERR, sdkp, "Invalid zone alignment method\n");
+		return -ENODEV;
+	}
 
 	/*
 	 * Check for unconstrained reads: host-managed devices with
@@ -654,14 +729,18 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 		}
 	}
 
-	/* Get the size of the first reported zone */
-	rec = buf + 64;
-	zone_blocks = get_unaligned_be64(&rec[8]);
-	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
-		if (sdkp->first_scan)
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Zone size too large\n");
-		return -EFBIG;
+	if (sdkp->zone_starting_lba_gran == 0) {
+		/* Get the size of the first reported zone */
+		rec = buf + 64;
+		zone_blocks = get_unaligned_be64(&rec[8]);
+		if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
+			if (sdkp->first_scan)
+				sd_printk(KERN_NOTICE, sdkp,
+					  "Zone size too large\n");
+			return -EFBIG;
+		}
+	} else {
+		zone_blocks = sdkp->zone_starting_lba_gran;
 	}
 
 	if (!is_power_of_2(zone_blocks)) {
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f017843a8124..c03e35fc382c 100644
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
@@ -323,6 +325,11 @@ enum zbc_zone_cond {
 	ZBC_ZONE_COND_OFFLINE		= 0xf,
 };
 
+enum zbc_zone_alignment_method {
+	ZBC_CONSTANT_ZONE_LENGTH	= 0x1,
+	ZBC_CONSTANT_ZONE_START_OFFSET	= 0x8,
+};
+
 /* Version descriptor values for INQUIRY */
 enum scsi_version_descriptor {
 	SCSI_VERSION_DESCRIPTOR_FCP4	= 0x0a40,
