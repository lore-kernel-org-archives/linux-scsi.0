Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94A1096F
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 00:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775089060; cv=none; b=ulIKU6pRLYbaOnxXzwHbRhF8/g+NH8UgJJms8HlFBFpaf4yVy6U3z7mjmlZIjfQVD5eiGeyyGI5n7qQwQfTPiLQO3ki4T4XsiszrFgMm9wM1iFQ4C7vPZqdJbuYp11UYLS2MZlyu10Vo2I9sqqCEH8DjWscV2i9lOQHn/yc2MKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775089060; c=relaxed/simple;
	bh=ADra3ClgKePAN13xTmcp15IadPDVNykpNzwZxAQS2OY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=buZ3xQMBoBaJU8OyEZfXVyORhT+88aUGpgE8OB2h88/e5vuhGaRWsXgh3J4Fr0KwzKZ5TLWGH5q7GXmmtMJeIg9k9qFSTL6gKX0mwhCrwxHlisFOW6srCeqC5PCo3nMTDahetcdxjbdTUV++httEK6N3lleo6iCXC+RbduNLjOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIwXTD00; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIwXTD00"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12776bebe9fso858151c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Apr 2026 17:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775089058; x=1775693858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7TYE2yKc9g4jf7Hen57MTVK0lC7jGmTkJLhyUc8vkKU=;
        b=hIwXTD00NNh5mq0HZJE6XyMHEm4RiBbA1RPrcaAo1FE2EZFb++nz0FnbglquWpXu0q
         cqXJoAcUiKySnrzFuMZRblDJMDvX8KFPDEW0WLVb9X9WM1mIpH17rt0o6gBtROcx3VOs
         p9hOB2kZ40tftkPfidP1tuNDy4W8ci7w68f+vv6AWZ4EyXOXnq9vM2id2iO8JAIeMDlR
         Qnx8Vxf12Kd1jGCcAe7qn118UFvXJLJX24XwAdPZRQMgg3/9GI4qFUdWBhIlmqRR4Rvg
         WSmSuoI14LqHdbWWZTwMac0kBhZOLlI/5Q5V2JzZEuDHcK2t5tMs437OAn0+xiYWf1j1
         V/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775089058; x=1775693858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TYE2yKc9g4jf7Hen57MTVK0lC7jGmTkJLhyUc8vkKU=;
        b=XKhi4cGf3/I4LLucjLI44RDTPx8qbopnRtsWd6YtMU23quh19h2M1x4PomcN1hF1uy
         Jndjq/S/G1FvYzY+ssVu1VDzkSWzYjUl9KzqBnJ4e5wwb9+ZUO4NOOLtzbP6/CwxOpgT
         ICBIaWKJD7V7R8QJrZZa11rw42In0oxqXQgJ5ScwNmUsDYsbCmad2Ci84NTNroDchR5S
         OMFUi0OMqIxF95xhbUEvzCkULk73+xxgbtix/q+t8mV3JhRiBl1JmlkIRF2PRZzGFrd2
         /tKPrZiJV+pf3oBgSAgx3MuKJTBEmKe+n98BP9s9/EQIW+JJE0wXO+JsrqhT6yw6+Xfa
         uymQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmtj2rDd3bXGMwGSFnlKX/TeDxOnpTsiibsXLfquQEdbn4z+bN3yx1o2vf+UE++ppElNzXm90H/g2I@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0SX1tNCGBSWq9xNFnYh0flItZSh4RMoQxVw1sIQWyB/BXKwKp
	lHwlg98zoOxkEQN7sr6aJsTCcNBQMxjhvw5lzgG8Ga8keE85Ar0huD5Q
X-Gm-Gg: ATEYQzztyJNK7JESQgUudFzS8CZWipJSHhnjbpyxU27syDunDlEWe+8SupSVoqO7ZKC
	piESixcGvw9zbeZzsYZmMMOZ/tpcEYgAwz5A/sWEJYCwdQGEiihZ/KsMQJKUfMVQVc/X3QiIzry
	elJMNcEnXCPKyoSlvkmaolSmJY4CUitYrGSxzjqvJYDz0dTaULK1/LHnpwQboBBk526rISMt38G
	DLlxQq/GeVtLsBaj0gaezc9GBZtPmdQeByDJK9s7uiugB5jKMcbvSQSmZlUL/zJj+1+yfCwDJWV
	LReNkZLnjCloyUtaLBzoXcA6+jqNsf8ht5RLimm81Z/U/+Cq0w57aJlQdC6isfvB3CrI/T7gocv
	I49bQblFS5kDjf139fSa9FENXdhDQL2F54V6TIPkCdP4MeazWeeSFreAtq9ecY+AejrCmbQDagV
	GMmIaAyBVJuISCIdS1UNFe4sD0A++ytHw2bg16iaxAfGCNTiidnvyUDKi0a4xBBfWq+A==
X-Received: by 2002:a05:7022:1605:b0:12a:6902:ddc6 with SMTP id a92af1059eb24-12be62edb08mr3514362c88.0.1775089057784;
        Wed, 01 Apr 2026 17:17:37 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12bede7f004sm1049731c88.13.2026.04.01.17.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 17:17:37 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:BROADCOM MPI3 STORAGE CONTROLLER DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: mpi3mr: convert offsetof to struct_size
Date: Wed,  1 Apr 2026 17:17:19 -0700
Message-ID: <20260402001719.72691-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A lot more readable and clarifies we're dealing with flexible array
members.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 27 ++++++++------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..7a5ba05abe28 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1139,9 +1139,7 @@ void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc)
 	    "updating handles for sas_host(0x%016llx)\n",
 	    (unsigned long long)mrioc->sas_hba.sas_address);
 
-	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
-	    (mrioc->sas_hba.num_phys *
-	     sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sz = struct_size(sas_io_unit_pg0, phy_data, mrioc->sas_hba.num_phys);
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
 		return;
@@ -1203,8 +1201,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 	struct mpi3_enclosure_page0 encl_pg0;
 	struct mpi3_device0_sas_sata_format *sasinf;
 
-	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
-	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sz = struct_size(sas_io_unit_pg0, phy_data, num_phys);
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
 		return;
@@ -1226,8 +1223,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 	mrioc->sas_hba.num_phys = num_phys;
 
-	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
-	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sz = struct_size(sas_io_unit_pg0, phy_data, num_phys);
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
 		return;
@@ -1713,12 +1709,11 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 	struct mpi3_device0_sas_sata_format *sasinf;
 	struct mpi3mr_sas_port *mr_sas_port;
 
-	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
-		(mrioc->sas_hba.num_phys *
-		 sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sz = struct_size(sas_io_unit_pg0, phy_data, mrioc->sas_hba.num_phys);
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
 		return;
+
 	h_port = kzalloc_objs(struct host_port, 64);
 	if (!h_port)
 		goto out;
@@ -3014,9 +3009,7 @@ mpi3mr_transport_phy_enable(struct sas_phy *phy, int enable)
 		    SMP_PHY_CONTROL_DISABLE);
 
 	/* handle hba phys */
-	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
-		(mrioc->sas_hba.num_phys *
-		 sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sz = struct_size(sas_io_unit_pg0, phy_data, mrioc->sas_hba.num_phys);
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0) {
 		rc = -ENOMEM;
@@ -3056,9 +3049,7 @@ mpi3mr_transport_phy_enable(struct sas_phy *phy, int enable)
 	}
 
 	/* read sas_iounit page 1 */
-	sz = offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
-		(mrioc->sas_hba.num_phys *
-		 sizeof(struct mpi3_sas_io_unit1_phy_data));
+	sz = struct_size(sas_io_unit_pg1, phy_data, mrioc->sas_hba.num_phys);
 	sas_io_unit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg1) {
 		rc = -ENOMEM;
@@ -3134,9 +3125,7 @@ mpi3mr_transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	}
 
 	/* handle hba phys */
-	sz = offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
-		(mrioc->sas_hba.num_phys *
-		 sizeof(struct mpi3_sas_io_unit1_phy_data));
+	sz = struct_size(sas_io_unit_pg1, phy_data, mrioc->sas_hba.num_phys);
 	sas_io_unit_pg1 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg1) {
 		rc = -ENOMEM;
-- 
2.53.0

