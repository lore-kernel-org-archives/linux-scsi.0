Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4D381B9
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 02:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724466588; cv=none; b=X6o2/xDaERm6ILASvdPu46JVayg0rQyN7iDSpRnuUO9G+37Wr0N+Sh5LMo/EPk6SaFcxbbZVScaEHGa+yCW+QeuHUEjYxSY+iw0OxxIBIk8sIyvX45FTaxUjULhiVUqo9WRL6zDmmPvzEzGmCHzr75OfgtxIKesKjk4iwWF4Tmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724466588; c=relaxed/simple;
	bh=HB8sOVmVq2SFOhyTL0BsBPc1nEGkXN0Wg6F7BI0Pcts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCrVrgM2Yopxbu2PCoK+jIffm+NfBqPkMhhZFCA4PhrGzFaDa/yxM7aJvEl4Edd31n4SAs2jfof2NNEKtJRuMyNzrsGhljdbL4pb6hq8AKcHJMbQDAA+2HCXsSjmvVt3NTdAt/Pl6S/Tlm3w3vhvOhCeFW8+k4l8kF5cKm7WO3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QG4QjkzB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QG4QjkzB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fee6435a34so18883185ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 19:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724466586; x=1725071386; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Y/+D85iiWw9j17ToU29/DDlQs8mVd/ieEio6xVmFjA=;
        b=QG4QjkzBwdlLTkU17x5V4WiHYOPEc0urwHdv7AvS3c5Sh2jg2VjPnZfHgYKcR8clTn
         Hnnrx8lH/y+OEMct5Nb5eVSg9plt5zcgSrKJzvMFQsbtA5ZK5mVvNW3Lw6uuxJspvidL
         +8VsA8QOdoinQNmx/FvxWXj0CsTpTJKA8Lq0qLXdTLAgksGZjbCpSHOA/cDdiKcVgLnA
         /sc8Wp7QMZtW/qARTO9Lipd+IZwCz8ojHo0MLq1f9VB1wd/duBfhlwBSZFIqLtA6KnFO
         jQgR2pom6r3ebxLWefeq0EJ1/5EK/wfJ8OLVZb1JfEDLNdOgEXPqOdPUyVaY7bkX+pTy
         +8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724466586; x=1725071386;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Y/+D85iiWw9j17ToU29/DDlQs8mVd/ieEio6xVmFjA=;
        b=nL7k+vUeBVxeTe/p0uLjCB0OZf3+JIR1tHRSjskU6a9d479u+1uzJGEFGThtelRBjh
         bLhAwSrBpEdJhqklakX2Nko1bMzNzj5hAMN3P8BKew+/RBIONi9BFO8Y84mAmtZKUaRF
         8YdfbrBC9HQEqITeqF36FyinqgPWqfmQOkavWLPjQhVTyOMmugWjUJ0wYTJV6ul9lSAk
         r3iy+GyOUE788m3HbUve+IQ4/G87OsCviP19X3nTwmJGlIxk9sVyFtdqDir2RWrmI45+
         jB0tQ+VWU5AUWKLJoufiZ7mz+1sxMxuhIM2LwqKa744U6gabkhnviYu04NtyLB8FN6Zc
         wgZA==
X-Forwarded-Encrypted: i=1; AJvYcCUG/aNHIhxysNpqAkGwNBq43YP2pHix8NLVw0ozDACOvCfp+wNK/OI/i6ovvSD9beY9xax3VO4VEMAC@vger.kernel.org
X-Gm-Message-State: AOJu0YzsCi1IesLrAuUGfwwWM3XzBlnxs6M0zYaH9VvS96HFPClffarH
	XhWnGpppfEJb/qXS2tUxR2JRBRy9OYOPYX2XAp3B9JxPYfNnhskuYFlYWrg/3w==
X-Google-Smtp-Source: AGHT+IEn81lUMvOaVUlLCSFD7ITJcagH8cK0XYUU7n/Xxb9zJ+EEhqSp9PqjLOVWcPSr791fhMNm3Q==
X-Received: by 2002:a17:902:d2cc:b0:202:11ab:ccf4 with SMTP id d9443c01a7336-2039e442d21mr51531555ad.6.1724466586333;
        Fri, 23 Aug 2024 19:29:46 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385fc538bsm34396795ad.290.2024.08.23.19.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 19:29:45 -0700 (PDT)
Date: Sat, 24 Aug 2024 07:59:29 +0530
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
Message-ID: <20240824022929.sxnh7sjl2tb6pmbm@thinkpad>
References: <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
 <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
 <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>

On Fri, Aug 23, 2024 at 11:05:12AM -0700, Bart Van Assche wrote:
> On 8/23/24 9:48 AM, Manivannan Sadhasivam wrote:
> > On Fri, Aug 23, 2024 at 09:07:18AM -0700, Bart Van Assche wrote:
> > > On 8/23/24 7:58 AM, Manivannan Sadhasivam wrote:
> > > > Then why can't you send the change at that time?
> > > 
> > > We use the Android GKI kernel and any patches must be sent upstream
> > > first before these can be considered for inclusion in the GKI kernel.
> > 
> > But that's the same requirement for other SoC vendors as well. Anyway, these
> > don't justify the fact that the core code should be modified to workaround a
> > controller defect. Please use quirks as like other vendors.
> 
> Let me repeat what I mentioned earlier:
> * Introducing a new quirk without introducing a user for that quirk is
>   not acceptable because that would involve introducing code that is
>   dead code from the point of view of the upstream kernel.

As I pointed out earlier, you should just submit the quirk change when you are
submitting your driver. But you said that for GKI requirement you are doing the
change in core driver. But again, that is applicable for other vendors as well.
What if other vendors start adding the workaround in the core driver citing GKI
requirement (provided it also removes some code as you justified)? Will it be
acceptable? NO.

> * The UFS driver core is already complicated. If we don't need a new
>   quirk we shouldn't introduce a new quirk.
> 

Sorry, the quirk is a quirk. All the existing quirks can be worked around in the
core driver in some way. But we have the quirk mechanisms to specifically not to
do that to avoid polluting the core code which has to follow the spec.

Moreover, this workaround you are adding is not at all common for other
controllers. So this definitely doesn't justify modifying the core code.

IMO adding more code alone will not make a driver complicated, but changing the
logic will.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
