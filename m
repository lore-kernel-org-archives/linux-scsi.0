Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D502486647
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790159431; cv=none; b=WL/qss9jX6lfxHWo72cAkN8Kz/5kaLuesPkWH7BW5oEP9jOpteFwvmsyK/14zKmrfcu3JWzwRnlTMDaOW1dNL2rQDy+fMIaAfG0UqJk8PVLqmEJgwfkM4NR8TJhOZ3bh8hMM8m/pOaw3FzjwCBIMJQ8hHpAyLxn4Sk2aqIYODhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790159431; c=relaxed/simple;
	bh=4A2rVpCglcElPTI0FX/kZ2D+r2RLsiom+HOo0azm9N8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hhZC5mg7UwEP/fgTv7ZB3xwEwj6KjHATL38ZWHsQBAYfUO/PNuSXxJ6JHzP57N7loH8FU5SGiUrrtIQIDg1ugTQELpRDmoulUcuKoltAsj9pmcA/4JycxW4gCz39U2BTJ9W1vV6tv/c80cyIjzvqN5qryS9OwzL/PP6tRL6jeuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFfhvlb2; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFfhvlb2"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d20963so401009b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 03:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790159422; x=1790764222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SJQcE+RNdWTQ/Zw3ZZ29eF8rBGAX/7jKIXho5Hbkepo=;
        b=BFfhvlb2YkH3g09h5WLKDhAtqLoJ8CVC+uUPhVIx1QFLiUIfMAkqttQJc+ZteSS1QY
         ggf79iexq7eT7FdAFJ8zJZQonnPRm09xH2dSgkwcEsu0HDz7v7a7Vtpth5wr83IusWhp
         iBlc5rLC1cyneu8QUKYgx0vDSCkXCx4qrhgQ+tvLGjyHrJmtQLt/C+9PNQ6OS01XaKOD
         /hJrwFdR59ESMo3ZUa72OqZ2XHZRLHVGAwN3v2VW/KnY+1UpHGepu7x18ywm09xwfF/h
         OM117WKmsJMvSLq7SyVKQdiXq9Eyeb05KNVmIw4rWTuhN04OKbguUwz8G/UoaobFnVIq
         CYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790159422; x=1790764222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SJQcE+RNdWTQ/Zw3ZZ29eF8rBGAX/7jKIXho5Hbkepo=;
        b=iMPk3ZAtf9BmW8r4fY/zf6R5tffGbgp+g+VP2fbn0HWfTAVE444MO0IRdGfTwi9+X7
         oyQyGjLMVpaZEfrIVoQMsMfVdYLMWqvAaOTSPrrBopS0vdsLo8F2eFOisIvmz//24pjB
         ZE9cim3LZRUTArlFTN1BALleEMHgfCcTMSNvgetQ2EXBeiGZyFFLjhvVBdswGRZ7jPuo
         5YBUPqO93lopALPVcm6Nb2+JiFafZf72ZoO+cdNjwF77DcA1zS3JmM+LzfvXUYzftj3t
         6eb1UBaVPUK0H1E+UQj+GMFaOpf8wRIn59TJRCZODZ2x/gcLhxoWiA3U2ACciTLm0BQh
         C3RQ==
X-Forwarded-Encrypted: i=1; AKwUvByVYNPZfNY8wsw6A/mmuGYMm/+2uQM6HZvsPji5wSJg+AI2TWcPuXJzov0+s4QeXWmEAljhlm/fomnS@vger.kernel.org
X-Gm-Message-State: AFuF++ky8EevEDwRMgc508tZbFaohDf1WXwRWPwyK/hDdRDGMDmfVkOH
	kk7pSuNzPF+szW5M5woMcSI/LBMV+xwbthWRxYvgLoTAbVLo6GVSfwcH
X-Gm-Gg: AYBFou20QzpYzrbjhe4GYf/PgZpPtQK8wHRGtMfur+kdZOuJxIvccXPjoJGCMkrA/z3
	Y6e/DXlVxCPW1Xf7HuhT/LQvURWzbMt62L+ed8AmGQmodhuNdxk9jXfMuJfBcES4PXi8GonN9Al
	BvnufsupC/MR/TykAtQK35IUDPo1/qinhq6TQJxAr7fdo5AIJXtPlxD76ZrFsUhtV0wj0zLlOnN
	LrruBvNVzVVTiB+m2Ojyn37MrmMMsrw0uXOWBM041/mTuHL6DBcqXNBq77CkH9tZfovRHTQ4rM4
	aHGtBsBwk4kwQ25XNCdYmdRiuMxQMh/H57nkKVGlSS0RAvHyV0r8UoQljkem1BLtkM5mlZUEb/u
	IG1WZ9DwHsS/GsyXNJtVdGoTLG+mois41COGFYzXdB4j+2HK1hIuxrdFMxYGBBnyct3oqzAUXfW
	LOHNCS127UfmPxFec0Eo32gGCZ/QIDDJIO7teE55n3cedQ/oCQtd5JfumkSsRijsDzdV6p5devd
	5WgoBShGtL81pcA
X-Received: by 2002:a05:6a00:1489:b0:86b:b308:b926 with SMTP id d2e1a72fcca58-87d1a2bf425mr2002629b3a.14.1790159421340;
        Wed, 23 Sep 2026 03:30:21 -0700 (PDT)
Received: from ROGZephyrusG16Air ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1d5c1f21sm1048685b3a.32.2026.09.23.03.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:30:20 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
Date: Wed, 23 Sep 2026 18:30:14 +0800
Message-ID: <20260923103015.2365773-1-nbg2974@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

v7, as its own thread, addressing Lee's review of v6.

Changes since v6:

- The driver moved to drivers/leds/rgb/, where the other multicolor
  LED drivers live.

- The series is submitted with git send-email this time, so the
  patch format is the standard one.

The SCSI device handler attachment is unchanged; why it is a device
handler at all, and what the in-tree split should look like, is the
open discussion in the v6 thread.

Everything else is unchanged from v6: the hardware description, the
scsi_device_handler that does not claim the sdev, the multicolor LED
interface, the protocol handling and the known caveats (manual
attach until the split lands; SAVE on every update writes the
enclosure flash, wear uncharacterized; NULL-parent LED registration
to avoid the sdev reference cycle).

Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe
    enclosures

-- 
2.55.0

