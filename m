Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366E19415D
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725532293; cv=none; b=V/mwaXC9xrV4CMyBxgr5R3Y7YS9K7rYqEPJ34CYzckJJmdSb9Ykp1v3lJ0Yd4nAEGauV47PdWSp4x9qJ5d69laamy2amqdSSx4vEy97slza2zn88R5ikDCXpwEo3026EAX4Ug8bDisB/GeCFihSbIxA80Fl+V/Qw8/DuJD7eXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725532293; c=relaxed/simple;
	bh=crwZFMkRQS+HwOICz9H5GHjgPtpS0nqB0pa2kxPVpvc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G4p2CiFJarGtWzlMIbg/MkBzrD5wTkvPiW9Y8yxvNj+NIExOoPft1V7Hxn31554pJw9yc4SnLdFF1H8XW1hCc+QIEgkaUp8yCoAdQ1uFzRgTvmr71GWxky8dVVdXSisxX7XrI2OTSmumBBcC2EXEwEs2DNioBHt1h9+2wrmIpGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ayZpiMJy; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ayZpiMJy"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-70f645a30dcso464229a34.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2024 03:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1725532291; x=1726137091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yPTHNkSaGG/rpmNcvAPYF3EMi3Wgp0LRBxTs5Xu+7uQ=;
        b=ayZpiMJyqt9jFU5+9TK0bgD56oAstiDR12oh0qzPOjUwI40T1rUzT2S2Nnog7456ML
         GQYOEmxezL31c8r1eRZ2xL6bqc9YH5KCk+RYuOmTum8R1KzzQ4ux6FJ7n3FivxyYiN+C
         StsgyJfEJMS0XfZHszpPFwTzdv2jJ5EqJhVRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725532291; x=1726137091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPTHNkSaGG/rpmNcvAPYF3EMi3Wgp0LRBxTs5Xu+7uQ=;
        b=L7n2kzmjZZDAWz+nY70vxVP+AS8NRQ1KvFwVgXK1COjJhE1KTAmpB1iOwHSJ+z2Adq
         EmbcgEK3pnUX1xaGdaKYx+jnp8qmj8qRQtwXzf77jgTl8q2b3PSADhxIxWxpvGjEFBUC
         Ho6BT6aujzeF3nazr6fKgNhLg0vNOPD3XcPip3XU4zL5TSRNdTrbW2Fws/wq/ul2fVfA
         9M7HaVFi+wIhrk/UQnyZBXqwF5KpDUKjezprncU0RPi2wT4sQxKvCyPTluYJK25RT/Mf
         C8d2BJ7uTT79m5B24ppGmTZvHpudvkY3U5Hm7jmc7RCWUrNNwLlN1lFNHJM4zmQx7dJZ
         zkpg==
X-Gm-Message-State: AOJu0YxLw3PzR/T7CWQCOHenaI6x8ZuORp4tOClMioXMmpKhZxXpJXf4
	6yVipqTYmzGeEX+K4hIAqLTUv9Sksef8tfisqLcsHrml4tRDIILSjJEM9pOEHER1WFa6c/haYM6
	HFEixEM2kP6Ue78AwoUUJdiaLrey9qjqFl1kYUa81+CN0IDSzyi1RlPW7gNxPsyEmXAi6cNI4G6
	OesSwRnEHFJAPE0wclB7LnNmEm9IrD05t1aMFxBE+oJfUBMg==
X-Google-Smtp-Source: AGHT+IEF/ssCRNWyIvsyEoYGZD0PZ8hXuJZ+Ric3/nt9tl6bw0eJt2DanvKav3rSGnsgVpj1Xc2Guw==
X-Received: by 2002:a05:6870:7013:b0:277:fdce:675c with SMTP id 586e51a60fabf-278002dfc1dmr13551563fac.15.1725532290577;
        Thu, 05 Sep 2024 03:31:30 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785364f9sm2960177b3a.87.2024.09.05.03.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 03:31:30 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/5] mpi3mr: Few Enhancements and minor fix
Date: Thu,  5 Sep 2024 15:57:48 +0530
Message-Id: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fix of mpi3mr driver.

Ranjan Kumar (5):
  mpi3mr: Enhance the Enable Controller retry logic
  mpi3mr: use firmware provided timestamp update interval
  mpi3mr: Update MPI Headers to revision 34
  mpi3mr: improve wait logic while controller transitions to READY state
  mpi3mr: Update driver version to 8.12.0.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 35 ++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 13 +++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  8 +++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  4 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  8 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 77 ++++++++++++++++++-----
 6 files changed, 119 insertions(+), 26 deletions(-)

-- 
2.31.1

