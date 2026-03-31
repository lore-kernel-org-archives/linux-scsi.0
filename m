Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4F2D46CE
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988587; cv=none; b=AfBdt9h75lDpd8AC6t3/bn/mu3JCKmRo+IYopDNN3xX+JJ5UUC6IKubhPLTlQd9qZCRSqRQdQk0i2+Ixypf3sIBNlAsxRAfVLJ6R5fgC9nnlgkuZ1INoY4DWMB9POHA9GIEkylM7//gTxxL+ijYG03HSLmJaCu5Z3prLiHnck0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988587; c=relaxed/simple;
	bh=DdxjRWAE0Vv+TJPrdcCehA5053Kn5UikCWNLMPRmKBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g60B1QYJlhTNgdjDHFa0yxsV95vBq2RHqdEsguh47D9Dw10yKukKNnD/h8jonGFLpJVksrAGnWf+T4rQprR2PHVpsYeVmYjoVxIq2rg+EcMCUvJIcC7qmSdT4a8E+qJW+BpDGCRQOcq0D6Ku8kRrbPPyuEN7Y2kwSNGyn4k+BkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZK86yHku; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZK86yHku"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8a032383008so46391256d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988583; x=1775593383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NfNIxp1JYKPECSleqgK9ZcrEdKsicKkLu4ACKeEPGj4=;
        b=ZK86yHkuUei42m8kIqP5UTqt2Oj/9qWr/GMWdjHur2sc+pApMMKHslawxe1zFJbl23
         1EOnqUhSzDGuewHJBDhIkJ10U8Qe7Dfva3zmOUpDgNT/Ea5TRPJ+e2HxuBNZ4tfixlAr
         YO/l1OWM6aQqmLZAhxTYyo/7qjZLjxSWedOfdRoWO9336QKDXAygGKkF7Fg61DvnzUm9
         CsdqfWggF1EPx+kTSS2Z8p3UF98BuQZ5iq2oY/FB/A2f1sX9VTAVng5p/rQSUJgfVv+L
         97Yr8PbF4ggMMqbzBAeAC1l8Gzwy7t0BVW0OlIS3xDz+nJ4X0rww/I1uxfzn/JXiP/oz
         aiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988583; x=1775593383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NfNIxp1JYKPECSleqgK9ZcrEdKsicKkLu4ACKeEPGj4=;
        b=E/o5K7DV1DacJiT2mqptN5lWnyAOdZNVz4bQ+MJ1rklPif5wr4WEWPQKudcUnzpi0I
         XVjYRT8rGW12bubKYaNtOXV+VE9ECd3eI6YYxLaUGo5ai2TswBbhH+vjakHjoMOIEi9W
         93IjlrICOyFlgPSWAvLukdhke0skE1sDsEilKon7fmn/WuBgKOOoxMsNR+DyZUHJ1KsH
         2erCLmcpK4lJbUp0ojeW15r4eo8ntbXVUSJ+B4+XmekptybwlSCovkYaOQssEdzeNNg+
         gtKyKmB4bxt2UQhE/BLj7Ocb1HTdM9nTbeeaQ5YVKeQzltkJW9QVJMkNiHzvel/mhymN
         6Iig==
X-Gm-Message-State: AOJu0YyXNyK4hDZdD1QxyNe8zBk75hjGxrGN4vx7820Xu3fa3mlAtcbW
	arZU5uy/JINYeJMCN0A/VwAIfjAzK64hWFa08HxCjtM6D7Ybudfn/UyNc2f2kw==
X-Gm-Gg: ATEYQzx2D/WDeL4UVH14BJ1edimqbCO9B4HyYbkAuInFSUL41Oiia77uQmI70+nckUY
	ugKHFF/0e8eifJXRwvxk0Lp1FIwoNDki03Rh2nZCJuBjMNYzjcKGRD9KLcblNjn2rofQ8bH4xH4
	HZ0iHs+bFyMhCwXYB+78OQFF9cgaoOK4d5VE5NWR0fbk7q5UodN/UrcFUoMAsS1u2VdfhZ72bfK
	0y2sUs5Xyz02Fz1baJ8upbf2nMBw7WRNn9H7BIIIgLH6lUgiuLTkuCrU8YVZYhCe/ahK0hReUIc
	X983nFTaPGYUFOqbgkZ5/rE2oeRSmeaonKW+WRHH/E4lyxrim+bwWJMEdhlZlJvdrhm7JI2KZbQ
	bUjERZJm1ExrErtBRMCuBprQfvbMDdRkhEjnm/tq4mdmZ64OqfilKnTy/DPyEErq8txLpsLs3Fh
	S/JW8pv0ifr2M5p2o6U4PkRxbn1exAZ3J5QU4yRLcq0O21pOQFEA4SZwiWdAwky4xu/u97XJmfv
	GONylOfT4mEOL/4BeZ6W/J2dPTl3nNnzZYb4RXEhwA=
X-Received: by 2002:a05:6214:8089:b0:89c:9c8d:e985 with SMTP id 6a1803df08f44-8a4390c56eemr13349696d6.27.1774988583346;
        Tue, 31 Mar 2026 13:23:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:03 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/10] lpfc: Break out of IRQ affinity assignment when mask reaches nr_cpu_ids
Date: Tue, 31 Mar 2026 13:59:19 -0700
Message-Id: <20260331205928.119833-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

The purpose of the lpfc_next_online_cpu() call is to save the cpu index for
the next iteration of the for (index = 0; index < vectors; index++) loop.
Because we’ve reached the last iteration of the loop, cpumask_next(cpu,
aff_mask) returns nr_cpu_ids.  Thus, if we already know we've reached the
last iteration of the IRQ affinity assignment loop, then we can just break
and exit.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3bf522c7f099..cc2ecfe1c907 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2,7 +2,7 @@
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
  * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
- * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.broadcom.com                                                *
@@ -13039,6 +13039,10 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			/* Iterate to next offline or online cpu in aff_mask */
 			cpu = cpumask_next(cpu, aff_mask);
 
+			/* Reached the end of the aff_mask */
+			if (cpu >= nr_cpu_ids)
+				break;
+
 			/* Find next online cpu in aff_mask to set affinity */
 			cpu_select = lpfc_next_online_cpu(aff_mask, cpu);
 		} else if (vectors == 1) {
-- 
2.38.0

