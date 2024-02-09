Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E7839AFC
	for <linux-scsi@vger.kernel.org>; Fri,  9 Feb 2024 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517863; cv=none; b=ItQhIuxnGzI9TFtcvFVk6OcS7Aj+adJHGiXx4KkbpKQxgEQTuG885w5uFoVJt5CqwDNL7rI0oqkCgC3rL9B3n5bdQCzxZtIre9G2SKvwGx/8r9Urqw+nG1HwYiKqUB+itPz9g8pz6w1cihjBAK/APw0uw+TVINIfhax6XdFQmh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517863; c=relaxed/simple;
	bh=QVarPAYcC5n7oy6ys/7qfQ0UVMQyXIdvToF2ttVkyE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g3f6QwISPAQKAzr4y3zCJ2Yb99IaVUHgqjaPnUeA01kDQ6OFr2ib7wvblI46k01qWvU2id52nWnYB8bULBfaH/zcL/FtN7uG5B7KLOYyde3gsTb37XQvczMVGXHq41A9jah73xdAbNfK99Ut+dV+kSrkok7Sb8eOdoc3FpIhako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EpfmhWfH; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EpfmhWfH"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dc75c7f638eso332102276.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 14:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707517860; x=1708122660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=628t97wrZYyhnBGa6SPfseRS05OEREwisnOmsVjSZHs=;
        b=EpfmhWfHIGEW5MVFZQZIgIWLqmUuz0BmZKxHv1KZAQ5mgjh4LxjBzfLCnIGmmjl3H6
         jC6nAaNhDaA2pLzWiJnFp8AZDCNF8SDeolGJgIXD1ZKkCi1bLFvN0ybmYFxD3DTrefJD
         /8JrsXyDY6jAZaEXAen94iWv07JCZD+lcrx4lyXamrsIRrjj+HcKanuIFAx76cSYl3J+
         t41URjn69nzfK4l2Zf1LQVK12+MciUJ7yIg47u+nV3XJxgvz+jk/l05X3JmGExzj8Ywy
         sXJpeXdCGSABJjfUYoJdzNKdwk7mG0o0/3fDsJNaR3JFKtvmJ/8Y+zqoKRHXsE6AR5n8
         F/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517860; x=1708122660;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=628t97wrZYyhnBGa6SPfseRS05OEREwisnOmsVjSZHs=;
        b=MdKZWTw6x2jb8QpNNEpPHYQ1CP7N/AQV/Nq4vSNrdH4zAEok5QXpJsjn/ubvWNam6i
         vNlqyAnx1fCL2yG3wm2qx4K6Xq1j7HjcEOqCXn3Ny6E2oay+xNOgRJC5WCyehdHDf0hX
         n+1MjdPz8JA0whocXajOlYMe2GnYXJhGZRphvSwhVt0YySU37yqkhJk5TE6MEErwO1GC
         E2XARCJMvC0sCLuktnG28HVPfLx2mksbiLPivjgQGZYVcwpTvbutXBtnEXLZh7ZEHhAZ
         WUwrrUBcVYwvuyhq41z+G+nyjNP2GT/+s47DehOg/XulHQIPoMlWx8qu7benDFwPrMZ2
         feDg==
X-Forwarded-Encrypted: i=1; AJvYcCU2xI5rrNUTkA2k0f0rXkUJzoBEzWJ+UQxlOa8K9nmFsKGevM2WsMz/QCsQtXRJJ5LVHrgfO3afRDiVAgGpobyU0BH5tUTTrKziGg==
X-Gm-Message-State: AOJu0YwHmo61nfQ+MkpdhZ0q2nCDcf4uZ8yEh5/CUZGInvMUEIP7H2vT
	jcBmRX5dPVNxg/cpHADOZaAipZxm0dXexv4OMPLpnL5KBz5/kEGOFv+VC0y/aWW2gaYzOw/8c73
	slpDinVh3F2Z7+hPr9ZoEBff9LWqoPfzN4NvjGQ==
X-Google-Smtp-Source: AGHT+IE2UidT0dSQEZFl/DBrLVMTcv/V7Hyr4NbaAg4ASho6vcCFOa1CL/uvwz6IzvxMyHtF7OCOB/UJYOqtx3M8f3U=
X-Received: by 2002:a05:6902:230b:b0:dc2:6496:f41a with SMTP id
 do11-20020a056902230b00b00dc26496f41amr694217ybb.28.1707517860682; Fri, 09
 Feb 2024 14:31:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
 <20240209-msm8996-fix-ufs-v1-4-107b52e57420@linaro.org> <1d67b626-12ef-484b-99e1-d5d6d3571d74@linaro.org>
In-Reply-To: <1d67b626-12ef-484b-99e1-d5d6d3571d74@linaro.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sat, 10 Feb 2024 00:30:49 +0200
Message-ID: <CAA8EJpo2NpiVz3b7PAPsTYRJDnXwLtYX9=kHgj8Sk99dzmh1fA@mail.gmail.com>
Subject: Re: [PATCH 4/8] arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nitin Rawat <quic_nitirawa@quicinc.com>, 
	Can Guo <quic_cang@quicinc.com>, 
	Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Andy Gross <andy.gross@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Feb 2024 at 00:29, Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>
> On 9.02.2024 22:50, Dmitry Baryshkov wrote:
> > Follow the example of other platforms and specify core_clk frequencies
> > in the frequency table in addition to the core_clk_src frequencies. The
> > driver should be setting the leaf frequency instead of some interim
> > clock freq.
> >
> > Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
> > Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > ---
>
> 3.18 says the clock can even go as high as 240000000

Yeah. I just copied the core_clk_src specs. We can bump the clocks
when this gets rewritten to use OPP tables.




-- 
With best wishes
Dmitry
