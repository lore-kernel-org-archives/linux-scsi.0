Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C9316C854
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738145591; cv=none; b=bGcv6P9sfyoAmCcFfw6YLTjEaEmpQU6Ow+i9aJjIU2KI/vBMNlP6A/bpbGvhaShpa52Jt/GLxutBIEefutH2H2REAnKWIeV9cpAry6Gf5NbnBW6kUp0xo/+qY6o/u8LYJk5UU20VZh78vWJ+KUmvjiol2m9+yYMJpkInES9KDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738145591; c=relaxed/simple;
	bh=6Pd4874c2o39DyUPGuSboF3ksGXM1ofUvMMlxk1puds=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=lu+OYDwszOA1cqSq2aWBkV3gwIkf+OlPONeMktpPZTA3ocHcPdgu0C0aTjPwYskDG3S77GKExkTP/P/bwZ3Gv6tbUfMk0sKC/qpPVa7/oQiMnH/Qb+vha9197xLoi5y6dUGrSDHznKg6qDqE2cl87zNOZuPtGeM4rYp17OQO6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SKJKZDDy; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SKJKZDDy"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2166360285dso112190985ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 02:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738145588; x=1738750388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P20F+ZROzfN9gUehIeWHVYIH/hhVTGfNDQ2YXfE6gE4=;
        b=SKJKZDDy8mYSb4a6EEjj/vXX+oZs1Fdt1NcHI5tqvOzIMBXK778yRrxZVMJzROD3IJ
         FbBg+tfb0O3C8vVLmnKP27K4yBTR2BBOEY74u0kOJLyUrXir2dBqE6fyhW44Ior8dsAY
         kG3pPrqyVxEwiPESFtsHyp4stUIj9sFSk5J94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738145588; x=1738750388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P20F+ZROzfN9gUehIeWHVYIH/hhVTGfNDQ2YXfE6gE4=;
        b=TRCRCmgogoSqDzEeFxjai3pbtnJKgWRNnnoRWSnwSWOZlfeavq9hvnt3KDOvuHG56j
         2rjtlH4gonGaHbOxOX1WBBR3wg0oPglkf2f9hDiwOGcRjLD1R7YV5jBOJR0DahIDsVUF
         Flu+NacGznTqjXThoCPQdjETWS9zXJlLsEdBTw/9fkAszKqSKJsEOGKe/kJuwdZW8USI
         9fBB/JvF3S7MSIxHK8xE1Gr6EkqoAKk14Zdn5XbwmMQIF/9hM/MuxjxuQuAXx2ycIcqL
         2zPnr0z4Cz4V209eBwgxQOgluYlSkf2HFAfFecvPtimpX8Ultxf58BnXYxrWnXscR144
         jdlw==
X-Gm-Message-State: AOJu0YwOEohqxgo0OeN6vYVxycatPlI18gaIy2qv7uYgRee++2sKqtnM
	glm6dPUiY110b6tu1fqoeMJmeA4CkkQTiyDtiWm4h1U5qWHUACDJbS+GSdph9Eul/WplzwWPjwY
	zpvL/gT4V2atCNo5tqordEvOgi7MqiAi5QciVTCaX6+3jhT4j30dncNd3xSRwg6D+ig3R5OCe8l
	jFOPsjWqdb04fcL9cfjx1MwavBpDVHfL44ehHXJt+BXBfZ4m0T
X-Gm-Gg: ASbGncvDnQI76l/f/P+/1MkbIl2Q8q3wYFs2PixcW/YSIJySqM/nLIsx3Ki/9KGjOtI
	sqdQi3rL2xfoGFhhyWVvBAME1ZZgmliaVduAU1usVccIz9PHEIeMBkVPhE8AW8pd66RF2PIKFm2
	yzuZQPLhJNJJdq5cICWOpXuq43zIuN/3tku4Db7TrcWUZLynzvB1sa22cC5YmfdwDBc5blT1rov
	nNPdhbg9pLy5auPVfY9R6QolB7HflCYYzlEP2ChgjIczmOAIZYE2KiowfWRiY5yDw3BNPeU/n6f
	TjdqOe/tWiK0gmgjU2hQoI+1clu7BvrgUKKkvIAc8TWm0muty5RiAac2Omw=
X-Google-Smtp-Source: AGHT+IEHh7+TBdEfrlmR0XQHx2F3UgkXDoD6mINyyOLKaPxYq+H4YuAOfc5v6tKSsqr9mq8vfrki2w==
X-Received: by 2002:a17:903:1208:b0:215:6995:1ef3 with SMTP id d9443c01a7336-21dd7c4635fmr26940725ad.3.1738145588182;
        Wed, 29 Jan 2025 02:13:08 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424eb96sm96579015ad.222.2025.01.29.02.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 02:13:07 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
Date: Wed, 29 Jan 2025 15:38:46 +0530
Message-Id: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Ranjan Kumar (4):
  mpi3mr: Avoid reply queue full condition
  mpi3mr: Support for Segmented Hardware Trace buffer
  mpi3mr: synchronous access b/w reset and tm thread for reply queue
  mpi3mr: Update driver version to 8.12.1.0.50

 drivers/scsi/mpi3mr/mpi/mpi30_tool.h |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h         |  31 +++++-
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 128 ++++++++++++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c      | 144 +++++++++++++++++++++++++--
 4 files changed, 281 insertions(+), 23 deletions(-)

-- 
2.31.1

