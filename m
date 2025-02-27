Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC227781F;
	Thu, 27 Feb 2025 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696684; cv=none; b=RBufhoA+p80t+7k+1MhSv7SHI2SEyR2h/1jkztsp905v7l3moSATros2WSNdvPnXKDPSmK3z4obRmi5iol88jgYh31pLKob2ZY4M3zzIJ3uJQ0OBi/GnVHzcQuIbRGmXeq+T+Qp92ueow6YWilpQyp6GAo53khNBBHsagLxgKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696684; c=relaxed/simple;
	bh=ZNi7C6bEWTzQUwdQGL5EqHY5BUfHTwi74qKGhnSGiYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LaOIJYgJjiBoS7YsRflNH0aLwphUci0KEvD9hV0nt124z00O6fXRzoTMUBiJCFTf5aDPBqN4//MPFd2PGZLRZ6Z8mpiyKXxe9jblsunxa/DpVLBG36WcdC4sfUIqXDC1JrSttO8u7+a+jZlJemrZfvRAjUA5SoGm9jGW7A4+tYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsdqezS6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsdqezS6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so10069475e9.3;
        Thu, 27 Feb 2025 14:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740696681; x=1741301481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WMU+NZb2AVhk09uVzN7k+ZVKtf4IpbZeTSZv3DDk2aY=;
        b=SsdqezS6Is+jwtBJtMIxYH/o1eRMpljnkeR1K0JE/pDVo3llt7wy1Ugv1OwTwMVvQh
         GepGuEhODCVaPD6NuGpgDZx7YXsWtAfTBALDUwCXvMozLVBIocjp51SbbpQoeowvorQI
         jBVsAgkpYZnGGofclNd181aSx2FMO9ASyFPJqr4wTFzLIOoDvKv5ynaWha6u/zpPxo4z
         SCRWn9WAnDje3wUOf2qddCf86qeBMhZGwWCBw0ySFEEgl7VIxoO5xNTXt8KYOojz68Ar
         Wbwd2yGE7rxiX1FAUTcYz/P2wMhQJdzy/liS31E83g1HIpkhJf8w027r5xFLbO7R3GEn
         gInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740696681; x=1741301481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMU+NZb2AVhk09uVzN7k+ZVKtf4IpbZeTSZv3DDk2aY=;
        b=MpvrzStpXQvFaINI/6EQJYTDI0eNc8vSqTTTjJ5Qet/v6QWLkPISSA60DwHgHk9O0z
         ioDuBS4aGYumNWrPOA6RtuCFYjshcTnL1P00Tr0qu5lXAdXI5ECvFRlKrur/tUMMNIjf
         ION+exDvDqRESIiZFFF59CaguX43jK4i2kB9ofdCTm7wXWZkzkjRTFtH/wKnpNHKSN5A
         X1BF0lc+i/I2ya0II5EeH8gef33MpO2NRQTl2unILjha/VcPtY54/5LmgArJpso0lrxA
         cuj1bZqwpMb/q0vO3CamnQzgtwgZNO1bFvjSG6BK1dzjwCOhVD/VRDA2CncaHz0fZk2r
         zedA==
X-Forwarded-Encrypted: i=1; AJvYcCVRhmZR/wisiGV+cx0a8twkT6lx+B1YPwIrmE0lNQv3MDaTfh41g6MuyZlF4rcDCw+IzSgHcbpe7a1U2w==@vger.kernel.org, AJvYcCW/64BrlhyJJTI5a5FEJp8GE6Wq5o2X+InkwGvW34VyXFxVxe2hUF92HqrCfkj2YKPxSA1xt6wdKlq7eIA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4egEdupzxAPcRwsHiNemglpKac3CWC4cj8TVep4hr424uqSUk
	jHDhZTA2CVWBaHVyCmb65k+ptPMkvpg5VWl8waRo1mu9pWQ/ldMEutoJ5sDppfw=
X-Gm-Gg: ASbGncv8gbp9xBZRWKHh4DRHtxJyOcG/bVE7aVMlZnfC+42ZakjD/soq536AVeSjp8U
	+qDk+DiCy8J2hEpZ2Uh5eRg1/UslimQSz+Ixrvbuui6wBXeKwCYN5CEaVd046HIiIOMmjEJbcG9
	3BSZNp5vx0w4wbSDADIVDkWXHwtzcD7HmlqLM2oYcziUfrbnB61g7RQFhLtkJrYEy2Epejx9yFK
	Zd+x8l/xIeya3zY2yTEupOTPaXwNciRt0Y0sQaWnAMMR76/98NNHZWAzZg+k3NHx2gZwqv2ZE5A
	ABol+sAPgCxD04dSH0e0MzQ7vog=
X-Google-Smtp-Source: AGHT+IHPqkfBSHNgZwgyytyFDMty3HvWbsqx8cQXA84xBSInA6L2qPeZF8jWee0m6ovCoUw5FTOGkg==
X-Received: by 2002:a05:600c:502b:b0:439:9828:c447 with SMTP id 5b1f17b1804b1-43ba7d6635cmr1864125e9.17.1740696681215;
        Thu, 27 Feb 2025 14:51:21 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43aba58760bsm66555595e9.38.2025.02.27.14.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 14:51:20 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: lpfc: Fix spelling mistake "Toplogy" -> "Topology"
Date: Thu, 27 Feb 2025 22:50:46 +0000
Message-ID: <20250227225046.660865-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a lpfc_printf_log message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 18c0365ca305..8ca590e8469b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3524,7 +3524,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	if (phba->fc_topology &&
 	    phba->fc_topology != bf_get(lpfc_mbx_read_top_topology, la)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"3314 Toplogy changed was 0x%x is 0x%x\n",
+				"3314 Topology changed was 0x%x is 0x%x\n",
 				phba->fc_topology,
 				bf_get(lpfc_mbx_read_top_topology, la));
 		phba->fc_topology_changed = 1;
-- 
2.47.2

