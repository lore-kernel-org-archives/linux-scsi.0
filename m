Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAE18FC78
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717581117; cv=none; b=PkF4nZMhSwGNEnhDHltnU7tMWZ93ZzROPz8U7LB2u36hU7P5FANjj/hNmJNkm9x1OqtObfyoTuON56Jm0+nIeaarfQ3p0J76fqkKo2J6lqjzbsLvg0bcwWOCJ1+xSKP4FaKRP+kWjZrZExj9G+ihLPCRfLzil0uQc71TqfGu1ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717581117; c=relaxed/simple;
	bh=071vanPJTHSYSaEuZOYJA/qelMShIQMk08GSk3Oy448=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rf01pfMi6XUnFZ2aM/yWBpabRdHEHBgVVj0tqQY+w7N5DD+L7u0r12HnL5YaQNk9CWVkvbZisUWVAV1dBs52/lYCO60+CwBoOz4FkdimwoZQB6XMVCJJPnrpEjfJdM3hGWSjJnXTbtzk3wRWigp5ZUMxDGH5zVd2NTJUyJWhlS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GVQtzhBT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GVQtzhBT"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f62217f806so57526695ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jun 2024 02:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1717581115; x=1718185915; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MoOu+HaxjppCXYw7pFCb8xaStkIDhLjf3WnMyGYy3m8=;
        b=GVQtzhBT/cvwLJXO2p85DpQpBWVvhVu4vkBgsFvu4GYSyBuKbWTQQqIAhcGhr91ZGh
         8VbpOXu3/oCACE5zDnZctgtS6d0GW229DM4QEme9T/tEGGSgPgl9RjnjJOemqkkqGrMm
         9RyOwX+ktP3c/6O49UImKg6boFI82/An/ZA9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717581115; x=1718185915;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MoOu+HaxjppCXYw7pFCb8xaStkIDhLjf3WnMyGYy3m8=;
        b=kROCUyD/xZb2cMSY1ArxggpAY+WTgANCulpEwtYnMZHZtQe7bdTVjONcnYBFWQQQl+
         qT07FMM62pswXvLueB23mCD3fSYnAB2G2BTUH5vIdxeXSBFNq851oZHpeEMhLyoVWoF8
         QanHT9zAaoPE/ko2fz5gLPsueKRIVPJb3NEUUL70iEdD5XarypCNkXz/uah4wcuH4mn+
         /ArPA2ID0YBy0FfYjEttCqNHC1if/tLUNUNnpftwpfYslXht683P0FtdEFlMbydBSunS
         hPViFp8zRoVyDNpMH+BxfbYV+9mwlZkUOW3KA0KXFfEM60acU392aRFIlQaG2FEuVNDD
         lc6A==
X-Gm-Message-State: AOJu0YyNKHjyQnMRFxqEisgNsj+y1FV47wMdO+Q4323mf9b6p8hZLY72
	jlXhVHgHQUNr0OJL8kvRm35SNHNrayGw4AfOPn+L55s9h4RIgKzh0TETJPObctEq1a+5oO64a1n
	oqzBOPvlG9pjOnVVLVQNNLi74dT/dzxfmy7l6VKAmhK3r4UjhSXSHW7ILZfVFu9obHrDRjdxrgm
	8fdHw7u+J2h5x3bPqOeo1kTJ/hQx3XxXuObZGuItQ7uh5Hlg==
X-Google-Smtp-Source: AGHT+IHBbivPmrj/bbbzxeFNLH2W/QgH+Wutzu/4ADTeBeNUSzJwVMvfZdtA3eabfSpjlB2MnU4nRQ==
X-Received: by 2002:a17:903:25d1:b0:1f6:3693:1a3 with SMTP id d9443c01a7336-1f6a5a207b8mr19143765ad.33.1717581114666;
        Wed, 05 Jun 2024 02:51:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f673a9ef86sm58002285ad.56.2024.06.05.02.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:51:53 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 4/5] mpi3mr: Ioctl support for HDB
Date: Wed,  5 Jun 2024 15:18:39 +0530
Message-Id: <20240605094840.14968-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240605094840.14968-1-ranjan.kumar@broadcom.com>
References: <20240605094840.14968-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000003fd520061a21844e"

--0000000000003fd520061a21844e
Content-Transfer-Encoding: 8bit

This patch provides interfaces for applications
to manage the host diagnostic buffers and update
the automatic diag buffer capture triggers.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h        |  14 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 265 ++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_mpi3mr.h |   3 +-
 3 files changed, 281 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 36281aa07a93..1b9c2f976f46 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -201,6 +201,20 @@ extern atomic64_t event_counter;
 #define MPI3MR_HDB_TRIGGER_TYPE_SOFT_RESET      4
 #define MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED     5
 
+#define MPI3MR_HDB_REFRESH_TYPE_RESERVED	0
+#define MPI3MR_HDB_REFRESH_TYPE_CURRENT		1
+#define MPI3MR_HDB_REFRESH_TYPE_DEFAULT		2
+#define MPI3MR_HDB_HDB_REFRESH_TYPE_PERSISTENT	3
+
+#define MPI3MR_DEFAULT_HDB_SZ  (4 * 1024 * 1024)
+#define MPI3MR_MAX_NUM_HDB     2
+
+#define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_INDEX   0
+#define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_DATA    1
+
+
+
+
 /* Driver Host Diag Buffer (drv_db) */
 #define MPI3MR_MIN_DIAG_HOST_BUFFER_SZ		((32 * 1024) + \
 	sizeof(struct mpi3_driver_buffer_header))
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 7ad904153b1b..84a712cb87d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -940,6 +940,259 @@ static struct mpi3mr_ioc *mpi3mr_bsg_verify_adapter(int ioc_number)
 	return NULL;
 }
 
+/**
+ * mpi3mr_bsg_refresh_hdb_triggers - Refresh HDB trigger data
+ * @mrioc: Adapter instance reference
+ * @job: BSG Job pointer
+ *
+ * This function reads the controller trigger config page as
+ * defined by the input page type and refreshes the driver's
+ * local trigger information structures with the controller's
+ * config page data.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long
+mpi3mr_bsg_refresh_hdb_triggers(struct mpi3mr_ioc *mrioc,
+				struct bsg_job *job)
+{
+	struct mpi3mr_bsg_out_refresh_hdb_triggers refresh_triggers;
+	uint32_t data_out_sz;
+	u8 page_action;
+	long rval = -EINVAL;
+
+	data_out_sz = job->request_payload.payload_len;
+
+	if (data_out_sz != sizeof(refresh_triggers)) {
+		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
+		    __func__);
+		return rval;
+	}
+
+	if (mrioc->unrecoverable) {
+		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
+		    __func__);
+		return -EFAULT;
+	}
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		return -EAGAIN;
+	}
+
+	sg_copy_to_buffer(job->request_payload.sg_list,
+	    job->request_payload.sg_cnt,
+	    &refresh_triggers, sizeof(refresh_triggers));
+
+	switch (refresh_triggers.page_type) {
+	case MPI3MR_HDB_REFRESH_TYPE_CURRENT:
+		page_action = MPI3_CONFIG_ACTION_READ_CURRENT;
+		break;
+	case MPI3MR_HDB_REFRESH_TYPE_DEFAULT:
+		page_action = MPI3_CONFIG_ACTION_READ_DEFAULT;
+		break;
+	case MPI3MR_HDB_HDB_REFRESH_TYPE_PERSISTENT:
+		page_action = MPI3_CONFIG_ACTION_READ_PERSISTENT;
+		break;
+	default:
+		dprint_bsg_err(mrioc,
+		    "%s: unsupported refresh trigger, page_type %d\n",
+		    __func__, refresh_triggers.page_type);
+		return rval;
+	}
+	rval = mpi3mr_refresh_trigger(mrioc, page_action);
+
+	return rval;
+}
+
+/**
+ * mpi3mr_bsg_upload_hdb - Upload a specific HDB to user space
+ * @mrioc: Adapter instance reference
+ * @job: BSG Job pointer
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_bsg_upload_hdb(struct mpi3mr_ioc *mrioc,
+				  struct bsg_job *job)
+{
+	struct mpi3mr_bsg_out_upload_hdb upload_hdb;
+	struct diag_buffer_desc *diag_buffer;
+	uint32_t data_out_size;
+	uint32_t data_in_size;
+
+	data_out_size = job->request_payload.payload_len;
+	data_in_size = job->reply_payload.payload_len;
+
+	if (data_out_size != sizeof(upload_hdb)) {
+		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
+		    __func__);
+		return -EINVAL;
+	}
+
+	sg_copy_to_buffer(job->request_payload.sg_list,
+			  job->request_payload.sg_cnt,
+			  &upload_hdb, sizeof(upload_hdb));
+
+	if ((!upload_hdb.length) || (data_in_size != upload_hdb.length)) {
+		dprint_bsg_err(mrioc, "%s: invalid length argument\n",
+		    __func__);
+		return -EINVAL;
+	}
+	diag_buffer = mpi3mr_diag_buffer_for_type(mrioc, upload_hdb.buf_type);
+	if ((!diag_buffer) || (!diag_buffer->addr)) {
+		dprint_bsg_err(mrioc, "%s: invalid buffer type %d\n",
+		    __func__, upload_hdb.buf_type);
+		return -EINVAL;
+	}
+
+	if ((diag_buffer->status != MPI3MR_HDB_BUFSTATUS_RELEASED) &&
+	    (diag_buffer->status != MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED)) {
+		dprint_bsg_err(mrioc,
+		    "%s: invalid buffer status %d for type %d\n",
+		    __func__, diag_buffer->status, upload_hdb.buf_type);
+		return -EINVAL;
+	}
+
+	if ((upload_hdb.start_offset + upload_hdb.length) > diag_buffer->size) {
+		dprint_bsg_err(mrioc,
+		    "%s: invalid start offset %d, length %d for type %d\n",
+		    __func__, upload_hdb.start_offset, upload_hdb.length,
+		    upload_hdb.buf_type);
+		return -EINVAL;
+	}
+	sg_copy_from_buffer(job->reply_payload.sg_list,
+			    job->reply_payload.sg_cnt,
+	    (diag_buffer->addr + upload_hdb.start_offset),
+	    data_in_size);
+	return 0;
+}
+
+/**
+ * mpi3mr_bsg_repost_hdb - Re-post HDB
+ * @mrioc: Adapter instance reference
+ * @job: BSG job pointer
+ *
+ * This function retrieves the HDB descriptor corresponding to a
+ * given buffer type and if the HDB is in released status then
+ * posts the HDB with the firmware.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_bsg_repost_hdb(struct mpi3mr_ioc *mrioc,
+				  struct bsg_job *job)
+{
+	struct mpi3mr_bsg_out_repost_hdb repost_hdb;
+	struct diag_buffer_desc *diag_buffer;
+	uint32_t data_out_sz;
+
+	data_out_sz = job->request_payload.payload_len;
+
+	if (data_out_sz != sizeof(repost_hdb)) {
+		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
+		    __func__);
+		return -EINVAL;
+	}
+	if (mrioc->unrecoverable) {
+		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
+		    __func__);
+		return -EFAULT;
+	}
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		return -EAGAIN;
+	}
+
+	sg_copy_to_buffer(job->request_payload.sg_list,
+			  job->request_payload.sg_cnt,
+			  &repost_hdb, sizeof(repost_hdb));
+
+	diag_buffer = mpi3mr_diag_buffer_for_type(mrioc, repost_hdb.buf_type);
+	if ((!diag_buffer) || (!diag_buffer->addr)) {
+		dprint_bsg_err(mrioc, "%s: invalid buffer type %d\n",
+		    __func__, repost_hdb.buf_type);
+		return -EINVAL;
+	}
+
+	if (diag_buffer->status != MPI3MR_HDB_BUFSTATUS_RELEASED) {
+		dprint_bsg_err(mrioc,
+		    "%s: invalid buffer status %d for type %d\n",
+		    __func__, diag_buffer->status, repost_hdb.buf_type);
+		return -EINVAL;
+	}
+
+	if (mpi3mr_issue_diag_buf_post(mrioc, diag_buffer)) {
+		dprint_bsg_err(mrioc, "%s: post failed for type %d\n",
+		    __func__, repost_hdb.buf_type);
+		return -EFAULT;
+	}
+	mpi3mr_set_trigger_data_in_hdb(diag_buffer,
+	    MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN, NULL, 1);
+
+	return 0;
+}
+
+/**
+ * mpi3mr_bsg_query_hdb - Handler for query HDB command
+ * @mrioc: Adapter instance reference
+ * @job: BSG job pointer
+ *
+ * This function prepares and copies the host diagnostic buffer
+ * entries to the user buffer.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
+				 struct bsg_job *job)
+{
+	long rval = 0;
+	struct mpi3mr_bsg_in_hdb_status *hbd_status;
+	struct mpi3mr_hdb_entry *hbd_status_entry;
+	u32 length, min_length;
+	u8 i;
+	struct diag_buffer_desc *diag_buffer;
+	uint32_t data_in_sz = 0;
+
+	data_in_sz = job->request_payload.payload_len;
+
+	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
+		    sizeof(*hbd_status_entry)));
+	hbd_status = kmalloc(length, GFP_KERNEL);
+	if (!hbd_status)
+		return -ENOMEM;
+	hbd_status_entry = &hbd_status->entry[0];
+
+	hbd_status->num_hdb_types = MPI3MR_MAX_NUM_HDB;
+	for (i = 0; i < MPI3MR_MAX_NUM_HDB; i++) {
+		diag_buffer = &mrioc->diag_buffers[i];
+		hbd_status_entry->buf_type = diag_buffer->type;
+		hbd_status_entry->status = diag_buffer->status;
+		hbd_status_entry->trigger_type = diag_buffer->trigger_type;
+		memcpy(&hbd_status_entry->trigger_data,
+		    &diag_buffer->trigger_data,
+		    sizeof(hbd_status_entry->trigger_data));
+		hbd_status_entry->size = (diag_buffer->size / 1024);
+		hbd_status_entry++;
+	}
+	hbd_status->element_trigger_format =
+		MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_DATA;
+
+	if (data_in_sz < 4) {
+		dprint_bsg_err(mrioc, "%s: invalid size passed\n", __func__);
+		rval = -EINVAL;
+		goto out;
+	}
+	min_length = min(data_in_sz, length);
+	if (job->request_payload.payload_len >= min_length) {
+		sg_copy_from_buffer(job->request_payload.sg_list,
+				    job->request_payload.sg_cnt,
+				    hbd_status, min_length);
+		rval = 0;
+	}
+out:
+	kfree(hbd_status);
+	return rval;
+}
+
+
 /**
  * mpi3mr_enable_logdata - Handler for log data enable
  * @mrioc: Adapter instance reference
@@ -1368,6 +1621,18 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
 	case MPI3MR_DRVBSG_OPCODE_PELENABLE:
 		rval = mpi3mr_bsg_pel_enable(mrioc, job);
 		break;
+	case MPI3MR_DRVBSG_OPCODE_QUERY_HDB:
+		rval = mpi3mr_bsg_query_hdb(mrioc, job);
+		break;
+	case MPI3MR_DRVBSG_OPCODE_REPOST_HDB:
+		rval = mpi3mr_bsg_repost_hdb(mrioc, job);
+		break;
+	case MPI3MR_DRVBSG_OPCODE_UPLOAD_HDB:
+		rval = mpi3mr_bsg_upload_hdb(mrioc, job);
+		break;
+	case MPI3MR_DRVBSG_OPCODE_REFRESH_HDB_TRIGGERS:
+		rval = mpi3mr_bsg_refresh_hdb_triggers(mrioc, job);
+		break;
 	case MPI3MR_DRVBSG_OPCODE_UNKNOWN:
 	default:
 		pr_err("%s: unsupported driver command opcode %d\n",
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index c72ce387286a..92a0eb190e1c 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -296,6 +296,7 @@ struct mpi3mr_hdb_entry {
  * multiple hdb entries.
  *
  * @num_hdb_types: Number of host diag buffer types supported
+ * @element_trigger_format: Element trigger format
  * @rsvd1: Reserved
  * @rsvd2: Reserved
  * @rsvd3: Reserved
@@ -303,7 +304,7 @@ struct mpi3mr_hdb_entry {
  */
 struct mpi3mr_bsg_in_hdb_status {
 	__u8	num_hdb_types;
-	__u8	rsvd1;
+	__u8    element_trigger_format;
 	__u16	rsvd2;
 	__u32	rsvd3;
 	struct mpi3mr_hdb_entry entry[1];
-- 
2.31.1


--0000000000003fd520061a21844e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO6bxJ1v+TMLWVKDZMWdf017H9uZ7nmc
CmedpItLGNbFMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDYw
NTA5NTE1NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCEEI3fyq4tGi9jKZoL3SRpYRdwQICCkXEhUaJKorz1gOYLmLSa
y69MoVlUvBqd9w65Ur4kV0HlXOSRsbeRkrbq97wEwVaLfNocdyJShe11Q2qZcUgAVI5mXFxnsHVz
Rmt3w8EgFxQ6fXZTmkKaG24VIidMQMRXigGceKpATcurw+DCB4X9z+oz4m1PuVkAhbgSVUfM32ze
U5k3zmnkLoB+0tujvTrFI9xuQlD/yEdI4sbrCK4D3cKUXewT+tSTRW072LcPLFqNl67jmboAmQZY
Sc+SafGortBGazBNiQornJVkwXMTSisCarE3Je26GnuYYLUxWg3O6YluiFaipp+q
--0000000000003fd520061a21844e--
