Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967EAC8E1
	for <linux-scsi@vger.kernel.org>; Sat,  6 Jul 2024 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720283613; cv=none; b=NxRnkW9cpWSsksRIZN1vIBQDxu0YhmtleP1VXNzDQOw78UUODype2qpvuS68sOo0d6fi65D+2q1/bQbgY9cu0xJslJHl/n6KpEyoFWbpvXcvn2VirayYuWiujvHNjb/bIH+M4lftgEBGW3a3v8iwWnY/QyhzOHNXgQIfedSONCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720283613; c=relaxed/simple;
	bh=TuUKXJuHDG5++oHzVNPgpJzk2789U9tGiFfbccHCWVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUxyR8tJjGqJCSMbsl8aCKRRE7rhzHGiv/182FrJ4m5aLkOh2fHbJ7VZ+YxWKiKqPolVj9pBHonjHw8kfeFACa4d1i+oUtRt1jiD6YdlD13PMKWTlJODAvn6MYw8tbt6x99cHMHSHK5jcetRZ8dxR5BVhChqyyjyxSrci8F3Gas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bn/uxfcZ; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bn/uxfcZ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-710437d0affso1514217a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 06 Jul 2024 09:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720283611; x=1720888411; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sWtZTW0mm6Moxq2yomwxzKgYnwEqenpYGNOvkcYZ2gM=;
        b=bn/uxfcZJKRgGg9+eSHjK46RWZ7wN2WrPG8G57TDYyD27EuGJzAHin3YKRSt4D/OfG
         32kIDR+aL0yPF2kIuAmtYP2MP9T3mxOQQ0EOjpbNsLqCz1Qjby61phPdpt9pGvMV0IF7
         KKyNaCZN56A3BjcOLjfiBRqq/EK7R8nN2c6a1wfxCV2VU883pzeHmZpfPglEncEaVPjB
         kVxtCdDvh1md1nfEvOLjcreb9ytTlhW2UF5q+dsf1KtsmYcnJ3hHOugepBFvGDXb4JEV
         Vf1Az5bZW5m4C9ppD1R+lJqXmfROhU/XMcN9kgoVV/jmT5/YCRN13Xu90w0oGxm7u+X8
         X03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720283611; x=1720888411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWtZTW0mm6Moxq2yomwxzKgYnwEqenpYGNOvkcYZ2gM=;
        b=Tbp6Xo3sws9FACMg6hzprUOiMELILUt5/ZxLRl4kiI++bYq29T6e3G3J4dvdhjRzno
         D4b0H3jlB0GmfjgqKLuZEQ/Lhq+ZXILbGg4wCy7DiUrYdDNX63JL7h55pb+F3dnhyQEz
         kdzTTwonJROmqa5yrxtapZbfNF7cSi2mmWJ+nbSJWdSmhuH0VUD6tG0d1gVF7We9SB+D
         Lo0nrdyGYaQBmY+vgxIuEOOIfUjUBY2vlNQAOQFPOxK9YF6HQxiitkJ6DfSmt6daQ+ne
         0kpvtLPGVvQzjJWQP/81bQSOBzM5MEWy93G2fpGsbuGas359HYGBQk85Q4J+XVL4h2h3
         Rdbw==
X-Forwarded-Encrypted: i=1; AJvYcCVmrCRbdQZV9tqIP8PUE8aqgc57q1UkfzTvd79u0xul2oR4jCimwXrmHbi8iaX08OTDgHV7G4yCLlj7SsPZLQ84sboNvg/gN5d+5Q==
X-Gm-Message-State: AOJu0YzV8gJJ8fS8Q5AURuDD77uM+O4/zwsH8i43rgyZiJdz+2DE3//O
	xXs+aCRc7EMNyB2gYbeSIwdPEKssOYAuFfQSBL8N3OCKquJtFWHPnTe3BlG1cg==
X-Google-Smtp-Source: AGHT+IHuENQ/ImN37Us/SGIiu9gCWEAUpxYHKhdxRUjD+/mmLZYzKMp3xXJrdjSMM0vGO2YIh/jT0g==
X-Received: by 2002:a05:6a21:6d98:b0:1be:cc74:5818 with SMTP id adf61e73a8af0-1c0cc73adcamr7484248637.12.1720283610717;
        Sat, 06 Jul 2024 09:33:30 -0700 (PDT)
Received: from thinkpad ([220.158.156.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb4572b1a6sm35744825ad.196.2024.07.06.09.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jul 2024 09:33:30 -0700 (PDT)
Date: Sat, 6 Jul 2024 22:03:21 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240706163321.GA3980@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
 <20240703132202.GE3498@thinkpad>
 <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>

On Wed, Jul 03, 2024 at 01:36:46PM -0700, Bart Van Assche wrote:
> On 7/3/24 6:22 AM, Manivannan Sadhasivam wrote:
> > On Tue, Jul 02, 2024 at 01:39:17PM -0700, Bart Van Assche wrote:
> > > -	mac = hba->vops->get_hba_mac(hba);
> > > +	if (!hba->vops || !hba->vops->get_hba_mac) {
> > > +		hba->capabilities =
> > > +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> > > +		mac = hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
> > > +		mac++;
> > 
> > Can you add a comment to state that the MAC value is 0 based?
> 
> Sure.
> 
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > > index b3444f9ce130..9e0290c6c2d3 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -8753,13 +8753,15 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
> > >   		if (ret)
> > >   			return ret;
> > >   		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
> > > +			ufshcd_mcq_enable(hba);
> > > +			hba->mcq_enabled = true;
> > 
> > If the 'mcq_enabled' assignment goes hand in hand with
> > ufshcd_mcq_{enable/disable}, why shouldn't it be moved inside?
> 
> If an UFSHCI controller is reset, the controller is reset from MCQ mode
> to SDB mode and it is derived from the hba->mcq_enabled structure member
> that MCQ was enabled before the reset. In other words, moving all
> hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
> break the code that resets the UFSHCI controller.
> 

Hmm, could you please point me to the code that does this? I tried looking for
it but couldn't spot.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
