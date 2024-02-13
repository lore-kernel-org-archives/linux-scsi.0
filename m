Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8FC605A9
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707847696; cv=none; b=jVpQBdZ7LmJvl7l5teqFOJ80Ud5AE2C64F5w/XC9GHE7eigH+U+7GjvMTqGECq4XEOvPQyky7ifGyGSGOBYB8RuuBJbJO05EwIiEZ5lXXUv9XJ9n9cjzvy9ldxgqt0gE7OpS5+pcRNQh84oD7uxXRqo+uLKjKPQa34KQJHttDOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707847696; c=relaxed/simple;
	bh=qUDpWufqOP0+PWEnGi4jvXwLx/nEOG4F3D3IgB3iO4U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lMFzzZAYidB4zSj6iFCgAyebv0RqeUCzHxt8KgZHoykBlnl/LLYcx2wQpCAg249LlWg+2bj7KXwA2CV5uWGFb5pwVQ6MkzKzeGJmewjeXiEZ+aA5sJH96QSrXwVRkdt5tiy4VnESbZ1M35CrFA6fWZZ2N42jBdiZ37xNuPVfqp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SuF2eLG3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SuF2eLG3"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55fcceb5f34so5398646a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 10:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707847692; x=1708452492; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y+WHbON2JSYzrGtsBd+Bvl8eFVRHPgb/kBoMusZieaI=;
        b=SuF2eLG38/F+r9Tr/LjUNQ0auUlOkYvSKGcinnZEtpVXPM4u0m7tnxl8xefYfNA0UQ
         jErGcJF8Vc97lCjJKlOSBVO74eb5MMe/oKdZQFPPGzY8jJcOo/EzIQN23Ucg+TftvgE/
         SB7bea/c0FtiK7sS9WHLUdCui1ZCcivGaC/JhD7IDRbpuZd6ZfmL56YsXI7fH1YaUjGU
         KCzd8/aGwS4siTNYGdVghfqUg2PaMkpGPBIhCJk6gMuQOMMsNmPspzRco61sqRjdOUPY
         6PyZTiWtGVDcCGgDtbWMTWYXrTXndPefn2OX3N8gi1/kva1z8aVgNDI3iRIFKnnWc3BU
         gZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707847692; x=1708452492;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+WHbON2JSYzrGtsBd+Bvl8eFVRHPgb/kBoMusZieaI=;
        b=YPgu0PWX+ymlISi+0y4S8o+dkoY2mjUAfrcHqLgeWnWdBZJh3a1sWHv0auauCQQ1bX
         XWKvU8nr3bDEyFr/PUKVXVT0yiw0te2VJhZHKIhQDeSfZbuCIv3aD3sK4kGl2foLbhCF
         +PSleyfCQnvokLICQHGWpjKv80q89AtsNBTsoyoOhHXaE8Hc+/VVtol9dzz2v94XPyOk
         9RfA1b62Jyr1q1lxLcCDPObRh3JzR15e5bdcjM/hTkL9VXyIEVVZEMDpOAU62cNtwNdl
         bjPUgxq3kXi471SZaQP7eNc1dNy9K/ZPrGmxhv9TQY362Su9Go1AsG98YN5N/V/IksM0
         PofQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPBlpg7F3X5aUDzhu2I9lV6h5HZY09qyZaPRAq2WNZtgnQh3Zs+ijxAfH5wC+IZlYmsFvz9yK3lnK+uAoEcmg3/9Fgu6MspCdbSg==
X-Gm-Message-State: AOJu0Yw1CgssbfpwkboTTiz6ZvjT1L5DdBnyd5CvL97aGcDbnPDK07NE
	B0zqjcVAfJkKOq5Iw/BgwWQ9xc2swcFOplyS6cs/VEa1nlll5FkZSlIGVUj7NCo=
X-Google-Smtp-Source: AGHT+IFWCTr8oDNuetE1UMBMX0h8FuBHaqRwIHB/Dr1kwXZYVGHgvdLsTypTigVsdOewUWEp8b9Gmg==
X-Received: by 2002:aa7:cd72:0:b0:561:f8f0:33ee with SMTP id ca18-20020aa7cd72000000b00561f8f033eemr287257edb.34.1707847692644;
        Tue, 13 Feb 2024 10:08:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvPiSHWgg1v4Pv6U8ngSel5c0LfVZ7RbHdILANjpT0ZIk4xIXGDYxJdONi57F+KKg+mmosjuCfV6tehu+0gkUTjwgJUY7ljO1NX6eOouw5DOlPBaAl2KciPQSgkFQEp7tqsQvy+JPcwTU9oku+uajansVZmswJl3Z8Rsfk3eaEBB7vC+e79t4To+/iT8dE8l1iSxiSFpuSHzfL2xwGlI6BbfB54zJJ1N9uPpwMH69u7EWjKiyY2TmqZD01GsyNcOlhb1az7M8XHgRR82yhQR273Eri3BdHniZu0LKZe+Pm30ZI+Z1eL3N4GnxAHwB+z3S+PTWnwODlLsfsSlmYw4VwDMyPE+je5+V0dD5/qA6RV72IMvs0r3tC2XktCckEU5JMQ98BqkL/E5Omo2QteAABqnjLpHL3PdZNDzyJeBim2D1GlENtlAECL5bTflyzBZsKAx0I1r8I5I+82ezt9TMza+Xnek3IJo7ocrId/Q/QIWuOsmrjKWnmfXh8YBQ+Hg4N9s4dTeZWmJiqtVvXnaQjpsTCA/MFeoTJHWPDueBANtl2yejC1TvoTF7xWqs=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id t22-20020a50d716000000b0055fe55441cbsm4133469edi.40.2024.02.13.10.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 10:08:12 -0800 (PST)
Date: Tue, 13 Feb 2024 21:08:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Peter Wang <peter.wang@mediatek.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Adrien Thierry <athierry@redhat.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: uninitialized variable in ufshcd_devfreq_target()
Message-ID: <c787d37f-1107-4512-8991-bccf80e74a35@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

There is one goto where "sched_clk_scaling_suspend_work" is true but
"scale_up" is uninitialized.  It leads to a Smatch uninitialized variable
warning:

drivers/ufs/core/ufshcd.c:1589 ufshcd_devfreq_target() error: uninitialized symbol 'scale_up'.

Fixes: 1d969731b87f ("scsi: ufs: core: Only suspend clock scaling if scaling down")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d10a77d05d2f..a8a9edb7ba24 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1514,7 +1514,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	ktime_t start;
-	bool scale_up, sched_clk_scaling_suspend_work = false;
+	bool scale_up = false, sched_clk_scaling_suspend_work = false;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
-- 
2.43.0

