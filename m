Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9538615A
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731260266; cv=none; b=nrIbtSyMfa/RSp0KKsbK1c6xAzkPvqGJRWF9lPfwFhJQryGBpzePDCRheaGwFkwhXCNg0daGRg1Elf/sq3V062AC6UxJPeFLty0dA5yLc347wbS5aqSYf1fR1ZGqXu9Sh73l3QuEH3G5G9vAhHFxBWtw66QW+8dOWEgXXp7m8VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731260266; c=relaxed/simple;
	bh=/KNLFQ0v/OggHYH4OeCZo0xKTXMJkBkWrMV/DcFaIqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u9X2ln4FRoxs0g3qFqHlFROmGI/0kfm3a/FF/S5lufnvh13E5y0VpWodvj1O87qRkQjGv4Dw+xGNbB9TVqS5jZOZuTq5aVqCp7dfZZvc0f1hnnfvielz81nbB08gZmYs+GWMQZZbaxFyWaGu9hUnteSBQweY+uRLYOAHyK7s4YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fx3B9XoV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fx3B9XoV"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20cb7139d9dso34998125ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 09:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731260264; x=1731865064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yy34YhL5dMnKlQqi8+UALprhgy3Fk1OzFpqI6Y743+4=;
        b=fx3B9XoVC4KfZB8/Bu9K2IVKbXDxpK9rUozREuEGLro7f2WD8TsLbrNqdTB6YUjm7g
         J6XEaWXzQ9CNWKRdm/BwG5B2CwhJB4dnwhnmvdptEcQ/8szjCSLztNweQioQ09HsboXI
         vCQPyW8X6N6sdKzamDyI8lPmVCROo3EsXHO9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731260264; x=1731865064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yy34YhL5dMnKlQqi8+UALprhgy3Fk1OzFpqI6Y743+4=;
        b=i1ChO5zRTNBolMGPKEoPMsv6IeXTbqid+EuTYqrgh6uJ7VfKrAXJrr+cmTpdrC7v7H
         6cB590AQvmzxjfCEcVcXGyu63M+3ZVH0cthB3isFUUZ0Nbor0GLG3fO3uRT4O/kBsPOd
         eVWVAo6GomtnxoR8ByfKj05cI4ruaqinsBCgBZw/4l/XUSeDTfHDBXeBiv53Jufp35KY
         WH3BMTQuHiQigXvTG3geEg2atIf+Cc3rsLXoeyFE6Mhr7KXchOP82fwpgFXdDSRbhj4p
         7NDImoXCmRwAPWuwazZex4yLLCIQ7iEihWAuIXYs6r1uITrUvrqto+JtxgrNSdidQIij
         qkgg==
X-Gm-Message-State: AOJu0YzBtGtAboolT/inNpNrBG9DzRPTXkXXpKZ3R2YHaKSs3aqAWvYW
	RkyFnv0fmVSmUc+zZFDkm4wiYdZc8pldW7zk8EypT3t4lPi5S8Eed9lOysPjcVNRDxVNryyexWP
	0z/amHP0KB1Khx1x0uWQc2U4RqS6CSZPuLgmyh+L/qHob762bUez5HYc7+4ZeobsaD94jhBn9IZ
	qg3n7rJK921lNH95q+9OImOMR2SGkfGlzxLE9st9dXmco1XA==
X-Google-Smtp-Source: AGHT+IF68T/ljjgX5yRv+q3tDR4qk/nUkxmm6ULJLq1z/oIR2xWix4Qr7AU5jyG+GVmL008qLGjSCQ==
X-Received: by 2002:a17:903:192:b0:20c:b3d9:f5bd with SMTP id d9443c01a7336-21183d1ec87mr135604645ad.18.1731260264249;
        Sun, 10 Nov 2024 09:37:44 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177de0447sm62314465ad.109.2024.11.10.09.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:37:43 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/2] mpt3sas:  mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Sun, 10 Nov 2024 23:03:40 +0530
Message-Id: <20241110173341.11595-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
References: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issue a Diag-reset when the "Doorbell-In-Use" bit
is set during the driver load/initialization.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ed5046593fda..16ac2267c71e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7041,11 +7041,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -7135,6 +7136,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
+
+doorbell_diag_reset:
+	ret_val = _base_diag_reset(ioc);
+	return ret_val;
 }
 
 /**
-- 
2.31.1

