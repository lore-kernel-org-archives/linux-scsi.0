Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F80472521;
	Mon,  5 Oct 2026 09:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193614; cv=none; b=kUa+/k3+4QnDHWyRixlBBFO0V8D1lhyyVExZ81t5yNP+vm7LHL/yXePWPHwz0w8Rd/IavpJQB9F1fKsV8S8iOoDBwrNAJKMkYs6QUp7MKYPrsss1TvJpp3FOPCjQLw8gtJ5gQzOR9dZ2au7LCJX6rspJ3ero6eJ2BofR1BlhPNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193614; c=relaxed/simple;
	bh=/bXqUTCbOViNeLCYK/YFBU0BAv26EfmhgQg4hklhLd8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP6tx4WLAqoqN0xCt3X7GxlpTehxC37bBmdXHl9D8ZUwIdzC2Z6tolnsxrORiTnYGkLw/JA6E8DoyqFOEAM8i1ifJ/B5Bmw0KbOjLzu9igGhlxJoePLtD/Bvo5J9XZyAy7tK/6EoSpBxLOPyiJ3chSo69JZ35LmxGJMH0EGPU1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb4Hzd8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb4Hzd8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507011F0089B;
	Mon,  5 Oct 2026 09:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193602;
	bh=IxR+DpTsEIrtWGmUq7f4FMC9qpWmqPMYXravKOx7duE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=mb4Hzd8G+FR+SHcdTDFOP9Rc5cRYwhC9IAETl3SiV8zyKxN2PtFY9kITIx19rpmst
	 hPbVcmnGFNsnyOfEFH5gLgQZglgUxx4KlgENq2ekhQfLTAFd9u4hTFDPNtO5ZH9cMW
	 HGkdn6VHay+2SrxD4LjW/4AIY97jKTtryF7gMpmBrgPbJClFHYkysKljV1Rt46eUV+
	 2yM7pTf8GfUpvb+9Hb42DPoRSXVmFFekuL9Jn3C+E5zPag2eoWHGb9m8peHWH2F3zx
	 x00KcryfCN9dbBSKno6wPscqVu8SN/+3cUNjZkVhm+MNw4Fdp6fzjjDiRBhIR+N1al
	 l3kMgGwrVw6kQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7/7] scsi: sd_zbc: define storage element management operations
Date: Mon,  5 Oct 2026 18:46:32 +0900
Message-ID: <20261005094632.580753-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
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
 drivers/scsi/sd.c     |   1 +
 drivers/scsi/sd.h     |   4 +
 drivers/scsi/sd_zbc.c | 210 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e54..799d2093d667 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3937,6 +3937,7 @@ static const struct block_device_operations sd_fops = {
 	.get_unique_id		= sd_get_unique_id,
 	.free_disk		= scsi_disk_free_disk,
 	.pr_ops			= &sd_pr_ops,
+	.se_ops			= &sd_zbc_se_ops,
 };
 
 /**
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6a72371fee78..16a004a1e6f1 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -243,6 +243,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, struct blk_report_zones_args *args);
 
+extern const struct blk_storage_elements_ops sd_zbc_se_ops;
+
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
@@ -271,6 +273,8 @@ static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 
 #define sd_zbc_report_zones NULL
 
+#define sd_zbc_se_ops	NULL
+
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 2c77f878ab3f..586e0ab508ed 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -548,6 +548,216 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_info.zone_blocks);
 }
 
+#define SD_ZBC_STORAGE_ELEMENTS_BUF_SIZE	4096
+
+static void sd_zbc_parse_storage_element(struct scsi_disk *sdkp, u8 *desc,
+					 struct blk_storage_element *element)
+{
+	struct scsi_device *sdp = sdkp->device;
+	u64 capacity;
+
+	element->id = get_unaligned_be32(&desc[4]);
+
+	switch (desc[14]) {
+	case SCSI_PHYS_ELEM_TYPE_ALL_ACCESS_STORAGE:
+		element->paired_id = 0;
+		element->type = BLK_SE_TYPE_RDWR;
+		capacity = get_unaligned_be64(&desc[16]);
+		element->nr_zones = logical_to_sectors(sdp, capacity) >>
+			ilog2(sd_zbc_zone_sectors(sdkp));
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
+		element->status = BLK_SE_STS_UNKOWN;
+		break;
+	}
+}
+
+static int sd_zbc_report_storage_elements(struct gendisk *disk,
+					  unsigned int *nr_elements,
+					  struct blk_storage_element *elements)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	unsigned char cmd[16];
+	unsigned int nr_descs;
+	int i, ret = 0, result;
+	u8 *desc, *buf;
+
+	if (!sdkp->modify_zones_supported)
+		return -EOPNOTSUPP;
+
+	buf = kzalloc(SD_ZBC_STORAGE_ELEMENTS_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_GET_PHYSICAL_ELEMENT_STATUS;
+	put_unaligned_be32(SD_ZBC_STORAGE_ELEMENTS_BUF_SIZE, &cmd[10]);
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buf,
+				  SD_ZBC_STORAGE_ELEMENTS_BUF_SIZE,
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
+	for (i = 0; i < min(*nr_elements, nr_descs); i++, desc += 32)
+		sd_zbc_parse_storage_element(sdkp, desc, &elements[i]);
+	*nr_elements = nr_descs;
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

