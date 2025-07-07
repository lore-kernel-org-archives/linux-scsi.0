Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A3F2E8DE6
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907932; cv=none; b=jrDNctt9FVxzKAcI7RLZyMzwoVibt91AZIkmo4K8j2w4DqdDlSKsWL4RH0/M3LrvbDAbKdqFOL8BRNOMewjRU66LxnjRbKBxkYezZyc7eDgf6v0cVYdefFgAYkaps3iLo+xEEE5F7BqHKsQbXVCrl3MRO0Gy+KbitJlk0LsHUVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907932; c=relaxed/simple;
	bh=V7GVXPeniRjfSBXgyWCdSqUUNadL/PC4wB6+w+kmXrE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hQEgCtFdJDLZRkLgqECYUWJJHJQ0OgWG3TSv7YYyXyWs+LQnQAm9Wj4m6MC8zRTXzQ/rD34A/RxuZYXnZk6gxtKT3Q0Tqnc1/vL4OjVGikQXu+AX9GeaqpogAXmD6Dkz3R19aWQuKX82/AJAJZx1R1CV1AGU3BJdf3Rv9BsOju4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GfQ3D63d; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GfQ3D63d"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ade5b8aab41so705884166b.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jul 2025 10:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751907929; x=1752512729; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=57rYJvDLr2D8w3kMcZW5Qve8k2sDHgGAExSpeGzzFo4=;
        b=GfQ3D63d+nGazbk7+lWB93ffVNPgxydPzyZXj3KGUyz/vIms4FksdDaxrU0xQ429vw
         rx+TtugBgSOEJDFoHPbvG9HYkXmSU6leJ+pqVLcTfaj8G7FcqCEW5S89ZoAWI+SEDzgV
         R+dCV2bGR+srkCuQrAUqx9k5W6qnKDVtbbsZ+xPEpCd5+oZ28ot9cUeQi1R9kpBT5WUv
         AFaWPypwbM1YUFnO4YHJFENdKPAxbUQgkL1KI5BWHacbYjjWvfmR+/Z2A+/Fd8vZCHTa
         byUzedF4qHVgnhNVvmiIeNvVMGqmkWFKwxDl207Q6MGm5nGKidGmgu8kCcce9jdkyxQ9
         Zt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751907929; x=1752512729;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57rYJvDLr2D8w3kMcZW5Qve8k2sDHgGAExSpeGzzFo4=;
        b=mK3rVqA71W4b+F5LMlRP/qHX6MicdJ/uO+Jx5EazpMWoWbh4xksc9lKC6DB6AmEJu2
         yVWTtRe/Njo0A5S0oscG1RwwDYnn0ZYwPoNjfMZjwGo5chMXARjEukxNO7eq4QFCqsPP
         13bMKXrIKQiabTFMF+5nQM42rCc1E94a2D62Pc+wdilnXYzDlZutSh8HF7yMapJjv+gg
         fdCTrNluKucG9cIDuJ49lpzCMgJEwi4kMJK/0T7o8J3Od50qm3boB8APA3tvAVh6bP+I
         tkmz/b/SZqDovNsxNZ+g2vSUtVX5fUelbteKQDM1ndfHHN8/2uCzBQIiLpBo5MvwX9HO
         hcjA==
X-Forwarded-Encrypted: i=1; AJvYcCXfytnGW3q72TbkH6d3HHVnsVkJBw3ZvJuQBf7iQiccnnSPYT3O1ghthQq76ehw2mbY3THDJOdbC+/F@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9frJTM0owW1eFtzaV/7j+WZRixftbqM9gsr/1Z9SeIrVnOsWd
	mYaH+/Vm+mdPHbHxiwJL1wfUvPTaCCLkx6IGxMJzH0G/jG1zD2HjLRtruWhKCuvJ4IU=
X-Gm-Gg: ASbGncvBFl9h8RX86yzIlxZTcOStuBPSEGX7CztXHhFvrsA4hQ2uwsgd8b7uWsnRzO/
	/b3Q8Wva3zKItBApsvJb7LkfGcL1JCJsmeO994h+7aVPwz+rxau/8ZT4fDxPt9IIhFQYXuOutAb
	wjP+UdDJhti9lDbwyua5AdqokM+bVbnEngST706nNsRqOjcAy4vFnyNmJu7Hpgog9IJFoluWmrC
	Ft3c8t+Vl7hK0arzB4sE/DjxlcKg84oW87VVz0zU5wCA/dmKhlrUX5a0TJePMsrrB4m1iKsYwGD
	NOp951yvfoKS7udWPV2FJdYg2lw3x2tmvqQtPfFxw8/ghufIo8Mq4nghjVmQ9BpdA+iMkunctvA
	qkGi0/mr0rGbINXjtzmvHNtrFqKHVRDxB7DvnQs7mCkYnrg==
X-Google-Smtp-Source: AGHT+IH39ie4cMyXIg4z35kSN5NcopH3AiyCIAZ7/0N31t7b87LaPnUMjOhDIkjPEUdI9Xt4zZAZOg==
X-Received: by 2002:a17:907:3c91:b0:ae3:70cb:45d5 with SMTP id a640c23a62f3a-ae3fe741335mr1295648966b.48.1751907928992;
        Mon, 07 Jul 2025 10:05:28 -0700 (PDT)
Received: from puffmais.c.googlers.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac54a0sm745507266b.109.2025.07.07.10.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 10:05:28 -0700 (PDT)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Date: Mon, 07 Jul 2025 18:05:27 +0100
Subject: [PATCH] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
X-B4-Tracking: v=1; b=H4sIAFb+a2gC/x3MPQqAMAxA4auUzAZqqT94FXHQmmqWKo1KRby7x
 fEb3ntAKDIJdOqBSBcLbyGjLBS4dQwLIc/ZYLSpdKMbPL0gpTtsgrKyP3Cq51K3lkzrLORsj+Q
 5/ct+eN8PxFjj5GIAAAA=
X-Change-ID: 20250707-ufs-exynos-shift-b6d1084e28c4
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, Seungwon Jeon <essuuj@gmail.com>, 
 Avri Altman <avri.altman@wdc.com>, Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, kernel-team@android.com, 
 linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
X-Mailer: b4 0.14.2

On Google gs101, the number of UTP transfer request slots (nutrs) is
32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE
incorrectly as 0.

This is because the left hand side of the shift is 1, which is of type
int, i.e. 31 bits wide. Shifting by more than that width results in
undefined behaviour.

Fix this by switching to the BIT() macro, which applies correct type
casting as required. This ensures the correct value is written to
UTRL_NEXUS_TYPE (0xffffffff on gs101), and it also fixes a UBSAN shift
warning:
    UBSAN: shift-out-of-bounds in drivers/ufs/host/ufs-exynos.c:1113:21
    shift exponent 32 is too large for 32-bit type 'int'

For consistency, apply the same change to the nutmrs / UTMRL_NEXUS_TYPE
write.

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3e545af536e53e06b66c624ed0dc6dc7de13549f..f0adcd9dd553d2e630c75e8c3220e21bc5f7c8d8 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1110,8 +1110,8 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
 
 	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
-	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
-	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
 	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)

---
base-commit: 50c8770a42faf8b1c7abe93e7c114337f580a97d
change-id: 20250707-ufs-exynos-shift-b6d1084e28c4

Best regards,
-- 
André Draszik <andre.draszik@linaro.org>

