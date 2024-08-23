Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8F1891B2
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724425107; cv=none; b=EKFBdSxNGLzc4KDF+tMD16xTPV8EbMxfNlDsau4KUJN6TxtalxdCKwSQfhobEEbEiNXK8Xx1id6GGwOMttcZ4ezJ26qY5nQ+L1Jjd4SDW8TZV+87V3BpJB7Tm54t1B6JyAFy7HBBGoEvgPeqD2spgthKsOUZzuZvf9jsE9okJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724425107; c=relaxed/simple;
	bh=9BO7TxDCHU+glB0+XhRzoDErN/FIrT1JU+rIHQ4PUko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKzB8/NFVzwdym2v7F7dIQjD4Di+TL6nUnF/Jy6GVYrX3+rpNFTsLfZ/T2T9OGqCboZOyYVRYU7qc9+haMwzBW97+QtU0ueNeIYqz8i7BPQrTwpZFpt/uEaFhy2xyP1osYvt6Bx+Q+OoxSt8zyiVlcNIDVNJkcT7nxHGgTC5Oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=by2s6Xf7; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="by2s6Xf7"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7cd8c8b07fbso880962a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 07:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724425105; x=1725029905; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+lFjlrM21UZyyv+6tLO93idiejXv54jN8U1d0cmsJKA=;
        b=by2s6Xf7l1Pc4ZfukJgdBGoIGapYJnTsa2GpFsdhcRhsWHFpEqLWC1WbYpSPJMMZoD
         fU71v+aSoDRMI1Z3ne1B36HT3vZpo2unSOZRtMdR09MYAfsfJea2JE929/UtFRECj4Wv
         csqd/HFuSpTYeakMKD/N08Mz9dedZtEouudWMgY+G+0g39pqKalmhbk+U/ObURCNU4AU
         0eqy8sKxV8r615lYsPZznKQUThGhZSXAYMous14UGRgtriMxeceJ2JCzq/o/6EzWzbpy
         0aaejRDpnoRhd5pF7/OQrv/aJHU5t3S9TDdQL+pSNRMQPn1TH8JbVmSyMNnth0v1Zumv
         IIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724425105; x=1725029905;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lFjlrM21UZyyv+6tLO93idiejXv54jN8U1d0cmsJKA=;
        b=Sr4NWlpkXZMwVeXCF26UI/2Jz5Ih/VcvcEqYjiYIZfwM/Ve52MwvPbre2fdWNEDvEw
         aQc9M98VqgaQ5aAJuUqJ1kXi8jTAPLrfs6vMg9kwEZbG3xVhhFyArojvJDOuibTInghW
         WVUFqGjyprxEBcLWnWOhw6ZJeeo5MJJmR3k0ZdLjvswV9bMbPnLndKzmiwdUdnrvolAB
         j/DR9ZiMRbKWZz1Wvbq53V+I1WyhV5DqU2Lfv1S8sqdeYWaLTr4Pn5nH3etXlHaCOWBf
         uW1Nz3gKE37RTWqq7f7q9+L7oENxo0kBr/dnJvJ6IldHX4RgzhrXpckVgy9nwL55JHIa
         K/cg==
X-Forwarded-Encrypted: i=1; AJvYcCXS/+mLvHydJtYV+qKW3WoDcYfPe3nqCvQoKoU26Xw6tTXaElLvFFy2pG3+5u48LG6Jtwqi3kgcL9vJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Bbu35sg3m7xsJapGjJbfRn8gwrXMlRExe7SFYKh53vdq0fec
	hgUXAlhQLuIs14pMiWovXLy/MnrrZj1dZWD2Ct9gIREhPgGnW5xTCoLAynj/0A==
X-Google-Smtp-Source: AGHT+IGgUS51dzBRhOtV1Qt3U3kcQAvFan4E3DT9ygqgDcoi06MXhVMF3PQKy993e1wh8h0eGFqF2Q==
X-Received: by 2002:a05:6a21:339a:b0:1cc:961f:33c6 with SMTP id adf61e73a8af0-1cc961f36e0mr1002310637.19.1724425105307;
        Fri, 23 Aug 2024 07:58:25 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9ac985fesm2877454a12.7.2024.08.23.07.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:58:24 -0700 (PDT)
Date: Fri, 23 Aug 2024 20:28:17 +0530
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
Message-ID: <20240823145817.e24ka7mmbkn5purd@thinkpad>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>

On Fri, Aug 23, 2024 at 07:23:57AM -0700, Bart Van Assche wrote:
> On 8/23/24 5:01 AM, Manivannan Sadhasivam wrote:
> > Unfortunately you never mentioned which UFS controller this behavior applies to.
> 
> Does your employer allow you to publish detailed information about
> unreleased SoCs?
> 

Certainly not! But in that case I will explicitly mention that the controller is
used in an upcoming SoC or something like that. Otherwise, how can the community
know whether you are sending the patch for an existing controller or a secret
one?

> > > - The workaround results in a simplification of the UFS driver core
> > >    code. More lines are removed from the UFS driver than added.
> > 
> > This doesn't justify the modification of the UFS code driver for an errantic
> > behavior of a UFS controller.
> 
> Patch 2/2 deletes more code than it adds and hence helps to make the UFS
> driver core easier to maintain. Adding yet another quirk would make the
> UFS driver core more complicated and hence harder to maintain.
> 

IMO nobody can make the UFS driver more complicated. It is complicated at its
best :)

But you are just applying the plaster in the core code for a quirky behavior of
an unreleased SoC. IMO that is not something we would want. Imagine if other
vendor also decides to do the same with the argument of removing more lines of
code etc... we will end up with a situation where the core code doing something
out of the spec for a buggy controller without any mentioning of the quirky
behavior.

So that will make the code more complex to understand.

> > > Although it would be possible to select whether the old or the new
> > > behavior is selected by introducing yet another host controller quirk, I
> > > prefer not to do that because it would make the UFSHCI driver even more
> > > complex.
> > 
> > I strongly believe that using the quirk is the way forward to address this
> > issue. Because this is not a documented behavior to be handled in the core
> > driver and also defeats the purpose of having the quirks in first place.
> 
> Adding a quirk is not an option in this case because adding a new quirk
> without code that uses the quirk is not allowed. It may take another
> year before the code that uses that new quirk is sent upstream because
> the team that sends Pixel SoC drivers upstream only does this after
> devices with that SoC are publicly available.
> 

Then why can't you send the change at that time? We do the same for Qcom SoCs
all the time and I'm pretty sure that the Pixel SoCs are no different.

At that time, the SoC may get a new revision and we may end up not needing the
quirk at all. I'm not saying that it will happen, but that is a common practice
among the semiconductor companies.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
