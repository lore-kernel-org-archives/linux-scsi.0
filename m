Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1656332EB5
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607468; cv=none; b=pcORhRnsg5l3Ne9PhfwwZYqgEiH01xINOYGeh2g8RTmBxXi7xBoA8DTz6JaLCZu03Zhf82DnMquYJIA1BuiqdqmF47Dqhj+bYP0+KEwxwldYMs9AHleMOZJ0044jLc2uX7BXZgn7LQ4jxZ7Wk8vn5B0ys7sS7rt/TdrXaJrw+AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607468; c=relaxed/simple;
	bh=3j45qOv9dOKnEPoGLBz2aPE3Q5ghWuddtCesY8bMY7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcu0/DFo3khh1AmbxeL2Qvg/kguKKv5vM/8Ue9AZG4ioHjmAr0yRkx38ULK6wED2934gaIMkwvuPxzaJXNmYnOVsLWi8iDZYl9D6e9uvTTg3LANnYJL3YYywMFGb/VjAcTwT2wak5xyvTq3UPjECy7+dndHWhJ/R7zL23vSXWiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZ52F4m3; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZ52F4m3"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6a73db16efso5006584a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607466; x=1762212266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZv/S16cQGzKZl+7abSz9G0MT63mkGDYKPwu+Jq/R3A=;
        b=NZ52F4m3SSvteM7ZynL0v9jgsRAEzYZicmABZKise7PpsWD+s9LjFrcoPbNy+O6oKK
         EY4+bRdbTZ+xElWcywLDRGv6NZXbN8tjBCg75rbXN6LM4/HtpTIC+DJO2ifZt3U1z1z5
         +sJq5KWc6mKeeAblJePillocNrdGrp2JfsRVKfSCrjJfDckTMxfVRRPE1oUm+QpChkaD
         eLzLncQJ+8vhkebJVvOnlXikw571QvjtS0EeB6D8iZImhwh4bjrW4kKZ0+xgX1Z89GsQ
         NhrAOuuN4Jb/mYREQN32PvCtQFENA5zJui4uQL5E/hjwNYd8oMEkLtM87cKZQCbBSne8
         dKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607466; x=1762212266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lZv/S16cQGzKZl+7abSz9G0MT63mkGDYKPwu+Jq/R3A=;
        b=il+oSMJ1jkxXfeGxfOL7ABeqxSuf+WGyR+VaVlTwH5/PCoQaB1tCId/LCtzkMgAUK8
         Y0aMntVfE68eQHNH3OLgZi1MmQpzhnaem2N8+B1dME2WNeUcuqN1wW4QJmuVoxBHyA9v
         rxtR9tanZ+meHXcwZnc5PRt7QKxSafhb+T7myyOCI3Bsx6M+F/rFf3GMtXBOKxcmq+kc
         AazvFPpe1HiAVL+DuVpbVIj+1ydpG3m667R7myH4KaUS7rYZH7tnWZp1B5mFl9jYj+4s
         dOwXJb1/AW5Pjtkk/VV2lq/sBoGsak+lHjtqAQ1RH09oWH1G5QImtln8Bat42bcdLsMD
         iSTg==
X-Gm-Message-State: AOJu0YwZdMg0NzjYYLFatSQce0CVereNBMUupnKw+leZIz/BZEv2fhpR
	AqinYWW+GVas054HDaE3bG9mJhSVHYd0sEEfpDjJIGAoyYbNdJsIFVPHKVM+fQ==
X-Gm-Gg: ASbGnctVxFczibQACb9eSj7IMKMVazo3bRvQXdw6vUZSy/HY8TGhw/TY+jXkuu5eWEE
	69o4cuOAzpdls2Bq39Y50dKEZR4xtbZuuPcu++wPeExol2L2aTxv5zobYAr6TJk16wfzPaislNv
	dE0SjuV79w4p9xsTgUdJ2+k8vcRvCYp7bLdzg1ErN134hp6aaVl2v37PUKHpkkaeiqLdwD6Tz+v
	H1rEdb1MooMc/BKdw5Hrha1aUei5QMcbG+tkYCDhOsUCFvr4iobjflmh+seHGkG/Gtj43gKQtLs
	LfnUeaY0SPKUBYKbdKpUCgpWDdzmRL1N4eDWeShChCc8oxNi1JobNHXmfeqO1lf3DgvUgbjwwj3
	F1SzRgFuRW8G9mnm94ZMm2ZdErIbERf4eGZ4z0LaTHksU6SpkRlTuaRdmh1ZeetpAIzyyZLpU44
	4Lbvp9NwZfEuZ7BTAB/YFaR+Z0SfJmA32x29+InomMxu90dld+IM0nJaLu/r3Z/Ykrg63PAQU=
X-Google-Smtp-Source: AGHT+IFoYGki/+d3ZL9VNqTv+AvjbLkVs2nKxbW0I29DyHsgjMLaj182VNPcAUeeAPYSt2Ge9afZZg==
X-Received: by 2002:a17:903:2443:b0:272:f9c3:31f7 with SMTP id d9443c01a7336-294cb6747d9mr14212495ad.50.1761607465893;
        Mon, 27 Oct 2025 16:24:25 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:25 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/11] lpfc: Copyright updates for 14.4.0.12 patches
Date: Mon, 27 Oct 2025 16:54:46 -0700
Message-Id: <20251027235446.77200-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2025 for files modified in the 14.4.0.12 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_disc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 511aae481b77..51cb8571c049 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

