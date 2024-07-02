Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544133BBE2
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 03:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719889321; cv=none; b=F4aID5fkddu+cWjhb81dHawjKKVs5wPsbvvr8ELtzMDEfkOcNhwZZQcXYU8F6DERpHxBf2qZlOB/nwrwCBL47pYEmlIR4f2EGE+UAwcrB3UldZ9TIHm319oRYK9XOTRBrz8YfBHe4ock7O05ZKFXSvIywX65s5u+4hw7XMNXvBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719889321; c=relaxed/simple;
	bh=uRis9c+lV+KjT5nqjRmwxBE80zJ+0PYiibFIcTHrRvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hajDc1gLhHkiEyMZGHwz2gq3uvUM6fiibUqzRm/4Drm0/y2btYa5oML8iYQmqvjFGmeM6ehjJokJ6xzCllTGsKwxEFHZPSeOViPNPzkY78XwxRv2d4i1tICK5+VaXIredl19D7B3pfDgkoaVIExO2kwJr/ac2FJVrz8+9Whl2Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=pass smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=KvYroCN9; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="KvYroCN9"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d846f4360cso353389b6e.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2024 20:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1719889317; x=1720494117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UUAtUfsl0CXkKYEgFlq233RO29hJRLPHCOz3KSrrbb8=;
        b=KvYroCN9/kO4AxHitthuoauC2Lzy/EMNieCZbWAfwkuBLtHvIzugioPdvKV4xZI83z
         SRLV84jtBBGDazGWEYdITHSXGMhXSAOwcXw6orekGtTBkBE5JEHKHGf3jO2+jInM9PGw
         vcyYfsI5bjmpXyTvdNkmPDRbbqRi3l83jXF/Rz0BmXR4oows+uIwD0/FvFUYEkzrBGAT
         wDYqSHYzQhLBf+42VILVtRb+YMc5Shn82yoT0zSFGk3LMc7PFsW+okqhrGNCKut9e471
         xDWCbrCPbKDe//ULV1AZj7GyDE7+9KZEy565E0mc9bt8rupjAmk+830acxrauVGWAjyy
         Z3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719889317; x=1720494117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUAtUfsl0CXkKYEgFlq233RO29hJRLPHCOz3KSrrbb8=;
        b=tp69dNu3eHBsvYDTvpbLaXoR99wiQjVRB6aYizvTdwnPvd0F5Fp1xLKOaZbmbzQMZ8
         gNSCnVL+pOWaDYkx5bt4auBNYJ+b5+8PHdFoLLRCVY8ZZtkr3jnF1dqFQgQx9qu7qFxO
         B2wb7cbpczSOI9RKwscKsjSipZFd9kcYqHTa9WE6Ad+WY37Rd0Bjk5LkTzX7R1TnsQNC
         NdLXCXUMtFflkgdxzT9bCy30HX21BVbT+if9gqoM3tljpDVhnLW+sEtvacf+sTMtE2Kk
         7wokKyv/m30eLsNrundO/4PHudqYroWscUxGTXs5lwRaVqCeEPHR0bTEZwaCYx06Bx7K
         VAdA==
X-Forwarded-Encrypted: i=1; AJvYcCXaaitQ+gmqlgSRxtdS42OWBvX2jSznLJJDTK7upDDEOtW5dSSUQwyEiwa10UaQZRK5nDOuYl+lds/H6mcSkOZ5AqKuzK8sitTBVg==
X-Gm-Message-State: AOJu0YyjuBQHGlmWazI3ohuN+rHN3Y1zs/6586bFAShtk4gwPMITV+Rk
	QaQuWQE6NzNp7g2CCRQpn9z9CBa6trRNGBUUWQw9n4uzBdAKxzlobtySIclCb90hk8+Ey7mTvSN
	k6EQ=
X-Google-Smtp-Source: AGHT+IHHUUaB6s0Oi9ST9tgc7dW515vCFgkHaAq1noINZIzQYhSZdfTlyGbd5oTc5vZ1rx/1sn2OKg==
X-Received: by 2002:a05:6808:2011:b0:3d2:cba0:f902 with SMTP id 5614622812f47-3d6b35ca4d5mr11712690b6e.25.1719889317231;
        Mon, 01 Jul 2024 20:01:57 -0700 (PDT)
Received: from fedora.smartx.com ([103.172.41.200])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a8dbb2fsm4792904a12.31.2024.07.01.20.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 20:01:56 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com
Subject: [PATCH 0/3] scsi: disable discard when set target full provisioning
Date: Mon,  1 Jul 2024 23:01:13 -0400
Message-ID: <20240702030118.2198570-1-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

this series has a few fixes for the scsi discard mode changes.
The first disable the disacrd when set the target lun full
provisioning, the reset have some cleanups.

The series based on ("scsi: sd: Keep the discard mode stable"):
https://lore.kernel.org/all/20240619071412.140100-1-fengli@smartx.com

Haoqian He (3):
  scsi: sd: disable discard when set target full provisioning
  scsi: sd: remove scsi_disk field lbpvpd
  scsi: sd: remove some redundant initialization code

 drivers/scsi/sd.c | 34 ++++++++++++++++++----------------
 drivers/scsi/sd.h |  1 -
 2 files changed, 18 insertions(+), 17 deletions(-)

-- 
2.44.0

