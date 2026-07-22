Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D5347BAF
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734937; cv=pass; b=jNyK9cJFjw2En7reVLV1u3tCCoD1uityO7AZtpzQj5w3/p/L1Ag0CeomSt/Fhbzwcm/IcMuEdff/GHwgapRQt839Qtim6rrRT9zjH1KCCTLSVHhdzSmuNLW9q/87dCidmM/RgH/gz1WdolBcReWy0ZzUFgwQsVYAAaJO/uciMgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734937; c=relaxed/simple;
	bh=W3qDeXLetR0TsLy6YU/1B34IhqeSacUbQ8FGxwJODhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGyi9DHeBih9Hwo+ucVWP8P42hk/28QKInU+A6lsmnL7EP2mQuKrshBmFjxHSiyDThCLVlm1X3nIuKLAzNE6pLLus8H0Ap4UH7YVauX2/ehGMl6aYrd634YOBoT7srNTMfQ5kubDjgUdYBkSyNRxUJsXPYP/xSYATlEo2NM4VX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBN5a70D; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBN5a70D"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf4c37dbe6so5012735ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 08:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784734934; cv=none;
        d=google.com; s=arc-20260327;
        b=XrIY/yiqDMsjnBtPOStiTq3zXigqe4jq6z96WAPLBUF3E6km8JT4xNjWSSnDvNniIY
         W67U7v/OGzYky1t8ncX+VL7JwpglCx15qVr4Z/iknp5r2WDf8mLymKdixBllcVYSs2vH
         SnCYn7tblM79B8Ug9HDhZcD/DoMiRAF3s4rMcdryk9kMTaiegBAT5oLIpY+StCpoAjzV
         8dKXqwAuuts/Am5S1v+3aodwcjRMT0Odi3OFPRvdvaMxka0ONFvC0VLALZyQqXArAMZ/
         6onpHwxxpxOMjTymSgUtGxEyETvc88sq/DZgL5ArRLosPIXo+PN5VD2B+bM5ZC2T66RD
         0OQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TTqYZMK9fGKKUMNkPtpKKlAD3TWJJcDsNL9MVJWEDng=;
        fh=XwT3QI1GbFpybM06rHf+B1MmgORLvw7kzKLa/z6UYo4=;
        b=Lwu8YklT61t8iuKFWWOP5Z6KV3Xsti25jM2uG6aQ3OxwGTkSsWzQEOx9MkD9CZgvYV
         xzWPahz3yyHEApAbF8dHKeYlfTPEwNcmvIEvDXuLce8zbQqGJ2D5fqI/fPLzbvPYA6/G
         m1dDAa+6Z7adWWah71em8FrkFnB9nIEqt6Cc+MPPeMZvBu4uVmnB9gs7sIKBQBOAoPZb
         YHhc0w/dkBcWtZyUvSDidu61aKQgA2xAZUJ8g+4ZfhT6kUO+SOQn1m4ASoxs1lbWKBg4
         sby6QtknB8HF5UJI10q+qK2bE1/FJednV6JgOlaEZwikVlJOdPgeJ0/N34CArSbTFwJ5
         OqWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784734934; x=1785339734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TTqYZMK9fGKKUMNkPtpKKlAD3TWJJcDsNL9MVJWEDng=;
        b=YBN5a70DYN+rqz3hvYcSOe2EjSnZmgblM9Wa8zzxMtJq6E177b0OGfbhYk8rg3Z8Ed
         lX5k7IIHFupy9vuPmIrT1FxGTuA2TwhSoXjGHFO79SKVvl9f1gaGD2/ApSidL0uvUcLj
         gt55/aw65e0i8mFC8BXq6m5AS8pPi/bWCD8Z+GnfCss7J43LCfAQL39U9ewY9mHJMu++
         QbhcWyUpfYZiofAw3SfZjP7u9b2IbVqgrB6AERnbTO3Nkn85PK+bYQAlhvNK9CUvzIT2
         mIWdveALOEDOg0g2OQxnAiKQHZjca57X7TMN3ugF+ja+/vBFzS90d0RvLVaHYvBaplRv
         Xizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784734934; x=1785339734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TTqYZMK9fGKKUMNkPtpKKlAD3TWJJcDsNL9MVJWEDng=;
        b=WPg8diCkeVoA7iaJcB4YvoeeygkDfz6eYaVYlCifyp7BL4aZQh/1w6dPSWQPrCcifu
         VPm5aeGYZ7y8ZKrMHewlTQVEUF2nilpDNVWEO8UEowOT3eQoJ+Lrce9kg+xH8UDLYr7H
         PmreA0ZTafzYeSmmXMwBEp1ITWFRZ91S7K4gp/yqQfvv28m70mkV1gM+/DXafA9jV6Oj
         DzIOXernxI6zTbzt7kd1szoGg3TKc/9MIhjBp92NNal4pLeHHGbRS0g2EboHqdG3MuYG
         mLwlFjbpqPUqrWe/bshfPmnP6bxk0qVAZbXLvzjsgLj1g0CKjZ7zBD/4GzqoWHMfGRgQ
         IwYA==
X-Forwarded-Encrypted: i=1; AHgh+RoiUuYf62x2e2klK57Lh1xM2Cp9QJeURC2gzlwXIQey3Q2etASViq7jOVru3ONrAzfITVeQZao0YYDQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxYgQnvZ7B0DQp5VpHILMZJB7vNDhd/gXR5Y0YetYPBNwCB1UUr
	G2mn/OTBiG59vRjedocpd/CFTzGG1FpkIvyYD7/kfYPD0Nzbz2fS0Ot0vnF5Mzunxy22xm2bBMM
	DLA/J7cKTz9c/x/zFdFcNH5mZqLUQink=
X-Gm-Gg: AR+sD1233nyVpDvh2aTVmMxrwp8TYJyHUQoQK6vkRCP/+d2YbxiV49w5ti2Gnd56Asa
	+gwaEpPuaNhA5WljWK49qUsBQ+tV0cJ9QWQ/OnGxbfaIFL9S+j82ImuFwbt2EH4DMe+p2w+0Z4c
	A+zW+1iv/kz1Hrg2lNTC+XjJRFxQxWYZBIOExGDUJZdb/vQc0nQ9Dlr4tCZ1bmvNlRZEA4Qd4Uj
	UzB+pNZNcXbhOyY3EE5W5DLAcUuI5wXwCSpcVnGrXub4Uyu/s/zKfaaGeRDLTdWisHeagMq8meS
	Mt7v0I/F2kYAeyXipd1TDU6XoguJ/+frpKy2McpmUCuGQs1SjQ2AXNYx+CKNU+h/b6MyKyRNDVD
	2EQ==
X-Received: by 2002:a17:903:324d:b0:2ca:ecf6:9115 with SMTP id
 d9443c01a7336-2cf802b7fcamr62975835ad.2.1784734933954; Wed, 22 Jul 2026
 08:42:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn> <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
 <2026072224-moisture-gonad-409f@gregkh> <f2eb5423-b5e8-4b8a-9d28-974dc0eef892@roeck-us.net>
 <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>
In-Reply-To: <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 22 Jul 2026 17:41:58 +0200
X-Gm-Features: AUfX_mxNJUq41Ky7nzLh3VQVuQID0gIoN9NG7LbJh_SeLBjqg6uwGAOlwPy3vjM
Message-ID: <CANiq72mwwG6M1=d-UW8CU=R+PoNzZii_mxZ_5=k5NehGP87mzQ@mail.gmail.com>
Subject: Re: How to fix problems with the sashiko review model
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Greg KH <gregkh@linuxfoundation.org>, 
	sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org, 
	ksummit@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:29=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> OK, now I'm confused.  I thought
>
> https://github.com/masoncl/review-prompts
>
> was the source of truth for this, but that project seems to have been
> copied into sashiko rather than pulled in as a module.  If you want to
> improve the review prompts do you now have to submit to both (which is
> getting to be a bit wasteful)?

As far as I understand Mason's is being pulled from Sashiko's, so we
submitted to Mason too.

Maybe they also sync the other way around?

Cheers,
Miguel
