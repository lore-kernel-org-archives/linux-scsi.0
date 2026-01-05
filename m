Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EE731064B
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 10:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767608282; cv=none; b=Jit6azPRnTUTEpI3Y9W8NybiGee8PwPSZ/Imo9gyBKj68P5DuVDOweOtrRz2Tq25Ykry42v0o5paaVPDq4Vp2/J2s7dwi3YhvYGUecshQPWz37xAp8MShuGb/ud/JC5j9ix+b9H8SxpxvypCjzJXMIEWg7spfjBpAw67urb2nYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767608282; c=relaxed/simple;
	bh=NyXaMzDErEA3jOKkS6g7KIPNUYJqH4kB5dkra/tYLyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XErSia8GQbiUBnF5vfPyx1U/8uy7UeXQaRGuaSn8Sdl15mMGZBpWjUA0FLXzVwXp2A5cvxc48qSasiLEPgZXKGcVoXnQpQaXQEzoWglDah61WAi0b26ggX73p4A7BrgYFfNf3lYyzvtVNlpl4ABfcjtDdiT6pS0e1Fu4lLACIls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r+nB8QZV; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r+nB8QZV"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so11340346f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 02:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767608279; x=1768213079; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VMXZd0k2gZxn0kgU5s3lzwvKxk2LyOp4km2h9OrJH7Q=;
        b=r+nB8QZVDn4QauAWQvOzwAr4PH/K8EOtelqRKDJGW3qwdVvMn5cxsXsmnrrqWKmAeS
         sFyFFGtPjxFeQKkBuorQKDsSW0V+FaaIYsh6Fs607zMtIFqDbVQMWBdM69iZ7/0N7OI4
         pHl+DUKJ7uzEIjAqddBTYJNrY2RCZ/ZerZDjhwgfp0KO/2BmxqvpsNmnA4Q9dBM7aqnS
         fbwCouy3EaR32n3mUYG1zwgYbekKuz+Tg1hZwZLcTZRC2Pj1BqTyiBnPx+h7h+ARK4jz
         0puzKQ0aXeiTlV3YQtpfAlFhGMZ5qBZiPzsWkfVozfRuPRQqjkkZ9bydiKFgDWRvZOWq
         +DrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767608279; x=1768213079;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMXZd0k2gZxn0kgU5s3lzwvKxk2LyOp4km2h9OrJH7Q=;
        b=wOvkWfca1dDpP97/5sVqmhoQIdIvkhGk4I661xceeu5e1mR/KfteeCHeN690/PP7PB
         MFL0nviwBrFJ67PIFmsOzdBRFORziNIS4tFfInbHaKAZ45+/YQIbK1SZdP3FWMv/8ED8
         T3ISlDl9v5bdQsghijQtDs5aCjOby1HHmg6NXuWuNKmVfbn52pvsyRz2ZSBBKraLpD3t
         UiSYnPQ5UyiJPxHq5g6iSW5Jpb9NCJm+CN84aVBwocMIGEBlE7eyO1+e27Im3IsAnAab
         0MM4b+Ov696Np+7SXx/dVnSGxASTpS+qAqhkGz5hwLjqUjcX2oipItjltHC0URo2ENbD
         b1dg==
X-Forwarded-Encrypted: i=1; AJvYcCVHNgZy58m4k5xWeckdDW+3RVgQpyIpHdiEXLfZTi6WU+PsYEOFKTOhtp3jFBqgvy4NL7RwSgGPIX0Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6sLmp7bGEIOfTHhlHnsJCpoDQmGJOyLPo32GiUVreuH2vwT2E
	r++y6I3/yyOeok1fkJXCL8runsSHUhZEOiZh9cD5Y5hRfAl1wUJlyjJVrK8ipW6Ea+o=
X-Gm-Gg: AY/fxX7+3TCdNxbqWDqpz8ntA1bX9z5RwWhmB7ytK4Gztj/2ggCo5iCdlhM61EuWFJZ
	uM5k1OIsPQ8qHIyg1394/x/BKny7YVLmmyTlaCK6sKijJUs36iAg1AUZyZ2igWC6yhnrmeZA05K
	CXHhFT9JxqE8viZSDc6Bare8qGQ7OQf7baKV1sE9vnRqs1/9sYaooO7lSWErEKmBn0Jy3ndHqc2
	kYXsl/g4T1Pq0Yh1RPK1qexLtTAiDfOkFjLs+2H15gC1blu5jzPfq8jfYnSy2/Y4YUnp2aWYTtE
	astFXyRtVHrGEW4BH8bLUTp9slBZhiHGr7op5lkYLDXu4k3PFmxnKYjin7jJy6dUJGjsAM022bj
	pFbsgAnftuZaDuiYX3dnuGdvsM7lQobEzFRz+RogCbJ6CVwB+N3s3dg+Q7/sGtW/j9RwrHQayFy
	wDAYXfK3c+s+Yf7oqu
X-Google-Smtp-Source: AGHT+IEkiG6mOIxmE+qAmWBQCXghDrypzkvELGSywwjbqNdPJFgJnMlRBOP7ilekWub2UAgbWww8Tw==
X-Received: by 2002:a05:6000:2c01:b0:430:f62e:d95b with SMTP id ffacd0b85a97d-4324e4c9cd6mr71242039f8f.15.1767608278863;
        Mon, 05 Jan 2026 02:17:58 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4327791d2f3sm69077587f8f.11.2026.01.05.02.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 02:17:57 -0800 (PST)
Date: Mon, 5 Jan 2026 13:17:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: markus.elfring@web.de, James.Bottomley@hansenpartnership.com,
	jianhao.xu@seu.edu.cn, justin.tee@broadcom.com,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	paul.ely@broadcom.com
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix memory leak in
 lpfc_config_port_post()
Message-ID: <aVuP0lJxn2pc6cNa@stanley.mountain>
References: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
 <20251230062008.1021449-1-zilin@seu.edu.cn>
 <aVuKJPNjNyt3_yEV@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aVuKJPNjNyt3_yEV@stanley.mountain>

On Mon, Jan 05, 2026 at 12:53:40PM +0300, Dan Carpenter wrote:
> On Tue, Dec 30, 2025 at 06:20:08AM +0000, Zilin Guan wrote:
> > On Mon, Dec 29, 2025 at 10:09:04AM +0100, Markus Elfring wrote:
> > > …
> > > > Fix this by adding mempool_free() in the error path.
> > > 
> > > Please avoid duplicate source code here.
> > > https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/scsi/lpfc/lpfc_init.c#L563-L564
> > 
> > Thanks for pointing this out. I will use a goto label to unify the error 
> > handling logic and avoid code duplication in v2.
> > 
> > > See also:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc3#n262
> > > 
> > > Regards,
> > > Markus
> > 
> > Regarding the stable kernel rules, do you consider this bug severe enough 
> > to warrant a Cc: stable tag? Since this error path is unlikely to be 
> > triggered during normal operation and the leak is small, I didn't think 
> > it was critical enough to bother the stable maintainers.
> 
> I don't agree with either of Markus's review comments.  People have
> asked him to stop reviewing code or at least to stick to pointing out
> bugs or complaining about style and grammar issues but he doesn't
> listen.

I meant "or at least stop complaining about style and grammar issues".

regards,
dan carpenter

