Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D5016C854
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738145603; cv=none; b=lDn3enGRo/M4n+v0N7rgae59zYULXti58FxafaJKIeTPh9Xv0f3g5Sm74qJbJWwH7WPxp6fbX9pukc7ZkbyZr2iCK4MGbLraGQY3xaKE/E5DrF7O/NwVc5PduNmA4632LnbFDG/ZAvTKvF/V730aYO6rErLvfwz9aiuKh0udBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738145603; c=relaxed/simple;
	bh=UqHmUUx/B9Vo4eH5i2sbHdkgg90Ky96Jjnvpy+9gcGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D9NxoFNa5X/S6YYP3JWT4LoQLhG2gkAXcVsqKDYLy83QSFpFp8IStWYpYfO3dSS0waxOpf7kCz2XBCNuIyxQqeafXvHrZvqSLd8wldvLDzw4+XlqmymElpkZl6mDgObglQj4uNwOe5M5ASLT4lfT8Z0C3x2AWHwqA2Lgs7YtuIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cQuz34Qw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cQuz34Qw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166f1e589cso53468465ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 02:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738145601; x=1738750401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XjPdbmHBzmGCr0hFbmC2FStZMESrpQzuEPm+5vJLrs=;
        b=cQuz34QwDRllVrapIpBHhb3MSEZVXH/vj0gAkaASU3WJ8AXSVjKFqbG5KO+LlYWFA8
         9ybuTLr0KmVmuGZfcBOL5h3pJbqX8RWt7x8c689x2ftMpR71Utma9PUPyeavasmduTQW
         yJkVtoA87AVKAj+4l+FSxyNQmM4NFIHd2ySgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738145601; x=1738750401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1XjPdbmHBzmGCr0hFbmC2FStZMESrpQzuEPm+5vJLrs=;
        b=vvL5uiGG/MuF2snsIAlZbMkT43rMf23AFfBDLjPYEs4FXU6sZIRqkaKvdRqllJG0XA
         eNXJ+rj/4d/5QAteaR5RRwV5N+IGhWd57kL0494cxBeXuCFR3OG2LqtnMAQtUl2/m7rW
         RxnTNomQ29OZ9pbDOkmtHrMqODGXQ6OI1VgdXDNjFC1//D1psYqjVfBye9iU94C/beiZ
         WsO1/Unahkn0ca1PMQzDt8iCwb0DWGfA13qFq8dnYST4pCH2YBpq7g1cR3tlhgl7lUjO
         Vrj0kViipBl88JZgZRzNAU2qQ9t57TzBoibt9kHr5PW9R9o9f3s88Gpuni0UXuPQ55X/
         dKAQ==
X-Gm-Message-State: AOJu0YwbhjbRIpqIcLtIdfeEkZ/JxmvKrAL8wRXniPpDyRPsFf4yKIa4
	jRMgOkfFh1QgHXCyQQS73cnCgTBzyY0SO7MBQBYJfTpkoLKcq+pRIZMwkKrAxUubZNd7YWMDkzm
	9c+DdZ+8p3Hn2W9mBgpX3+BR6pmXiatWOUgf6YMsA5AnPF9MgA8yNpQF58IRmZaNs1InjpOBnGJ
	Zv6oowlkVcwydG+GeBRUROUVRcpkCoxP8++W0Rvn8IMdoQGjQ4
X-Gm-Gg: ASbGnct9LtBgn6QwgeBDKgoe2io6r+qD39CKX/MpdBuxrHorEkQ3I8t88hrCiFWvAdC
	1ke9Q8y9wEBP3mZqkPFZWY7iNfX1ZfvbQDmW5MeD969CGUJHWbEoum5wVqyGbN4jazcNE/dlsJy
	FQTcIc5BzIgqNNCQy/0Vc7sPXgeOqZ4yyCZQacFgrRhXd3X2O4z/R1VizkEMEpWQVejeh1IlxdN
	m2zsHVLV4t4Q5xslfaC1kpR1aMVFj4CLiZP9aMdeFppsmEs3ZJvT7GCMeChEZCorEUX0Z10uhfk
	mOmK1pSv0/5F8xdTDK8GNj0vsCOBORRQ52ybN9ZMIEOHaNRYr7CNIS3E7W8=
X-Google-Smtp-Source: AGHT+IGArBjJHmeBP2jF6SFpUq9E6hvhNBx63z3kG88N36ezrFcgIubfKmqIlCcbS6ipX3sqnfuanA==
X-Received: by 2002:a17:903:1252:b0:216:643a:535a with SMTP id d9443c01a7336-21dd7c653c2mr39927325ad.20.1738145601133;
        Wed, 29 Jan 2025 02:13:21 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424eb96sm96579015ad.222.2025.01.29.02.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 02:13:20 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/4] mpi3mr: Update driver version to 8.12.1.0.50
Date: Wed, 29 Jan 2025 15:38:50 +0530
Message-Id: <20250129100850.25430-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version to 8.12.1.0.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8978c201c6f0..b6e15b531596 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -57,8 +57,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.12.0.3.50"
-#define MPI3MR_DRIVER_RELDATE	"11-November-2024"
+#define MPI3MR_DRIVER_VERSION	"8.12.1.0.50"
+#define MPI3MR_DRIVER_RELDATE	"28-January-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

