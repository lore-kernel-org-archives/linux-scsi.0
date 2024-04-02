Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC29115A4BF
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712085946; cv=none; b=tsQBNTztY9aNCBO0V/uNBwNV6Md1Quyyh9tw+q87zPNRTtdbWw5ZVmjolrVJS1gwdl/cs6rT5KLRs9os2XdSBcEpcG2yhIAezZWpoqg7w1BnT6Xb8KMu78aycFGiPi/kRPh6hutDzHCNNnc7fYPrcQc9YI2bpfpOR27fJs3TCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712085946; c=relaxed/simple;
	bh=nuVk2rrPA+78ak46RlwfYXTFyzdDDE2jrqhHVoV+Z1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aLJ0lRiS89A//5GwmHcELOmY6BLFJ/9jXdc5ykX62xV3kpXBNZSaPeNodL9ghgMZeNtfoDFxnyc/5PSP6u9Fg2Y1/Yuc2Lhwt5And9d8p4yptdK1BcEW3/1kDl0bv98cIAnhOg/D3xgKIxVq3DQyU3N311T4UZXvHQQeCqKeGZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eRUKtcdW; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eRUKtcdW"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dd02fb9a31cso4837374276.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Apr 2024 12:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712085943; x=1712690743; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wt5s0i3Bf+a37LH9mW+EUzfbFaTvXfHBxqu8Vrd66jY=;
        b=eRUKtcdWpe86riGzbCKgEMCvzWTToENpdJAPyKlfdEsr5PvWRL3utQ9r8TpBC7focN
         j07zITPYqxGQRBL+l1Y4LFCUWZRVsv3h7iiDAqzKB2hKYt7EpYJfvDT2P4HFBl8zOkdj
         V5AqF6oJ90MXGqdSsA2AAvv3q3yVeaY/vMkgcFUCUtX24PYWVSI4uXanASX1+EK/eipd
         CKPiHMPgfO/+7VRw3s483x0njYoF4HaFXv4Qc/9SDT7YxBViSeyaAvK1HmwYT8zdxhKD
         lX1KmDoIn3YEpBXpV/vqrOhV7jdbRtgjc1KvprkdxSwMzUiejJChi51BC8kFEcwylNww
         fMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712085943; x=1712690743;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wt5s0i3Bf+a37LH9mW+EUzfbFaTvXfHBxqu8Vrd66jY=;
        b=rp/ckXbjeIwwVzrOrMc9VMEI9dieN55JWQzIuCzGTDPE3Pbal1BmO2ADST9q3Uzljn
         v9EbqfYhC/Jl0gbuogueyXAKebnPp4IdRqCplveueMh1lotqowyEY+1rCYYaz8II+iOt
         yC1H79GHaSwQK2t8IgDazxL82/IMarJJBSu7hR9/mffk4vC1Br6Nb/0d1OzwzTaD2Gy5
         PZEwi0P/AoOkD4Ko8USTj2uT45o7RFkq3uJbPOLvMlDgp4KYk8B2dDLm4pyTaOP2xTg1
         sCeg2zqywtg6GHj4jFiXaDVdaJy/YQVokLgPmVgISluD08TimCmQic4WXI0YRjesPDGs
         od1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnDEbGXeaFvO/6uU3Oy2XzcPZI3l3pocuSIkd7qGpQBjbyYoyCyX/DmjXkqrRGVbe42M61B/LrIHrVUu4TEh34HW3lwFWo8zwJig==
X-Gm-Message-State: AOJu0YwKviH3MbF5nzY0/5Ats56fLY06wOWylCnwMYeG29FjgpbsgZrX
	Zbenz/OSN+rjkFOS+jL/wzwwOtJ/AKNZMycGkA1qz9B344eXKMpyZqGCXwWMqrQuJMcMrbpCmAB
	enzQVBjmIUhcw68TsqJ05tU5gvZncOfesFLZjaw==
X-Google-Smtp-Source: AGHT+IF0NCPeZnC/FxDzoqpqrxq4T4tmylOUOl34+HGr8LAiprE09JWVEjadMflb9rYYLe9n6G9XkDK88BIiin+WUmw=
X-Received: by 2002:a25:b90d:0:b0:dd1:2f58:292b with SMTP id
 x13-20020a25b90d000000b00dd12f58292bmr10593508ybj.9.1712085942918; Tue, 02
 Apr 2024 12:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240129-ufs-core-reset-fix-v1-0-7ac628aa735f@linaro.org>
 <20240129-ufs-core-reset-fix-v1-3-7ac628aa735f@linaro.org>
 <CAA8EJpphzwoCaetGfnM8dE478ic1-BMqXKA3XVLeC9j5BBu3SA@mail.gmail.com>
 <20240130065550.GF32821@thinkpad> <CAA8EJpqZYp0C8rT8E=LoVo9fispLNhBn8CEgx1-iMqN_2MQXfg@mail.gmail.com>
 <g4a6gl47kfjx47ww36qnwp7zgvbd5gi5r7d26ibitfrybaa3l4@gvnz2mhsdf4s>
In-Reply-To: <g4a6gl47kfjx47ww36qnwp7zgvbd5gi5r7d26ibitfrybaa3l4@gvnz2mhsdf4s>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 2 Apr 2024 22:25:32 +0300
Message-ID: <CAA8EJppOPrSfD=VkHm8M0P07=mN_BikT=cGvLe6UFL3OpKVWzA@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: dts: qcom: msm8996: Add missing UFS host
 controller reset
To: Bjorn Andersson <andersson@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Andy Gross <agross@kernel.org>, Andy Gross <andy.gross@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 20:35, Bjorn Andersson <andersson@kernel.org> wrote:
>
> On Fri, Feb 09, 2024 at 10:16:25PM +0200, Dmitry Baryshkov wrote:
> > On Tue, 30 Jan 2024 at 08:55, Manivannan Sadhasivam
> > <manivannan.sadhasivam@linaro.org> wrote:
> > >
> > > On Mon, Jan 29, 2024 at 11:44:15AM +0200, Dmitry Baryshkov wrote:
> > > > On Mon, 29 Jan 2024 at 09:55, Manivannan Sadhasivam
> > > > <manivannan.sadhasivam@linaro.org> wrote:
> > > > >
> > > > > UFS host controller reset is required for the drivers to properly reset the
> > > > > controller. Hence, add it.
> > > > >
> > > > > Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
> > > > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > >
> > > > I think I had issues previously when I attempted to reset the
> > > > controller, but it might be because of the incomplete clocks
> > > > programming. Let met check whether it works first.
> > > >
> > >
> > > Sure. Please let me know.
> >
> > With the clocking fixes in place (I'll send them in a few minutes) and
> > with this patch the UFS breaks in the following way:
> >
>
> Was this further reviewed/investigated? What would you like me to do
> with this patch?

I'd say, hold until we can understand what is going on.

Mani, If you have any ideas what can be causing the issue, I'm open to
testing any ideas or any patches from your side.
Judging that the UFS breaks after toggling the reset, we might be
missing some setup steps.



-- 
With best wishes
Dmitry
