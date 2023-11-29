Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNC5meiT"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF110CB
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 11:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701284679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UGclDzu+lySOVYdka+aJpRVC+wxtGJIKs0Loae/8ctc=;
	b=YNC5meiTeIdkZtFj/XidKHtSBvMuEsh9FdUC1yj1dIr3EcTzdKljyR7nWKGJOIkCC9irYB
	FkQo8r6B0ms8HUVSqlCwIqa5nQ/V4x3CymVhYRQT/K914F0Tps7/bgZ/TQ++V28oAUh5Q2
	+3z/KmaOvDDxxyBPa2jSj9ikXH+fAzg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-ixaR3LpQPgqEjH_46Y0BGw-1; Wed, 29 Nov 2023 14:04:37 -0500
X-MC-Unique: ixaR3LpQPgqEjH_46Y0BGw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-67a696be34cso1044766d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 11:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701284677; x=1701889477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGclDzu+lySOVYdka+aJpRVC+wxtGJIKs0Loae/8ctc=;
        b=a8uqq54rjEQLtCK8pP8eyne8JnqopHpBD937GRdR8QK0+wSWhieKiwczqh/tjPMoIt
         /uOxZzTP1kGpM5n4YHncjR/IBzHnQoeh/Naa6vFzlwdSLYAVbRGSjJNENTrubBJIfcYu
         kAo7EEGsu3sqItg55KAij+4Db3Ks+kB/MR6vZ765MIx5VySxvAjMs68hIVkoLk006G7a
         DfZw4hgS0Jw3Vd9EciWY59sM9o4DFQBNYPqSDX7GgWAoQ0VHU9ilJEiTOp4egiJfdEfW
         ZJMRRYvg/B5yDgscp4avNP6TjKvr+O6/DhwybX8fddTWmTenaCB99z4D82+DPUHctQ/a
         or8A==
X-Gm-Message-State: AOJu0YyaHKlubVE2wOn0UHn/NPfHcapZU7f38ZRhvN+NkS9lBV2QwvIk
	2bUltxJZ1Buvip+61W12ruSGjohVsbROStAQ+74uOYnzJ24mu6sKeyUZJbG3i0Vb83zxL6hiux8
	7diFtl99MSF6PqS+dYA5Pow==
X-Received: by 2002:ad4:4147:0:b0:67a:2426:260f with SMTP id z7-20020ad44147000000b0067a2426260fmr16663864qvp.53.1701284677150;
        Wed, 29 Nov 2023 11:04:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFcPEphFasCF8dyMXcL4RBEb7gdvleqAlpNVolRU27wf08hfohgOjfKvnY/3TDGHXGuJIb9w==
X-Received: by 2002:ad4:4147:0:b0:67a:2426:260f with SMTP id z7-20020ad44147000000b0067a2426260fmr16663825qvp.53.1701284676783;
        Wed, 29 Nov 2023 11:04:36 -0800 (PST)
Received: from localhost (pool-71-184-142-128.bstnma.fios.verizon.net. [71.184.142.128])
        by smtp.gmail.com with ESMTPSA id gg12-20020a056214252c00b0067a4059068esm3354845qvb.124.2023.11.29.11.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 11:04:36 -0800 (PST)
Date: Wed, 29 Nov 2023 14:04:35 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Can Guo <quic_cang@quicinc.com>
Cc: bvanassche@acm.org, mani@kernel.org, adrian.hunter@intel.com, 
	cmd4@qualcomm.com, beanhuo@micron.com, avri.altman@wdc.com, 
	junwoo80.lee@samsung.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] scsi: ufs: ufs-qcom: Add support for UFS device
 version detection
Message-ID: <rgn6deseihby3wuwqll5qkephtzthcpxvoel6fpf6baxwjabjb@3fnuzl7bhako>
References: <1701246516-11626-1-git-send-email-quic_cang@quicinc.com>
 <1701246516-11626-11-git-send-email-quic_cang@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1701246516-11626-11-git-send-email-quic_cang@quicinc.com>

On Wed, Nov 29, 2023 at 12:28:35AM -0800, Can Guo wrote:
> From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
> 
> A spare register in UFS host controller is used to indicate the UFS device
> version. The spare register is populated by bootloader for now, but in
> future it will be populated by HW automatically during link startup with
> its best efforts in any boot stages prior to Linux.
> 
> During host driver init, read the spare register, if it is not populated
> with a UFS device version, go ahead with the dual init mechanism. If a UFS
> device version is in there, use the UFS device version together with host
> controller's HW version to decide the proper PHY gear which should be used
> to configure the UFS PHY without going through the second init.
> 
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 23 ++++++++++++++++++-----
>  drivers/ufs/host/ufs-qcom.h |  2 ++
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 9c0ebbc..e94dea2 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1068,15 +1068,28 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>  static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
>  {
>  	struct ufs_host_params *host_params = &host->host_params;
> +	u32 val, dev_major = 0;
>  
>  	host->phy_gear = host_params->hs_tx_gear;
>  
> -	/*
> -	 * Power up the PHY using the minimum supported gear (UFS_HS_G2).
> -	 * Switching to max gear will be performed during reinit if supported.
> -	 */
> -	if (host->hw_ver.major < 0x4)
> +	if (host->hw_ver.major < 0x4) {
> +		/*
> +		 * Power up the PHY using the minimum supported gear (UFS_HS_G2).
> +		 * Switching to max gear will be performed during reinit if supported.
> +		 */
>  		host->phy_gear = UFS_HS_G2;
> +	} else {
> +		val = ufshcd_readl(host->hba, REG_UFS_DEBUG_SPARE_CFG);
> +		dev_major = FIELD_GET(GENMASK(7, 4), val);
> +
> +		/* UFS device version populated, no need to do init twice */

This change documents the content of the register as "UFS device
version", both inline in the code and in the commit description. Earlier
in this series[1], Mani mentioned it was the gear info:
> > [...]populating a spare register in the bootloader with the max gear
> > info that the bootloader has already found[...]

Is it the gear number as in HS-G4? Or the version as in UFS controller
revision 3.1?

[1] https://lore.kernel.org/all/20231018124741.GA47321@thinkpad/

> +		if (dev_major != 0)
> +			host->hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
> +
> +		/* For UFS 3.1 and older, apply HS-G4 PHY gear to save power */
> +		if (dev_major < 0x4 && dev_major > 0)
> +			host->phy_gear = UFS_HS_G4;
> +	}
>  }
>  
>  static void ufs_qcom_set_host_params(struct ufs_hba *hba)
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 11419eb..d12fc5a 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -54,6 +54,8 @@ enum {
>  	UFS_AH8_CFG				= 0xFC,
>  
>  	REG_UFS_CFG3				= 0x271C,
> +
> +	REG_UFS_DEBUG_SPARE_CFG			= 0x284C,
>  };
>  
>  /* QCOM UFS host controller vendor specific debug registers */
> -- 
> 2.7.4
> 
> 

-- 
Eric Chanudet

