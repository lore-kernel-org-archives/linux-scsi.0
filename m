Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6512F2EB02
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 05:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740547826; cv=none; b=QjryxDzhhK2Jx0qGybqQqnmxs/EG/5mpfyavDdIvZz2F7bLkq1eF38edCFI7JQ1W92I9ZxCSjwnWnzNGcbkUVsA5UVycERdGY2pYPFolAORPq7h2J8dR8EMQmDA78H+phnHT49JmQdJjf83jJ0hEQoQzCXw3df/KtHjBIg9oY6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740547826; c=relaxed/simple;
	bh=PDCwV3qdEOjxXIjtKkWf5Vz2HcCqhICawWEfa4yI5K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+9TQLCt8a2M5kCzKMrq/wXb72NXLqXE3jn3Emn7eBHP2xbGbLVIhlwdoHojWuCbOQxh85I9EV90JL6cgpGtsmjaruh32sLp2z3vwFdcUN2+UyyIgiM10KJ/dROL7ZT/2EUrHlcfFj9ydU4pTs/OsmFhvO8WwkZsLsvYd8lU1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hoKf9oVM; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hoKf9oVM"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-220e6028214so139634515ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 21:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740547824; x=1741152624; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ysxu4HBM1PvBAX3G7aQAJNrxG8wBMOF98K3kSzCpKb4=;
        b=hoKf9oVMGq/+2ovy8FOqD2fmzLHSTD8lGrmrZtUKQC7itxUJJAsI+fR+xw1l+RYBmD
         Ljf6IgoB6vTyHnWa4Wsp4cEff0bvxOr5Zl5bIPXewCJuMn4jkgnHrBe5bJYJxNn95T0g
         9Aj1ddGjbZ2QZdMcAqEiy3jOeXNlop7sABATIrmL43bVSHBvuqEwN4P95MtxaB6XdNHu
         ZHn8xbComngq+Pocw2X1PxoBLcb1ViyAzCwjN2zlHoO4a1Gc8KjZc9WDw0rIlRsOLCl9
         gcGSNCvvs4W20XyQjioyWvCflTIgoYEjvRfju2I9En4zpMKAt3Bq+O+lc/CNHdPLLYia
         i57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740547824; x=1741152624;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ysxu4HBM1PvBAX3G7aQAJNrxG8wBMOF98K3kSzCpKb4=;
        b=o2WTfuo+PcfbklQ5sEQC3plXYe04H7jW+p/dyXD30InNkoJoxSHNeBRSr2k8ULpYte
         /OFf94uEBOtS8PO1ppkpZ0bkyfae7+3yy7ryDUQezax20FBfJbrxtvq2MJWrzyFkNxjO
         OsFkWmVwVD7ylxJXp1T2IS+mJ24J71OAYOeWZ6UCM8TyYgoITLZIclYJUytBUF8i92BA
         me4mP1aZ9yAYXq17Q6Cahyh3CpRlB6ITH1u7qnbGLuNNPb2GUsKLBplQ7q6ZNqGCtqex
         e9oJ86zYfnHbl3nTBZRajVjqcPUSRy7vJ5DyhxUqD4mkIRw0vAsH/tHpLYy42Jq2WMs7
         XXUw==
X-Forwarded-Encrypted: i=1; AJvYcCUl1P8n8z3zW1jWlJOLNjglC/jKVjjzpz6h36qodeQJ0ItHnTxnNCuf/r999AerJW+EAuNQcvJqjhap@vger.kernel.org
X-Gm-Message-State: AOJu0YxOdr4HzmGTxf3IGMpfSvziWNgp2AmXJH69RLCrJGLHzUKkH9AN
	30XIwX4Kj7adj8DxfkX4mtmsD5VE7zdF8wUlafRzQKZoYek70+oJW/m64ZmzHA==
X-Gm-Gg: ASbGncv3DNQvi+q5/vUVwD2YC4SjBupKeZeyVPiopH36dPJRCavpGfrfOB/28LTbz9h
	EDyT9IZXCCt8W/Xdwj7bhJ0laYRsr3UGzoLRoYrJ1SNQi0+YcBx/voIc5/PFuy0QNSwzoYYiTzv
	lFjj0gOSaYwxUPFsY9TfIXjTA4ZTPOT/k/58rhOo5Y39aDeaSI079Ao8x60r09YLi6x7XgAyLGG
	DxFIZSb5Vhf5asHOZStbEhyIFNGrIJOVThucioUpT6yUN3NYLvi6gWSaxWJSLePNYPm4XNetToq
	r3wWezrwQPqAT8hIbMqRBzkUYOYFO6ro1L69
X-Google-Smtp-Source: AGHT+IG1ATYcBA3Lx5kX9fxW7lirbjTeUCqtNQ1K3OphxIX9hK11KaA9lvhbUyRdKaGgUECgCpTu2A==
X-Received: by 2002:a17:903:1c4:b0:215:5ea2:6544 with SMTP id d9443c01a7336-2219ff827b7mr300683495ad.7.1740547824537;
        Tue, 25 Feb 2025 21:30:24 -0800 (PST)
Received: from thinkpad ([120.60.72.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a0a6252sm23604675ad.186.2025.02.25.21.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 21:30:23 -0800 (PST)
Date: Wed, 26 Feb 2025 11:00:19 +0530
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
Message-ID: <20250226053019.y6tdukcqpijkug4m@thinkpad>
References: <20241025055054.23170-1-quic_mapa@quicinc.com>
 <20241112075000.vausf7ulr2t5svmg@thinkpad>
 <cb3b0c9c-4589-4b58-90a1-998743803c5a@acm.org>
 <20241209040355.kc4ab6nfp6syw37q@thinkpad>
 <3a850d86-5974-4b2d-95be-e79dad33636f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a850d86-5974-4b2d-95be-e79dad33636f@acm.org>

On Mon, Dec 09, 2024 at 10:35:39AM -0800, Bart Van Assche wrote:
> On 12/8/24 12:03 PM, Manivannan Sadhasivam wrote:
> > On Tue, Nov 12, 2024 at 10:10:02AM -0800, Bart Van Assche wrote:
> > > On 11/11/24 11:50 PM, Manivannan Sadhasivam wrote:
> > > > On Fri, Oct 25, 2024 at 11:20:51AM +0530, Manish Pandey wrote:
> > > > > Submitting a series of patches aimed at enhancing the debugging and monitoring capabilities
> > > > > of the UFS-QCOM driver. These patches introduce new functionalities that will significantly
> > > > > aid in diagnosing and resolving issues related to hardware and software operations.
> > > > > 
> > > > 
> > > > TBH, the current state of dumping UFSHC registers itself is just annoying as it
> > > > pollutes the kernel ring buffer. I don't think any peripheral driver in the
> > > > kernel does this. Please dump only relevant registers, not everything that you
> > > > feel like dumping.
> > > 
> > > I wouldn't mind if the code for dumping  UFSHC registers would be removed.
> > 
> > Instead of removing, I'm planning to move the dump to dev_coredump framework.
> > But should we move all the error prints also? Like all ufshcd_print_*()
> > functions?
> 
> Hmm ... we may be better off to check which of these functions can be
> removed rather than moving all of them to another framework.
> 

devcoredump turned out to be not a good fit for storage drivers. And I can't
figure out another way. And Qcom is telling me that these debug prints are
necessary for them to debug the issues going forward.

Your thoughts?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
