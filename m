Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCAD1FE45A
	for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061806; cv=none; b=QDz5SmT/KofiVX4BCkqHXa5SrBRfP246LlJgBB+1Ve41exlQLhufTS+6GVTAb43kd8axgpKHKx+NRyODUPx2WBVGhNpQ6tCmCZ3WTDgGmcj7iiO9mNHPre9GijvZ/kT2E98Y8Qk6mAB4W1d71Tw2+yrXp8oc+eyVPCRdlwFmFjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061806; c=relaxed/simple;
	bh=vsjkFhzbw8Mj9kwWHsBWD1yi6AFymH0oA4rIAH8CUsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxbCjVWDVPNni0r2aYbVW4CdfTvPYOTsGyQa3+Fy+LEm41WkCPBgfR9k8CwVdFGQnOiKlG41O1J3pYO3+tGquUM7OcClt7FkG+bzlGRApVWQblFl5kiz4HcSi1o6Exwm3KJcYuCruw6By3uJUKsrsHthvJrxf/gVx5DE7iD2OR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JaZvTKlN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JaZvTKlN"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-220c665ef4cso15913895ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 06:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740061804; x=1740666604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KL2GRd3tQihpEe0t9Wg7SFp7S8xR2Og6WhiAG1dGLnc=;
        b=JaZvTKlN4fULPqkXZzAAWPjeMhL/p8wIpeyKn1Kb1SMJD/0vuQ1KXn7gpbOMoPLsuZ
         9NSeIPb9DExwLLej3yEnJIEXcGggCB6pux866EUBv0ZJa+4AxxOdf5S6eNf45WKKlROh
         rT2Wa5NbtECtqKkPnEhiB7f1ubmHTlLXRuQ6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740061804; x=1740666604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KL2GRd3tQihpEe0t9Wg7SFp7S8xR2Og6WhiAG1dGLnc=;
        b=giP+MuljafliXK+71TXocvzYiCxYJlcUL1zQ6RdZUxD3ol0RHBZn8wGsKtDk4hImE4
         HV+HxHAi8t8Fi5NOz1xW0StB7UO74u/yejUuNxr6jaUZCP5VBRwvL/bC3m5+OctRtSnN
         ecjMlYAyxME2cJV7I5ww3NoTk67ZiTR1SQN3Ewp5un/uNtXRQCItoZE2zXJz2XMEOX84
         6HkQkKiPQkCpn6eNH3PLyo7/vPQsfucPYxsyEOnfB+524myyj6iNJ3T4P+EmXxqO6NV4
         T/H9eyfLc3oqWTER6oXWfsSQ5NbXJvq5IQoSGAQjKAM7xTEJmk5IcVwJKnLssXCwBKeK
         87Ew==
X-Gm-Message-State: AOJu0YxFT2uJiWQyA9EwMADF3U44IEaYSyevfMDMhsEMzGHhvI7NrndX
	tzX9/MPgnCV6Bx6XmSGz9cwVBN/ZsaSWXxuznGfsWIfvjtAvmA79byVmAibWtyxBEVt0nEqBpag
	vyZC1RsNxRWJygbwjHhf7vbTm2MumNdJm3DNTN3H/xxIF2OkLthJ8AmFY/MRkkwquV4PJ+yw02Q
	5w4DSHN2ZWD8uBk6m+KskPnzrsLI+bmDL8zRjei/Xe+m4Yfw==
X-Gm-Gg: ASbGncvtBocyJiWIktMr5rZn2z4+UqFGLd0W2AMZfftt0Ya6zzkBtwgJVxgdnl5Vx2J
	B7iiGblOUh9OO5qjBjsXq0CSLkps+EKT+yhGXlDK7dUJtjokv0JTN1I6bU44pAVcr7UlJofHTpp
	yBkxjV3wJwGm1pqfvYz6Kd+bjRxKyewnVU3RGX2PfDG3Xfd/Ec7s8kshEQ1UGEkgLVZ/bBJ23uc
	my0s3Nx+kU9GjPWrK4woHKp/3Kb6mrjP4EQmf1ZffrRLS/ZYNFLRML6TpMKpLDmJEQpTbPVYOMV
	YkFkOX7cQB5QXaMdxVwt2cwEye8ycWbHuGXVRXUj9xiwgSOeQZvUwwuYreo=
X-Google-Smtp-Source: AGHT+IGn46KNQUevVNWAfNHFqMEE01eMxP2wHk3W4JgaXWxBYoOCrQQQlkW3xrNlyCC3g3zxh2XAxw==
X-Received: by 2002:a17:902:e747:b0:212:63c0:d9e7 with SMTP id d9443c01a7336-2219050e470mr37819225ad.0.1740061804011;
        Thu, 20 Feb 2025 06:30:04 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d47ba84fsm122551805ad.0.2025.02.20.06.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 06:30:03 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/4] mpi3mr: Update driver version to 8.13.0.5.50
Date: Thu, 20 Feb 2025 19:55:28 +0530
Message-Id: <20250220142528.20837-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
References: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version to 8.13.0.5.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 3348797bc73f..9bbc7cb98ca3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.12.1.0.50"
-#define MPI3MR_DRIVER_RELDATE	"28-January-2025"
+#define MPI3MR_DRIVER_VERSION	"8.13.0.5.50"
+#define MPI3MR_DRIVER_RELDATE	"20-February-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

