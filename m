Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9335E21767A
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 06:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757052916; cv=none; b=G6fdqhZnsvQq/tA8A0M7in3r6O8PzmEIKeR47x2OMOFPB/MKKJBVXNK867H5It0VvCBcUUaACo6B7Z+ttQy0SxdTi5KgKspUKDXNJWotqItRPiSRrJGKULsosVFip6ALmwYcqDcKfqvqnvnW5ADtJJEZXyIARBv5Ux4cjWCip64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757052916; c=relaxed/simple;
	bh=4QB78LNQwxKAsA68SulDE/sw/iH3uDbwsF2AQjDBOCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+f7RlR+KoOpedebpDcwIc883MW/XvUHSeGDU7N4BUysn54xaBf6LkqpEltS2aojMZEJr+L0X50T8Lx922IvAuVSjaGfAPy1n3lmsRSN9zmD5IR0AoWVhdiBz77pmxp0q92ryJyBC7sF9iawb+D0UitB/BKDJANC9UndM4QZSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WCewLAdo; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WCewLAdo"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61c78dc8b12so352900a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Sep 2025 23:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1757052912; x=1757657712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67Fan9f0fhfdCk8yqG4XmOKNFNUAhVKb3cVNbIqGl/s=;
        b=WCewLAdoKtdo8jkGFbffWFrZVuD9nvvpv6EPBWGIrbZwEUUWtItcvNcQoYoaszr4PW
         y4Ajw2DZSXyGk9schrUGWnCguNtZQtN1dG7XbbcPJZ9bQ3O4VCeN9fjFcs3Z3zs/a828
         OR7sHZAUQlRZ/CbaPvFsjDiKUBjIt+MHCW6nDu/ZRZrA5JDsIMQfqw89/bFpupSTMTDZ
         QpO7dkLYfykfvD7j3J08M1LWT9FlZZ+/Zp0PNfCOYFSi576Z+970F4Thxi8F4fMMcpOk
         4WVSkGmKZztk8QAvnBqQuNd/Wc0qXrZdxSRlKGXeYKHtsHDgxfqWkxj3lnNuo7vGUxiK
         CS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757052912; x=1757657712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67Fan9f0fhfdCk8yqG4XmOKNFNUAhVKb3cVNbIqGl/s=;
        b=Jwh++ooTNHIi5MAPFkfj7NCRczIxVwZMGgrTpWaaR14gkgnrBHGPYGsJ6soejAy0CI
         6mRMKKjpOp0ru7qw1zcx2IDMpW66bZWcbQ76xmjV/tO1lU+D5iJbpK+DBa5Ah9MS41wT
         LsmGXiH4nth+5SCsGB1AliUubnyND/UX+8RXJtlfSZrYg+6IkjmhkqND4600RCF2VSbx
         nvB+xFCLXRdusXKiu1SNHEVO4bWYzVacKW+V0gFlhiRo5zZR/uLBmUwoZt3HK8WxOQVe
         1MVVtrxuSbbvGYkogIDHcmN4s40zrbnkCGi20OkAGiyaXFv02TdKSMVJTrWPz9eLXy/s
         6twQ==
X-Forwarded-Encrypted: i=1; AJvYcCUendHZ415mU26MHG7GWti6cw6kAL/bUv5MS/r1IOSkZhbCWK/UlSlBE2w4BVT4+5ut3jA9BtslaAr5@vger.kernel.org
X-Gm-Message-State: AOJu0YxkjtIUZAhtoA29CTVJu2yIocnbCTbWyIreCFxe29rnYnHfhg0l
	lgBvfaADaT1Fv+xRKJD5w6prknHLKcFBhvsU4vQNiT2rOaLz1Tt3elPYe1XfiHYD8qN8N+nZbat
	OUJqgjSIkYzRq3PNt5GV1LU+jFGEYDGqT980kKUp2bA==
X-Gm-Gg: ASbGncu9j2NoESqV84pHE4yPsWasszMc6quQfs+a3C3Wzn8EsHpngqBVkLIXz2EhUmi
	v/MBzaALUmbJYmhqIAKdEtulSqwk/2Q0Sgq7pru2ItHqih0guHWBFI4ftKYV/lCuADf6X2qI5ns
	j9waRp5XR5rheuJZiOOpk8k3YiRSSDX5ncrxeYXH9Mc7NQeuzBY7Gw86rqXhFVhupK16Y8BHn9U
	mcmEK34
X-Google-Smtp-Source: AGHT+IGQxtNMXZdvajLZ7J8QVJRCMBGrRVcTSOlLx1yX827VXeUjk0Y0uoYjfJG3Qk/GwD1+mtNnIEotbRORPtK5gAk=
X-Received: by 2002:a05:6402:430b:b0:620:bf3a:f6dc with SMTP id
 4fb4d7f45d1cf-620bf3afabamr1472744a12.4.1757052911908; Thu, 04 Sep 2025
 23:15:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aLmoE8CznVPres5r@kspp>
In-Reply-To: <aLmoE8CznVPres5r@kspp>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 5 Sep 2025 08:15:02 +0200
X-Gm-Features: Ac12FXzLRYvr9qxSpOLdM_cu9n8ZpiBkps4v2s9lawoV77lRbVRWUjzUv-Bi5yo
Message-ID: <CAMGffE=4KUt2y_-C32YaVtJVFiyU+1T=gnu1D0m+MxXs=X05kQ@mail.gmail.com>
Subject: Re: [PATCH v2][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 4:54=E2=80=AFPM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> Remove unused field residual_count in a couple of structures,
> and with this, fix the following -Wflex-array-member-not-at-end
> warnings:
>
> drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a =
flexible array member is not at the end of another structure [-Wflex-array-=
member-not-at-end]
> drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a =
flexible array member is not at the end of another structure [-Wflex-array-=
member-not-at-end]
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
oh, indeed, v1 is wrong, and v2 is right fix.
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
> Changes in v2:
>  - Remove unused field residual_count. (James)
>
> v1:
>  - Link: https://lore.kernel.org/linux-hardening/aLiMoNzLs1_bu4eJ@kspp/
>
>  drivers/scsi/pm8001/pm8001_hwi.h | 3 ++-
>  drivers/scsi/pm8001/pm80xx_hwi.h | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm800=
1_hwi.h
> index fc2127dcb58d..170853dbf952 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -339,8 +339,9 @@ struct ssp_completion_resp {
>         __le32  status;
>         __le32  param;
>         __le32  ssptag_rescv_rescpad;
> +
> +       /* Must be last --ends in a flexible-array member. */
>         struct ssp_response_iu  ssp_resp_iu;
> -       __le32  residual_count;
>  } __attribute__((packed, aligned(4)));
>
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
> index eb8fd37b2066..b13d42701b1b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -558,8 +558,9 @@ struct ssp_completion_resp {
>         __le32  status;
>         __le32  param;
>         __le32  ssptag_rescv_rescpad;
> +
> +       /* Must be last --ends in a flexible-array member. */
>         struct ssp_response_iu ssp_resp_iu;
> -       __le32  residual_count;
>  } __attribute__((packed, aligned(4)));
>
>  #define SSP_RESCV_BIT  0x00010000
> --
> 2.43.0
>
