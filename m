Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BA32F4A1B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272984; cv=none; b=HUbNYgFEJiNF70fab4Z2OpBmBuIMuSDDcDlP+jnsQ+wA1oKxQIJJN6KUJUCn2FLVb4BNUDybjlI/4DbOy9B+mxuC4fI8G8cPBs1Jv0cOA6iT9vMEzRmBPL77piOYKIbnoHJQtCkzZ1F4qMXEEmOx3phcJwXNCXgZTi1jLMYSpUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272984; c=relaxed/simple;
	bh=/lwpENf0lZZn3HSxdOSB1sPiCRSJTrihGFvEnZUqGNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dAKOGwSUxvckzrHuTQVAgIjL+SGWTMTOo2gbmlbStOM9bmxko4WBEhZXebE3rx9RRtRGUn2z4AsW279fQl1DdMltcCy0KHxZEIv5mVmDlvwJOZC+Asweo3q7y8s0Bk6iFEsNLZmsV08ijYdbp5zSGKRKr95wb+Iv5oM3B8OzO1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEUwnJZV; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEUwnJZV"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b31cd61b2a9so19820a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272983; x=1750877783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FFBkcUumdQn84qWHCiunsr4YAO8uWs92poa32xh1KA=;
        b=JEUwnJZVIkq41lnIHHP2OegHlITplCB+Kz0j4pfcjPZ86JjbCwXwMecMibUExeCDhr
         x/1WGk4bGgi7Lg6uXzpYB22yL6siSJyED1ZRq2tb2GEqscl9yj2RG5De0s+hAnx8CBOo
         EB9HkbjPn+4wDPHo74+G6cn0DUiXeRF17C3m7FZT1YwNMsZX7t7CeJqwcEk3ZOT6tt8L
         JJ1/qVtHagYxg5uphLmec8mKlhpaVnrFRvsRUZCHTAiEWJfU1vIuxWAovBo2R+RugBlx
         njPYliJogaaQS+zfFCKRY2RihUBHKuu1bwfsgg9ecALAuxU3XvW3tIEdACf/IKXONa/N
         vO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272983; x=1750877783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4FFBkcUumdQn84qWHCiunsr4YAO8uWs92poa32xh1KA=;
        b=Bi6EHPS+qJnLl7XmVNZ3DRgpoLf/33WUJ9nQmNS5SVYmIV9h5mQR0kkDctoDr+eALI
         FPkvQmjarQx+pLN2fHOKR/bCvOUww86QCFVUJYVENEbbTvM+2Zyzv22rE0YlFwi28lK6
         qLRuBi567CyZV/1SXpj7rgo7CRCce40xmbT4cpfIA1pebvk3nrxYYkaclmUR8rlnEFG2
         FsihIXHls7ckkMwElBrhn2hA3JMQdZg9S0iDJFz+LRN6rS5qzHbZ5DcBidXNBvQqQi82
         +qSEtcNOZZFbNkNuxiFXZjv0BRYvY/zxXcAWSP32zl9zSuuCfCfw7ExVCeR9tMkDlkLw
         DJbg==
X-Gm-Message-State: AOJu0YzPTPLCKNw0N+Oz7tkQ+zzQd9OBFVZdAGfKIIt7ZASniA6sItii
	mHuXMoPv4SYMDVB7RflY0r/Ijr0ceCbBhj6XsXLTBcVniZEz4INM1jIgoS+trQ==
X-Gm-Gg: ASbGncu/rN3wqx7XSvYWYFZxtdj0N9Iz6mDh2VohxWDTMSMtWhaS/H1bPSg0Gnu9f1R
	cOWDt63vyNH0nEmnlFx5okWVv2NGuBORFxq4ZZGhLPuxohl37PeWnMgA+gHRO6lBlBa2uCHECIS
	4UHjwoqKqvWCHb9R1Is2xliH1D8kk63Ow22iqEsAwYXoye3gGWIdY19bl4hShbtZ9N1DF0tKp9T
	41YaYBQdKghPVPMJgcPgLo68T4TjqMbxUxNJbgxSouNlyT/YW2mJTZLfR9/eLQTH9iWKczDPC8R
	s1CNhAc2DDR7ybJvUi+ys8xpIVA733531qnf5Xn//dAqlSqBP/Fb5LW3tVFVnzi6DI8idEWBF4e
	nI19+GxRStAK75ibZXVPo3e5nnASi3yaXVsqxJIQ67/ncnDM=
X-Google-Smtp-Source: AGHT+IFV8d0ZerJScyzMpJ/HSOsG01Vpnmm02UKnVoHZ+WElFzEbUSjpLg90TXBQDmMPQMYYzIAuAw==
X-Received: by 2002:a05:6a21:790:b0:20a:bde0:beb9 with SMTP id adf61e73a8af0-21fbd494fccmr27918566637.1.1750272982777;
        Wed, 18 Jun 2025 11:56:22 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:22 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/13] lpfc: Update lpfc version to 14.4.0.10
Date: Wed, 18 Jun 2025 12:21:37 -0700
Message-Id: <20250618192138.124116-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.10

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 749688aa8a82..9ee3a3a4ec4d 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.9"
+#define LPFC_DRIVER_VERSION "14.4.0.10"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

