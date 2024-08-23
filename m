Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F522D7B8
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724431711; cv=none; b=nyKqMu+Qns3LOQFOj3b4wu9cggeuGFLjX9USwM+kXAEuEaMzEeEyazmPsmGI6rej/zZd5LdiRBVKJ8BF/eaOhqZfb0nJ6rFrq5/bKO8Wep8rT/GbslR9eDQtpDT6us6XR3xGlNcib+MKbrKxAqh7X3IJV6cY7UNlAN8fqkBdqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724431711; c=relaxed/simple;
	bh=Q6cbzblmdkSDVqseiznfYtiU7hNHbt9UWSxOq0O93Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rm491/iOqmZopc+v3x+tYPdXQhnkl5aDNBYq/11cJiYJDnWL6jSVkXG7P84XkMW58DBdgR9NlHhm6tbLy7/vl2l2xbQX4gDAjeCluyo3D69uWrScS++df83nh+ZnhS6JcsRt+hxg0vjmZXhAidQa8haVDx+VJLLv8Bg9iPkdKKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R87hW5nN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R87hW5nN"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20203988f37so21439185ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724431709; x=1725036509; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hMJwIYEu1vg5GncYlXm22wNn39FYP4s7k0GRSXzu1UQ=;
        b=R87hW5nNs6OymAzlQtV/1c1O4gwMlkTqTQz0wsPQ246q2KATd59gYhBk0rj9qc5QEM
         gTMsomrSMvtm3ATfCOPMjN4aD0SyZQ2pa54Rr2QpdHLTOL1sw67f/+AZV3kV/3ywzNlB
         wFmg9XFN4wYIpX6Zv7hxjw3uxXuUz0wXJAjAxTg1cGTNNqVRAD+ppAinX1+H+Hc2/ysR
         JAuJS4dpD1lJQmxlb8cwGMmJl6Gq4Plr+bP7TMe1PJObyTBhYEsyp/fDYivVuhGrnSFU
         FQ8rkN+rKDBwkzaGY39A1K+JJiNH5LXW/hUYzpfA0/Z5edazIx7NXRwcTcoaFBRXvcqB
         lqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724431709; x=1725036509;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMJwIYEu1vg5GncYlXm22wNn39FYP4s7k0GRSXzu1UQ=;
        b=AqfalNskLmzJY5jNPw8v+ubVqGYNf2iDTT1wCEv3iTHRd1VyJlWxw9pPV6U7aprBk8
         KFomqlZ/xiVFtXU1eNtt66d09y9HuQkPJuLxx7+J9yLIxkDMkR0it44Galc+xHIaieZl
         539aVBDFwMR2/+ZSUCtBgSRz87aeb4catsBfjL0Gt0biumH23ieBdQlQBv7Hsb/fVTa5
         fewCjt2+w4vWhOY9kDA3EFDlHW5WAZOynCPjozR93KmlXpY5AmsDTeyeJJXr5FD1142y
         X42pr/4ShjzYO6ifTZ19BWo9g1HtgBnmoy0KeYpGpOQCVqrAYc8G1GlsyH8IGM9Sewr+
         EtVg==
X-Forwarded-Encrypted: i=1; AJvYcCVRci5nR0rKlUuylMXt+IS2S0LzQ3X9lDlZciZamB5D0kvsI0779cApqswPKBGmNksN6M+ySvpRkfqC@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ+UCqBjrH0uWYAsLivNpxShjzIPk5VMqqKjmDZcKGzl0fhria
	c5CDTyWUF36ikHrzDXRJBwxPlrcgFZKSlg8lnacXPCk04d2WWuxEgx7x6G8LTw==
X-Google-Smtp-Source: AGHT+IF8ix6JPTSzPua3b5fJtCVMPIu8rRnnwJQwe5IHJgjgu/Zw+2H+ifGktz9xbyljI51qY18zIg==
X-Received: by 2002:a17:902:f54f:b0:202:562c:f3c7 with SMTP id d9443c01a7336-2039e44f53cmr28624905ad.10.1724431708835;
        Fri, 23 Aug 2024 09:48:28 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385704048sm30185845ad.215.2024.08.23.09.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 09:48:28 -0700 (PDT)
Date: Fri, 23 Aug 2024 22:18:22 +0530
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
Message-ID: <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
References: <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>

On Fri, Aug 23, 2024 at 09:07:18AM -0700, Bart Van Assche wrote:
> On 8/23/24 7:58 AM, Manivannan Sadhasivam wrote:
> > Then why can't you send the change at that time?
> 
> We use the Android GKI kernel and any patches must be sent upstream
> first before these can be considered for inclusion in the GKI kernel.
> 

But that's the same requirement for other SoC vendors as well. Anyway, these
don't justify the fact that the core code should be modified to workaround a
controller defect. Please use quirks as like other vendors.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
