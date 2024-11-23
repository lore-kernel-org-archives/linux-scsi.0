Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC7B4204B;
	Sat, 23 Nov 2024 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732361447; cv=none; b=Kr83YayPPVjMqsy7i3rKQScvjUZC7pumBHnzyUPlhsCFHir/Xb8v+pfHQecuGn7XeE6WvHVYNnh44PY/YFdinpG2d4hElBpbw2H7CrGwDqn8sb0XTHlOC2/4OOxC/vpNvq73AXiXsJAKJymnd+6n3YI+so0f4IB+DD93UZ5noT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732361447; c=relaxed/simple;
	bh=s1kW0GC7tVu/ry+dzlrfNXs6b4WecJETvWvBvwoP7UY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JI0L0u3Nwfq3X8bcD4zYzwGka2TeO1DksTvAAsSc6I5EIXaJWLzaNXthTetGDgfqRVgQJLItm+1+rkaXnGwwv+/YXvmHx4mnpndvDEbSWHMTd+sB6zKmeXGLbHbUB8v5DW43ydPE/3rVXs9Vl8E3O6MvwEFXNpbgL6sZuuFor+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lw+czA8Y; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lw+czA8Y"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ea8d322297so2367013a91.1;
        Sat, 23 Nov 2024 03:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732361445; x=1732966245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BoDEcCDWOg767qwXyvpXiCVeebqUSdME87+maYfZUUo=;
        b=Lw+czA8Y4vmDaSyvhMoDjeLAlvgCBJpkIY/n5siDcKIkZ/EmYjrOOLSQNsWW0w88cP
         IfaAF3/gE/XAwzKgipSzY7SmxVzzW9YlIv170PztAKv5aw4SRbCTQWG4kiXaB2fUyUAM
         ekm9c9GrQ52P1OdMau3y4YRGF3t4ZifV9n4iJUOAkTGSn5FWcsWW1/ag+5ShU/r71Cju
         bUXoE9w8DSb0XqnjmkErV56yqDrcMCZ75g1m/L4uN8aFfdDrRSzqqNYEarkqGMrV+4Ck
         ZpH/jIlabOd3+ZKu40FtJsPnh5GRWCoBDJDSweekonDtGgA4QZKkopg1qqpjvfX9U/yq
         bNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732361445; x=1732966245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BoDEcCDWOg767qwXyvpXiCVeebqUSdME87+maYfZUUo=;
        b=sCMR7UtNqrK9DCDgh7V0K8CdEyOLl1or3BP7bmdtWReaweXgX+znYaCiUbfG5VWGJw
         sN/6VY8G2cH9U9xWZac5cOwEG6HzLZs03obBojLG0ICiR5IOrCjoBkxE7yA7mIW5tyWv
         Lxa1w+UrxQIOoQ2YDRD+OgO4u5RQnRKLqnfdauN4xgU3DjXQLruPJsVBYRG0DSuxh1my
         +SJ7nxQA8Fai9d+uGPhsErfRIl063BKJHa+PSv+ByIXKUsgrS3uEOWPGvTG2JQiqeXI2
         nEPGd4fVU9DwPAz6ygpS22z1zgVN7dWAzAWiQZEHoPjV3UX97KFJY0tKnK+nvirk3txo
         TVLw==
X-Forwarded-Encrypted: i=1; AJvYcCUgXAlhbGTZL8Q8vryx2mD7lZ2o5IZls6fSfZE5TYJpStsgDI4H5eCtW4m9XLDM4KB/xl5TXQ/fx+P7TPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2DREPa4DPRY+WsbT+XvO1+9FT0KUSMjHyLakkxzs6/4W7axBE
	dsqW3Y+bHlyZ0JvHgtsOVYDab1wXntPXt2tkdleBzLR3D5BsKewi
X-Gm-Gg: ASbGnctEdPOG0HWXJraLfAkjbHT28qGktSHKeIcoRcU807x5V/sSRFJR0/Np+VPF3ly
	cYy2iqeKTD3xtaw2ejiIscmed/+4eO37tbJw6kDzBFoTeFwWGtXPDJOmkTnTDTZWM5I8hEuw+wI
	uKPdYH4REkERsbNM1+ZaVm3CtgHUd8s7a/MnyVMEACsYCWgVjQI6HgRugpiiU9KpBPdPbqocCpC
	I6WM4O1w78Xu39WM0ASMwdsUAhsICOiub+fiN1hK6n5CtTFC1g5jA57R/eJ3ApiuTbkzXg04oXN
	NQxydNIv6cCC5eqOUsXAfTFxEnH5jX8a8TBMA+Vp9lg=
X-Google-Smtp-Source: AGHT+IEU8x8SQh4r9HRbD5cHK1d/AtFbp85c1bmrSAfvLQQxFbmsHUcltnW+iiHVjVXUgxE48lZiow==
X-Received: by 2002:a17:90b:17cd:b0:2ea:7368:3359 with SMTP id 98e67ed59e1d1-2eb0e126a6cmr6921008a91.5.1732361445487;
        Sat, 23 Nov 2024 03:30:45 -0800 (PST)
Received: from localhost.localdomain ([121.241.130.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de554fd6sm3072302b3a.139.2024.11.23.03.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2024 03:30:45 -0800 (PST)
From: Prateek Singh Rathore <prateek.singh.rathore@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Prateek Singh Rathore <prateek.singh.rathore@gmail.com>
Subject: [PATCH] [SCSI] csiostor: fix typo doesnt->doesn't
Date: Sat, 23 Nov 2024 03:30:38 -0800
Message-Id: <20241123113038.11188-1-prateek.singh.rathore@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prateek Singh Rathore <prateek.singh.rathore@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 8329f0cab..d9f0b6888 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -800,7 +800,7 @@ csio_scsis_io_active(struct csio_ioreq *req, enum csio_scsi_ev evt)
 			rn = req->rnode;
 			/*
 			 * FW says remote device is lost, but rnode
-			 * doesnt reflect it.
+			 * doesn't reflect it.
 			 */
 			if (csio_scsi_itnexus_loss_error(req->wr_status) &&
 						csio_is_rnode_ready(rn)) {
-- 
2.20.1

