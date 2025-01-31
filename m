Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4691C5F25
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280721; cv=none; b=reOmDpiIxKc6gdm6EiifKw3kza1C978MGcjiGsuQ0Sb/qn7P3PvXgVhd5zOKpr45Q/nzxYznhsHXb4C4v4vDhSRjIxfKtI5+AQjRfDW+v613lvhJG7y4AG4VvB9Co9dTJQBhy3RH0j9/37iMUqbstBOorov5n2fKWVukNX3wK3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280721; c=relaxed/simple;
	bh=fRFm4c9l/ddLErZws3bd3FGJtqx8cps+DsE/QwWQ9To=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKR8b+F7VEsmrWTto194NCgoNqQ+Mk4EN6RflCfpgEQTnE3dWLY4cRuOgNQRTHtfgP/UAY93o+4t9YShw0sZ9KY9hreUYAiIV2hC/3Z1/xO4nEmTj1ofsGm2rLlECg407gidTyLJpOq5uEA1z3Twz7tFMcaCXBW+CZH8VxdxNlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGH6g0sc; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGH6g0sc"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-71e17ab806bso793675a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280719; x=1738885519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+XhexWIesFdWmoPFaZnMY3VTKVVmC2Nyj5gR8bs03g=;
        b=bGH6g0scbu3QxPl+BeMFVINygUqPDyixGd/F+rgYvlawPWhwX+nuwiI8fETcN0oeAK
         eNvUo/2RCQcO62xUyHMiXMBqMl7PmUm8V73w9wgPAYWcmq2ofFQWNctk0CSv5IYt/HpO
         i7asyDBVr9bws/E1TgPjF9rmC+uxPnpD4tq752UnN6lM10FmgF3AgHRWKbH7wZOsuYeZ
         voU5f7tqZCCiStOB/k4ixrOa1FYPlUMdy/JFbMsUhlUs4BoI+NrqkPXnZuT4/7Rg3BMD
         2w96Fkvz5zWVUW1mXwoOpgCKFzkYM6vTkODIuuBzdMGx404ncKWhCZLlFcE0nSqhhZ1U
         +jcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280719; x=1738885519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+XhexWIesFdWmoPFaZnMY3VTKVVmC2Nyj5gR8bs03g=;
        b=GXIrjo7Du11vORarq0IuMAxLq3aO+lzRQyx6IM5KHCjk1jvN5LPgTXywqNBRxWRe+I
         jJ7H+jSJFdebUkj9lUkxCc5QEXf7E+lw0T7cXMcRqHxbSmSez8StehvdNtjeruG/mCPk
         sVO1cPmc0klmots54YKflAt0pn+IGuRyo03YPqPXmlbVeDCToPAjcSQmK41sgpM7hWVq
         H0l6ZMN+I4jerZ104BUGffDBoJ1f48OTumLAURL06bQaLvZKcLAnTcID7lDfmTYEosNg
         OlaZAV+yb9uVTCpTXGDCiIEk8a7RxawJPH9pdJMqAyCcqOF1oMB2iI/Bf9Ho7dx8UrWX
         XSEA==
X-Gm-Message-State: AOJu0YyHYzGNBdA/y4vVh5zM58NvfLT6ijUf4cyPBKmFmeAYI40gQwBL
	Jyvrzd+z8id7CjmgxoLGbenOFcXIxpb3VLWm5yG6GUhESlLrbVO80D/cAQ==
X-Gm-Gg: ASbGncuoi79rSf5WY2053QheI5wQYZe79WaZvd3kH0Xx8p1awkHdsi4earL38ob2hhR
	jQWC4Dnj7VVtSm+5N5i4LLhpTbr25/mV/lCBDYGyvKAQtBqn2/zhZwy76T0hiPXlOWJs4gaq+Uj
	K7gy5UwrX23Emu/PnTUkYJEVihCIeUREOn0Zk5NsIJeS7qjBamBAvZh6WMruMXdmk8hgKhb7ZmU
	Eok3YpCtrnDHqV5DzOabA6+rGvE0Gu9n2uBJfA11Y2TO05BS2pLm1xuyoZwiCIofdzegWLzdlB/
	uHiW4bhAOosqAL88yaYYpTezpBaEWfW9V2M/Qv+JGsi+NT+6VtWHJZffAD+Jkzk6qRlF09oJlUK
	O
X-Google-Smtp-Source: AGHT+IEhA5qH61b+P1rdhM4nxeiZSP/1h+7r5V5vA79IWG8kblm5dISscDuQChvm+QKn4/wUyypdcg==
X-Received: by 2002:a05:6830:4702:b0:71d:ffa1:6b0a with SMTP id 46e09a7af769-726568edfb4mr5894021a34.23.1738280718843;
        Thu, 30 Jan 2025 15:45:18 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:18 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 6/6] lpfc: Copyright updates for 14.4.0.8 patches
Date: Thu, 30 Jan 2025 16:05:24 -0800
Message-Id: <20250131000524.163662-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2025 for files modified in the 14.4.0.8 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 2 +-
 drivers/scsi/lpfc/lpfc_version.h | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 318dc83e9a2a..9ab2e98cf693 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 07cd611f34bd..a2fd74cf8603 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 07b614bc9a6b..8bcc47ac7026 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 8925b51910b6..638b50f35287 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -32,6 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright (C) 2017-2024 Broadcom. All Rights " \
+#define LPFC_COPYRIGHT "Copyright (C) 2017-2025 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
-- 
2.38.0

