Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0153803F1
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 02:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790045449; cv=pass; b=ZwtvHDOhpHsqsQMDsQPdmmRCoIpSNVx/P+HP+wYXTbcXfccllJGlLPx1fG1mR0D+ytLl6aORoGn13Xxg+faENyUFpjxneN9pKz6xeluKtHVCSFuRJspDaiYeLnUSJ6L3WnL1MwtP9Tpzte31ScsSJqJ+sX18JJoitnQymzPYBx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790045449; c=relaxed/simple;
	bh=9seE7DdQbFb9HiabltP2bn/Px47uFUhhhOnC7opdhaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J3xKoqhp7tT+UywV8aCvOYom1qhtNGgHZtFoIM1uVauPATjzrUdUpY5iEAIGiDKSx0LR5xpf0Tb/XWa0c+xCGE2W8YmoxUOcFhYIlZe8DAT4lOxGK7S7z1P9Q2G46652AZQx871C2HcmU15u7RHADwdpm/SrV0lCzHKllCG8T1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hQwaIh6g; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hQwaIh6g"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e56a1b327so2811815d50.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 19:50:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790045447; cv=none;
        d=google.com; s=arc-20260327;
        b=ccm4fgAKGXqJk2Z/8c7zWBJrn2VwuqsWgjCYMdjrA9Ri0Wp/MGKG3PPd46gJNWz+Kb
         Z9rSa7Uq8oXql/USGWKDe8YQH0XWgDI5JAhgWxahMd5EwR23NyFTkX1cC/qrga9jgqzS
         TtZfXPXQc2hBJfB3+WOfWxZhqPfmOVY2LY6njBwAIVZiFO2/9tUhDbKbxSHgtCyRHohT
         Uvdbtq9uC0P5wGbPFDQSvkmcH9vrS+RTVktfpUJ/UcSFXa99zSpuJQHNd35zamnYKuA8
         DV08tbHaFHXbc4BsEaS55K8xrrLba065G64GSRHEqu0zKU89ZzrWafAePMa7k1BJzF0n
         vMxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PuG/mOTULDlFBdQPJWs+1DVH0LGf45HnPczNNq/pztc=;
        fh=rJnfX1T+/PqVNm/U/O0OriCjxpo5GO9w9ANAm35Ytg8=;
        b=qFIf9yFpYSCbW0V5U2XaOms0vzd9wNjojYosE1BB6Hfbrv4DkkdK7M8aZospqRHJ09
         cbVMzBdZ5NnDII91D6ZXIkrEvS+XA4PwcLjO5YhWCsICmmYihx4AZaNrSqQv0vLOdWg/
         Khmq7FpvZP7AqBHW+0Qg+Kn6gtW3Jc4Ig7hfu2iqDYUrQfjo1seVyWixQZWGJ7gHss+u
         jNo3uD457rjqImwuuwv18Aqajw/+uTsImicjyWpSsUuYEn24wdEMdNdPZOCyfUoy/0RO
         E2CojlxI1ebcwcXNDVkD4gTXUciKrR4ikVpxE8BdElbVY55NeSyfhxjPEeh/iS77HakM
         rIZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790045447; x=1790650247; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PuG/mOTULDlFBdQPJWs+1DVH0LGf45HnPczNNq/pztc=;
        b=hQwaIh6gJZv0U3Pc0WcTl3biDBwWXnovJwhS420V1vgGJRxdzkeZ1EuDk04OQkh3O3
         EW55N0B9NP5fiB2rZ37fQoRGRKVPE5ppPLIVgwy38P5VKM9c9X51S5SmvfFq1ep7HZic
         B/3BIWVepPEhGsEvOUWuyW/C5Cp79VW8kuVuAu0b/KfixQgr8fiIxB6/wzEA9TYZMYP5
         J/jZiChLpM26ek5Fv3CsH4E7ZYUSbH1v2pEu69nKhSSpu9+B3BDDLt9qm8Z2IwkAsmY8
         rHIs0f471PPnmPxwwaUhNJdsZkZU9ZAMpXIS/sXmn/cBndjlcEEec1NigufxTDyIJPWe
         CwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790045447; x=1790650247;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PuG/mOTULDlFBdQPJWs+1DVH0LGf45HnPczNNq/pztc=;
        b=slx4mk/7B0JJNIPxicLUhLWsWq7AR4fB3Et9kKP7fyh9iiyIthTrI+gX1yYD755Gtl
         YiZReOxfh4HGkAAz40lwg6muUi6rvkXAO08AuaXFtEwADZ7YwrMGI4QaPyXUQdFaeyto
         /uBMDY1iOhkwLOvZImuxry/h29lOudWYu73gzTmYGueSdHE9foFNiP3jphZx5pNNrDOM
         aIWgeAN4BSJRaMdGrupsjSNcjoTkfJ8BAzaP3lOER0i1a6QaudBhTY5nxo+gWlDA4NMD
         frKOuEjf7TwAyjT6SdceNaT1RVKdCPYg0laoQztGnWpw7wHVYQZ9snPVWbztGY3XeXLF
         k4tw==
X-Forwarded-Encrypted: i=1; AKwUvByJ3huzA5RgmKrkbbr31vTeGgBm97wlYRNUW8tU/bVPOx2IQH4eg43o9AVHonDKYhlKM5KkQLUqk7Am@vger.kernel.org
X-Gm-Message-State: AFuF++k/aAb3h0CMyooY4CCJPDvPqqwC+0r7T0YjCxphNQlZNSnc0KFc
	5bCzPiiwKtJUfFujMhiGfuIzsELenxPJJzOKWzLECr/S5sS68AIgOd1bGfmtLoV970ArkNreg16
	UiS9tBU9ASrOhT7tUm8Sfu/TNTNTcf9k=
X-Gm-Gg: AYBFou1p1gNDjbBxMCpiGlEUPzkwXnjMml5m1BkZ57IIQ9iFRfjSgSdYqdZ+bDh9ay6
	13g60nrIA5wFLR3zZ0fvGVB/5ZqXeXfSAyV/7xchYhQmLsWw4sPEPpiakd0WRCofzb2cpfOjn8y
	CcczyKLvCX204w+rdj5/a0IFnF2EeBZpjvhHacUGJvqFhbwl2aE3zdbkBaUul0JFmZRpsr9rHeZ
	lhQUreG8D/31OqNIfA8DlDVUJrqvUnU1734wIc5k3sh+74PvjZfmEi52QZ1DSIq9nn/GimrJWQU
	sgJqNcCNEW4dQhfKw3BLndjEZYCA5NPeqo7Ai8j0Oqm+YWufo5qOJyAsmQ==
X-Received: by 2002:a05:690e:4385:b0:671:c5e:6d5 with SMTP id
 956f58d0204a3-6717fcb6779mr2611942d50.4.1790045447318; Mon, 21 Sep 2026
 19:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918181326.3633765-1-lgs201920130244@gmail.com> <arFJiC1JGB0KpoLn@quoll>
In-Reply-To: <arFJiC1JGB0KpoLn@quoll>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 22 Sep 2026 10:50:33 +0800
X-Gm-Features: AcwNN1W51HQHgqXq96H1vY74mor976BD85GOPWHnSJHN_BwJ54ajJuhACadQQO0
Message-ID: <CANUHTR9JgmyoCp3hcTbBn-NnUzjKFW_LaRHcrsY9qZbGvxAcNg@mail.gmail.com>
Subject: Re: [PATCH] scsi: efct: clear MWI on remove
To: krzk@kernel.org
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Ram Vegesna <ram.vegesna@broadcom.com>, Kees Cook <kees@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Daniel Wagner <dwagner@suse.de>, 
	James Smart <jsmart2021@gmail.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

Thank you for your feedback.

On Mon, 21 Sept 2026 at 23:13, <krzk@kernel.org> wrote:
>
>
> On Sat, 19 Sep 2026 02:13:26 +0800, Guangshuo Li wrote:
> > efct_pci_probe() enables PCI Memory-Write-Invalidate with pci_set_mwi().
> > The probe failure path clears this state with pci_clear_mwi(), but the
> > normal remove path does not perform the corresponding cleanup.
> >
> > pci_disable_device() only disables PCI bus mastering and does not clear
> > the PCI_COMMAND_INVALIDATE bit. As a result, the MWI configuration can
> > remain enabled after the driver is removed.
> >
> > Call pci_clear_mwi() in efct_pci_remove(), matching the probe error
> > path.
> >
> > This issue was found by manual code inspection.
> >
> > Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  drivers/scsi/elx/efct/efct_driver.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
>
>
> You sent multiple independent patches, to multiple independent
> subsystems. The amount of these patches clearly suggest this was
> AI generated and most likely not tested.
>
> More importantly, you sent all this work without properly organizing
> relevant patches into patchsets. This makes reviewing difficult
> and might cause multiple reviewers to address the same issue.
> Replying to the entire set is impossible and requires handling each
> patch independently, instead of applying or discarding the set.
> Maintainers also won't see the bigger picture of your work. Quite
> worrying.
>
> This is on the verge of hostile patch: bomb us with so many
> contributions, we won't be able to handle them in efficient manner,
> like responding ONCE to ask you to slow down.  Considering all this
> is untested and LLM generated, I have even more doubts whether this
> should be considered for review.
>
> Please read kernel documentation BEFORE posting more work. It will
> explain you how to identify subsystems, how to organize your work per
> subsystem, how to document usage of LLM and how what you should not
> do if this was posted in a good faith.
>
> Best regards,
> Krzysztof
>
>
>

I would like to clarify that these patches were manually reviewed and
audited by us; they were not simply generated and submitted by an LLM.
However, I understand why the recent submission pattern may have given
that impression. We sent too many patches in a short period of time,
and we also failed to respond to some discussions in a timely manner,
which made the situation look worse.

Many of the recent patches, especially the v2 revisions, are
corrections and improvements based on previous review feedback rather
than completely new untested changes. That said, we recognize that the
way we submitted them increased the burden on maintainers and
reviewers.

We apologize for the pressure this caused to the community. We will be
more careful about organizing patches by subsystem, preparing proper
patchsets, and following the kernel contribution guidelines before
sending future work.

Thank you again for pointing this out.

Best regards,
Guangshuo
