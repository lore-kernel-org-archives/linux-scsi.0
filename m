Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EAC338939
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817101; cv=none; b=UIsrXwZ2pun6F1JNz9HnFsEv56K4vVaRObPsz0S55WIhuqyu4AMujTHskxj58rlPy4tu/zHLq0DZVSHxOrxzknvjIlDUqjFnzJwrjXVvpY9Q4ISaNq4gIAddYEa/Lyotf+50CUa8gx/UX7NCsO6N+AzcBlsUj1U7GSLS4sGsUlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817101; c=relaxed/simple;
	bh=zsGfW0U9ndviMNB6bn5eedJivSA4tWqNT+0ROyjm1vs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k5G0BdoowdyMERepgJDXfWkDqUSFqvNbDI//g1KjXVMcLa9EQoRRBtmPNo7RTBsKF9nNZTORF87QscuzcWUZA59a3I7v50N0tQKX+k7vV2Gy5ljPqac+LuKP6DNTFNXa+4pV+AUhCnQ0PRf1rFl5n7dhAIFRIs9XVAIK6MpX4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cz5BjAS7; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cz5BjAS7"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3f0c93ecf42so772279fac.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 12:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767817096; x=1768421896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fQD4tqd+tzxOcNj4b+9n3FxkungouOe1P1ZBL2GQRoU=;
        b=cz5BjAS7gi+IVA6tBG+Ut8DZ1Fk4NZI/NbNp4kLwQ4BL3cxBJGwBjmDOd6xK7wrVBV
         KyENovd5lI5xKn6oDHlrmqrEgZ571eZ+df3AfR2CudbB/4z6JUJr50oFrQdrG65ey1n0
         PFatDqOyarDjGyncI7Z3CN8QyrsJKFrbrqT8sWhZOuZ+TiDxLLqVSw77QItpGyECbXiK
         PFP5yfpppFSZDS7wd1mvnTzUHzqJlvI+or9MdhCKOKg8IErfg/Qx+6ntT+mn7588979q
         CGwnsMjI/jgcKfykYEhHO/FS0mhS61ZvkVcc0TYwg+4LNm0sJToWk79Hm0M26N908crU
         D+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817096; x=1768421896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQD4tqd+tzxOcNj4b+9n3FxkungouOe1P1ZBL2GQRoU=;
        b=Fh5Enf+15EhhnA8bAJHq3BxqSm2IG7qGnIg0g6nscLopNb/obkbT1Na8QgTQJ0qRIU
         YN6YcUQ7YFP5HKelKfLWSD7IKAlh1Xn7p+ijss0Uk8K43f6qIPQcxcIYAciEeubtdMnU
         +wX7ZPyr7uhObCE1Ad7V9TTugcroBCnCfIMFZtC+itDx+rP+3XQbQECuUmfBrynHN834
         pLLEwnKwX5HA1gBrN2w6DpsZDKms9Q1EaE5pPEyJSEIIetXfPfieVQRLje0IdqH+1APQ
         /u/TcAzPC5mihaIdgFJUN+OCfdeQj1ETk8O+1UZGwJfdJ2hX2JqMAC3XSskGZ7WLojup
         cabg==
X-Gm-Message-State: AOJu0YwZWILoFibVyTcrHFbqJYerApww2YsLNKGgcTQop1SmDehAr1VP
	4IEXA0vi28JM6iZi8KVvoVBMnarioNMDsVICbKSoyJUTUe9srPbmjWwV
X-Gm-Gg: AY/fxX59QD7ea2VNWdBLxA3/Ca+AQ0PsULpSDFY/abT+P/Qgg0S9uaFhFdgLM5xKE7L
	DFJZpqvGq6+Q0I6qOEdeGYCWwnwycaN/0wYv9H/NYli5nYXv5O5hLEb+Wig3/Mm+/ewGE29lxMz
	7kXoc6lAoli3CpvoVPJhGzQzoEp2ovxf5Q70+vJn2Tk1n9njYI+CY8qw7UjpGLQOy4jDoT8lgYr
	DzW4yLvYTRTnpSBc8gm0s6u/2QgsBprQr8JYECa+qqzYVurOEa5tj1j8DkE7GA+Z1seaW4IL/jP
	VHbwkHA6LyGP7e3nVKBFJt/hVF0MnM7OxQ44wxRcinM/sBoORHnTHBrQTlEUtPtcdd+7aDDTIum
	XFr66QhL6AFQ6UjpAp2GmM2c5CDN2Pt6/+xOKI2aIjkRzgrI9GBr7FyHl/oOrVcvtzEmFsS2lhn
	zp8PtDGuszwUZnxQNd6FxcLTFU0pyPoPUd
X-Google-Smtp-Source: AGHT+IFJZgyAXysQDNl4TXnrVOoRQ4ytxvqFUusezErvxkbzlqvbBHmkxAdmRqPPnvnRq5aVrJpjoA==
X-Received: by 2002:a05:6870:4190:b0:3e8:9b72:5cda with SMTP id 586e51a60fabf-3ffa22c382fmr4175551fac.11.1767817096200;
        Wed, 07 Jan 2026 12:18:16 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3e844sm3764622fac.9.2026.01.07.12.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 12:18:15 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qla2xxx: add boundary check for RDP PUREX item size
Date: Wed,  7 Jan 2026 20:18:13 +0000
Message-Id: <20260107201813.31687-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In qla24xx_process_purex_rdp, the function casts item->iocb to
struct purex_entry_24xx without verifying if the actual data size
(item->size) is sufficient. This can lead to an out-of-bounds read
when accessing members of the purex structure or during buffer dumps.

This patch adds a check to ensure item->size is at least the size of
struct purex_entry_24xx before processing. This aligns the function's
defensive logic with qla27xx_process_purex_fpin.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 16a44c0917e1..7e2ea880ac37 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6075,6 +6075,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	uint rsp_payload_length = sizeof(*rsp_payload);
 	int rval;
 
+	if (item->size < sizeof(*purex))
+		return;
+
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
 	    "%s: Enter\n", __func__);
 
-- 
2.25.1

