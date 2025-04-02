Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2871DE2A5
	for <linux-scsi@vger.kernel.org>; Wed,  2 Apr 2025 19:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743622945; cv=none; b=j1Or634YQbQi6wTfDhSp8ojCRgwHZ4bR1ikOk2b88ai3uHQVf2ZgLZr5DmhUj+gUhjmiMz6gnCoixOe5b9BOdw/qPiD7vm05nfZKQvGtobYex7J5/IaqTjH2+jE7E61fZ0FDM4vPavPAY3R0XdyihrtAEgmARIHjtSIA1kTR85Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743622945; c=relaxed/simple;
	bh=9XYhl0ZE9+HKWKZpuXUIPrcD8SioJ/w+JX9cypWBKV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JuOBd8SWxTGXtm8poeeRvFv/cM7Cx6uwAFCUEw2nWaDcSPydhuT/7XxCJds+/NYzkHXDOTF26wX0CQWtlSXbZiXO1MuT3CoautGcpJl7fgxCMiGqAQFfr/nt+YTCiOnEMgJedlke2UJkefowrcTtUPDcYhOTcFdAtEhuJcLuxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=DAZ01r9s; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DAZ01r9s"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736bfa487c3so130687b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Apr 2025 12:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1743622943; x=1744227743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yRgZAfGNjbBZGwp1Ms8e/uyPt/GjJvybehTQLlt0do=;
        b=DAZ01r9sdnjKtn3L2g2EMPgVvW0HeHATOIvg9AApDGXEE5pqeUlHKYZ0aiN1+Ws3Ga
         xuDO+g0+1aY5pweUjbd3BRQbN222KxifTm6FZahjoanALq3vuq4dHLueW2Px135WUwn7
         HEFfnC/HksEROFkOsaHdAeQTOmIXNg87/1A9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743622943; x=1744227743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6yRgZAfGNjbBZGwp1Ms8e/uyPt/GjJvybehTQLlt0do=;
        b=IwNEQad0rwyH1QkDBJjkhaXhY3/ITD/Fy3OYTyqfR5WCCTaTBb6xbJ/ixRUl7U389N
         NYY+uufjCNa98w+/yBSRcSqU5FsnZGwLCHeXIzVj52rIo1smr4nuoK7Ti1GuaQAGv53m
         WJgkwZNO4II4YoBSatJqFNXqXh3pOKnqVh9NDNS1mRPHiwO3YXiMjsmPo3yqbHeYC7P0
         hhKITZ7xmHj/di62rJFmrDir7P30dffWlSikCjec0DYvgHFFOw9FdhCnU4uHmn6kQlEb
         YTwzWTQTl9kMwQtsFCAPvHTP+9VIrIDeYZqxSY191gGHFZzn+bIf5ih4ua9VPbgcZ63r
         K1wA==
X-Gm-Message-State: AOJu0YwLcAVwHuJ0EPJjBjsjAHXbcQqoclrAptVvsIvvkOhPkxEd0ISL
	VHPeC7s8ydf8kLh/I7Dy4OlvdF+Wdm/i7e+bfm5zywgIyUOsdx7AlXTgk4HWS1dk7N6Va7TOY/f
	9ExbdLudOSrBiSxOrrmtTln++bOmZLZsWe97mLf60TIX6oViLwtxB2OgYDqw+bW4OZOQAdJ1QwG
	RiZWz/WqU1x3LUq4n6n0D4hGcYP4WG4/pn3FKEkeQrkpZmCA==
X-Gm-Gg: ASbGncvRO4s4lLvh/hGcYcLNrhdaKNvZUiN2e7CNSSv5OMQBx3m+FKZ1Mla8zzlgKVO
	pBC5ym2XWGWThk//Ok/AHriCJSg9aSH/OtIiQP9dtw1kN7KuPYb6MS9d7gcZ4YJUSmKS1z5nu4s
	mhWNwdalWo19ATh/tDlged2e+DAPb4DoQfDnQW1zUa8/0Pp1kmrI3YqpsOnORYS3fH7tyXOJZZ1
	Oyi5Qb9qt7J8xhn5Dkv41MZeHDX+yAFGQZXLxTTX3vGqxwIH7ecmgbEKz+OP4lllGkqvg17Qs2W
	jrPAx5VNh7Dp2SYCdZSqrN3RI2HqLNEI0aA59yKsork5DGbSBpKYYQGShvQ4n5J+gkeJfnWz7Rj
	AwXNzfRaT/7zgszlLngufwDl6azMqG1s=
X-Google-Smtp-Source: AGHT+IFdVOeIhKBvroftqUh8ZBgxkd8w7erViBVtsZf8iAKlPK9ZZbk9a2ySg941JCbJtkThCrbM0A==
X-Received: by 2002:a05:6a00:8d3:b0:739:4a93:a5db with SMTP id d2e1a72fcca58-73980434c54mr24372557b3a.22.1743622943067;
        Wed, 02 Apr 2025 12:42:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710d97cbsm11797396b3a.173.2025.04.02.12.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 12:42:22 -0700 (PDT)
From: Chandrakanth Patil <ranjan.kumar@broadcom.com>
X-Google-Original-From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	rajsekhar.chundru@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/2] megaraid_sas: Driver version update to 07.734.00.00-rc1
Date: Thu,  3 Apr 2025 01:07:35 +0530
Message-Id: <20250402193735.5098-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250402193735.5098-1-chandrakanth.patil@broadcom.com>
References: <20250402193735.5098-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 088cc40ae866..8ee2bfe47571 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -23,8 +23,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.727.03.00-rc1"
-#define MEGASAS_RELDATE				"Oct 03, 2023"
+#define MEGASAS_VERSION				"07.734.00.00-rc1"
+#define MEGASAS_RELDATE				"Apr 03, 2025"
 
 #define MEGASAS_MSIX_NAME_LEN			32
 
-- 
2.39.1

