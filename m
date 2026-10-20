Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792496400;
	b=Hla64igA2dhjninayUy7WCxP0txPx4T6Gd40sFV0ZBfmD6ULnCdb6FNiD8Op1XoD9LQP
	 pN7Ts8HdRxum5YPah92yxfNNBc826t4ztNaGWW4y+CLq3U5LoQniD1tFAlQ4QPFPj6OtS
	 k9xMsjr7FSoCSjgbkQkRCyMUTN6nXw/p3wOsC3TtiDIBMSvfs6/WqsMwnS7FIuxQAbQHO
	 s+OoDGBg0VitvtXEyv2sGIM8BjR+NLIGCvhCvrGvvyZ3fWzg9b3SdX3AktWwoltrhmcAD
	 EgSZ54BlQ4Nnvd1aEIF7DLEku1ylWFQOihCnXOAIP0J09gI+3z2Pl4jetBUnMD1Z6SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792496400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oW3CDQ8hWTvJxUFgrwX87dctU/0QppQ3eb5Z2AmQA5E=;
	b=X0zZspQOCEgkEfjqwX2x9TZOCeRf1kpfxFqgKdbQNjrFu+8sf6aWK8SsYNfxE0S/V675
	 QqSztLl2YGIAfgeJ4Zy7SmqBT/vnoECGUVAod5c8mzONx31Rw75N37SyFgHv1ni/lsdws
	 PBMOVcppLKpZq6mWePE3lxlYilCRwPiVNe9ka8FbSUxOn8Xg1DN2CpHqzbePqSKi7ECt1
	 pI57tRlTdEhyWlV3CJOqk4aLcVUMa9cnhuZGEwwmIp9k10MLChKpC+Y1C5nz2/v8r0k0H
	 sFLHdK/b/gklW2a0T44DP3yBqJQIbsPC2th/pkVU8nSGU4gKxtjIdfvWiTPK18xOXug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pnbqEWqq;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F554606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 11:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F554606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pnbqEWqq
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so6866825e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 04:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792496399; x=1793101199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oW3CDQ8hWTvJxUFgrwX87dctU/0QppQ3eb5Z2AmQA5E=;
        b=pnbqEWqqPXivjtNzYZssc4sPi0e5cT8ldBrc1e4TlbBt1++lqwYJWEp7jmGnWElU2D
         S26ldoKeRJGFACatqK3dRhiLRDVaRBcHq0hp91y+dgoxS1MZPCCa3ySPtx8K5ZljdOls
         UzpTg7McrRchDHMLyZzBMpYKAlJkaww4rZahNmDRHvmW20vbOS/rztuCnOjD6E8oYlXs
         G1xYxYEpIFq1nSrG6M40wvp2AP5b3EypieCbqq4MgX9v97GZy6PiRDmDORec2MjESsaV
         xx2FHio3h8QQrmPWQ2V+T4fw5CW1P6qCs9laIdM6QrJ8qeCnuoqSrAIHVmNucG+8PurF
         heMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792496399; x=1793101199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oW3CDQ8hWTvJxUFgrwX87dctU/0QppQ3eb5Z2AmQA5E=;
        b=E2i5omIW4DjvBrp/yUUzpQbO/d/n9naTGiubidqk2+TvtyJ6AW14EvhGrJAcotVkux
         WepV8MsXt3/dpo1ah8WGZx2fzyv03BWR7AYSYfL0b1QRHVr+PXk9S72In6SHFJtPRQBg
         EwTfydF2PxrTVTkMVebqwacLh72Mza6xLMUuoo4eH6UVF88TBhI5wsMQYgNfm/34Yfge
         3f8buGUxOKqUnigPUAwYDWo/kXLMVPRGk7KKAiTN4iFKf1eoW5Fzl+YUZO6iwXDMvr/1
         qGDGWPOuPYiPMHBlClSZt/5QpTK8yxOf4sFQRS8oM8IxnA2KGApgjjw8ndCg0eqj83rT
         uacA==
X-Forwarded-Encrypted: i=1; AKwUvBwi8jvWLbhyLksd8EOtEz/X6gZbXEl/a1r5YU1s0G90C/HByPLVkALC+zVVCxdouElnd9+U56QqozKX@vger.kernel.org
X-Gm-Message-State: AFq9FYKI9289l7Yk70QRdiZPt5XANUpcleGbTZCK2aeRsglqu6Jw6kaY
	zD291oj8TnItGwWsNnFHZeBX/RU45QSH10JMWKjQk4FGlyHB7ENg8oy0
X-Gm-Gg: AYBFou2dmDwnzPlT7DeVZLJbilaAetu97Tb4xkQujsCnpvk/BWXX1ri/pW+WHuW59hY
	/rCE4BArwLonpu5ik28ln2QAhinlNdgepoTi674MjWzJL2dWXugfr2rbh1ki9FKWuefBqqj6u22
	Tel37gYovujtIUxGTp+7RT54vzkLCE7Jzw8V5YaO90lzDiII+tHpPanheuN0ovO2gq/fRYwRiNr
	5rcxn06aWFQBaY0mtfmRLpPQ/ocsCrPmT3FON+6ov2h4k8IAWRFK/+luk+p5ONibqbIwKGdWjeZ
	gkf+n8/qF+FC1/8c/JMZsvBIUNZYSCQPHERlBxRdQlHPjIGvxn3jgOwvJFd19QjuANjho6k87t3
	s3awXKHYW5oCV+vhyERDSOL6DNKqBFh0d73yGizenu7x79F/yKM5Mg86r3NaNZhGAlEVN7fJsIM
	xU6xFX9K/k0WDZqLRoAX8GEK6YIY+hgW6pVVoe8hfENUpg2g9flfY1lmHdDlMMOdmgqg==
X-Received: by 2002:a05:600c:4e04:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-4a1f4c7f3c6mr41266915e9.5.1792496398642;
        Tue, 20 Oct 2026 04:39:58 -0700 (PDT)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2c242dcsm62439595e9.0.2026.10.20.04.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:39:58 -0700 (PDT)
From: Andrey Misiurov <andrey.misyrov@gmail.com>
To: Alexander Antonakakis <alexis@maich.gr>
Cc: stable@vger.kernel.org,
	regressions@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	1151377@bugs.debian.org
Subject: Re: [REGRESSION] 6.1.178+: lpfc: boot hang due to use-after-free of mboxq in lpfc_sli4_driver_resource_setup() backport
Date: Tue, 20 Oct 2026 13:39:57 +0200
Message-ID: <20261020113957.951380-1-andrey.misyrov@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>
References: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Oct 20, 2026 at 01:23:03PM +0300, Alexander Antonakakis wrote:
> Moving the mempool_free() at line 8178 to after the
> lpfc_get_sli4_parameters() call and its error handling, as in
> mainline, should fix it.

Hi Alexander,

This looks like the same issue I came across. A patch doing exactly
that is already queued for the next 6.1.y release:

https://lore.kernel.org/r/20261008184328.2857037-1-andrey.misyrov@gmail.com

Regards,
Andrey
