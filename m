Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BB929D277
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957979; cv=none; b=U+YztqiYQd6QOfFSZPYd7MhaBsabIxQgrJ09KeU4VCw5j8HflbHpCHNs5S14g29pP9N1HZAkhFy3IrDvAc9lf1WKGY6i0pE1OhjaOW3nTybpXsjwaus7W+GzQbmFLu7zcep4iF8arndWhotkPAQgGNF4F/G5VErupaUZL6M0IxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957979; c=relaxed/simple;
	bh=onVmHaqQAOlDfhFhzxzQy9h2VU/+EL6U9EmFxzlhrkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJ5n5OofcBHuoFYvuCRi+0HQXsJY9Nr+R/db6lwWQSAFURBnh4B16Z1hy1E9Fzm146QQauB63fdsUZeSrnS2Rpj3D6Hed85+pnWRdnl4AWtSUVWmMX7WUJBkDljq9iCrrVIaONDI8EWjvpaFKI03MUI5IFVtlnaNWCoie92dmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUoF+caM; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUoF+caM"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-77bec8ab89fso19072716d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957977; x=1758562777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BuSAjkHIqbsTTaHc7oqdPHpwfSyV8Mv1gu03O6MC4yo=;
        b=nUoF+caMxMF/ArqHSdHcvEQjjA4kFfsTxmDQSx/ao8AH0lNDL8rIkSoD1iv8qpwZWs
         BcA5th98nPbq/7Y7eTYdfzZXmZ3de0oPEeS3m1IdSe41Y5pprHiQDmihIulZeQvYW9DY
         eAOcAFSmAWkVj/E/lF9f1HEr8jpuQeOCq4gnvQOQnuBrjGOv3xZhIuSyXZA7KDO1qUyb
         gC/AXQXJ6PdhRVDRajE6EOC0BboNUJUxwTeNRSWDqPauu8o3susmjT5ngdoYZGgY+/w1
         2AX0rUnaVpK8rsIYEBG46gvhZFJokrKGK7jJi75CPgOhSg0kRoT+em2XBXnfZWQHOOrM
         yVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957977; x=1758562777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuSAjkHIqbsTTaHc7oqdPHpwfSyV8Mv1gu03O6MC4yo=;
        b=RrbiBS9io5tIlULtxR/bBkbRzqQAfRrlytXCBzbQtDusr1fPROoPpy9O8LLXyAZr8v
         40hmcEDM90WNpYs8cPR9MkcLlrRAXf8GN1JZOnr1BvEJWxyY4sidFx2lVnffaCszbVm0
         WdrUw1eEP1GneDQtT4wsT0GG4ROJkXnc0bh/Pdg9vEOXJeFB9SK1Ha+s0aPG8HmEY0Mw
         BFKvyNINpFQ8hpN+VEVYRuzeuXDjxGfP/8H7ERpVX/A15sXyQ3y/KvKM0AX5TlcDCIpj
         96sE9xa+HT9dUmTFT3yyTXCM/O/ZNA19jV9btQjX/nI15F8Cip2LdSAF1nfMcySTTmjV
         nSdA==
X-Gm-Message-State: AOJu0YxmxlNcXS68ZoIqls0BrJYATLdvGLpwVfw8hyUuCv9zr7u7ChZl
	svw94c+Nb2sYufyrwE2072E95hjR23gdimn1zPjKPMg9wzvRmHKPegBruuiZMg==
X-Gm-Gg: ASbGncvCwhXzwwXBkcq1SgrilvKm9d6UkBpPuLUG2gu48NXWszWyavyLswQRxJSbKlY
	Cpgp2vDL7uftS5km/7XweiqD02lZRpopGWJnAO2szyf6eq/r8uGnP4n2cS7bf8/M4HAs6ShbaOz
	VQ2chBeKndJCcGrxaIzlblcQa0CQReMUf0Xc4FxHdK9gSXmbmxbOMfGVeheBP0l3W9dD94zxtFt
	67jCFsyvWVqkWe+C0F7gs11VmrfhGhEqEgr9UA1igCq9PexYTrhTGUkvVBgFKJOLIw+z/Tpwqoo
	4wQJC8tRqyy/PANlftwAluk7uZ3VtY0f6SpplS6YTePoIhVUdx6fTdlaVePNfxabr4xiV00h3WN
	ZxFvnlpwLmc5b2CSkPphQHDH9gxuVkTP/G/xv6si9Ym/IFsQsGvg3qxscR9FlpdY54pOd1p8h3O
	39jnoGuZI=
X-Google-Smtp-Source: AGHT+IFisvjFf5FDkXef4MQmzpz1VNVpV4jiKP/BI/cBdA7FKhXpm08BHBKh0+CNoJ8oi1AStsqV+g==
X-Received: by 2002:a05:6214:301e:b0:77f:17e1:6842 with SMTP id 6a1803df08f44-77f17e169ebmr77093216d6.47.1757957976454;
        Mon, 15 Sep 2025 10:39:36 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:36 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 14/14] lpfc: Copyright updates for 14.4.0.11 patches
Date: Mon, 15 Sep 2025 11:08:11 -0700
Message-Id: <20250915180811.137530-15-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2025 for files modified in the 14.4.0.11 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h           | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h   | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h        | 2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8d9870764a8e..224edacf2d8e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 566dd84e0677..a1464f8ac331 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index b287d39ad033..3bc0efa7453e 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3799bdf2f1b8..1e5ef93e67e3 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

