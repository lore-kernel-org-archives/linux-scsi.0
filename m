Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131F85C607
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668178; cv=none; b=nTNZ7mgYEZ1kboBzJQTNARM3MzSZxhpBJ+dwTzq72y958MMlrLsTz0GAhsGkYyckXL7DXyWEIPgasrNPIJ9SzIV84s5uJq5wLc5voK4YOE5TCzjtl/nNrYag3fgJdbL1pesLbL/iQSiuQ/4RFrA63Dxx3nyS3vIrofymSTCDGHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668178; c=relaxed/simple;
	bh=ATqU87LS5ezLdeXcWTeyKyLuBGCxRxxH115EhPc5+wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lTpePEJNGMwIMltA05XXvR5vXo9Gs0KWwjNImkAtRmkD3uLL2XBlXrgqooO7eqXG35Jes1LL6V1sw859laqpPDJd0C756J3XH/ZSc7ym8OuNQM1nTTNrA2ja9FWTVvhk3+bu+lPt84ifEhtx67Y8bhKHnwUdBe745AVXcnq6iF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WUp0OiaO; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUp0OiaO"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-42e4b89bd3cso10082461cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668176; x=1710272976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVHTt6NBiMTnG3shM3xG2Nf64zdGcTjMP0Ts5mx9Cgg=;
        b=WUp0OiaOGbHYL6mvJ2Ml+k+mHZrxredveJ4VjCGvnTFnj6B5pSrYzg5WE63ki+a/2l
         psDJf7y+hVPHFAz5csDb74v3xR0m/Etv6VXOBwGo955o2IWw7dYw9MNyGbxgPkKilhs/
         2oTIAwLpflc4SlYXv/yBj6CJDX/jmZ3ijxKcU9GhSP/YM8sffQkSrl0g9J1105FXVniv
         ncyQF959KNWh0hB9BXW1TdkJM4K75gg55ZfWipnsYZVS4jTBl6ratE+dDF05W4xb4URY
         tquzl/PDnZ0jlVno0y4BF1828B1RtGPFNUU4ON1TNwJZjjZQQENHmVAZrmSnU+Doh70w
         4yCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668176; x=1710272976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVHTt6NBiMTnG3shM3xG2Nf64zdGcTjMP0Ts5mx9Cgg=;
        b=V1zsijVH1DWFp/33nEOHO65wCbsuov8GlzwDdyf6S79ype+CUVDMt1SEP4cMlB7NiX
         FxZ4TqrRk2ydWyQCXPhwGExar3Z3P9VZlV0T8GygvZF40Mx6J8rA0sjK6iVrNM3gEfvv
         SDVn87Wgjr5DJS8UM226OQuWH6F1l0ROXY5Ksvyl7bT1aXxGt5VQ+r5PBIyLuMDuItnn
         SdJ+zdoiRzFFmOM8ZVu/wUXwzjs8b+wCuGnc3I1TYr6GYxrIk5PYUiv7SL+wZN115Jll
         M/WZ0ZK6PbLejtVmSnOnXj6aUL1+W83QktmukVSp9vpHGHoRvx2rEztrearpzJ5x/G9c
         Zuyw==
X-Gm-Message-State: AOJu0Ywrxwj7VL8Ovj+744awg9QmVf//JZBnzxL3+X2HflDKJ1NxL8v7
	+oa+LxKYunUvV1B9fG4GMBC5drelj7hcisvXOWx/pY6lP7H5xLdbrPAXZudZ
X-Google-Smtp-Source: AGHT+IGaUOxMIluvb4IeQ1iyk4SDyFA4r/TovscU19o4EPSY5lX+qCUYQPX/hjxsWthBmOAvpMLQpg==
X-Received: by 2002:a05:620a:4587:b0:788:31b8:a750 with SMTP id bp7-20020a05620a458700b0078831b8a750mr1417952qkb.1.1709668175995;
        Tue, 05 Mar 2024 11:49:35 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:35 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/12] lpfc: Update lpfc version to 14.4.0.1
Date: Tue,  5 Mar 2024 12:05:02 -0800
Message-Id: <20240305200503.57317-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.1

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 56f5889dbaf9..915f2f11fb55 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.0"
+#define LPFC_DRIVER_VERSION "14.4.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

