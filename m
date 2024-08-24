Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B81A182C5
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 03:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724468607; cv=none; b=G+Jmd+coA5m3t+wuOQQOy2m5MufvbFb3ASKihuyln8kYd/A4aVxYh9dxxqihgm78O2S8axgcoPl0wvG7Ae6mTXnnxPDKQr/GHA1NWFBm5pCZausDn8HLNhwcY2ijgab9QlBTWOwdeqE2ILPqC1QyVrxBzJg7tsal+/RfmI1LF44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724468607; c=relaxed/simple;
	bh=P0H2c1MZ+T7ykWgEYoZgjktZcfTvFH6nmSn8V2Ajlgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHoRV317+XsLU6j+Ku6PjUlzphtE6Mhds0G4n4LLPIBgSUxt4eDGnvJiZXeeSFPjF7+vyOi1g2JaG4vPejFuRA4FCjLMvMiwaM3vRnPYWvX6Md9iLgO0nePhLvL4aRBdB57LQBPqusoPf3COrq+RAZNzWTcvKBCVTol4v2Cppm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WQ8MDSru; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WQ8MDSru"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7163489149eso1551564a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 20:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724468605; x=1725073405; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KhC5nkpFOp0M/9ADExwfC0zOfh4qmr79nXiSJvjBjas=;
        b=WQ8MDSrugDXkdp4cRJNUU9EpuhQDH15u4BmtYzDf4QJ9BMwU19mvjMLmw5JpUr3Z91
         YoOoicWBwe+bg0Lm4RXKvsBuNyMTESQgW2UeMDvculMfRekwwV28vulkOMFlv1MYEKX0
         6BpdWGziQIwX2uLnnKsg6d4enTQxS0WrezKpc7ieQTvKAJX21S7AMZinEKydnZNHLj6B
         NdpRNwx0S2HC7keotzP+colG9c1k/+BsXT1eRZcWWWpH9tQbX9TCj73s1H8OmmRapEs5
         +SPnHtGUDQ+fZ660eEoPYqu/0Ez5WNhZoa60ICtKd2GrqljtFpNBJe8eBwOkDtT1DyM+
         eZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724468605; x=1725073405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhC5nkpFOp0M/9ADExwfC0zOfh4qmr79nXiSJvjBjas=;
        b=DrHICgjASkRRicJ5l3CF98TxMN/Er2pYFGwUzBMTcdCml2BiL/i7KaHFosoa0zMpDA
         ewexG+6vBxEWhNHYVlVIsWmpcN4qeLe47FSSp31x/ONR6ZKHb+08uqn91YsvcOCdwxWO
         d4eWKtXk82H2l9PjEP6xfgsQXCrbZwUGOzq8KozsMOtxIKmgnO/S5vJZsbXE8KXjRXH1
         qYFKjkx+Q3dyXUWNP12/NhDYgqWuIDu+gd8nner0qAU8hXXlMB850a7MVusHDhpnHPth
         EJXv9+1cW5kueDj8Pp2JyZ0j4KIBhIXzx05gvp5H0DdtjXAcCdxklwhzzol2XnnJxCLH
         CbyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk2gnkdguIolzcmdmivBhluEKxYYi3BCFrzldjgXgdvyAJ7Y53+YiVN128TO8twqjhSQXZ1D8yjPf1@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrw2/qILXnnz4yZK/Y06fd1ZRcRqeMXw+rChN1O7LWOPLXYKKx
	vMyOrd0B0pqoF2HX72EYZU1m+t0z12RdamXV/MYNs+YJUm0YpTD64U5Nf8blZw==
X-Google-Smtp-Source: AGHT+IGU0Mhzyvl5egT3Rm4QGqSzgOBJ56K6wSybAa2hhlqrgOyIz3ssvJNaXuj7dbbl+6h0miL2KQ==
X-Received: by 2002:a17:903:18e:b0:203:8df1:1233 with SMTP id d9443c01a7336-2039e484574mr54592975ad.23.1724468605305;
        Fri, 23 Aug 2024 20:03:25 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385566479sm34530635ad.58.2024.08.23.20.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 20:03:24 -0700 (PDT)
Date: Sat, 24 Aug 2024 08:33:14 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Message-ID: <20240824030314.rhsfdhralfpcdjgt@thinkpad>
References: <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
 <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
 <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>
 <20240824022929.sxnh7sjl2tb6pmbm@thinkpad>
 <861b64b8-d0cc-42b3-bf57-375f84f4fe85@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <861b64b8-d0cc-42b3-bf57-375f84f4fe85@acm.org>

On Fri, Aug 23, 2024 at 07:48:50PM -0700, Bart Van Assche wrote:
> On 8/23/24 7:29 PM, Manivannan Sadhasivam wrote:
> > What if other vendors start adding the workaround in the core driver citing GKI
> > requirement (provided it also removes some code as you justified)? Will it be
> > acceptable? NO.
> 
> It's not up to you to define new rules for upstream kernel development.

I'm not framing new rules, but just pointing out the common practice.

> Anyone is allowed to publish patches that rework kernel code, whether
> or not the purpose of such a patch is to work around a SoC bug.
> 

Yes, at the same time if that code deviates from the norm, then anyone can
complain. We are all working towards making the code better.

> Additionally, it has already happened that one of your colleagues
> submitted a workaround for a SoC bug to the UFS core driver.
> From the description of commit 0f52fcb99ea2 ("scsi: ufs: Try to save
> power mode change and UIC cmd completion timeout"): "This is to deal
> with the scenario in which completion has been raised but the one
> waiting for the completion cannot be awaken in time due to kernel
> scheduling problem." That description makes zero sense to me. My
> conclusion from commit 0f52fcb99ea2 is that it is a workaround for a
> bug in a UFS host controller, namely that a particular UFS host
> controller not always generates a UIC completion interrupt when it
> should.
> 

0f52fcb99ea2 was submitted in 2020 before I started contributing to UFS driver
seriously. But the description of that commit never mentioned any issue with the
controller. It vaguely mentions 'kernel scheduling problem' which I don't know
how to interpret. If I were looking into the code at that time, I would've
definitely asked for clarity during the review phase.

But there is no need to take it as an example. I can only assert the fact that
working around the controller defect in core code when we already have quirks
for the same purpose defeats the purpose of quirks. And it will encourage other
people to start changing the core code in the future thus bypassing the quirks.

But I'm not a maintainer of this part of the code. So I cannot definitely stop
you from getting this patch merged. I'll leave it up to Martin to decide.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
