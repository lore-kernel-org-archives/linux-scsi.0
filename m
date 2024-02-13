Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363F2261F
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 10:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707820201; cv=none; b=WTdYYPPzvauxIKrwjYSNTfS7wVzpMkQXtx8BRUbLUvwDORAxdLiHMpT+knvjDW6feIw9Rr2ZAcoLH1RxAJpzOVdE74aGaIOsiO/AmwNOSWm9bh/8798B0lhYQDyfDKxl7cMAlNLYRGRsOhvVHm5ET5WShq6gc0lVRiFffqHultE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707820201; c=relaxed/simple;
	bh=BAFPNPzJQXtyCWF5XDn1RobzHn1V1SnAs/ZanbUdfKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qRB+LDeOiqbYKWz5dXJIOfkM+BqZYphQSk5vn3eikDpJda758m/0V5t7HbNT1k9HaUyCFs4AAfq3CxycVEOCAUQyfUCLzi7eo5zDEjoUjbt3UfVqFoQIxD62d5L4vRgeKvJWxBuWQKEHJU7pP5umZHHBbJshDpnwcRMo8zeu8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DcNcbdEK; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DcNcbdEK"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-dcbc00f6c04so1172020276.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 02:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707820198; x=1708424998; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+EqDonj7KQZLiaPp6D4ZvH1t+lrAEwUNc/fnEAHBEOI=;
        b=DcNcbdEKUxMv4AtS+vABGbgp0+Yl2IvqLbxYGiAwtW96WJ2uzGzFpCsdsJV2NigBmv
         72oKFdlJmEwojo3olVaRTcsMmVIQqI3UDtSzqFSsT9yG/xKR/TEYi4KZCnC2DMtJa7Ng
         4wo18UIcsvKnjuVSq8u65kcNBzl9tMVVVh/2CmdvU59oEky8eWuJ9qC/duiTLnNxmmsf
         7LuOL21lAhH904E+T2V1nJyK6S+7O4+eN4/ua1BZU/JrhGgYBjJBbNyg/KpZsiI6oy1H
         dVcVqa0NoPpvEJOrBjLFSXJMjCIhyOslNq5ot0WEcxMDI3cWy2U6fn148pmJmxIRUMHW
         aBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707820198; x=1708424998;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+EqDonj7KQZLiaPp6D4ZvH1t+lrAEwUNc/fnEAHBEOI=;
        b=MskReaQZWBLp5K5/M7QRYMBpirOVQGy9j/k6EaOJP8NNTXutS2ApjPQbep7dg+x/dO
         /2OeOJiOH3Qs4p3dlIGnxeaYc7mk54vv6+jhXZtwHdWpi07nkw//Ctn8X7ee/68or7bH
         n+bw974HRJZ9M39Ilp3szGHRmkWiiknzTm5NtGq92rUt3OJy4m+j8MIPGxLK9sOOZ/PO
         OyQ3ooYP5Cdq2Bq3hgNHzMh4CciFmod1lQ5WEio9Wy9E0PEGpgelOR/yqwyPbV2ZHEdZ
         6HX/ojx2ZxUsVK9qtrRU4KSKLcLa0CBbUDtPDdtQovnhK9t0F3Tnf+OieSRQ6MhmuOyT
         d07g==
X-Forwarded-Encrypted: i=1; AJvYcCVXMrigLYVmsmFnnHCvj0TmGB9YubW1H4CBzhQN4j53jnmT3tRFRa1jUOqRipxHjrejUHtKwwjNnqocwpN/PFLi0PvkNTKYB5ln8g==
X-Gm-Message-State: AOJu0Yx8KPMTZsedZQVd99bdn+o2fsUP5Q2gx4jQu9ydCDXO2vDk0Uj0
	nfRU2Eso8y1GRuNafryF3LUK6jtHG6xhVmt7SGQMZPiYVCMCzGL3+RqN3EJ+Cqcy/olFnOJt1Dt
	RIUZLCmGHCzTLJlleTve/DjNtmz5QtKeo/Snmmg==
X-Google-Smtp-Source: AGHT+IHkdJx+zFat9qPbr3h4Rdcuck1pBATP4FKcmKR8VS5uJISAam7tCEk56SEDoapPdlF1E/YwhM52Daf0RNngWRA=
X-Received: by 2002:a25:ad45:0:b0:dc7:4313:8b6f with SMTP id
 l5-20020a25ad45000000b00dc743138b6fmr7824715ybe.54.1707820198159; Tue, 13 Feb
 2024 02:29:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121-sm7125-upstream-v4-0-f7d1212c8ebb@gmail.com>
 <20240121-sm7125-upstream-v4-2-f7d1212c8ebb@gmail.com> <20240212222232.GB2655166-robh@kernel.org>
In-Reply-To: <20240212222232.GB2655166-robh@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 13 Feb 2024 12:29:47 +0200
Message-ID: <CAA8EJpoymmOBc3CfNHJKBT8BNje_s2a5uGPde3QHYv3vQ97=-Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] dt-bindings: ufs: qcom: Add SC7180 compatible string
To: Rob Herring <robh@kernel.org>
Cc: David Wronek <davidwronek@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@kernel.org>, 
	cros-qcom-dts-watchers@chromium.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-phy@lists.infradead.org, ~postmarketos/upstreaming@lists.sr.ht, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Feb 2024 at 00:22, Rob Herring <robh@kernel.org> wrote:
>
> On Sun, Jan 21, 2024 at 05:57:42PM +0100, David Wronek wrote:
> > Document the compatible for the UFS found on SC7180.
> >
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Signed-off-by: David Wronek <davidwronek@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
>
> Should have been picked up by SCSI/UFS maintainers, but it
> hasn't, so I applied it.

And it now triggers schema warnings, because sc7180-ufshc has 7 clocks
and 1 reg entries.

>
> Rob
>


-- 
With best wishes
Dmitry
