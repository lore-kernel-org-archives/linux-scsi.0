Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D3149DFA
	for <linux-scsi@vger.kernel.org>; Thu,  8 Aug 2024 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723121869; cv=none; b=Ae1ZSaRHUsTu0NUcQZxz/cVopWe15wXE8tHOQlmYkbRspKJ3BUhE56msUtZkLmBd0qvJip6AvWz30fsUNTrjHgy0wp3LnaPM3vu2ZE3ir5qpFwgU0OCjzdxdNt4RKRMdZeNJEvSm2ZUZvjXW5McSYTAmEF2OeSD1tMG9YpAF74Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723121869; c=relaxed/simple;
	bh=mNLV4c4zPQ9Yzpiaw0jBb8ZBWV7iIEC+jrpT9jPgPSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VOVS1GA+fYk2TbiOvsqAtlQALGla1A4x6qw81tN3UPsr+noBR2qJbPeODO05ytVIHuN3hK7GMP4t69HCrjEaYMt1Df24K3CG5ww37xSPgrV4BaDDNLCGXVgBCFQQxqADJk+llKlLSOYQdPY4iekH8bu81sgSLe1bQJXT5AypxFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dGLZnWHN; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dGLZnWHN"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc569440e1so8814385ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 05:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1723121867; x=1723726667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG5+v1yCDFtfXI8AGrFbrDvt9Ut3zqUa7nE1CC+Yxn4=;
        b=dGLZnWHN1ObQNdqtEM7BHldhcD07lfI6TTgmHrwHMi2n5sozCNQIGHNJhv8OV2+AkM
         ORHq5UBA1hBUfnOIkWVS0qf2a6mSt/CkDeZrk8BP9rNDcRGjhXUgnuP8LjILVuvgMW9P
         6a85Nd+4JWJbZrBjdGd1DnG3WgsZ4tyu2r2DQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723121867; x=1723726667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pG5+v1yCDFtfXI8AGrFbrDvt9Ut3zqUa7nE1CC+Yxn4=;
        b=v08I9lLuUjGXWORPCnpHccBdW6IoRHWWFLy6DuHGb7vi7OATnugH0gNWU0m9/MuO0W
         enBI5fYOWwQrOPNAtsRo8lFErMLHdeTuO/3tY5VbT+uvURaDBBM4mTdCV5T8moafss49
         K2SJVE6zcrw9Yx1fWHmgrYpijLJHcTWuQrJT8a+6QobATljrclIUs4xX2tIjEpmLSMHc
         tTHlOlQlRD1aV2Ia3jbkuZzamKmUILEcW/nfyyeIzGlHV0kE5COE4dYIJlHohIIHxI6S
         540DBwnzGwwb24MPSAYBNR/6+T8EeSC7NyGK+ErE+rygcSnOCoh8BWuK+jx3tCdjDJSn
         o3+A==
X-Gm-Message-State: AOJu0YwvM6/nj0Ffp/1LX7I1n2qdBUMxbNLyiHbgM7N0cckmWJqPYkLk
	SHrWG8ob7nG0XEeW+sSz2bv1fzbgXZJA/Z3dYBfznKwmeR8dEyDPiJlKKxNRC4k4+uGaXkVboQ4
	CgyMMc1Tuk5zQRSg2Thf0NSb/me1UP4IsA3udzgE3e2DwEX5NyS6dCBFT4XRgk7861uAO7wbzQm
	hxzpxaUoD6aqYHN+ZgDyhKwVq3u03HiSk48nA/e3eRHLgmVw==
X-Google-Smtp-Source: AGHT+IEHAUYGtaJxtpZk71GSiKyOGr7Lgq7Iw3Q4eRGRNQ7u8s2PW+knDz26iFTNvdaZGnBIvyordA==
X-Received: by 2002:a17:902:f68a:b0:1fb:95c6:8408 with SMTP id d9443c01a7336-20095336766mr20745295ad.61.1723121866627;
        Thu, 08 Aug 2024 05:57:46 -0700 (PDT)
Received: from localhost.localdomain ([115.110.236.218])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff590608b2sm123283325ad.152.2024.08.08.05.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 05:57:46 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/3] mpi3mr: return complete ioc_status for ioctl commands
Date: Thu,  8 Aug 2024 18:24:16 +0530
Message-Id: <20240808125418.8832-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
References: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver masked the loginfo available bit in the iocstatus
before passing it to the applications, causing a mismatch in
error messages between Linux and other operating systems.

Driver has been modified to return unmasked(complete)
iocstatus, including the loginfo available bit, for the MPI
commands sent through the IOCTL interface.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c196dc14ad20..169850393580 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -345,6 +345,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 {
 	u16 reply_desc_type, host_tag = 0;
 	u16 ioc_status = MPI3_IOCSTATUS_SUCCESS;
+	u16 masked_ioc_status = MPI3_IOCSTATUS_SUCCESS;
 	u32 ioc_loginfo = 0, sense_count = 0;
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3_address_reply_descriptor *addr_desc;
@@ -366,8 +367,8 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		if (ioc_status &
 		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
 			ioc_loginfo = le32_to_cpu(status_desc->ioc_log_info);
-		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
-		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
+		masked_ioc_status = ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
+		mpi3mr_reply_trigger(mrioc, masked_ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
 		addr_desc = (struct mpi3_address_reply_descriptor *)reply_desc;
@@ -380,7 +381,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		if (ioc_status &
 		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
 			ioc_loginfo = le32_to_cpu(def_reply->ioc_log_info);
-		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
+		masked_ioc_status = ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
 		if (def_reply->function == MPI3_FUNCTION_SCSI_IO) {
 			scsi_reply = (struct mpi3_scsi_io_reply *)def_reply;
 			sense_buf = mpi3mr_get_sensebuf_virt_addr(mrioc,
@@ -393,7 +394,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 				    sshdr.asc, sshdr.ascq);
 			}
 		}
-		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
+		mpi3mr_reply_trigger(mrioc, masked_ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS:
 		success_desc = (struct mpi3_success_reply_descriptor *)reply_desc;
@@ -408,7 +409,10 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		if (cmdptr->state & MPI3MR_CMD_PENDING) {
 			cmdptr->state |= MPI3MR_CMD_COMPLETE;
 			cmdptr->ioc_loginfo = ioc_loginfo;
-			cmdptr->ioc_status = ioc_status;
+			if (host_tag == MPI3MR_HOSTTAG_BSG_CMDS)
+				cmdptr->ioc_status = ioc_status;
+			else
+				cmdptr->ioc_status = masked_ioc_status;
 			cmdptr->state &= ~MPI3MR_CMD_PENDING;
 			if (def_reply) {
 				cmdptr->state |= MPI3MR_CMD_REPLY_VALID;
-- 
2.31.1

