Received: from mail-il1-f226.google.com (mail-il1-f226.google.com [209.85.166.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A03286D4E
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679656; cv=none; b=k9e8ekgHieC5XZeSWdi+C5XTiDP8m5fcu5JdLWLemGO2apvHWm0EuIeOIqjqEJKZmnrIBVyCN93RCJ3cSEo8Txmt80eo8Pj1k5fJaBakk1YABo4RSXeDHZk+KzSXtAD9MkArNDPqKLvAEUnViE5GQrsr6cCkppu/Ipa/doi0rbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679656; c=relaxed/simple;
	bh=TWRlDdq57+0cdC6r7YhqlO1oAeJu6hd87hPuMS32kE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sTH8/eSKDbxtJQnY22mMWRj9/GVX6lRkrrYQulf1Ajg9Oc+X1Xf5eaXjoCZWa9eTuOK+uGLWwylDv5y3lpHYsAKskAULURW0NAE0o7oWfWx3rBcYwlQW2a2gVraGTuqwS3AiAyJa7IxIdJCrwi/t1pwTcjdWjj9Y5+NrZRr09SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SObGmji2; arc=none smtp.client-ip=209.85.166.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SObGmji2"
Received: by mail-il1-f226.google.com with SMTP id e9e14a558f8ab-3e67dde929bso1423395ab.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679654; x=1756284454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYrO7CtHiX+U4W3utEytf32ydj4SAMzUElkKGzu4Rx0=;
        b=T/wbZo56/7Z9NhQEvEREqoMW9tStOcZqgvmg5T7bFL7RecjazXHdnmHGU+u9UFiYNd
         oXV06hKmloSc1CVWXbWh887dlC1yNEBACrXCA09T2S1e+L7t0bVFZiw/2GMOLDOng/gs
         9Z4Y+i1imWiHTjxzxS9hwIAkDLB2ca+qclITC8QVMpvPndiL4vvK2cd8P/GxnHpIHUmK
         BmPv4aAP6JabLfWg38K16UZwU66bJ+92n3U1YIsOPXaXSvLAcyrZHvv4uTyz3dk9WaW8
         pJr0MYddQwAAaLoRoVd16xgns3/fTxxGKShMHmPHxEsSSBwz9Vec4GoyVGbMD2N2jjQ3
         g1Gg==
X-Gm-Message-State: AOJu0YyziHM+fcvLcBOOrT9+Nhmo6DzblLa4Zo063UYYVd1bjmBobZyt
	g3LhI5COB6PPutPyLfoI19Bva7dbJmx4MN12PtCTIL/Cdq+PEznvqgYum2gDw0D/KTIey/u3xFc
	+imVZzCQNIvBTArltSvFUbqf2XBp6SiMOj+0cvU5JT4yzahmq7pEFlckHwq/fUpy5XQvVhIlrjQ
	hQlm5bzoIS6z3f+hpAIK3RZ/53meopK8rmDTlK1UcVIWwtUXzJPrdlhIAg3D4rA2oiN0eDIB989
	3/OLAgjMc+izjvKbXHeE2Tb
X-Gm-Gg: ASbGncub/gQrsNVHHX3LnYzMu64PX0aBNSFzSAbQNlovkhiCnUY6FrmXnnNKNIi2dvL
	4Wrebao0LfF1nEJYcmBZssml2uQq0PRWYUh7/dL42R4gIlTk9EtMw7fZ4yCxmxggEbrWDLnB+Hn
	sPUEKI9r3ahiesvys6HQAtQPEC7pfPS4SQvyo1++lh7K2ud45tJhp8w/IIszSnzY/GJLgruUgkv
	3Mq1Fj3X3uVitIhYDHgzzGakvbifRMfzxgJbc6vW4XboMeDMaPnT6dP/KuPX66sTaqxsgEfY0zp
	3pkGIla2Gq2as/rKJSNeZJ2nQMPiVloz4/AE05dmYCgrxo6PwP+mHGASFxYZNNGpzOBJ2bSp9Sx
	93qoRPCt9h/DxI2vSAWTPMt9hEic8FVk7HHk8hI0GRGvrw++6L6RLhmcRdOmD4ujWGpzWlp3TdZ
	tB0l/bb7jNRQ==
X-Google-Smtp-Source: AGHT+IFTGB/aB5JBJECBoRzGEZbvhDiElcO9cBC64mu1NGUeiu85LmGTkzu5e2ikkbHGvVFidHm2ubSFENOP
X-Received: by 2002:a05:6e02:3a04:b0:3e5:81ef:b099 with SMTP id e9e14a558f8ab-3e67ca1dbd1mr37805815ab.1.1755679654261;
        Wed, 20 Aug 2025 01:47:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3e67d95f824sm829315ab.46.2025.08.20.01.47.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b4761f281a8so884316a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679652; x=1756284452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYrO7CtHiX+U4W3utEytf32ydj4SAMzUElkKGzu4Rx0=;
        b=SObGmji244+/MdPl0aaPeSEDNdF2ZoJkYgq5Bla4POvxf2Dix57ZHdArSiRnsPaZaT
         2bVZ8z0zYOgmcKyy+ACFlk7EE9DBjjC0SCuezjU6oaF/9qGAEiyvjTHvvvf7aJdtgRZ1
         zqqQKbeneODexT2qnSaNJa4dg/NDfqgpZfsmg=
X-Received: by 2002:a17:90b:5590:b0:321:a2d4:11b6 with SMTP id 98e67ed59e1d1-324e12d65c9mr3375940a91.12.1755679652175;
        Wed, 20 Aug 2025 01:47:32 -0700 (PDT)
X-Received: by 2002:a17:90b:5590:b0:321:a2d4:11b6 with SMTP id 98e67ed59e1d1-324e12d65c9mr3375902a91.12.1755679651563;
        Wed, 20 Aug 2025 01:47:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:31 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/6] mpi3mr: Fix controller init failure on fault during queue creation
Date: Wed, 20 Aug 2025 14:11:34 +0530
Message-Id: <20250820084138.228471-3-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
References: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Firmware can enter a transient fault while creating operational queues.
The driver fails the load immediately.

Add a retry loop that checks controller status and history bit after
queue creation. If either indicates a fault, retry init up to a set
limit before failing.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0152d31d430a..124a0aa0ed9e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2353,6 +2353,8 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u32 ioc_status;
+	enum mpi3mr_iocstate ioc_state;
 
 	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
 	    mrioc->facts.max_op_req_q);
@@ -2408,6 +2410,14 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		retval = -1;
 		goto out_failed;
 	}
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+	    ioc_state != MRIOC_STATE_READY) {
+		mpi3mr_print_fault_info(mrioc);
+		retval = -1;
+		goto out_failed;
+	}
 	mrioc->num_op_reply_q = mrioc->num_op_req_q = i;
 	ioc_info(mrioc,
 	    "successfully created %d operational queue pairs(default/polled) queue = (%d/%d)\n",
-- 
2.43.5

