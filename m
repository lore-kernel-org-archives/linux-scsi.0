Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669E1E5716
	for <linux-scsi@vger.kernel.org>; Mon,  3 Mar 2025 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740995134; cv=none; b=Z9ILTRA/CzacYk/HLdyvQe2IO1fWay9Lqd5sPb2jDCSkuLVu+KoF1psaOvaRkWNp8v82U/Qtbouu9F3dmw68wLWKAEKofTz8HQzLl0LZj5U7Y42uJe5juS6fNLU9hmooH+u+Gy+LH+HUvLT4W6xCHlLN5AAPydG+nD4CYp/m6P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740995134; c=relaxed/simple;
	bh=GHiLwixb+NtCP+np0bJvdlV0qEiPd+T8tL2Lpw4XBWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=udR3mgueXAEi4alqdF0uUTIqGq0abm8ZeIGZuNbSI60mW2n4x1lx98NkGjq4HOsbsFzwrkHYQodgeO06SpmVyb5aZuFmeR2o6WdIKXDUbFMzBscdQj9V3lFvPG2smdR/JJVkQI6Y3rqk1x8LXZ3UT6h7/vuXxS+qVzaBvAsaALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O5gUNLU3; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O5gUNLU3"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fea47bcb51so8364034a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2025 01:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740995132; x=1741599932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7H5aQrVxQGc/oa2qtWZcwzvXbBceDWEZ7haAhLo1SE=;
        b=O5gUNLU3amnYWP9pvv9BGDumg8qZ5XP/7OAMFHwbl1pCBtWtyutemJWJQxj5nGJd57
         5OBKkYXLWo7EamNAhADpKKjM71dJATKGvfraeLQ/toA6hoEU4cpwB3IE8EBwxEfujNHi
         glgKUxMljUAwdNJwC6gwYGLZ/JOldiWUaiIcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740995132; x=1741599932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7H5aQrVxQGc/oa2qtWZcwzvXbBceDWEZ7haAhLo1SE=;
        b=BM01DR4CGHcJEjLo4S4zzUH4eCb+3DopEi7qZP4UWCkXQi4Uzz0uJl4P3m7sKmf9nC
         mhS2IBRSpN/sKfjrJFrF/fqQWCW/8WbTufGRl0pOT1oCRjHOb1UjCgcimOjZ/MvQP7aQ
         bo7gZ+/JZMKyVN/fG+Hy66dGMsiK0pW1EVEIOIulGNugj0NyOg9h22TERfyfEDW/XGhZ
         I/ad8k9szLNPE5rt4KW+kEjB5p6+tDhOqQiEWeOO700rp8S+d1arIoYiEGazh2ltZQlB
         BrfX6pLPQvaIlfbPkveSTyahbYy82ssI6aabrVasLY6247/Y93BnM/PadtfA/sUYQQJw
         b55A==
X-Gm-Message-State: AOJu0Yyoo5rttZsvn4f0bcw7eOp/lqC2I6oC4UyX1KCAfUb/LcxlQ9gm
	TNi2D4PPfJV/Ioc9isbjw0QobvmaVSzmbz3Q8rVQzdNMIlq5qWqFtA5ZefeYzZEZaCJhK3rMu/R
	26i68LqtMWbmpkl/jSDX2+RsQOMAYFfYxnyjC5H2b1+tsySPNWnfkIiDfX5GNz/zoxcCkXhtpOd
	eg/E2r1THBZIAikpOuk5VRZFvPgKaxV7l68/+6yXdRaFkfdQ==
X-Gm-Gg: ASbGncsVHu6sGh9lJzY9tfrudQaaVOuCwPlBXT/IQDHl9zv6t+Ga45hXOxmBmwZvm2y
	WqO/KtlRrR6icf7GB2y35W8UKVR/8Q91277dkLB6Y4pUXAa9lXfh+4MAZ6iU1pOweJZ9FfabxEn
	Jo+hgg/+l5+HSNIZiOlqFR8gPL6JXDoGx6monN1dfQQatYpzhsJyuJysO9IN4xdI/aKF9NQR92O
	A7+JELWF1C49Q49w2xMMq3f1ZpXVwkRxQs9UN1rxU8kim7FEc8lIcoSip6qiTk2WPdx3NlCvrDv
	+0u04z7FibIiiXu/Xa23Qm0boKY4+O3c6qah/e4IK/o6KMs60wiQBq22WP8A59APgx92+YqRhFn
	9E50/w+/eFltli7lenOIs
X-Google-Smtp-Source: AGHT+IGtmKmwIfCgoe9kGlhjVMP3AYWAfropoxTZnLfKQKlNGmzmHsajfFSloWICxPK70JLLvcX0Mg==
X-Received: by 2002:a05:6a20:6a11:b0:1ee:dd60:194d with SMTP id adf61e73a8af0-1f2f4c9c8ddmr15769645637.5.1740995131668;
        Mon, 03 Mar 2025 01:45:31 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af0fc1dab93sm5323282a12.60.2025.03.03.01.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 01:45:31 -0800 (PST)
From: Chandrakanth Patil <ranjan.kumar@broadcom.com>
X-Google-Original-From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	rajsekhar.chundru@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/2] mpi3mr: Update driver version to 8.13.0.6.50
Date: Mon,  3 Mar 2025 15:10:04 +0530
Message-Id: <20250303094004.93770-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250303094004.93770-1-chandrakanth.patil@broadcom.com>
References: <20250303094004.93770-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9bbc7cb98ca3..6c1365603b26 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.13.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"20-February-2025"
+#define MPI3MR_DRIVER_VERSION	"8.13.0.6.50"
+#define MPI3MR_DRIVER_RELDATE	"03-March-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

