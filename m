Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AB21D0F54
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412945; cv=none; b=WVufCimXKCvMWL4qbVWiXT8qCrrkXxZa0IQfP4Clo80iCQ4F+70mBbomnvbBMWJa6Ah/BxI4mfC5Tys/d1rUxWiBXpLbHBhZf6/yY8azMu22fV1AdUjrm3aMersHOpba8+CXNYJJpP5dM/MyKJS9QSW2W2/kGaDWyEqa5YEOKgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412945; c=relaxed/simple;
	bh=sDHOZVokJqTX3H9alm0F5QEYjZdWVeAqeXv3kooQBlc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ajvzlAsOClN1Dp2xq4r81liiStEthAXB7XlH0aAT7WKaqMDpzthopIB7ZXU89A6aV4IiVO4C50rxgRts8MzV3ogf6OpWbUN6Bp/K77GzyMlLdE+LnL/MBNQeAXy0UcmDNxiC5GRfN9ELmTlngCK6qFAwT5yp76qITCnvdHPRjx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQ9EmP+g; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQ9EmP+g"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7ea12e0dc7aso983577a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412939; x=1731017739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwrqWF6msfjNLL6uHk0WCDym5XXfkKJniGLuYrucaJI=;
        b=CQ9EmP+gPsBKG1YnZ5jwwPMZe2KO2XWLFVQzC94ghm15QraehLK9TLNwNJ2W2mJvot
         tJes32flOPUixGo0K7chZhUg8F1CCnORWNXdCYUaXq9Y8HG8jBLPSagwhGV71j6M2Olj
         VFhDs71JeddghlFy3yQQZn0TZuM8CYyQRLB9z9OyVT5tg40TISJ48LslvDsPgOseTQ2g
         y5jt5hpUNDTG4EOGSLQUTfxD7Sy4PSAmtNpHlHMzW3It1Bsfk2RMIZyXM/PgbuGoKArO
         rBKv7k+9RKmerPnM0FFeiE/+bswl91hCyYUzcqOuO3HkKYXuqnerO9j+bceXDYssrg+F
         4B0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412939; x=1731017739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwrqWF6msfjNLL6uHk0WCDym5XXfkKJniGLuYrucaJI=;
        b=SYX0Et9QGZU3ASCS1aL7ZNaVRQOjdVXplnYDGxBCZ+ll2gjybdAN3NXzquiF5CEWGB
         9RC2ejp3Saec3SXzgF5WllCSFNtZvN3j5lAmM5VAkv8XjRmfoqKl+A+HODqtn6qNQxrO
         jCREk1kw/p0Hn53rwiYgc8z/U4H7VTTV6ngAEFVKS/qDt++4ZZF4zDEadytCxPbyjGS5
         VBj2d/Qi+J0xos7s+VlujjRB4ENYLXNQL7F4gtSt9AW+rQUl3AsVJObw9u68tt4hThMw
         5LD3VTzu36d/HfPYZFGdtYPRkUMqBhHh+VXsSe+1H9UceaQahn96MIpvBnWzfT+C/L4I
         QZVw==
X-Gm-Message-State: AOJu0YzN4zw/CKrL7ahycSH0izhJar5woP0dXBsPtBc6YAFctXGTGIL7
	1qX8VwJVYbGwrqjHdXBTFEielzgGPbQ0NRaCYrNYrSbrwlqbQ3kyhFeL4A==
X-Google-Smtp-Source: AGHT+IG6ycz0Y3tLOtkd+U2x3uq3xTrxFBqZIidLFxZAZVdhDlx1P1y9FHPjBA1omuFDRGqz6iBJLg==
X-Received: by 2002:a17:90b:1c85:b0:2e2:9e64:c481 with SMTP id 98e67ed59e1d1-2e94c2e2caamr2038409a91.22.1730412939237;
        Thu, 31 Oct 2024 15:15:39 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:38 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/11] lpfc: Update lpfc version to 14.4.0.6
Date: Thu, 31 Oct 2024 15:32:18 -0700
Message-Id: <20241031223219.152342-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.6

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index e70f163fab90..61fe1220f8ad 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.5"
+#define LPFC_DRIVER_VERSION "14.4.0.6"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

