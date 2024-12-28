Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE56F19F41A;
	Sat, 28 Dec 2024 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735411821; cv=none; b=Y1L5wjNvX1OZTBKbSp/LeL2Qmi+300KGMsmNfAVZNrAlPozzW1Mq//axdkgpiLvshYvkvq8hvmilX+BcziX34ObITB+oM4jN0voplIfEWIRzpKe5tWO7SN4dH1aFcdmmieHIv2E7kPWccsU0hnKMb6jmzDE9vnHmgLPd+KycbM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735411821; c=relaxed/simple;
	bh=CCJtLFBCs6CKtlN21Jf8J9218bTM+KX7G7To006Rf3o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDE61zVLKhBIkLym52JgrsB4K/2LKOc3v0wRUtdo4m/FlfIdfpwfzYbOl9jiO0N1VDoXvp1ZjI8MOMa3gkUOfKg/SuOgSF8Xqcrtzit5DZAdNH/pITU6edGTpWrE3RyLCDjL3KOsbuMi4sEntfxQJeZEAw5g4lU103rrCFFuo/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nIGenw5z; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nIGenw5z"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e53ef7462b6so4633666276.3;
        Sat, 28 Dec 2024 10:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735411819; x=1736016619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QHPIZAncAii6tgbh0wNxh85yAc7Gn1z/+3/HM+ibJUk=;
        b=nIGenw5zaGkJmAryzB3kQXm8+qNZZorrCRzWZyV5LH+/Uuh0ZTSp+f/V2rStzQ1yaZ
         fbv3ugUSlSPVgz0Hga5GYWf/bQFPdNw4O2u4XJIqC/Bdo1ln8dFrW8UnQeRZma5F1OB9
         1OMfFn9LEvF8GuYy1CTCvsv+nLcc/TwFZZ0jzEIN1NABgwPVedujH1kFslAqenyQFKhH
         y6LHeKtCXTDU/dIL0V8zQYAGh3c5akZiNsYm+WC7DoAcnnriZeXanD7JiunhQ+K1FvWJ
         aqrTuCFldlBg+2zO4Br7clxLznEo4g0zJGvY7wDZB3+pdTEJiPJWpEdgwMUI06VUaaV3
         ADSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735411819; x=1736016619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QHPIZAncAii6tgbh0wNxh85yAc7Gn1z/+3/HM+ibJUk=;
        b=hZkR/zxBo0Z1JDWOFA45nsmmxtM7b33Z3QP2LrE2uhfN4fc4OnxCCrjEQtHSCq43Eb
         o2va0eOBMmNUhljLrBvjSZ26o4+R/bvAZTR1SyIjDr43HR7hGhK35DWZY7GErNe8S4EH
         cqAkMeFROv/vuPS7F3qndym9LG7JGCiKXtUYNzyXYiVZkQ4/8fiuA8pZzDljsMZaeFs/
         Od0wKf51/xTARzIHIM1FzNG9poRzWefA5IIIZFnQdqkX/ZwSUFwIT5XYQB/8iE/MQzeO
         vkHQj730HsxmhFKg7jTbEc3VHZsDRZx+AfavIOeh9Vq610oSSrD61969NGi48BxqaeB0
         A3Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUvaFUZIyy4W6Pe0z4w0WKKYzxFcqOjP2kxkOcoJWmJOkKV/Be2//G/WMsWVUyEADJxy+bhc9mae7leuvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyvEOi0OLwznRx9FHQ1f/JPw/hfg5vDY6qDijLtqX0/j1boDm9
	XYvCVRH1Xi6kNHfwnRyFgVcXeS9aD2hQrCnEVscXW2XIM8/Vrg1gf9ZxxzkX
X-Gm-Gg: ASbGncs4C4fY3EPb/bfpvJE04Wlrr9lcSmyL/lZQQPKXjZBIyAhxpDkEjGooWa3JrJg
	qNi8/3WZlZVoF2GiVEE3HtgEAwQ5y9CWimjLbeC9hY+v6SY9aVjEneMZzuBpFEWYUl8Scv0fhUO
	jtEMkxFuLcgRlXmlNagFsgitkRToyMGooxojTxsbyU/ZNi/Lih71wBpOw+rMCGr5XnWjY75fVL7
	ZPDFqBQiwnXi6Odvf7sB/FGAQhYxlNMuwrmfKcyRS1elgvUN6OeUrsCSaOiAaAP/q6aXjwRY9HO
	IKsPKK6vNpS8Wq9K
X-Google-Smtp-Source: AGHT+IHcVmQ8u7XvWW06STVtFjh0Z/K0WoYV9ZsBMGJX581Zr3/nYzYWbMrabkokE7DvE5bpKUWkOw==
X-Received: by 2002:a25:21d7:0:b0:e3a:3c1a:3bef with SMTP id 3f1490d57ef6-e538c3a0018mr17151525276.36.1735411818952;
        Sat, 28 Dec 2024 10:50:18 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e537cf46c0dsm5057066276.43.2024.12.28.10.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 10:50:18 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 12/14] scsi: lpfc: rework lpfc_next_{online,present}_cpu()
Date: Sat, 28 Dec 2024 10:49:44 -0800
Message-ID: <20241228184949.31582-13-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241228184949.31582-1-yury.norov@gmail.com>
References: <20241228184949.31582-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lpfc_next_online_cpu() opencodes cpumask_next_and_wrap() by using
a for-loop. Use it and make the lpfc_next_online_cpu() a plain
one-liner.

While there, rework lpfc_next_present_cpu() similarly. Notice that
cpumask_next() followed by cpumask_first() in the worst case of an
empty mask may traverse the mask twice. Cpumask_next_wrap() takes
care of that correctly.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h | 23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e5a9c5a323f8..62438e84e52a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1715,18 +1715,12 @@ lpfc_phba_elsring(struct lpfc_hba *phba)
  * Note: If no valid cpu found, then nr_cpu_ids is returned.
  *
  **/
-static inline unsigned int
+static __always_inline unsigned int
 lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
 {
-	unsigned int cpu_it;
-
-	for_each_cpu_wrap(cpu_it, mask, start) {
-		if (cpu_online(cpu_it))
-			break;
-	}
-
-	return cpu_it;
+	return cpumask_next_and_wrap(start, mask, cpu_online_mask);
 }
+
 /**
  * lpfc_next_present_cpu - Finds next present CPU after n
  * @n: the cpu prior to search
@@ -1734,16 +1728,9 @@ lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
  * Note: If no next present cpu, then fallback to first present cpu.
  *
  **/
-static inline unsigned int lpfc_next_present_cpu(int n)
+static __always_inline unsigned int lpfc_next_present_cpu(int n)
 {
-	unsigned int cpu;
-
-	cpu = cpumask_next(n, cpu_present_mask);
-
-	if (cpu >= nr_cpu_ids)
-		cpu = cpumask_first(cpu_present_mask);
-
-	return cpu;
+	return cpumask_next_wrap(n, cpu_present_mask);
 }
 
 /**
-- 
2.43.0

