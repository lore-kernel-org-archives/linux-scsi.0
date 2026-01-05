Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2557A283FF5
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 09:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606827; cv=none; b=Tp/CuvndZVjHSrN5s/zIp5XcspYotu6/WGwmCCFYjMw1EnIVl4Lk1X1E6D5NzZvjfWWjiaHZQAlXCgyZ+o+GSKV4JwCZg3/JjeyHRKg7SmJXXBgyuufvKxUYOQWQUpJ3gmRV4pakPR/rQcFH69D0aWzUBkc7bVymx4cj1xrYrZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606827; c=relaxed/simple;
	bh=JYCjSlwgfps6QXKtpDHggwUF1W61UlyY/X3NFqWnja4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWBQ4Eu1swpnA9YiKPdXN/EjtADK36ekF1rea8PztUuWE7HHNTHhmN4McWb5beliTi6ynZ7xcU4oVBSBTQ45hdKQRhcjwPD/SpMd5h7mZSmOGznV70E3a7D4i82yfL+7HW5Pu0BVD5F3S1FKbgElydKGVHMRVpbU3Kt4AZFEQTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dZAcJ0Xi; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZAcJ0Xi"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so103536505e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 01:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767606824; x=1768211624; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CpKgGSJ+75221h6VW5t4CNe4ZqtY9MVAIQyQca2c7b0=;
        b=dZAcJ0XijEWhAhHRBc+ptrpKijEbUiG8pQuLzZM0bzQI08MtcWbdx2Q9M0yOf+W/8G
         0CnQ0bmCsQc1jUjoelEMvIYUzHFatEgZvhM5HqlYDaWNk6mg+E7k2wlPK0S+TL/SPNVf
         Tj7x/0kUqXbdl6WgO3n1px8Dg9PeJWdXb1f0PyqaF5ROhn1NJeQabB9f/eZnTi15ZHET
         Y4BP4VnEr/9j3jFZUNdnCFeg2mqs3ifRja8pY8ba3IQXlCLYjtW8oQcJflSuJgzmwMCw
         owR9N33hZI4f2FjFIsWtYmbw5nqkTrBq2g9KPsYc7G2KkqF1pka4wsmEhopXc0++eLBW
         T2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606824; x=1768211624;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpKgGSJ+75221h6VW5t4CNe4ZqtY9MVAIQyQca2c7b0=;
        b=bsH2x2ugomMAcYaNYPIElU5MXh5SasoquoEOcjKR6BMhEQKblO2JnpRvbDiHQCwBAL
         UJL4lxaR5B42NHZlRE6hRbQ/LiJJGid+BgYufmVfXPXskSi9PctlHHgaw+QlqgWRtenh
         Z7oqTniLhN1cGfuV33ZVDmRfwOdYXVAsteE0UH1hneoy6TTbPfLf58maQ05MsW1nhDHD
         v1hdzt00VQqadYjUZPMdsEPVerWHsDQr64hK7cifXdfKvuHkXxAPtWbWX+UGlQ2UI1Kr
         DxEQobCe9a+pWTAq1Lq0m3Ht2lXH7KqlBkFo3Qak/FW6N97RasP0Vr3UDbHqjo2E4xi1
         wdrw==
X-Forwarded-Encrypted: i=1; AJvYcCXw0GWe5AR+GB9boEW3a9cJfYpKFnBtrOcBLUIoTqYEOS4rs9KU7JBVUoB3nhFJKXbKxrgu3uKxGdyK@vger.kernel.org
X-Gm-Message-State: AOJu0YzwMKPgDRt1BGJZDcRSlzfu2Crp6Ha48RZSGM4a4F/VER7JrupZ
	rB+tcdil41NZ5tBCAkb/0LrSO+8CGZhx7w/17duzTTHbHC/LN6xDGd7+tqly/kqLQQA=
X-Gm-Gg: AY/fxX48MTXe4DWCNSi3IrjymvumgfU0JpbAPh96E9AkaYyMyClOW9UOxVFE1XOsl16
	HbNd1JicrC2tJAKtMEV6Z1ecXVzokW9y269eH6s2NSyPEMM/u/CA7OeVlRaQiSe6H9OSxT2SFHi
	rJ8C6qQXJou5xo4NcMPl/B5a9qrbFZyvq9ETJmgya7A/5RccEcD8yFnU3pzszyTh5bx4iv6fmxV
	RhjMbZP2uW3Nk+SgqqDDs8YlYhW8i/Dr667JohcgWXAN3dJ3sp3G6eOjbFlB9g2tktHIdRgUM8r
	z/A6iL/cl1jmrWmsvewYsMz4GkX5MhbAtHK8Yhc6JoESxnjV6pLf+uPzXK/uTxJpdjKP3nb8Hpf
	BIgvoE5rsn3Fga4dS6hmrIp/Nmt6XfxNuiJ7I+8u8MyjGki2Pdq0Vtx4R0egkxx8yWbfy3zplRT
	YK3wlCY/IcaBhLGbMz
X-Google-Smtp-Source: AGHT+IHXrwODx43asw4XDeLwpdA69n/5YpE0Rwx18F/hMfT02cBwBEbmvIVlCR9Igb4Sdc+Zx1GaSw==
X-Received: by 2002:a05:600c:3555:b0:47d:649b:5c48 with SMTP id 5b1f17b1804b1-47d649b5d5bmr189572735e9.36.1767606824441;
        Mon, 05 Jan 2026 01:53:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6be5a555sm56806025e9.4.2026.01.05.01.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:53:44 -0800 (PST)
Date: Mon, 5 Jan 2026 12:53:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: markus.elfring@web.de, James.Bottomley@hansenpartnership.com,
	jianhao.xu@seu.edu.cn, justin.tee@broadcom.com,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	paul.ely@broadcom.com
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix memory leak in
 lpfc_config_port_post()
Message-ID: <aVuKJPNjNyt3_yEV@stanley.mountain>
References: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
 <20251230062008.1021449-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251230062008.1021449-1-zilin@seu.edu.cn>

On Tue, Dec 30, 2025 at 06:20:08AM +0000, Zilin Guan wrote:
> On Mon, Dec 29, 2025 at 10:09:04AM +0100, Markus Elfring wrote:
> > …
> > > Fix this by adding mempool_free() in the error path.
> > 
> > Please avoid duplicate source code here.
> > https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/scsi/lpfc/lpfc_init.c#L563-L564
> 
> Thanks for pointing this out. I will use a goto label to unify the error 
> handling logic and avoid code duplication in v2.
> 
> > See also:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc3#n262
> > 
> > Regards,
> > Markus
> 
> Regarding the stable kernel rules, do you consider this bug severe enough 
> to warrant a Cc: stable tag? Since this error path is unlikely to be 
> triggered during normal operation and the leak is small, I didn't think 
> it was critical enough to bother the stable maintainers.

I don't agree with either of Markus's review comments.  People have
asked him to stop reviewing code or at least to stick to pointing out
bugs or complaining about style and grammar issues but he doesn't
listen.

https://lore.kernel.org/all/2025121108-armless-earthling-7a6f@gregkh/

regards,
dan carpenter

