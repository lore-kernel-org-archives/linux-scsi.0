Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B69D11CA0
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731260264; cv=none; b=X0iomPeyfiu+ZuZOWJxaEsVG7DyXjs/Huo0ptdKF6f4Dw1GqDBx1lC+dXZR9A9PajTfugJ5Ae06OT8w4QM58pYE8M1GYg573rqFgx1F1Ueg+rKHwrtmNfROEP3x3okeOKgg+meSWoJbq29ud2jEcC/UDj02g3489rHNnVaN50fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731260264; c=relaxed/simple;
	bh=cAZQsyVx0QKr0DoP7NYqnCm5eWAvmKKZ6Bclq7gdfNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PHmKHcc4ET44voqsTrc/FzIQSTvOQCk5tKs/MRjtNhQMJnu8uePF9ryvKmo1QqJimmOQuzJsELVWrIZqM+BHT+djm9QdyzNgnNANlV6+E4gI7Wq/LTji3f1nrAg71LEVGTT7ijGGIhNlC1+4tqUwt8BGT0ZFE1pFCzBu8bI3YYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ZrKCEP+r; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZrKCEP+r"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20c805a0753so36150765ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 09:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731260262; x=1731865062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GhkFurx0VWzHaVxLjL64/n5qUuokf7ebUOZVyZc9/zA=;
        b=ZrKCEP+rBG9LxOtHVnpf3xtz+2lVKAysn0NRyzKBnTm4MofiCKfYBQIUUAG7AEtF+b
         dUihVQX8zQszlIvnC+WTyimIh2sQjeq0mnSm9NEqbSGLs+NVMo16EqrviCenRfreXOKT
         P6Qycu0sMo90x1zvVUwhMPKciz9BP9l4Stu1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731260262; x=1731865062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhkFurx0VWzHaVxLjL64/n5qUuokf7ebUOZVyZc9/zA=;
        b=fH9p8+k3mP8Wyb5++BwZSaYwfj6VILh1AXrrabHoDLCOj7muGjvyYPKX7rluai9vmK
         RRQgpTZXGr7k8g0OjTyrqgsclkf2BuQgFkKvS5ue02BEnZGMusO9EAlaEdu1qgQKpgiw
         mi4AmSLwr8u5Ifg3qCAsoRx7TXPEJBMeCT9oNVohaJlPuljTa3Xi4O885esNAHemnFSx
         Tw3F29UAsjCFMsGJvU9yX2LNSsy3yUsbm/owacIpocHcpcUFmCs5hrQLFcICRrAOSF1W
         VuU8oWVSzF9yMQLGTTeUp8ze67V0KzedyYCSD8h3d92oe5ULxaqKl5NWYUr0iwzTtyxi
         9GDQ==
X-Gm-Message-State: AOJu0YxMLIhpnyLbYEhb8b3bQRzHT49eGkizIJmcdbF6ge8YKL7ZcvCW
	/sxGqjAuPTVMMYyIydCpiQGYmAspqR+57udK/thygY6dsSZD04CtHWzaiK7IPqMwQJ6JAzwOcQJ
	LCLizG2w00YDc9pva89Znl1cRs+O1q8SUELOWPGrgbpB324L5gl3aoBS6f0qelU/D2apGO4WtDt
	ezxRH8iMPj7Ts+KyLiHukidQ0HrPKycGczl1Vpyq+VZjd2eA==
X-Google-Smtp-Source: AGHT+IGsMv7zADryD2hGZBGwYq0g/jODb+7151m8SYGveqRq/MLJ3P2vCL9ZTaOlgRviO5SJ3zfoIQ==
X-Received: by 2002:a17:903:11c9:b0:20d:2804:bcde with SMTP id d9443c01a7336-21183e0ce16mr132601255ad.35.1731260261517;
        Sun, 10 Nov 2024 09:37:41 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177de0447sm62314465ad.109.2024.11.10.09.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:37:41 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/2] mpt3sas: Update driver version
Date: Sun, 10 Nov 2024 23:03:39 +0530
Message-Id: <20241110173341.11595-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version along with minor Enhancement.

Ranjan Kumar (2):
  mpt3sas:  mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during
    driver load time
  mpt3sas: Update driver version to 51.100.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h | 8 ++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.31.1

