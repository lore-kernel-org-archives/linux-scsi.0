Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC4F21ADC7
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609089; cv=none; b=fqgVMK5GxM0+DmYJomB7/T3Q5C5Au3u75nNVVDwIT4i/FvVEyDBzVoAQdwNDCF0lScwNXoHVYxmQhlD88BWn1fm3vDUSc0LVlGJK9hksutsAPeGKObPs3+WldkHi4s2vbuyKSQgmqyUbZh+WVKTf1VTEnwDyArN0diS3caIeMm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609089; c=relaxed/simple;
	bh=PhYPUrUG+PXiqwskbYWP7FYFddh1QI1H+qfQm6csVDc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWi4ek/aZunE8BA8s00K6J8lo+sdXNzhHCWBbq5ucohxrud4ZNDYFl5jhqIdtCXc18y83p01Y63UdH6UOmSOIyMmhB+AFa3XuqQO1M68qBFhrVmCzwJ3gsvZ1u0gUyuEKLI/1bcrlK0r3Sg9Mv4aD14XjodjpKZSWIcZqIJ8WMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MAn01Klo; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MAn01Klo"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736b98acaadso2699321b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609087; x=1746213887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=so/wiwgjHW7oHEn1jinyOqqjwD66ZNbOq7w2WCg5xHQ=;
        b=MAn01KlolrHSQSO3cYehH4o1c2Hxe2olAxxpKUbdOvmrUWZWrFjnLKa4+nCllBA8xL
         H8bJ58/pZAZJA2OPmyysktMi+HCg+tS3WMR981nqyOETxl5T+aD+i+Z4yinYyqeLv4gv
         UeairE9ojBsXI9FPIehxAMji4UA+G+3VVOFM3apWC84rBBd9PFP20KFyyomtC++E+DGe
         Mrt06ocbFXQnTZ4744CENjQby8ix0q0Lg9aUreeUdcQQoBV9sqKwPtYdj2BWkwL3xpon
         gSH3KtClMDf/mzYt+2lBVDMRnnYz7+JplH9vsHWAUssK04ZEtg+K/VxK2kdHJYIvA7rS
         ROGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609087; x=1746213887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=so/wiwgjHW7oHEn1jinyOqqjwD66ZNbOq7w2WCg5xHQ=;
        b=ZLscVpBUj749oUNI+HLJtPqU0AAbeni2L5T8xcUrDMflgFXjT3QoZCbA7Ywc12oKw2
         unTIkqy2Y+vUVdMJb2WbIGD55EWwFkHXGteljP0eqFos09fsVOWnTIAD1BxWeexn6wjj
         BjJwKEJTaVjfZLlzbva0iEavt3fi9cjygj34wJVj5bZeIl2EdAno7aqU5cWUfcPe0CGK
         MkHGO/W2ojznKLTayEgF26m1CE+XPiEUVhWc5NUMivrJqjldfCbNRGqtqBaQ4IzABwAs
         a1b2dJZxBFFNfVSSpEaPzdXuSTN7LsV8a9CMQgBWzH+EFjrA4zf88CZ4LjCg4vSYTlmM
         M+Zw==
X-Gm-Message-State: AOJu0Yw2agrId6tcnKCeXIIVoY5yuvf8wAWf2snHgUegLQ/Fg1joB7dG
	K+78YtaAoxWGyP2/0wRWU22qJVWvIYmpAQyIQz99EFu286+lFLJxzAk0uw==
X-Gm-Gg: ASbGncvtLBqYYIxU/EuJo715b31GCDDn4WLOniPOJZRsAxFuIzdB0RpqmlISxytn8Tw
	ALT/ID/vmo46cMOpcck/YQbzxlCRShb7dDjgj5fLb3PlAjaLCISqIfKKzqtFaIvdd6t3k+RYDLN
	QVHbBXI0Tspb5vWSjpyM4Xf+PDdOmEvV3/AZbr6bS9uIQ+Ju/qVhdwaaX0+hIAxQiCBIcK8igiI
	l44GOZHNPptMSHyeI9yOY7KuUT6qNywL3T9SxWvvdxeLBv7GjMd0ttlTGKdOz7NGQPM1Yd2qQZJ
	koUtvqrxJBkn7uUjfcUKyiyY5A3Lc51hZp0jLatrgz68iP8FL5Vag+s0FMtTiA1dPgXbllpXn2E
	6XkyQ6hsj70YVngI0DPCETCgabA==
X-Google-Smtp-Source: AGHT+IHgTo2XwRo+e/d4FkjfZAt20UksnEmiWgQx4Q0Iqd1yCH6l2R3LOl2xZuzhkeFXQjXpJJl0Bw==
X-Received: by 2002:a05:6a00:b4c:b0:736:34ff:be7 with SMTP id d2e1a72fcca58-73fd8b6bd7dmr4190716b3a.15.1745609086862;
        Fri, 25 Apr 2025 12:24:46 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:46 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/8] lpfc: Copyright updates for 14.4.0.9 patches
Date: Fri, 25 Apr 2025 12:48:06 -0700
Message-Id: <20250425194806.3585-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2025 for files modified in the 14.4.0.9 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index efd02c464549..54ee8ecec3b3 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9d61e1251a2f..a6647dd360d1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b582728d9e48..2ebb073e4ef3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
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

