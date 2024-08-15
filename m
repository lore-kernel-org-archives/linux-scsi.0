Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BE17DA8D
	for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2024 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721084; cv=none; b=lAQQDrdn5Y+JFrlAti1HmCf0rEHcf1drJj4pEcu9SPuBogrvJJrBBFIeMWYOgF5mYH8HQ9MrTKfNiT/gqosrqa+5R3CpVEpB8VxbSXg9j+Er7VCpCAdThNSoDndPL1Vn038TGfRoozpwnWwajRuFhDe4dFuaBxRSWuZUN+xTFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721084; c=relaxed/simple;
	bh=hK9x6dzRpGC8KUkGCpjPQhxBbwERUW/es9KBxYVU670=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Q/VevSvY36bh0CEnIKaGfuIFAuhUGQrDNDS6ICCcInot10nE4vHqS5Cu7LmmuDhn5IdjBZkm5bWd27eAdqTUauz5ThyBjO28MFivTuNMyGadSW64jb5vkIkkSVqDWM+tSX6xIyu/HddRzx/AIYJoR5IZmD/zQfWlQhf2aYKexdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DOu4dnhl; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DOu4dnhl"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52f024f468bso938195e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2024 04:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723721081; x=1724325881; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GwOw2yZJcLkYGRSEzM30uACAh5jcGiNrXqca9PAg4GE=;
        b=DOu4dnhlT3BZlVlaSKn1nz9803EQDGtFuKsRgzrsaEuiBIW/rBLQERQKBonHnj9E6j
         UFHBTxJf5+W6Sv0C++RENrF9f/T8NPghIXiUywpCWoVV2NS917FORrZzmcq2pS5KBWLT
         N8+68l412t7zLBIPmQKw3izH2usF8//i/DAf2yyRN2hBnlDAa4zoC3xLpUYyIRGUOrWT
         OSl3tQl2CC/JErtlp7s24NsjxKy+jQQGEk54lb0qU3VNuFCUYx7qQqhCm8lpvDyNqd1h
         wqfjiiz5EyJDRhcHCxLWDzp84XOKSwvueKFczqUvAKVi2CZcGC2wfEIrB53cyYOI2Lxv
         E4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723721081; x=1724325881;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwOw2yZJcLkYGRSEzM30uACAh5jcGiNrXqca9PAg4GE=;
        b=Y24IPm6zKpqi0l+rQsMiAZmpEPSRr73meaTHGuv+78VkavuFqQ0+jLuCL70BBI5ScV
         EfcKoUwv6/n7tiIgPFfMwY4EYEmQ8ucipvlJzgezdOy2kecZzLXw2jcz5H/4u+mqa46W
         UuhsbY6GdjeMhryRxNQoejZwQ/PIEkZH39iVFgDevzryjQywF50/0fmj8Zu6vfc0+orK
         qKbzrouLINwNoHMCAEQKlS49TtP7H1fLzL4BaiGRffATB08sXLzWxw6iTbFfyZ/v+U/d
         b7znjf8xGLbqgJJHW8Vi+r89Z6r6YhGD8VcsIMbFhMaurX5cOyOUAD56XbyJA9VlZe3r
         mODQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcInp8z6UzbVzEPHldWULSFR44/86dRlpcluQpaccf66a0K3g83Eev19qUWMoVhUEuN9NejAnBxoN4rAa6Qb4VYxiq9gxMqSwsRQ==
X-Gm-Message-State: AOJu0YyVm7d35TmZQKSHU8Zj3unsXSKAz2smVRbqH1wAD82GNXsEt/j8
	2Ah/AGUE+oh/cTWHK76GNfFf8XCDco7sJ7K5luChk1R5sYFU8O1kmflp3jiCMIs=
X-Google-Smtp-Source: AGHT+IFnZ0lunFouQFuMLE7ezWjdZu72TNWMHe+GJtkHOdU5m2D8sEMH3Uv1CpSNRxgkEkrOrUQ8HA==
X-Received: by 2002:a05:6512:3c89:b0:52f:d15f:d46b with SMTP id 2adb3069b0e04-532eda7595cmr3980479e87.14.1723721080615;
        Thu, 15 Aug 2024 04:24:40 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cf05dsm86767766b.53.2024.08.15.04.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 04:24:40 -0700 (PDT)
Date: Thu, 15 Aug 2024 14:24:36 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Brian Masney <bmasney@redhat.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshcd-pltfrm: Signedness bug in
 ufshcd_parse_clock_info()
Message-ID: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "sz" variable needs to be a signed type for the error handling to
work as intended.  Fortunately, there is some sanity checking on "sz" on
the next line, so negative values would be caught and it doesn't really
affect runtime.

Fixes: eab0dce11dd9 ("scsi: ufs: ufshcd-pltfrm: Use of_property_count_u32_elems() to get property length")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 0c9b303ccfa0..1f4f30d6cb42 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -31,7 +31,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	const char *name;
 	u32 *clkfreq = NULL;
 	struct ufs_clk_info *clki;
-	size_t sz = 0;
+	ssize_t sz = 0;
 
 	if (!np)
 		goto out;
-- 
2.43.0

