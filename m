Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DDD1E49F
	for <linux-scsi@vger.kernel.org>; Sat,  1 Mar 2025 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740828546; cv=none; b=rB7La1KV74XjsfNr3vLKHufM0hGj3VOFOg8SeCSaiBE+z/teGSx8zBOCRlvtPhrIm4G+lI9eBEdEwxx4U91prwBzuDXwiT/UEJRYO7/vgsVlXmsqn8lhK974snic6Tpd1wsplIqUFJd39hpZuuKx2rybspLt1LbQnpdNSubYIQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740828546; c=relaxed/simple;
	bh=E9DujR3IizOT6sbv3rY7g2iXJ9du8KJP7l9vYi2xhUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hi+x/MI3OBekdRJao/iuJSBcCYagCy9jEUHfp2Ccix7fhbNd3HjSGpZvOZRN9CaRhHGm2+dvL172YzEbLracVP0d551sdJJsHsxWELmtf/G6ZDjdtFxF1WfPZJfnw0/tjffn6GlQ5kUVn8Eaumgk4biusj3rGn7lXJcAKQz1Vrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=prGAcD6k; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="prGAcD6k"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abec925a135so392464066b.0
        for <linux-scsi@vger.kernel.org>; Sat, 01 Mar 2025 03:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740828543; x=1741433343; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhzJnfdycFMueoTPI5BXB8D50gcLoAdCXXuIai65Q+Q=;
        b=prGAcD6kwhreyqaQAREmdznrao895DvpGog1nY/0aYIX0iGVF+8mKpYPvATUfeNffu
         NZbfMM5GEOlCu/QhXQUhBB6diLIcblSsx8vXDtY3861Likecw9nahxy+e0IRnMR2QfsB
         pfuRtMaAICBt2Bksgav748AUNeQ4FCbA4fulY5a8AVMku3VjGPL0L/lNvRexHJVwrIMU
         viBM0/iomcD50VD9qj+QJ3TQCXCprotVe3GCoyUIWSIglJLgeU0e0o12OFcn1bT0kpeD
         r8xEgszUTztQcAOiV+HSEPu5S/+B0evNMtA2JF3suyJvlW0O8vqsNlgEnbbplExkhpJI
         iIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740828543; x=1741433343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhzJnfdycFMueoTPI5BXB8D50gcLoAdCXXuIai65Q+Q=;
        b=WJI4WElZXeEsrERhfu2TZhysQzA1B25tZR1J+4scgtX9oTz6xvvydeYnGcyg8/MXNG
         UeVIxut5PoDztDJoE4aVZYESmJR+3wUpFz4B3o4l5aK55b6c5HrtI/Q1MqoQA8cKdrvm
         G+ldu/ORyl2K/R9OoOgPDHSZoqyulY/sa/p8oDa4yOOM0TSNXucAo23l4TYLXrSxUuhW
         lasvvun/lWajomQ/FuuLjOqsBrUUCCufsPRGuj49b06UAC7ovaZC+4BVz/lXRDqRevVp
         az4nqmXUCuSv9JWaKBFPbTycnZyXJpkjjSebjAV186pQfgzGX9Q/MtY5ylO6HvcKmaja
         PzgA==
X-Forwarded-Encrypted: i=1; AJvYcCXz5xHUMIqQqmsnTfhQxGPFRNVdgz7Hw+cqbeK3wj4fF/AYgePTMSvGsqLpNE2fwKzy23FMTKQ8nQKb@vger.kernel.org
X-Gm-Message-State: AOJu0YyNRfu8BjtumvKC0rCBozGh825lrEZ4pB7g+7P2zUFxErlyl7VN
	e5q4FEJgq7VimkapPPTu/cG9F7zLP2+q1IFnfR3axn6z3pw3+vEtKLxyubiPqOo=
X-Gm-Gg: ASbGnctrEJZhViXNGVIImVHSdTxBvsGGh/r1ftGhDkymgGWqIb5HKwCQzzgI5IaLADg
	+TAYPUaMys1fEp17TxJ8Axkc7aux1k/M7vEagqWC9o75yYeKm8WBMsdtRK+w4PWloWw6LeiyZNr
	lxWKz4GIRl39jXRwaDydC2IjKlYwF6DS8Zf8+k4ZEV+IwHg8wfln5Bae40HWo2lCRiaHOG15p1g
	ICHsy1sAARRRVnY7Ue3NvOFPrvTBNrKE6BFKSgQS8fgAGy7ri91SwQTHvUz43gg/bmIlIXVjwqN
	BY8I6/9Gy1zEVdf8yq3b5TU+/4r/hBsb/IpEpr50mwWJPnFw6Q==
X-Google-Smtp-Source: AGHT+IEmtT5UDlv6mGlToR9LRcWyhK4Zao/oqUAxcObLaZwH1AUk9XBYd76/u37kZ+ts9n5DOSxrLQ==
X-Received: by 2002:a17:906:26d2:b0:abf:40a2:40ce with SMTP id a640c23a62f3a-abf40a24533mr409191666b.31.1740828543140;
        Sat, 01 Mar 2025 03:29:03 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abf0c0b9cbfsm462821866b.14.2025.03.01.03.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Mar 2025 03:29:02 -0800 (PST)
Date: Sat, 1 Mar 2025 14:28:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: fnic: Remove unnecessary spinlock locking
 and unlocking
Message-ID: <95135f06-cd1f-47a3-8253-c4275e7a5c3a@stanley.mountain>
References: <20250301013712.3115-1-kartilak@cisco.com>
 <20250301013712.3115-2-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250301013712.3115-2-kartilak@cisco.com>

On Fri, Feb 28, 2025 at 05:37:12PM -0800, Karan Tilak Kumar wrote:
> Remove unnecessary locking and unlocking of spinlock in
> fdls_schedule_oxid_free_retry_work.
> This will shorten the time in the critical section.
> 
> Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
> Changes between v1 and v2:
>     Incorporate review comments by Dan:
> 	Replace test and clear bit with clear bit.
> ---

Thanks!

I'm not really qualified to give a reviewed-by tag to this, but it looks
okay to me.

regards,
dan carpenter

