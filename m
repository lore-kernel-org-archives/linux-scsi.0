Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7787E2AF1B
	for <linux-scsi@vger.kernel.org>; Mon,  9 Dec 2024 04:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733717043; cv=none; b=J9rEBU9TfTB5Vw4q7xD7/ZJIisD5zSdRil7Q8+t8ensyIrXkzpCJvxVTC1mbl/96SghwFjk4ksRmclbu+NzRLdulZWHFcevQaKp9gWzdFfV/TUp6NVaD2g1wR3gzf13PsAQ4XyUP2C79dNxAWoDmVXs3Tpv2rRtXsNOTGBqzzUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733717043; c=relaxed/simple;
	bh=cETlEE0WzQEHwy8QEzoaAMqjhzhL0tNxzJ0RsFPbUTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRuMgF1LY4jRN1cAo+qPHGoemQd3kOWZu6bdnivdAgt+DSFmlLHjxj6dCgQboG7qvXZQsxK9QylAjvXAQFAcLbCeHQUVSN6PcWcQY1Qvf2EHrD9hGq9iRF7iFlPGSvDw+byXgCa3ADSyk+OgN1lae8m6rzLg1JNsQzwR5XP9bas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aCTotBxC; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aCTotBxC"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-71deabe9d24so407523a34.1
        for <linux-scsi@vger.kernel.org>; Sun, 08 Dec 2024 20:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733717040; x=1734321840; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xSueRKS2Dc0oEFrhPvduUyI5vUBlKuQKvD4Db72M8fs=;
        b=aCTotBxC6veSmtoiU3NYRwqPWeFvOyubNoM1ckIbpIu7VRZM6TfFMFASN2wlGvefEu
         HGHMcrQdIKsgoFzsT+7658dhohetRFt8Aq8A/0+gRgFIDwSrgFU9nJyP/ha7zz1YZiPZ
         UQ6ikk/KjKksIcqrCpD7GUMDDO/fY4q/RwrsUf+TlWaJc2buOEiJqjDocRTeXULFjlJp
         X/n2llRQ5zb+VNXJ0UWiFxc3NhJYMcGLIrKKyknPq+hTExchj3xvcXD/ntWt/jg+yw5h
         zY1Ntt0YsL+d8d0B5lhXpZdF3AZaLkN7aql260Jg8OlW2Z0FKuXumvV3czWTsdPJgVsw
         WH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733717040; x=1734321840;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xSueRKS2Dc0oEFrhPvduUyI5vUBlKuQKvD4Db72M8fs=;
        b=r0TlywsopIS3Ha2E+yhx24VV+XQNvssvc35s8fmvXMathcXRTpN407xrUxR0UfAxDH
         I4qFdJrSN+kxf6aM/aPSIa3dSB02Fk+S++SqZCQTruH6T8B9fa3ZEJ0xozckygBEslmr
         kr3XHR+2Sxl2+1zuUbRzFtKfkLWbnpQnLhHiF7iuYcfU/EeF/h396J/8dk5U6RGccgFn
         mK3Xy/4rNptMaVREoKd7jKVQK4nsGJ5lMJe9zWMh2IVRJSEI2Q6nsnrYsFLx83H2Cy2Q
         jfw+q3CnUo34vDfzpW8B8cGn7+BoQHBSXhiAtyyzM8qNSrc5QxKw72C7CHdk2M+jugxV
         Silw==
X-Forwarded-Encrypted: i=1; AJvYcCVOxrwuQjwsiJXFCKG5Y3vDkrMT4LpcY3JtfPj1YjncyLdl0HMbJIyGVZ4b+qYis8eSZnx72I37wJhk@vger.kernel.org
X-Gm-Message-State: AOJu0YwiO4swTMWD9VSS1tbY1ZoV423c5pMuZQWfbWFt+c7a3D0bmzhn
	BmR35TmNrmPahu2THgU30bC6V9M4G3MzNpUeIByDQMC9aNX+0NYJcJSgRjRrDA==
X-Gm-Gg: ASbGncuQPn3W9k3JxaySNrDgW39vklSz5SXtERjMfrHnykhU+St3SlNr35Vsclo7wpo
	0xTW9wmc8zi0TufpLXmA5AYJVvHNp4kOqq4YDY7FjIe6foTBGbryRDxPLrXHOaxV7hwA1tF3G7f
	bO0OyHmYgdaU0hYfhKxK217XgSHgYcbxXG2BqURLTEE/S+TsLjfGg8BJQUKrvLWGijRhMjW1Z7M
	ko6I/q2G0trTNdAWa+3lapOLJy/DYNnr94B3DZqo/pGzju7CiJUjiFFtuc=
X-Google-Smtp-Source: AGHT+IHU6Xu+n7ZNg85zbpBlEgO5QS7TgqjBuo8IL4KCXkx6Wsj/Pkxh7R3VW7ABG7uDeLGEC57Xcw==
X-Received: by 2002:a05:6830:65c2:b0:71d:ee65:7c38 with SMTP id 46e09a7af769-71dee6581cbmr2249231a34.22.1733717040567;
        Sun, 08 Dec 2024 20:04:00 -0800 (PST)
Received: from thinkpad ([36.255.19.22])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725da385bfcsm2772546b3a.70.2024.12.08.20.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 20:04:00 -0800 (PST)
Date: Mon, 9 Dec 2024 09:33:55 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Manish Pandey <quic_mapa@quicinc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com
Subject: Re: [PATCH 0/3] scsi: ufs-qcom: Enable Dumping of Hibern8, MCQ, and
 Testbus Registers
Message-ID: <20241209040355.kc4ab6nfp6syw37q@thinkpad>
References: <20241025055054.23170-1-quic_mapa@quicinc.com>
 <20241112075000.vausf7ulr2t5svmg@thinkpad>
 <cb3b0c9c-4589-4b58-90a1-998743803c5a@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb3b0c9c-4589-4b58-90a1-998743803c5a@acm.org>

On Tue, Nov 12, 2024 at 10:10:02AM -0800, Bart Van Assche wrote:
> On 11/11/24 11:50 PM, Manivannan Sadhasivam wrote:
> > On Fri, Oct 25, 2024 at 11:20:51AM +0530, Manish Pandey wrote:
> > > Submitting a series of patches aimed at enhancing the debugging and monitoring capabilities
> > > of the UFS-QCOM driver. These patches introduce new functionalities that will significantly
> > > aid in diagnosing and resolving issues related to hardware and software operations.
> > > 
> > 
> > TBH, the current state of dumping UFSHC registers itself is just annoying as it
> > pollutes the kernel ring buffer. I don't think any peripheral driver in the
> > kernel does this. Please dump only relevant registers, not everything that you
> > feel like dumping.
> 
> I wouldn't mind if the code for dumping  UFSHC registers would be removed.
> 

Instead of removing, I'm planning to move the dump to dev_coredump framework.
But should we move all the error prints also? Like all ufshcd_print_*()
functions?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
