Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF3B1DE8A8
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045298; cv=none; b=M7rcZVOVRTuoMB74VGIQBbSuz9Zauf3CMWQpf4mdI07y/ZToaBr7UVtVGN9CXVWo/chPpYW5VQb+J5bYzTdfn420cKBTFWOSmIcLusjwwbI81pzk9bb0JzxB3mzH1opj5GxYo/eS0jR84kcOV7jS0yERI7cbUG3ZhJ5RbucL1ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045298; c=relaxed/simple;
	bh=rOXjxmyt4/NLDJ6oztjIUZSiXHcJuFeL0+D8veg0rvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iwx8xRE6QqxrcAOf0pvC0AOqpQna+/Cqt5Ipgil+hMurl//Gaxvqx1Qt6hXFg6eQxhmDNh563HuxBv/W0qCYejqYHigaVCROLggJdSpcqB7kklN5f0oRVGH/xVWe6YbQDu3QuW0CwQWn5ViFmNgmFlrn2WJnvT14TrgMdKkTGO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+HOKwK/; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+HOKwK/"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21680814d42so10464885ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045297; x=1734650097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSgsWE9qSNc7zZsTbQmWn7ecVlZ+Cei3YklgM2z39Lo=;
        b=D+HOKwK/20VKwh7qgncyrhrS3N7xVde/0C7NY4SMQIac6c/C04I6PtUld+mH7F8lQI
         kCyTrRCOAt/66H89RUyj9tF903hZbtn/2jpRvG/K1tVxkVBpCtbEtKal8H3bfNppuRHt
         Ju0R2xIt3Hx6bGjFVsg5Z0UXiLUGPzBN3R9EyMhMXyOVBYh0x/tCvYwF6i1EQtGoHTNY
         lphF+FZFAScLZPRyeQkpx1+ygrtcs2R2Ou7cpxz42FClK8tMLFHBqbPjFMLpGKo5qq+w
         81pTAigZI+Ls2RS2UIcH7582ghovThnd7AAYQp2Jk3PnHP7zyOE9pPPDnCj/tzmHWU62
         OGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045297; x=1734650097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSgsWE9qSNc7zZsTbQmWn7ecVlZ+Cei3YklgM2z39Lo=;
        b=bp6NDTUrbUjQspVbFb0EUEHljeIg3MQh+FqwDRbcelk34C6K2R7pqvqQ5L9XP6RH8T
         KgKiaqHjJgRVrZZRRgTrXr+2j+3rGl9lSHU5iTD/bGfheYcZpYfz5fukpb21fjQJ3yBc
         Z98eune65ZWxUGF3BJGAiqbbs4loBI1pIIYX8bB5cxsgL1YBovpBjEEl9tX9nb1OpWdn
         aqnd60gEAkjnSMmmYhnyDKWO10AsEr+lh65H86bMJR5ndHuQysY5sIZmNemQnIBL4gAo
         mPSFjtfi2Ce78GEa0gbw0j3wvG4bo+QZy2+hqoCDSDrK3lo0ZeXUFV6liGd0G+Ex9tQr
         MYtw==
X-Gm-Message-State: AOJu0YwNyBxlW1jCrUv3+hSFzdKFJ7naXEj7j8uwn4DJ3IteIyCpPmNq
	AFnwHxPKA1Ldo1DIL++mV1BHjLeMNpBQjxdoz7SwlYx+U/vEA+lQhf+iUQ==
X-Gm-Gg: ASbGncvLX2+J+1ffSxodLj1JKwtP+sMhoCDy64cB8pGZAQokYo0L0+WLnAGTFGlx/ZU
	wWWfYz+4fyutG39Ri7SN2fx2pkatrg33nWyZiQ7CUzK4H7Ax2weSo29p9iJtEhkcaHdY0P6Xv5p
	ybvOyOFqNPJqLb1vtYuth4aeYfKGQaIFyWUELrtLTAu+1kYgdzdv+xDlLUtXx2iwh60xQMFUmpp
	AuMC61iHiVa1dYainQszNxideWf4heQQVTdvP/vE1FHbdnVXMIf0SvVqvKvRM1MluEeuHBrXhku
	M6rIkKhREAWvRSXVws4vtQFMXDpzZF4K2fvbhTIcBA==
X-Google-Smtp-Source: AGHT+IFr98lKcEVYnnkqsCoz+Z8A2fEc984DBhugg/Oa8y+dT6sYSEBZhV6Cc3XnkU04+YzD5H2SwQ==
X-Received: by 2002:a17:902:cf09:b0:212:4c82:e3d4 with SMTP id d9443c01a7336-21892a587b2mr7098505ad.46.1734045296766;
        Thu, 12 Dec 2024 15:14:56 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:56 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/10] lpfc: Copyright updates for 14.4.0.7 patches
Date: Thu, 12 Dec 2024 15:33:09 -0800
Message-Id: <20241212233309.71356-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2024 for files modified in the 14.4.0.7 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.h | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 86d509f669f1..27e7a033b53d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2010-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 71d3e60f4b20..32298285ea5e 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
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

