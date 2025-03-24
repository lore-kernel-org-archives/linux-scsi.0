Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7D257AC2
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 07:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742801977; cv=none; b=V3bNwsMKJH3SH+76CVbcEX27zWndx32jyL7ul/zfCNKpSUHizHCEAdMhFri/cfecOwYIUJpnlDaF51K0RC93/WmrkMQacKPN7f5Ly6+NJJqI5V5wlB0VKx5zrgsRBYfUhExVw1xJ7BnvJ3YlVH1Gazc8eYUF/BnrR+zQSfE5QZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742801977; c=relaxed/simple;
	bh=/E1+CdUd622YHSdavtWVNjJeqQ3x0Q9Uv74BQL9+Btc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8wtGGh6bvJmUM3mFToFM2XahJk3e/y5kB9/np4ckEFl77xjCD2xIOSegPOInqW6IHPLwPfKJHsGdqI/lncnNSiSYvK60xVx79tBFkdRFq/+X/K7Zl3pI+8kyEle7tepXOwDjL8XVM/kSBcKwilqSIIcv06rfEGh4tiOqmWzuIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FLKVB7p2; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FLKVB7p2"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-224171d6826so57402975ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 00:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742801975; x=1743406775; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SxcFj9fapiNOLa4zKIqkX0qfsgj2Wcwr7I86fBYGV1c=;
        b=FLKVB7p2BAPSLHdcTWEku7Jr8bx28PABFcTQNHgT3LD2H7FnjPSqljbJlAw1wClIrW
         oJxmtGu2UQkD5foeSAHUjvqz60TPkhnf2wx2NYsTz3YmfYRNEKsN/nADD3Ze1Jb1Hmpk
         FGC/vjcseCeuT6fXeD6HrViyOfRqRy8r+sPanCOj5fAIquYygjY+nxZa8LrOUrne+gqJ
         pWP/tG/UNcNG6A29tkYNYfSiWuNI4Y5kym3lQhQsEUWlYeyqk/XZ6RGnbCNHqLW3J3Yx
         LlmTASDqWn2ba/Qu3lDaZqLocCKYfWfurrQ+npDAte7WGc9HpvNFv1IhX98k5tb+DH4p
         QfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742801975; x=1743406775;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SxcFj9fapiNOLa4zKIqkX0qfsgj2Wcwr7I86fBYGV1c=;
        b=nUFVVrnUgQD0pjt7Ucj5goJtO3bv1x0cHIFxglbX/aKiZCXUWVFfKDMdQ9dd3fYI7Y
         1NTbi/IxmSN2f/Kyp4V1aIAf1fQ7OykmEtnYakwOyhOm/nlF12edlQIHDu5m5zinLO+E
         gTg53siqIYxqTrmJsmjwsfw5hapG46TNWVe4sBHZgKVCOhcaV70qB7uiN+fcFx3In9ps
         kC6+5CqdQxB6ksRDNAS8rWSD9d7QmKpcgmjh7TK1eifWYAvjQJr/z1Ju1Q0dUC0rgPGP
         fvcruudG5Ws4lKxaOH4rg69nrlNOzbSrqw5OnfZ5Is8jU/GZU3YlCPdee6tlnA7tWULA
         ChNA==
X-Forwarded-Encrypted: i=1; AJvYcCUxazAIPoB46rPKAL8vSfhOI6JXhNHIe/FvWm/Q2mZDWA+f2uD9GqR7GsBMHmmcDIqbduXAJcGSZumH@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3s2t5arZp3o+Xc3JjGqJ2cSG0jDVSwFsNKIuK/S1+ZWjwjAZ0
	KEItwv8UAz9kd1sp0n4cxGox8yj4DdMZIHBQwz9V3YkiPuoMxkZ6DtOzSiitPg==
X-Gm-Gg: ASbGncs8jp0r8pV1lWrUFsSfAxFGqo7au6NpQ8nlosEoFTl8TnnBhcGsl3Togy0G6nX
	7mGud5w8bIl2KunkkU47r6nhszSKluec7XMqHqsVkyMH8cw6ATnHqTG1GjX8qRohFZqlp3dBRK5
	15U2Lai9gcSliCIfjf6QqxN/O/fBQ36D+ADgNkBDsPEPtcg+a1uXj/5X8OqL/mBXjToPGIRkq58
	hj5fU0fz8yagNrSkbGKYf7TTTh1SFUj8pZfK07J/WNE+pCESfrBJ+69voSu8PQoB4IoWws9XcIo
	Iw48kgs+LPrzg33vqo1/GYfhOnQAmmQnztWcJWyWkViM+AXHUokp5YmC
X-Google-Smtp-Source: AGHT+IHRecfblK8vR1wTkg7Bdl2kn7F86Ux81QsmlBimFCn4K8XEWHWHnLXKyVSFhm78XAFAqD/w/w==
X-Received: by 2002:a05:6a00:23d5:b0:730:8a0a:9f09 with SMTP id d2e1a72fcca58-73905a02721mr19367881b3a.18.1742801975063;
        Mon, 24 Mar 2025 00:39:35 -0700 (PDT)
Received: from thinkpad ([220.158.156.91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390618beafsm7199869b3a.161.2025.03.24.00.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 00:39:34 -0700 (PDT)
Date: Mon, 24 Mar 2025 13:09:29 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: MANISH PANDEY <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com, quic_cang@quicinc.com, 
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH V3 2/3] scsi: ufs-qcom: Add support for dumping MCQ
 registers
Message-ID: <awc2ql2x5amiahf7l47xqhgl7ugi4zpk5wz7qycgbqb52gh4yb@24za7q2rqqob>
References: <20250313051635.22073-1-quic_mapa@quicinc.com>
 <20250313051635.22073-3-quic_mapa@quicinc.com>
 <20250318064421.bvlv2xz7libxikk5@thinkpad>
 <12753be6-c69b-448d-a258-79221f4dbc7c@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12753be6-c69b-448d-a258-79221f4dbc7c@quicinc.com>

On Wed, Mar 19, 2025 at 11:51:07AM +0530, MANISH PANDEY wrote:
> 
> 
> On 3/18/2025 12:14 PM, Manivannan Sadhasivam wrote:
> > On Thu, Mar 13, 2025 at 10:46:34AM +0530, Manish Pandey wrote:
> > > This patch adds functionality to dump MCQ registers.
> > > This will help in diagnosing issues related to MCQ
> > > operations by providing detailed register dumps.
> > > 
> > 
> > Same comment as previous patch. Also, make use of 75 column width.
> > 
> will Update in next patch set.>> Signed-off-by: Manish Pandey
> <quic_mapa@quicinc.com>
> > > ---
> > > 
> > > Changes in v3:
> > > - Addressed Bart's review comments by adding explanations for the
> > >    in_task() and usleep_range() calls.
> > > Changes in v2:
> > > - Rebased patchsets.
> > > - Link to v1: https://lore.kernel.org/linux-arm-msm/20241025055054.23170-1-quic_mapa@quicinc.com/
> > > ---
> > >   drivers/ufs/host/ufs-qcom.c | 60 +++++++++++++++++++++++++++++++++++++
> > >   drivers/ufs/host/ufs-qcom.h |  2 ++
> > >   2 files changed, 62 insertions(+)
> > > 
> > > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > > index f5181773c0e5..fb9da04c0d35 100644
> > > --- a/drivers/ufs/host/ufs-qcom.c
> > > +++ b/drivers/ufs/host/ufs-qcom.c
> > > @@ -1566,6 +1566,54 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
> > >   	return 0;
> > >   }
> > > +static void ufs_qcom_dump_mcq_hci_regs(struct ufs_hba *hba)
> > > +{
> > > +	/* sleep intermittently to prevent CPU hog during data dumps. */
> > > +	/* RES_MCQ_1 */
> > > +	ufshcd_dump_regs(hba, 0x0, 256 * 4, "MCQ HCI 1da0000-1da03f0 ");
> > > +	usleep_range(1000, 1100);
> > 
> > If your motivation is just to not hog the CPU, use cond_resched().
> > 
> > - Mani
> > 
> The intention here is to introduce a specific delay between each dump.

What is the reason for that?

> Therefore, i would like to use usleep_range() instead of cond_resched().
> Please let me know if i am getting it wrong..
> 

Without knowing the reason, I cannot judge. Your comment said that you do not
want to hog the CPU during dump. But now you are saying that you wanted to have
a delay. Both are contradictions.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
