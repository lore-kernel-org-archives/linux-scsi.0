Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ED83ECBC8
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 08:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969559; cv=none; b=ZzT30hGJMRbwD/QaIM4cqF/N2nQ6umfNYA4dPPuv9Bvj6DYscnMUu9cVK403gV/6wkIqOlLXmbCwvN/BVaT1WZ3iAVgSYHUbWk0WBpcr8Mp0GTULq2s8vkYgYuV2r6IaRmzxO9caqYnsxtQtgJHP+HZ1QqarwIBk4c9+f48W3Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969559; c=relaxed/simple;
	bh=Ipm1/+N+UR2EZlzp726dm6ADjYl4tUPqfX1XEeSMZ60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kS3G6xy+krvbCeWLhGbIPwPLuHA9nR60uJ2VgcImCIm746RG4StNFv7EOUEBXIUjeBNu0tYbVfR1bjncphUr+IRRZ2KhELIsBlYeRzx0lSiOryrudSsy1o6gaegXFBXEuLt7paDZgQvcBC1bNe4EOXy9LjsIZzHGo76VsSwsylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=izTgSmvR; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="izTgSmvR"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-445795cf6f1so2985039f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 01:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777969555; x=1778574355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sXd3ING9B/AfI9jdVOu5NsWzY0t3tustuBe6Esbl7Sc=;
        b=izTgSmvR8XigoWvARMwTYenCRygzxVoE1/7kSfesHatxF8DZPzma7vnQCzraXHx4cG
         4zB1+/HPgqpuaetMlp1NlZ5OMNbGtW9uqjck1DW8wPrw3/F0ukmGsgaN1ngd6CyLKo9X
         b42i7X3hnctof6loidQBNwTGxGD6ik9Uw3Ywc40KvmgD/jrnPppJ2ApcN6j12CH5xZFT
         xPrZBslOnOevD7H0Qe/YIYY67E8Tmsq+j7hjzDBghCDC5EuVItcDb8P1MOTHdYylu2H6
         Xpig+pw6ZkMalaB4oBLsjduTv8jp40ekiUw5oYR15gzQOqr+djhB6bHw9OXnFYsgwLYF
         emTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777969555; x=1778574355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXd3ING9B/AfI9jdVOu5NsWzY0t3tustuBe6Esbl7Sc=;
        b=OxX2r9e1OHUvByo1XsOqEKw6LS5Gu7dXmbOmpDGz5NwMANEfzj5utQgBB5eNTQmN8U
         TdBYTgjB3whPsLTWbE4Ki/g8o6JYh2rR+ZVVIw5AaDwQMnGiWDRXL+IGPPbxqVKeIE3h
         dV5/WxFz/4Bh2p3Y2gj53kM3/5Ym7DzLLx92qTJQVaF+gXxwtnUU5acs5/RQcm/bgglk
         uacp30vU9DK1FIIeUQCjIRB86bXBzUM2RjyCeC6pb6Ke/O+E2K5SS1Dk1mXEs1Ktad3J
         Lc4s3uSN6QmCFLzGj0PuyaLQDCVsrSrHFz1+PmuVjx53zE1PCGZ9a3R/+lmihBc08Or1
         AeIw==
X-Forwarded-Encrypted: i=1; AFNElJ8pZbda5MF+HAHjzIznohkmpDW3ElXZq+juMlV5zWzdiskmdpfSPaEBPy/Mqp8blyqwaUTJN+HxJEDk@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Ftrwy+y1ZAnFdi+TxtPUSnxsO4thTVx18XzFV8/F5ehYV9R+
	OhYcgBpM64kfFpZltFIcFh0H/fc7VvyOvUrTU7oZcEGRT/RXd5WtFFaG1N7AgN/5C7Q=
X-Gm-Gg: AeBDieus+Hjq4TbMCJVWN7xsH8eXUTMUw6nMsVXZ829pTdhbFyTL5ZOPxxcb/4fo/zg
	WWzuGAZkoZLKm5IeDajD39lsWv3THbOP+yuNY1rA9ywRYYjYszg6zl64RzDXF4s/orKV0KUza/s
	8T49O6hE3Lb801n+WG5xHAplieb4xhhkmlylXAMuqqwjVTQq5bXFVVxJ/2m27gYr0PttOBs/YIY
	EvUZeysymlhyWNP8mWP+420ayAg7Y3TJWnoY/YQ033GOrvq1KCicWc6Nr6EQ6hW+1Glh1sZNq2i
	H0zJ2RR1uj6adXtahaEso4C0Ca5+G7wC0AkLWWNcjf5KAvL9zOyQKMrSysNlQYED0yR6mbvjgaM
	19tZXV8oirrSQGjxXBbpyx7u4QFzCUb7t0dcri7ZYmxHC2BM2nokBsHuax25iBeatdsJyxn74ZZ
	Df1PqQAZ93/Do/3CqSAced8eM6xITHNub8TDi2kg21BY7MbE83WhzVFscFmCn1QRfm7B8zUOsHd
	poFHHkGiiQpbDjxILDu0xwcXg==
X-Received: by 2002:a05:600c:8210:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-48d18bdcb31mr29058625e9.17.1777969554885;
        Tue, 05 May 2026 01:25:54 -0700 (PDT)
Received: from localhost (p200300f65f114e082236c6257eff72a1.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:2236:c625:7eff:72a1])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a824f9f0dsm365942955e9.15.2026.05.05.01.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 01:25:54 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Archana Patni <archana.patni@intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ufs: Rework pci_device_id initialization
Date: Tue,  5 May 2026 10:25:43 +0200
Message-ID: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1375; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=Ipm1/+N+UR2EZlzp726dm6ADjYl4tUPqfX1XEeSMZ60=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+amHtrEUqSl7ftLRc2QtGyFtRPexc5Pr6yJpR WegllgSLPeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafmphwAKCRCPgPtYfRL+ Tio8CACkzPPvxNBaS2ZBK9jgDBbcgN2vtNDpIBtQdOT7dI8WbBNic2dFe2Fwa4TosuWEqOYbHk8 9tIMVXTVyx66ygedMkHsYX/bs9aVK2Az7ROyxs9kSdwADjeWoFLLwxXImrIOFMtNHAmqp1HhZuW czQffRen60cpoVwdTdIsS+MrmwDUxBn3fgLrGXGGNN6HcGENzoIWOi5OEqChfcFGLi1WAy9323G rP2M/3DQ1fWLCZm+6Ruu1ikoPrdFiHiCo/AhXqyuOIKZCOEdmp0X7J+EfwPqpr3AJ5+psP2yvOc ff/sN+a0DmxnR+qgFeoKXP1QBsa3ersSNhccumBTp7vMgQ1h
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

the patches in this series adapt the pci_device_id arrays of two ufs
drivers. These are preparing a change for making struct
pci_device_id::driver_data an anonymous union (similar to
https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/).
This requires named initializers for .driver_data. But even without that
this is a nice cleanup making the array better readable and consistent.

The benefit for the union is that it allows to do:

-	{ PCI_VDEVICE(REDHAT, 0x0013), .driver_data = (kernel_ulong_t)&ufs_qemu_hba_vops },
+	{ PCI_VDEVICE(REDHAT, 0x0013), .driver_data_ptr = &ufs_qemu_hba_vops },

and

-	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
+	hba->vops = id->driver_data_ptr;

. This involves less casting and thus makes usage of driver_data a bit
more type safe. And this will make it obvious that the ufshcd-pci driver
lacks a few consts.

Best regards
Uwe

Uwe Kleine-König (The Capable Hub) (2):
  ufs: tc-dwc-g210-pci: Simplify initialization of pci_device_id array
  ufs: ufshcd-pci: Use PCI_VDEVICE and named initializers for pci array

 drivers/ufs/host/tc-dwc-g210-pci.c |  4 ++--
 drivers/ufs/host/ufshcd-pci.c      | 29 ++++++++++++++---------------
 2 files changed, 16 insertions(+), 17 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

