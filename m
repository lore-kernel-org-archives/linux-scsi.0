Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B894184527
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724414483; cv=none; b=J3iL8m3Qnkw7NUWeII7wq3Ht5QIrh073zjwvwiN+QN4JQMimC6hk5eiKtWzPmmf+U5DgVIKwhGiJe1Q4YSHbuIacsTJbMt2BBq3khXJAnNpCDW17VU9KkvhUtosDij/cjTAm/eM03AySeyax9CosjNCM9TqH3JpLQ5DFOzZKQ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724414483; c=relaxed/simple;
	bh=AbJNotZCfoSO8UnNR48LAshozDQ7intq5ppT9A2Wo0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhucFUG0+OMi/7pgw08LbRnhY9HkbWX0bXKBVwmo+g1fuHZeFQPgnIxQ3bOsWVc+tNZVe7zucT7vnsc8DKGj9l0qMRsVd6smYttVZXfBPgNs2PSI4qW8vtM/Qsikxext8tKgir0NEkRgMrD5wewI1vRD/An+oBEu+q07NBYKaCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xod2EUZS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xod2EUZS"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2025031eb60so15867865ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 05:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724414481; x=1725019281; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4lPP2VboAY4KUrp/wQt8zK8eznebW308xT3PpW8kK78=;
        b=xod2EUZSDWE6yVbz5Wwc1m0TCgdb3uEOdqGZ7K5vY4JWBd8UCKuEULxTBvEieoOSXF
         HxUPMM6CAwVJwfvTxCypd+shvvWvHZDQGpDbwYyHvjBAWmWf6bk3VJ+ISlKZGyu/IW3g
         j7ciA5KQwJ+qxslmdpUWBexI98084OPClMmHy2aNxX8ZL52M0GB4h3T+uTjOF5wNEDGf
         9sGi/GAIDhhWO+1S/fboYbaNR9RiKyHfZ1Nahim+Jq2VOvpWomw+7R9xRiO4m/5cmHfV
         ZyxjtrFydp54B86vmUgJQMxsMEC4Ds8Pbm2lQojtrjnGwUFBcAr72UWXCZGiB5dTkNar
         uZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724414481; x=1725019281;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lPP2VboAY4KUrp/wQt8zK8eznebW308xT3PpW8kK78=;
        b=NeMptspCUFvA8vSY0SxDmfzGPgCPz6OfJ/hUXEYVUwjp0bcpd649GYau1PXOGzi85b
         U+h4wiNHAUPC25csuQSHe9MFx1TZoltfaHw9lx5Sn6a34c3E8hqnvdcCqxxio6aFIieO
         XdVi2F8oEYQeCpoooDEWHvflXqQDAgoB7TNBuQYUwf1+l6jT/pFyKQKOAnJ9tlwHDLch
         QUrFfB2nmvVR1jeeLrDgN2aH797M7MGE9YWs2MD1duBIdkj10PUHtIo1tY70ogRe22ca
         LUU0k+7nRvCx/qYQX4OhB/27CiSaw8BOKXU/RFXfBafic71gqtzxEJAXMdCmFnL21ihL
         UmPA==
X-Forwarded-Encrypted: i=1; AJvYcCWg/ETwn9e94mOeiL38LODbsxMDVz9JAIVnZLGPwcuYm/JPWeH6BlCYsuA+rpdinjreohZmw0TrUp/4@vger.kernel.org
X-Gm-Message-State: AOJu0Yww8lt/QlonaAdRs82JGLGlZvmr061tKsdT3yucxGZuWsKgugW2
	CIa12Y6jIWrvVKvJwttMtTShhUfFqNl32kMozzkYFo/Wyja4Z3NH//Y4fyiJEg==
X-Google-Smtp-Source: AGHT+IG/Ufhdsc3sPU/JiQ3fmYFVazl3l53yswYPe5KTUP+Sx/6a3GwEX28ynVsc80jOHEsj0LF2MQ==
X-Received: by 2002:a17:902:e744:b0:1fd:93d2:fb67 with SMTP id d9443c01a7336-2039e5127c5mr19744155ad.52.1724414481204;
        Fri, 23 Aug 2024 05:01:21 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dc280sm27168765ad.162.2024.08.23.05.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 05:01:20 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:31:04 +0530
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
Message-ID: <20240823120104.siy54o6qja75lpwh@thinkpad>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>

On Thu, Aug 22, 2024 at 02:08:24PM -0700, Bart Van Assche wrote:
> On 8/22/24 1:54 PM, Bao D. Nguyen wrote:
> > I am just curious about providing workaround for a hardware issue in the
> > ufs core driver. Sometimes I notice the community is not accepting such
> > a change and push the change to be implemented in the vendor/platform
> > drivers.
> 
> There are two reasons why I propose to implement this workaround as a
> change for the UFS driver core:
> - I am not aware of any way to implement the behavior change in a vendor
>   driver without modifying the UFS driver core.

Unfortunately you never mentioned which UFS controller this behavior applies to.

> - The workaround results in a simplification of the UFS driver core
>   code. More lines are removed from the UFS driver than added.
> 

This doesn't justify the modification of the UFS code driver for an errantic
behavior of a UFS controller.

> Although it would be possible to select whether the old or the new
> behavior is selected by introducing yet another host controller quirk, I
> prefer not to do that because it would make the UFSHCI driver even more
> complex.
> 

I strongly believe that using the quirk is the way forward to address this
issue. Because this is not a documented behavior to be handled in the core
driver and also defeats the purpose of having the quirks in first place.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
