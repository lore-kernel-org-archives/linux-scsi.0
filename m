Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD2C29E115;
	Fri, 27 Jun 2025 11:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751024590; cv=none; b=E8ujlvVl1hv+zb/wUEv3R8rTebs0TxxbpBo8/xYJ0l8mRi86YnTyO1K9AgIt4vTiInKpMwXRHlUkJKGrHlvanb9rq8/I3iCNi0FkodHP3L5WGDV1aauIDF/IXCNKr2Ez7wyTpm0iQ6E/mFSnzO1ULc4SCsB3dWQpeP2Kb9gUEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751024590; c=relaxed/simple;
	bh=01x4DIG/MLfv54ivDmaNIOW309XnOy44DSBxspFOKKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aeUJCFBEnfZEDYXA81Hapfb6GJj796pUNdfwMeBw0jjf6VdaW3WHY27Bf4HJ6ZpJNPZToCNnQv4ncnZlvmYIfnyCfvbh/yD8wrXk/PztVPdV/0CUkHu/BSKb4Pd3qJyEYRfODcVMNx0h4uGgdvkAR6Ol0aoA5Yytf4GedrEdEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CxsWZU26; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CxsWZU26"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4eed70f24so311381f8f.0;
        Fri, 27 Jun 2025 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751024587; x=1751629387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6QGBPcCUdbQ9cCGWaoo95uH+3lhdSPiV9mhyp8TNwZo=;
        b=CxsWZU26z6AG7REZD9gITkGc6lucKG0IoI3m9BzCj5setzl8SHy3hWCdVx7Yeulb7g
         eplo2bX24mFWhBd+foDiMX1+x1E/5j81TTIRTw5GnAeShl2sU9ICRgaM3rmNTDIpGhcG
         LRTBXqGBxnsuLKLxiDsayrrEzD+VcwcaKLS3EkvhNzo+bH6QaMK/L6VlCTN03A96NQki
         L5I70joEU40kjlB8iUlEcvXeeihp8BW0INO9ghbwEMo4AQG8+m7ZPL2GrLKJy8/Zdm+A
         fy5rGJIxVBbUDButgmxiMfKmzv++MozDplAqOQy5m88wPTXG7AyikNO0aRysNmgoHNi7
         WQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751024587; x=1751629387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QGBPcCUdbQ9cCGWaoo95uH+3lhdSPiV9mhyp8TNwZo=;
        b=L9ozCbDp8HtoLe6c8vKcw/EFNn8yQai2DPjjCk2pWsuN2DpssSfX9rNB69ECKXaSfK
         7P+sXL/+Xw1cBDeoW0BRTG8ava4N+Or6cgjt2N8AbSeiWwasE5zE32y1b+xnVZ6UGVm+
         RUDtBmz1tgwf/92jURUabGySERvK9HDGJ2ThJODaXv3dJXjzCsoCLuIeuOr5PhoY+PvP
         4/3J3AWC0RfaQpw5iSnrSG4DhqbvnRFBCbZloJxfhLYiiWvjKzshQ4NrBWamU44AHVMH
         ucXPa7te7OX109+EBoc6biMht7UEw4OzlHrM2rGN7E6xwbWZAHv61iyysE+GmEb2t5Ef
         AVZA==
X-Forwarded-Encrypted: i=1; AJvYcCUF6T1K5e3bjWLXleUIlbW9dnxNpN1hYyC4F2ABc8dh0OUUqyiwZahvuDOvkfCklQVtONxtOiLPQHotI8ej@vger.kernel.org, AJvYcCVDzCOvpfCI6K3wrDdZVhOdgPq8cMWXNn3mzS0y36qtzl/iheXhRftvfEPDYT8Fy9zfTZfPksV4C8kcmw==@vger.kernel.org, AJvYcCWSeAaKvYKL64ZDES99RxqYafGDIMaomqnLXUGZRuHXjalhli1eY+kMWFe1j6S0L8k4k2vURamQyG2QRGs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1eNI4psUlA07J0ctZxx8QLyNVMXRHvtX4Y/OmgS7kAU8vGJLV
	EQIuq1YmdRh9F1olsIVsrF8dqhYfpYjXLBqxJWt/ebxPx0heTamePACg
X-Gm-Gg: ASbGncvFImGKkf7bxPEo06nEU1wvrf1C8fTAtH40wC5BsL9xrz7j3i7y+sph0C8f7FE
	Zv5dBLnJ/5VqqhElcV7BZ5k+7GG7TY/FSfgoPe0g/NvsRen4xrKQLk/JZ0JmSf9ZlWrvdkgvShq
	dtaAkUubBUEI+nrXnh5N9EJX/yPqhzfKeWjTWxtc+UgBvt1bvaGgnosYPa+oEd8q3P7WlSGF9Fp
	DXwRmrweYvFdVl196IGCPIMABC/d5zE16GynmBp+WHGzFIV/sSMaYccA3A0k3UKkuUUdUDUO4Ec
	yhaqri1Kr0dfm4pTURpsKt3BEfGgtuVxgkzsWkiY/cA3Uj5Yf2iY3yJFdr+1K3iZ2r4GRDVw1Ec
	4lMpkyX5T0uIdBvA=
X-Google-Smtp-Source: AGHT+IEzB8OKtz6EI4EG6Z2bI83b9XilioEr7YH0Ayx9iVh8UP+7DpwRKhNGodaDU5udaC4/Pdg57w==
X-Received: by 2002:a05:600c:3ba4:b0:453:590b:d392 with SMTP id 5b1f17b1804b1-4538eeb77ecmr12554225e9.2.1751024586994;
        Fri, 27 Jun 2025 04:43:06 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:c222:941f:da95:c9f3])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4538234be76sm78169655e9.15.2025.06.27.04.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 04:43:06 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: Fix dma_unmap_sg() nents value
Date: Fri, 27 Jun 2025 13:41:13 +0200
Message-ID: <20250627114117.188480-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 9ac69356b13e..bd3d489e56ae 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -382,7 +382,7 @@ efct_lio_sg_unmap(struct efct_io *io)
 		return;
 
 	dma_unmap_sg(&io->efct->pci->dev, cmd->t_data_sg,
-		     ocp->seg_map_cnt, cmd->data_direction);
+		     cmd->t_data_nents, cmd->data_direction);
 	ocp->seg_map_cnt = 0;
 }
 
-- 
2.43.0

