Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0D2C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjCIV45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCIVz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:58 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D0FF16AC;
        Thu,  9 Mar 2023 13:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398956; x=1709934956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hb7jAHjMWTWZt4gJYnW7U10Z4zAALD8fUvl65/ingZQ=;
  b=KdfIJN7uJtpZtJ3fKslmXlbbadjTUZeQBhYBPJfK9mbFKDbSk+4JmK9C
   luy92AJpnOr9YUXqVVYHi3uAHbVL5v9fhLngzJDqkTnmIowyfz9JVUjl1
   JZhyTpvP9k6wXoLT84iw4pQMZTPOv/Mru9x9wmM9kYJeYGqk//a2DH3Tp
   CpCRVa6nt/Ni5ifNhkzXSKRTWRSx/0cea+48nu+KQYNyqntc3Uxo6VBHO
   73drCiiV4UAsXLDb1A7QSvXH/Vnb81pIU9JcuXsKbAh/oYGsNTdCfVqW6
   IbnNkRsp6edkw94EimuuyNo0w1HiE/aX5X3C3Gapv0dftBmMEFJ5flQqw
   A==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271025"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:56 +0800
IronPort-SDR: dU5uDFNA9vRygIJBRxn+IpY9GqngZG74JOmVOcmBdS9Qi5zTRlEcVRc7bUi08FMgKsvOGxgx3X
 licOsgAtpYODT1XlC7YuXoM3XnaB5TwdmXNrCWuLPl9EV7Gb3bq6LXW/E9q9PdF/hhnKBYcaRo
 c87LeX1qmFA7gQmWHYq2Ajzd1mm7ohX8hjAT8zqmXGKuHO2RS4ZfVl27XpJ8CS9TMKis+N71S3
 d3uOhgSM71x8yjkwwkf2N7Ak4WSaH0VJkkLS62ZJu+dTODHue4HqOwyAbN8yGnxdFRBrBgrjHB
 ZMU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:49 -0800
IronPort-SDR: 7wJn2+OVweDoU2k7DwNjMrqAxPU9NJOxcahZWvpfzYJcvqJw/XPqmYhMDsTmjUyR7ibzHfGiEk
 xh+JBxfCUZGJGacA0n9AN3xXQ4IvmOBeACX90GDtL08L8zgphqoJgZz0WGf3NukBigGmb7lkQO
 i1ioZGgRp32K3MBxONSkr6Umd+bor+J2QJDn4yp6PcONXsAK4X9o/bpo10HC68CxVWAHdZfO9x
 gayN2r3zdJTLLxEOof7B08a28zQHdcIe9toaQ/w5aUWHw/v4JLS4RH86dOIebEIuZ2H5LRvAW4
 to8=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:55 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 10/19] scsi: sd: set read/write commands CDL index
Date:   Thu,  9 Mar 2023 22:55:02 +0100
Message-Id: <20230309215516.3800571-11-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the command duration limits helper function sd_cdl_dld() to
set the DLD bits of READ/WRITE 16 and READ/WRITE 32 commands to
indicate to the device the command duration limit descriptor to apply
to the commands.

When command duration limits are enabled, sd_cdl_dld() obtains the
index of the descriptor to apply to the command using the hints field of
the request IO priority value (hints IOPRIO_HINT_DEV_DURATION_LIMIT_1 to
IOPRIO_HINT_DEV_DURATION_LIMIT_7).

If command duration limits is disabled (which is the default), the limit
index "0" is always used to indicate "no limit" for a command.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/sd.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c4be44832b49..791c160e6eca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1042,13 +1042,14 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len = SD_EXT_CDB_SIZE;
 	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
 	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
 	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
 	cmd->cmnd[10] = flags;
+	cmd->cmnd[11] = dld & 0x07;
 	put_unaligned_be64(lba, &cmd->cmnd[12]);
 	put_unaligned_be32(lba, &cmd->cmnd[20]); /* Expected Indirect LBA */
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[28]);
@@ -1058,12 +1059,12 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 
 static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len  = 16;
 	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
-	cmd->cmnd[1]  = flags;
-	cmd->cmnd[14] = 0;
+	cmd->cmnd[1]  = flags | ((dld >> 2) & 0x01);
+	cmd->cmnd[14] = (dld & 0x03) << 6;
 	cmd->cmnd[15] = 0;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
@@ -1115,6 +1116,31 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 	return BLK_STS_OK;
 }
 
+/*
+ * Check if a command has a duration limit set. If it does, and the target
+ * device supports CDL and the feature is enabled, return the limit
+ * descriptor index to use. Return 0 (no limit) otherwise.
+ */
+static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdp = sdkp->device;
+	int hint;
+
+	if (!sdp->cdl_supported || !sdp->cdl_enable)
+		return 0;
+
+	/*
+	 * Use "no limit" if the request ioprio does not specify a duration
+	 * limit hint.
+	 */
+	hint = IOPRIO_PRIO_HINT(req_get_ioprio(scsi_cmd_to_rq(scmd)));
+	if (hint < IOPRIO_HINT_DEV_DURATION_LIMIT_1 ||
+	    hint > IOPRIO_HINT_DEV_DURATION_LIMIT_7)
+		return 0;
+
+	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1126,6 +1152,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
+	unsigned int dld;
 	blk_status_t ret;
 	unsigned int dif;
 	bool dix;
@@ -1175,6 +1202,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
 	dix = scsi_prot_sg_count(cmd);
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
+	dld = sd_cdl_dld(sdkp, cmd);
 
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
@@ -1183,10 +1211,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
 		   sdp->use_10_for_rw || protect) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
-- 
2.39.2

