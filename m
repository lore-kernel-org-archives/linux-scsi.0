Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44033DF
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660531; cv=none; b=mq/Wzm+Tr654nqMBGk088ijOfWhQjrs5dFSX1ado5oS30i1HCafO9emYqTkC9CJInY/amAyIyrwRud45I+IKILuxFPngOa/ttdTz2UVVKhZTQeBz5JUg0un9jyyKXGfsgmEQBX/p0ZrbvJDzo8y52T8N2GCaKmQ2LBYBHECewlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660531; c=relaxed/simple;
	bh=PEBRgy3U8le0rU1YUtzuqdU4UbSrGVwJNBwWY9qNTQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BYo9tFy7it61JNQENQWyXgXOCPrEmbPLL9FCqV4/9mj5mET19yJ5ugx95jo/upN2nomb06s699bYuQoB6nNtjSMTveuNrEq2OFAHmwe3lkhEGmhV5oJqmua8c5tFDLhCcGmleFjWnjIUe/ONRnU7kESpB7+vb24jiqtxbI4Cj/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9kORAzv; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9kORAzv"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-42a9c3f31e0so4803541cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660528; x=1707265328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAqUwWvKuTXPsVxKyqp8DHVvLG+80LqrXU5iD5oilK0=;
        b=T9kORAzvQojI0xNXdm31xyy4puIIXjbm0cX5zxWttnA3a0PeSe3DkSA/nm0qP9tF9I
         3qZzZVjR+cxO7X9cAnhVcnpahcrB6JRWNA5Mhc27G53VfceQsRDrpQlnyRgIGt1c8/Kb
         5LgtpJasz1CNDYElXZCrVHtsZsZkKq6FcCgbG3j/2RyOaZddWESC0pPQZ48AuEMlMsXX
         3VMu1mwnW2q3e1IaXi210xVNPI7+bKlI3G0uPazZ/fTqFiAvE1e20Hk/nA/o6KwrJpLH
         V7/b8501Mr2qdTi8Khs3mEd4NEcXrfuKms8mugox3foWsh8+R6/7GJ9HkFY5oBNdE651
         LcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660528; x=1707265328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LAqUwWvKuTXPsVxKyqp8DHVvLG+80LqrXU5iD5oilK0=;
        b=hrAFrpgPVSEpJJF5W/XLo/g0tiKFCOvRZnQO9515jZVn4McBXf2nKoymkKF46tmqGZ
         h/Q16QHljI1DFWY5u1hvGhicDi+NrNcoGrLXm60hAmaWyoop2KCeHjIenm5LtKfdlXxs
         fQe9ElwV46bGR0lmM32foRknbW/p5GjuIABkai/Arq33vz9iENvFaubcA5VELNFD1E+8
         V7czwkLp6aFSe/nKowySK0CNlwecjIi36/oCl0Vq8phR+DxHzNhvD10LV9NyM6m4+L1X
         SCP+woO3bsmwJXuEf5h8nnkqxkERAIKWb0U+YBp6V/zPCR7de6mgWmf0M+h0bVoSJsJJ
         LJVg==
X-Gm-Message-State: AOJu0YxvmVCmaK9nRf97LT0pi8+Vsh35H3YVedBP6lk1guLmFAFiDCtW
	C7TQiYVV7VRRJpVqQFqtqDXpe4r7YpqEUVshAk061dsAmMKU+P4go5pRStka
X-Google-Smtp-Source: AGHT+IH7d3R6otgQJi03rcQvuKAnZbgYDYjP5SXXncC622cCujcphWZu2x1Nmd02UXJWvAeZIilRQA==
X-Received: by 2002:a05:6214:29ef:b0:68c:6ccb:44ec with SMTP id jv15-20020a05621429ef00b0068c6ccb44ecmr155163qvb.3.1706660528474;
        Tue, 30 Jan 2024 16:22:08 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.22.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:22:08 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 16/17] lpfc: Update lpfc version to 14.4.0.0
Date: Tue, 30 Jan 2024 16:35:48 -0800
Message-Id: <20240131003549.147784-17-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.0

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index aba1c1cee8c4..573c9721ea0a 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.17"
+#define LPFC_DRIVER_VERSION "14.4.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

