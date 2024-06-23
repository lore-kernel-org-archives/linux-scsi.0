Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5012E1DC
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jun 2024 13:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719149613; cv=none; b=FtYGvgyHgeEiuyoXm8+CiZCZXYzoQqDut20K8p5E47lgIup0OU/V5Rvmsl9M0mxTtQt/U3t8gRQU4uUYjmtiy2kcVMaIROkIfCadb4dxXK9Etf5cuHdhaFXcYno/YEPlI3h8jpxZ/974piQMVo1WbI2Qsa+JTPHI44DS+CqoH1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719149613; c=relaxed/simple;
	bh=hc5SF8FjVQpDJoNOLTsMUwiLLcGKL75MRESV6AnEc2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2eXzmw3xg8aQg9eZa+qxIUox0ioETc070UH6ihhwKWnGcLiO4iMb+JbHfo6+NN6EEnakYKFtOAalHq+4BLwz5w2fAqSnQd+/OF43Cvqi7PxFW3+cqt9lb+7JmMwjGvOXR+oYTrKgS3rMd3IUsmMKbs4c3gn6BRY3G42NTXeM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kJALk6L9; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kJALk6L9"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6e3741519d7so2337787a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jun 2024 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719149611; x=1719754411; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ns1fnTzTdUmb1vc2WkiRdixgl1ZW81dp3irGq6lM89Q=;
        b=kJALk6L90EOHkAHr/HEAGuMcaHjp6Jwe5nxJl2n6Ju25P4Ev26Z1xg1C9hVQoWPDDg
         9XDvxWZSTMh97qpp+9tNFKfwTQOMvGQI/PpzIxgSqWTAf3/5iucem5BB3N4JGiUzRmWX
         HZyNuwDMLTxBCd0xVu3akLTPWu17KFjkUd0vePDJY0Zpq/1x7+lT/EOSFFxsmQTRPk0h
         u/5lWP679ITfWekW3eQKdgrx007IzQH8SS75qjSYVNvA+gZXorsYBZzBbt1P/VTRacjy
         mujmlbFiXoqOYzHwhwy5fQIDOuwLIRknn+JJvoU5oQTUY/GTj6GIaPEFxxmaTTfMcurm
         9lGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719149611; x=1719754411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ns1fnTzTdUmb1vc2WkiRdixgl1ZW81dp3irGq6lM89Q=;
        b=srcWxZo+OYqdIx6DUELyqzIkyFCGdAi/EsUoNdXH6+GTOJOLRPSFiolmRJGmCtZ7Z/
         ax1GH81XQ0OMaQsVYL70Zs330msbgTjc/pqbvP32RQGnEvvHj5kRJxbu0I8Iz87I/FcK
         P50q7w0zrT8+98MW0K6GFGWctCOiXF3FhWIH2k1pWIT32ju0gPew/6xgNt5t/Cn22sgY
         Rmhac2zDwcjKY1ELAvMMe6BlqptgJDqHM92gfH33uRmP348xhkq9hkQr5z8UI0fC1yNf
         OtRDkeqPHs57jkTl/7BibVgGKSUjyO6tYGtPRaxLhDhfpOB4MvHht1Ob+z13xPG2r2uV
         053A==
X-Forwarded-Encrypted: i=1; AJvYcCXI3bc+C3/nqAkXVfcAG/QbMOmUPB4778EOomdTguiHwt+D33v6IczUjwglqC10i/mULulmQKJELtdXJp6D1kYROPL6spcZ4gP7mw==
X-Gm-Message-State: AOJu0YxCFq9WtGVHthALiQY5s5e/yvzfG9wCA83Y0iDQsKrry5sqEOps
	DMao/XokeadGeermh7KPPc3MFJr5aiivTD7UlnulQkmEbsCAl0mVsN6KbZtMQA==
X-Google-Smtp-Source: AGHT+IEBDU6jiDDkx8mwYzJEcQxj1Gize1uLoiJ/JceB7ug9qw7oF37SHdztfQwAq6WPS5ng7QNX7g==
X-Received: by 2002:a17:90a:8c7:b0:2c7:8a94:215d with SMTP id 98e67ed59e1d1-2c8504f40a2mr2080599a91.12.1719149610978;
        Sun, 23 Jun 2024 06:33:30 -0700 (PDT)
Received: from thinkpad ([220.158.156.124])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e64a1d9esm6890937a91.56.2024.06.23.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 06:33:30 -0700 (PDT)
Date: Sun, 23 Jun 2024 19:03:24 +0530
From: "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
To: Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc: "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Powen Kao =?utf-8?B?KOmrmOS8r+aWhyk=?= <Powen.Kao@mediatek.com>,
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240623133324.GB58184@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-5-bvanassche@acm.org>
 <20240619071329.GD6056@thinkpad>
 <20240619075731.GB8089@thinkpad>
 <93539579c4eb5bacc9dc9afb726294f44cec7dc9.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93539579c4eb5bacc9dc9afb726294f44cec7dc9.camel@mediatek.com>

On Fri, Jun 21, 2024 at 03:32:18AM +0000, Peter Wang (王信友) wrote:
> On Wed, 2024-06-19 at 13:27 +0530, Manivannan Sadhasivam wrote:
> > > > --- a/include/ufs/ufshci.h
> > > > +++ b/include/ufs/ufshci.h
> > > > @@ -67,7 +67,7 @@ enum {
> > > >  
> > > >  /* Controller capability masks */
> > > >  enum {
> > > > -MASK_TRANSFER_REQUESTS_SLOTS= 0x0000001F,
> > > > +MASK_TRANSFER_REQUESTS_SLOTS= 0x000000FF,
> > > 
> > > This should be a separate fix that comes before this patch. But I
> > believe this
> > > came up during MCQ review as well and I don't remember what was the
> > reply from
> > > Can. 0x1F is the mask for SDB mode and 0xFF is the mask for MCQ
> > mode.
> > > 
> > > Can, can you comment more?
> > > 
> > 
> 
> Hi Bart and Mani,
> 
> It is correct that 0x1F is SDB mode.
> ufshcd_mcq_decide_queue_depth is running before mcq enable.
> So that value read is still SDB value, not MCQ value.
> 

I don't quite understand. My concern was that if we change the mask for MCQ,
then existing 'nutrs' value for SDB could be impacted with this change.

Perhaps we should use different masks?

- Mani

> 
> Thanks.
> Peter
> 
> 
> > Oops. Can is not CCed. Added now.
> > 
> > - Mani
> > 
> > 
> > > - Mani
> > > 
> > > -- 
> > > மணிவண்ணன் சதாசிவம்
> > 
> > -- 
> > மணிவண்ணன் சதாசிவம்

-- 
மணிவண்ணன் சதாசிவம்
