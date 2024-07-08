Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519B9149C60
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720461990; cv=none; b=jFkXPu7DjvWnsqtbSwCw2xSIT2OyJ1yztbOwS+KT2uDPLK6i7cveU3sW+BmE/U7p4YNe5arXWZnRT0ixtkYgMSXHSI5uYeH65AiQ1qAmDHINfbr/TlBaK2UEGGmV5UlHhC0uIBbiMLImb2vuL6idKnSOCW67uGJhXNusql2Hp+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720461990; c=relaxed/simple;
	bh=KaqAKPRfso5meJzFln2cLYV1G7rMMqgmLaYRRENW7OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsoYS3cYwdSYsCKh0XMtshhzgWsSAshuLGJad0pY4hx5zMb3nIsb0koZd0f5J64a1AxSwCkOyeRTR7OrqJPBtMjal/nG/RjYnrQa/6UBg4wRwevISoJcUXKajpVYbBC5ZP6ndHZb2B/5032RcaShuTIbA2x3SkUwZcHWPnRZVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M+51SPes; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M+51SPes"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7669d62b5bfso1791665a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 11:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720461988; x=1721066788; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rgb3hVAm3eX39WO2ENiEeQ2vupPW+qzrRGUnmXGGYmI=;
        b=M+51SPesZbnRkJMmtnCIqEyHZhH1mYCxiWuf6h+IS8s4U0tSHImGEVEpE6OxeNL19H
         3LnwDq54JIHqEcnpaO9ZcAASS6ZzWQHWMA9EYR8vHvtTVmgY6JIxlNGiDbeJtG/UWS2s
         VDI5f21puJEjeFDTQlgKZoVv0omEWmXPvzH518GP9hnNOgPJ6CL35iBjBxWSf9THIRec
         MQlBUimPNIoNmPgXLsZZNx+nADnp5brqo2t9+HwrlOZEaU7GESZ0jijOdr8Y7UJaJorP
         DiPFcXCVJAtlwb1qBFrfzV5SweitLAhh9rruOFntu5fCpPmXboJDHXKI/NtKCUpaH3Ej
         sy6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720461988; x=1721066788;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgb3hVAm3eX39WO2ENiEeQ2vupPW+qzrRGUnmXGGYmI=;
        b=W5dzn3Cwn3p3lcyBZEPdHy6wB+TA7e2lal3E2tb73XE7SPKymgk0Bkjm2pfsCyspfv
         nS8/fouO2YDu2jBoK5q9OFdh7+MAdG7dcstDB8kXUFrkxBSnjXRAsXjrDDFR5AEy+9nY
         TK/zDlaQKA9r4DfC2DRsSrIsJcxbTnuXW/eP0dZR/Z5UblMqN4ZODQQVOZzLwzlhFXY2
         kRuPTjcI91sCaDh6Li+P2UKUoIY6L3yMYffPLMWs8oC6vd3R3nRL+j+lIM4LIwUrbmIQ
         ufkCTPZtfjVztJRe6P8C0HKEzGl+cYtjXhkClpjS2YZXlECQydkSqGxhzo/eZzrifPDY
         YHVg==
X-Forwarded-Encrypted: i=1; AJvYcCVYVL4c6z/3ZfAy19vm0SgZxyzWcHfFZVFsKhCG3Rl2aBlaURQorD7fUgQk5xREA2fsVWdFaFShdQne9DyrH+mbmp/+11f65Gil2Q==
X-Gm-Message-State: AOJu0YwBpBYPv8Ya/TEFkp/NOxRJefZHQoYwnNBMYwHVoLAxe8cR9O5G
	CRfPMna7kLlLg/rd8kfv1lGIXpK+v2pOLcCrHvnnDWQZ9pgJNYAY+kB/gaHxTQ==
X-Google-Smtp-Source: AGHT+IE/NbmCp7SRBX610mXxFsAxREnIM0ONPRiqSnSe7BvVyUarq/RXkRDIVzzBN4gy0JuErFXQAg==
X-Received: by 2002:a17:90a:bb09:b0:2c2:faf7:67a0 with SMTP id 98e67ed59e1d1-2ca35c25792mr400037a91.16.1720461988457;
        Mon, 08 Jul 2024 11:06:28 -0700 (PDT)
Received: from thinkpad ([120.56.193.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c99aa8d106sm8493111a91.50.2024.07.08.11.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 11:06:28 -0700 (PDT)
Date: Mon, 8 Jul 2024 23:36:20 +0530
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
Message-ID: <20240708180620.GF5745@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
 <20240703132202.GE3498@thinkpad>
 <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
 <20240706163321.GA3980@thinkpad>
 <8544aa91-1044-41df-8650-2a3fa3d58016@acm.org>
 <20240708104415.GB5745@thinkpad>
 <f40ce193-1abb-4518-9cfe-5e35af636502@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f40ce193-1abb-4518-9cfe-5e35af636502@acm.org>

On Mon, Jul 08, 2024 at 10:10:43AM -0700, Bart Van Assche wrote:
> On 7/8/24 3:44 AM, Manivannan Sadhasivam wrote:
> > On Sat, Jul 06, 2024 at 08:24:06PM -0700, Bart Van Assche wrote:
> > > On 7/6/24 9:33 AM, Manivannan Sadhasivam wrote:
> > > > On Wed, Jul 03, 2024 at 01:36:46PM -0700, Bart Van Assche wrote:
> > > > > If an UFSHCI controller is reset, the controller is reset from MCQ mode
> > > > > to SDB mode and it is derived from the hba->mcq_enabled structure member
> > > > > that MCQ was enabled before the reset. In other words, moving all
> > > > > hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
> > > > > break the code that resets the UFSHCI controller.
> > > > 
> > > > Hmm, could you please point me to the code that does this? I tried looking for
> > > > it but couldn't spot.
> > > 
> > > * There is no "hba->mcq_enabled = false;" statement anywhere in the UFS
> > >    driver core. This shows that the reset code does not reset
> > >    hba->mcq_enabled.
> > 
> > Right. So this flag is used to reconfigure the MCQ mode upon HCI reset.
> > Previously we never disabled MCQ mode as well. But that is being changed by this
> > patch.
> 
> Only in an error path.
> 
> > > * From the UFSHCI specification, offset 300h, global config register:
> > >    in the "reset" column I see 0h for the queue type (QT) bit. In other
> > >    words, if a UFS host controller is reset, if MCQ is enabled (QT=1),
> > >    it must be disabled (QT=0) until the application processor enables it
> > >    again.
> > > 
> > 
> > So this means, once the HCI is reset, the QT field will become '0' by default.
> > So if MCQ mode is supposed to be enabled, then driver has to explicitly enable
> > it.
> > 
> > But only place where you disable MCQ is when ufshcd_alloc_mcq() fails (in this
> > patch). Then you also set 'hba->mcq_enabled = false' afterwards. I fail to
> > understand why you cannot move the assignment to the enable/disable API itself.
> > 
> > If you do not set the flag after calling the ufshcd_mcq_disable() API, your
> > argument makes sense. But that's not the case. Perhaps I'm missing anything
> > obvious?
> 
> What do you want? That I move the "hba->mcq_enabled = false;" statement
> into ufshcd_mcq_disable()? That would be wrong because (a) it would
> introduce a confusing behavior difference between ufshcd_mcq_enable()
> (does not modify hba->mcq_enabled) and ufshcd_mcq_disable() (would
> modify hba->mcq_enabled if I implement your proposal) and (b) wouldn't
> reduce the code size because ufshcd_mcq_disable() only has one caller.
> 

No, I'm not asking to move the assignment inside just the ufshcd_mcq_disable()
API, but for both. You are saying that doing so will break UFSHCI reset, but I
fail to understand how.

After your series applied, 'hba->mcq_enabled' is set to true in 2 places of
ufshcd.c. And in those 2 places, ufshcd_mcq_enable() is accompanied. There is
only one place you haven't added the assignment which is during the start of
ufshcd_device_init()::

        /* Reconfigure MCQ upon reset */
        if (hba->mcq_enabled && !init_dev_params) {
                ufshcd_config_mcq(hba);
                ufshcd_mcq_enable(hba);
        }

And this makes sense because, if mcq_enabled was already set to true, then you
are not setting the flag again. But even if you have moved the 'hba->mcq_enabled
= true' assignment inside ufshcd_mcq_enable(), it wouldn't cause any issues.

Where does the assignment actually breaking the reset code? This part I don't
understand.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
