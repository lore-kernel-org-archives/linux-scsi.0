Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4391D95B4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 11:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741086620; cv=none; b=Sful765T83HlLQhUPkX1Mdi3uKGKfg8jpL8nechDaVagL3/e1gUXiEJP/F9p4EvMUWm2y3lk4gyWH3pagkde+wd+B72DeWCeow/b3W2b7kQFBNQ67KOrB9eg0XvIv8UIV+cbyyICkunUXU8Y4ZhN0nWySg/1401exp00ABASMLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741086620; c=relaxed/simple;
	bh=orq1R91M8c7dbpXtuEOgzh42cNSPrB9DSV2M6evhgEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MV8PIk/TiMcaeNqwv+PDE+sLxyWC2/1nVBSsQNUOHSfbseCTgW4T3EWUcdTVzlbB8nKHPUo3c4HFEj2kG8OW//sLbSnSlWugy9Wiz0xScU/ddupbm3xloiobJ89SavnxSs1hzgdJ5h9TE+XVmCLekmsCm1E838RWoZ664VrAY5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uu6G7HoH; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uu6G7HoH"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-60009c5dc41so596297eaf.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2025 03:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741086617; x=1741691417; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQbFhcoDrZBPCIQTDm/+1b8V56ThPOVb0NP4CFpNh3Q=;
        b=uu6G7HoHasu8+ttQ9ueKU8i7O5rmNcpOYtwegexQ3L64JgPnqq9YXgC8cgsz8+7XyN
         y3WfH3fX6SsQ/C9OhgLpINNvNNypB1ALO6K8lMyDAvXrcMCiArDJ9OCHZV95GQlNdbNV
         MxPfHKNVWxPmkoNDvZ/jDXPCUIGVbwZ5XfR4buQUu6HasdRFYOQgiCej68SaRYjLThly
         5FOQtyqxOkyWTmCc2Y685E2NccJ+QzdgrHGQcRdg8qnaQQVQ2lz06MtfybjwRePnVxwV
         xp1CRzY3j3WypR/vNzyJPWxOjJAu+RoGFpJKCK6Csj9lnBld4FJiC8oDi5Ep7SR6re5o
         ZxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741086617; x=1741691417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQbFhcoDrZBPCIQTDm/+1b8V56ThPOVb0NP4CFpNh3Q=;
        b=r/X87gw/ZoKriqhmxe8XUwibGj2EjtZWatU70Vl6XqJKEbJZe0U3/2R3jSkh2YxPVT
         00IHgbTFmmqqfutGtfPnAKs0w3fDVtzgQa72lqCFXm6sWg5q4SCc+YSgwKSfgauqqROv
         qWMhUndycItLda1HipUxtB7hzh13meS0o7OKxfYWjVUAwyePoGF3eV+AbnaoCht8DIgd
         a240Wcyl5M2a/TTyeLz4iRn2twmwmxa4EWUSw7biKlDFGW+mIove/S+5hXfV18Wps1LC
         w1WeGB1oYQy93MSOMcTkTwUbk5cWZqKLvXtyb8Y8sHsoOe/ieqRddpOUIqYsfnccl+dR
         c9Cw==
X-Forwarded-Encrypted: i=1; AJvYcCX3tb/qQRJf04BW4oSZ1nMwT/1StZdPuSCPqB2aWVUt6fItlhOEoQpi5RzES845Est95q8E3weXbaeE@vger.kernel.org
X-Gm-Message-State: AOJu0YxSKbzCwPKwIEhXL2HvU8B8CI19heLlLsjVxcw2IXcaYYPBQGwu
	GvMHyuaVvyM/k+YzA32KnvsS1uu5JIOXTQDsKdrgz9ViHef8Lq8cnzbt30HdaGvMZlwNNO3+r9O
	NoFKL+WjF1b7/EYR9uMU+7tV4U5ijQZR3zQA4jQ==
X-Gm-Gg: ASbGncu6CJeFBTKV9mKDVEGCWK7xuGoPPdtt2sE0N7DYEu1HdHMSaaGVXltpflu/DB4
	kBBygqSLB9oQ1VvV+LW2uW+VUQLrhtbwwk+IF7LofWE8OTfboo3nnAVFqes/khGJNodUiNgdJaO
	IKY80Wb8hqKvXbl8/98O0zxSO+lhY=
X-Google-Smtp-Source: AGHT+IEINRiNLM5nuBLFCz1du/UfXjBpJa2EipBY+f1wkfnUA0YwZBo+sl10akF+u4qE0h1ovmH6xsuQeboW1BoOyFs=
X-Received: by 2002:a05:6820:260d:b0:5fd:c5f:3937 with SMTP id
 006d021491bc7-5feb34b8657mr9224249eaf.1.1741086617654; Tue, 04 Mar 2025
 03:10:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-6-peter.griffin@linaro.org> <51ec6f40-c62a-418b-a538-082e3ad887cb@acm.org>
In-Reply-To: <51ec6f40-c62a-418b-a538-082e3ad887cb@acm.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 4 Mar 2025 11:10:06 +0000
X-Gm-Features: AQ5f1Jqwsn9oJaTqNHIYgxQUuylO7zocGAli9flyfTI1wTMKlEft2huZY8mFVSM
Message-ID: <CADrjBPqw-kt+4fLfJCziAJrtcV4gVM9Gubtq=7Xb8sgxq-i8uQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] scsi: ufs: exynos: Move phy calls to .exit() callback
To: Bart Van Assche <bvanassche@acm.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, krzk@kernel.org, linux-scsi@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, willmcvicker@google.com, 
	tudor.ambarus@linaro.org, andre.draszik@linaro.org, ebiggers@kernel.org, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for your review feedback!

On Fri, 28 Feb 2025 at 19:20, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2/26/25 2:04 PM, Peter Griffin wrote:
> > +static void exynos_ufs_exit(struct ufs_hba *hba)
> > +{
> > +     struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> > +
> > +     phy_power_off(ufs->phy);
> > +     phy_exit(ufs->phy);
> > +}
> > +
> > +
>
> For future patches, please follow the convention that is used elsewhere
> in the kernel and separate functions with a single blank line instead of
> two.

That was an oversight on my part, will fix.

Thanks,

Peter
