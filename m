Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FBB1E491
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715872999; cv=none; b=RXCT3mNkrJ+9N++a5YSsiYdX0mMSj7Abytunh0v3/bM9fQSpfe7SUXlbk7oKgJf7x8NCsD6MEUupnBkN9PKNK9e+YOBMC1w87nEKohtTX4VuKLSo9yhdG1gmQvAro9Yt6gW27GkkoG1P3znYTotrEjJwkxP9ywohvTAssAzt3Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715872999; c=relaxed/simple;
	bh=Oirm+I96aBz5GGnAy/zr/FCvINMvUIMEPfHVp287/c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyUaROAq3aHBgZcvGZ6U27XcUm76dMRj8Ob5/GAe7F8g/9N9QarJsC+1HXXQ512n+hZarJXAjKmZLU+16nIvKoNNocU9zY7pv0dvoVY2QTN81DV2QhdJtpj55uqrN5zJjgERoRTtD5xjaw626eM6lTmqYOo4Ri9ojyKzCLwOWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MCnpImwd; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MCnpImwd"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6f43ee95078so320750b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 08:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715872996; x=1716477796; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=f3Dq3mk1WS5OdXWgkd92Q0QW7IXBjuwPUCl6iAYZ5ZI=;
        b=MCnpImwdkx0VsUE8//BYkQ63x0emtU7iO91eid1MLqtparOKgp9cvmMmFvZC8qILsA
         DpbJLsf/ruLUSMbKqo/CjNLNbkMjT5g5/kG9e2dylTdRAQpaismxPpm3C2jjtwrB/RF9
         cQLfBCF4VtSmgkutczuHx3p5FvG9od6LLTd/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715872996; x=1716477796;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3Dq3mk1WS5OdXWgkd92Q0QW7IXBjuwPUCl6iAYZ5ZI=;
        b=MyD0MA+vGzQAbrGnAsdB/ggMB0OyyZIZLmBHPeKZ/GnOo4P3o+TXLksWHrlvb2HDUi
         qFpR0sYwgBcQFngxQJo6iB68W7A6xdoaxIr/4o5VRnfpXjZPoDKAExNzxzi1OtNAbdB9
         H+R4x3HIn6nBLPYPoqKrdS2ieyeCjxztvnq9DXDFgqsoMZl5yOLFDLoTZ9XhslGLB5Zh
         RDLOb4HkQENVew2sqQkwZFcJU1lIl4IMCLhujHad6Iw9l5BGqLocC6MBwR3VrA2IJsIR
         WgqAhpS1E/ywYM11YHMxSiW8KmiFn26ulV6a2Wke/0oVoRXrKkxkGL9F4Dboe82wCSkg
         snYg==
X-Gm-Message-State: AOJu0Yxg58BJqpV3xtLk+zp+L0NKWyb+U6TusAbqpRDv7wiGKIi0IHrj
	JYk80wLyDDpu93SNhzgcmGNEo1NxIsCH2NMlu6jiPoHzxUKAUs3ECuUTfAvb6gucH4VMnyCPt6/
	7qHZ7jkIr6j1ey2A9M/P0eRgPSCko2u5RCNpZzzL6M0GOOs/weEE8k8aZBHOPm9UgcPdkOzkbnd
	bSyxrSTu8YtNCK6sRwr9xAycheeR+sXOxBgPQXSu9gBpONA/+z
X-Google-Smtp-Source: AGHT+IFhMMok3i/KPc9qDM9FkqW93EmjI1SAPuid0yYMNa6ReQJfzhHQ4OrLPt5siMKHOdjmAiwAug==
X-Received: by 2002:a05:6a21:9216:b0:1b0:25b6:a75d with SMTP id adf61e73a8af0-1b025b6a9bdmr3325028637.52.1715872996113;
        Thu, 16 May 2024 08:23:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a83d3dsm13241749b3a.65.2024.05.16.08.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 08:23:15 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 2/6] mpi3mr: Driver buffer allocation and posting
Date: Thu, 16 May 2024 20:50:06 +0530
Message-Id: <20240516152010.88227-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240516152010.88227-1-ranjan.kumar@broadcom.com>
References: <20240516152010.88227-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000073321a061893d02a"

--00000000000073321a061893d02a
Content-Transfer-Encoding: 8bit

This patch adds support for allocating a driver
diagnostic buffer and posting it to the firmware
for capturing the driver logs in the controller for further
debugging.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |  13 +++
 drivers/scsi/mpi3mr/mpi3mr.h         |  21 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c      | 154 +++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
index 3b960893870f..495933856006 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
@@ -7,6 +7,7 @@
 
 #define MPI3_DIAG_BUFFER_TYPE_TRACE	(0x01)
 #define MPI3_DIAG_BUFFER_TYPE_FW	(0x02)
+#define MPI3_DIAG_BUFFER_TYPE_DRIVER	(0x10)
 #define MPI3_DIAG_BUFFER_ACTION_RELEASE	(0x01)
 
 struct mpi3_diag_buffer_post_request {
@@ -40,5 +41,17 @@ struct mpi3_diag_buffer_manage_request {
 	__le16                     reserved0e;
 };
 
+struct mpi3_driver_buffer_header {
+	__le32                     signature;
+	__le16                     header_size;
+	__le16                     rtt_file_header_offset;
+	__le32                     flags;
+	__le32                     circular_buffer_size;
+	__le32                     logical_buffer_end;
+	__le32                     logical_buffer_start;
+	__le32                     ioc_use_only18[2];
+	__le32                     reserved20[760];
+	__le32                     reserved_rttrace[256];
+};
 
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 4ef96c39c832..dc7e8f461826 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -37,6 +37,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <linux/kmsg_dump.h>
 #include <uapi/scsi/scsi_bsg_mpi3mr.h>
 #include <scsi/scsi_transport_sas.h>
 
@@ -195,6 +196,13 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_HDB_TRIGGER_TYPE_GLOBAL          3
 
+/* Driver Host Diag Buffer (drv_db) */
+#define MPI3MR_MIN_DIAG_HOST_BUFFER_SZ		((32 * 1024) + \
+	sizeof(struct mpi3_driver_buffer_header))
+#define MPI3MR_DEFAULT_DIAG_HOST_BUFFER_SZ	((512 * 1024) + \
+	sizeof(struct mpi3_driver_buffer_header))
+#define MPI3MR_UEFI_DIAG_HOST_BUFFER_OFFSET	(16 * 1024)
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
@@ -218,6 +226,12 @@ extern atomic64_t event_counter;
 #define MPI3MR_WRITE_SAME_MAX_LEN_256_BLKS 256
 #define MPI3MR_WRITE_SAME_MAX_LEN_2048_BLKS 2048
 
+/* Driver diag buffer levels */
+enum mpi3mr_drv_db_level {
+	MRIOC_DRV_DB_DISABLED = 0,
+	MRIOC_DRV_DB_MINI = 1,
+	MRIOC_DRV_DB_FULL = 2,
+};
 
 /**
  * struct mpi3mr_nvme_pt_sge -  Structure to store SGEs for NVMe
@@ -1113,6 +1127,10 @@ struct scmd_priv {
  * @ioctl_chain_sge: DMA buffer descriptor for IOCTL chain
  * @ioctl_resp_sge: DMA buffer descriptor for Mgmt cmd response
  * @ioctl_sges_allocated: Flag for IOCTL SGEs allocated or not
+ * @drv_diag_buffer: Diagnostic host buffer virtual address
+ * @drv_diag_buffer_dma: Diagnostic host buffer DMA address
+ * @drv_diag_buffer_sz: Diagnostic host buffer size
+ *
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1310,6 +1328,9 @@ struct mpi3mr_ioc {
 	struct diag_buffer_desc diag_buffers[MPI3MR_MAX_NUM_HDB];
 	struct mpi3_driver_page2 *driver_pg2;
 	spinlock_t trigger_lock;
+	void *drv_diag_buffer;
+	dma_addr_t drv_diag_buffer_dma;
+	u32 drv_diag_buffer_sz;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index fbd6f32f79ce..5937054b3cdb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -22,6 +22,17 @@ static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
 
+int drv_db_level = 1;
+module_param(drv_db_level, int, 0444);
+MODULE_PARM_DESC(drv_db_level, "Driver diagnostic buffer level(Default=1).\n\t\t"
+		"options:\n\t\t"
+		"0 = disabled:  Driver diagnostic buffer not captured\n\t\t"
+		"1 = minidump:  Driver diagnostic buffer captures prints\n\t\t"
+		"related to specific mrioc instance\n\t\t"
+		"2 = fulldump:  Driver diagnostic buffer captures prints\n\t\t"
+		"related to specific mrioc instance and complete dmesg logs"
+		);
+
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
 {
@@ -872,6 +883,31 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	return retval;
 }
 
+static const struct {
+	enum mpi3mr_drv_db_level value;
+	char *name;
+} mpi3mr_drv_db[] = {
+	{ MRIOC_DRV_DB_DISABLED, "disabled (uefi dump is enabled)" },
+	{ MRIOC_DRV_DB_MINI, "minidump" },
+	{ MRIOC_DRV_DB_FULL, "fulldump" },
+};
+static const char *mpi3mr_drv_db_name(enum mpi3mr_drv_db_level drv_db_level)
+{
+	int i;
+	char *name = NULL;
+
+	/* Start with Disabled */
+	name = mpi3mr_drv_db[0].name;
+
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_drv_db); i++) {
+		if (mpi3mr_drv_db[i].value == drv_db_level) {
+			name = mpi3mr_drv_db[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
 static const struct {
 	enum mpi3mr_iocstate value;
 	char *name;
@@ -1238,6 +1274,102 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_alloc_issue_host_diag_buf - Allocate and send host diag buffer
+ * @mrioc: Adapter instance reference
+ *
+ * Issue diagnostic buffer post (unconditional) MPI request through admin queue
+ * and wait for the completion of it or time out.
+ *
+ * Return: 0 on success non-zero on failure
+ */
+static int mpi3mr_alloc_issue_host_diag_buf(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3_diag_buffer_post_request diag_buf_post_req;
+	dma_addr_t buf_dma_addr;
+	u32 buf_sz;
+	int retval = -1;
+
+	ioc_info(mrioc, "driver diag buffer level = %s.\n",
+			mpi3mr_drv_db_name(drv_db_level));
+
+	if (!mrioc->drv_diag_buffer) {
+		mrioc->drv_diag_buffer_sz =
+			    MPI3MR_DEFAULT_DIAG_HOST_BUFFER_SZ;
+		mrioc->drv_diag_buffer =
+			dma_alloc_coherent(&mrioc->pdev->dev,
+			    mrioc->drv_diag_buffer_sz,
+			    &mrioc->drv_diag_buffer_dma, GFP_KERNEL);
+		if (!mrioc->drv_diag_buffer) {
+			mrioc->drv_diag_buffer_sz =
+			    MPI3MR_MIN_DIAG_HOST_BUFFER_SZ;
+			mrioc->drv_diag_buffer =
+				dma_alloc_coherent(&mrioc->pdev->dev,
+				mrioc->drv_diag_buffer_sz,
+				&mrioc->drv_diag_buffer_dma, GFP_KERNEL);
+		}
+		if (!mrioc->drv_diag_buffer) {
+			ioc_warn(mrioc, "%s:%d:failed to allocate buffer\n",
+			    __func__, __LINE__);
+			mrioc->drv_diag_buffer_sz = 0;
+			return retval;
+		}
+		/* TBD - memset to Zero once feature is stable */
+		memset(mrioc->drv_diag_buffer, 0x55, mrioc->drv_diag_buffer_sz);
+	}
+
+	buf_dma_addr = mrioc->drv_diag_buffer_dma;
+	buf_sz = mrioc->drv_diag_buffer_sz;
+
+	memset(&diag_buf_post_req, 0, sizeof(diag_buf_post_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		ioc_err(mrioc, "sending driver diag buffer post is failed due to command in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		return retval;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	diag_buf_post_req.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	diag_buf_post_req.function = MPI3_FUNCTION_DIAG_BUFFER_POST;
+	diag_buf_post_req.type = MPI3_DIAG_BUFFER_TYPE_DRIVER;
+	diag_buf_post_req.address = le64_to_cpu(buf_dma_addr);
+	diag_buf_post_req.length = le32_to_cpu(buf_sz);
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &diag_buf_post_req,
+	    sizeof(diag_buf_post_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "posting driver diag buffer failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "posting driver diag buffer timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_DIAG_BUFFER_POST_TIMEOUT);
+		retval = -1;
+		goto out_unlock;
+	}
+	retval = 0;
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS)
+		ioc_warn(mrioc,
+		    "driver diag buffer post returned with ioc_status(0x%04x) log_info(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+	else
+		ioc_info(mrioc, "driver diag buffer of size %dKB posted successfully\n",
+		    mrioc->drv_diag_buffer_sz / 1024);
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+	return retval;
+}
+
 /**
  * mpi3mr_revalidate_factsdata - validate IOCFacts parameters
  * during reset/resume
@@ -4168,6 +4300,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	dprint_reset(mrioc, "posting driver diag buffer\n");
+	retval = mpi3mr_alloc_issue_host_diag_buf(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to post driver diag buffer\n");
+		goto out_failed;
+	}
+
 	ioc_info(mrioc, "controller initialization completed successfully\n");
 	return retval;
 out_failed:
@@ -4358,6 +4497,13 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 	} else
 		ioc_info(mrioc, "port enable completed successfully\n");
 
+	dprint_reset(mrioc, "posting driver diag buffer\n");
+	retval = mpi3mr_alloc_issue_host_diag_buf(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to post driver diag buffer\n");
+		goto out_failed;
+	}
+
 	ioc_info(mrioc, "controller %s completed successfully\n",
 	    (is_resume)?"resume":"re-initialization");
 	return retval;
@@ -4669,6 +4815,14 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		}
 	}
 
+	if (mrioc->drv_diag_buffer) {
+		dma_free_coherent(&mrioc->pdev->dev,
+		    mrioc->drv_diag_buffer_sz, mrioc->drv_diag_buffer,
+		    mrioc->drv_diag_buffer_dma);
+		mrioc->drv_diag_buffer = NULL;
+		mrioc->drv_diag_buffer_sz = 0;
+	}
+
 	kfree(mrioc->throttle_groups);
 	mrioc->throttle_groups = NULL;
 
-- 
2.31.1


--00000000000073321a061893d02a
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIE169QG6sKEm8Uxb5n/SL2GHKUsAJt4Z
Qwe/AzZodscrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDUx
NjE1MjMxNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDIx45VOzOjvivOdSIyjVP5KzNiwcXSo3HiRizbH08T90c2CBGM
pelcpkTkRPKk/hnIvfbNRk2dbvFJwh4OlcDes+uRABnmSGss3U9Htoxr/Ma+uIYzgacbt4GZWU2s
alxeo/CEEZ1ObJmXhiZYJrigWeVkNwfTr0MP3t5g/c47/EWJh2B5nqA6I3qUNEJRTzIbzLeYCjGz
3Rij+f7DA0aGLBKkSzxqcwiJz6+jAPC3ConduuFaEGOeABatXGoD1nBOVTj45i+zErvzVQR9O786
62r1W3R0f4g6/Hi4t3O639a5MbKmYZUk4N5oZ5m0re3f0lbLZkgX11WnjK5BaonI
--00000000000073321a061893d02a--
