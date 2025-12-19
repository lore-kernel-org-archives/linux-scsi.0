Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C219F135
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766180730; cv=none; b=f9ckjiFHfwcfEoZyyT0WBH9d6O4MYhCA6nWY7S6WwuPFfFVyQzF7A5+l9U5r5SbBA7/wtJhswjWIJbVtJeaxMf/FNLURhXejf6gJ9MyfnRaLv/W2TNCZOIVL2ndpZrUt3yhy7AbaShznwtnRyofEAQ5ZeLSiiwxhj5ZO7j+qiQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766180730; c=relaxed/simple;
	bh=E/tyVze7GjvOR6oKmycXNTHZRcGUr0IVK21VJQSKidE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TWtb2xg8Ajw4rcis/Gz4PqNwJJjGoNmFOqGYVvePC/c/OnhNVyC4GIANhKtiEpHifmEQScKjUmoBjsMvoM5dKZxFHJ9y3ETZ/BO6Yt29zzTBmoRj+qkToilivH6IDUO+4tAOPtXD4eGHeKyZBf+6BdHLT3OvaiAP8ptCRUh6AyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScEfxe9z; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScEfxe9z"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa9so1043130f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 13:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180727; x=1766785527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV5l3aK94WjBMd234KR2t67rjid2aTdUenY4d4w/l6o=;
        b=ScEfxe9zXZg7hZtWBG6pPp0CoMf1gj0QvZAyHlHskpSaLCQ0Cf1xr7XL7of8HrtYaL
         +1DwSb9peIXSXg0DBBqeO2mvIHhJymWkJ/AMg9Aentoa7RppQKHYP91ug+Uf8aC8xYYF
         D3VXU31TWPc87/sc2JNRAQrfny6M28E7RsTgu1Meh8GZMsRi61p4mZpxJAVRI7oEoA5j
         iZXeCLcI6igkfBY77ixiwNWHmgG5HTAyG2vBsBH9gAiwzGjNkE9JJDCkkpikmRMoIb7m
         r3MIW4SLLnlzg9gEuKLshQeznKY488YY1nza0COMGUTFCT5iIKuKmvpJZUC8aOu6DCHP
         97ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180727; x=1766785527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZV5l3aK94WjBMd234KR2t67rjid2aTdUenY4d4w/l6o=;
        b=KcBl27GmbeD+Yuly+gIIU+IB1vfF8VfGBB7TPfEsdocGRa/zt253AReN11nNbrjKoQ
         d4mNTzYGm5lHs4qNWuF1jpprHaRafUG4ffzd4OjGsfrra+NBl6rfvIltfkaywW0bQG1N
         LomNs7PuCTG3WP5liG6vb35mOP+C1yPbfQDf6d2eIFfPXO5q3jzIfN8TyrqVImyyWyPW
         HODVEQW8yv++0kQtHzchOs0aGuVf1UnCaMiISL50lfVTl7ymwC3U6RVMe9drEg3wQltO
         Kh0cnB3n2ROt6AGfdmf1GHZ17+VueOAHc/v4pbWYo5JCXRmDwilaipd4i+/OF815p/Ks
         uFcA==
X-Forwarded-Encrypted: i=1; AJvYcCWB9lmUyOmkMtYwwpoubtAOea6g+1wn2R8w0bM2J8Djwk5rNx9qYbUmI1QR6f6EZ3jOEemLXbAHaCMR@vger.kernel.org
X-Gm-Message-State: AOJu0YyvTED6fg6rVyBGfXm7KKMgLIN4Ct5Vqr5pDAuK4bDt3NdJbVSr
	eWTlN0qQC9GpfNm9YaXFFB2whOXBwM1P9z/uVdQNJmiHtCYlS2H3Aog4
X-Gm-Gg: AY/fxX45z3MwlqIj2+Wm25khT0U4Y81nOWAkNyqMRVexT+q3f6ghNoGIWpJPC3CbU8S
	ieX1w0tDysC15NQu+iw1V5kBxZhf9mXWuqoxwu2zHRq3G+Ya9T/wNOpiZzZIYZB2+Q5Op3QQs/+
	QoaA1AOQtvUoB8b8v+kgBtHKsZ8P3warqWQZ9rOj5SxDgtkNm7aZW8yFshVR3560VZa+O7FxTM+
	vGllo0CNvPZ40BePHQ01iX8u3c+oj81bhpKFWzmjZb1Bke6qlB2UhQFzwBnKrpkKS8Bn7y2CYKV
	04L/p7giFOBfDs2wFRQDUXsUcsfPQxyU5HR+XtcrV9ysOgdrws4rbnVaV6dK+pST4gW1cZmSqNp
	hHrJc8gOYHWlRwsQ6ZohN4IM0LR7Fjt47xFveujMPYy3flixBOluLQ98DqtHui+wDDlrY3xLYiR
	snZugtGSaRgqlep9wY1qWW
X-Google-Smtp-Source: AGHT+IH6/ztrcn+SlJfyVJT63am/rH1xZvx6X/K4m0kF1MT0B91G4kSCAcxAARG8TFZiP/ksh381nw==
X-Received: by 2002:a05:6000:2211:b0:42f:bbc6:edab with SMTP id ffacd0b85a97d-4324e4fb405mr5082384f8f.29.1766180727224;
        Fri, 19 Dec 2025 13:45:27 -0800 (PST)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm7013078f8f.0.2025.12.19.13.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 13:45:26 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: host: mediatek: make read-only array scale_us static const
Date: Fri, 19 Dec 2025 21:44:28 +0000
Message-ID: <20251219214428.492744-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Don't populate the read-only array scale_us on the stack at run time,
instead make it static const.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ecbbf52bf734..66b11cc0703b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1112,7 +1112,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 	unsigned long flags;
 	u32 ah_ms = 10;
 	u32 ah_scale, ah_timer;
-	u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
+	static const u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit) {
-- 
2.51.0

