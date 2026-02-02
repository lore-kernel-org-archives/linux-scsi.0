Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017DD1D7E41
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 02:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770000343; cv=none; b=D1dS5EzSTgZ5xYGByGjECwQoZTYBcRQSzgoMKEf71xw1RTC9kcZ46WJRsiAVTw1+KKDRnE7PS2TWj+v4RIPlJ8QERuRkFDHg7u47OxujujBWXPZt4u5rpUu2rAi+Z3khqoq3Oq1/13k4RzOsbU+TCo52yCJJc3Np0ykuKhpuNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770000343; c=relaxed/simple;
	bh=z27B/FDOfmmGkvQXwTFWiYCTYY0dzJFZZs+et6QUEnw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q0Lkna453VaII36n1Qb5yzGWF4ecRdhiHLfLQTNtUVYjAT2xBjOqaHr2SPLrcdUDJ5d7DbLGUdBmd1isbPlvZCJPIo8OJpz1bwWFzB8EQcERSrkZZiZ6Es1HGZCCKuGOCkqarWwz4Ai/ZW/gz8CpNbsTMkCTgb9pVXvzreC6CpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tier4.jp; spf=pass smtp.mailfrom=tier4.jp; dkim=pass (2048-bit key) header.d=tier4.jp header.i=@tier4.jp header.b=nVneW0Q4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tier4.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tier4.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tier4.jp header.i=@tier4.jp header.b="nVneW0Q4"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-81ecbdfdcebso2053913b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2026 18:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tier4.jp; s=google; t=1770000341; x=1770605141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n7l0qcnyrUiRMBos2/spllTnQlnbr3gDS72IGaq9hbw=;
        b=nVneW0Q4mXlnsT6J8rBJonpv9a5/dRbes8nZDLtXnFXMbJJM8/XUT5akmTSM971/1L
         8y+8yrxles1fjbquY4P9v88vluuD+C2JL4XWE+Nvnan328KtJqLliKuGrgAFn36/QDNx
         b1ybhTwpoFUtnDO8kxzkDw1MLLS2dwmOuTbJWifI2U50EKOHV5Ouk4seV7tmrWCxUewq
         0HOsO1XzuenSFRQlbpTU94qRb0Gq7MfJCmAenI5KlwbMeFa+o0nJnwZ+c26qm5JJYdC6
         DdDHlm32z/FNEVHAlBZbD+QLsG+E8ROLgmOySLbM5WhHrA3QUbgmqEe3Zo4jV8Lrs8nV
         yJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770000341; x=1770605141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7l0qcnyrUiRMBos2/spllTnQlnbr3gDS72IGaq9hbw=;
        b=U0I3lOGq6RBege0hkfBS8MivnAkJyZYvBtPcSihUykG/JfIaX4d+rqrBBen0N3rvR8
         +SAua4BxQEfYI5qOTl7BBUDFFtsz6NCjoqn/SZHoma9eCfzeTGemwXgljE7lKysgZ/6Q
         faYi6AI58ivTNy/695n9kRwdtTxVLEIpyQwgrM3LFgU4O9NKxosJrJfsrU+K4ah4fhJp
         3iy1NjnCABBwlMZMLdY57nMiQc+mChG/mgIzqzp65SRlWzJBQEvoMxLKb8te6E4xQ/e+
         5J6HGFMYjWr9E0i9gX+ust3+UlUeH9vlPtWNPrh0DwHaDZ6n9KVqc3/PxOqT9ItWfmFl
         mVFA==
X-Forwarded-Encrypted: i=1; AJvYcCVzTJlz3bMbIReXJ/5NYDf6wG0pD7GVDXXqTUFaFGphmn8f6U19048i15y6CL0Fcg2uJcz5Y9AdlIZC@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp5bETZdW6frdLGXcZVtmgEMnEhjWwi3AdiwSSWSswJyIeui6I
	Kg8Eiy8QLAGqDomOU6wyL6Wm6JxYNlQQdAUejSdpkjQU/T1mfG5zAPm6sHVaJSkb5EM=
X-Gm-Gg: AZuq6aJ7h/Rs3oEZQ1vmUweJdFXgOTWjNY5//F4JCihl+n0YqukVC0lcmeNS6J9Z4ou
	yq5xygNtEtrXrzpmouinQTMmeyMlHw4p8J1JtiDNQ7dsb1wevz1BZ8oPBc4/2SMbzeJWQdokoW8
	EukybwobOsq3lPsLWXHPhNJmfrdCFOMadFvcTnflNUs6wTnno4frfgpRGfSUdf1UItnqSh+pqFz
	qSfexttvI4hIF0IW25XJmqbEKZ14e4VAjDVFMBlPzfmxMRNGYH20hObz8SR+GlJ3l75lKdQxoSS
	HWB9zLZ3tKMji0dxMME6GlvATff4IpJBqZHaWtIhOJgLDUU25R3N63cZwP1AhpZqHqWgYKDUtTY
	RwVNS8p4jtmwLQHnEulUhoWjFa7CNHSjkPVlBgJjvoFcg9m/EcKuNRvgmUu9xPzJvexZmcpFqXY
	I5jHxXgaAYKvIxzqtZj4d/MXmJF1aP9mx9XyN5/L5gEJUEGiY=
X-Received: by 2002:a05:6a20:3d8b:b0:35e:5a46:2d68 with SMTP id adf61e73a8af0-392dffe0dddmr8347239637.9.1770000341265;
        Sun, 01 Feb 2026 18:45:41 -0800 (PST)
Received: from dpc2500057.. (fsb6a9315e.tkyc502.ap.nuro.jp. [182.169.49.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b413d16sm135081995ad.25.2026.02.01.18.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 18:45:41 -0800 (PST)
From: Keita Morisaki <keita.morisaki@tier4.jp>
To: Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>
Cc: Stanley Jhu <chu.stanley@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Keita Morisaki <keita.morisaki@tier4.jp>
Subject: [PATCH] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale trace event
Date: Mon,  2 Feb 2026 11:45:26 +0900
Message-Id: <20260202024526.122515-1-keita.morisaki@tier4.jp>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ufs_mtk_clk_scale trace event currently stores the address of the
name string directly via __field(const char *, name). This pointer may
become invalid after the module is unloaded, causing page faults when
the trace buffer is subsequently accessed.

This can occur because the MediaTek UFS driver can be configured as a
loadable module (tristate in Kconfig), meaning the name string passed
to the trace event may reside in module memory that becomes invalid
after module unload.

Fix this by using __string() and __assign_str() to copy the string
contents into the ring buffer instead of storing the pointer. This
ensures the trace data remains valid regardless of module state.

This change increases the memory usage for each ftrace entry by a few
bytes (clock names are typically 7-15 characters like "ufs_sel" or
"ufs_sel_max_src") compared to storing an 8-byte pointer.

Note that this change does not affect anything unless all of the
following conditions are met:
- CONFIG_SCSI_UFS_MEDIATEK is enabled
- ftrace tracing is enabled
- The ufs_mtk_clk_scale event is enabled in ftrace

Signed-off-by: Keita Morisaki <keita.morisaki@tier4.jp>
---
 drivers/ufs/host/ufs-mediatek-trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-trace.h b/drivers/ufs/host/ufs-mediatek-trace.h
index b5f2ec314..0df8ac843 100644
--- a/drivers/ufs/host/ufs-mediatek-trace.h
+++ b/drivers/ufs/host/ufs-mediatek-trace.h
@@ -33,19 +33,19 @@ TRACE_EVENT(ufs_mtk_clk_scale,
 	TP_ARGS(name, scale_up, clk_rate),
 
 	TP_STRUCT__entry(
-		__field(const char*, name)
+		__string(name, name)
 		__field(bool, scale_up)
 		__field(unsigned long, clk_rate)
 	),
 
 	TP_fast_assign(
-		__entry->name = name;
+		__assign_str(name);
 		__entry->scale_up = scale_up;
 		__entry->clk_rate = clk_rate;
 	),
 
 	TP_printk("ufs: clk (%s) scaled %s @ %lu",
-		  __entry->name,
+		  __get_str(name),
 		  __entry->scale_up ? "up" : "down",
 		  __entry->clk_rate)
 );

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.34.1

