Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CCF42052;
	Wed,  5 Feb 2025 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717659; cv=none; b=csH3PF1VZZgOJHt9n+QDF2mzrZuQIh5LTG8eSvmj3es2wrbieCsdoPTNuFO/jLuauD+3MkvwkgknphEYTyJqYB/9ZtutAK8jqU4c8f7hl+h+3YT6ShLnVuDgHbi8Lu5qU5HV6oerXvUPgwOxGyaaLrVBiJuceLXsbfdUCMKk2mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717659; c=relaxed/simple;
	bh=6Dv9u9iMz+DcsLmWTQCbzBZtfz2P+8l8k57NZKBzhGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bszgNs9QuPHcKFem9Q55JXDcL/qmD9Wlt8eoAE3FOC6gvuRhxSQ97cQ+OnIR71aMjx9twIQezMMQVoRckPPfD+PvrH8h5cvAidqw+YN7lxoSObjN4Dnfha5pliwqnjFe/1BAkkIZe/od0iAMV7Dr7B5pfUfYCw7vYcGMcHoWM0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ax59BxCl; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ax59BxCl"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-46783d44db0so59237091cf.1;
        Tue, 04 Feb 2025 17:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738717657; x=1739322457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=ax59BxCl505GgNkpHXGEHxdvMzsMTI5vXtwwgCyUOp93tf0vDfFH9tWZgt6SAqLYD6
         SaTtv7xyGar4dRdU4mUcWkExBB55FF/Vwi1UBNHO7qWA101izVffxBua/UXfpNFAXO9Y
         a1F915e/ik1H7mcxXGysofCqQWrylayJcosbSmzSgpGmEMFOWyv9m/KFlcflc5fAyF+x
         WNeqlmHgx8YpiNYn1SXrN/QGCSvoa43//U/Jl9RJEmRt5CvVzfcGASVldyZ+/b5H+1h6
         LnbXlZrDIfLwr/4+dHOVRFkGCdVmDQI5iWO74REettca6YlKFoiID98Ll1AsdNoRSKeX
         bW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717657; x=1739322457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=KyeuCNKiGsellkHXO1XlgqINQ1roJQPcrDu1Tmo9y1YXXULDLwTIsMRy3a0GC34Lx6
         5JGNrh9iwqD10lJr2OTr9hJ+sMVo0NlBY6pQef71juN0lbFzgk+IR1mz3pMzNeT49qVM
         UYXV2U9n2i0nQwa+rP3iH/ZV8pHbmqQo5qowA7GjyKVQarvEpwAiiKo13ER3YkwSMRXg
         0xGHo8K/aK2J0Bfo0ORCvluvMYffQIZIcxrv+7nZuiG0tfcEOn+pMqYw4M5taCqbzLsn
         xmLEVs65Bcu/LOjMwc+a3gw7SQ7D9KPTYjxZxTHwzixTLfUKQpTOqmwv8749ljFg6vQf
         TB9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV5+727Hfwzbl6oYl0K2Q0bhxDSL3rhE5Viv8ZJ+/zKSbNVve81YWF8noLeSMzq8v2+B98np8Su@vger.kernel.org, AJvYcCVefozxR0Snjza9rC+Pe33cXqD2axeql5cKvfSTfCwV9Z1HjzEu9uzf7yiVf4dNj0cqtHuFkqt8Lw2tMw==@vger.kernel.org, AJvYcCWtoik+rKOVMETExtCX18vt9WLi3juvD2HPGdQi+qM5rJKaz8g+cRFvKDaulk+3Yv+kbxdva91skavr5zk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymb0ksF8iphnuk6cKmBbpFxPniwqPmilGvY3M5/pNuJPVCLSha
	KHyniLhSnV/SEB4RCf8IIdT3uHn4JyWubuqm/pZ04ow3/eJZ/PgdO0buZA==
X-Gm-Gg: ASbGncsLH1ol/pLPUwLY51NqPD0G32kI4k57FYPpV+EG0OS7AcGOXj12HofAaGF6Jux
	+Ze1Yhqb1uOe2RQm4ukRMKkOCluU6WbiFqB5ZRdsLEWX+3G/ThBwZcD8hprYjF1j0FPCzvJUM1d
	E0JixZLiM0AQ5dZPtLf5YUf1DlWfjAHl6v353aaZg6uTOi0wLoF8JT3SzOCmOI5SjIwGl4EIB5l
	BH4Nk8/ILsBMVB1pEixLGXIoaZDLB7s/lJ9oeFmQme8fauPiTEbxKRVq5j85c6X9hDcSeHJYphj
	pDrF5IeemYP6XeD8VKAKvpbxKhap75tjKXyntg==
X-Google-Smtp-Source: AGHT+IGZL/SmfkGwGOEYRyj3+4VgU9tfZvvahbcV/s4gP4J8yvv4GhsJtUGI5ZNOmTME2BzM3ehRaA==
X-Received: by 2002:ac8:7d0e:0:b0:467:677a:74d with SMTP id d75a77b69052e-470281c3b9fmr11744121cf.25.1738717657016;
        Tue, 04 Feb 2025 17:07:37 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf1728d3sm65069281cf.57.2025.02.04.17.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 17:07:36 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: qedf: Add check for bdt_info
Date: Wed,  5 Feb 2025 01:07:32 +0000
Message-Id: <20250205010732.16891-2-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250205010732.16891-1-jiashengjiangcool@gmail.com>
References: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
 <20250205010732.16891-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. No change.

v1 -> v2:

1. No change.
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d52057b97a4f..1ed0ee4f8dde 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

