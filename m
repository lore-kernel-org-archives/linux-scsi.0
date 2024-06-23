Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89191802B3
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jun 2024 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719149953; cv=none; b=I7q9PvhXGE4Y2y4UGJKvWGovXlWUZ6pLcdL8cO4O93u/42xF149I8ttXeoO9owVP+fdxRO3+BZw8NUE7K3nRiTk84Zf2/8jCauuRSZm6cAccKdD7BK2Vy5C+V4zhiMaisXW+umQvEL3ozY4OZqYZMzXrl3zukb3T3BpezrC4lBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719149953; c=relaxed/simple;
	bh=dug/FAn+rVMy4lGYALFDEuXV2salRX5aJXPGd8uyshY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6jY9sHPmhLAAlWXhhdeG0VmlNSpalhPQ6XtNnSCnAj3GdShFIZ8dJxw6XWKIr6Yzcc15eMgops63tLVZdIIdI875jbflpRtOXHthuf5XgOibaIFrfGWSnRb2x7JjM6a0+D9lGliNTtrUJOPdaqfpiy6JraSe9fgRoijaNqEU/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ArnH+S+g; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ArnH+S+g"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f9b523a15cso25213595ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jun 2024 06:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719149951; x=1719754751; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tZZBsgFB1npoVZQZ1dOy6Supq3j4Xml2gdzzvV7xk2s=;
        b=ArnH+S+gPL9smFvcwwrpJppvO51bZwnCdwpkwa1lCSsBHeAMjFaZivFmlGB2pXBkOz
         T/zDcV8C72ISh3THEaS5QFaFJOgPpWf/p8gGZlYJ6+LMuYiwL+0hM9fzeqnVIItZW/qD
         5Frn+sEDedO27OEV31f42BQipZhJW4A4uFiYF3LIjayx37ijE2JwvIq51LS9CKXceQHB
         WnuQiMks704XOA5utV1jLqxga/afdzTUaXjaKATaTGBDS+M+oadbH8gS2it0wslmRfkA
         MIljpFo8fR3xytN1w64PM9WCfJ73U6JyZRLBIRxxmI8etUONincEptJqJOin3ZRdQ0KJ
         BiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719149951; x=1719754751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZZBsgFB1npoVZQZ1dOy6Supq3j4Xml2gdzzvV7xk2s=;
        b=gwK1IA8lIggpfGubLHfMGsLEccpFxEeoxcVoGLar5aGLOyjPlv6EVMdve4l1JP8ODK
         1aVtVLvgD1p8dpd9XSibsI0T3gVTDyo5gxrUSNzWVm5DHHEtyDsZk8qCWMDKxB48Pie2
         UkjcSeRGWC43WzeNz48Vt1C5rKj3R2BGAiYFByb2UgcUNHPOgUj4PdozuKqsSMHkYKoD
         HEPs8najZNsSPGbhN+j6FmtyIN7w8SHuoh9kTM4gsncsy81ZNm4GQ+gLo/eHIGqV7aSf
         E+N9p/ulcjapu0Q9hs2ho8T8yAbr7ZucMYPHJ62ZkzaKimoBj73K+hEJQygNtQihDHjJ
         Tz1g==
X-Forwarded-Encrypted: i=1; AJvYcCUcYeKFr6SDV1yceA0N1j7g/xSizD9TUMYwNdenb2C9L+glCyxINUrS/LZ7qZkk40Q88INFvOLx/k/Pk7OqvPsQDjdzkGpB09usZA==
X-Gm-Message-State: AOJu0Yyk6uVyoLK3bo1UaSVMhggechGjRVh46YEJXRp12OClXc1d2lIo
	BxZkt1ScSxkMjdLeE23K2kmeDspKh3QPs41UF8J8HtGF7GdRekkieH3VhYoGJw==
X-Google-Smtp-Source: AGHT+IHJjmrhz6ReOARqTWVChevoqegexZBgfndIVifEKIsso85vJhjR4ThfnMmvK9gc9ubVNM1fhA==
X-Received: by 2002:a17:903:2290:b0:1fa:2c79:74f9 with SMTP id d9443c01a7336-1fa2c797661mr13558885ad.37.1719149950768;
        Sun, 23 Jun 2024 06:39:10 -0700 (PDT)
Received: from thinkpad ([220.158.156.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5f7csm45196115ad.140.2024.06.23.06.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 06:39:10 -0700 (PDT)
Date: Sun, 23 Jun 2024 19:09:05 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH 6/8] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
Message-ID: <20240623133905.GC58184@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-7-bvanassche@acm.org>
 <20240619073210.GE6056@thinkpad>
 <d88fcbfa-eb05-4b46-a452-2cd9e7897797@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d88fcbfa-eb05-4b46-a452-2cd9e7897797@acm.org>

On Thu, Jun 20, 2024 at 01:13:10PM -0700, Bart Van Assche wrote:
> On 6/19/24 12:32 AM, Manivannan Sadhasivam wrote:
> > On Mon, Jun 17, 2024 at 02:07:45PM -0700, Bart Van Assche wrote:
> > > The ufshcd_poll() implementation does not support queue_num ==
> > > UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
> > > if queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.
> > > 
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > ---
> > >   drivers/ufs/core/ufshcd.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > > index 7761ccca2115..db374a788140 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -5562,6 +5562,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
> > >   	struct ufs_hw_queue *hwq;
> > >   	if (is_mcq_enabled(hba)) {
> > > +		WARN_ON_ONCE(queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
> > 
> > So what does the user has to do if this WARN_ON gets triggered? Can't we use
> > dev_err()/dev_warn() and return instead if the intention is to just report the
> > error or warning.
> > 
> > I know that UFS code has WARN_ON sprinkled all over, but those should be audited
> > at some point and also the new additions.
> > 
> > Also, this is a bug fix as it essentially fixes array out of the bounds issue.
> > So should have a fixes tag and CC stable list for backporting.
> 
> No, this is not a bug fix. There is only one caller that passes the value
> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT as the 'queue_num' argument and it is a code
> path that supports legacy mode (single queue mode). Since the above WARN_ON_ONCE()
> is in an MCQ code path, it will never be triggered. The above WARN_ON_ONCE() can
> be seen as a form of documentation and also as defensive programming. I think
> using WARN_ON_ONCE() to document which code paths will never be triggered is fine.
> 

Why should we insert a warning in a dead code? WARN_ON* makes sense if a certain
condition is never expected to happen, but if that happens then most likely
something wrong happened seriously so the users should be warned.

But here I don't see a possibility to get this triggered at all. Please correct
me if I'm wrong.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
