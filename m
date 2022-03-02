Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71226C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbiCBFh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239614AbiCBFhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B567B16D3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:39 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222fNNx014942;
        Wed, 2 Mar 2022 05:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=ODUHLRPROk65njViGM79XADjujxgF0BeuOWTRGyNRs0=;
 b=XWS62EqGwrA3qMZ2NEA1HlIo+Lk/oZRDFvoEimAcCysnRCHianJ1zlDnUgg/7AFLQgsj
 vemL6NgyghisCSUXr+bTeh2RWIRK3U1FrKjYl5+BZwNQd0qcKYh6zRgUMBxy0jEbTbca
 XQ6B7De6TC0i+403sBdo4UGHooiBo1j6RewShRehBBEZW209t/Tpg300rkVmLQrqVLSt
 F6gWkAfq3ASDXcKXnq8Bd8x2ObCs9aO6+RpfaW4epfx7eaaqnTnnDnvKnbPbW+tVSunp
 7cbEvh9uhIweGGr9zYFK6MvEX3GW7yx8wPENz4kQOakopHOWnuqQVtVISMifjY2a5A2y 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amq8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225Ir3K175892;
        Wed, 2 Mar 2022 05:36:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vams-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:34 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZv014395;
        Wed, 2 Mar 2022 05:36:34 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-15;
        Wed, 02 Mar 2022 05:36:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Aman Karmani <aman@tmm1.net>, David Sebek <dasebek@gmail.com>
Subject: [PATCH 14/14] scsi: sd: Enable modern protocol features on more devices
Date:   Wed,  2 Mar 2022 00:35:59 -0500
Message-Id: <20220302053559.32147-15-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9wSIgzvaPTglyFM5p8N9O9oppH8rP3Qc
X-Proofpoint-GUID: 9wSIgzvaPTglyFM5p8N9O9oppH8rP3Qc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Due to legacy USB devices having a tendency to either lock up or
return garbage if one attempts to query device capabilities, the USB
transport disables VPD pages by default. This prevents discard from
being properly configured on most modern USB-attached SSDs.

Introduce two additional heuristics to determine whether VPD pages
should be consulted.

The first heuristic fetches VPD pages if a device reports that Logical
Block Provisioning is enabled. It is very unusual for a device to
support thin provisioning and not provide the associated VPDs.
Consequently, if a device reports that Logical Block Provisioning is
enabled (LBPME) in READ CAPACITY(16) response, the scsi_device has no
VPDs attached, and the reported SPC version is larger than 3, then an
attempt will be made to read the VPD pages during revalidate.

The second heuristic relies on the fact that almost all modern devices
return a set of version descriptors in the INQUIRY response. These
descriptors outline which version of various protocol features are
supported. If a device manufacturer has gone through the effort of
filling out compliance descriptors, it is highly unlikely that VPD
pages are not supported. So if a device provides version descriptors
in the INQUIRY response, the scsi_device has no VPDs attached, and the
reported SBC version is larger than 2, then an attempt will be made to
read the VPD pages. In addition, READ CAPACITY(16) will be preferred
over READ CAPACITY(10) to facilitate accessing the LBPME flag.

The benefit to relying on INQUIRY is that it is data we already
have. We do not have to blindly poke the device for additional
information and risk confusing it.

Extracting the SBC version is done by a new helper, sd_sbc_version().
Another helper is provided to determine whether a scsi_device has VPD
pages attached or not.

Reported-by: Aman Karmani <aman@tmm1.net>
Tested-by: Aman Karmani <aman@tmm1.net>
Reported-by: David Sebek <dasebek@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c        |  1 +
 drivers/scsi/sd.c          | 77 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h          |  2 +
 include/scsi/scsi_device.h | 14 +++++++
 4 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 524e03aba9ef..7183fd35e48b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -497,6 +497,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	}
 	kfree(vpd_buf);
 }
+EXPORT_SYMBOL_GPL(scsi_attach_vpd);
 
 /**
  * scsi_report_opcode - Find out if a given command opcode is supported
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 163697dd799a..1f7ca9446949 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2497,6 +2497,19 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
+		/*
+		 * If a device sets LBPME=1 then it should, in theory, support
+		 * the Logical Block Provisioning VPD page. Assume that querying
+		 * VPD pages is safe if logical block provisioning is enabled
+		 * and the device claims conformance to a recent version of the
+		 * spec.
+		 */
+		if (!sdkp->reattach_vpds && !scsi_device_has_vpd(sdp) &&
+		    sdp->scsi_level > SCSI_SPC_3) {
+			sd_first_printk(KERN_NOTICE, sdkp,
+			 "Logical Block Provisioning enabled, fetching VPDs\n");
+			sdkp->reattach_vpds = true;
+		}
 	}
 
 	sdkp->capacity = lba + 1;
@@ -2563,8 +2576,10 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	return sector_size;
 }
 
-static int sd_try_rc16_first(struct scsi_device *sdp)
+static int sd_try_rc16_first(struct scsi_disk *sdkp)
 {
+	struct scsi_device *sdp = sdkp->device;
+
 	if (sdp->host->max_cmd_len < 16)
 		return 0;
 	if (sdp->try_rc_10_first)
@@ -2585,7 +2600,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
-	if (sd_try_rc16_first(sdp)) {
+	if (sd_try_rc16_first(sdkp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
@@ -3399,6 +3414,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
 		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
 
+		if (sdkp->reattach_vpds) {
+			sdp->try_vpd_pages = 1;
+			scsi_attach_vpd(sdp);
+			sdkp->reattach_vpds = false;
+		}
+
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
@@ -3543,6 +3564,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+enum {
+	INQUIRY_DESC_START	= 58,
+	INQUIRY_DESC_END	= 74,
+	INQUIRY_DESC_SIZE	= 2,
+};
+
+static unsigned int sd_sbc_version(struct scsi_device *sdp)
+{
+	unsigned int i;
+	unsigned int max;
+
+	if (sdp->inquiry_len < INQUIRY_DESC_START + INQUIRY_DESC_SIZE)
+		return 0;
+
+	max = min_t(unsigned int, sdp->inquiry_len, INQUIRY_DESC_END);
+	max = rounddown(max, INQUIRY_DESC_SIZE);
+
+	for (i = INQUIRY_DESC_START ; i < max ; i += INQUIRY_DESC_SIZE) {
+		u16 desc = get_unaligned_be16(&sdp->inquiry[i]);
+
+		switch (desc) {
+		case 0x0600:
+			return 4;
+		case 0x04c0: case 0x04c3: case 0x04c5: case 0x04c8:
+			return 3;
+		case 0x0320: case 0x0322: case 0x0324: case 0x033B:
+		case 0x033D: case 0x033E:
+			return 2;
+		case 0x0180: case 0x019b: case 0x019c:
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -3568,6 +3625,7 @@ static int sd_probe(struct device *dev)
 	struct gendisk *gd;
 	int index;
 	int error;
+	unsigned int sbc_version;
 
 	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
@@ -3656,6 +3714,21 @@ static int sd_probe(struct device *dev)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
+	/*
+	 * If the device explicitly claims support for SBC version 3
+	 * or later, unset the LLD flags which prevent probing for
+	 * modern protocol features and reattach VPD pages.
+	 */
+	sbc_version = sd_sbc_version(sdp);
+	if (!scsi_device_has_vpd(sdp) && sbc_version >= 3) {
+		sdkp->reattach_vpds = true;
+		sdp->try_rc_10_first = 0;
+		sdp->no_read_capacity_16 = 0;
+		sd_first_printk(KERN_NOTICE, sdkp,
+				"Detected SBC version %u, fetching VPDs\n",
+				sbc_version);
+	}
+
 	sd_revalidate_disk(gd);
 
 	if (sdp->removable) {
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2cef9e884b2a..b0b39e0ea5b3 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -108,6 +108,7 @@ struct scsi_disk {
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
 	unsigned int	medium_access_timed_out;
+	unsigned int	sbc_version;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
@@ -118,6 +119,7 @@ struct scsi_disk {
 	bool		provisioning_override;
 	bool		zeroing_override;
 	bool		ndob;
+	bool		reattach_vpds;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fd6a803ac8cd..feca18e5fe28 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -605,6 +605,20 @@ static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
 	return 0;
 }
 
+static inline bool scsi_device_has_vpd(struct scsi_device *sdev)
+{
+	struct scsi_vpd *vpd;
+	bool found = false;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg0);
+	if (vpd)
+		found = true;
+	rcu_read_unlock();
+
+	return found;
+}
+
 static inline int scsi_device_busy(struct scsi_device *sdev)
 {
 	return sbitmap_weight(&sdev->budget_map);
-- 
2.32.0

