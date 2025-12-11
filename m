Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFED2EBB9E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 23:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410306; cv=none; b=uAQn7JJxXTOhBjobGTyMey5HjWcikl/YM+13h4LCQpcNbp8scUjq1yZCD2+8AMknUiEC0RMKvKiRR5fApah1twLriMSUJsEvdWQiDBWgxnEhb91Mgh5OAZMCT4n8pbcW6bsh2WMgCQ2yi2MCqRpiCn6DHsvtjhZG0VGkvPt6AMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410306; c=relaxed/simple;
	bh=xFjM+8Q0XQa6QtLvHUwhwX+Sn1xxUik/0TDFIxp8u6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jDRuex+PL7EX0C4kW1CqaX9bqX9gVBWva4oqYYGsEN4W/o/riYia9KXuZ2osOWHfSTCyfuuCvfPy74Cy3onSSWkW+QwXKyXWvEjRY8ZjEASDSXeeXDi0vWea9P92eEBBu/b20tutaupkapTXvoxsPq4sOQKkw+UxoHN8wkgpHs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XsIhyPyO; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XsIhyPyO"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b28f983333so44737085a.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765410303; x=1766015103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=753sifIrf+DmAUG87avOFlYTBd2EGZqeNt0rsx+hhBA=;
        b=XsIhyPyOYZSaJkPcKGaZ9FSsRIEJ9IQQPf6vhV7Ir/wEtPato05mJVUmJEBOA6J09p
         xIdrDQrrdw5tvum6Sjz02TTQ6fxX7/avSvO3eLzTvIDNvBiejGGXZqyNWBt58GLBI3Aq
         OLOQ50qpXYR7GK6NhtXOgioDeRqrr8lZbtsI6hp/t0NWPoOxP+RYgy6rfzw/NOJSRJfJ
         140C7GMUeIXBSRgOrIPiwLc8xSq71SVTmqvYO3N3lSZRQ37cB+cJh2NgkDgF0GxW9K/v
         IiHYaqYBmzOtwGlfAZsMrjX0DmXixAG31ZfU7UGIyqm/5g3doLII1AFC3jt6YgQaecw7
         d+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765410303; x=1766015103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=753sifIrf+DmAUG87avOFlYTBd2EGZqeNt0rsx+hhBA=;
        b=waIIn6nrhGFMOQoUuGcNDliVR29I+K6kueUFcv+95lkHi6I6bm+g7cTbQQCh/GkOV8
         248/qz71rB+RtB6wzRYCn5de9rEj/0/1V0wfX98go8R1VptxNjtnFUhdi1AcND/D715R
         E8l77/VfhTzao2jltpNeYjOsOKrCn76ialCPvATHIRt8bvEScJ0HRdGv+1sPWYOktRSB
         QJ2pRACYd277YS6pQg7KYyORoW21/0pacx2gYU9gSIaFlN71lzeyXRbU9bjK/G002M44
         5BvjpCIZujsYP/pTHRKd3qCiJeMD32v7x8USh+iDh4ZumUwNophPSTW2WtGGyqez6DBZ
         Jr+g==
X-Gm-Message-State: AOJu0YwgF3AHu1Jev6qygy9+A2MiACrf1LM6dd3ytZHkbmDBzMmxDAo2
	Fco0vPt661JpJ9yQjHgY1JtIDzrdUprHx0xdJDS+y/ZTKJ2xh8Q0AO2FR3D08CK6
X-Gm-Gg: ASbGncsS4KuSqG99jMZlhCdynS2dhKwH68JqxdZ1/veCNmOUPUhlyz5FLvn1J5YQdy3
	K5Stzt2oI891alncs6NIbaDQjHnlZKLtXY6b4kWJ9pfen4hg6tqheqvDqSmKBak29AAILsZ2sKb
	51YzJONeCzJAOdR86brteGZzSIKEPO8Lnu7kHnENWHS0qEpR4uKvHqmC28peJpHEy/WJjJtEm5i
	Biu5PjxJnQ9Wvhdn5N/k21TgaYNuJyd3eJw3PqEhRNMfDvQnNl/LSuOKDAq2kHMjd84OLdFAz/M
	41NkK74Q1YYJu/2f9edNsp8EVHK8OcFRWzs8x7b+cgmE/2C0xh8jYhScF2Et5gliqLy67R2Wzw9
	mMfKA4KsNgKym29wWt4+IRXpC+lgwOq54KSqfMW/PpbPM4NmgCOcXkpd/+vOaPUcB++c1HIVo/y
	dQErmhydXYmqXuFLrpXXEfbnItewXEAmJCLrcUMiGnSqYt2gvfopPxAhOZi1QiwvOarYScF2U=
X-Google-Smtp-Source: AGHT+IEg7g+evyAfOU5rrGsZHOUp7ryA3F6PlYfmaWJxGegLRB0Uy8Fhf16Vc/VnBuDlVz3YCsNAMA==
X-Received: by 2002:a05:622a:2443:b0:4ed:8264:91ba with SMTP id d75a77b69052e-4f1b1aaee25mr55939511cf.58.1765410302875;
        Wed, 10 Dec 2025 15:45:02 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f1bd6b502asm5869051cf.16.2025.12.10.15.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2025 15:45:02 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/3] lpfc: Update lpfc version to 14.4.0.13
Date: Wed, 10 Dec 2025 16:16:59 -0800
Message-Id: <20251211001659.138635-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251211001659.138635-1-justintee8345@gmail.com>
References: <20251211001659.138635-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.13

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index f3dada5bf7c1..c4ca8bf5843a 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.12"
+#define LPFC_DRIVER_VERSION "14.4.0.13"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

