Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A31A923
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268098; cv=none; b=Xx3LYt+pfKjm02DH3VbwcRICPjOjPj/JHFeeDDq5S/LY2EuN18K7GkvF99NXM0NrQ5ERK3/pG3X2/eWjIZh938nGA7V4uDbtX6eAET+IGMiiBMXvld3qPFKjPkctlxBg7DVlctSLwtNXoMKkxgKDrlAW8pGuwUphaHdyMh6qa5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268098; c=relaxed/simple;
	bh=YluwqkRJBBulotHI64ojo3PvAtPWUnclKov9a4m0HrM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BeTnXy8jGo1TcPh1VVxva2r6fzO4QL8ik47o+Fmxe7rtmQhSwWajMEw8bc+USTe/B/Fw505qwh52rp/k17pa7tQbGRoNTJkiIwwge5+mYMHsVdEH703Redt9kZxBR24yKu5vBk9cxMneFsqIPQz4FUamoTf8eCPLX/Sd+3vgTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=F3kiXy89; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F3kiXy89"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7f43259d220so1651481a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268091; x=1731872891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+42fYyDB/T1h/+G8zvwsuVmFhTX9wfQhFTHW6uKoHU=;
        b=F3kiXy89umAHPQ/JxCm0ZywJ40Ta7PXQG8wKPdJRa4mwvQIUDJkHRZ3925MYH3pODa
         bQNIyTJoyrjSd+hC/Z3lSU0J0v74S3EByxq7NjOoEH3YZc9tJYAQYMMzcyR9XCIodMfW
         R0plRDYusOmQ6bt3WNFiEouiHtNbe+Zrmh79o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268091; x=1731872891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+42fYyDB/T1h/+G8zvwsuVmFhTX9wfQhFTHW6uKoHU=;
        b=GCRtP161Xb/AWaTncoppSBKcC6p/CbFoV1oyC/GV/66V7qK1pxTLnh5wH7ZuM7wqgu
         ZElsTxjWXSIJbGQQDRV6vrYFCL16dHnjYnAPYnW+7W4q8VXJ0caqmib8Qn41pmi44U8x
         /GPyEzMpcUOl++ybJcyrKzxr7j7urpXIQo9KFCicu31XZrPqpC8PTQze/I2Q7jFuXMF9
         BrWuTg5AXxl3r4uEWSNh2ykPdd14cSX0bhfBoIeFjNDKTo+ok9sFlMj9viE1AMFEjE9T
         /P06qpgbVMOIe99tS0aGnEBr44gpkNlVI7JKwMggkYswRSPLxsGWdfts5EmACXImf8qw
         lJ6A==
X-Gm-Message-State: AOJu0YyDWGFH1/SuvgCKg2hwyGZwBFuojshX2sWOydFafJTXOx+ABpIe
	I0oneX7JwOi6ntraof1Hmy37x093/3CO/GrsjKNXEEdcmNdEz42bqcHtJuVRCGREdqfm8uhtscH
	0tSVkQ4CD1AEgXuPYzA+aH7Fk5xr+P9kgXPh3sH7wyuO1hv7bNjYEtGyKaeYQkwq2D080JGT+1V
	JMm+SD2+dHwlN3nIRWeG6387fPifZb52jF6mX03m1pmT/y8A==
X-Google-Smtp-Source: AGHT+IHqegq1+n9PaJaaEMwBzQ9rI9TPaSt9CGRlg4Cb74zntBIJcBD4091TobY7uBSGoyKsT0q6Vw==
X-Received: by 2002:a17:90b:3b47:b0:2c8:647:1600 with SMTP id 98e67ed59e1d1-2e9b16fc9d0mr14279865a91.9.1731268089980;
        Sun, 10 Nov 2024 11:48:09 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:09 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/5] mpi3mr: synchronize the access to ioctl data buffer
Date: Mon, 11 Nov 2024 01:14:01 +0530
Message-Id: <20241110194405.10108-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
References: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver serializes IOCTLs through a mutex lock,
but the access to IOCTL data buffer is not guarded
by the lock.It causes multiple user threads writing
to the driver's ioctl buffer simultaneously.

Access to the IOCTL data buffer is guarded by the IOCTL mutex lock.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 36 ++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 01f035f9330e..10b8e4dc64f8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2329,6 +2329,15 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	if (!mrioc)
 		return -ENODEV;
 
+	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
+		return -ERESTARTSYS;
+
+	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
+		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
+		return -EAGAIN;
+	}
+
 	if (!mrioc->ioctl_sges_allocated) {
 		dprint_bsg_err(mrioc, "%s: DMA memory was not allocated\n",
 			       __func__);
@@ -2339,13 +2348,16 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		karg->timeout = MPI3MR_APP_DEFAULT_TIMEOUT;
 
 	mpi_req = kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
-	if (!mpi_req)
+	if (!mpi_req) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		return -ENOMEM;
+	}
 	mpi_header = (struct mpi3_request_header *)mpi_req;
 
 	bufcnt = karg->buf_entry_list.num_of_entries;
 	drv_bufs = kzalloc((sizeof(*drv_bufs) * bufcnt), GFP_KERNEL);
 	if (!drv_bufs) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2353,6 +2365,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	dout_buf = kzalloc(job->request_payload.payload_len,
 				      GFP_KERNEL);
 	if (!dout_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2360,6 +2373,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	din_buf = kzalloc(job->reply_payload.payload_len,
 				     GFP_KERNEL);
 	if (!din_buf) {
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -ENOMEM;
 		goto out;
 	}
@@ -2435,6 +2449,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 					(mpi_msg_size > MPI3MR_ADMIN_REQ_FRAME_SZ)) {
 				dprint_bsg_err(mrioc, "%s: invalid MPI message size\n",
 					__func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				rval = -EINVAL;
 				goto out;
 			}
@@ -2447,6 +2462,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (invalid_be) {
 			dprint_bsg_err(mrioc, "%s: invalid buffer entries passed\n",
 				__func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2454,12 +2470,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
 		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
 			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
 				       __func__);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2472,6 +2490,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc, "%s:%d: invalid data transfer size passed for function 0x%x din_size = %d, dout_size = %d\n",
 			       __func__, __LINE__, mpi_header->function, din_size,
 			       dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2480,6 +2499,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x din_size=%d\n",
 		    __func__, __LINE__, mpi_header->function, din_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2487,6 +2507,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s:%d: invalid data transfer size passed for function 0x%x dout_size = %d\n",
 		    __func__, __LINE__, mpi_header->function, dout_size);
+		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		rval = -EINVAL;
 		goto out;
 	}
@@ -2497,6 +2518,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			dprint_bsg_err(mrioc, "%s:%d: invalid message size passed:%d:%d:%d:%d\n",
 				       __func__, __LINE__, din_cnt, dout_cnt, din_size,
 			    dout_size);
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			rval = -EINVAL;
 			goto out;
 		}
@@ -2544,6 +2566,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				continue;
 			if (mpi3mr_map_data_buffer_dma(mrioc, drv_buf_iter, desc_count)) {
 				rval = -ENOMEM;
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
 				dprint_bsg_err(mrioc, "%s:%d: mapping data buffers failed\n",
 					       __func__, __LINE__);
 			goto out;
@@ -2556,20 +2579,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		sense_buff_k = kzalloc(erbsz, GFP_KERNEL);
 		if (!sense_buff_k) {
 			rval = -ENOMEM;
+			mutex_unlock(&mrioc->bsg_cmds.mutex);
 			goto out;
 		}
 	}
 
-	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex)) {
-		rval = -ERESTARTSYS;
-		goto out;
-	}
-	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
-		rval = -EAGAIN;
-		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
-		mutex_unlock(&mrioc->bsg_cmds.mutex);
-		goto out;
-	}
 	if (mrioc->unrecoverable) {
 		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
 		    __func__);
-- 
2.31.1

