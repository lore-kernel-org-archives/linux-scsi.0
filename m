Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GB5BLNw2"
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D2410C4
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 21:26:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5c659db0ce2so437113a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 21:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701926791; x=1702531591; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XeEwOVdmoze4GgUERLZCvN1YeRMPDZTEgHk4TFeG0KI=;
        b=GB5BLNw2Hg3PxpzGnosbNxesjIavbkDGPg6Yi6K9IBB0+H3WuHRPwDjO5CZWYLElX0
         hB0Fc4qtYeDdQie4hahYtqt0R1p2f0MoaAOsHqGWRm9mA59yKDyRjoQWw51ncWJE5Eie
         kda8TR8Hg0DEDLFlYvA6W0eMM35vzlqEjMAuKA2LUR1eHiNWk9PqIz904F04stkwf1mu
         AiTidL2Tm9xe6RlZTPjOsnNhirY1oP8ZtXvJttZo8fVJLd8Pt6x5dftJ5AKuL3A1czhA
         UKVt9nSIPsXKy5R1xiaEfkXr0ORBi2WVtdBpVijQy998zbK6NqvVMyWzsbysZODstuNB
         k/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701926791; x=1702531591;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeEwOVdmoze4GgUERLZCvN1YeRMPDZTEgHk4TFeG0KI=;
        b=ctTLFA1cYpUSb5ErSUigNuZh81PgZ4FTDyuqG1wLTOP8Jp9vMbo8yOfEUOHIBw4e6j
         +Ez+Dqf7nkKYRL3M+pMyqt2qTPXP0A2VUPmOj+eqLKZGElyGJNM2tIKzKrzQl9e9PZNf
         Q1EFSjX/gQVof6vwtlUCD47yejrl9zew6LRp74w1x900qWeTJ6zHUOFnouSzjVZNFwWx
         GAVidnK3QeYuIUNZGKRqm9JNhiHi6LKMJlW3TnQPPwiFJrVoFmApXACnx0YPafToxWmu
         d6lCGKto3tHTy910ArTc8I0Y13hnpFpHBbLD0MlSuKZTQ/0CFBtz3tIAQlBVmdqu8Rji
         lr3Q==
X-Gm-Message-State: AOJu0YwC49Hj3JejdBoLWBp0NaQInU64e3bmulr7+MafaTOnt+FyfMxb
	a3L8XcAghKtU/RGi/VPgwfYB
X-Google-Smtp-Source: AGHT+IEtTZTW+sxUG+Y2qkOFbTaA4dzLqxda31KDpLSQuX7weMGaX0vHN/j3SKmhaPyP+fnGbTc3vw==
X-Received: by 2002:a05:6a21:149a:b0:18c:42ab:fced with SMTP id od26-20020a056a21149a00b0018c42abfcedmr1857397pzb.47.1701926791573;
        Wed, 06 Dec 2023 21:26:31 -0800 (PST)
Received: from thinkpad ([117.248.6.133])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902821400b001cfc50e5afesm385085pln.23.2023.12.06.21.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 21:26:31 -0800 (PST)
Date: Thu, 7 Dec 2023 10:56:26 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Andrew Halaney <ahalaney@redhat.com>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org,
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com
Subject: Re: [PATCH 07/13] scsi: ufs: qcom: Fail ufs_qcom_power_up_sequence()
 when core_reset fails
Message-ID: <20231207052626.GB2932@thinkpad>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-8-manivannan.sadhasivam@linaro.org>
 <iecwyzsamuwhatodicsfptf3dgl5nglrdqyennmhagpjz7yrtr@r72gejcvhi6w>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <iecwyzsamuwhatodicsfptf3dgl5nglrdqyennmhagpjz7yrtr@r72gejcvhi6w>

On Wed, Dec 06, 2023 at 12:41:28PM -0600, Andrew Halaney wrote:
> On Fri, Dec 01, 2023 at 08:44:11PM +0530, Manivannan Sadhasivam wrote:
> > Even though core_reset is optional, a failure during assert/deassert should
> > be considered fatal, if core_reset is available. So fail
> > ufs_qcom_power_up_sequence() if an error happens during reset and also get
> > rid of the redundant warning as the ufs_qcom_host_reset() function itself
> > prints error messages.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 604273a22afd..4948dd732aae 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -359,8 +359,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
> >  	/* Reset UFS Host Controller and PHY */
> >  	ret = ufs_qcom_host_reset(hba);
> 
> I noticed that ufs_qcom_host_reset() doesn't return an error if
> reset_control_deassert() fails. Can you address this in the next spin of
> the series (I don't think its in the following patches that I glanced
> through).
> 

Right. I'll fix it in next version.

- Mani

> Thanks,
> Andrew
> 
> >  	if (ret)
> > -		dev_warn(hba->dev, "%s: host reset returned %d\n",
> > -				  __func__, ret);
> > +		return ret;
> >  
> >  	/* phy initialization - calibrate the phy */
> >  	ret = phy_init(phy);
> > -- 
> > 2.25.1
> > 
> > 
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
