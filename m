Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9459F2F2C70
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 10:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661023; cv=none; b=u1nUbxDdSIsTyZe2uyL5g/jnspBop3PWwoExGSCoAQMYOSKEymoBqnI3tGItC6cRthniqyscw3JPlmb1QTqO+pBRjXrP0kkBHNL2Ui+zstxgZ9c4f0rYqzNvPs067yO1UwcQyfb9SDccEUJ8VkSqz3XoTyhuvWHAIyWMKOkkUEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661023; c=relaxed/simple;
	bh=GwY+ydg7QNO8ffgOhspbvFzuLK5V0VJeLu7G3qLFQ9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nA+7kCxmuyTsTJpmU0JEmZy1akWGafNc7ZQS9xjwzz6N+X5cwTj9hWdwT0sEZPCLTbNaN3da6zPbJBNQokrzh1TI+GL6UY6ZPMfEmvkYgxOO0VWFuHTPRRymi3ISVFyCHP5k0jgGufZVFRZhAPNbA8neJuk1pDBX6oRz7eMIlFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vnKajPBD; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vnKajPBD"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ff8d43619cso1474041fac.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 03:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752661020; x=1753265820; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GwY+ydg7QNO8ffgOhspbvFzuLK5V0VJeLu7G3qLFQ9o=;
        b=vnKajPBDLQoJuBu1wcoh4+9baoAfoU5a+icFk2HgcdAex4DqZ9wDHfdX+9M36A1kiW
         SzKTA/rZxtjh2QTarg7+OnKAE9QI8tLwAxlNs1pxxf6WX7MiwN/2KbVJzcNDfaaDrlMD
         KXy5fxIr25qFFDMjYmowwwazpUkLadav/fkNKIS4lsB6sRp+cnOVOt57e8rAmFNDNTN2
         60nGYg0+S4FGRZm/Q5bpSpQOwlkimsVoZ2WPAiW3KbVKylmEqIG6A/9kqftOcuXhE+xt
         BKnHsj4F85pQBDLzPvG4sJdIWqNGKBO2ed3TRdfGxj8GuBxTcIzXfZdowU4Xv16/VW9X
         mukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752661020; x=1753265820;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GwY+ydg7QNO8ffgOhspbvFzuLK5V0VJeLu7G3qLFQ9o=;
        b=kRiTFARDhd/kp5WbxZbtUgVHMVTUkC5EYORNmDCy/VWCey6Lv65+EaeSr7McxZ7S2X
         hhvwSUofNjsmS8sKtR/syCe/CbhSgqRJRvdUOygGTuDuaikU1vzTBWsqS7WvkLHCZzvI
         3Ci9ZWcnpkUuP28AiAO9iHe/2TZze2gTfD9+6FVCX8Ven0ZKZshXnsKFiliI97egB7qS
         UW+sLGpwBgxSLuVaxeqy2hFYY/t3V96D0k2R7KgaSD7k62NJpAcux8doYnWd0p/5+AIT
         c1l3+f+JVOjhJZ4LsFK1ljmz1J55VRi0Y6+y+iivz4N5wXE+iS3u+k+njp8oM21TdOJ4
         u+tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl67gZ0fXqPDuxX94GQVDcr3Zrnkjd0troe11F883rCM0JWNLuARx45FS/0jy+TmVXnWbamWXowIBK@vger.kernel.org
X-Gm-Message-State: AOJu0YxUglaTzy1HIU/5d9KaWNy/TsFEP/gDoaWP58DeSxpkox5053VU
	5IJhuHk6cs7LIsJLSxWBCNsCCKSiQNvoLwnSFOa7Cm96EfUn4wRsHKl21eMpp1vRpl27W656p7i
	HF6XPjTegDz30WvgthpyIXTFINnYt+RfeXtgvYgss7w==
X-Gm-Gg: ASbGnctVsWN9wMducvaaPkqS1Vfz2EilBb1DQddC+us6p9vE+uJEYd1993Nug17xlEW
	PDWCgoKT9IfInCkC5xzpNqykL9uGtWnfr/7N5fXJ27YdAu+uf+FtMyOYIExovI7UmRQkLo38Ukz
	o0nGz7pvWkLzZn/mKGK9SCd5hLfxFwhbiqXqDoZFVwUl8AauslyHhaVCtGM+PQJ/rgdvdcMNCug
	XK+dn0x
X-Google-Smtp-Source: AGHT+IFBJVxKAXo/cKR2ndkM9X7Bsz8i7y0trbE2KS4VktpXvhySzwMgUoWrnTeCkvYzPODvF62WRFigY53HbadClC8=
X-Received: by 2002:a05:6871:71f:b0:2eb:a8fb:8622 with SMTP id
 586e51a60fabf-2ffb229c270mr1371804fac.15.1752661020506; Wed, 16 Jul 2025
 03:17:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
 <yq11pqiaedd.fsf@ca-mkp.ca.oracle.com> <yq1a556776b.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a556776b.fsf@ca-mkp.ca.oracle.com>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 16 Jul 2025 11:16:49 +0100
X-Gm-Features: Ac12FXyVvVETCy_fvebhSLHtpuQY_pd3_d6Vt5LZcabX59ifAwOETZg6eR50R8Q
Message-ID: <CADrjBPrCBG4ZatLwYyH07f5EQrbO876M7WqXX7UfgD9Cg8w9Uw@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: exynos: call phy_notify_pmstate() from hibern8 callbacks
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Vinod Koul <vkoul@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

+ Vinod (phy maintainer)

On Mon, 14 Jul 2025 at 23:15, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> >> Notify the ufs phy of the hibern8 link state so that it can program the
> >> appropriate values.
> >
> > Applied to 6.17/scsi-staging, thanks!
>
> This appears to have a dependency on a patch series aimed at the phy
> tree.

Thanks for your email. Yes you're correct, as mentioned after the ---
in the patch this has a dependency on the new API proposed in [1] so
can't be queued currently.

Thanks,

Peter

[1] https://lore.kernel.org/lkml/20250703-phy-notify-pmstate-v2-0-fc1690439117@linaro.org/
