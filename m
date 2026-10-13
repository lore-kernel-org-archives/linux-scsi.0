Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ADA4CB8A8;
	Tue, 13 Oct 2026 12:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894485; cv=none; b=GzNZePu8NyX8pfUylccBJClTAels2bag54vBelZ8+Z3XJVZydG+F3fSYiZTSedfgKR+g+bHE5EEqZZr3h3w6sdkRDxjpMD497GyDKaNMT36y33kL7M8PuxYmOoRuXImc1cN/K8ihcGN0wBfidkBcAg+iOn+NGOZhUvTSc33OMeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894485; c=relaxed/simple;
	bh=gLDkhLBvEQe2BjaUhqjboPl1tPz211nOzKnVbMSSWYo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc8ovPLmWcvHkofNQJ7Znmnk287mlnfhCVlZXdCovQgmOH1bhezc0XARZtjDhBPNGF9KRQx7lMCH1RI2OO14xe2mPPHvCudNwr/ELeo6+B+8Qj36rI062yobI3wY55GR2hdCn8IrVQUVZNS6wvSQUHqpOBfqN3LLYsvHBW5Ads4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3ph7wFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3ph7wFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F8F1F000FF;
	Tue, 13 Oct 2026 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894484;
	bh=4z/FZ99t8In8a/pReIwN4iTvcvj4HfARz97cWJPafa4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=i3ph7wFCpnZtlwTdTKAvlPcTmB/gNJLWxRN7LF30WLtRP3toVOh9h+32so8qP/J3W
	 HTl5SJIJnet0T4DmeFksaMpEf5XLCsjYLFkMweXN4I2qePMa6z+pFB+DKnZynHZ8u+
	 rYUU+5yPl2sRH/5vVHP//UXh5P6x9gq42xiqdZTmLb0nYTXFiGMRFwcshHdld1uaj8
	 L2+egyCM4F9tBsZtrAEEJi+EnEDGd1c22/JcWEGIMYSeG63u+A+eUsA40sMxkJRcuF
	 zHWu6izw3Vrss7TBMaitY1R11p6uVKnU3IwL7/IHYYo71+MyzXqyrmOPfQ7HEwq2eu
	 Fv8EYMZ9m6pZg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 10/10] scsi: sd_zbc: define storage element management operations
Date: Tue, 13 Oct 2026 21:27:50 +0900
Message-ID: <20261013122750.2237843-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the storage element management operations using struct
blk_storage_elements_ops. These operations are valid only on SMR disks
supporting the storage element depopulation feature.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c     |   3 +
 drivers/scsi/sd.h     |   2 +
 drivers/scsi/sd_zbc.c | 233 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index db7c19d1c2ff..48c46f4a1ace 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3943,6 +3943,9 @@ static const struct block_device_operations sd_fops = {
 	.get_unique_id		= sd_get_unique_id,
 	.free_disk		= scsi_disk_free_disk,
 	.pr_ops			= &sd_pr_ops,
+#ifdef CONFIG_BLK_DEV_ZONED
+	.se_ops			= &sd_zbc_se_ops,
+#endif
 };
 
 /**
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6a72371fee78..fc8c49903811 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -243,6 +243,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, struct blk_report_zones_args *args);
 
+extern const struct blk_se_ops sd_zbc_se_ops;
+
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 2c77f878ab3f..39cd4f9fcce5 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -548,6 +548,239 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_info.zone_blocks);
 }
 
+static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *desc,
+					 struct blk_se *element)
+{
+	struct scsi_device *sdp = sdkp->device;
+	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
+	u64 capacity;
+
+	memset(element, 0, sizeof(*element));
+
+	element->id = get_unaligned_be32(&desc[4]);
+
+	switch (desc[14]) {
+	case SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE:
+		element->type = BLK_SE_TYPE_RDWR;
+		capacity = get_unaligned_be64(&desc[16]);
+		if (!zone_sectors || capacity == ULLONG_MAX)
+			element->nr_zones = 0;
+		else
+			element->nr_zones =
+				logical_to_sectors(sdp, capacity) >>
+					ilog2(zone_sectors);
+		break;
+	case SCSI_PHYS_ELEM_TYPE_FRAC_ACCESS_STORAGE:
+		element->paired_id = get_unaligned_be32(&desc[16]);
+		if (desc[20] & 0x01)
+			element->type = BLK_SE_TYPE_READ;
+		else
+			element->type = BLK_SE_TYPE_WRITE;
+		element->nr_zones = get_unaligned_be64(&desc[24]);
+		break;
+	default:
+		element->type = BLK_SE_TYPE_UNKNOWN;
+	}
+
+	switch (desc[15]) {
+	case SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS:
+	case SCSI_PHYS_ELEM_HEALTH_AT_SPEC_LIMITS:
+		element->status = BLK_SE_STS_OK;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS:
+		element->status = BLK_SE_STS_DEGRADED;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_ERR:
+		element->status = BLK_SE_STS_RESTORE_ERROR;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_IN_PROGRESS:
+		element->status = BLK_SE_STS_RESTORE_IN_PROGRESS;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_DEPOP_ERR:
+		element->status = BLK_SE_STS_REMOVE_ERROR;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_DEPOP_IN_PROGRESS:
+		element->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_DEPOP_OK:
+		element->status = BLK_SE_STS_REMOVED;
+		element->restore_allowed = desc[13] & 0x01;
+		break;
+	case SCSI_PHYS_ELEM_HEALTH_NOT_REPORTED:
+	default:
+		element->status = BLK_SE_STS_UNKNOWN;
+		break;
+	}
+}
+
+/*
+ * Large hard limit on the number of storage elements. This accommodates all
+ * known devices today and likely forever :)
+ */
+#define SD_ZBC_MAX_STORAGE_ELEMENTS	255
+
+static int sd_zbc_report_storage_elements(struct gendisk *disk,
+					  struct blk_se *elements,
+					  unsigned int *nr_elements)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	unsigned char cmd[16];
+	unsigned int nr_descs, nr_se;
+	unsigned int buf_size;
+	int i, ret = 0, result;
+	u8 *desc, *buf;
+
+	if (!sdkp->modify_zones_supported)
+		return -EOPNOTSUPP;
+
+	/*
+	 * We need at least 32B for the report header and 32B for each
+	 * descriptor.
+	 */
+	nr_se = min(SD_ZBC_MAX_STORAGE_ELEMENTS, *nr_elements);
+	buf_size = ALIGN((nr_se + 1) * 32, SECTOR_SIZE);
+
+	buf = kzalloc(buf_size, GFP_NOIO);
+	if (!buf)
+		return -ENOMEM;
+
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_GET_PHYSICAL_ELEMENT_STATUS;
+	put_unaligned_be32(buf_size, &cmd[10]);
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buf, buf_size,
+				  timeout, 1, &exec_args);
+	if (result) {
+		sd_printk(KERN_ERR, sdkp,
+			  "GET PHYSICAL ELEMENT STATUS failed\n");
+		sd_print_result(sdkp, "GET PHYSICAL ELEMENT STATUS", result);
+		if (result > 0 && scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
+		ret = -EIO;
+		goto free_buf;
+	}
+
+	nr_descs = get_unaligned_be32(&buf[0]);
+	if (!nr_descs) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Invalid number of phys element descriptors\n");
+		ret = -EIO;
+		goto free_buf;
+	}
+	if (nr_descs > SD_ZBC_MAX_STORAGE_ELEMENTS) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Too many phys element descriptors\n");
+		ret = -EIO;
+		goto free_buf;
+	}
+
+	if (!elements) {
+		*nr_elements = nr_descs;
+		goto free_buf;
+	}
+
+	nr_descs = get_unaligned_be32(&buf[4]);
+	if (!nr_descs) {
+		sd_printk(KERN_ERR, sdkp,
+			"Invalid number of reported phys element descriptors\n");
+		ret = -EIO;
+		goto free_buf;
+	}
+
+	desc = &buf[32];
+	for (i = 0; i < min(nr_se, nr_descs); i++, desc += 32)
+		sd_zbc_parse_storage_element(sdkp, desc, &elements[i]);
+	*nr_elements = i;
+
+free_buf:
+	kfree(buf);
+
+	return ret;
+}
+
+static int sd_zbc_remove_storage_element(struct gendisk *disk,
+					 unsigned int element_id)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	unsigned char cmd[16];
+	int result;
+
+	if (!sdkp->modify_zones_supported)
+		return -EOPNOTSUPP;
+
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES;
+	put_unaligned_be32(element_id, &cmd[10]);
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				  timeout, 1, &exec_args);
+	if (result) {
+		sd_printk(KERN_ERR, sdkp,
+			  "REMOVE ELEMENT AND MODIFY ZONES failed\n");
+		sd_print_result(sdkp,
+				"REMOVE ELEMENT AND MODIFY ZONES", result);
+		if (result > 0 && scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sd_zbc_restore_storage_elements(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	unsigned char cmd[16];
+	int result;
+
+	if (!sdkp->modify_zones_supported)
+		return -EOPNOTSUPP;
+
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_RESTORE_ELEMENTS_AND_REBUILD;
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				  timeout, 1, &exec_args);
+	if (result) {
+		sd_printk(KERN_ERR, sdkp,
+			  "RESTORE ELEMENTS AND REBUILD failed\n");
+		sd_print_result(sdkp,
+				"RESTORE ELEMENTS AND REBUILD", result);
+		if (result > 0 && scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+const struct blk_se_ops sd_zbc_se_ops = {
+	.report_elements	= sd_zbc_report_storage_elements,
+	.remove_element		= sd_zbc_remove_storage_element,
+	.restore_elements	= sd_zbc_restore_storage_elements,
+};
+
 /*
  * Call blk_revalidate_disk_zones() if any of the zoned disk properties have
  * changed that make it necessary to call that function. Called by
-- 
2.55.0

