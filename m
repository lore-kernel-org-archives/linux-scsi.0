Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CDE157A48;
	Wed,  5 Feb 2025 02:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738720885; cv=none; b=L8fcb6Ms5FMkZJSG5/jy4GSfuZEjLTC5F10+vhPD3GWypRFi1/7Vais5NlR33bQl+qhZy3joTK+3G2paowpoxHfWA87oMDagEpHOcnSN+KCh+3VbmoB/RuSNpJJT+XVGke0jshxxwbpsyke5si8AcGGnwnhxPcUeC4bJxoSLPN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738720885; c=relaxed/simple;
	bh=Es6yk1PUJUxPA8OTmzLtbtyn21alu/ay7LY25tfAGAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RV310hs4MqgIAi6nea5hPiB7uIAq6ptOG34mA9GPY/smkTCfO0pO0o+pzoeXjybe+yrvF0rdV4AfoZKsfMcYhwo/tdTk3ue9UcYOhtUBhTW13rtrd3nc8DIGfINVHHrKHi7O7H7Phr0JtfivsjdBO7XLvS2g8kAU84w2QYHJ64I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXQLGNkH; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXQLGNkH"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7be8f28172dso326573485a.3;
        Tue, 04 Feb 2025 18:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738720882; x=1739325682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wmqu8Vw96LdkQbtKmW3VNNRd+LI4ohMPpAuQdsSuoh4=;
        b=TXQLGNkHb3kjfQQdsZDyfXZNAW4ElI4d2YJ9vvWEpnZCA0ltsMIt+asjJcyhTTbKXk
         JCozhMM7PXhJEceqvUCM8P36MollRW62mn20024xiUkzeGBbR4xYv0iRAo+GpopccWL+
         bfDBcjDf4zkEJb8bgGz+v+3i4c89SuFKsKyviNyse5Xo/ie3xZaG7qrx94ChjBUy9i4h
         hgjvsPrNfdVmGqqLev1Lwv2XVRpIUe1I8FhAlQ7+jFK3VqY8qMxMlq+1HuLa/VH5JuAy
         OSH3xh7quKx9bDTryxZEGRrWSZmt/aKaDu7InqYj4ZFGV/2EenwBJaxaF6QDEMYoAHDN
         6J6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738720882; x=1739325682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wmqu8Vw96LdkQbtKmW3VNNRd+LI4ohMPpAuQdsSuoh4=;
        b=l6nm4fQdnv/X09c+8P9mZqO9WrAEZOJMhix5F8l0Vz2CJXNKzAPiMR96iuZgi6rZFh
         czBc7lgFwjRujAvLzeIawYURkNvJ5mhu6yEGxPL95Wk/JebblD+TsR/8glGS8aR9JIYU
         GSnr4s1MIN64YPGE1S0VOzOArRhn+FQ1xMF7R0CNglTMv2IHyQzM36SqdN+/jlswQT/s
         z1TlgLFYEXZU/2EahdC0iBkmpCBZZVznRqWeWbp1f6ER2K5lL8dFgHgG4A3XL4r0F1rB
         ZX9vVydLtQBWIfPq/EgMDUUL+xUgoAPwA/Xg6WF4eMIkOrZT+EOJCXoFuYo6NlPMUZRS
         6RZA==
X-Forwarded-Encrypted: i=1; AJvYcCUyNdx8QyEI4DfyEj0Nz9lOA5ju8ETxqPUVpJJRXGyMWo7v/TWaP8BCZYAemIJIWm10UkL/Mw0bf1GLblU=@vger.kernel.org, AJvYcCWA8h0dLzclIwM547yDrn3OJYdO8XyqAQXnv7vc3kYGY02IzYQPv2VSSpKMY68Ec7xQFUnnJmZO@vger.kernel.org, AJvYcCWEz5fi/+jI8GW7pQfzBXuWBrKygRj0VyZhzDyX20L3hwtFgtNEL636RWi6xlSdhoYxPWaXFzO4QfXPew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqHwpdXkuwXY4JI8t8QFkbQPH0al1PoaV52zqIPqmauVK4yvXa
	PIysbqmKD5tNjMVPLjUuajOaLgITre3yYzIl7afJ5osTGvuCy4JP
X-Gm-Gg: ASbGncuDlO1STRIMAWjONfCvexzXyqWafPf7dlRuNXUzKwGBzdmyeZmuKqlJ69gH+hN
	MeojJbCljE5BLavGTxbkLIYi+YnTlw9N4r4jWOVv3Bl/moNsWA6Xi1cZGalN+oPxPn3GJd8flbH
	oJP4C9BYHh9ZWugD8wGyauhk9hQVNrk0pmBnbp3Zk8XINuaPi5ndUiMalt82rD7qfz/J3Pw5I3G
	vrIlMmKAJr5sw2bG1wVs4KGmRp8SAytN9jgCTrO0KMWQ7kcOjU0T3bi/Xl9EgFVBxzECNw43FIf
	/EDczRJfmwKemPjuZhs8GvU8we0EavXXSRDFnw==
X-Google-Smtp-Source: AGHT+IGnUTZeS4eZWKN2g/ocOzz8X2orsJDvN+Raxy+ImAnJx0e8bxu1WAhIylZPFVNIqSYgYc4MNQ==
X-Received: by 2002:a05:620a:4894:b0:7b6:dd82:ac9c with SMTP id af79cd13be357-7c039f980ddmr174659085a.12.1738720882196;
        Tue, 04 Feb 2025 18:01:22 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8bc32bsm705520485a.1.2025.02.04.18.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 18:01:21 -0800 (PST)
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
Subject: [PATCH RESEND v3 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Wed,  5 Feb 2025 02:01:18 +0000
Message-Id: <20250205020119.24007-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
References: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. Remove the check for bdt_info.

v1 -> v2:

1. Replace kzalloc() with kcalloc().
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

