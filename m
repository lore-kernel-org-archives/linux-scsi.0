Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B623403E0
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 20:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783887407; cv=none; b=uqCSvSoZxUNN7I40gPzKE/LhaGwkmgkGRdvWWhRZ4XaKFcCQWTivJHWXNH8Zyeit3rPRcwiJNfGsqKrUz9+/0fxeCbFLayA+mgPkXF/8Tnt/7Mv0hTh+OHE/JoueR8nbWd5WS0eBqeV79vVYs5U19K0SW6YQQxj4iJMazbF1c4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783887407; c=relaxed/simple;
	bh=3QLR3KK8Id6mI23Kry/sbc3hYjkLOFnlNehgggqEwkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLy3wWRocNxVu3gr3Eozl1O9JHdxN0UANWK+WK9TCaoMQEcwYx/S1bvieWBJGRyZTwH3znxazGF/BlAxWo4eGBzW3I7QDI8aLPDKnkpEys28FzmcT9CXOfGUA83OOeE7aMJvKhlDBADVBqAxAiTDlKSUbtMzyd5AH4NPt4q5bNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=WiNtvB6V; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="WiNtvB6V"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81ea0b7d137so5660927b3.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 13:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1783887404; x=1784492204; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sexe2OJDiMkFGhURClJc1NsMoa58P5WaL0Byl520pbw=;
        b=WiNtvB6VOqUyBMNBFIfKB7RbXWlRSxzqtOwrhRon4lL7K8XxCApY+/SJ7ba0nxDLIC
         lozPBy/7nEqv41IuNdpht84WFu1S0SmgtopoWXtdShRV8szRnwKzHBNmVglVU7K5ODnv
         7CKt41No6cvWST0+1ZMlYjoy0auu+FWQVuYwlIHHkDlaBMfNQeNnYGiOWI1uMxieKrrq
         oFbyRt4MWZ5tpi8WVK1RWbYJHGCYwhflkKImif7K5Ez8TazAE/7L6Azb4RObxD947/nn
         GUnBSZ8ldoXcQLTNyufvy5bX4/Xsc7p6cwgKp1l6RUtUmnqHxzbvdL/QTSE3P2iupsY+
         NSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783887404; x=1784492204;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sexe2OJDiMkFGhURClJc1NsMoa58P5WaL0Byl520pbw=;
        b=g+Y10K2G3V3roJewZUgOp4RK/X/ZWH4PQMfUwq5X4zgA/w5qEJ4o0OmPFOGA8jwBDU
         NpWsfto4Yzc4WlUttDsCBlzMdTNCPAdXr+DZroySwfAoabWxz+gkDzQLnFW8jWvybsRg
         twiShatQTu64BPKmAY467qnE00jP3chzaVKD2hV7mZkYKbJ/p3uTkxpM22ttnccn+2lm
         GpQiHu151Br8PV8YieeX+WoHig+s9i+HWxubQ0u1pGlmXB9Nq+7NyuSp9reUnqpaxPr0
         Pt+VgvE79ETrKgYMfyUFmC658IB2SacvT+0Ef398IZ9p+7Qfh0ecUdF+UJ4ogvDEXqHN
         mwMg==
X-Forwarded-Encrypted: i=1; AHgh+RpxEo7HaaY8T76nC8JT6Ou7nLHATMEHqKE0WtLs78wkgjpYaPkbCiAywA837BEJkOk/mE5V7XduEp5n@vger.kernel.org
X-Gm-Message-State: AOJu0YyGvBISShMjVxuYXoy5Sd7hrql/6+0uDPcED07u9h0yFEHeDsT4
	jfRetH2hYHYzkhlSwzU1nTzDIORvyMt5tSdk+keDVTSgzzX3JzfT3J++lLJyROteQ+c=
X-Gm-Gg: AfdE7ckIJ3HS2IrXM4svX2CA2b1VhXiRYWRjnINmkd+ITfGdl3ckod401gKudNhh2w4
	4YB3rWPrzVQtZSD40lumnHV0B2ESyJzWKjE4Dpa3QHNv/rusv32Qpa4/UUJ/9cI37mz/L6zntl5
	BsOXsU5/fWBEHvCls8Cbiji/0AUZHV8BFb8yi3uvLkCO0M0cqHqlS4nDsdfBqlLxJAHTunI7zBX
	4+wPzdg+wTvkRsS/mpxdKzNVaVfXwnAMLwpuSX+90SB9qNFU8Lus29P9BoRATY3UrgUtWX6euyD
	FjTY5CwghPwJ0LSx2xQ37kImeJpRhiij2DZ7qN4j/Uk5HM9R+J2t+95yaU9xSxQu9DQgJwuVB+Z
	0bCm+Si7T+3aZGME6Jc6hCn+wpcVRpMEKgsfUf0xXXrTm7HJir98yE64k/CDogm0FkSLSH2i0rg
	H58CWuZOYYN0VAgBLoA2yC6CSCLkVtw3KcnJSmUhSuh3ZaGqANBfn0OphlRVBD/pVzcFx5
X-Received: by 2002:a05:690c:250a:b0:81e:68a2:89d5 with SMTP id 00721157ae682-81e901b3d89mr51627807b3.55.1783887404652;
        Sun, 12 Jul 2026 13:16:44 -0700 (PDT)
Received: from toolbox ([2600:1700:220:59e0:5e9b:73c6:ee82:165e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6c1f11bbsm98699367b3.35.2026.07.12.13.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 13:16:43 -0700 (PDT)
Date: Sun, 12 Jul 2026 15:16:40 -0500
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <7x3b4sttnc4oxkuvxmpkihfi76lkapjcigo7khgcgfytvol7w2@v5ykuyrk2z3m>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>

On Thu, Jul 02, 2026 at 02:31:36AM +0000, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h |  90 ++++
>  4 files changed, 1034 insertions(+)
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..4f53b7f7688f 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
>  	bool
>  	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
>  
> +config SCSI_UFS_SPACEMIT
> +	tristate "SpacemiT UFS controller driver"
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_SPACEMIT

Can you add SCSI_UFSHCD_PLATFORM and SCSI_UFS_SPACEMIT as modules to
riscv defconfig (or just add the former and add a default y if
ARCH_SPACEMIT in this Kconfig entry). This will let defconfig kernels
to boot with persistant rootfs on these devices.

> 
> -- 
> 2.54.0
> 
