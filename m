Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81B6482D7
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 10:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720435464; cv=none; b=li1ZahkuFfCvVX+lgMtJhzwkjbtk9jJI7Mr4AZY07rWi9y39Adjn1YxM75bseJCWALFCEcZVpomOsZ3mcppTuGBUixWu6HVOpWFQXtA3OZSiJX3US5lpZTL82oKN/i/rN9XmGyO9BzaEXdv/MoA+v5KP+fTwyCKH1kBt8lZKgaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720435464; c=relaxed/simple;
	bh=Cz6+CpFcdHPrfHBh2n+FYevYt7MOs4F9d+Ea7oHL78Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRkzAWkPgd5xg5D2nyTcVVDkWyYaeBVK+Ilbhwnv18uWxfq5YATkjxRuZ4kRc5eHLT1JAOZHdJGBYgzlVxbXEgKXXyUeOdIYcUJD5R7fvo1AF4Xpe/veRZrC+FBJZKPkYEz17DqY+eVydNfMZiqLJg81B3dPdYXmEnEL1CsNEKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ifWrGUrN; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ifWrGUrN"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70af2b1a35aso2174427b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 03:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720435462; x=1721040262; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bDZfvvagOLHrUJ+B6QQBzaN2tuRYIbx0DLLJSk53LB4=;
        b=ifWrGUrNTQDNY5p6flvMHPLbu3gQ3Jcx/BwSUsaej7zM+j9Li8/67ndyANI6RkRxwm
         CeLhyiXBBpGDSGRvM1S599CZ2Dn6LAtoAsGLpR22lByTomqMWRSz/MEtovk/61vtB7pJ
         sz+lF45/XoXcKo2GLca/aarrh/qRG0FK7PjuuYfxoqdnxilvY15cGBRUuqyzLW/QHGrQ
         0oO0I+N1TMbRwedzr2SRTgTSoyU2wmbRIjmZ+FFCH8X+3RoLniyMdXXN7EQ28pS5NB2P
         sKRYJG2FdbGJZo1Imyt/GtKRiGHSV+l/sBq62L3MvszSeQqlxa6ZNM9Pjk94M8pTijB4
         dOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720435462; x=1721040262;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDZfvvagOLHrUJ+B6QQBzaN2tuRYIbx0DLLJSk53LB4=;
        b=FYmx+mwZQClgpZXtl7nVBpQPZ5wc9IEm4lOc/DCK4u8jNlJYTGM6oPk1VwHCtsDfPc
         tTl+7nhXwWEYd62BW5l+kPJaZVK14yYeKFPU23IMJ3qui+IEZRhHggogrl0nxP3euZy2
         V2KQCZxoQkbSq6iQ6dnjAkCFwHIKrjC+NYy95YsLZNnhVze7pzi+VPp1RaMJZGDDfctw
         aPrZQVXiDHDSzQAIZKFT20QRJLc9oicZwVBFcmkSMv2oGsN3VvTqSBBTmG65e5rJscV2
         4Vwx1OzDaJxhM5p+fON2ZRT2HdZ4rjAyVV/q0U7mJI6n78fNuwpNdZMOkI17bkUmxJLf
         HaLA==
X-Forwarded-Encrypted: i=1; AJvYcCWnn4HKkvncODkBEQJNvyMNSVSsYUCGk90O0IZxRt2UQosojUfsU31XAGQpBCTAJ5NF6W9TdoPTAkj0Nh8zXzhpzwSOW05l7oQdCA==
X-Gm-Message-State: AOJu0Yx8riusBPTGzVfXQtVpdh8kuYyG0NXuMdV4dMmeqk3hGJ1m1bNx
	ovIH6Jet41F4cladAG+6nFEexrywC4wOewp0Mye+3Kx4UwVzTroaTr0jEXp3zw==
X-Google-Smtp-Source: AGHT+IGVMdiJ/veAGTyv/vD7ntPgzuTOhfBVXu3IF+qH9LDf2W0o/78tK6vufqf3JqwlZTI59jcmsQ==
X-Received: by 2002:a05:6a00:2192:b0:706:5b58:464c with SMTP id d2e1a72fcca58-70b00945ca7mr9524435b3a.9.1720435461933;
        Mon, 08 Jul 2024 03:44:21 -0700 (PDT)
Received: from thinkpad ([120.56.193.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b1d9bbaedsm4330003b3a.172.2024.07.08.03.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 03:44:21 -0700 (PDT)
Date: Mon, 8 Jul 2024 16:14:15 +0530
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
Message-ID: <20240708104415.GB5745@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
 <20240703132202.GE3498@thinkpad>
 <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
 <20240706163321.GA3980@thinkpad>
 <8544aa91-1044-41df-8650-2a3fa3d58016@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8544aa91-1044-41df-8650-2a3fa3d58016@acm.org>

On Sat, Jul 06, 2024 at 08:24:06PM -0700, Bart Van Assche wrote:
> On 7/6/24 9:33 AM, Manivannan Sadhasivam wrote:
> > On Wed, Jul 03, 2024 at 01:36:46PM -0700, Bart Van Assche wrote:
> > > If an UFSHCI controller is reset, the controller is reset from MCQ mode
> > > to SDB mode and it is derived from the hba->mcq_enabled structure member
> > > that MCQ was enabled before the reset. In other words, moving all
> > > hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
> > > break the code that resets the UFSHCI controller.
> > 
> > Hmm, could you please point me to the code that does this? I tried looking for
> > it but couldn't spot.
> 
> * There is no "hba->mcq_enabled = false;" statement anywhere in the UFS
>   driver core. This shows that the reset code does not reset
>   hba->mcq_enabled.

Right. So this flag is used to reconfigure the MCQ mode upon HCI reset.
Previously we never disabled MCQ mode as well. But that is being changed by this
patch.

> * From the UFSHCI specification, offset 300h, global config register:
>   in the "reset" column I see 0h for the queue type (QT) bit. In other
>   words, if a UFS host controller is reset, if MCQ is enabled (QT=1),
>   it must be disabled (QT=0) until the application processor enables it
>   again.
> 

So this means, once the HCI is reset, the QT field will become '0' by default.
So if MCQ mode is supposed to be enabled, then driver has to explicitly enable
it.

But only place where you disable MCQ is when ufshcd_alloc_mcq() fails (in this
patch). Then you also set 'hba->mcq_enabled = false' afterwards. I fail to
understand why you cannot move the assignment to the enable/disable API itself.

If you do not set the flag after calling the ufshcd_mcq_disable() API, your
argument makes sense. But that's not the case. Perhaps I'm missing anything
obvious?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
