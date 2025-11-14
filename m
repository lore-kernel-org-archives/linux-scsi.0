Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C962EB874
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 11:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763118015; cv=none; b=LUcyZja/o91Q7r+VI9e7Zxps5Jamou3q+cFHdp4AHHMHujb1Ie5z4bz3kEmdvU2rv0FMrmQg9+FuKTah22VAXAKxXu9eVnuuJO4VD7V1oKsOTAkKXK+VVR/TA2lHwQx9ZXq8JxF7lypTKjAoLp4fi7p0bWbzdjte6CtwPxbgQT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763118015; c=relaxed/simple;
	bh=Cr5VpJUDrX/7stDx3IyKkVdmZNiHlBWLDvGapTEWnFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UM+KIxilNJDiVWiAEbPLcm92mENUUifWGO/JkeUEwqXcWZc83XhNPkWo5azAr5j7m3+/m92XW3FweJauLmQCe5KpVsgSU3L0soOQvgqyxyDshvC3L2Afgpy9LRydwBFnQVTW+VRWyIblvxcn7AeePAE3Qf06eYQk85Izx6uO72w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKyFB+gd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKyFB+gd"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-297dc3e299bso18744505ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 03:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763118014; x=1763722814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fiTiWxtyHwC7fCqBlOhxnQowLt8NNXlGyysVx3xJsUA=;
        b=IKyFB+gdnqKFnxpRkTweF0cYSYXl5YDAkJ2V/56+peh0QqydVVgw/Y2WbTKXtZiYjN
         p013SSyeXGu4Ya5TjCiF8ICg/pc+W472aYmdGROh3iN+2QGQ/bo5HrZhxoUQolpEv9XM
         fgrxTEIX6uiqj7zyd0VDCqfiQ7Gw9Ml+vnH7v6oOAHvNEaNvWaPUUeve/GUUsjvHdb5e
         rrC7ITMZZoccUzB8EO9dZrInumaelZzv9P3lp9lWhW+FlFY9qkyHOa92q7OSevxueXAe
         hBTWPZHo7oQv8Di7mRCKckK532MHoGiVIxxnQaQ4MZdYpHhJjFp8PCqIGcADx1e9nPZ/
         9FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763118014; x=1763722814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiTiWxtyHwC7fCqBlOhxnQowLt8NNXlGyysVx3xJsUA=;
        b=a8bzJszVjquMdlRRHDHLsX+MUW1IpQxv/8L92bBsvRVkHLW8MxWvk56RhG9YVI3J7z
         gM9JeSYgXlcaK1c20obgMnWfZP7zz06ecR5Sw1qeZ8xptMHf85k1rFm0ydkj28ywpqLB
         nH+xAKT4tQDmV90lwCYz2zAfzNzTLXi9HaHlGtQMCkwWx020jqa8d5fT8CyxUAXwyDC7
         G91Dwv/Yabgpb4dm5YdSdEPVnndXCSuA4PE/oKSVyePX1nTCYlOySFJGKyNM4cgxtSfM
         5y6M2Oi2NZc7s3a6aV7bGZeyY+NWSBRQ32Db6WwXFWuoFFwl7JNUHsusOGos5ff6E1KE
         c+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl2oeS/YcZe22Yw3aSCiTUyJ7ipZjHcZ6voqsbVeNQAeNuN4MLIRD1wl7OXgwbqvoRzctSRlSrqVrq@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm2IcMV8so3wwQh9nKEHpZlb4ZjVlh2bOkPZu0bX4L1NKQH8HX
	aaZPkUsQVfxygsFFa33MHL/d0BD2U2ma3ok607dMcx9KDYDhdcWQ7X3E
X-Gm-Gg: ASbGnctYouB7+XfqwehAHLN57+tpZ7Cd/PKTAES0wq792XfGVnbwR75u6MeF0FnAos7
	/Ajx0g7dkc1ogQIaSlqJAap+RfErp1Wq5kQN9BzRfw+oCV87A4OSE4oBeHZnBpEtZk2hXG6SJhX
	alOZhdJyTEUbDcFBuSEMmDeJ12iYWWwoKPw9Qkl3HUb1Kok47G4pTIOOVzlYPkvFZ3B2Lz8Er9B
	5dN45WBfSV+yuoOWzmALcuYzncTWUYfPHU6iv46wv0URCIqkNZUdtGjG9oo71Rf6QDA3N/qih1m
	WyCAhmcqAizsjd+WlPrOfKXEVtfBRKur50nXd2uyf1+lTqCOD04mAG7aLxasWkUbEf24BM9YUNq
	74ldFr7EzJR3PFsxu+gjfAPBuCBqy4Fd2/6RuWsvdg8rXk+lgCMLj2B3E9knm818TBGBwU5nLvQ
	Y=
X-Google-Smtp-Source: AGHT+IHIySgW6kxe189V/hTiJIxS9B0z3kMFPtgZCzv4JcOFT7gocOXRu0WuYyJbiP7Cd41d09eUPw==
X-Received: by 2002:a17:903:3586:b0:288:5d07:8a8f with SMTP id d9443c01a7336-2986a6d7a64mr24735395ad.24.1763118012001;
        Fri, 14 Nov 2025 03:00:12 -0800 (PST)
Received: from fedora ([110.224.242.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed16sm52409555ad.86.2025.11.14.03.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 03:00:11 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	suganath-prabu.subramani@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sathya.prakash@broadcom.com,
	i.shihao.999@gmail.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: mpt3sas: fix spelling mistakes in comments
Date: Fri, 14 Nov 2025 16:29:52 +0530
Message-ID: <20251114105952.27379-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'implemention' with 'implementation' and 'deboucing'
with 'debouncing' to improve code readability and also ensuring
professional code documentation standards.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>

---

changes v2:
- update patch subject description.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 3b951589feeb..1986c5c4bc14 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3324,7 +3324,7 @@ static DEVICE_ATTR_RO(board_tracer);
  * @attr: ?
  * @buf: the buffer returned
  *
- * This is for firmware implemention for deboucing device
+ * This is for firmware implementation for debouncing device
  * removal events.
  *
  * A sysfs 'read-only' shost attribute.
@@ -3346,7 +3346,7 @@ static DEVICE_ATTR_RO(io_delay);
  * @attr: ?
  * @buf: the buffer returned
  *
- * This is for firmware implemention for deboucing device
+ * This is for firmware implementation for debouncing device
  * removal events.
  *
  * A sysfs 'read-only' shost attribute.
--
2.51.0

