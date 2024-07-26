Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720F314A4DB
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034812; cv=none; b=cJVyCkPnoz7OscWDr1FCETSNmM/PZ40tjfM86/LBjWtTuTIHXJKbcDd1Ee3HSpIA17tUZ79VSL21YWL6NoxZiogOD2R+CUWKnWho4K676aARqR/eAsnapsBfg1R16xr9roml/sUuqazMMAdo1NAP6rPLKmJhzorl6NM5SzUL3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034812; c=relaxed/simple;
	bh=0UaRDiv2hfbk2XcjYfDPp24lTkJ/tVj0wDLqKlLVGLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e32hXEm2T9SAt/mT8fXokL1v1JHWSA3DJA/DZEmcjhYWext+YwSeiZlxS4hbYiL3Cj/XO6Gm3EdUKgRDBJ0cIYhBOv8o3t1/EeLeXEMUADE3dGUguc3VkUsmcE6lWN5iaGP/cEHON7U7CM1KfUDiEbT6dVospEiMmjAhNvvOvQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=axc3wQIp; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="axc3wQIp"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cdae2bc04dso241223a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034810; x=1722639610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rdc70V33+T1cbKKu300daghyfQbyMg5bNzX/qsatImA=;
        b=axc3wQIp4bW9LNAGsU4wuVrunyQtMb2UtLyzPMvgBZ5Uej/w+Jzv96nSfhvtHsfbjr
         +ZPww253Jhp8d1kS+prdQDZ0akdBUP1KZ5l/hZ9oyuqA3KckkaKbiCN4lsd7MgzGgkG7
         ZOW3dQj58poUJBEO9tvGcrheJH70oU1vbL3KHWKl7n+c+RmkWp27eohfFNIriwd0zkbg
         E+Ih4rJXI5yFWsATPEvIZ4w8MpWKYqfJGenmmYvEJP8tZXPlhDdeZicdoloEhm0eS8Ic
         PxZR4vt25kbRGCpcry5Z43cLdAtFzwhrB2zGiBYrIHhB8QZU16EqhbgxtW8B0DaBsJsd
         RcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034810; x=1722639610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rdc70V33+T1cbKKu300daghyfQbyMg5bNzX/qsatImA=;
        b=f3/rDCK24BA5netshMtcEXSPBBhSL/LH6VZHianBo2zOShupYITBokgqID/z04PLIg
         OEPwra6WRtNvnub/FUu8KJTd5VojjsFUsW0I4ftrbPTyRfqi7b9dzAlTvOLm2mERXNN8
         B8QR9rN86MULufOEVEGaCLAlPU5IOoIfrEEcDSFiYaT4JAD2a6MPNP8uqaOxAWca6K8+
         PjMAoVUOQo7BG6ml5jVIn9IUvRdzE/G0Zuo/U00/KjT7iJYpcyW9i/4QZrQjhJs1R5Hx
         SIq7kZVtSCZsZhNr09desSfZw1O/wVFO0NEn1Lc05GTbFRDLqd7xi1Awj8865ASC2423
         Hdlg==
X-Gm-Message-State: AOJu0YzPkju0Iutla8/Ne4niqy6aw868jt2GHi4NXJaOwVrt4RJSWePc
	YpxtuxLi5dilgfLoGA9Uj/YcpKG7Guvyim+57iVTv7NWG4RRFm/5VaSeIw==
X-Google-Smtp-Source: AGHT+IFpEVJIXCsv4KEHBnrnquaNQ7AG1fzK9vbUKxnVBiVaClTa6A6Md8M3oX2EK/UDeVgzMQelvg==
X-Received: by 2002:a05:6a00:6f4f:b0:70a:f156:fda with SMTP id d2e1a72fcca58-70eac95e22cmr5107316b3a.1.1722034810443;
        Fri, 26 Jul 2024 16:00:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:10 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/8] lpfc: Copyright updates for 14.4.0.4 patches
Date: Fri, 26 Jul 2024 16:15:12 -0700
Message-Id: <20240726231512.92867-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2024 for files modified in the 14.4.0.4 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index cf8ba840d0ea..cc3e4736f2fe 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

