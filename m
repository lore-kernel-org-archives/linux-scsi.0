Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B1385515
	for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2026 09:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788083617; cv=pass; b=T7FMMfFZqsrxZ6MONhuFO5AYn9lb50Nd2r577nxwNgOurmeYPglXWtFXSIFbgpvZRLCGeexJlsH3wZalXcVioARx2MMtTeT6YYuQHVjKLlyIt3y5fHGRvV0JerDzRmAlHZ6/rbLpWHLy+w/Z3RD5T68w++lsUMWBjiorGN8JYW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788083617; c=relaxed/simple;
	bh=noOHtdEDHEPP5QeHRvdNfehU3w+1cJ2qwt7n8s1SjvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B/jJthwRm1v5nPeU/dCRuXVbfgiztPXTkTW8SOPYdt7MmXZPxofOOZJFeBVfpwDHXnD0L6Bj5kOBo8zSP13be4nphXHmFODqQjCraeoqhjAbmz63+HLOaBeN4MtyooCuFgUQM5ZzQPWzf9F+6Pq8ZYWWSzzgSUdmCC8+Gm/8JA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iK1YSEwh; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iK1YSEwh"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52fac937235so155411cf.1
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2026 02:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788083615; cv=none;
        d=google.com; s=arc-20260327;
        b=jkIrk6NlXLAK73RQAefssHNu3YvqdMi52JVBfjpaHa2/TRV/y9Wl0L4jaSR0j422Rf
         Y25yLX/IwZXUnCd923hNn1m+cIsJ1O9CQKFifYJE/ZZRBMegrPMhb4lrsMGGTwii3Ixj
         Ka9u+SM1IE8f2Szr42MG0lZ5G5x5VjEITNH8TASU9wfjnQNFE6VpsAFSItQ9OHZI2Zfc
         quwbAH0I4xR/Osf6bF9zfAtegCm93d74eoYtrcBzU3uiOvcnz6tKartPb7h2vlRiebJ7
         3aM133kg76YJ2FzikntrTa6CscXYrs8vUNPvbVjkcLTMZv1Gtw1nDJFrl4caU/botK9o
         5jNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5S6aFJy+mT5uKBC0KX5FwDzSqvoGmSboVBAKwD0uv/s=;
        fh=yd8hTdX/2GfB2KRRajRSH8PJ+vYgj5sIi9pryJhfiBo=;
        b=cnaPP30OYYexHFf6/yycoMdQxFIQBCDGWNNRpP7Dm7hxLuPT/ZioA/Rfcty0G+ViSp
         qng9yxlz3JIou3/RHnsq8dZ6YLEVFapItbXhxwHkBX+PppUL4LbBPHZNM58OKsA2iaHb
         6G6D5YMqR9FlOG+9NZa+blPHmqcU4kWBbKBX+mWeqVZD7IaRJC7/jpL7Jf49LqUaI7E2
         k3lapNkcPp/z4bl8y0wg+BOYpbpSNxPTotjqEOWUNFP1/cW0U5dACEDOo7ogIMGzyJnc
         19ejVQWyloqkIZLf6gGRACOM3pRdzWJGaHoDUVRdtsb41p2u8ZEuwFfe8QP7devlmUbZ
         JcNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788083615; x=1788688415; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5S6aFJy+mT5uKBC0KX5FwDzSqvoGmSboVBAKwD0uv/s=;
        b=iK1YSEwhvz2bARYqHaACpd71HzuzrHQ/qpMzh1CTGxpiLis775HXkl2e932mrDkKAT
         vcGlLVLf45tf1/iPYBi4SXnGB8SoECgQTDlUm3nqtf7JytOO2OtBBkaozi1ydDm7TFXF
         pm6EtX6WxEDDJBcGMwEVnUk7AogjHa5+QvF3aRvelkvJuw4EOC8CJ2AsQMHdcwrYAxTL
         QFpnn1DvGA8a4hprOQ/3JgUowQ+hTacqd+11yn6KdZcKxZqNqL1C1vIpPGlj/ILLvw66
         /yJVERsrECDVieqoK9m/xBm11OQzh+YPO9KG1wzwSNZJkno/OvwLlDjve024LAFxfNuG
         OSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788083615; x=1788688415;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5S6aFJy+mT5uKBC0KX5FwDzSqvoGmSboVBAKwD0uv/s=;
        b=TfGLb9MBMBUy4/9QGyYZX+G4sC132mIh6BsrB2f8pE53VvYfez514cWMCaMhJmVtgH
         TDqf1hPPNdjmUlpJYQZYrTfYz28wS1vj0yf7E4O8fV+/mscjqvaoH+ABdXtmlUCKUgdq
         agBtuRpyeodKUCIm7yhc/vK3o5FjGJI73r5grrQKidf32y9oveKQXNUAz9cWLN8B5Dse
         nSC9iwo2YeKf5YR6A0ud7JWz6cDUBV2O7vmrHDLbVk3ZJu26Z9Wx5EcGCHsv1w4qSH2u
         FFNWh/lUVVH8IB6QLwlMtJudSdOyybQ6toPT90kZe2J36vPcT9HU2CQuaf+cVFV/eibz
         uw8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqF3hXPw2V5IYFTlFWsQswPGgoZRerYnncIqINNrxSnz34kOXcrYN8GysIPUDdZsBbwX3czBK2wC3mH@vger.kernel.org
X-Gm-Message-State: AFuF++lALVg5EMKAQL3e55Gdu6ZbD95wwpPfzo3hV457wqa3aXdAd9XH
	pAB6ghqeF4pFrxUNxWLDwx9DU9oID9YJDBf288eEmQnkAp3WipMhI2WmMon1v97pJewOkZ4AQO8
	0J6qidLSKN7h/xon1Q/rLNOejBSRPs8CQJTLiO4i+
X-Gm-Gg: AR+sD11+buUXFR7KcqO2DEa2CukKP/UIaSbJcpKp2E9eWMr45EuRI7Aq1L13dktVCAq
	A1J3viKqM1fHiJxUkDAJVpuEAqrR2UN+riHWNWZkzqNvgE4NB8wkOLQYUGNdFh14uay9ItRZzQK
	JkcWFTGJ5rrJP2ovPNtg6Ck72sofm0OTobkt7+U78FEXBLW1J9sRVp8sQBfqeEbiuYOzFt5zclM
	Cee4NjsCE1w5DxSw+HWdXnVZWTGfbfowP+NLXUSZYfY+7Ta2HZEcylpdoNxBSK17KTQ0TI0i/M1
	iNiFUh4LS0d0QI1717qfSHSH0m7IGvsoORX8mxpeXDgVWoMQlstlwTiqK5YVt15sPa45dJtZhui
	V/Q==
X-Received: by 2002:a05:622a:190a:b0:528:38d6:71b4 with SMTP id
 d75a77b69052e-530100f6b84mr249421cf.11.1788083614253; Sun, 30 Aug 2026
 02:53:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828092311.10774-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260828092311.10774-1-pengpeng@iscas.ac.cn>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Sun, 30 Aug 2026 17:52:57 +0800
X-Gm-Features: AcwNN1UaiSHb4F9fUpqjBR1le5QyODKMu5bAeRX35ytqP7PxUTTdcqYqoVRCkRc
Message-ID: <CAE14pdeXt63__PW0Md6Vp4hfh-HTdhG=LGSRtYRLQKWk0phxew@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: mediatek: Handle mPHY power-on failures
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Peter Wang <peter.wang@mediatek.com>, 
	Chaotian Jing <chaotian.jing@mediatek.com>
Cc: Stanley Jhu <chu.stanley@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-scsi@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Aug 2026 17:23:11 +0800, Pengpeng Hou wrote:
> @@ -509,6 +509,7 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
>       struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>       struct phy *mphy = host->mphy;
>       struct arm_smccc_res res;
> +     int rollback_ret;
>       int ret = 0;

`rollback_ret` feels overly verbose; a shorter name like `err` would be
cleaner.

> +             ret = phy_power_on(mphy);
> +             if (ret) {
> +                     if (ufs_mtk_is_va09_supported(hba)) {
> +                             ufs_mtk_va09_pwr_ctrl(res, 0);
> +                             rollback_ret = regulator_disable(host->reg_va09);
> +                             if (rollback_ret)
> +                                     dev_warn(hba->dev, "failed to disable va09 after mphy failure: %d\n",
> +                                              rollback_ret);
> +                     }
> +                     dev_info(hba->dev, "failed to enable mphy: %d\n", ret);
> +                     return ret;
> +             }

`dev_info()` is inappropriate for an operation failure; please use `dev_err()`
instead.

Thanks,
Stanley Jhu
