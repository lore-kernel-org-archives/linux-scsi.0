Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A52617CA1F
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719397812; cv=none; b=exShlDKpQGsGUKEi1plBzCI6u/ZLC7ZfFkfeSHAvHUuC+SqpJq/+9QZsnZgEDDMCdegwRifmDDXaaXAz0o7P53VhCfSahOavIUoCoftMs4iQgKt/awC08Lx1IAL4289BG5kwojRRMCB5H5zyjSfLVFwH1bMCxl7WnVWr8OOBM8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719397812; c=relaxed/simple;
	bh=JbyaOXLkzzj6E3O3ZIabJ3AHHsK0KKVjRogogEeK8xI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iz2id90rGk5C3Kpj61q9Ta9svmI5W34PolObztGpA7i4UOoLKG+D9M3DmO/5RkjlWeZ4ZKNYhO0oAKFisUP7NJ7IbNnrfNvvdaJuLLhvs4OpK4oa4P8iZzIp55hOAfEsdxXoEPf1AuMP59/S3mtqvwY+M/oUbD7jNr4XWOh2kuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UjgXCSWi; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UjgXCSWi"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f4a5344ec7so3132815ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1719397809; x=1720002609; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=njUZ7oUPjB02cu2liRJ4f6d+XNkRKbPLaaAjGz84bo4=;
        b=UjgXCSWi2EydFT1ftnnNzmRSklnDV8H88Epmz5Mk9wcSYy7jr+lH0UA0zaMn2hGW6V
         8WR//rx/Og0U/yHt4hA332U55cNv5Noa7NtTob6n1H74t1usHSH3sWQCad1PzeFK5TTH
         cF62X4P9iRBtnvCpFKE7r+NsWW5HOj0WaITq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719397809; x=1720002609;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njUZ7oUPjB02cu2liRJ4f6d+XNkRKbPLaaAjGz84bo4=;
        b=KqbAy7A2ICPoLnPm/sqVRe9J0prn8hu0f1WWpel5fvKVgJEh7PP9t3/jNO5+H+DeFG
         i70ES96qj8Uczslia5PWBkaPu5fZUr9JDucPoFIJgRX6KC0mHO2K0Sp6lRwyvH1qad/D
         jbTH6kL+Ol3RMAdkksoGQGcyxbDKeo8IsB978iSeeETtWrClP8dcbUzz7wNQVLJGXEqz
         h6ldSs3DuG5c9ePMLGVnKiYCO4X35kNcYL/UAPht0+2uNCfH4lvbWADzBBrPwYWYZv41
         2DekkZqg5ktMSZ4s4tOwCwJtzAtBQMIUC68WGgf7Wo7psxRYySW0JiOx1yU5tLCnGqTK
         z4uQ==
X-Gm-Message-State: AOJu0Yy83nTx6RZhyMq8jtW43WjssaUNcOeBoaGonWt0OCW/IsE5kvVf
	CHEvohMQCOuy6k3d1dYf5DXgwAQ2ksLXtWkRw0xVirUimOLc7XfS1mf2LbKYkYx6iEULECX1bm0
	sJQqy2cxN2syYcTkweskT8zCqTYrqbm0vJrRMx62rVWKNkEhXSSm7roloak+Nl0ucOAE4aJg61n
	rZBOgr5/5JebxgvvOL808V6l/6kN4kdUvjxO9eIhGuuHG42A==
X-Google-Smtp-Source: AGHT+IFGwXuQGNde4Oe+fd+KGx8ZvCvZ/qtL3cEoKNvBnyrEf7c8gT2dsWr7lR4vr49i0GfrFQ62gw==
X-Received: by 2002:a17:903:41cc:b0:1fa:918e:eae with SMTP id d9443c01a7336-1fa918e110dmr11891035ad.37.1719397808593;
        Wed, 26 Jun 2024 03:30:08 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9ebbc7ccasm96051055ad.299.2024.06.26.03.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:30:07 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v6 3/4] mpi3mr: ioctl support for HDB
Date: Wed, 26 Jun 2024 15:56:45 +0530
Message-Id: <20240626102646.14298-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
References: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a5a6d3061bc87fab"

--000000000000a5a6d3061bc87fab
Content-Transfer-Encoding: 8bit

Add interface for applications to manage the host diagnostic buffers
and update the automatic diag buffer capture triggers.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h        |  12 ++
 drivers/scsi/mpi3mr/mpi3mr_app.c    | 265 ++++++++++++++++++++++++++++
 include/uapi/scsi/scsi_bsg_mpi3mr.h |   3 +-
 3 files changed, 279 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e14982a785a6..1c604ed24c6e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -200,6 +200,18 @@ extern atomic64_t event_counter;
 #define MPI3MR_HDB_TRIGGER_TYPE_SOFT_RESET	4
 #define MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED	5
 
+#define MPI3MR_HDB_REFRESH_TYPE_RESERVED       0
+#define MPI3MR_HDB_REFRESH_TYPE_CURRENT                1
+#define MPI3MR_HDB_REFRESH_TYPE_DEFAULT                2
+#define MPI3MR_HDB_HDB_REFRESH_TYPE_PERSISTENT 3
+
+#define MPI3MR_DEFAULT_HDB_SZ  (4 * 1024 * 1024)
+#define MPI3MR_MAX_NUM_HDB     2
+
+#define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_INDEX   0
+#define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_DATA    1
+
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 85c69ba105d8..f73f265c7921 100644
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
index a3ba779a3f78..f5ea1db92339 100644
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


--000000000000a5a6d3061bc87fab
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDExX4+q15YXlYbDuOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjExMTQxMjAzMThaFw0yNTExMTQxMjAzMThaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFJhbmphbiBLdW1hcjEoMCYGCSqGSIb3DQEJ
ARYZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOgccBnKTcRY5ViAG6iAGKWZ8pjYBaC0yPSOnu903VijdPFPnRdvshVcVxr6QvmlBCzKJaet
zZlOdDzH9Sh5FfHxwia1H790mce+cjggA6koNdslP25m4SfoAUcvLxNk1koVjbyxvNPG40Mlg8f8
Dp9JubCHz3kEFHjItKFkpS8CHMR1Hx4Cnws434zD/pz1TMUmYyq1kma0Vi8YPVlwkaHgq4J/9Lw/
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEm0U13hiyXXIrECN/Huebkew2gkKlTS
u0eQZ+pJHoV/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDYy
NjEwMzAwOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAMiyqw1Dx/3xGWw7/j85Jeac5ZIj8wMKpaCYOYkbzjSso2uV1z
5zERz1ihZnTuH+QY0/lXNqXUstH8Dnex3BjsF3XgmK0WuPgogg5dIEwymxgAv+iQdvmuSB1Lnjzd
ApP8TuoiljYOxWvRsfJq+8z9wz7RYO0ze7fq+vHXIbO5Xf76XkbxpLakNozg+hNNtdQk8afwvdva
Q7oEJjrR22C4wDthhBq9cQZ0EMfordGqb5VPbIKihH+LXAwZ6fr4UAb9fo6+H4u69wg2joLNPL4O
QElU5Zl90Z7SGNJdqbG6TjnbtrOhBM5y0QLwAV7/wxNg4utNHrlZyRh1YVSUTMxB
--000000000000a5a6d3061bc87fab--
