Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C231E7C2E
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289941; cv=none; b=EoVJ/ONnP+AJ7KmvldHnofwq5aR5MBcIuRHnFPfnGrVVZlBYT7Rrq5k8oDGVAJFWEU2Dm1xmIjyHUaQ+Zodu/wdboGIT3JUt7iKSarky/0PXlrXZFjGYZOcspuTGXerLkkjNtmM4F7sU6cHipMe48NSCw+JRLEHGB76tDzbw4gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289941; c=relaxed/simple;
	bh=i1lP8I2grHrCyE9c+t46FjNKQ7k/gGdFLb+BmlfKGdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VEmz4qMsunxO3Ygo9AWk6Zl89BDJHHFQSaV3DR49QRgPQfoFqtn9iSQcTgu/bbQoeuc36DlFa9WKqzgf9lv8zLvqLZF5K0zij4cg89snvHbNwPq57b0enu8UqtscUMmAjiXM1i/kHykhExSJPmhdYPdHYW1ontGGqW6c8ncvqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lSSUQXSs; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lSSUQXSs"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-71811c7eb8dso3333954a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 05:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730289936; x=1730894736; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i1lP8I2grHrCyE9c+t46FjNKQ7k/gGdFLb+BmlfKGdQ=;
        b=lSSUQXSsaSOgZU2f3Daew00I6NL2+efCPSGiItNwWeeRzKSK6U54gb3nn52IIHOm0E
         R3EW5AxP2G06TB5+Z/ZLJ1Pdk2HrWXvtMzDQUajg+cX3/OG0VpMr2xAyL2B+645X0kZi
         U8jort3N65efeTQM7zhvjI+QbYkgrk6MSaOHx/aCWxbJarVEfdFW9oZ99juJkCGOVPNu
         H5zdJIxuCmC1K43E+EsKeo0BzclI2HP/02K0Xz6hR7lrmABQ2UFytPvGZLKbqwxtLQ1v
         ijuqhe8ZG1OR2H8ARNspiNoYX/EmvYi/YrSQMBCHkZ2/OAO6XcFI/uL7HF78LmNQkudF
         mBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730289936; x=1730894736;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1lP8I2grHrCyE9c+t46FjNKQ7k/gGdFLb+BmlfKGdQ=;
        b=gB59X2wwCIpowcvUJ5+/FHjvN62gXgkDFxQHN6oqhbLfF1kEZMG1at9MJfHYoc1I3O
         IHv1PsfyQrpbr5A4mT5yBgxrbucVUC7iGbK0wDyUuG7ezI4RV9zCAJEyqWJ7+fGFTxv0
         y5+K3GlBHKvLO6k9sDYKrgpBxzUNJLmkOlppiJrOPTe5A1qX1mfaQ2dSK38u469SIzyj
         Y9dUwF2D/wandnJLgF6zHB386iC2wbuh/rNe2Y5UJL+6nZ7aeYXgcVH7bD3hksoG1X6R
         fKMenUVkizXhmwhZVGRCAtJnZz8P2bGPUvsOLMBeEp13ybNevuIUCqO/IUrMXUD/q3es
         W1JA==
X-Forwarded-Encrypted: i=1; AJvYcCU+wzsmSxf1FPqvs70cA43QNAHfdFccG7ADahg1m4f6zWgY6MGGmLc7GDGV1tDtvvHOP72Q+hWIHofs@vger.kernel.org
X-Gm-Message-State: AOJu0YzPpDtcvYogsSiG6P72N0ZVvuK4Bf/RFAQ8M0+MKrt8gDkx4J3+
	RT4H38AOQm0VrLvY0es34xkj/E6PLERmGQYkqV4FzbmWbwkBJytC1s9uI5DVuZd+58tqehD/uli
	gu/X+wQvt4ofuUauu8kxh2LLj9ctdR0rsX4/OgA==
X-Google-Smtp-Source: AGHT+IFn+twCzCSyeeaogqHqxJtlAhMOH/0ALCX8dQKWNuWWzUxem8EDdoP/Zy/JRJuXvAkQG9PBSSTzZU3c7V6LoE4=
X-Received: by 2002:a05:6830:3146:b0:718:531:c190 with SMTP id
 46e09a7af769-7186827b1abmr13608345a34.24.1730289936015; Wed, 30 Oct 2024
 05:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-2-peter.griffin@linaro.org> <74458ba4-af0f-4c41-92f5-c6c0cb79e930@linaro.org>
In-Reply-To: <74458ba4-af0f-4c41-92f5-c6c0cb79e930@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 30 Oct 2024 12:05:25 +0000
Message-ID: <CADrjBPozRnsf5a0fNchbuokUK6y00SNSqEGDJ-sHojSvFzdd2w@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] scsi: ufs: exynos: Allow UFS Gear 4
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, avri.altman@wdc.com, bvanassche@acm.org, 
	krzk@kernel.org, andre.draszik@linaro.org, kernel-team@android.com, 
	willmcvicker@google.com, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Tudor,

On Wed, 30 Oct 2024 at 08:04, Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>
>
>
> On 10/25/24 2:14 PM, Peter Griffin wrote:
> > UFS Gear 4 offers faster speeds, and better power usage so lets
> > enable it.
> >
> > Currently ufshcd_init_host_params() sets UFS_HS_G3 as a default,
> > so even if the device supports G4 we end up negotiating down to
> > G3.
> >
> > For SoCs like gs101 which have a UFS major controller version
> > of 3 or above advertise Gear 4. This then allows a Gear 4 link
> > on Pixel 6.
> >
> > For earlier controller versions keep the current default behaviour
> > of reporting G3.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
>
> Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>
> some nits/personal preferences below, no need to address them

As I'm re-spinning anyways I'll update it like you suggest.

Peter.
