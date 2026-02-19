Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3971A238C16
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 06:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481188; cv=none; b=L4r3M2CrxHCaF0z5fPf0bXJhO9AdjicXPy4Ju0t+H/Sh/N0b9bkmJk1kns8aRLpxSYyIsCpRTcdFNeAqNPtV2qRGJm8xGuS8IF25Fq6tZwxThxTXPW+LINYSvlhlviP89D+fH3QA7FNh7bOCqASzERJ8GAuo/wnjw07P6XVz4qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481188; c=relaxed/simple;
	bh=gbw86lH9zHcV52bv58VrZvPzxGJBTiMlN+0U/OXGPOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIMjTzKdobX8G1LaimKD1HbPvaLTTTHAIJmOPruR50eoqNWQaXEKLtwuIbZupvF/J0lcs/66Dw367zthMRMQJaNrgifeE83K5QV6oArmMOyuyrS8dJ/zAEfn9QSpXXHVGhFOv+Si4pUU9Gx9LFh8fEYlV2dTe0iAKsGiD/qUL1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pZhlsx4m; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pZhlsx4m"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-482f2599980so6753415e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 22:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771481185; x=1772085985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=boGhfzw1KRhdRR34NLhbsa+Vh9+Xgvok+OeVAzYzW+k=;
        b=pZhlsx4mwCU3xvZSjzdyC8SdDQ8IoJ8GXgEkPGci9w7mFoofwTYJfZ7cLgBkDKOoda
         vktKMGn2tWDP96aWtfVCbHOfRmy3aiBvryBntwFqn36cilZ4C6ovoV9VqMwHB7YDII6A
         vCM4hGZwlFA5nWf16C9Vx1b7XxsjXL0pDfr4m5l8pUmkqiTODog4nHcZvdp7nlPWRcti
         Pah2yVuuY2nV1GoZjP13jM+1xFdZJOiB2ayv0JBuRw52/EZhK+fMvjnevQpPafLDe6oc
         8MDuXcO2MzdT2FbH1c7rQbDUF1I+OFW2BlB+3z28mnvV8H8gGvFjgchVwpWGIJTYUddy
         MZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771481185; x=1772085985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=boGhfzw1KRhdRR34NLhbsa+Vh9+Xgvok+OeVAzYzW+k=;
        b=RqOV9rjxu9AbmnyX3jND30Ucj/Q0ANYxuslT/RV/RI4hofRTDn/5VW5B1pSlZxQkRB
         1FkO76D+h+gILBMTFRs8OpVkxT10e4anoltyibTacco7hVbr1WYUqeWDflZzCNKdIg4F
         Iq/Aj3rg7i3vkR5NwQ2QOCrDJrbQYPe6iAU6WFjOggWOTQjna7Z9rq400ZrPPxgg5bVe
         6v6UrYaIRuXvAGe4zHUp6fdHXchfyuMxr0wMXVLqGQ9sAWtF06Lt4HUmzsdf3uiCHSA+
         vIfVaYAaRWi99CuBz6U3IC5H2IU4C08aAkg3IraHZytOpU/3++juvzuSiP+ypdAU7l+V
         q/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWinM2ntY9mzdNuWbcpyPvQrynHxYs+WSPQsfDJ+etIUPKc4Zv8Fh27jV+a3jGSXtEOwNutw94j93DY@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6DenxPSYAjxHQ6GeQM11IKOagUB+b2PkNMsShhNGhCzA2wqEu
	e5+1JZPVvZFB+QjZIwwrZLX1jIrwg5Q1jHUvWmDRvTNGP5U6WPt/Q8AObWMpVlVNcow=
X-Gm-Gg: AZuq6aIGDfbh7W4RJSMzy4nCPMXLXtRbD/KFYrts1VF7QyP14wq3lDe4Qrsz0kINkax
	4JXUgx3viD77A3RFBVE7l/4JjXuFbyuIYFPphUQLv7Yhn1uAlVDnwp6P5MaxDb7uH6R+PkkOsK0
	kkkDVIndk3SRptmLt8ge9EV+LiNsp7tbXS0o72IzHS2jCPbLiwQNJgzGSnxpbMxlCqKRzfGj/2s
	dhpfq9WilxN2HLjw7VRxGubjlMkKT8E2ELawC9ul1D/cP+drRtON6KqHPsjXedCnqIi8RnsvuBi
	4gmAUGVe88+KEg519FfUOqXMN9I1Y5hGOCoTDtivtgA8B977/VJb+29917p/pmZ5Xu3WIHOG+Yg
	CyDC8ulU2dAch9F4wdXR/alvOo+tfqW9OUA049fiR+y9lSbtxycaXeAtt3a7g1gyQfBz8uOaubM
	Ae9TKeMOTTnrdpCcTYd2/pJiOdf+4G
X-Received: by 2002:a05:600c:314f:b0:483:3380:ca12 with SMTP id 5b1f17b1804b1-48398b79bc8mr68572115e9.29.1771481185331;
        Wed, 18 Feb 2026 22:06:25 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abd793sm45673429f8f.25.2026.02.18.22.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 22:06:24 -0800 (PST)
Date: Thu, 19 Feb 2026 09:06:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, aeasi@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com, revers@redhat.com,
	Hannes Reinecke <hare@kernel.org>, Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 2/5] scsi: fnic: Do not use GFP_ZERO for mempools
Message-ID: <aZaoXRkzyCsGm9n7@stanley.mountain>
References: <20260217223943.7938-1-kartilak@cisco.com>
 <20260217223943.7938-2-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217223943.7938-2-kartilak@cisco.com>

On Tue, Feb 17, 2026 at 02:39:40PM -0800, Karan Tilak Kumar wrote:
> One cannot use the GFP_ZERO flag for mempool allocation, so use
> memset() instead.
> 

This kind of thing could easily translate into a static checker rule.

KTODO: make a static checker rule to not pass GFP_ZERO to mempool_alloc()

regards,
dan carpenter

