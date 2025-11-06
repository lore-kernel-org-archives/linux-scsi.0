Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F98C1F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467356; cv=none; b=TKMKaTQK85rQ4kcCkV4qqb2z6QLOkyI9OzFdG7IpRiX+toytv58NBsqooyJyklzCMEsmYXD0TJOEZslGWGT/LDoR94xTaRv5DGM5w4eKTXWDn+u7k01REXzyIWASW2+gdlzkubZy87me8aqpk5fTJ4SKXHnF9sivfucvt0T84qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467356; c=relaxed/simple;
	bh=3pv9x7sBa5i8ITONEgE/Pz2k+3abqh4u5Xmh0MIl3QY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PIIvxe/FdCCzDTqlxhzMROU7US62Zv56kZWeg+10Q5ap7xYe2cHCl9mS+YlmedYiZFn4tdbDyEN1sXlQoLtbKNliAAm7gCex01a0m1ew78i2CdKbZsBj1fP/4VI0gYiyGS0LQMSyMFPL22bVm+opanw284ArTalWbDOYGCq0pbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDcIYi97; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDcIYi97"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340c39ee02dso107554a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467354; x=1763072154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HcXz5aWtLNoptaC9KZwhWvQ/ESOvUBojr1ci7B5FbY=;
        b=YDcIYi97qgCWyzwfJVJk+v8POwFUQmwQdeDhuTuATT8CXHIj3aNFtfmIcsNHGig0gU
         ZXCyCN+LHiGiorL4xFiJo2ne3C15fRWSzh8L85EahhelmAQUGbRiy1TaxJr1gwyzUv88
         EcLJ8oxj72EHG6oxIqxwp9zHYWGFcYCbZQiGqrtOBgXWdWNp/t9boFZjpQETnpsGEtHe
         QOnaUhcMrGVsVKD4y0EQYlUWLPN6G+4O2Mhm4xGuBTm6AO9dxNlVrdUYkcGGL2gaej6F
         uA2Lx2yZmd0ooapGqNArHQ/P8TabP14QgfdbQVWH7Zz8ldi32jv7BMw8l7r34boTMpgv
         P40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467354; x=1763072154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+HcXz5aWtLNoptaC9KZwhWvQ/ESOvUBojr1ci7B5FbY=;
        b=hTPgn9ydT7sYmcOPNJk3ss7eLM2UNz7G8AJUuUMb48AB1P39KXJ6w1g+hxI1pU14hw
         2d9P0JSFG3yimIRBXqvJQVvSae/MNlTOiiarzDLtgNlBCAT9EgH3bA0O1EiLVva5njqi
         39PpB4plGP7piYLxFJ6XxDr1CTD9nlZe+sE0SHH5Lawa+zOUCd1PIpHbkihqejSmhpM2
         IdXFWHWJJ8hxQuzXsefy7xqc58Krftox5mAAFZ8xRxq3+MU9P6lM9g2u1jA36kMJbeQg
         lyzX0KcsMOWoZaunHZMRI0Phs4NgESad3WvMvs2kHZ4dsaV3KV09XquqhXgwDEUormRt
         Xo/g==
X-Gm-Message-State: AOJu0YwtsU+EtvZR+LlsEe8jZ1dnMjmS/WI9ccGfoS5CCmtv/mQI2KtR
	lvfEdtSjQKoibKH2F7az9zryyK7IsZXWOGssTQbecGXtnFuTKv6EQJWQBjIOMmz5
X-Gm-Gg: ASbGncv3jz0s6bZrgSJy9q0yinXHxInj2wAqGTemEJV5o0Q6ONpeNRhFOqThtRJxKNJ
	6qvEHKnj8hIRg4dQIB/k14KHJIS/ewDYZnItYPUih0v58q36a9oJJqFQkW51YSnBqvwrHo6tHIz
	IfPDvWejUG5b1HqJpN4doyVr5yfoiWWN/0kXysBhrhuo70I/4WfCQoYslnnL7Yz6d15sU2yvweN
	+dth/zvH+3uaIZnVEG8kDDIYL57mgVE6QfFPtqaB6sHzU7orWsRHCX0Wqy6CpnCTpVUI112tvHz
	Gk9DJBgFmfNoZfPxt505Tp/fx8CS/CFlp8X4+2jjpu5x5JFZGdZHYzbvinCIf98x5i47iYxN4fZ
	nXkyLu1LAKGG32N1iWIJik12fgMpqbgshiwv+XNCxZYDvH51dFcN5Ve9u/DmlC09ctUAhOwNfmr
	PQtX02vO10BKcfzUUgHQ5aGiMMFMuxnMYJnOh+LvC/PeavRSml9457kz0ynnHd
X-Google-Smtp-Source: AGHT+IEsZ5YxGVG2V9d5ShGvLO5TUvC/+HDXD0uEqbvI+p8Gwuis5BBZsISqAXYa7WQcIU5VAp/kBg==
X-Received: by 2002:a17:90b:2e41:b0:340:73a2:c840 with SMTP id 98e67ed59e1d1-3434c576ab2mr826608a91.30.1762467353865;
        Thu, 06 Nov 2025 14:15:53 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:53 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 10/10] lpfc: Update lpfc version to 14.4.0.12
Date: Thu,  6 Nov 2025 14:46:39 -0800
Message-Id: <20251106224639.139176-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.12

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 31c3c5abdca6..f3dada5bf7c1 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.11"
+#define LPFC_DRIVER_VERSION "14.4.0.12"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

