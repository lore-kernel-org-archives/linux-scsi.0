Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA56385D62
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778605684; cv=none; b=XonYtETgqOdqDaYQGSRaBPinIEbxj9KADQ6pg//mfbTv/kFWaI/J7UvgeAceBcChOJC1CxDueemPXTz+wbik/mifkpn/MFAJH/f/DNSYFrE+OeZgNXBJ3MPw8Lspp0p+PkDtneDjQEM63rVjyG/4ty/9ofqbZLZfkPD+f2NS5OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778605684; c=relaxed/simple;
	bh=W0teZJlfYAQLaXLTsjiehVqqunElU0WQyO/dNPhaS6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NgtVVT2LwfKiDUwIu+Q9BiLdZjfIwGsBc5+OQQyYARlsP9OgZXHBN9ooz/b/Gq8+qXBko6lAj0BR9i0BXWsTtLlbu9KnqUnmJh1YaGhScl0kShnSNfbzstRJwqEXXIsccfkKIAxnZQ99LylXsHjbHm5+9evdLfzc0W96X6RbYiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L49IjXOX; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L49IjXOX"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba0fc8b1f0so37234935ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 10:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778605683; x=1779210483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QYrM1ugjRPgLhpplO4rHGDHi2VlP1UNGf3qR/QOW+Dc=;
        b=L49IjXOXzujHBhOS1lvhfOlW6TuVaDWimWnUSJDvnZrG0L7Xrg3RpprNJR+PuZ33iB
         ZsL6Igm7CNb8G4liCfAlQMY25lS0fPSK1UwiOey5/3q9rBzsSzCX2W6q+8DkoUNjp442
         5IZXH+WmDt7edxmhxDh08ftw1C5oAiM76kI/CGWW9zvMll38yLnnzGO7tE4utMx7dqk+
         +WuT2/LE4rT/vAOZ782gdOGBk2WWb2gXwnF218viOUNchXT6722hmzCVROka2NGg5Lyj
         09oanr34ivNQ8UM1TKhuoVssi3424+BHpX64V31qfHuY7PiYIVpdU8QJZPdoncS/l8zF
         Kf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778605683; x=1779210483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYrM1ugjRPgLhpplO4rHGDHi2VlP1UNGf3qR/QOW+Dc=;
        b=PaNfk2MU2sXa2KoTc5ajznGqsSlZQ+02aGwMcvp8Chxu3z6oVK9DuaOsCQcfZZnOf9
         wR2Z9vQ+jlSBD6wXkbg3OYjEkEGJmuKFt1nyQtgOdYBOF2g805LOwh8osqe0SJg1/K4C
         gE8IAKVoSm/49VlrqFRqFDUtGtx+4yiuHo9ieuWyjSbS5KUlrLSpWsMJeLr3srJs/ZCq
         MjWm4CxYyjXfl0JsEq33koQ1V7qcZtX3D3mb3YJg3btBQoD1Z4UOcran4Ne+W74xSrAa
         2v6h+0hVhYTYaa4XW/9QEH/cEzBHvGCAF2K8AhAR+dysHxwZPiqx3x+fM1x+NfWVYlOS
         zrCg==
X-Forwarded-Encrypted: i=1; AFNElJ+XOGQvT0l8tLyC3q36V5FXG6dcQ/HHKUu/tqpH3HBXSxvUYrETNwXhZwBwl9UZLv8GVgkxeqgt/Wy2@vger.kernel.org
X-Gm-Message-State: AOJu0YzYCEriZSu++Ly4Ivhkkqg21HifvOLqmuUsmFsNGnmHuUgPWN0p
	y+48psoxep2I1mkBUwUTpHDz5gHh4W6OqR/MOdmQI68dc2JBEgHaCLHR
X-Gm-Gg: Acq92OH0DInGI88jTiVmoz/6WugQuT9nCwsCLirch3d4YA5yqiqncr5JI+PZfJI/I/G
	x7wlW1UliUEneVLDCXxOnDMmNGBViHh3ZNFI8svfep3iShMHK2Zpq04rgpDuCR7sDsh9iGJfWzp
	QDU+hOP2QGnYGOEDeaqwhaYFveQhVPI+w8JbLqTEeKf39rlxCzFBQuATor/OZj56LkPFZO+UdMQ
	rm5esItHUdLvXDtr/akkvK7e2D0WOIN6VmPNa/3+Sy+wiOg8NUeIN0FigjBu/tgLE43nzUWYM9T
	0s6eheOjkrAiwi+RQgm5s4HQxapz1p0SpMmCCt8+zZ+QiUrx4kT0kI/XNNSQzDmyDJ6NAn2mFj+
	kiOZr/ELR6batu4VHiw4Gu4TbICURCMAwPAFqit/GYr09lP2rzQ+eFZjY6N45aydqgGRX1NkVN6
	RWEqqML+bMkWkqTcjew1v3Jb4=
X-Received: by 2002:a17:903:1a2c:b0:2b4:6470:760d with SMTP id d9443c01a7336-2ba78f473a2mr318062185ad.14.1778605682482;
        Tue, 12 May 2026 10:08:02 -0700 (PDT)
Received: from lgs.. ([101.36.111.22])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e847d0sm136146275ad.62.2026.05.12.10.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 10:08:02 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] scsi: fc: Release rport device with put_device() on add failure
Date: Wed, 13 May 2026 01:07:34 +0800
Message-ID: <20260512170734.811837-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fc_remote_port_create() calls device_initialize() for the embedded rport
device before calling device_add(). Once initialized, the object must be
released through the device core.

The device_add() failure path currently calls put_device(dev->parent) and
kfree(rport) directly. This bypasses put_device(dev), the registered
.release callback, and the kobject/device cleanup associated with the
initial reference taken by device_initialize().

Use put_device(dev) instead. fc_rport_dev_release() will release the parent
reference and free the rport container.

This issue was found by a static analysis tool I am developing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/scsi_transport_fc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index dce95e361daf..4a757cbc7139 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3180,8 +3180,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	list_del(&rport->peers);
 	scsi_host_put(shost);			/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
-	kfree(rport);
+	put_device(dev);
 	return NULL;
 }
 
-- 
2.43.0

