Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026D01F8747
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053865; cv=none; b=HFBEKoiHGGFl0i6weCD23NmJWXsZO+OsZ5jYd+ympkhDcr/scMI7pmldEjKpNXimhv/VRaMQy7g2zEovx/d1m7uaqlWux62ElDL01Qs9mDiIZTSoNj8VmCwW/ALNARVQVSu4X0DufnhNm9nHaOGmwLRnAEqs3wBQxVd/z0XnNIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053865; c=relaxed/simple;
	bh=xa63cdl45Ay3mqQshlbRgRxD+grduS1xjIjcTrPtLaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UjY+V/6iCNKK424Job2hsAvsbTsI0SsNz3hOHnLxXSI8z0ZOUQ9RivZXVfo2arh3iG4934Wc7Kg1bgD+RdXccEdsUoSyp4tXHqprnTx52waU67jMlgqy73ZJNd4uEgPm8GMUoVzmoty4jZHFxCSN0dhpiVGoh+pusCzNFTcZk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NUN4xk9P; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NUN4xk9P"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7490acf57b9so345372b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751053863; x=1751658663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9BzN+q0oJmAch2Z+oWASfhmyuRjM+jQgxhyogpLBqI=;
        b=NUN4xk9PMcOAYbHBOBkMvFizb1PNuduG8NkPkTk3IpCI0gUfrMn6RUYHvDrZO/Ignu
         OcZ+SOrttKcX4KAwxTEa0zRXhQUA4MebgX7NzJ8+Xn4+WmTLqmXMWuoXyE3ZWBnrr1Ok
         uhsJGK0xpVSSuq1zaR8vViQTtRE9CwWmegIog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751053863; x=1751658663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9BzN+q0oJmAch2Z+oWASfhmyuRjM+jQgxhyogpLBqI=;
        b=t17lqzyvPeT/uxt9Zewg7qmMa/Pj+ogkO3/RH2P829zYJJ5C7V3KEmmmYdNxKVeKGP
         ccThLbBszBmsZ2JewD+CPU8NdU1gGwsz6DAu75txgL4DVe0/qaAPcFPYu4S/GN2iMeTB
         MT0A8qXCjRS4GSmT0tC4X6LMt6n3ncNXjJPWSFKluSnuPjLtpYoFMOMDcYArTSclon1k
         DI6Jg0ZytJzyPzD5qg8E4WQHPU11YawGwoL7NX4F4GbkQI+VssESQfIysiafWfnRslSw
         x0RvBHmEWYXLV6yhuQQUx8/ujVAt7yPL8RitmSHf8A+7gyxnpFF88iisB4de0flZ1yyF
         anuw==
X-Gm-Message-State: AOJu0YwJ/fpMb30IVbpQSe1CojQoYXSRdxgcIrm0sD970lDe9yf7/c7T
	Ir4PUKDlj52xWcWPDIkNORyzUwXC7vFS2sQXxLqfKkjJEuW7BBtwLFYECLe4A0mr/zg6oT3coBt
	uUqtSUQGN630FrnDhejLnFIb502OUrAwBvk2h5N3A0bcn2nXDVGUE9ChxbHcMOkSZUnfCe7j7jU
	XISBSapFVq2PmHhlDA3WI/CropmKZPES4L99NkinK7rgNtEJGtnQ==
X-Gm-Gg: ASbGncvVbLbwGIBTzDKtISaKjfggjWKVudLIYeBhnnAa+/EXy9StWW+KyRpFKy01/t6
	h/+WHpw3Kc6MUvIECOC4bs+M/hZMuXFLmtx5QuJJGu9s2YZGWThJciBDEq1hUumx1bVDnYr2M4E
	HKMj7vDdUIRcC6CgIX3EV1+VgrpZ96/iL3RciU+N4zLtFA9FEKQUsNqlKowQOzU46BYVo9WhKUg
	bljydS+bKFEKXBzoF3yMHSkL9wXOL6FfjDvvYdkueu8TXMNdySSCFD/vkUKVr4WUj1cowT4JiNi
	XBMrlYUV3tT506yPBGChRzEGP5ROXsmaQMSv8ykLLtbD+U1HkozvxREo9iwjAoQ5LU7mpY0cdKl
	M2nZc2QePVCie4Hxe+b/FPOEwszPo9MY=
X-Google-Smtp-Source: AGHT+IF4ps/AdgKc4huJHXINtS08vU/sSAqc6ItF4iYaSWBVgT1/hZzl0Ltr7XMLAAtkkwNz0rWWYQ==
X-Received: by 2002:a17:902:ce87:b0:235:7c6:ebbf with SMTP id d9443c01a7336-23ac46342d3mr78005845ad.35.1751053862622;
        Fri, 27 Jun 2025 12:51:02 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f247csm23485175ad.79.2025.06.27.12.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 12:51:02 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/4] mpi3mr: Update driver version to 8.14.0.5.50
Date: Sat, 28 Jun 2025 01:15:39 +0530
Message-Id: <20250627194539.48851-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updated driver version to 8.14.0.5.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index f2201108ea91..8d4ef49e04d1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.13.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"20-February-2025"
+#define MPI3MR_DRIVER_VERSION	"8.14.0.5.50"
+#define MPI3MR_DRIVER_RELDATE	"27-June-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

