Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793025779;
	b=Zszg/UrMpaeZ14xJktG1kixMVFoGW4iVDTWoD10X3+IGRXnAS179mR2Ro4pHbhg0xzqX
	 /m0o80ob5Fr8fB4zzTDMnpoMPwA5V98t++VJ4DcTRI/UFWzgKT+cpMVQzwYL9o9yPRlE3
	 irNWnnGzbFYOm3FPlE7OI23AdJAMSMYEisvW1AnXa1iU9uMEFroKI7qAo/RxRbcFfDWqJ
	 e07OUT5myuGRQt3W5zMcDLUJgOi487J7kJ16kzUdiRQMtjkxmJZ/wPuWN16VOOAmJTVl/
	 V6OcRzp2Nt4iG4iIKKg1cfEzFn6JjmGAKt32PBbEbpshfbKBLdZSBTW0h20ot9i2OEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025779;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:MIME-Version:X-Received:
	 In-Reply-To:References:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type;
	bh=py3eSCH/kMMZStYTruOia2CNu7tRlswpZyoC5eSohtQ=;
	b=k86wqNJnF9SDx9A3ZfD3cNXuhe/iE1th6u+bPG2ipNvKcWWUKyqgClyrssQ+r8M711nC
	 qAivFLQi8/pPA/xeBmJWz/etMaUbJ572j8Cq55Yex0pmQeGejz0ANCdudzSlSsulsb0pA
	 khTXv3KMSzJktUGVwcaGZasf0xMGDXTLwJiO71NdTl/9bt1u/RNt2u4M1ld3rJkxG0tse
	 5QrewTaVCTqQe967KdvJ/ab0sfiu73+p5onWDfd67QvDEv9DJb62jxslqE8mQmLnY4cxi
	 ZPawx5vV3K2brtqMaruobgn8sU5bYU38PBBVjMerq8/o9+Nu/nYBxWDmVKJYTBRO1Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Sjo2ss5a;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3463606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3463606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Sjo2ss5a
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a065e2933fso4459533b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 07:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793025778; x=1793630578; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=py3eSCH/kMMZStYTruOia2CNu7tRlswpZyoC5eSohtQ=;
        b=Sjo2ss5aQ2dVEHWf45qnSnSEFkoJnTfbuEVwIGHPPhnFs84dZacKMID4PZAHBEpgMI
         kzrCjPH4AezauNyEYGpRisAl1HIXVwO50z0jysSU/GCliCrOWIQA0FY0T9aTAyp7mGNP
         yyOD0lYJD/cAWBtWjUEmenbXwzeas4gaSL/HbyD9z4T++HPXM2viZRpbAK8+FfQFr5Jo
         i9XT1MBX6QcDwtLolxAsu8e40QK5aXBsmQMhqUdxswjiwXi9dN0gWBbRq7lMReo6kc/y
         X5YGILHUFtd7aj1DOJwKmOMgJWk64QTlJ39q1S9A0UUlhGREjNxqU/I7Mnhy30eNb00q
         TfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793025778; x=1793630578;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=py3eSCH/kMMZStYTruOia2CNu7tRlswpZyoC5eSohtQ=;
        b=BAxoPNOdLFN4ttkGjuDIiKh61RY6csPgseE9NgMih4pU8SAfQ4Bxj34wimnyC0q45j
         B6Sv5YjRK1jM0+EmwxnmSACwGeiitollOQ6xa9F3OFUxzcUt1vEh3Juxxc3gXXyLLMTe
         EueSiGm3VnpTJViMY4wQjI0nX3z05VjvJ5SBlCdBxnMb+VbMOnb8T9G+kfA70FQjJsNZ
         3g69WMG464BURKnfpkgR60Lb18rLOuXpkEm+5aebdidB310FqXB/WYZZBLfpRcZCsJzO
         OCj9EfvdDLQTeQV+NlkYWW3nf/t+CL2K717FPynYbxbY2vng/Gf0+3MfX+hTDZK15V26
         WHsA==
X-Forwarded-Encrypted: i=1; AKwUvBxbbTpa6EZ4PgLk5wRUQCB3etxTJVFUPtBW9yBVOG6SRUe7FB0Msg9lSNxiiOhbCaND2YZVJs2DxfOp@vger.kernel.org
X-Gm-Message-State: AFq9FYKvYdjV7gbkkNBMhWIKnduKS4+fQKxuPZzDdD1hwWZOYPeoQEq1
	ZCuMi82D2YdJE7Sex4I4vCKeqofbNmTeMK5TrDVvftIslu3+DCP89E8bAgTIg9wCgFUZF/BY28K
	UoFvGI+qKs6joBLKmDpQxDQ==
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: from pfbho14.prod.google.com ([2002:a05:6a00:880e:b0:8a0:6a08:e927])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2316:b0:882:359f:ef17 with SMTP id d2e1a72fcca58-8a36715c0ecmr5483904b3a.12.1793025778027;
 Mon, 26 Oct 2026 07:42:58 -0700 (PDT)
In-Reply-To: <20261026052632.1848929-1-hy50.seo@samsung.com>
References: <CGME20261026053046epcas2p31ae8a493f40c0f12523feec6e036072f@epcas2p3.samsung.com>
 <20261026052632.1848929-1-hy50.seo@samsung.com>
Message-ID: <18e21b71f8996bcc.3137322e31362e3131332e313435.1c875f.0000sendgmr@google.com>
Date: Mon, 26 Oct 2026 14:42:58 +0000
Subject: Re: [PATCH v4] scsi: ufs: Change the error check sequence for auto hibern8
From: Stanley Jhu <stanleyjhu@google.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, bvanassche@acm.org, 
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com, 
	h10.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Mon, Oct 26, 2026 at 02:26:32PM +0900, HOYOUNG SEO wrote:
> v2:  
> https://lore.kernel.org/linux-scsi/20261022074249.3098100-1-hy50.seo@samsung.com/

> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> ---

Please move it above "---".

> +	if (ufshcd_is_auto_hibern8_error(hba, intr_status)) {
> +		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> +
>   	cmd = hba->active_uic_cmd;

This brace is never closed, so ufshcd.c does not build.
