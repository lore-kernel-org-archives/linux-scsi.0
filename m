Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D01A38D7
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208400; cv=none; b=u0NH7WbRAN01cz2PNlglkSm0wxvCi46FQv1y4vbN4NUgv86EfyVZOoWAIv/7OeHXGeiAKDc+IZVi9o2L1EBn92wrojsdoXp4ggRO5T3moT7UU1FKlAfc6e8SN8PZCBc5CVrI1Hm0YVXY1hT4M+TzIYXlVPMabI7K2lpbvGJEOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208400; c=relaxed/simple;
	bh=qJI7JAC0Ed2camEWXFgqiWsh+z80E3RdsXM70TPSvcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nktuTrAPTc0mgpTPrVshMO5U2tOYjGw7FYE/lAJlouaS6hgsACq2XXPDb96AgT9fFcPxcyJM9Lz6AtrGtKF8xZlEBzAeS5WHCP9KhKyrKROlvqMt7hPCmhbt0fjAHhotWTqI5ZhliU4gPoRd2F1iKX5H+LYpvzMF0ZCZJCtVoSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KVE8F+V/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KVE8F+V/"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539f53973fdso1033334e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 08:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732208397; x=1732813197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kWmOlhAyvLltjxgfGITPOMja876WfWZzWl3k645acc=;
        b=KVE8F+V/cdPKTlWryJdccPU8fok3PgAhRHpyvS/S6nxWDqXL5I4d4eKXFWuas79cDa
         VWgTVDWZxy2vo83zWJcueTyC+ZRHlEyM1uLJI68FCDR7PbX87z4ZH9amUkREb8wSeFEJ
         ut6D/h8npNnC4Ai1J5jBxSoQQ7XY8uQqAOjWGFUamv3eLY7RIn9iVrG76TrAquvVSEKF
         OaHSO1eJ7eo3iUqdZ4h+KJRjlrpmZPhbVqDGktDGM3WmCQSDrKAoUiTxfzFr6SdjPIZV
         atdR6EuFDJwQjLN3ufyy/P3t+s/MyCk3BgsO9nygxoIwM44wISfdm2pbHXkpiYkS0XTk
         5ilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732208397; x=1732813197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kWmOlhAyvLltjxgfGITPOMja876WfWZzWl3k645acc=;
        b=CKv4ljyC5gC5tJ9YuWEKjaCaRK2dCYrAHAaqKzVMhmt3WOE6arS4/jlhInpFefuLqD
         +74nZpgajqrcc4u02Xa3yWQFVFD8NZMXIlniz5mBbxp0FSTQuq852L3Tp9LVmogZDiSS
         DORnUB+np05Nls4UyzqunnaIXc8XRb4lwUIJFMJNPyCDgPe7EyxBXXD0Hj25/1teWL7R
         hvPfwZSQFVus3rEj9HgsZ2y1FMX8WsV9XIGJopdYDmIRWPdG06zmVWn7WWhYtx4is2aa
         GMtDm5RHF3SOaAHWm8CHKeqCq64yNl766jQQY5laf7+ZvNsuJXYIBoDceruvc+uZ+Bav
         c1qA==
X-Forwarded-Encrypted: i=1; AJvYcCXnaDkZELGeLkoCep07LCWcZHvn0+neagqrweX5pbsZLU0MC9IzFTNUcaq0yyxCc8XR17Nl4RhbS30s@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa3LDzHlFWE7E6p87uGipmK5OKDzedIvAH+05iXqth+LQ84tBe
	6DoKk6ihd60ViMZeeN4Sqv+F7tCl+g37NpRO2AZGU0Pr+9RVD//PPukWIJL71+k=
X-Gm-Gg: ASbGncs8/6ph3p89jhHmauAstknEFNKwepONpNfW+AB0icsGaccSMzjcrjWtwiMZUa9
	pVUvjDvqc6gbbFY2A52MGlmdc9Q0I2aJgam8Ky+xWXOBvlNxKdLcWWHKk/I74JrxevTnwPQwvgi
	UIji/LQ2DDPDasGiVmV9OqQ0uEbuGAEGibDrperBjoPt0iGduUAzxHHFzgwPKr4kGdhzd0WwwK4
	t9I46OzNQYDHxBmV1AQAvrawFd1IYm8pHAKQpCuRW2tmbACl6Fz1ohQu79LDF817QB18qRA3o7P
	/AvXHLsu2ICWYzBYcLbuRFmnJwQesw==
X-Google-Smtp-Source: AGHT+IGL3c3ho7r8sF8Xcr9a+4/C/Ler4BcrWhP6ykFH/IDRrpCDlTkssOTbniD/Y/so77ORXxYebA==
X-Received: by 2002:a05:6512:3d18:b0:53d:c861:38a3 with SMTP id 2adb3069b0e04-53dc86138f5mr1426353e87.27.1732208396862;
        Thu, 21 Nov 2024 08:59:56 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--b8c.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53dd245186dsm16381e87.100.2024.11.21.08.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 08:59:56 -0800 (PST)
Date: Thu, 21 Nov 2024 18:59:54 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Xin Liu <quic_liuxin@quicinc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Andy Gross <agross@kernel.org>, linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	quic_jiegan@quicinc.com, quic_aiquny@quicinc.com, quic_tingweiz@quicinc.com, 
	quic_sayalil@quicinc.com
Subject: Re: [PATCH v2 2/3] arm64: dts: qcom: qcs615: add UFS node
Message-ID: <oikbuo3anhiifydvzdsjazbdwqqwt5ssi64sxopjrdiryr5r3y@igj3gzan4ks5>
References: <20241119022050.2995511-1-quic_liuxin@quicinc.com>
 <20241119022050.2995511-3-quic_liuxin@quicinc.com>
 <4bf9ea1f-4a45-4536-82c0-032f72b28807@kernel.org>
 <f5b40d0c-defc-4b91-9313-9e454af22fb8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b40d0c-defc-4b91-9313-9e454af22fb8@kernel.org>

On Thu, Nov 21, 2024 at 08:41:53AM +0100, Krzysztof Kozlowski wrote:
> On 20/11/2024 17:58, Krzysztof Kozlowski wrote:
> > On 19/11/2024 03:20, Xin Liu wrote:
> >> From: Sayali Lokhande <quic_sayalil@quicinc.com>
> >>
> >> Add the UFS Host Controller node and its PHY for QCS615 SoC.
> >>
> >> Signed-off-by: Sayali Lokhande <quic_sayalil@quicinc.com>
> >> Co-developed-by: Xin Liu <quic_liuxin@quicinc.com>
> >> Signed-off-by: Xin Liu <quic_liuxin@quicinc.com>
> > 
> > Confusing. Who is the FIRST author? Please carefully read submitting
> > patches.
> I retract my comment: It is actually correct here.

Yes, I was also confused first.


-- 
With best wishes
Dmitry
