Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D1E1B87F0
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 20:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868461; cv=none; b=iO0Y85r35VrZp/nAiWiOsmsxaDVl1n0Ws1ytxChlGiTUFfgf3BGxEJbIWUC2QquoK97x4iTDhCwlibHPhE5xHB26tH/BcpM7EPmPZxqG9i7AnQ+ggxYVXbhJ3RE+Jyht14paYqbMtlku1W3oChXqNY6mgaBPv3Bw5flSoQltuo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868461; c=relaxed/simple;
	bh=y/TWEe/aEhKr6s5KMRouLoYYcgI2epSiBagA6I5SO6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EwotZlZgxUVp09DkTBidfoyzQ9wg2hwW3hbgaxBwVKxkP62T1qvAaXPQbzll6Onf2YTkL7BZ0U1q43C5ei72Wk2afZ+wptyjXr8ySwl3WKbVtacU2a9GcBNDVv85s2Wti6j8ueDKcOx5jyOqwp75Ab/uE/tNNKpvlk4l62dGp4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RcGQHjzb; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RcGQHjzb"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-649a715fcaeso1711166eaf.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 13:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759868457; x=1760473257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/TWEe/aEhKr6s5KMRouLoYYcgI2epSiBagA6I5SO6E=;
        b=RcGQHjzbAGRrHPJEr+DWLdnoU2rfxNB/1+f3jUIU18Wqm2hO8HXSWKM+968sr974mI
         3AqSI36AL+0qpZJk4af5xGb6D5Ualc7Z/184RZO1wKK2PBy4q/AZA+dYeSlVzVRUi4bE
         8K+Wjz32+OoqjvYLmNlbFWlZ8l1pfb2J9B9/l564MgZNB+onHkDww4gyk5uIG4yYL6Nz
         15llv5nLVFN5J6pebfOFyq6jFrLKHiJATlW5NzHcc2JNmHx7fd4FEdJiJn0lLXiD9yLM
         QkT+bRjKQjSXpa+eJUNFj0eD7jZknplgpJT1boL9SV2twmRFJ9Fo1SRs2bdUC6rBlpNC
         wkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759868457; x=1760473257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/TWEe/aEhKr6s5KMRouLoYYcgI2epSiBagA6I5SO6E=;
        b=FpilLl44FU/BURCZKm+wYmzb+QgIcqIUN0+VToIsdQ/q9Yil3ZXjWTUITly+3zH/5p
         Ize4BFjxX7n6Qc2/joOFZJ4SVxJLj3mJFQWojyDfQ7xntYZ0KxXXnLziskh2frFkDy+i
         V4x4khhuvt14GxWhb2vCgctBYbOIBuSZwqljdCVdxzyNy1O6SG0FItd6b1QipDfa1QTR
         h0S3/xzF84hWscgsRNjvYb/JjOLXPBdTvx5cCGRcProNqe+m9Xa4ZL9y4CnyO4WcVxow
         VxXXRUwSn0eNvxjZSLJmULX7vpuFGZbbFyAgSqg3WAUH4+nq2J/dQq7y2AeCTqireYhj
         52ZA==
X-Forwarded-Encrypted: i=1; AJvYcCXRdzgYg2UW7q8t7wbLfTwu/uDnlO87UxtTX73vux6wf7wkKlNZpmLSsEsEhx6xhafSI8Yg7jPccP3r@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+yazywWeY1/1YrOhCmTg2cWTWGfmojMVZpvXapkxU9PE72Hg2
	C6EjzzbPFeBMEXNjOd+qqnA+vim/dXHVfvYgKzlNbh4InSpv8bdH0JKPRlIB99YvWcsxzSFNUFE
	uHRTrKYiGWUQl7SV4Qv2PnYIdKlJ5gdad6CusQfuyvg==
X-Gm-Gg: ASbGnctifszIragdmg6gAr5xzDNfpw5nCSpJwgK7pjDieCOIIQz6HQqakB3/U5ht4vF
	hf/XHUuGI0FbFXQ3Nzn0QryeTmrwhCif0w/sBQzDbGHevJlBcVn8EHgAYZufJrYF25owEFCPagP
	8Vm4qza5U6QTaLqdj21pp7jGT4ACtiFmFQZya+cWlN2AaUfh6o0S3t9vlxsHNjJI4haRqjm6I6X
	LrzUmlriNpO4/QZU3TakcRsSdk+n/+auJu1iw==
X-Google-Smtp-Source: AGHT+IEyLeFs/tZrPpe8u5cykgOumU9CrjJh4fjO1Ik2uE9eU8H/ZkZq/fUMlKIiW99d1ig/gW3IYGMToD+2pUB6yiA=
X-Received: by 2002:a05:6820:4a14:b0:622:1a4c:ca84 with SMTP id
 006d021491bc7-64fffe46c1amr372637eaf.3.1759868457494; Tue, 07 Oct 2025
 13:20:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
In-Reply-To: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 7 Oct 2025 21:20:46 +0100
X-Gm-Features: AS18NWBXzhclL12SN8KyOZlv89Zez5Qwco0h5Y-fiwtfj-_OtAAbqpmFxHR3Ve4
Message-ID: <CADrjBPo5F9H3BbxBBQmwmDUFnzibnH4hNkYMPTknOn8ZHH_Mwg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Tudor Ambarus <tudor.ambarus@linaro.org>, Will McVicker <willmcvicker@google.com>, 
	kernel-team@android.com, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Oct 2025 at 16:56, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> The UFS controller can be part of a power domain, so we need to allow
> the relevant property 'power-domains'.
>
> Signed-off-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
