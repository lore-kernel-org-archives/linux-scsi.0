Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754232;
	b=MdwmBEeNP/C+VwU/7I5mXTeIhtB0mq37IetzoAO229+XWmNEtWmBQ2cITrt9AjoCcSws
	 FoDhaOkZAQsk4tdEbg6MC8xK01pfqFitI5w+8w4QVtYkGWt+QcseJ79OzC+hR3OyTHjvD
	 X6dTQCup0j9R/+Z7floiplHVDGnn2zdRHth9xRRO5IoGUis8ovQouVau83eUER7Ny/Txn
	 EBO5jvK4H4uzXMcluMYjc+77qbBZXgZa/4/rMPHSGpfmpBKEheZa8kC5V2QRWPwRPlVYa
	 wTnog8mUX8IM6gXLJ6EBInvG6LRWlw3HzHSvI3wvgtis+tcnXHtt2WHdzvpLiox8xBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754232;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=KWL1TOPKw9prHLBXFYUBw5ZHPf8SaEPCQKHH9+UHlSY=;
	b=KA9kYV3Jj6lYHo3b48PwKheAFCYeF2MJ/41EDwxWal1ToCOJAsJ0FPYLiXSNDcObDPG0
	 UQ++zywOuIVc+vi9dbTG6fKG/BJNUox/Y7ogDgdjDeICZewXQ8hiPCfvnbcPQCfzyGigY
	 hulveMSczlS3QDBFK680+Xs0MZPyGn4syUS4kRfOP71kjXjLZ5qtGXAKhZnMH/zHns5rb
	 oOgF8RdwwD8uJpYOcvZU7vApKr57++cSM/6WyDl8klsPyYySkZHVL9Dgmed3BOriQrUc6
	 3KRjRJwyO8yTrt1tWAKjxtlqxic1yAbe7XK7KGAXle3UiLELu3kTv54+xOcX8fLq0tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZaMGkLhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED26606A333;
	Sun, 15 Nov 2026 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZaMGkLhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D4A1F000C5;
	Sun, 15 Nov 2026 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754232;
	bh=KWL1TOPKw9prHLBXFYUBw5ZHPf8SaEPCQKHH9+UHlSY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZaMGkLhijJM9FaZpzHqzmeVQ3GFuJMAAthuilYUam7fytsuhDwO8WG0fLLW8uSQSJ
	 4UJavbaDnHpuoFULWpyPcjnubIELHvsb/LLNHhbHTOb9yt/kS3hVGQOvmhohasJ0TO
	 89oA+zsuuGNZiBVL/Ahuh5y5J+ZZgSUBSwQXKyVjuoQeCsO+qfU9tdYWQ0r+9fT+so
	 EnN+2ZSxMzzxBS/3aA9Bc+Tjyb0bDqTCitnDMvZy0YiUXS/NLMawA0xRzrAE8SKzOw
	 D4DZozUwpy76s960n2t1VDJ8xFaSem/0xJEHnFXWsWdso74+nDoQI1vBoIeTNRrg48
	 slNVJyvpxf2uQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 12/13] scsi: sd_zbc: define storage element management operations
Date: Sun, 15 Nov 2026 23:50:14 +0900
Message-ID: <20261115145015.938426-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the storage element management operations using struct blk_se_ops.
These operations are valid only on SMR disks supporting the storage
element depopulation featu, with support for the GET PHYSICAL ELEMENTS
STATUS command being mandatory. The support for the modify_zones operation
is already indicated by the depop_modify_zones_supported SCSI disk flag.
sd_zbc_check_depop_supported() is modified to add detection for the
command RESTORE ELEMENTS AND REBUILD, which is indicated with the new
SCSI disk flag depop_restore_supported.

Both the remove_element and restore_elements operations will block
until the operation completes or an error is detected.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c     |   3 +
 drivers/scsi/sd.h     |   3 +
 drivers/scsi/sd_zbc.c | 493 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 498 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..34b44d72b2b7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3939,6 +3939,9 @@ static const struct block_device_operations sd_fops = {
 	.get_unique_id		= sd_get_unique_id,
 	.free_disk		= scsi_disk_free_disk,
 	.pr_ops			= &sd_pr_ops,
+#ifdef CONFIG_BLK_DEV_ZONED
+	.se_ops			= &sd_zbc_se_ops,
+#endif
 };
 
 /**
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 84c87d0f05d8..8a32e5f771d8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -158,6 +158,7 @@ struct scsi_disk {
 	unsigned	use_atomic_write_boundary : 1;
 	unsigned	depop_report_supported : 1;
 	unsigned	depop_modify_zones_supported : 1;
+	unsigned	depop_restore_supported : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
@@ -244,6 +245,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int nr_zones, struct blk_report_zones_args *args);
 
+extern const struct blk_se_ops sd_zbc_se_ops;
+
 #else /* CONFIG_BLK_DEV_ZONED */
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bf2e60071d57..6322256028aa 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -12,6 +12,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 
 #include <linux/unaligned.h>
 
@@ -522,7 +523,8 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
  * @sdkp: Target SCSI disk
  * @buf: command buffer
  *
- * Check if the device supports the REMOVE ELEMENT AND MODIFY ZONES command.
+ * Check if the device supports the storage elements depopulation management
+ * commands.
  */
 static void sd_zbc_check_depop_supported(struct scsi_disk *sdkp,
 					 unsigned char *buf)
@@ -534,6 +536,7 @@ static void sd_zbc_check_depop_supported(struct scsi_disk *sdkp,
 				   SAI_GET_PHYSICAL_ELEMENT_STATUS) == 1;
 	if (!sdkp->depop_report_supported) {
 		sdkp->depop_modify_zones_supported = false;
+		sdkp->depop_restore_supported = false;
 		return;
 	}
 
@@ -541,6 +544,11 @@ static void sd_zbc_check_depop_supported(struct scsi_disk *sdkp,
 		scsi_report_opcode(sdkp->device, buf, SD_BUF_SIZE,
 				   SERVICE_ACTION_IN_16,
 				   SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES) == 1;
+
+	sdkp->depop_restore_supported =
+		scsi_report_opcode(sdkp->device, buf, SD_BUF_SIZE,
+				   SERVICE_ACTION_IN_16,
+				   SAI_RESTORE_ELEMENTS_AND_REBUILD) == 1;
 }
 
 static void sd_zbc_print_zones(struct scsi_disk *sdkp)
@@ -548,6 +556,11 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 	if (sdkp->device->type != TYPE_ZBC || !sdkp->capacity)
 		return;
 
+	if (sdkp->depop_modify_zones_supported)
+		sd_printk(KERN_NOTICE, sdkp, "Depop modify zones supported\n");
+	if (sdkp->depop_restore_supported)
+		sd_printk(KERN_NOTICE, sdkp, "Depop restoration supported\n");
+
 	if (sdkp->capacity & (sdkp->zone_info.zone_blocks - 1))
 		sd_printk(KERN_NOTICE, sdkp,
 			  "%u zones of %u logical blocks + 1 runt zone\n",
@@ -560,6 +573,484 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
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
+	element->restore_allowed = desc[13] & 0x01;
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
+	if (desc[15] >= SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN &&
+	    desc[15] <= SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX) {
+		element->status = BLK_SE_STS_OK;
+		return;
+	}
+
+	if (desc[15] >= SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN &&
+	    desc[15] <= SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX) {
+		element->status = BLK_SE_STS_DEGRADED;
+		return;
+	}
+
+	switch (desc[15]) {
+	case SCSI_PHYS_ELEM_HEALTH_AT_SPEC_LIMITS:
+		element->status = BLK_SE_STS_OK_LIMIT;
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
+struct sd_zbc_se_report {
+	struct blk_se *elements;
+	unsigned int nr_elements;
+	unsigned int nr_reported_elements;
+	bool need_free_elements;
+	u8 *buf;
+	unsigned int buf_size;
+};
+
+static int sd_zbc_alloc_se_report(struct blk_se *elements,
+				  unsigned int nr_elements,
+				  bool alloc_elements,
+				  struct sd_zbc_se_report *rep)
+{
+	/*
+	 * We need at least 32B for the report header and 32B for each
+	 * descriptor. Note that we use GFP_KERNEL here, which may block. That
+	 * is fine when called from ioctl context. When called from a file
+	 * system, the FS can use memalloc_noio_save()/restore() or
+	 * memalloc_nofs_save()/restore() if GFP_NOFS is required to avoid I/Os
+	 * and/or FS re-entry.
+	 */
+	rep->need_free_elements = alloc_elements;
+	rep->nr_elements = min(SD_ZBC_MAX_STORAGE_ELEMENTS, nr_elements);
+	rep->buf_size = ALIGN((rep->nr_elements + 1) * 32, SECTOR_SIZE);
+	rep->buf = kzalloc(rep->buf_size, GFP_KERNEL);
+	if (!rep->buf)
+		return -ENOMEM;
+
+	if (!alloc_elements) {
+		rep->elements = elements;
+		return 0;
+	}
+
+	rep->elements =
+		kzalloc_objs(struct blk_se, rep->nr_elements, GFP_KERNEL);
+	if (!rep->elements) {
+		kfree(rep->buf);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void sd_zbc_free_se_report(struct sd_zbc_se_report *rep)
+{
+	kfree(rep->buf);
+	if (rep->need_free_elements)
+		kfree(rep->elements);
+}
+
+static int sd_zbc_report_se(struct scsi_disk *sdkp,
+			    struct sd_zbc_se_report *rep)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/* Allow up to retry 3 times */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
+	unsigned char cmd[16];
+	unsigned int nr_descs;
+	int i, result;
+	u8 *desc;
+
+	memset(cmd, 0, 16);
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = SAI_GET_PHYSICAL_ELEMENT_STATUS;
+	put_unaligned_be32(rep->buf_size, &cmd[10]);
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+			rep->buf, rep->buf_size, timeout, 1, &exec_args);
+	if (result) {
+		if (result > 0) {
+			sd_print_result(sdkp, "GET PHYSICAL ELEMENT STATUS",
+					result);
+			if (scsi_sense_valid(&sshdr))
+				sd_print_sense_hdr(sdkp, &sshdr);
+			return -EIO;
+		}
+		return result;
+	}
+
+	nr_descs = get_unaligned_be32(&rep->buf[0]);
+	if (!nr_descs) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Invalid number of phys element descriptors\n");
+		return -EIO;
+	}
+	if (nr_descs > SD_ZBC_MAX_STORAGE_ELEMENTS) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Too many phys element descriptors\n");
+		return -EIO;
+	}
+
+	if (!rep->elements) {
+		rep->nr_reported_elements = nr_descs;
+		return 0;
+	}
+
+	rep->nr_reported_elements =
+		min(rep->nr_elements, get_unaligned_be32(&rep->buf[4]));
+	if (!rep->nr_reported_elements) {
+		sd_printk(KERN_ERR, sdkp,
+			"Invalid number of reported phys element descriptors\n");
+		return -EIO;
+	}
+
+	desc = &rep->buf[32];
+	for (i = 0; i < rep->nr_reported_elements; i++, desc += 32)
+		sd_zbc_parse_storage_element(sdkp, desc, &rep->elements[i]);
+
+	return 0;
+}
+
+static int sd_zbc_report_storage_elements(struct gendisk *disk,
+					  struct blk_se *elements,
+					  unsigned int *nr_elements)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct sd_zbc_se_report rep;
+	int ret;
+
+	if (!sdkp->depop_report_supported)
+		return -EOPNOTSUPP;
+
+	ret = sd_zbc_alloc_se_report(elements, *nr_elements, false, &rep);
+	if (ret)
+		return ret;
+
+	ret = sd_zbc_report_se(sdkp, &rep);
+	if (!ret)
+		*nr_elements = rep.nr_reported_elements;
+
+	sd_zbc_free_se_report(&rep);
+
+	return ret;
+}
+
+static int sd_zbc_execute_storage_element_cmd(struct scsi_disk *sdkp,
+					      u8 action, u32 element_id)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	unsigned char cmd[16];
+	const char *cmd_name;
+	int result;
+
+	memset(cmd, 0, sizeof(cmd));
+	cmd[0] = SERVICE_ACTION_IN_16;
+	cmd[1] = action;
+	if (action == SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES) {
+		put_unaligned_be32(element_id, &cmd[10]);
+		cmd_name = "REMOVE ELEMENT AND MODIFY ZONES";
+	} else {
+		cmd_name = "RESTORE ELEMENTS AND REBUILD";
+	}
+
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				  timeout, 1, &exec_args);
+	if (result) {
+		sd_printk(KERN_ERR, sdkp, "%s failed\n", cmd_name);
+		if (result > 0) {
+			if (scsi_sense_valid(&sshdr))
+				sd_print_sense_hdr(sdkp, &sshdr);
+			result = -EIO;
+		}
+		return result;
+	}
+
+	return 0;
+}
+
+/*
+ * Wait for the completion of a storage element remove operation. Note that the
+ * standards advise to use pollable sense data with the REQUEST SENSE command to
+ * detect if a remove operation is in progress. However, since REQUEST SENSE
+ * will return sense data only for the last executed command, and since we are
+ * not blocking commands, this method would be unreliable as we may end up
+ * seeing sense data (or no sense data) for a command that is not the REMOVE
+ * ELEMENT AND MODIFY ZONES we issued.
+ */
+static int sd_zbc_wait_for_se_removal(struct scsi_disk *sdkp,
+				      struct sd_zbc_se_report *rep,
+				      unsigned int element_id)
+{
+	bool element_checked, element_removed;
+	unsigned int i, in_progress;
+	int ret;
+
+	/*
+	 * Poll the storage elements health to see that we get the element we
+	 * are interested in and that its removal completed. Since we do not
+	 * know how long the operation may take, we cannot have a timeout on
+	 * this loop. So check for fatal signals so that the user can terminate
+	 * this loop if the device misbehaves.
+	 */
+	do {
+		/* Let the operation proceed and check. */
+		msleep(1000);
+
+		ret = sd_zbc_report_se(sdkp, rep);
+		if (ret)
+			return ret;
+		if (rep->nr_reported_elements != rep->nr_elements)
+			return -EIO;
+
+		element_checked = false;
+		element_removed = false;
+		in_progress = 0;
+		for (i = 0; i < rep->nr_reported_elements; i++) {
+			if (rep->elements[i].id == element_id)
+				element_checked = true;
+			switch (rep->elements[i].status) {
+			case BLK_SE_STS_REMOVED:
+				if (rep->elements[i].id == element_id)
+					element_removed = true;
+				break;
+			case BLK_SE_STS_REMOVE_IN_PROGRESS:
+				in_progress++;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (!element_checked)
+			return -EIO;
+		if (!in_progress) {
+			if (element_removed)
+				return 0;
+			return -EIO;
+		}
+	} while (!fatal_signal_pending(current));
+
+	return -EINTR;
+}
+
+static int sd_zbc_remove_storage_element(struct gendisk *disk,
+					 unsigned int element_id)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct sd_zbc_se_report rep;
+	int ret;
+
+	if (!sdkp->depop_modify_zones_supported)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Get the resources we need to prepare for waiting for the operation to
+	 * complete.
+	 */
+	ret = sd_zbc_alloc_se_report(NULL, disk->nr_storage_elements,
+				     true, &rep);
+	if (ret)
+		return ret;
+
+	/*
+	 * Execute the remove command and wait for the element removal operation
+	 * to complete.
+	 */
+	ret = sd_zbc_execute_storage_element_cmd(sdkp,
+			SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES, element_id);
+	if (!ret)
+		ret = sd_zbc_wait_for_se_removal(sdkp, &rep, element_id);
+	if (!ret)
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Removed storage element %u\n", element_id);
+
+	sd_zbc_free_se_report(&rep);
+
+	return ret;
+}
+
+/*
+ * Wait for the completion of the restoration of removed storage elements.
+ * See the note for sd_zbc_wait_for_se_removal().
+ */
+static int sd_zbc_wait_for_se_restore(struct scsi_disk *sdkp,
+				      struct sd_zbc_se_report *rep,
+				      unsigned int in_error_orig)
+{
+	unsigned int i, in_error, in_progress;
+	int ret;
+
+	/*
+	 * Poll the storage elements health to see if we have any element still
+	 * being restored or if we got errors. Since we do not know how long the
+	 * operation may take, we cannot have a timeout on this loop. So check
+	 * for fatal signals so that the user can terminate this retry loop if
+	 * the device misbehaves.
+	 */
+	do {
+		/* Let the operation proceed and check. */
+		msleep(1000);
+
+		ret = sd_zbc_report_se(sdkp, rep);
+		if (ret)
+			return ret;
+		if (rep->nr_reported_elements != rep->nr_elements)
+			return -EIO;
+
+		in_progress = 0;
+		in_error = 0;
+		for (i = 0; i < rep->nr_reported_elements; i++) {
+			switch (rep->elements[i].status) {
+			case BLK_SE_STS_RESTORE_IN_PROGRESS:
+				in_progress++;
+				break;
+			case BLK_SE_STS_RESTORE_ERROR:
+				in_error++;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (!in_progress) {
+			if (in_error > in_error_orig)
+				return -EIO;
+			return 0;
+		}
+	} while (!fatal_signal_pending(current));
+
+	return -EINTR;
+}
+
+static int sd_zbc_restore_storage_elements(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	unsigned int i, in_error_orig = 0;
+	struct sd_zbc_se_report rep;
+	int ret;
+
+	if (!sdkp->depop_restore_supported)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Get the resources we need to prepare for waiting for the operation to
+	 * complete.
+	 */
+	ret = sd_zbc_alloc_se_report(NULL, disk->nr_storage_elements,
+				     true, &rep);
+	if (ret)
+		return ret;
+
+	/* To detect restoration errors, count the number of such elements. */
+	ret = sd_zbc_report_se(sdkp, &rep);
+	if (ret)
+		goto free;
+	if (rep.nr_reported_elements != rep.nr_elements) {
+		ret = -EIO;
+		goto free;
+	}
+
+	for (i = 0; i < rep.nr_reported_elements; i++) {
+		if (rep.elements[i].status == BLK_SE_STS_RESTORE_ERROR)
+			in_error_orig++;
+	}
+
+	/*
+	 * Execute the restore command and wait for the elements restoration
+	 * operation to complete.
+	 */
+	ret = sd_zbc_execute_storage_element_cmd(sdkp,
+					SAI_RESTORE_ELEMENTS_AND_REBUILD, 0);
+	if (!ret)
+		ret = sd_zbc_wait_for_se_restore(sdkp, &rep, in_error_orig);
+	if (!ret)
+		sd_printk(KERN_NOTICE, sdkp, "Restored storage elements\n");
+
+free:
+	sd_zbc_free_se_report(&rep);
+
+	return ret;
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
2.56.0

