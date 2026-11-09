Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217919;
	b=ArnomsO0m8bUWbJ/gI/6NWEy8QiSnLMD2KyA1Mg4OL5fQAY/oYZ3aJXsAZJLMVbO+mJy
	 ejU3ZQnmhf+15Mi0f1YzttKr9Zn8WSf78E8XnEO6N9UnHUwZMNyrUBeh92dFD5zrRntAu
	 kdKtU1FBzCNcSpvBgaWwnLrPw1rsA57/9qguadEVH3RWVbePLSqV3/VW0vSPQ0t2lPSi8
	 7UWRVnUyFCnz5XaHxhzGZYhyeN/VZo4aLSRS2Jtsy66zx7v081IxsGuuuSOkDJnTmEXXk
	 FTNKBfFud9JgARp9gd5xQieFxnK9vkUfjVFVrifiWpiVsL/B5z7CAR6uPeSZiAmAeLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217919;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ne63K4G+h5uz1JU4xeFiEEziMmQ4wZCxANVR4cqxlL4=;
	b=JXPkG5xouIUobvTQ3VvktwiHYcYb5ajsCU0E5pKcAnQXZD3snzoSy/ThNdKjdEPG5GMD
	 b6RKj22IETT9w8Ez1f+Wa/WdGz6mtxVTyMlqvm/bnq0hw/T8iQ8zQhdww5lT1KDEIOrlW
	 nGcs37JVu7r8yfkvh/o2evypLXZxMdyoMwr/hmBhKHX5KoPkXxOJ2G7ExAYaNgx8kl5+5
	 EctkbL4v2eQugFdKJm9nCfWGGCRJykjmK3QUqPNqnI0NcmtGwRUYET9jkScCF4J4d7vMV
	 g2jrSLz06nF3zCd5xIDpC/UU6A5VEhb1xFlVRbR3/XbM50dO6tRGHzwPVHsDxoJ6g8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MTPQ1/Q8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1638606D834;
	Mon,  9 Nov 2026 09:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTPQ1/Q8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE64A1F0089F;
	Mon,  9 Nov 2026 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217918;
	bh=ne63K4G+h5uz1JU4xeFiEEziMmQ4wZCxANVR4cqxlL4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MTPQ1/Q8WwfYolEnVh0HNygfFNJ+iPw4hybaJUEa0fQGZfFFTwTc9PMv4m4a5dxLg
	 keBpWzp+Xr1y+gP8NyLATDaQ465Mq/APSX54/S6Ela4Lbwk4QONJSvH6N5zPH6F/AK
	 g7mlm8oado8rgos8PtgQqt3W2k81MRPoCT0QnXyeCIuPzfzohuMAJTvzoltwoXvcQB
	 nxXiN6lkpaSqaY+jfR8vlKXOdeyLe3Ru9kB8rzAbvzQg27Pk1DQC1Lxu4AgeQrc2zH
	 QPF+oRr8pSE5Q8Gdv5ztxnqsU+yD+0+yc39OgcLoL2c9FufbbKS2dErUdNopZ4/HEu
	 sheOGL6XQKcRA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 11/12] scsi: sd_zbc: define storage element management operations
Date: Mon,  9 Nov 2026 18:51:43 +0900
Message-ID: <20261109095144.819709-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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
 drivers/scsi/sd_zbc.c | 471 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 476 insertions(+), 1 deletion(-)

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
index bf2e60071d57..3bad1392f0e2 100644
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
@@ -560,6 +573,462 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
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
+	nr_descs = get_unaligned_be32(&rep->buf[4]);
+	if (!nr_descs) {
+		sd_printk(KERN_ERR, sdkp,
+			"Invalid number of reported phys element descriptors\n");
+		return -EIO;
+	}
+
+	desc = &rep->buf[32];
+	for (i = 0; i < min(rep->nr_elements, nr_descs); i++, desc += 32)
+		sd_zbc_parse_storage_element(sdkp, desc, &rep->elements[i]);
+	rep->nr_reported_elements = i;
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
+	int ret, in_progress;
+	unsigned int i;
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
+
+		element_checked = false;
+		element_removed = false;
+		in_progress = 0;
+		for (i = 0; i < rep->nr_elements; i++) {
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
+			case BLK_SE_STS_REMOVE_ERROR:
+				if (rep->elements[i].id == element_id)
+					return -EIO;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (!element_checked)
+			return -EIO;
+		if (element_removed && !in_progress)
+			return 0;
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
+				      struct sd_zbc_se_report *rep)
+{
+	int ret, in_progress;
+	unsigned int i;
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
+
+		in_progress = 0;
+		for (i = 0; i < rep->nr_elements; i++) {
+			switch (rep->elements[i].status) {
+			case BLK_SE_STS_RESTORE_IN_PROGRESS:
+				in_progress++;
+				break;
+			case BLK_SE_STS_REMOVED:
+			case BLK_SE_STS_RESTORE_ERROR:
+				if (rep->elements[i].restore_allowed)
+					ret = -EIO;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (!in_progress)
+			return ret;
+	} while (!fatal_signal_pending(current));
+
+	return -EINTR;
+}
+
+static int sd_zbc_restore_storage_elements(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
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
+	/*
+	 * Execute the restore command and wait for the elements restoration
+	 * operation to complete.
+	 */
+	ret = sd_zbc_execute_storage_element_cmd(sdkp,
+					SAI_RESTORE_ELEMENTS_AND_REBUILD, 0);
+	if (!ret)
+		ret = sd_zbc_wait_for_se_restore(sdkp, &rep);
+	if (!ret)
+		sd_printk(KERN_NOTICE, sdkp, "Restored storage elements\n");
+
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

