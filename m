Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC9123FC76;
	Fri,  7 Feb 2025 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738943111; cv=none; b=LlzVjzFAitLcL+MYUUwEUWdC2iyvsDBu1VTrUUMR1b5BSbjBcwAkpkvGzKxEWz9ZySLOkliFgINAgU7sq0my5R5d94jvhdCV6nRT8QRboOiqpnAJDHR8eLOMncEDGoITUGewBrAo3fyz7K6IlTqZONMCgWPOo8eQjlptNA7klLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738943111; c=relaxed/simple;
	bh=PqYjErFgpDmmduloamFn8lsVmTU3tqphcV/LWTKCul4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oBcIscD98LXnOi/rEawUX1Cfp1m8Hdx7HKomfmgKYE9/DW/C7QSMeOTBbqF7hUDM/pVMJS9ENeYEniM7+RUgl2+j13t0T+WmSc/LS1oNWEjunJnPjUnzO5Bob4JKretqbQKAlowpDw4d2GiNlK1vQ9ELeIBwe64yI4k4wD0j2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfHefTLc; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfHefTLc"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e425548f1eso18094556d6.1;
        Fri, 07 Feb 2025 07:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738943109; x=1739547909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/Jw4AAFTVjBV/GjeETGPBCLXV/pV2bLbSb9lO99VYI=;
        b=CfHefTLcR0MvYfIVr3bXqRXx003CNsv6ptsz2MpwxwJdk23o9glFUqhYq68wlSKfQe
         lJqPYPeeN0H+KChpPVxvTWwv/8p0e82kEMVLsPAicA6XR/AIXpimu8r6HtlPLGPSOkQf
         Brw+k/acu8EOuwrd8GUXYm0EJ5Gyr5L/WgJF3yQGytZwY2TK6aCdiwixAc7XExzN/ZmU
         aYzr8sx/U8LPHu1EpfMSdvMiaqxOkP6KnmQAPWqjwf8Wg4rSe/SIzA4UCXIL3l/sRTRO
         gzqIMx3QuItTHIqobmHUSPPl90jYB9G+N5WVsuhuPDqXiSuVE1Jo8oOYr2+Y1kHg7IQU
         XpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738943109; x=1739547909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/Jw4AAFTVjBV/GjeETGPBCLXV/pV2bLbSb9lO99VYI=;
        b=FwYpCdaWqriCEml5NkizLBkDEE/q6ryLLFVmHnIw4J42qOelgpD1913nyDiNzHrU6w
         lIeX3wHhV7+7V2fJliztBh77DYAA6vcikrA8WL5hGrA+4kdw+aXpVLF0881f4MhxmU3h
         T/jJMm2WxZL23ZiaIsZ1bc1OxNrSAXytmYs+DrepqChKfpOxIiAEB0xoZZpTM6vgS3WX
         2RhUaqr7z0BPEgK6TrhlihxD3OKFEs80/GYKnMf+w+CYqSzkCUVvrK8Co8gNTvREA2mL
         nFGJTYaCoDz2M0YukcFPcMluRL98hR6Xhm8p7YYngpzcFbcqtROhgYbaXDFSMh+Bcc9G
         R7Vg==
X-Forwarded-Encrypted: i=1; AJvYcCW9a3i/z90MHyDokIFsMe/C+6GG3rlc/R3t5WDemtUpoqmpiLoDc6BveNSWiN+iz4lNyg94bnvYuCNeAFw=@vger.kernel.org, AJvYcCWQiI581NGxHkE2r7MpG8SnkT5fbOGb2r51chcwx9i/eQGebVBIGzec4GTephXX3rRfGXsYPDHz@vger.kernel.org, AJvYcCWbVs1f1WkUIi0a56W6EUhyw04P0LAMWWAF6GL1GCk/bpvIMjXVPB/3XwRwh79a+yN6XKezra/Hvjm0Eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjVferhEt3hgT6OFdEx4f4iuAu48nO/lqNykMcNG/H+dAPIqKo
	rFUWB0r3ApZSPo7AKLjd/CvdU0RbcPSU24j2cfQ4UZzLecPBQK5l
X-Gm-Gg: ASbGncskdsQXVq8yLDppwPYuWruVktG1WAqRPSTqiHUxyLPh2TUOBc7rENzoZuGdZhL
	ct59lUSNYD4NnQIKtTFznKAuQx/zpp5T9edh1s/J3cdwzIXyePeF7HIHwa+gFMXYsmwF6LA2N8o
	fpW3tTXcIzi/zu3JzZPvULgG+UKhUUB3A839YaXhjmC/JeWumapq5H6SPDX+hWPHSaS3ieyNX71
	kNNqeGLUvRc1EV9ApqJWgsVk59Dkg5mdxVwWNOR4oTzoPPitLr+r7Boba3pX5I/j9QSKDSce4nl
	dBL5HodXA6LggcOFCpf2lLH4a5WIQ90LnQfxmw==
X-Google-Smtp-Source: AGHT+IHBucr4VfC5lc3Cqa1WhyasK/5sTIkPGzh2KQ3GqRVlxEyZaaOKiduyC1wzP7/PGqSXkz3c6w==
X-Received: by 2002:a05:6214:240b:b0:6d8:890c:1f08 with SMTP id 6a1803df08f44-6e44569d333mr51858806d6.26.1738943108794;
        Fri, 07 Feb 2025 07:45:08 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e43ba36d5csm18258186d6.26.2025.02.07.07.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 07:45:08 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: gregkh@linuxfoundation.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	markus.elfring@web.de,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Fri,  7 Feb 2025 15:45:04 +0000
Message-Id: <20250207154505.4819-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2025020721-silver-uneasy-5565@gregkh>
References: <2025020721-silver-uneasy-5565@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
potentially used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changlog:

v2 -> v3:

1. Add "potentially" in the commit message to explain this much better.

v1 -> v2:

1. Replace kzalloc() with kcalloc() to not reintroduce the possibility of multiplication overflow.
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

