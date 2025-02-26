Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DDA26A1A1
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607468; cv=none; b=TDPJPZm8El1RBjOAu5OM1m9GyzHJeoeBJVpZREYBuXFdpnJa+Zxy0rjHR0RpNo4Un697ywCApnKPP3lgTmaZvHOMCKF3VDqS1vsdSZI8g0qkCq8kcSCrz7zfejhhzBVO1lE4iS7W/xtE9c8lwboPHA2DXj4DnOH7bsH/e1csjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607468; c=relaxed/simple;
	bh=XD5vHpBRFTxxteEvRZ/Amzm2FaKpvRfB8H6AYjhg1D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8yM1TRpVC3wsLtJluFbammFncC5Na/liCU7mEaBBq4dZPIfQEH0ak6xgeW3aQxuxdZzdl87TIPQHej9NOUmIRnZUfNZDEcrdHnmsHEUC9xQOlt3r+KjFiGhClMAm6BOaNZwEGbbfJoSyxHIAbWm4xEm5QhyMnd8fNEVtMS4f8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gMyC7EE1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gMyC7EE1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-220c8f38febso4079485ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 14:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740607466; x=1741212266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqQVvrSG700cJ8ivAGfcs4D2QICVIKls7c2wPxYXgmg=;
        b=gMyC7EE1m+EpUlfi8P2iye5nBycYRLvHj9VIhmiUXuRPclAMNWlHaPT+lUwsGDX7sv
         5NjqLMD0lzex16YwaVbx4vmRYlE/jixnnH27RW8cSyeAIDvu7tqGX0q/sTSs2ZalMlWe
         Kd8d0/tZWEEvPj3pMqig19FWyeE7jYEAZm4bB1D24hnchC68Sy4o6/bHgK6EtDJZ11MB
         6aRnggH3QMbOgw7nAisf4dzbEhnds8BWcvWtDK36aGAFj4HV7VH1pap8rP0PCYWXiMTr
         /8DKCwNokHzsYXi6SGVqUL+ZwNwBpwJHzkXR51bVimteJeMCLsqvnL3YC/snskdQLI2H
         zrUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740607466; x=1741212266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqQVvrSG700cJ8ivAGfcs4D2QICVIKls7c2wPxYXgmg=;
        b=ITnyy2rk5uIZBIASm0v6nvHLT1xWnacqt/LDPliXjUE8AeGOEY5TZqbFWdPIur2nQ1
         IarLudXao+ciJg0yxxq9w6104x2xPJIelGgZcl6Y2z2A0AskHsR4BRiKKwHHN0bGTqiO
         +cQYjnh6rTsCvwLHCheZNxwg1GJ0nUN8WjfuG1ZwSKyqGhxV2+VKWGSSY5+DELwJ/Bms
         MuZhBMj/zAkiAhB5DalzieOHFhddZx+tNc9W70jBPs4eJb4nriw5zFN/t+ZLUg3f3HxL
         P8uSdF2FZqlJ9SpLbxsSM+htlsbBdvou1oz88H1nIyHogmefJgiYII+yDRS6M3CMaLlh
         7p4w==
X-Gm-Message-State: AOJu0YzRNBwDsWZmcHFHJczBwC8zRhrQzAa23egvB9Bmjx2nKS4ZjbXz
	kjcNygtbjaJMqvvo9GMiumhjdtoY+8NLhZihzz4V2mQrfe65abVd0XqtAsAJ100=
X-Gm-Gg: ASbGncuG/wLYAnRotaQ8xDtB/BUG/azKUQUE86gn0nGz9+TS6A4UhYopyAAtsAuknX6
	wlfzJenctdbT5XJ1SUhK35PB3nuEf3FFJLj4kqX5CZmuA83M+4F+hHdN8TuoL3Oysw/OQtTOdOr
	t7YkIHICLZxprzr5sWD+iSECkr8D4Se70p/20aKtxwguolYI5+azHflFif/eWQi43yFRu4AeLEQ
	EWCJX81b9qeSnEJOByeObserSxgF2gB3SUSDR3aJ7gw+QJTtlw3JXk/giZDhDKauwWGF898qspL
	z8WQwkRLqc7e7LXtCJIo3uXOGlCbiPmSyRVfEbwjeDZR9E7Y8EBUFggR
X-Google-Smtp-Source: AGHT+IH0ey8eRCvxcHgsNYYNwiwm9i82ds1xLg6pyL6Gx4FmTSqN0nYi+iPEnmvAXppRtAVsCj9cLA==
X-Received: by 2002:a17:902:f68c:b0:223:501c:7576 with SMTP id d9443c01a7336-223501c75e9mr6151485ad.12.1740607466019;
        Wed, 26 Feb 2025 14:04:26 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([104.134.203.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350534004sm1044145ad.252.2025.02.26.14.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 14:04:25 -0800 (PST)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	krzk@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	willmcvicker@google.com,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	kernel-team@android.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 3/6] scsi: ufs: exynos: ensure consistent phy reference counts
Date: Wed, 26 Feb 2025 22:04:11 +0000
Message-ID: <20250226220414.343659-4-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
In-Reply-To: <20250226220414.343659-1-peter.griffin@linaro.org>
References: <20250226220414.343659-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufshcd_link_startup() can call ufshcd_vops_link_startup_notify()
multiple times when retrying. This causes the phy reference count
to keep increasing and the phy to not properly re-initialize.

If the phy has already been previously powered on, first issue a
phy_power_off() and phy_exit(), before re-initializing and powering
on again.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index a00256ede659..943cea569f66 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -962,6 +962,12 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
 	}
 
 	phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
+
+	if (generic_phy->power_count) {
+		phy_power_off(generic_phy);
+		phy_exit(generic_phy);
+	}
+
 	ret = phy_init(generic_phy);
 	if (ret) {
 		dev_err(hba->dev, "%s: phy init failed, ret = %d\n",
-- 
2.48.1.658.g4767266eb4-goog

