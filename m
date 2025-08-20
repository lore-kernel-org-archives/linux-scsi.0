Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E5E271472
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679679; cv=none; b=LS+kHlHbXu+yAB+su/uHCJFvGZVvX+d+QzDSsdzFU8zd3jLGFZKwfpFAxwrP39oFHxXuvdf34qkuCTjeV/NEmUsJYF4qx1i/wpEo7gebR++vuqYFyWVOsk0RgiGdHSgo6+xYSz2lDu7bwulkYj6twj4x35psxRQNxR6Uc4J+gXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679679; c=relaxed/simple;
	bh=OF9PX556+c3LIw1PD1XvUcr56GZNB4PWnRDj7FycRjM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBop6U+LD0hgIlPNd75tRo/A4sjW1t+8B/33RRmX/AvD0SFz4GIFyHwG+n2brrkMg/quoImMAgfxZ5/iFdMIo0IR5niXlH5gY9r9yCv8DEezTD5BzQGOiVAoq62v4E+LOFWb6qUml2Zc1nMv4l6L2k0zSDvSk453bVuvu7h66xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fI7hELQ9; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fI7hELQ9"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-76e39ec6f30so5090597b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679678; x=1756284478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQQYujXAPUdihHdyMrgGVFLILsOSNhMPxo4t+M1nFTo=;
        b=BD9kiUvQb/net8Fwc+DCWf2p51ycDRYk8KMF2lV4Exd7lVn7F6R1pw5iBfJlWywXXL
         x6vlzT6PphTXAoXA1rZ0qYq/N0xo9pDUdtLJXC89Z2Mukpyph+3OT6mj33CmqTbifTU/
         /SjLE24n7s//q0CWiP74Gdm0KeFlQTtbYx7Ugsjk8EUiimEAso4qrx4rqk/lzbOKwjfT
         jX4o3lQw+Ej9kpRdtxVU6DS+tXPQ83ctdZ1ht/wl1bEQenG3+qElINDv54EZBgvfjWIU
         05KfQZMlGq3Zt/I1fVSel+RFaaW3VydUBMLXT2v5rZV3cxikS4e5s07wYxTxX1yq4NMu
         9v0g==
X-Gm-Message-State: AOJu0Yxv0jeKcOQaox+5QJMnUyUwq9JUngF4E26U3tsS6dtXZl4j11l6
	2K/e1QZioB8R2hNi/qa4Nu6MigKJ/tQlRx0FJDTjrP/oANSMo52rUYNtmvq6pMffjSodGfnOE8j
	tjLYCTyRQYLToLfUre8sbPFCB8JYYAma3Tx7thNO113HLfuJOP6XE7pGf7B9QZVxXcbOETb6Ih5
	KdU53W941hNxa0MB9OJZbEfZU58Y7MXC2ZT9FkbGDFFTBiMZEYYRDJbXMsv4tulC3jVnNCw1E5+
	VmDXo8K5GSSWlubMkbXB8/X
X-Gm-Gg: ASbGncu4Wq0s/++OueYGHVdkvPpfKzFpP0n+GUlIsHNSBls5l4BXz1Ze5CbwyrUHDKK
	TocF6pvufkr0s3xygh4xZfiqaQbip1Wnldl+4Ovzqes20jJBjQ+j/20xTMC7MUXUYKPqCaAK6GQ
	6WhO7BIlqZav8gKEqYTH00CGaphhwJT3ieRM2UIyA4ZirfUn4IYt4fqMgHLFxULFh4AZDSrsyak
	1Mg0oS5ePfRaC1dWA0M/d/ribRvnMgAy39ZlUX313texLNBwUlsgBYlF+33BmAVTSIilOYBgVP+
	2b4ijJtZyrH4Kk9579nUfBKkZR23LS5MF4iyn5twxWaGx85p6ftuSq+LUlvH9AEa2z6jLQYGyB7
	dcSIYVNv8Xe22yG2/oNAHniJzm1kT69Rl5bQlrvYGM8bTkm94UzWFl9WHgM+NVRa4E9s34mcA+7
	IQmyny
X-Google-Smtp-Source: AGHT+IFzzNwWaNaGbXX4J0G220N3YesIQd1wGnPgIGRE/5oB9ANwaFsGHVxKMY2MmyKmuI9C1oNrQWrZEzoG
X-Received: by 2002:a05:6a00:2301:b0:76e:885a:c333 with SMTP id d2e1a72fcca58-76e8de1c034mr2929520b3a.25.1755679677816;
        Wed, 20 Aug 2025 01:47:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-6.dlp.protect.broadcom.com. [144.49.247.6])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-76e7d25c2b3sm373735b3a.12.2025.08.20.01.47.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32326bd7502so5666408a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679675; x=1756284475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQQYujXAPUdihHdyMrgGVFLILsOSNhMPxo4t+M1nFTo=;
        b=fI7hELQ9XZT1qK9FhAqyl+v9zRn89MYtbmGRwWmCUexNxUerW5D7ReSSDtcmGPlG2w
         Oc7O9WuhzjO+hpcDV5uLJ2c39C6FWI9OF1cXBuwSBf2IPjLtezi9a2V4IJf97Ceb5UcX
         kc9q5hD+qcFJTU2J+zQ45VqQL1FK375ltTmzY=
X-Received: by 2002:a17:90b:254a:b0:323:2722:fcb9 with SMTP id 98e67ed59e1d1-324e1290c0bmr2766818a91.1.1755679675411;
        Wed, 20 Aug 2025 01:47:55 -0700 (PDT)
X-Received: by 2002:a17:90b:254a:b0:323:2722:fcb9 with SMTP id 98e67ed59e1d1-324e1290c0bmr2766783a91.1.1755679674895;
        Wed, 20 Aug 2025 01:47:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:54 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 6/6] mpi3mr: Update driver version to 8.15.0.5.50
Date: Wed, 20 Aug 2025 14:11:38 +0530
Message-Id: <20250820084138.228471-7-chandrakanth.patil@broadcom.com>
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

Bump driver version to 8.15.0.5.50 to match the latest release.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6024b5b760c5..6742684e2990 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.14.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"27-June-2025"
+#define MPI3MR_DRIVER_VERSION	"8.15.0.5.50"
+#define MPI3MR_DRIVER_RELDATE	"12-August-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.43.5

