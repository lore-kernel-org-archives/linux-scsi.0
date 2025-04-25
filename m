Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3B12192E4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609076; cv=none; b=GdCiG3jc++rDYZIySCJ/yWw0LkM3gvcZIBrIFRlv8jbaGyrdyBLUzgOAMrY8YiGZaLl0AN+KQnF/LmfUsT4ZGUZ1PyRcvNNDxMananldeWS7urT8MZT91c3SIcX225PXyyyYznuKCZ/vJermu1BrhBjrri7BMW/5DqYUFBrlJOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609076; c=relaxed/simple;
	bh=IyyUXe40hpaCHh3NxILkhV/uL2rJT05UwTt96ueGMdw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Zo+d9gz1BJsfgBIpgkYQ2H34OOjc/MBN+mBuznqU1rA0wqlD63xh4SAb4D+4FpdM7zwRqeWuw+eMf4ym5hKfYK97vM0c2HqnDqgWigLNqPrLLC9Ssy3/inuaMV7BEmRcHP/nQYtkPdWEoAcsnY96jui21hqfjShjDzdTYv9Nh/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HllHzxLx; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HllHzxLx"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736aaeed234so2319218b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609074; x=1746213874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7a+h4ZZ7iy7LVmLFkasdcOpSh/wuCI+Hl8osaUgS7c4=;
        b=HllHzxLxcuD5FiR3j5yFKbhD3BFM9ZuXyEHZ78rx3ivUEp9q1BtnFKdTCjdIlkDbMd
         TMvGJnAHucfDYB0YQp/8UKpLT89xRP574IYO9+uEmYxEU6jjLCw45RLF4h3hGZS5Cmfy
         6Rju9YmmpGNXq1aeaP6raxew9I7hPCMBZbqP3Fs8pXvM1t8qiioZw79mTWrK94yEtxAe
         bzn3TDb6Ctmf2bIVFos07frCFuWZSbeOX7Wi5CsEIEWR9pUfc6ukCaACcPGdbhhSFlKF
         JFEDLCX9ufpJw5hn+Hi2DjTirSHZan8NWV5mjhF1+oOpK4WVfUHDznkIAOP2U/cgGTl4
         I8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609074; x=1746213874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7a+h4ZZ7iy7LVmLFkasdcOpSh/wuCI+Hl8osaUgS7c4=;
        b=bdDRZmIy/SxG2Ssrdd3yBW+OKvyzR0y9pLkSJJZJ2McsgyLxxFlV4J9td42oyH3Taa
         eHjPVSkZT6BnlFTO8NJv5kS2xKmtVHhmQYPo0pl+v35Qdi9uBcHCmYX3eDJ1sqGQB/mF
         w8jvwX5pigvfhy03izHpJaomcvxZC557y6ZG1tCTf6hLHUQSJA+wyFpAo1JexyT7cuzr
         jKLNTQwOJEw/IIB+l6nVwvuCyaiCLz53FrBDXcL0I7qp3KEpiA7qR0ROaZriXXCdenqz
         T9ZN01MQrO2yx8Pffd28Vc0cl0IvNcBKTV/BNM4l04P/SwquS4iuvlQYDUMYYd26Prsb
         ZJ+w==
X-Gm-Message-State: AOJu0Yy70/aNP8qNWsnrjCp4CTas2q0KHA/sZ6WgkuaadU9h1zeICE0Z
	o79Po3sfKhDT6eH+PSJIdQ3hPV6o+lAIUmR/W77LI69Q0LrP4ZwlD/kmyA==
X-Gm-Gg: ASbGncty7ErSeAlwcHiScKQ8A0uGRCFmY34AhcjHfoZ18OE81seiF19tO9IseBTy+X0
	/TBqHEi0ZR1jbnok+2scbpvq6DnK8N6qHrk0pnyj+Hk4DCRYCHPtaSzSmSgo+VYkYksU3TbhEby
	7knYwPsMQoXJfYTAUF0rxH8AHVgJUweC1ygSO+JMnkuH4vKR0FOyJxjtdfuMMxsb4scp4mrbZPD
	dxh8BfQ0WLAAXfkDmYUG6t0QkVPLV5S3eN3DU7ubgC5NTzJQIOuCuD04pcEIGQjyejftbJWzKWb
	/wfOm3/X1jqL2/0xP3KJ/R5XvbixXcb3dO+5KwrRybXpzVNLIxpLVpIKB2ll3yrXnQZun52zwJV
	bUZInAlCvSFZGivYXx8ow3DxrYg==
X-Google-Smtp-Source: AGHT+IH2qaAzQlOpCPHHyMg9iI7NziA0e56wGXRq9EyhtfQeILoPdAnS8mmm6BvQXqW4YX1WEVAI5g==
X-Received: by 2002:a05:6a00:3e2a:b0:736:34a2:8a23 with SMTP id d2e1a72fcca58-73fd896a139mr4124026b3a.15.1745609073751;
        Fri, 25 Apr 2025 12:24:33 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:33 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/8] Update lpfc to revision 14.4.0.9
Date: Fri, 25 Apr 2025 12:47:58 -0700
Message-Id: <20250425194806.3585-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.9

This patch set contains fixes related to handling of WQE commands, PCI
function resets, firmware eratta events, ELS retries, a smatch
use-after-free warning, and the creation of a new VMID information entry.

The patches were cut against Martin's 6.16/scsi-queue tree.

Justin Tee (8):
  lpfc: Fix lpfc_check_sli_ndlp handling for GEN_REQUEST64 commands
  lpfc: Notify fc transport of rport disappearance during PCI fcn reset
  lpfc: Restart eratt_poll timer if HBA_SETUP flag still unset
  lpfc: Prevent failure to reregister with NVME transport after PRLI
    retry
  lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk
  lpfc: Create lpfc_vmid_info sysfs entry
  lpfc: Update lpfc version to 14.4.0.9
  lpfc: Copyright updates for 14.4.0.9 patches

 drivers/scsi/lpfc/lpfc_attr.c    | 136 ++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  38 ++++-----
 drivers/scsi/lpfc/lpfc_init.c    |   3 +
 drivers/scsi/lpfc/lpfc_nvme.c    |  10 ++-
 drivers/scsi/lpfc/lpfc_sli.c     |  26 ++++--
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 6 files changed, 183 insertions(+), 32 deletions(-)

-- 
2.38.0

