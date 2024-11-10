Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB2915AF6
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268105; cv=none; b=aE3qZrR8I8LJJ8paKuUuP+cYncCOdD39AfWtZ7LsKxOMbLB4FmvYxhJrG4EyMXLqOAncGt+5KFav6vfvP7d7y3+LxDpt6npPtQm4JXSObJb9L0jDVYQSUO/aJD3U81AcoJAtFrKEuZQmKec6boIZpFu9odmNHumODZnU6+rwZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268105; c=relaxed/simple;
	bh=0bIVxI+EMAm5BvOMqSR7tfnVUX8i5BO/ijqyZy+IkHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qZBo9fIMDvBCdB8ulget4rtPNEtwpXmiLrq3kMrQXz5oeKk/VMzD9ErF0gcxuSMeFKZ/O3GWbIGDGir0xtwVM0xr6C3lYQxS5I/Do7EcOJkNMONSeISi2FJ4U8vaf3tV57JoUzGxPrfFxXWSr0waBIWtHLO0ijDntxR3duFiGhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ss5nkIdr; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ss5nkIdr"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ee7e87f6e4so2874127a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268103; x=1731872903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fFWL3tfYC6pGJrFqs7JRhop7HEAFGKnhxz55QaxF0k=;
        b=Ss5nkIdr00LS+oIbweaz2LJP9fKsiXgNsMIWnuQOGhTOEcAR/BqNH3eXxxSmLWDoYX
         1CJe0XMDQULf+w6jvKJ+NQqy4Oiv/NVLLBDWApi6MumIxj5oxVD/D1I5iTbnsmvoUvWG
         x8yVhd7dIZ+HzBsjHUj0ISYGRZMb/4K/+RktU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268103; x=1731872903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7fFWL3tfYC6pGJrFqs7JRhop7HEAFGKnhxz55QaxF0k=;
        b=ZpVBiSLaPptJL+y2xTiFE+xlQ44ZeR1za1la8WGCs1aV/SIr5MwC0QrwwtlPfcqpYG
         IGxSWFAlMKLhHeGFnY0wBezcsdf15Ml806rxdUZM22ikWYwYLxQqwEklZNNwD7WWXOnO
         uwN11jIk8yo+AzBroa9hDw2zetl9Ds9sG9pDGLm238ES/cXjqZzOTVCS/y5pIUFlcrWE
         1aD25RudoMTXrdb2f0Oy/uVIkwCT4rXx+MjzZsW0lPpyxLJQeUdMxi9prI3uYsM/GsA3
         pGOeZMHAGP/yVgm6dxJnpxyBhMFvyQ0G2FyCvse22eUqZcwLidWjLeCumS53X0Tk8z4W
         TnqA==
X-Gm-Message-State: AOJu0Yxa9vYiU5Tw+Vf7CUXwrEGDjzx9Bj1M07RMuEW0b+SWsp9KhrRy
	tIO3NlkMQFrhVVwUVc06GmdlWAfQYdtkBpd4gbVzTxfhn0jM3IpmzPhHEOR6nr1x4VEvFYd4vdx
	/zax3O2l1elXKLz1zppi45lwA+SChgWroecBWF2zVJyx5307adxSlm3QLMYeCYznWUE4c8zehbx
	0jCSSRYUcS09ai3FcGoRHJKIFa0Cl2nFN2+wXioxrvt5KN6g==
X-Google-Smtp-Source: AGHT+IHnlfZlqV+4RkYWaGYm5jDnB4gnjrxLpfvoEdcej5Zi1j27vGr3M/q2UTNqtIGCiTSpsVB2Dg==
X-Received: by 2002:a17:90b:2ece:b0:2e2:d33b:cc with SMTP id 98e67ed59e1d1-2e9b172e0bemr14404145a91.21.1731268102509;
        Sun, 10 Nov 2024 11:48:22 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:22 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 5/5] mpi3mr: Update driver version to 8.12.0.3.50
Date: Mon, 11 Nov 2024 01:14:05 +0530
Message-Id: <20241110194405.10108-6-ranjan.kumar@broadcom.com>
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

Update driver version to 8.12.0.3.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index f06ee0aa9ee0..1c1a1546ab67 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -57,8 +57,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.12.0.0.50"
-#define MPI3MR_DRIVER_RELDATE	"05-Sept-2024"
+#define MPI3MR_DRIVER_VERSION	"8.12.0.3.50"
+#define MPI3MR_DRIVER_RELDATE	"11-November-2024"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

