Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC72F1AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045284; cv=none; b=Zzjne/aWKE5ZpXnxG0BQ3RLSJLua/gtCK4pViyl7Ad9CFRIGFpxCHWysWtHFzya0LIOmE1B5rsizK8UWXdjDtbDGXTtKGY1q3KUD9cqipbxBEp6Q/yxQX0Q0yLaUk967HHjHlHUY3COA7XuovyYLIe+VUxkfsOUOCkBPENPiIkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045284; c=relaxed/simple;
	bh=4k92MtZjJmZ2mrX2PydRLJJHpMkHuox7DW00Mq2dAoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QxHnzQDcoSO8qrd7vnXhHTzptF08CPsnDbbBALGlNQaEL4ZzPQU6XsjIVnJEYxv+GwxcdGY90/WB51yRnZvS55JsWMzmr3+EUAxe8qr2r2rQar+aBIUTRvkXzIJPxM87hP2hyUY9e5g4mojGA0/Eb6+TvJvi8LLjlVrKa3QI5i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlvtoyHG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlvtoyHG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21654fdd5daso10429995ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045282; x=1734650082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Xoh0fInBWbhi/eDwU8jUtcyY7mrX8SIdhTjfoMZaeg=;
        b=MlvtoyHGaLl/byY+1BHpaCRjKBty+EN9FCoL6HBwU5Ps0rSpDGlNNS+UuIoop1/Mvy
         3yEONzHeIA5sUy3z3TbdeR+A3gzg6f526qAQqr4aHRunv/GiH6hY90u/zgmaK+WDovCf
         bhInReM7zpQp/tK1jtKZg1e63KqXGAyqB2zffWdA/xOiA63QVgdY1eE+ylfW5y2xSrPW
         ZgsYlpafm4j/3/Ed+qUm+U5On5UucYb9snny4mgS1enzFvHox9dCpXvVokcLnEhr6jAV
         ci8aCf0ql3I8R4DgWwERoe/68VNzWvwMIRTMVKCJ9rH8ZlFnwsof06i8uhFTcDRvtPol
         T48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045282; x=1734650082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Xoh0fInBWbhi/eDwU8jUtcyY7mrX8SIdhTjfoMZaeg=;
        b=NNZgqiDgKLdhu2/LerFr2+16nK1qNWwgU5YSJjs6ETX04yrQDoJjtNuyWyvV5cVcDA
         LFa/4UiJtRZwyC/dabcqQsO3beP24/Ut4n+2uxG0Ac7O+tmxW/qcmOtqyqTuaph3InNj
         fdsGayQes/uej3FqK6GlIlKjpnq7m37aE63nt3UFh0736f3cPl2rOBWiuyo1uCgCBTIR
         RCHbNs1YEPon5fLhtP+PJDcTR8lWQSstGKM+ptAkhVu1AaKFGsvRU+Dqkke4niHmlMNO
         mbZ9w1k+pXFEVgVtfUp1R3vUrHmultBvqkOaWOcfxxw1C+Bf9XUgOtUUMN1bz95eXPBk
         eNBA==
X-Gm-Message-State: AOJu0YwhFnc9r1JLSLav/K8hrG1SZ3C0Gf88fcnb+E7ZgnNpnsyZr+AD
	zSiEE3RIkNu0CIkD/dz/DiGo0PfPGxTN4b+v3ZqVfHwBFUgMI7E2DH9P4Q==
X-Gm-Gg: ASbGncu1iAWifdKCbXiB9qKTo7q3P74uVXQR2J1P5VbtUwf1QSgIEZecNpu+sw+HwuX
	8oX87i+Sjx6bosXK1CZJSsrYZCrFez8zv2Rpa9EE4GVm0noCIxYtqd/10CASnY8k2+WpjteqA1i
	euze6PM4eZEKyqmBMXatZ5+m17Gpf8t/T4XMZPKu6n+d7CMLoSFfzUSP++hlA3BW37JiMwYx2fC
	LzZ2t9HHkmbdiri7CPAtTMaDz9+dJ2SrGmjVQAZmwU5ul3o3+WJAZzt0Uzhkur2ZkxSr8FwFRtK
	dujEtqJcpDi9iW8NpWOc6EVKq+hFce+def2+71ns8A==
X-Google-Smtp-Source: AGHT+IFuS0xiZ4DjdZw6SgzUgE4ni6TlQ8HJLOJzusQmkZejsDQNcjmh4xYj1t7GALrNt2r4DL9iPw==
X-Received: by 2002:a17:902:d508:b0:216:6f1a:1c81 with SMTP id d9443c01a7336-21892992997mr6951755ad.2.1734045281880;
        Thu, 12 Dec 2024 15:14:41 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:41 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/10] lpfc: Redefine incorrect type in lpfc_create_device_data
Date: Thu, 12 Dec 2024 15:33:00 -0800
Message-Id: <20241212233309.71356-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix smatch warning by redefining local variable memory_flags from int to
gfp_t.

lpfc_scsi.c: warning: incorrect type in argument 2 (different base types)
lpfc_scsi.c:    expected restricted gfp_t [usertype] gfp_mask
lpfc_scsi.c:    got int memory_flags

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b83627108eca..c57f11f6fc84 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6423,7 +6423,7 @@ lpfc_create_device_data(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 {
 
 	struct lpfc_device_data *lun_info;
-	int memory_flags;
+	gfp_t memory_flags;
 
 	if (unlikely(!phba) || !vport_wwpn || !target_wwpn  ||
 	    !(phba->cfg_fof))
-- 
2.38.0

