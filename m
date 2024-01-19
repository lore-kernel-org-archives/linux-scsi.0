Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F91C58103
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705699997; cv=none; b=ntjAWHkos36PAHb9WQV/H/8R8QJEU4xbe9HBuurxLGE90OMveNYV+AWV3eDKy8/uBWoKX1Rh4XCqWVp2PnEq7dYSU/gmsj6/9aJCHhWaaZE8+mCV7GfzeisTz8M+J0EvyxrRYCPW7lSwKkWDugNxCNWjaNO6omjA8dtJ2ccRYw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705699997; c=relaxed/simple;
	bh=EkTj7yDGwdkzAs8tBNlRMDUvXzIDCIPdlE7L2nKM844=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mos8bbkVJPi0Ny//PMseETIihwrIV1shlPuqv+luDO8Gi1QSSjjQ67YHPGTcNPtqBoeNnveOflNfNE59rzhNinwp9JxUwinFnglcTULsJIJkvrfUI8Qq0gol+cbSVyJeq1Q8XaxlqZB2hLr0HSDG+iPgFCpoHK1ZTVmbPBC4CVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbSo464k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbSo464k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705699994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lzrWPZR5+3QYuqMx3/O+fwKFrZi0Xwysmh/7OAXDcYM=;
	b=fbSo464k7XvSr96aYW4EOzeJ7XIXlJ4i5DcpvJhnVjvHtD+jxNUXuB3zbABa96Vm4K08mE
	V79LK4qRjvkT2Ose2rTXDUc0mjqXbNLazAkSsSrxI2nupCpXIr0ptFIl2L8YoyfdQsvQHy
	L1fIv/BmblvR01IKGPLVFqHbzOeMN68=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-WuH8mkLDNeWWs91x8lHLQg-1; Fri, 19 Jan 2024 16:33:12 -0500
X-MC-Unique: WuH8mkLDNeWWs91x8lHLQg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-67ef8bbfe89so22389986d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 13:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705699992; x=1706304792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzrWPZR5+3QYuqMx3/O+fwKFrZi0Xwysmh/7OAXDcYM=;
        b=GioVTqiKOAr9fu5Dm5BuXbClZn7qz2Wbv2nIQzBd5996mqSM5tT4d/6EJWQ8X0kcag
         WNPqhMnTa1L9FFb9CIxC0BWFahma7a6YiXHZIV7NWlTK2c+nsjp+jlSU9Qlrgi3rNxjW
         32Mq8Z3zjux/ngXXZ4rkl4o7KO4L2DQ3h1mIc3IPui0xDaxyG+jUyrHUkhw3CuNSRUph
         ivgJ81bgxfNlvoXtep6VYb90+GfRyYqnUEjTChCRSP1wsIgAWSwCHf1joxUD06yeINJf
         rj3fpxkyG5kbtnQomJ5lVWwvHffUixxVDP8niOj0qNsl1iSGHE5Eb/I8ZFCJlwA6VaZd
         rdyg==
X-Gm-Message-State: AOJu0Yyj6LKIZAmejE2LEaCftrTRdiVys1Di3dAeI20kOncsCBmhKOv0
	9rRDiG6hwaCw9v7rG+W1VJf0EuufXd8rWIF/SzN+LT4VWIcNb4XY4DejuSFXN4qcduvWlEvdwCh
	rYnvF2eUbc9mfGVHlP9xZr8Lbuv2qZlEa+anrZx1mPtbhmXEc9TxLPljt9SM=
X-Received: by 2002:a05:6214:2686:b0:680:c880:6646 with SMTP id gm6-20020a056214268600b00680c8806646mr668652qvb.22.1705699992325;
        Fri, 19 Jan 2024 13:33:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzzipQRf/AqpwwysE2kv7ZI6fkFW9M4nW61XT5BD6zZ/s+tUut70peKPfzGaEivdj8NjgXpQ==
X-Received: by 2002:a05:6214:2686:b0:680:c880:6646 with SMTP id gm6-20020a056214268600b00680c8806646mr668638qvb.22.1705699992064;
        Fri, 19 Jan 2024 13:33:12 -0800 (PST)
Received: from localhost (pool-71-184-142-128.bstnma.fios.verizon.net. [71.184.142.128])
        by smtp.gmail.com with ESMTPSA id di8-20020ad458e8000000b006818a1e269csm39021qvb.102.2024.01.19.13.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 13:33:11 -0800 (PST)
Date: Fri, 19 Jan 2024 16:33:10 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Andrew Halaney <ahalaney@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: Re: [PATCH] scsi: ufs: qcom: avoid re-init quirk when gears
 match
Message-ID: <graeyylgohsukni35djpbxibnz5ya7laqvsydharkzcktv2iwz@knbu5uq5fa4x>
References: <20240119185537.3091366-11-echanude@redhat.com>
 <3xnedre2d32rkad6n2ln4rrah7sgg6epxnzsdm54uab3zrutnz@fww7wb5mvykj>
 <otgj6524k6wiy27depeo7ckopmrr2v3xdnaoph4c5djjohnpmg@f7hyetygcyyr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <otgj6524k6wiy27depeo7ckopmrr2v3xdnaoph4c5djjohnpmg@f7hyetygcyyr>

On Fri, Jan 19, 2024 at 02:33:32PM -0600, Andrew Halaney wrote:
> On Fri, Jan 19, 2024 at 02:07:15PM -0600, Andrew Halaney wrote:
> > On Fri, Jan 19, 2024 at 01:55:47PM -0500, Eric Chanudet wrote:
> > > On sa8775p-ride, probing the hba will go through the
> > > UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info
> > > are same during the second init.
> > > 
> > > If the host is at least v4, ufs_qcom_get_hs_gear() picked the highest
> > > supported gear when setting the host_params. After the negotiation, if
> > > the host and device are on the same gear, it is the highest gear
> > > supported between the two. Skip the re-init to save some time.
> > > 
> > > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > > ---
> > > 
> > > "trace_event=ufs:ufshcd_init" reports the time spent where the re-init
> > > quirk is performed. On sa8775p-ride:
> > > Baseline:
> > >   0.355879: ufshcd_init: 1d84000.ufs: took 103377 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> > > With this patch:
> > >   0.297676: ufshcd_init: 1d84000.ufs: took 43553 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> > > 
> > >  drivers/ufs/host/ufs-qcom.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > > index 39eef470f8fa..f9f161340e78 100644
> > > --- a/drivers/ufs/host/ufs-qcom.c
> > > +++ b/drivers/ufs/host/ufs-qcom.c
> > > @@ -738,8 +738,12 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
> > >  		 * the second init can program the optimal PHY settings. This allows one to start
> > >  		 * the first init with either the minimum or the maximum support gear.
> > >  		 */
> > > -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> > > +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> > > +			if (host->hw_ver.major >= 0x4 &&
> > 
> > Is this check really necessary?

I *think* so.

For example, if hw_ver < 4, ufs_qcom_set_phy_gear() has a comment saying
"power up the PHY using minimum supported gear (UFS_HS_G2). Switching to
max gear will be performed during reinit if supported."

> > 
> > The initial phy_gear state is something like this (my phrasing of
> > ufs_qcom_set_phy_gear()):
> > 
> >     if hw_ver < 4:
> >         # Comments about powering up with minimum gear (with no
> >         # reasoning in the comment afaict), and mentions switching
> >         # to higher gear in reinit quirk. This is opposite of the later
> >         # versions which start at the max and scale down
> >         phy_gear = UFS_HS_G2

IIUC, the device would not be able to negotiate a gear higher than the
minimum set for the phy_gear on initialization.

ufshcd_init_host_params() and ufs_qcom_get_hs_gear() both set the
controller <v4 host_params to G3. So if the device is HS capable, the
re-init would set G3, instead of the G2 selected by
ufs_qcom_set_phy_gear().

Assuming I'm not loosing track somewhere, the sequence of calls would go
something like this:

ufshcd_init
 ufshcd_hba_init
  ufshcd_variant_hba_init
   ufshcd_vops_init
    ufs_qcom_init
     ufs_qcom_set_host_params /* if hw_ver < 4: phy_gear = G2 */
 ufshcd_hba_enable
  ufshcd_hba_execute_hce
   ufshcd_vops_hce_enable_notify(PRE_CHANGE)
    ufs_qcom_hce_enable_notify /* vops.hce_enable_notify */
     ufs_qcom_power_up_sequence
      phy_set_mode_ext(phy, mode, host->phy_gear);
 async_schedule(ufshcd_async_scan, hba)
 ...
 ufshcd_async_scan
  ufshcd_device_init
  ufshcd_probe_hba /* where the re-init quirk happens */
   ufshcd_device_init
    ufshcd_vops_pwr_change_notify(PRE_CHANGE)
  
So that would limit the device to G2? In this circumstances, the re-init
would instead re-initialize to G3.

> I guess what I'm saying is shouldn't the check be something like:
> 
>     if (dev_req_params->gear_tx == host->phy_gear) {
>         // Skip reinit since we started up in the agreed upon gear
>         hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>     }

-- 
Eric Chanudet

