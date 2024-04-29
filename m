Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DBC18410D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427894; cv=none; b=q/s2qtFY55v3ICUKJf+5U+4nBbozVLJhPZowMSqGReiYdCj6uY4L7dtLXhx6emS1aqLNhiJiXalVPH3APcc4Ki+MlXUlrO87rT3oNr8+3hUD7B9yJWNCB609eUBibQzC6TATXbwQd2amG6VB7tiT22poJzYZ9snhcJl9iDkHuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427894; c=relaxed/simple;
	bh=39NwExyd+gclFPClfGzw1OHttCbrwh877M4VISbCcKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tFQaQS/iswam5n0bMUZTfUyOJj2BhBVNu1R2Ypq7fmEefmxa53MhJkPLDloAL91VmHeMtX/hoSpHkePhoKiXMV2zgC109NtziH4loDeANIqntme67/K7wK9LNfFbQV+kUT5Pkg9XNxw8aHJ64FebIgQxROt2WRCaRII0esr1YPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knDjM43z; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knDjM43z"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69b67bb05c6so885376d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427892; x=1715032692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ho4G9EID4X4d0K+8s+VHMn2DrMao9ZgXfqrtO0B49E=;
        b=knDjM43zqHkVwppR8VBq3GQo1TM+9IK8LT4UQgkr4DZAUMWV848MRGQu+tKn6QyYXP
         f3suHWEl0iwIe33v1diKD6IPurA8MIs06hwYu3vfr6FOIBYBYJ+avQ6f8MamxI8vIjWn
         Cxx0gRmNhz5gbk04sqfz9Zyw7uuwVCS5WjEESvY4GWPz3k3gHmQfawX6/Y9NkN4xT81S
         ue/j6L34xQ67US0A5YWCuES3Pm3Pl35ukw026RxIlIqK6A6dyM/y2eJ6MlwaiUC4+1qC
         VhNk8Vu/UnEyE8JpylbAWnlImCDGAU9tfQNcOLLl6tQk4MiLzv++txuUV2y1PImbwhxn
         okPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427892; x=1715032692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ho4G9EID4X4d0K+8s+VHMn2DrMao9ZgXfqrtO0B49E=;
        b=vYW/ec4/5765JJ/aBs5HyFQFkIA3diUgI5gusGZaWIEvLcV54NZmILyAdD5WvGi/kE
         1GNkEpFUCcrQOfh++gNpO9lYXkhiX18Kcfp/g/XirZxFYku2hwq1TfdwHT/GHBOrb4JK
         WjNImkKuI0NfBimpI8DlLrsBb7Uur0NKS6KacWEhKVcLY2Bhshn3ShRxo7Ybl64buJ6J
         qi75+op38ZuFJTE/GuezTCEDC/Mh/K1LmILAISY/UvbcWUuTMoZ8nCyR0uNPE2Y8i3lI
         86yI8+b8e9Xj6dtsNa14qjKkVp8Vi9tSN4hpbXVhQd+xupPGIxtALZpZJ3otoeLh40IS
         SCmQ==
X-Gm-Message-State: AOJu0Yy/xek+8/kwSjYEfJ3oVPpJHK9lhoiIYrJaOHPkM/TdquJnyXhO
	A0Mb/NNmRxgGpnB0gaU9y4PybGox60Xay1qH0i7+diOIJNWEc5FQr+F56w==
X-Google-Smtp-Source: AGHT+IGJ2FhHGbDROlCdAsCxZcZVJxE5/rfJKulnoAm5EkpXAscXLybxENTihP8fyPif1fygPGnltQ==
X-Received: by 2002:a05:6214:411b:b0:699:dfe:6015 with SMTP id kc27-20020a056214411b00b006990dfe6015mr12766981qvb.5.1714427892420;
        Mon, 29 Apr 2024 14:58:12 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/8] lpfc: Update lpfc version to 14.4.0.2
Date: Mon, 29 Apr 2024 15:15:46 -0700
Message-Id: <20240429221547.6842-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.2

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 915f2f11fb55..f06087e47859 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.1"
+#define LPFC_DRIVER_VERSION "14.4.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

