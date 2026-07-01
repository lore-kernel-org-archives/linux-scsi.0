Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DDD3A48F7
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 06:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887005; cv=none; b=pyFJ47RaX5cd8jqY1DcTzeYWrj7a0kwmghNN5MYg/9toN69Nl6o1E+y1SqFBXRIl+dvKqpiiYO7JiwDJqUYKmW2nxKnqiWNocaGPc2pJqBUlOa9JJ5D3P5zHczBCoYeo5vxNSmSnPR6LyoWV7k0VJj4MdiXlTADEWD6qL92rofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887005; c=relaxed/simple;
	bh=iDb19+v9W24MFwVBLKYMAccXrZLiNoIhHW9iZ7BQu8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dS9ajIR8Ouhjdvjk+DDuTF6Ia1WGDyQJB2GZs/ziw70gwioq03fcjrr63fih04SUIx+zISwkyNGvcslTFHv7tI3j33vVEZRqW7H6ZJpXXEOCiOARl8DRvWItGtTo/pK40wSpuR2L1oJ/A/6XZ78/4bZPen5B4lq7LCJB9iGMK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=VnAXweOo; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="VnAXweOo"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8479f1a86ecso169661b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1782887001; x=1783491801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wh8rPIUKvSG7DWfJknXu0HCqG3Ju9McYV9PNpDjOZvk=;
        b=VnAXweOojvyKVSw5BJfxQV/rM8AerMEQSZwqmZkdHxTRi8VuDj1Ss1hNNofhPyW0Nb
         NZVZQSUwn6tSZ8D4XFg4W8piMMKxdn0+ElYqSBJHGZwGpdMhQYyNT/5Ird9C+Sw/IM1q
         64KLTgF5yr9xvL/v+2Xpn1Apw6ZdfyqwDVc+NXFkRreZ18Tjkr5kPnU30NAjwgZ3OiEv
         rJrJvRJCmf5wOhWW5Rkx+o0ZNKK55f9tMm+6XolbHjKL+86CFp0LYS/UIf0ncvA+hyWI
         Ct8S+mQr+1zLh/v9d3Ayey39yju+jOKMysb2o8QYyTNINKNq3BXKFD1Ysq3AISnPhhCw
         0JOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782887001; x=1783491801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wh8rPIUKvSG7DWfJknXu0HCqG3Ju9McYV9PNpDjOZvk=;
        b=kmQyKOfx1LJrmQAspvjdHYnWaA6MK9dg/63DXw1+jHxWPWSXDhUmqgEZSh9elDfWZs
         /a+6lU5y6nlHOq4JuhIHn2N2wUKGv+evgF5lg9BtSZ8yO3x92FlLVVCSFv8Cfx1wxjFO
         L3R0x5lp/v5Up3grsWD3sD1I0rWJEl5cQSM2fii7at9sOBzZXUM0VbTcF0Rwv5ssbvj1
         ETxRWL7y4kMwQg/sy4cYRnfmsMIxI5rc3nrtGP8PiZo9xbih+e2RBgHT4fNhcJj2yFiQ
         ZE2eGAaNusxgDeb0hLZqDkRDwVKpe9HQ9N8ahGiNguG6trP87AYgou9ejjjJLakL1Ggt
         BrNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrTXSQ3UGSg6J6wIIucVUolU1g6x83mpPbuhD5QQU3Gl1gnpjX2D1XRyIK1l+Fje8vdxP8EWmtBfhKh@vger.kernel.org
X-Gm-Message-State: AOJu0YwxGEv5bl4k9JOigqID3Ypt+DH1wQq3531cY5cBtra5VnVcwcHL
	j1OFzwBVFMx6BxTOPw2BkA7IArNY+KnihldD6jouZqceu91FAblyiYEO8dtFgDYdguA=
X-Gm-Gg: AfdE7cnsSHjgj/7xu0CJNZNxU6jJF7Hq2NUQJgq6FqRGJ0KwYt0WBfeq7kIV2XYHzNK
	+NkopLlcryuY1o7WgeCet88d3ajtTJ5lxnRyL7fwZ9ol3GT/PvmOVWC9AkbYAACX71N0kmNaVnm
	HI/CxjA7b/Jw3oWBpa4hQGgbr4kwc+0yNWc/7FStPGpEsmodjkdypQQzYK3v4xnn/QLniDFzp8s
	UamXDJwkfSR/W2Na0SpLcVbu3e1xW5v+w3gC4sNNtgLxyWJ7Xvfxwq8V+plV3m9QiwvPtQfx+B9
	nalZN/hfaUcJZm4KAUgn00uhIk7O3LExOq3dorELXIKlys6lIbDthKqDh2VysHt3Lvmifo+IJNw
	FoqvlsSr1vUFjedqi3zsApbLNQLJHpg35Ul/V2TLlgpFihxjgXfXSet/FfJPZhdVpsk+ClNRxTQ
	FEHbm4FXV9I/3lQsOtNycLnQQKzJkriURFRkA4rjid+Dcto85DCuq8fLayE50q2TFYTar/v10AA
	BzAkAlufU5JHtJpsq0/5Elm1fE8G+tamVu+Fc98+7o=
X-Received: by 2002:a05:6a00:a87:b0:847:9aa8:d3ce with SMTP id d2e1a72fcca58-847c06ddd6emr253010b3a.2.1782887001364;
        Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm3270627b3a.33.2026.06.30.23.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: ram.vegesna@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: Fix potential memory leak in efct_hw_parse_filter()
Date: Wed,  1 Jul 2026 11:53:08 +0530
Message-ID: <20260701062313.372532-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an empty string is provided as the value, the error check after
kstrdup() call, can fail even when a small buffer is allocated for the
null terminated empty string. Fix that by freeing it before returning.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/scsi/elx/efct/efct_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 1838032f6486..b0fdeabb9d05 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1129,6 +1129,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 
 	p = kstrdup(value, GFP_KERNEL);
 	if (!p || !*p) {
+		kfree(p);
 		efc_log_err(hw->os, "p is NULL\n");
 		return -ENOMEM;
 	}
-- 
2.43.0

