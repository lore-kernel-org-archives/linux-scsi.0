Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CFC2500DF
	for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2025 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667784; cv=none; b=QmcRV3BXNIqrZ2IzxDzXgfKhrFM3HArExGExLbLj+/ierzKjsfqYB3tt6euFvJVW10ctqXNcAY5r0z52lclFMPTUASwaUW4yElrGM5p1hS7qEItYkYInvzw1kSNUt0hhcpBEEDin3chFC2+CCKQALmcaM1HqkB8g3Oo5E4CKcz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667784; c=relaxed/simple;
	bh=6faw81wFFaRXZ3ymmYdJwV0mSvCtlP2Ar7QjlZFTgoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMbmUqdKckFfJJ/QcPsw37e20R8KfgyQqfUmh9qCgx+vtr80exgRxLa2VLyPUIGkQ7ZR7HyhxUIZL7+y0VAtl8HmUydjmT/3Bybrgf0MxcWR+xiYCXHA+NQcqxLp4LAP9YlIys8X0XXe+X9Syfm5yCpMPrATbJkBh+9S4Ww7VZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=judPU/uM; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="judPU/uM"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2212a930001so26503375ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2025 06:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740667782; x=1741272582; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=smnGGK6K/Wef+b2awCjLQ7c9xAU1Vqd0Z5QG8gAABNQ=;
        b=judPU/uMsYozBnMd+rF7yQgjRKyWcfspUpOL7O4D6Qu0vGtEQXaW80EAINGBF3aSGO
         noWvuuIibRn7Zf64JOzA405Y+lwU08n/udEMRvSiWCw9cj9YEPb0WR+zUWUhxQMXqjPm
         lGVjMs8dWyyvSOfuqIGCunUofES+wOr51+mci83gfpqgaYYSG1n1jqZcW16M5wCGxQNi
         WVNH28NbJEH931xJd29QZoC0PAk5zghXGwS+sznl4QI05OOadq4XkGOshBP+lGlh93Nb
         d6IN/9auyIcVySUq9YVs+H+Lyc/6ozzn5cMqO5T3t4NsIUb1GZP5IaM+GUbmIccHDuXI
         3DOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740667782; x=1741272582;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smnGGK6K/Wef+b2awCjLQ7c9xAU1Vqd0Z5QG8gAABNQ=;
        b=lunF2fqhWRQTTBDdB0Vijw15Q4vVCHtzZgyKVX6MxpIa68HFsXQVyDs2cPTdbddIle
         RzB23XjW+1Hzv0phs/+hDpi+SnjFHtQkbSxpYqINAokXbo6+4jQtpjktrFfxfJbLfEdd
         brnbF/qbpRJ/rQADcLrd6KQF95tkIMGB+csPFqo2p//p999jmYLj2kaR6f/fV7OwqPp0
         42tMrU9P2NIjalF/Hf05XSV6/K6Uc2caneala0TdnzlLeXcDKqcn72zISoOSUO9zBivo
         YA5Kt+onbOPIfInm+a/QKseFtRVvTd3n57crddg3KQqeqLGK7pdHmBb0AxKl/NzOtxHu
         UoCw==
X-Forwarded-Encrypted: i=1; AJvYcCV6mgt1pCp2tPSeIyF58Q7Jqv1YItrdKSwBkgA1uy3lVkpdB0Qhpmy/YJJvuYkeFGNCfSyHFzVV5Voc@vger.kernel.org
X-Gm-Message-State: AOJu0YyzxGZ43lev751AADtMdl/SNGFh7x8kSkcm6nD4GY1k7d9vW9Du
	cZv1o23vfsgojNnABSW7na/A5/NXPSoksscrdcQnboEusAhftvniDJqwdsJNdw==
X-Gm-Gg: ASbGnct0h8LKkY2RCV0LVhxy5fYNihv2cNJt/cTky3wYPQocTWiVPKvNceLz/Zsg0Ia
	w/7weGZjo7Ye6iHvCxzSE7gIpMjz6JTUJCE3yuB27fCpGqFV6qOJ2y9EFZFg6zPu0/O5gOrnzPG
	efopPNGBXetgbKf1G8HKOTugGaG9WCT0ZWy7xjUT/TJoXriB+Q5Wj3T/Ob/JqV7UQuorwy8sFq1
	dekhv7xseO4g63XieSmgfSVeaCOirsBKsWE37YNx/R/lQNSMzotWmWz+gSm7nVnxubeluGvM1AM
	pspB5CuBBrBr7P+sB/y8T4BiJ8739HQX55aA
X-Google-Smtp-Source: AGHT+IGPbMh9YLaLdnjg+qD36H+rS672w6Z7sxM9qS1ipKhQCSGEXPnAHeWSHqT6Fb4RF7dlqr8/wQ==
X-Received: by 2002:a05:6a00:c94:b0:730:99cb:7c2f with SMTP id d2e1a72fcca58-73426cb3cdamr39658350b3a.6.1740667781668;
        Thu, 27 Feb 2025 06:49:41 -0800 (PST)
Received: from thinkpad ([120.60.51.181])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a0060069sm1661260b3a.159.2025.02.27.06.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 06:49:41 -0800 (PST)
Date: Thu, 27 Feb 2025 20:19:36 +0530
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
Message-ID: <20250227144936.4wrvydm4i4oenszf@thinkpad>
References: <20241025055054.23170-1-quic_mapa@quicinc.com>
 <20241112075000.vausf7ulr2t5svmg@thinkpad>
 <cb3b0c9c-4589-4b58-90a1-998743803c5a@acm.org>
 <20241209040355.kc4ab6nfp6syw37q@thinkpad>
 <3a850d86-5974-4b2d-95be-e79dad33636f@acm.org>
 <20250226053019.y6tdukcqpijkug4m@thinkpad>
 <6eb9ec05-96f1-41d2-b055-56e34d5722ae@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6eb9ec05-96f1-41d2-b055-56e34d5722ae@acm.org>

On Wed, Feb 26, 2025 at 10:40:51AM -0800, Bart Van Assche wrote:
> On 2/25/25 9:30 PM, Manivannan Sadhasivam wrote:
> > On Mon, Dec 09, 2024 at 10:35:39AM -0800, Bart Van Assche wrote:
> > > On 12/8/24 12:03 PM, Manivannan Sadhasivam wrote:
> > > > On Tue, Nov 12, 2024 at 10:10:02AM -0800, Bart Van Assche wrote:
> > > > > On 11/11/24 11:50 PM, Manivannan Sadhasivam wrote:
> > > > > > On Fri, Oct 25, 2024 at 11:20:51AM +0530, Manish Pandey wrote:
> > > > > > > Submitting a series of patches aimed at enhancing the debugging and monitoring capabilities
> > > > > > > of the UFS-QCOM driver. These patches introduce new functionalities that will significantly
> > > > > > > aid in diagnosing and resolving issues related to hardware and software operations.
> > > > > > > 
> > > > > > 
> > > > > > TBH, the current state of dumping UFSHC registers itself is just annoying as it
> > > > > > pollutes the kernel ring buffer. I don't think any peripheral driver in the
> > > > > > kernel does this. Please dump only relevant registers, not everything that you
> > > > > > feel like dumping.
> > > > > 
> > > > > I wouldn't mind if the code for dumping  UFSHC registers would be removed.
> > > > 
> > > > Instead of removing, I'm planning to move the dump to dev_coredump framework.
> > > > But should we move all the error prints also? Like all ufshcd_print_*()
> > > > functions?
> > > 
> > > Hmm ... we may be better off to check which of these functions can be
> > > removed rather than moving all of them to another framework.
> > 
> > devcoredump turned out to be not a good fit for storage drivers. And I can't
> > figure out another way. And Qcom is telling me that these debug prints are
> > necessary for them to debug the issues going forward.
> > 
> > Your thoughts?
> 
> Does this mean that printk() is the best alternative we have available?
> 

For storage, yes unfortunately.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
