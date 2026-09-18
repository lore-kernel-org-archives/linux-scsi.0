Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308764766B2
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754534; cv=none; b=gME/ZiqgqRnRQjssiWzp63ejo3ir1PZvQQTxmnBVw8LyBQmz6dw8l0nWmyejsqMAr1fhDkxa860XQhlEo5lFqi6htTtm7LTqe1EK8Nm5yycoft1J15fx7AqeDvQ2CDL++x14eZP9NENbAGkx7b7QPvBpoEd6tQg10mBIr+sZ9AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754534; c=relaxed/simple;
	bh=2ywI+x99AL1vVsJgsYse4XwvQoMzKOlrEMnWJuVwfm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VreesS9Su/OOVBnbPJBJeW6heQiWR4r5iNdNrJXV15h5MNS6DVsMXEvJbJBdoL26VVI3rEuM3AMhAgbOj92Hyu5UCLTNLnC4s32j1DCmIf/puM5gvN/0HRXnvPxhSmWYFqkyRliX9HIDGxo0nmoyVXhQM2JqeppW4KyQTc05+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HUKg6Iwt; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUKg6Iwt"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4c3304784so888707a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754532; x=1790359332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p0aRkG/STOJZPyiXgGevwP+glg/s3VjB+O2AFDUKik0=;
        b=HUKg6Iwt7Fmv7nhI+bv25a+k4qi85ouKgXDnISeXtE+6Og4GAP2AXh8eHA2Ic60ZGt
         QtJy4qOFWLGidVISaIxKO1eaMYAwKsXnzaYnHLeAvGfgzyvcJv98kYlFbwC9Y80U5Jen
         oMNJutI/qa7D5Lzvcb98Q2kc4cM0ZFsXdqv7apuu/uGXb++gWI4VWOIzQhOxU29/q2Vl
         qLKraGVGEgCHGKBCG2PFe8kjq2L+Lm8fZmUOsmsvkTZdiym0H0YnLNvresFiDv8znbMg
         okEUWyor52lduVfzpd+01c1BHDVY7xgcm+zkFuUiIgB7mD6I7G6W8oGLjWNy6boyhjfe
         f7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754532; x=1790359332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p0aRkG/STOJZPyiXgGevwP+glg/s3VjB+O2AFDUKik0=;
        b=rPtIFcony7uCbfVcaShB0jajN9Jnsa/3xkf6r536tX8zIPZ0RqyFgMHIVP3h0jXyet
         Y9CCkVa6DtsRQvCbgiBJCW8a5BjLCdYmaMo9fKh+l+6f+REQ1hdmLcvULBc9ziojl7cl
         MNzHYsZqZFAuTD7bG9MPiYvaw4AamwlVO0JUGSggRCqgcxtTBo6Y+u60NjsnpH8eGXpE
         17W1FZm+a9LOSgwHkX5lxfCxjHChdZGb3t9ZSRF/uZFyJsL2uSVuALmB8duBdHr3aGIG
         8uUHphQIQWazFNsiWNllW9Xr91n1U10Pi5O/XpoFMRJBecFgb1zXdIrhpeRIWm+Z2Jgm
         kT4g==
X-Forwarded-Encrypted: i=1; AKwUvBzm28NjUAIGT/+0pqFNX2y5fL2V7prJPep3I+ezO9fSZZCBzOK8KJ6sMLdWIHYaCRyi0HvOHApO95LT@vger.kernel.org
X-Gm-Message-State: AFuF++lkMX4I9hg79u5eOj70XtWYa1WWvM+4Ul4WieLRr9ShJj4vGo6I
	gE4mJQXMr0iWopXlalNiTcw3bNTjGS7YPXb6N4rRq6dit4gfz8LB4C7+3ez5ISBj
X-Gm-Gg: AYBFou1fCPeURyF8blFErZnr+JDInzpdgQtkAgITLGC781ihO3sYOvhVNEZWKcBwfSF
	Mvq+uap6lF6x40hLMzSw5dX2LYj7NND9DhPHZBJ4selngFC27R51JH2jrtkhdchOjo/Rx9PzJXI
	a8Yn6T8QZYi+S7DTcIhsR+e3sfIJybiLHjFtFjyYMU4PYkypBeVa5l12KkATEjEDM7DD6ftsiGE
	cbDLLVLG4VXXe5qKy32Xvm8hFgnN1BQ4oOiio4dKP+Nzdf6wRMqWhkm3+P63ij/gRChWe3ZSyFV
	nnT9hU/U3Udwb2k0/VHFppH4GUE23q0iNGi6LWxw04WttGXAm3ALT84K96BnsMRerzhLAoX00R/
	fJvPhVk1MrJ5qAIsmBHyxlLMAov0z3tITsZ2zKGt8G3GMYhOiCns6YWh9YTNap1dn+zFb8ZgQMw
	bIbhJ5uzQkacNlEp63aVvr21fqNGCfBUy6TYYHnFOrMh8Tg6+Y2oSubA==
X-Received: by 2002:a17:90b:280a:b0:39e:2530:2102 with SMTP id 98e67ed59e1d1-39e54f4221amr13366348a91.11.1789754532323;
        Fri, 18 Sep 2026 11:02:12 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e554e5529sm2016932a91.4.2026.09.18.11.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:10 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: zorro7xx: put SCSI host on remove
Date: Sat, 19 Sep 2026 02:02:01 +0800
Message-ID: <20260918180201.3624568-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zorro7xx_init_one() obtains a SCSI host through NCR_700_detect(). The
probe failure path drops the host reference with scsi_host_put(), but
the normal remove path does not perform the corresponding cleanup.

As a result, the SCSI host reference remains allocated after the
device is removed.

Call scsi_host_put() after all users of the SCSI host have been torn
down to release the reference acquired during probe.

This issue was found by manual code inspection.

Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/zorro7xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 21c769dc1ecb..a8b0c2d4a9cb 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -164,6 +164,7 @@ static void zorro7xx_remove_one(struct zorro_dev *z)
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	zorro_release_device(z);
+	scsi_host_put(host);
 }
 
 static struct zorro_driver zorro7xx_driver = {
-- 
2.43.0

