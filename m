Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704A5FDA3
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706023109; cv=none; b=qvfltc0/F488+3t54+Dpqqyve0tdHi79SMMAlf0cagxoTg68AIGVY7ILmv6VP+9sts8AlwsFDrGpJr6YmWyXxXKB/sDNdALpCNmUuvbqos+hZrhTjPhghF1a1GezOZQ4bC1U9Y2Lmz+2CNLlIVVLeLD8qsnxhSHJKucCuX/N3XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706023109; c=relaxed/simple;
	bh=crUOVrMbeEO4wnicc5iui9hOeN4LYMI9Jn8rCfHnCRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aS3xocRPWBTMuhmzZMUkdyqfctCS3YDjbwIHTjTMejiCKjslbvNNgTr3rLU8SGCuR2BemqPZKP0AvO5a9ApgSBvs+AH6nG836+Ekv+XaFtuAYGNjkRZ9OOtFJ5M0C2ve2Ass8YUX0eBZpBCWGVAJIU+QtwBm+ZEEz9cpC3cYUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G/Zmf/pC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/Zmf/pC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706023106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cg9rVYslPOYKyRxMw9IkZlsZENR/nLG/k/wm9SQRp04=;
	b=G/Zmf/pCWB+CwIe9mWfiSblRd0QV/8ei1Edoe7lg7EEMI9q7/x0ppsbuBwFW1Mz9yYbmq/
	xUNc0EaP6HWH1YnG5XKWWHj3Y5wH/keGSBtM9dHiaTInzw35Q8W1B17IENeLGvRo3RARI8
	78o4qxhnL8/3Dmml0Be2wG8FpLOCl+k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-3_N7deOPN6iFfsLiioXwng-1; Tue, 23 Jan 2024 10:18:24 -0500
X-MC-Unique: 3_N7deOPN6iFfsLiioXwng-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-429cc1afb92so79419511cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 07:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706023104; x=1706627904;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg9rVYslPOYKyRxMw9IkZlsZENR/nLG/k/wm9SQRp04=;
        b=syboY9/dkQACBaAgOTnCaj3VeLKCViKLAOPV5O58fx+pCbaoYxgRetmKe5H7y1szlG
         1ttKhIbPU+HN2wBsqEqxEsIjhhXOvnH9u5eZCF6BpmH7vS7o73GTEVUwjP4b24gROcEA
         cfCejd4OxnxrqMYJpdAb6KqNZIj1lsoAOEShLYZBMErinsRmxi8mofFLHGgmWOXKbi/i
         NttUvnlfHqAUyTIBu5MtaDg01pPJRVjgVuF0Cp12Vom4ismAkGONpS/QQDmbBPmT2H7P
         dcrw20K7UPamlNDkvIkfFq9SAqKRAmX7TnXW5F1Oe8ggJpnCbHwE3zMpHOrGAsZNXmfn
         IM/w==
X-Gm-Message-State: AOJu0YyM7715UJQldGWpJnm5KdZ7HFChu3h+DK76gG3FGc7Taohg2IGf
	WGMXNO6zCnqleb9fgH3kFknjZ/ayiSLVv8s9cF5AXH9NVj9djqlyNEgj/nPqPxggyAB+CkFETlZ
	IVLLiOYqRqYfd+wW4bzVMBgjTYVDm++5IjQxmIRTdGQTBnuf4unNJujNjlpk=
X-Received: by 2002:a05:622a:34b:b0:42a:35bf:40f2 with SMTP id r11-20020a05622a034b00b0042a35bf40f2mr999987qtw.58.1706023104365;
        Tue, 23 Jan 2024 07:18:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7iVj9B700sdyhUCZJUNpfTHatf50PZK1/4/aA5N7R1oR+82VHoBiI7HHMIcCXwDPVqd7kSg==
X-Received: by 2002:a05:622a:34b:b0:42a:35bf:40f2 with SMTP id r11-20020a05622a034b00b0042a35bf40f2mr999977qtw.58.1706023104039;
        Tue, 23 Jan 2024 07:18:24 -0800 (PST)
Received: from localhost (pool-71-184-142-128.bstnma.fios.verizon.net. [71.184.142.128])
        by smtp.gmail.com with ESMTPSA id s13-20020ac8758d000000b00423e9316931sm3522132qtq.83.2024.01.23.07.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 07:18:23 -0800 (PST)
Date: Tue, 23 Jan 2024 10:18:22 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Andrew Halaney <ahalaney@redhat.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: Re: Re: [PATCH] scsi: ufs: qcom: avoid re-init quirk when
 gears match
Message-ID: <hnig5l4y3yc3h4khjgpkdbooop2ctah4pzplumjdzxzdxs3rqu@vsrubpdl26bp>
References: <20240119185537.3091366-11-echanude@redhat.com>
 <3xnedre2d32rkad6n2ln4rrah7sgg6epxnzsdm54uab3zrutnz@fww7wb5mvykj>
 <otgj6524k6wiy27depeo7ckopmrr2v3xdnaoph4c5djjohnpmg@f7hyetygcyyr>
 <graeyylgohsukni35djpbxibnz5ya7laqvsydharkzcktv2iwz@knbu5uq5fa4x>
 <20240123143615.GD19029@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240123143615.GD19029@thinkpad>

On Tue, Jan 23, 2024 at 08:06:15PM +0530, Manivannan Sadhasivam wrote:
> On Fri, Jan 19, 2024 at 04:33:10PM -0500, Eric Chanudet wrote:
> > On Fri, Jan 19, 2024 at 02:33:32PM -0600, Andrew Halaney wrote:
> > > On Fri, Jan 19, 2024 at 02:07:15PM -0600, Andrew Halaney wrote:
> > > > On Fri, Jan 19, 2024 at 01:55:47PM -0500, Eric Chanudet wrote:
> > > > > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > > > > index 39eef470f8fa..f9f161340e78 100644
> > > > > --- a/drivers/ufs/host/ufs-qcom.c
> > > > > +++ b/drivers/ufs/host/ufs-qcom.c
> > > > > @@ -738,8 +738,12 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
> > > > >  		 * the second init can program the optimal PHY settings. This allows one to start
> > > > >  		 * the first init with either the minimum or the maximum support gear.
> > > > >  		 */
> > > > > -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> > > > > +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> > > > > +			if (host->hw_ver.major >= 0x4 &&
> > > > 
> > > > Is this check really necessary?
> > 
> > I *think* so.
> > 
> > For example, if hw_ver < 4, ufs_qcom_set_phy_gear() has a comment saying
> > "power up the PHY using minimum supported gear (UFS_HS_G2). Switching to
> > max gear will be performed during reinit if supported."
> > 
> > > > 
> > > > The initial phy_gear state is something like this (my phrasing of
> > > > ufs_qcom_set_phy_gear()):
> > > > 
> > > >     if hw_ver < 4:
> > > >         # Comments about powering up with minimum gear (with no
> > > >         # reasoning in the comment afaict), and mentions switching
> > > >         # to higher gear in reinit quirk. This is opposite of the later
> > > >         # versions which start at the max and scale down
> > > >         phy_gear = UFS_HS_G2
> > 
> > IIUC, the device would not be able to negotiate a gear higher than the
> > minimum set for the phy_gear on initialization.
> > 
> > ufshcd_init_host_params() and ufs_qcom_get_hs_gear() both set the
> > controller <v4 host_params to G3. So if the device is HS capable, the
> > re-init would set G3, instead of the G2 selected by
> > ufs_qcom_set_phy_gear().
> > 
> 
> REINIT quirk is applicable for controllers starting from v4 only, because legacy
> controllers don't need separate PHY init sequences. So you can get rid of that
> check.

My bad, I overlooked the check in ufs_qcom_advertise_quirks().
Thank you, I'll send a v2 soon.

> - Mani
> 
> -- 
> மணிவண்ணன் சதாசிவம்
> 

-- 
Eric Chanudet

