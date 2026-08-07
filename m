Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9886A3009F6
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127960; cv=none; b=f54JRsOegK2AwxfM1ZWHndy9B+R+IpF0RZ4QlRudubW5eUcefDiTWAt9AkSGlJTPSODe++sWlhcm89L4AqSQ4LvoJH3GUiGUb4U0du5WlS/944yQ2Eoim7ERHvxRfu+vY8xQXu0JdUeOpaYX2scJRdgNSdqDXeKZcO3zolvLlNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127960; c=relaxed/simple;
	bh=1w3Nuu7MEgSLxDphoqxOiHIes6lwaCTQWCmIXRsJ1JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYGbPlv7Zjq5JukOfB8JP9wki8XrcDBxMtIaWX/heiKgJcSGSvXdH/a7Q9VU0uXXDp3LQ68ezB6VuF5WuLRvnnOZdfivYFwAioO4wIkX9IoG9XM/W/SMPvcqpggMi9qB/0RX5hF+i30hEh3YfxDPk90nciSdD8XfPPEkmniyAOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxJU0sDn; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxJU0sDn"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso2943763a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2026 11:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786127959; x=1786732759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1w3Nuu7MEgSLxDphoqxOiHIes6lwaCTQWCmIXRsJ1JI=;
        b=BxJU0sDn6IWhfFdgJx5YDAB3tj8L7UywxVGZ/+VVYM7OEU65n9StIZWqB+gbJLoO8X
         CFHaDWtW7MpLz/tP9WsXAawThLu8rNuWhGL5WpPnlr3cDHYm3cP8HG9fgfEpILq4Tod2
         hWr1bM4kIUmQykqgaA74KrtRy4zFEUhuhAMdgBQOs+Eo0WeVEpE5ja5rXenz30v4Is15
         OKk7V3tx33GwZBNv54G2i2tRJay6h8YWtdiup/ZYyn+GRUNI2WUaroHzVayN+AYaR063
         JyEEtedZWhI1m3zjzZ0FAsRgHRcolOxenzKdTSn5RoVnMGEtjUY/991P1e7QDM/i+Uu9
         ncXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786127959; x=1786732759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1w3Nuu7MEgSLxDphoqxOiHIes6lwaCTQWCmIXRsJ1JI=;
        b=LOB0JaA4yFufySYh6nyPVwNWeAoz6hNyoSOAqug77tqyMprKvDK7pI3jlx9bjK16RZ
         WHBMX7iRfu29cYMEJhJYwG9u160xic5VUYnlJda/cfTHwVsahvjApj87ZExvoqZHqbNg
         NcLfVxOkcOPFJ9H8nxAet4Me9g+CgYtJfxTc/KQqtFmo987D428NEeHi3gBWrzVAVXw9
         cUDtVAC0dv5DyZJGDkXu5FYj8SOEQgqtw0+IhoF5A7hCVNnSjpiR5CMw7eNKMIfHfoQo
         GDONHRYWXPKSaFiqu3V1p16pVnkZJ1DvI0wrb4oltIQngs+lPNs9CZnNtitVgisZUm2l
         mDrA==
X-Gm-Message-State: AOJu0YxEsDvPFwz3VhEh7zaSumFiF2uePrszRQ4ydsji0BxzLriUltbt
	+KZZiayjc3zu0LXLsYA7mlMVJVZpk29JaG4EYd2loO10iapUbwnBdOWW
X-Gm-Gg: AR+sD10jcl4Iu74w4FaJYjfKCZ0U+9aQsqto1w0ghjODIvYXZazzD8OBibXd3Mv4mdj
	Xq9scaYtgqMIjhsADrB6A7eyZtuGWiEFuTAARAERbxYajS120tfrMAlwXJRuweN4Ydh7ZMEAEJN
	vrVRex2ZnNEauX77m0+O9ehsK/70H2YPHQYTXKJxSQtuPoqv7aOjgulDQXCLQQswqLXa0wNdHwE
	keVJr1LmSWL5pftBb+pSYbTC1GIPmpXnvM45HlgZZrSnzav6ueEZi2xKVvngrsUSP+FHMi9Xmyi
	L6LD6BpIKipj6Wp/YjNhm5tONP/NkqHYoC2265kTiBd0KLJRXFNc477SSKSQmO4o7AgYrujrCik
	2u+TxramfkCNgLt/IdpWL623GMh1rem86//mWWaCqolLJ+nCzqNg+0O4bkUwWXEr4ATf9bDmpL6
	K1uKi7fFwbwRohRjy8ExXY1Ho41kex1JmwYe+/WhHsZJDUCgaPLj7dWAOtjiUuVq3nB0HPjn7ZX
	hWMDpCfFi1xqUvdgvElYp9WnMWmu7im3kAr5v0MFU23aUvmeoSx1LZjwv6v
X-Received: by 2002:a05:6a21:e58b:b0:3a3:a9c4:3d60 with SMTP id adf61e73a8af0-3cb85f5c2b0mr30739753637.27.1786127958832;
        Fri, 07 Aug 2026 11:39:18 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f37469esm1155243a12.23.2026.08.07.11.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 11:39:18 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: sashiko-bot@kernel.org,
	skunkolee@gmail.com
Cc: linux-scsi@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] scsi: arcmsr: fix NULL deref on dma_alloc_coherent() failure in arcmsr_alloc_xor_buffer()
Date: Fri,  7 Aug 2026 12:39:04 -0600
Message-ID: <20260807183904.73546-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807055056.9F05F1F000E9@smtp.kernel.org>
References: <20260807055056.9F05F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.

Now that I look at it, the commit message's claim about a reachable
secondary NULL deref via arcmsr_free_ccb_pool()/arcmsr_iop_confirm()
doesn't hold up: arcmsr_alloc_ccb_pool() failing sends arcmsr_probe()
straight to unmap_pci_region, bypassing the free_ccb_pool label
entirely, so that path isn't reachable here. The acb->xor_mega = 0
line is still harmless defensively, but my stated justification for
it was wrong. My apologies for the inaccuracy!

Separately, thanks for flagging the pre-existing DMA leak of
acb->dma_coherent (and the IO queue) when arcmsr_alloc_xor_buffer()
fails inside arcmsr_alloc_ccb_pool()! I'll follow up with a separate
patch addressing that.

ivy
