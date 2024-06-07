Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0FB198E86
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717780017; cv=none; b=UoPr72ZDzls29Yi8GK8X0L8AygbIV7T+QL7YMIAluAzl+KGVer0WFUrz9bDrk/a1wrcnfs6ZJ9moO7WW8Dm+YuzpViUvYcgAQobHPW8dBjuFInL6n1th3uoN+z+1A+WRtDJ9+ZvR7hkuATzU4vu54l1prZ+0p7GaldFs02HisKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717780017; c=relaxed/simple;
	bh=iAbPGXH/r5gL1hZgWkLgKCD1/WIGTyanOjQWhd5s0L4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b13bBHstMOSN/Kjem4FjWp74WgJE7vDkYG1TCUYU3S37y3Gn9EMOlLLv6Q3HDgQP3DyxfEmfu0HbYvsMMf9BrA+GGvYQn3Pjv+PgEX3/AUzVBOMgUZGNv49/ddI0fQJA/t7LkFHyqytxHgQKJ/HFFbloMw7Ms9eN6v33qmhlAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ps715JDL; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ps715JDL"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa75354911so3818497276.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717780015; x=1718384815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1aQwu1iGrHhm3SengJCu2MFtSP+MYd6cSL40GeM53Y=;
        b=ps715JDLGptltPdCPW3QatT/4wDBnjFNt4gBDKcCK8kviV6yKg46wfSlqCl9mz7srx
         y1IpgPGzoNtqDCJ/MRJAfNJ+m23FNx+2Qi27R1nz9oe3Y3T6BRgvPF1uwqyQR2qL+YqM
         EBk8UmILBL9mjAKMSnz2FFaGwWeQFqlC9ijyCsLlAin0gk1EB4BFVvKO7wh6OBNCyd8i
         FOZCGApB9gIE5vVD1P04K62kwjaQqd/ahND9iF9x8EaJjqFDCUKLqyrmo/Imq32WIMxE
         igfHkxN4QPNy0jXghr3W5htLMBjUNFxdGP9wvCMkj5u4EOulOjEG/z+7nZG8fp7BBtcq
         jFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717780015; x=1718384815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+1aQwu1iGrHhm3SengJCu2MFtSP+MYd6cSL40GeM53Y=;
        b=kDQvZp14l0akGk1dzOqH5CfNBJg0bNmW4MS6NSEEGPywLiodo8RJmgME/x5tFokn+X
         G1Qx850/98ndDM/Lp/jYGXgLrWdgUQf5Iselz8l18hpQHgdkuXwYZ02gu/fYI9A12S59
         kszS43wutmkNKcCHS+Sm5aXutmfPNGXZCwWZ1X4bJMsLI46EjfcMZZxf2Q61M+U5Iloj
         FHeKA7VSAZZ6/2S06ke2JvgXiuxNHLBBaIc/9i4Erb8EbJ6V+iii6QRknBAccbX1D0vo
         VVtQ+Xaja31qIizaTVqSmA1FUPkLr5OfFSrLhsSghrSHF16gYLbXbw9EaB3gom1m5gq1
         7A5Q==
X-Gm-Message-State: AOJu0YxGOi7ud273VQXKydVEmuIWybNycW4/DlCFr6U0mey1P+cxFiE1
	Iqr01AxRyzkOO3UheHFKU5woSHP7Uz0DTc/4TgPyifM+jw6cazxE9GacFB7DxbszVacpyMTEMxt
	dU/PzldxQSA==
X-Google-Smtp-Source: AGHT+IEWfyGzm83cGRqGBS0J9f1TYfWuqmEnzU14H2go4y66H8sDPlOOnoW013f8z11MSu4bAHBo7PH7HlEepQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:6902:1009:b0:dd9:2d94:cd8a with SMTP
 id 3f1490d57ef6-dfaf6647ademr268916276.9.1717780014727; Fri, 07 Jun 2024
 10:06:54 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:06:39 +0000
In-Reply-To: <20240607170639.3973949-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607170639.3973949-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607170639.3973949-4-tadamsjr@google.com>
Subject: [PATCH 3/3] scsi: pm8001: Update log level when reading config table
From: TJ Adams <tadamsjr@google.com>
To: jinpu.wang@cloud.ionos.com
Cc: linux-scsi@vger.kernel.org, ipylypiv@google.com, 
	Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Terrence Adams <tadamsjr@google.com>

Reading the main config table occurs as a part of initialization in
pm80xx_chip_init(). Because of this it makes more sense to have it be a
part of the INIT logging.

Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a52ae6841939..8fe886dc5e47 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -568,13 +568,13 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version =
 		pm8001_mr32(address, MAIN_MPI_INACTIVE_FW_VERSION);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "Main cfg table: sign:%x interface rev:%x fw_rev:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.signature,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "table offset: gst:%x iq:%x oq:%x int vec:%x phy attr:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.gst_offset,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inbound_queue_offset,
@@ -582,7 +582,7 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.int_vec_table_offset,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offset);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "Main cfg table; ila rev:%x Inactive fw rev:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version);
-- 
2.45.2.505.gda0bf45e8d-goog

