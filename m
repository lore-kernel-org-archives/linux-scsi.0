Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9971825B2F4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929751; cv=none; b=EFmCAoiyesbcTnqMJ9JD6E1PlKcvZ8LPGVeCNX/u/+RczLq2DV/m8HqgEF0zuO6DSPnWQVKjzX0kKhm8ewSf7JIivwrVJ7G3thG0M6K6X87HgP/mPszoYGmTSGvPXh9s7iPuYEXb46E1I4A/RjwubunGA6Jd68YM+UYHEnwf9fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929751; c=relaxed/simple;
	bh=N4Db8elwtoJ3w5qsb2krFN3RSRUE8VFtvGdNcrG4zro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bA7gFFyAHYXeV6TIHtB17AILIyt4aQoUIiBxCzlPGP2+w4stagFp8hoypGcnn2bzprqJDNaGjiZsbVhMyjaBtrMt1g9Jhou0Thqt5JBn7cKoX9h8MOfEjXPnRtU8U/+IWSAAPSovReXsN65V9c7IR0SEQxP+PVIsDk27/5L4KY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hx+RbfRJ; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hx+RbfRJ"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a3400f30so2563411cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929749; x=1771534549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zmUE8kO3Eh5r3psNfiUeJgNrgRhN12plLQdkN7lO6Q=;
        b=hx+RbfRJuTVveYRn6HcZ4kxIwfWIPN0iId0oude009Yh1yV8bIgdpGMreDUuCTWwQN
         grYj6G9hU5WvXActoIvu0YbSCdFFBliZQzOXB0GUUfqCA1j2wV0g/TAeYMqccdu5+OVG
         kFdf1eFIZDho+q8RZaHXuPmho/Y4VcjFVUMRt/JYn8FBeeq0HDIs5ILjoj1mFlxJ+wIp
         ZSlqyr5594w3Zazg/lq/r82KqRk9cQQByyM+ME4U+pPnogsJVQm3V2ijYLU7thi5Qk1J
         4XPJ2aA+imaWedmBC8g1wodqU/AbeZCGPDiqSfzC0SJbOcriFZqDMSpLk3+Nj272Bq58
         t75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929749; x=1771534549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1zmUE8kO3Eh5r3psNfiUeJgNrgRhN12plLQdkN7lO6Q=;
        b=qfF8Ztu5sl6nkcTksXVYCUO1iovR8QDsYM5Glf/I//7bIoq3qwPOl9C3R4Nwh+BIPK
         qBpDsM+YnAuJq3NvOAlOVKheqN8XCp2+4xQxx4xQuU56zG5fV2Ikx+Uzi/x3vcyuAk86
         NNb5/nxup3wUhjmcqH8U1mP2Z7fhHzi3zwh2nZTx6LeS/GBeVH3pgLJATZnAM2+H/onv
         R6IBPtEchVVtMBdqiF27ALa9mUwVZT9XSPp2rzmMIriqVHdk7uhTqT7B7BKaRfHF/c6C
         vT6Rctal1k5jR8XuuqIpVADUcDiDWZKmTxc4hkPI1bVwzDqS6QlmptRFfiK2xzcxkxb5
         m3dg==
X-Gm-Message-State: AOJu0YwQXExFvLPkWsOmbZI6W70cGxV/n/Uf+zZyFXEmSlSuBPrnlo7Q
	ze/ssYdegRw91JtHR0UustIJeWyZXsgvD2fyREo0iTBHH+xEDqbAuyDo
X-Gm-Gg: AZuq6aJOWeNrt1ZUdY/zBCvjpPALaCKZfIZhCsPBkvHVgvXH/ZDQKbxzVIicv+Ynhp+
	INBUXIY51f5xUcmQbkeFkKRe/fM8ZX862i5Y3dZCNq65LPUUsWaYA6ZA/WMAEsFhJ06zBgUVgAw
	i9kBWMtUPFW7MyBdvJPWZ+8YRCDSi/9PdCuJLufr5KCQDqsUE7SMDQhi9eSLwhPz5/+g8I7vxDk
	RTznZEkzAUWoKJVwvNOD7wbubDAwM98dbVbwLraqJjD2tHZ3oPt42DIxJj3kH8BXTDDFNZrIfhW
	VUVyrEGg6heRjtpD94qarffTL21vwDjJbt7IbMSTR78R0+nl2HCgIw/RIMzFNPDo2Zxtnu5pXON
	MutMwyNvgjpU/DPEQ6k5s8kS14TqdtbiDjTIEJ+yyjOfnKCGXNUcOrTrmga7ONFntOIOo453C/L
	lJC2iygIuwAaXrno0EmZEHSzKegB+M9o5z2z6V4M+S
X-Received: by 2002:ac8:5f8a:0:b0:4f1:8412:46e2 with SMTP id d75a77b69052e-506934bb4f3mr55062931cf.29.1770929747654;
        Thu, 12 Feb 2026 12:55:47 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:47 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 13/13] lpfc: Update lpfc version to 14.4.0.14
Date: Thu, 12 Feb 2026 13:30:08 -0800
Message-Id: <20260212213008.149873-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.14

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index a362a7356435..31a0cd9db1c2 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.13"
+#define LPFC_DRIVER_VERSION "14.4.0.14"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

