Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9842EC563
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929748; cv=none; b=WPllBcvRADjYZWItJnsJZrdd5qP12aCIigf+sLdk9G86pt7/HjHb3CsXhwN1nBmL/5gdqofzz1Oknj3T4gxAIgzmFaRSVaaawwwFRwIWNjj0olQkLCWSUAfTTQiPZv6bO40hTehZ1jeoKjuSAc2NeVRQYzvcoL6XcJPSLmU4lZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929748; c=relaxed/simple;
	bh=aJXqm5FpTB0Z8ZeIBWcp2qFDyUDzW2gOVnXDOfNuiG4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvfggEKhyq0u2I9+Iub5YrFf+dfnUMX8cil9RJg6XF+W7mj9ceMUlRFqWFDXmYA3WjLsqtAJTgDrCg9EpppxbXDPY0dVSsvQ/VR0so3zyWSuUZlTE1XNFIauRT0WbAEBxu5F3QVkp/81VGKnczec2I4ptiuk5hONr3yBsHWCOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZH2ukQQu; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZH2ukQQu"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-896fb37d1f0so5189156d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929746; x=1771534546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lE5CfXeJY/ZxaUH1dR2w5yPnMDtBiPloKs8GsTUGFAU=;
        b=ZH2ukQQuhAjsbkfFVpYkrfvk0QtLwLEEKyI2eDxJixkGTPMEvCmQcqO33dWbGsY4CF
         1TU0FVzeaOA1eFclpjUtEMYJdYELrn41qg9Tl5jwPLWdVH9MCJtVFYztD11MGUuu7Jv3
         BLL06AT4M7gH9SIlcGJxjnS9NPgeZp0Bm9MYm3VM3oUVUim3pWI8NS5Jf0fL7WQokBV8
         RjkXoKEOKMIfUzLuIetINZUXKMT7V/yha4xk5hid5UJjApsWKHyVGAOaJlgfPFq5qQPG
         bEoMrOIm+VcuYAVYF4BMAenrgFLe3QXxFUcvFnSHn6urpqYvqK9jndfhZcupH78t/J3W
         DNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929746; x=1771534546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lE5CfXeJY/ZxaUH1dR2w5yPnMDtBiPloKs8GsTUGFAU=;
        b=KI7b8x08TxwGLXLbHZ/LJ0sZT8cSe8AUq4U7PhUrlKV+IyBxBNTiJHUZaZXK0lRaKM
         be9A1LpOgbCMNBx3diTFOFmor7+AoOJ+HtcNupLGW89Bt+eOq5YX7lEFSEIK4TOuN074
         Wtb/nM9dqt5DVicEmEFQmznQaag/YUZjzTiGu3slnhCL2EElwUXsrEJ6Ua4+BM1Za89D
         SqVsnhG+WkmKZbLMQHI3Y5W7Qi165PR71n76Syz5PqGNkqywUmK6JJIrwjjpirm+WpQN
         Pf91yzdNVMHeksrf93a3B+vi54r4FPcYq9/3arwHTm/wutx866Jpk+c/7xj29HkNTBEK
         /Q+g==
X-Gm-Message-State: AOJu0Yw52WzC3WtvmDOj+qbbVfXD8natNKkAMsbqFlFwKle/pLPrhNCJ
	tHMs2JumP/7HZeAjf6FhFbtXf9O8yQlU0ATO1yKYQSHaB7J0oaVW8Bd0wS+lnFYx
X-Gm-Gg: AZuq6aLkPkK7rXNDkpkUQa2ftQ9dUyMeJXJmpW6YZF8cwSOnNU9eSfioUn0EdhcnUk6
	Nq6kq1I21EtvSXGsXlY9tdeXuII5tkahCfGU9upU8mPc+/aktUHaGWiUiy/mC/ldZlA4MtSqIBU
	fVJI081AugJx0CQKaUO/lUa+zcwSA1tzlaMslwypp2cljfgv+DAzQtDxWVdfRQCsUIvbuZ/g8qf
	zgMO0pXgxvLd6Fv4WvrY8w3I8qqdKzdriO9lV7o5idO+YFK+4MslxGvG6yQkLA8211mBpGl0Af7
	tJcJw53DU/bBOEyfnOMx8x25Dm1QmFLjaB7itGLn6GprRc4mU3RwEuNW2njKxjDPdras9LctaC0
	hQml5kYyRIpHyZsI2IYB2S2JL9A35pqcuVrLMEoCOX8xUYWDENY3eyYKusbyNtwuJ0FT2xK1ome
	E0zYTzqU8sT1c2LvHw3ue8ZC8YNVch3iXvQvSoz9m6tKzdIfgG8OhStIpNDESJBwyoV0dKLMJJr
	tvQ/SrCgGM=
X-Received: by 2002:a05:6214:62a:b0:896:fb75:d982 with SMTP id 6a1803df08f44-897347847f6mr6663436d6.22.1770929746210;
        Thu, 12 Feb 2026 12:55:46 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:45 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/13] lpfc: Update copyright year string for 2026
Date: Thu, 12 Feb 2026 13:30:07 -0800
Message-Id: <20260212213008.149873-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyright string to 2026 for this version patch set.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c4ca8bf5843a..a362a7356435 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -32,6 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright (C) 2017-2025 Broadcom. All Rights " \
+#define LPFC_COPYRIGHT "Copyright (C) 2017-2026 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
-- 
2.38.0

