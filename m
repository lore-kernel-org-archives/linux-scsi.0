Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F281A3BD647
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599068; cv=none; b=aTYHIYYIeumx34Y7YVe8U1CAPojLDzV0Av67UiRY3FKOhxFIk790m7A1zW+LGi/W6nyWZxjN9gMZWK/lMdUJ3Pp3nJTYVU4e4pBL2qLzXHz9JbUWMfjNmJoqCWLNqPaI62cP3p0EgtZiIcGlkpkWiayyBsewRBiRVNToFx2gnYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599068; c=relaxed/simple;
	bh=bdwMNcZVjf0I1CDFWjmxuzGycazN9aJDtvxsS5g9hFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=The3Hj6UlLUq9MTaadV5mHwPqHPOiJSDTsFWqZLnGyU4rb/qiSFfCvTrohgw++KhjvoECSj6xAqx3LcMC9lKAdO0mGaP/ItwVpSYV/yHouFWnXp80qtLV2HByMbpia3eyXSujAuzNn7jkNusR8mb5hg06PPhX2iynP/ijby8rbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6xeTwBY; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6xeTwBY"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9157b94a07aso158592185a.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599066; x=1781203866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CQIKIOUNHK4p/kK1ZVRgUxKnjETRbt3AMrCW5x1awc=;
        b=A6xeTwBYAryazVJwHxydeUNnsdkMyog04gVLZBvEbieiDo9MWwc+OTXZe7pKDHO6hr
         wl/RNy2LJFZvj69q0oD6lkxbxzJjIdFhhhg42WK5F6WyJDKRTCeyW0HghNijeqagBSh/
         sB47D1ruqvCdZppFvNHHNZinjU621G8BMW/x6AGLBA1we2nlXSOe2mHqWZB93dz/iNNQ
         QjdCAfC7x7tgl2rvS83S6qREN965Kup7N77liuEmoFYgLxCfVTqgOOmoFlAQ132Pie0X
         mdyzvMw2cTVkO4aYuuXCrF04q6NhlQgoSBx2OOGq6jO2hBVWtH8wffqm53yH51AauTpg
         9dGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599066; x=1781203866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2CQIKIOUNHK4p/kK1ZVRgUxKnjETRbt3AMrCW5x1awc=;
        b=pcpGYtm5uL79+Gzq8ZnRxkS2XCT/Rley1nOy3NPdt88WUb8jKGlTAKuvxlW/0PhSMf
         dukhsEodrq37V2fq6DhrtUzMDGXd8RRT+h3uobWp3Fdas8DEn2+yUkjC8Mqp0w93GYxi
         ljE59/01Ov7eyt0l6fIVzlF1E2P2oKtPoXBST085h1OmZ1KJEAj/Su5zAMK7UUr2xlH9
         /MvnGUDphm79LPMLk8vt3OQcJ2olBiJd4sjv3pSJOTu7z7oKq30t1vDVkCX2ByzDbkmN
         90pD1ssUfp0f+we7lhlLozcN0HgzrT5+tNT1fL+YXsKrRIMIY9jepsOWeh/HWmcDWjtH
         bA6Q==
X-Gm-Message-State: AOJu0YyAhk45FMLTailHltSuDRTnJn0IOezL8gzJkI/yy59uEs6KEODf
	Ot8kGtV/72iudfxu342J7TDIFPXfoNBJWLegiEZVi/f/uVJKuD9el1Lovh0MGb9+
X-Gm-Gg: Acq92OHITmd/+U7G/SwrJVP+cA0orIIPJGh0Yu38fFjIt/c3smtHjmnyVi2nkuT8f/l
	hfvs3jYePK9xntdKtWRXUlz/5MyCLJ4uRfQN5feCItBGPJ5+QYMWM7O8Q9Bo2u9zzDJYLnp70JN
	bsXkxrqnw3D/YPf2ueojO3aAPUEnLI4gt+U2JJecIrKfN/wrZCWy13gIfep6dmAP5Gf84HoNRlo
	Y4vYXzZn39Xd65V+pWG99cJI9ntKFypGxrOsqVLeASwWyRcMM0hCf2y8a2t5HPo9bode6BUEomZ
	imvrQ8PkAcphb0stYazo2Ezf83Va4m0a/hVuvhtD3z1Br4HpuuXaLZnBBax8kdiQb4rlBg0cajQ
	NTVdPcjQ1Xf0Klqa+Kz8SFvgo0KradM9OnAVN0KjcbYhJcKa7sQ3BiiJJH9jghut28a2CahzdLe
	M4Mmlzqt8PR0fe7bhdgPMY8akHWKwJkDW6s+rlhsAI3OvxaIXKkskCv41j5UPzpVSp+KQFwKty0
	gUBinyeYD7UU69C0gku6l4aN0am14bvZsmTk7RdJZKCc4+WlRPMd4JcBos9Ku+N
X-Received: by 2002:a05:620a:390f:b0:915:9f28:6739 with SMTP id af79cd13be357-915a9cb1b35mr68684085a.20.1780599065940;
        Thu, 04 Jun 2026 11:51:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.51.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:51:05 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 14/14] lpfc: Update lpfc version to 15.0.0.1
Date: Thu,  4 Jun 2026 12:29:37 -0700
Message-Id: <20260604192937.65605-15-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.1

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d6e6e436fbfc..7df63d118234 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "15.0.0.0"
+#define LPFC_DRIVER_VERSION "15.0.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

