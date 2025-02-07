Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC695246324;
	Fri,  7 Feb 2025 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738943113; cv=none; b=q7v0/IU5K0EEm4qUvvQegpGcKy2QdF55dgRrdshg32R4HO7dRjSc3ypo84yPnBWlWpgYWIjXzOg0EViMNNh2rZWCH3Un7lnwTFZdvTDFlNaSbmY8Ji6NAo7jnnbiMUgFV5yElfkxOnsif2ao6D8Wma9d+t7/g1EpGjwmD9r9vlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738943113; c=relaxed/simple;
	bh=6Dv9u9iMz+DcsLmWTQCbzBZtfz2P+8l8k57NZKBzhGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L3Hn7mAqunUNVhth7VDc59T+RaTyee+DkFcyIPaR2W75PeyDAirxQzzR6UBeYi+KWrSetWSR92Xoa3mW7Z9Cr9C31ja+09PDx0dPALqwbkoOwnQdH6oCwcgZzEs3M/KCED06XWc/mZw6lMKWw1PhS1rJfzycE3IYhqjXSvftzNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nETfRjyi; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nETfRjyi"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6e41e18137bso19341746d6.1;
        Fri, 07 Feb 2025 07:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738943111; x=1739547911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=nETfRjyi4bJIK59ZgMQNdvF4elCXyyuQ+Hysjz0t72jFSxmUuXu2CsKhKA0QmqyZF7
         biUKSzXSGbi2g2hkPs5+ZUJBmXgLNfSmLBjpnn4Vh+dSywNz8Cs1BCvD6SMHwcvQ54+L
         rYG+qoDFvAEfRpyvlRGTumn5WYfo48gs480MBfMac0HPi5LKq1eBGfeP1Sr/yj45qYbd
         Z9NvGmqANwqd3lPp48tAgn00F5ZnSbUPx3y0JNLanZLpo9heq8vAGD9P7EC9j6t4kSMr
         CDLZZCk4mHsSQd8tkZgFDlgrwnl3aVmRL1lpt4I2XCKpbGX3O7SHDcThI8R5AZpOMUfb
         F2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738943111; x=1739547911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=qWNvj2OaWaREYsRaBgvMrdylfkk2PcXamQtOXgcBAGxw8qq/8qdUB535nX0uulofJK
         DZtKF1p+azgRugBJOn9R6MVUZmEM2hmmtF94pwbaXIr5PVVCmo0is31higawbrXJQDxQ
         Kf/Wpwa4/HZYZsA7n5y2HVofH2QwxAn3F0BgAjW6gW31aXb3QOH5BFpkj7zKb++TBT00
         Fr+STAs7IF2aBw0XzBpnPy1aE814afeyZfn9a4BGDR14+8QKadE55NGBbkSDfzi1Vo1F
         W+MUzx1YYwTim6h1BS8X8ChLWYCAopzE4GAQhbiXCmZFix/Cx3S7N1akGigKVfvhvjrV
         6Wng==
X-Forwarded-Encrypted: i=1; AJvYcCV5BfB/xXeJq+2mwAzJ3DfqT8Uf7K86N0MdPmWMU0ZbqvnNGRUV2xmeKdLk0eDHjgPJ8EvofPrF@vger.kernel.org, AJvYcCXJH7zdv2tRS4DeOJe4ClZBkGNmcyb2bLjlRjVqv72RoxFDiuTdip6y7kDO8hkiS+wFradDjUMdnVZLOg==@vger.kernel.org, AJvYcCXV5LSeGBcLWuOzKffQ8whjOYHRi9BekAOeYwi0JgxKD96rDknsS5j3I79Enl5tZSon3tsC4K4wKdgqjSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUenR7wXJTTxoDRzVCgNfVu3J8QlByihSJjij7/IrDA8glpGUz
	eBD35B7oFUXt3H73o60o3u83wc772lbh1quKF3ZFojzPd7TpaoOr
X-Gm-Gg: ASbGncvzKsl1UI9zNvbugrmH2Kknyi/e2+4JLCQaC3QMpDWSOaDvtK8S8IsB9xCNfE1
	qhRuAC4Bka0RTsCw/erViMaDQncgrCFDJNwjW2kDxpTfvFUGxiLdHbB6C17eb16uHxIdCbXa8di
	IQi3RbPHgT9NEaa5zcoFydfjwW/Tdm/vgOC7SN4Epu74kRMKxr2f7KThha6N0p0b8twYUiix35r
	pLZP2FjoP4D4uX3gmxkAORQhBhATx3kZ75TWHMA9yjB86JZpUmojxS7NlGc3KR+xs6HHQBGbflU
	WATzx+4KXoeTqAdCJhSs65TY26GeOhFgWrknBg==
X-Google-Smtp-Source: AGHT+IEh3IqsRiFrek8tlhG6fHu+9WMFlGMLV/pDjWkxT5uqn7EgEaqU55vIUyhc7fcVKGe5qFQQVg==
X-Received: by 2002:a05:6214:dae:b0:6e4:4331:aae0 with SMTP id 6a1803df08f44-6e4455c465emr36455376d6.1.1738943110627;
        Fri, 07 Feb 2025 07:45:10 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e43ba36d5csm18258186d6.26.2025.02.07.07.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 07:45:10 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: gregkh@linuxfoundation.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	markus.elfring@web.de,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: qedf: Add check for bdt_info
Date: Fri,  7 Feb 2025 15:45:05 +0000
Message-Id: <20250207154505.4819-2-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250207154505.4819-1-jiashengjiangcool@gmail.com>
References: <2025020721-silver-uneasy-5565@gregkh>
 <20250207154505.4819-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. No change.

v1 -> v2:

1. No change.
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d52057b97a4f..1ed0ee4f8dde 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

