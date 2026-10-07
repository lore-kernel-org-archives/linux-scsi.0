Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C6041D228;
	Wed,  7 Oct 2026 08:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361436; cv=none; b=B1DZKKc0IgJ5xzO3mhb24uMAgldoEl157DtFRGsK0j9a+zUBfS87YzalQOsTgGqBxzg/eDRAw0xaKSKGYXx6FzYfuZiM+DBh+6QsACvqBEaBV/+riNoR3JeXSKkfxBcxHLhVPgwz8+xUgLK8WVCGrwGgDQdkkp2mX9AnkHyX/lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361436; c=relaxed/simple;
	bh=ROhf1MCT5NP+etZBWnmu4jkHl+v/eU4Kn8JtofzpIA0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flIQZNoLDox+FBikcebupwk9u7+T+R0xtiKJ/yu8jxNQ7tQ2f67lwzX1lS8Zvkq5RsSlQwmWte3xoqGRBks1FcAGQiJsqgWOxsugfeFPKUl0DdvWiILkzzpjhuVSEFMVhT9fpN5AC4qOLENOPFXzx4ywFniigIOHfCo5Naz3StU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RzyY84li; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RzyY84li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264A21F008A1;
	Wed,  7 Oct 2026 08:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791361434;
	bh=gqb/vsjzX2P+Y6IyzSzlaH3tw5GCPESdzdwTrIbGE1o=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RzyY84liP90ZtVrde/BA1r2u6emAkmjFvf7B1XNKuAfwfmsW3sWZu+Xyo+ThMSXCw
	 z+FSBUFlf6CeeJMdY3NJgNi5+daUe9KG0tHmMyapZsenwKwQO8hZ00ixNy4YVO+Ge5
	 uhuMnD0NrpALRzVoUiMLsOa0mY2IWmJ54hlrks2uSDfM2l1TIZRHNB68iLTXT2FfhH
	 VnAJYqZVYEQrYKDhHRtbzVW9mmGlzn26Y152B0KE/7Eja50fGvbHRpht7lLTbtQDes
	 I6nbv2u6BD8vjCxVUcaCbZYl7q7wOdLJ38NpjXKjF0JCm8uuXal1WN2CtRIAFUgsq6
	 Um75uhZZ3ThxA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 7/7] scsi: sd_zbc: define storage element management operations
Date: Wed,  7 Oct 2026 17:23:44 +0900
Message-ID: <20261007082344.1049179-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007082344.1049179-1-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
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
---
 drivers/scsi/sd.c     |   3 +
 drivers/scsi/sd.h     |   2 +
 drivers/scsi/sd_zbc.c | 233 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..4372fa80f792 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3937,6 +3937,9 @@ static const struct block_device_operations sd_fops = {
 	.get_unique_id		= sd_get_unique_id,
 	.free_disk		= scsi_disk_free_disk,
 	.pr_ops			= &sd_pr_ops,
+#ifdef CONFIG_BLK_DEV_ZONED
+	.se_ops			= &sd_zbc_se_ops,
+#endif
 };
 
 /**
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6a72371fee78..b68b7ee5a5fa 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -243,6 +243,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, struct blk_report_zones_args *args);
 
+extern const struct blk_storage_elements_ops sd_zbc_se_ops;
+
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 2c77f878ab3f..60b9514d8d49 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -548,6 +548,239 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_info.zone_blocks);
 }
 
+static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *desc,
+					 struct blk_storage_element *element)
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
+					  struct blk_storage_element *elements,
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
+const struct blk_storage_elements_ops sd_zbc_se_ops = {
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

