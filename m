Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CBB2DC771
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746000563; cv=none; b=BHFouv1La719cg7tueb9TpQaeLydBJTfcksEW/F0qXkqklOZaxToHFu0OUZSKcYuqS/5GztWMMPQ2RTPvw2g6UkzKuOmMDTvXKAdH4g/Y+el++QXriJcPlNsS/RrzdWldyiARvd+EidxM8QUMEcrSy7iLjNhqrDsfOuvj8UJiKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746000563; c=relaxed/simple;
	bh=6UtymQyXrF4a+LYasF9PbN/zB10qj6RgpAwI21LybYo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LZQ8ViFVxV3LQ9RSLEL73ZWaoUSw9cPrEe2jw9ch5VtJid0BhN/B4lUw4BM5UrZzDx2jsReLxMAYN8NENCXAxBjpX0MmJ728WDFbh8UzDwexnffNIdKsgGWK4/NMn+gcWa+b2UQ/d6SvjmMiAuwEEWYpbnOqfA9A+nIHONpZzUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vOZeOOz5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vOZeOOz5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so64873615e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 01:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746000560; x=1746605360; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpACOCF1MHWzD96uBtOOM0CMYYdJxW2a4szy+v5N/qQ=;
        b=vOZeOOz5yTZMNSVQis6JmcE17LzgrtvDzL95xWFk1ZCNbZG+Jy+cOi09QNxxqodROj
         SMLVCvpuW+l9ZJigj0Ukr4Mv1MyUiPFyHqXEL7rf9dDlpgq0ueNUqevy+/MfpL+3F1gz
         xqt9YI6+znI2EOi2xKnKZ4u5ril5Q/W84b1yHd9mD+AaLhxV9m1bljCz6ftEgnQ0RHiA
         aJthFxsym3cy0Y/65D8Z7n3t1RxVh+5CbmVD4QoCqq+TpFxFv7CxV2Pp54r7+pJuNXpI
         8VpPam1yPFzOwZmXtUaY1OmcE+srUiU+0VA5ewfk1+uDVKiIBQZeeopAmec53mWl9eYo
         b0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746000560; x=1746605360;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpACOCF1MHWzD96uBtOOM0CMYYdJxW2a4szy+v5N/qQ=;
        b=hIVfQ1aS9oJc/ohnO/QBeWQ1ejsWF8+bPJ9le7PYHZgqt1nPpLZA+lhyQEcC/bFQh3
         ITFXTH4XvyiWFHFQN+2c9M9B4z4JdCAasUMZVyy7EvUWo/RkSnZBFFGz/dk40boVGm3j
         K8u9JraJnj6tFQ4UmcKFiVRb1U76tUzPlnqAQQ1L/S72Lt6GH9Bovy8KGQ/WWTFPC5E6
         y1uWFK2+XcpNtNI4TTOXoag3ZPDFpk8Yv3KVLUHYDvoE5AJhxsq+6zIJ38WKvNOR3amC
         zskTHR+Fh3zBY/uCoZW2ZSyFGBrlk+1iUeAmGPnMlT1gH0zEn9KiDS3xsYl2BGuyX5XP
         PXzw==
X-Forwarded-Encrypted: i=1; AJvYcCXhwWuxdB6lh4wU/druUZPwFS9zp9r8oIvtcaKWV8GY8MJHioUhC6ebUvY4IpOG8AdXoEZJDnQvHD65@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9fMt8H4eN07mNEETJ6/eKcBmNBB0kfoIwkLh1eyU1lk2gLbXg
	sZYuVMSdO6yqtzwYsAaNQG2SNJHKXKVjuQTbQdD30XkKnwjbyfblZ87uBR+yFhY=
X-Gm-Gg: ASbGnctd4TyYytK9Z1GOWAiC7cybVLbMOcGCpWrNsnBXqSm5imBuXVkomAtUKsuKTOr
	stGIlJRTsTu4xltz5vu2Ed5IHiWIG9pKw7SX3r+3D7N9kXaw7m/DPj0e7WXqk+9oTHqVh7Apkxj
	YwOomJ2ni9n24rgKL3j5fwyA4598ofel6JUK9o/jsQxsjAmFX1BvJYWsurBYyf/SYbeNsQAGGvU
	ndg/mbVTyVQMGsggBirffjMQb7V9PfBe2h0E2nSLluHhIxhpXmVipHH6lawZu7/ivgcTdgpg6He
	c3WZXSbKlOxNj6mHp8weX1DuR03RLkurpJ5jRWGBGIBOGw==
X-Google-Smtp-Source: AGHT+IGBq83nOcN4b+oPM0CzEXiI7VyG2IzTaGKGL8JICGk+35Wr6Tatqo6c5pr6+l1Y/IIGhYQN/A==
X-Received: by 2002:a05:600c:35d4:b0:43d:3df:42d8 with SMTP id 5b1f17b1804b1-441b2635580mr12479415e9.6.1746000560243;
        Wed, 30 Apr 2025 01:09:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-441b2bbbe88sm14908225e9.25.2025.04.30.01.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 01:09:19 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:09:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Yi Zhang <yi.zhang@redhat.com>
Cc: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: smartpqi: Delete a stray tab in
 pqi_is_parity_write_stream()
Message-ID: <aBHarJ601XTGsyOX@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

We accidentally intended this line an extra tab.  Delete the tab.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 93e6c777a01e..1d784ee7671c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6004,7 +6004,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 			pqi_stream_data->next_lba = rmd.first_block +
 				rmd.block_cnt;
 			pqi_stream_data->last_accessed = jiffies;
-				per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->write_stream_cnt++;
+			per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->write_stream_cnt++;
 			return true;
 		}
 
-- 
2.47.2

