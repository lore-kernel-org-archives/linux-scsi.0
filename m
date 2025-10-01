Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6694F2D9EC4
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 11:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318785; cv=none; b=EPacgHPYm7hpQXEigBtmdBDvhwFTTgPYo24wrPFfguF6/SPk+pCrCOf4YSAhQi+zESxjOy+uYj6MTnRlQJwQk5qiew0JHoK40MICbhqcO10NMQ7DHX8B+PL6SzmWPJB/sHIdFKJ+3ntHFdtWSut853ASA/uh56+G7AM34T4CqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318785; c=relaxed/simple;
	bh=EZ/ruoFThtPHmGMSXU+ZVodkvu94EYOb1JFHVd8D+zc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G4h4ixwo+cqFgYN+x18BfNtJzp+k7PaRbIHKBX9mEwxrLbGUotYO0eMQ4SxpWK4gViqzD59S2lp98758HyI6FnxoYLgHJkovLT8rtajvLuagPdtDIzW0ixoE4lIyLIYcVV2A1ioOFxwturHGt+A3BHgNdzspCdJzamRlBNbeEH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vpdw5Jzk; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vpdw5Jzk"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27eceb38eb1so84597275ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 04:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759318784; x=1759923584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ucUKCkCMkh3x6kA2pKF0IykrcO1bxzY4CZHYLxDzmUA=;
        b=Vpdw5JzkAoEkN+6wCuWtRKVC/hG/fZtc5mK7A+5bPnYjDnSwqE9ZjDneE647rJ8WAS
         gWhwtc0crZM8cbNLw+wQurR02IF+LrEcI4dl/rI717EQcJl/4TiGBzU8g4IvVC2fryfS
         JpiDUPZFS5uCfLTzTVxCxQGS39eES7miQOhQ2qLUct4XqXFfEwVymMxJwr/O4NnIhHni
         CUTu3Fr8oCkTKCvRJQewlTdIu0xQ0CFl8dW3cLwKEFvE9LcU4XoNVK8vBlJfzJAuC9rN
         sCv8z6asEPTLAnDGarLSYxr+2EKELEIeMHfJx2PT/hGt9ZSYLrt6Zk8GrsO3e2Nxcjku
         T/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318784; x=1759923584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucUKCkCMkh3x6kA2pKF0IykrcO1bxzY4CZHYLxDzmUA=;
        b=DalnyI9guHqD8/8X+Zx2QqLJvsz/6GLAmpV8Q+aM/TXkcM81GxfulOkF5g468SvOsp
         pY3K7P2imR9VrJCL0Hk8f4suoXJa2MCrVmu3RCMmwwbymb7Frc+6uL4ulIsGGYsaE60z
         IV+Licaw/7o8WhhS44ft/vpTYwcPHyN28kDpV39NkHr31rLnSCxk7ZazSHv6pjbqPZLN
         V7XIHBvknSQ717gUcD+/nZTIogkJMfWQmum1Y/iYjOzLASrZcfLuFvXosbhNdEw4y8tv
         2FiP0lXJ4OiGEyhWdgcE3FT6il2WVCn8gAraQAiAXNOvRBzdi0rQh+PpU4f5CIOO44Jh
         1pSw==
X-Gm-Message-State: AOJu0Yx/LHWktBphQoBsZDh+kvf0q4cI1Lx5FN20Bs9BWbvW1GQgjOEK
	JHLS1jBYvwjEhB8tYcFLuGBL2caxNKKUAOKgmGBH+OAJ49U4rgssLutI
X-Gm-Gg: ASbGncuK+rToAJlgCQXc/2ncf/uNiRmF/rnJGzfwU6e5/TFlwkXQHMxSDLueyqikM5H
	58W8QZaweCJJWyxCoNFwNpfwKGBWIKGCmvOboOOgKSlZAs6JYACSQVbCmm2tg70E7siIdaUYBFk
	q0EuwPh2NlCfldwO9ZD+21yajhnBYY6ADPQXSXJ+oIypXNOLN4J1n22ZUeAVvJgfmQaMZ3Nwn4s
	tlm6Eqt3eCkXMhP4oCXhbcZDjTL65Cq+JXpt3Yl60RTCyx8TtgW0cSsp8KqLM1Ou4oKl0b33Gbu
	+3nip8OgJXaDV2ASjCdrtLUsntMKXT4N7Stfr7nklPJ2pcQirROM9ZLFhHOhTe5a6DWZmCcB/HZ
	t7mEaS9WdYhmMMf1UQunhoeDOprNxa/JWW0GrHmw6zdrvpXRO9KelU/vNSFAyjsD9WQbN/6tqVw
	==
X-Google-Smtp-Source: AGHT+IG+vpAX3tAnKfYzMMgoEqi+4cPK2iHVtV0PmHOHWt1nTyquJ83FzARzXBcYPKEjPuTIuKYquQ==
X-Received: by 2002:a17:903:b46:b0:252:1743:de67 with SMTP id d9443c01a7336-28e7f318717mr29455975ad.44.1759318783552;
        Wed, 01 Oct 2025 04:39:43 -0700 (PDT)
Received: from ti-am64x-sdk.. ([157.50.93.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28d195d5583sm53135215ad.117.2025.10.01.04.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 04:39:43 -0700 (PDT)
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
To: Don Brace <don.brace@microchip.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	bhanuseshukumar@gmail.com
Subject: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic size calculation
Date: Wed,  1 Oct 2025 17:09:35 +0530
Message-Id: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use kmalloc_array to avoid potential overflow during dynamic size calculation
inside kmalloc.

Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 125944941601..7ff39f1faf38 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8937,7 +8937,7 @@ static int pqi_host_alloc_mem(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count == 0 || sg_count > PQI_HOST_MAX_SG_DESCRIPTORS)
 		goto out;
 
-	host_memory_descriptor->host_chunk_virt_address = kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
+	host_memory_descriptor->host_chunk_virt_address = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
 	if (!host_memory_descriptor->host_chunk_virt_address)
 		goto out;
 
-- 
2.34.1

