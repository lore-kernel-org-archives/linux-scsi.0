Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2C25743D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759820049; cv=none; b=hQGrPJysS+PHXh35kL6Ik0BsahC41yv0JFBml5lyaWx1VTG8Ytzg8wFxliQOdyGFdWFsv3jViLENgjq0BZWiIRmI3R9ml7y5GQP3+B3xJrEvn75s1GKb01nqzqr+okKPiNsRex9Ab0HAPTPoSntTE3+KZUAujMjYHRrY1vQgcxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759820049; c=relaxed/simple;
	bh=TTG+AhssdA42D9C9zLf9qT/1ySGtIas7NJQm9lzkZ40=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iV2tE9XhM6VduZ1nZLv5mJkrU484k320PRZKcOQPDqAL+LUBb73vYVjMZ2oqMcajvzIOPX1TktJG+CoBSvgi40qHqYq/wL342WUI5DzS6OZE8xV2XXGNQeiSV5GlW0CojtapxQ1eRFecAWreidn5ZCKKbJCFqbYWMRZ1KH7gvLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqCUjLDl; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqCUjLDl"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so2075547a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 23:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759820047; x=1760424847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mswOKIOKbhdl+VgGK7vEvPqN70bAqxJl6ivwxQMTkZ8=;
        b=NqCUjLDllV5XRJE+MjO8bvZK9sNtfVTfLAQ5xZDQ9Kvao4oAV70x9S6ZDTVWftZnLu
         5a7+GEDMK74bs72int1LBpySpsXJklJd8HOewOD5lUh5y1oyEAuxSHhYa3oNLfd+tyaL
         iH2PfRe1PEJ5gk5Mm5wpWeNBPIE4PNO4RfR4J7KJvr7ZC+zHaRtsfL/0P9T7hpEcEh+Z
         rjW8jqYtQRvc4nozAlk6hAkV+P8rO51tNBNHQ613cgVP+INA94tMYJ+ynLa0pJf9HrEM
         MtX/Dpqgq/BzVMtImqEts+feo3+CZ202JzN7ZbQQwS9iUIt/5wilG/+5BuK8t3sKvs+i
         fhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759820047; x=1760424847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mswOKIOKbhdl+VgGK7vEvPqN70bAqxJl6ivwxQMTkZ8=;
        b=BqdrWl9uloEID83wYm+paozAn/LmErPkBSWDl9F+YaFVPgHqzt9j3HXzK7L8JqbHNm
         ghbdkZqrNP4Squ98QExSxEMmQ1kt291o6Zb8T1ZeEk+LDGSWv5VWzNNqxxYpaBxIXljh
         5BblANldcc1o23lN9c834AKt5hdOzwHv/W2kn8NR8HKu5zlzE6BBuJIfEgQLyHHbV85Y
         bbsty/kNAV2wnmzmkOq5czCdqB+1UU6fzG11T8EjXAht6rnZXLzVli36jeBMshAlJoh/
         ACLE/Jh93MQLzfqjawFM7eNFN/wAddNZJHk5Mfb/M6ouymroCxKVIb4T1TJL1i+yx+g/
         SyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnE/HWfWu5t/wCf7H6qNnVTRLI3rDkWEKB4bEG+FFBi2DwVDgrKK8ACZ/a3Rdmv5jYi1+bH0wrV0fN@vger.kernel.org
X-Gm-Message-State: AOJu0YwywKo8KnS5VGNqrWrusEn8a+QWqBBLdjzycbQ8TN3ITjqWGj8Z
	DRLJfdn1MXCVUFFnRMq8SV/mKJvgOL3+bQfiIJpRcFYKydpgSPkDyQWV
X-Gm-Gg: ASbGnct3hZSd4jN4fNM23cCfmbb4iKcf2VekArC5H9TIRDnaphP/gtLQG9G/F75gg+T
	u2D6C9PIA+dJderA7LRDf9a1anOLq1ysoBYqfeZ9TumkphWcItf4br/CyL2GBEDiifV4D63og28
	mQUvMYB+Qw1vo1Ny3QQNUlbjkRWgglSQOwro+BsffVjBjC1Ix96brSWJTFvFKK5yQTTZu0vYAQa
	NOciXr47id+RETwGfaPyZ2JXWfGBNncWcP4EtPVG5nkGYgDR/IKQ86/L04BbE8usQYSRooujGAz
	DPOtDDCJZXykb6n8NdANsFMGs0p8y+EN5F+XPY7sNYEwVqA4+eCCnRuk3eL5drwI8tyVxpMMpxq
	QT07RDzOP9fuxdlmxK06Q03S5bPzcVGDhfokfFLabGroscKht+5Qvr27sYlKi2ixZa/HNaHw=
X-Google-Smtp-Source: AGHT+IFOWxg9dlREBFVestaXMYXB//r1bQveRFkHWcW/v8RP8fcHviNaQLC2YO5f6bIdAK7/nqQmyw==
X-Received: by 2002:a17:90b:4d0b:b0:32e:43ae:e7e9 with SMTP id 98e67ed59e1d1-339c27a50ffmr20351680a91.17.1759820046589;
        Mon, 06 Oct 2025 23:54:06 -0700 (PDT)
Received: from ti-am64x-sdk.. ([14.98.178.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee05db08sm824666a91.2.2025.10.06.23.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 23:54:06 -0700 (PDT)
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
To: Don Brace <don.brace@microchip.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	khalid@kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	bhanuseshukumar@gmail.com,
	cassel@kernel.org
Subject: [PATCH v2] scsi: Prefer kmalloc_array over kmalloc involving dynamic size calculations
Date: Tue,  7 Oct 2025 12:23:45 +0530
Message-Id: <20251007065345.8853-1-bhanuseshukumar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a best practice use kmalloc_array to safely calculate dynamic object
sizes without overflow.

Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
---
 Note: The patch is tested for compilation.
 Change log:
 v1->v2:
  Updated commit message to refelect correct intention of the patch to 
  address James Bottomley review in v1.
  v1 Link : https://lore.kernel.org/all/20251001113935.52596-1-bhanuseshukumar@gmail.com/
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 03c97e60d36f..19b0075eb256 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8936,7 +8936,7 @@ static int pqi_host_alloc_mem(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count == 0 || sg_count > PQI_HOST_MAX_SG_DESCRIPTORS)
 		goto out;
 
-	host_memory_descriptor->host_chunk_virt_address = kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
+	host_memory_descriptor->host_chunk_virt_address = kmalloc_array(sg_count, sizeof(void *), GFP_KERNEL);
 	if (!host_memory_descriptor->host_chunk_virt_address)
 		goto out;
 
-- 
2.34.1

