Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8F194C61
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427896; cv=none; b=qxKHYQTVnhqm41TdWyum2al1pTK+PvLwBB2w21FburoqfNDM4YOzIajk1lEPWap+8AFTb168VwcpXSM7jqOaPQbIwb+NcwMBwSu3J7smrWE4ArpusNVjL7gZNGQ7O7vMkmgRDNtBSb7b1s/Y8LPLYVfzHTYJEjX7jsn66Dh4+2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427896; c=relaxed/simple;
	bh=kYuZ84sB/zvQ3WNTBTORXqAEhEnBIvN7YFsmJKdn7HI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=syLJZfcUIIq0FzoWyrLqwqXbFsrlF+P1b/GE/wsEo0+FSNSh33MLzsjIdYVFUUgJ3aldOew2uFUGEcUgJ8bzbSLmetXKja+pQdvNMyQu41Moe8CejlCHLRuIKhgDPLK4nRXjxjDlo7+azFTw+bAKeUpV/ubUnIPISbyfkVGcw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGKs6dGm; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGKs6dGm"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6a0d274e631so1816156d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427894; x=1715032694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIz2qd01tp2lKPTlWWpkvg7WDjb+PyMN/jUVWOnBY2s=;
        b=VGKs6dGm8hQbBcFIaoM+lN6uWV9K1uCB9LoBmG4Sr5VBmuj90aP5oTSuT9d16JaKYo
         tkUpaVrnI6B8Y/f6gd+iu0JI+bAyIyDZgrPVjxqxT5vcVaTUKNa8sWdM0XcrqK2q4C1n
         ygvwgTFdoMAF18ZWCGztNNHTcjOZy7dWsAEXSOm+OLw7DBv5gO8WKUdaxuxyEb/pRuYo
         OqqHeK88Uuv+m/enCFfcQ6CFEk8nU2mLheQzzeY0wIHdhP1RQjSONKFdXlFwuV3oWx69
         BEpcwShQqEvv8MtqErolW8Y4EC9lXZnGIG2ajn7IhoeP6gu+LOoCLMX5z9InRYYtDNF9
         vCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427894; x=1715032694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vIz2qd01tp2lKPTlWWpkvg7WDjb+PyMN/jUVWOnBY2s=;
        b=u0HyhBUnx+qvxDCwhkO0e7luO0hOGHGWxx+FsFz3GzkWPg/l8ToTWu6VGkFSMAslvn
         fRL1R+2HM646itkwssam5a0FApePzztTgW/U44cTCcAZxX3BLIpdKKbeJgUklN0VD+1L
         wNt9iAoela8KYDDWUCck3FncT17VoGzqPcpD2AmT8sx5TkNx+cvLyGiiIsXkieN0ZHZ4
         3pWmKSkHMtfXE4BwkAzvnfuwS95kiXanZKQ9SlFppmBVvAQVU8Bx6VPsKMv3lGtD/ADj
         pSanN6plRegXy5ZKlmprqHmR8nB9KTEBw/YBfbYmOoAQn1ZvrHffth8ANgT8j0dY6tMx
         BaMA==
X-Gm-Message-State: AOJu0Yy1ysE9GavQ6BU1jeG1yogZzxU1z4/aMoc2H0GQA6xiVDOveWkh
	RyqwAXNKX9mejnasHI9SjYj67TwnaLGRuVkpsdNAhqLwNu3NCsZcul6+QQ==
X-Google-Smtp-Source: AGHT+IGclOYEm2+pVXm8VMVrktB4IwrkplJtbxNkTb21AI/Pq1m0sBgEMkuPILeOkWtuy6nCodlBmQ==
X-Received: by 2002:a05:6214:2aab:b0:699:2d88:744f with SMTP id js11-20020a0562142aab00b006992d88744fmr12959368qvb.4.1714427894350;
        Mon, 29 Apr 2024 14:58:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:14 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/8] lpfc: Copyright updates for 14.4.0.2 patches
Date: Mon, 29 Apr 2024 15:15:47 -0700
Message-Id: <20240429221547.6842-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2024 for files modified in the 14.4.0.2 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index e034a48124f5..a05d203e4777 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

