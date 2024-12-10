Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389C44EB48;
	Tue, 10 Dec 2024 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803343; cv=none; b=Th1pz64UlVbgK53CJk/O4uPVRUmNvcbiv3dmnImdce+jv4YEpiNhBmK0oKFBJ8az4ouOZb1Rc+rCO2aGYSdHLlGq29dKq++sSKHdfuz5FHMh0qqUgh811aXCJJwHyd2SHhpvXAQv1g6QsDlFbotjWIMhwsk3DKQ+5+oMTR7SVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803343; c=relaxed/simple;
	bh=5NhHa7O6RtwdRtCJDoaZPit06rKeTXv3h3+jqyfnaIo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cmhySg6wEAl2Xzh6YUhowNhgZl08U1j/+A0cduWNS9vg/AFcnkO8t+nkaVq7R2C/gfudgyFUY3EfGZt/jZqo5h+PrNaGDkaMoG1Xbs9awkDH0RxIGzekvbna2yL6W/WWTfGflnUj3Va5HIhaeSWKi+TckinKCDyww5q9DBw06Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oo0eOLqf; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oo0eOLqf"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so4381836a91.3;
        Mon, 09 Dec 2024 20:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733803341; x=1734408141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bh6xZ2UBk2TKGM3uWfsxOOPw8xFKLneJ4kGsbyp9EA0=;
        b=Oo0eOLqfur/Dzfgv7GYY8ZwPs1gPHQWUeLYzuMDTRYeLwNryL2+HK2VF2EWELPGPmq
         ldzoX3FIzb4m+1zBPlokYZcwMlyqB+vkgP+PEQegfrGO/MyKwClWu/edVW6cyIcczPw3
         pA7htwsoVgtp5rbLRMjQ4bhLRSMHvXnnPClIBd4UqLCir1mCYH7D8GKmDQsQi7tKUfu7
         2XngtB9NFSu85v0dJscOHGszS7de1wK9F45ckIzo1x72bKeJwljSx+nowf0ZYea45C5h
         kKzdPsbo2XZ2sJ95hu49S5T1dD+xn3KT1AMqJrtL2EdGMvVtP1Wu1DyyKcoDBZjD/WBe
         XGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733803341; x=1734408141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bh6xZ2UBk2TKGM3uWfsxOOPw8xFKLneJ4kGsbyp9EA0=;
        b=CsbgjSXF5pDVnE6P/cy0FWHaiiANwiaxYhPHCks/bTq1t5NUdLpSDhtgvR54FmvIRs
         WDgzUcB28EsR5Eyd9cECsMjyPWbo4p/Lh9WkBqIzzdnWolCGxI6G3NgB1sU2h/hEr/Xl
         bt7P6FiJiZ/75oWYeUC4gLWz04wovzIXQffvRTdoeLygFvWBHveRxgxrTCZpKoX8aOMv
         kemGz/vcuZuWIxapN7AtlyQ4o+Cf/OcWIW4gF22IvDmzn03HmKRlXcT9/0WaP3aC+5hG
         pxkiDWIUyeTtOYkq6qUNpmovgKVEbIbiZj4UAzPyweaD4Sqb+OUiY5L36lR4tId1Ex55
         nVrw==
X-Forwarded-Encrypted: i=1; AJvYcCWbrOU8v8fwHRILsAdXIKgy77kiFoKRPNGmwCPpe7gNf4wDoBR7+NRT7YRYydKvin6ElzvXyg+4JTp/Qb8=@vger.kernel.org, AJvYcCX/XSPiO3xpl8KHaxNi/RdpdQ0B4TKx2qZWxrIqeOMRxWppC1lbcHigacc5J7+YY/Z9MvsqV+pRpQ0NRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHOro5pKTR4XVfTDZHXFJrKLl3LAqqujfFvyPws9H6gdapjBZp
	rlQ8/9Tjfzf4mHmgcoJIRrYnK8n9IXzGZoYn1QhedPlrAQzW3gAx
X-Gm-Gg: ASbGncts2fn0/yVXEVVT+s4Yt05KvWL39OZdiYHqusFeJR1Fg1XbNLfN37U2Te7z41q
	3lxOlO1/SdZNxZpjxllABtMktrb3q/s7FX3peCsfFn3vunsahjI67BzV/mcvORYWoz/BaOVtHFY
	SwMDInFuqNWO8m0931EkmZ4Y1kT4tkpELKl6XYDCTOrC7N3krLwAX18rYFkZgR6yUl0mIu5xLcI
	M6RTDr06FXeokmqjB5ig1uL88es0T737jNInv4VMsque+Mc/nVKzmXyD7yEmP9/e1ZafynuRbL7
	R8SJcf0k
X-Google-Smtp-Source: AGHT+IFYlecFe3Su4R1e5q1bWYZOEGeW/wghL9TD+5r1xZQ5LM8x8xZn/smn38idLqW+fxYe4nR1yQ==
X-Received: by 2002:a17:90a:e7c3:b0:2ea:9ccb:d1f4 with SMTP id 98e67ed59e1d1-2efcef27dbcmr5104185a91.0.1733803341358;
        Mon, 09 Dec 2024 20:02:21 -0800 (PST)
Received: from BiscuitBobby.am.students.amrita.edu ([175.184.253.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef45fa652csm9617496a91.30.2024.12.09.20.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 20:02:20 -0800 (PST)
From: Siddharth Menon <simeddon@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Siddharth Menon <simeddon@gmail.com>
Subject: [PATCH] Drivers/scsi: Fix variable typo
Date: Tue, 10 Dec 2024 09:32:02 +0530
Message-Id: <20241210040202.11112-1-simeddon@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Renamed ESP_CONGIG4_TEST to ESP_CONFIG4_TEST

Signed-off-by: Siddharth Menon <simeddon@gmail.com>
---
 drivers/scsi/esp_scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 00cd7c0ccc76..7bb0b69bff24 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -80,7 +80,7 @@
 
 /* ESP config register 4 read-write */
 #define ESP_CONFIG4_BBTE      0x01     /* Back-to-back transfers     (fsc)   */
-#define ESP_CONGIG4_TEST      0x02     /* Transfer counter test mode (fsc)   */
+#define ESP_CONFIG4_TEST      0x02     /* Transfer counter test mode (fsc)   */
 #define ESP_CONFIG4_RADE      0x04     /* Active negation   (am53c974/fsc)   */
 #define ESP_CONFIG4_RAE       0x08     /* Act. negation REQ/ACK (am53c974)   */
 #define ESP_CONFIG4_PWD       0x20     /* Reduced power feature (am53c974)   */
-- 
2.39.5

