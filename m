Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DkkebFhd"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C19D1
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 12:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701290891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgK9SVKODvB48bATs/GY8yc91KWuPlynI97GGsWOuZo=;
	b=DkkebFhdHgzw1IhtizdPzuJjw4dBzpG/kcmDiEAdi4WYYTg/R7DZYxt6uqMlD8QHvOTdZR
	CHR0/jioLWiHZDtUhj6Y1Yxmx7spi4GSxwuvBV3x6vcRYyL3oBE683erjnZPQTBf6W/40F
	JKK7bQ1yzrbRPZrSA64fWFfJR0YfQk4=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-pcIoJZDSPxOezyMWHB7Feg-1; Wed, 29 Nov 2023 15:48:10 -0500
X-MC-Unique: pcIoJZDSPxOezyMWHB7Feg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5d1b431fa7bso3831177b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 12:48:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701290889; x=1701895689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgK9SVKODvB48bATs/GY8yc91KWuPlynI97GGsWOuZo=;
        b=DfWb86JsiY2b0CB/BWzWuER7+pT7WiRa/beS5soC6KQXRvtAAk3p8PCXZ7N/QzLvhN
         DyCbewdzMyoVGSG2ER7gFSRodaaARiUjbnES2pSKtvr5XzhVk4HOt32eT6tumleAp0J6
         G70N5O7PlL5K/hmrhM+XON6JNKh1ptHFBTSS32Cp6x98hob4+RC2vKG1eIRyc9uaJlBO
         ucb8bpAU0XrHb2WPwGPqHH9kdx+0eZbXQNQ7zPO5XqvfZOhTPfzpNRzIrb9VihS2322M
         cN9yCrkvLZJd7VTQh62Ox6buq8YK2MLwYrAtFR4Ix0XUCi1OgFPBNQTluVvDrGadDMe3
         ibKA==
X-Gm-Message-State: AOJu0YwLf6hAxhqJJXnrqW33HzE/Q6CsPC2pUIUeGlbD58xm48hJ6UYy
	/VXQUkRvPocBvnQ7rPFp13N9OR9hFG8VVq7XSM0FtuxC5X0PtEkXeI/jdyduWrEfxnBHPEUhpDi
	hwri9LHSfTT5fr6fxjQYtlA==
X-Received: by 2002:a05:690c:3145:b0:5d0:bd82:a87d with SMTP id fc5-20020a05690c314500b005d0bd82a87dmr9985293ywb.9.1701290889554;
        Wed, 29 Nov 2023 12:48:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnJ3Gqey62Zd2lyl5c2NqI9b6c5SGjVB3aYgy6NvYWJzN7gTHxO7Ubp0FYkzvfEQ+0pZ4bFg==
X-Received: by 2002:a05:690c:3145:b0:5d0:bd82:a87d with SMTP id fc5-20020a05690c314500b005d0bd82a87dmr9985278ywb.9.1701290889271;
        Wed, 29 Nov 2023 12:48:09 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id kc9-20020a056214410900b0067a15610d3csm5588607qvb.72.2023.11.29.12.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:48:08 -0800 (PST)
Date: Wed, 29 Nov 2023 14:48:06 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Can Guo <quic_cang@quicinc.com>
Cc: bvanassche@acm.org, mani@kernel.org, adrian.hunter@intel.com, 
	cmd4@qualcomm.com, beanhuo@micron.com, avri.altman@wdc.com, 
	junwoo80.lee@samsung.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 02/10] scsi: ufs: ufs-qcom: No need to set hs_rate
 after ufshcd_init_host_param()
Message-ID: <y26a4ciloi6bcmil2hfmsezjeaomjm56ukzdlbm5fxlwpj3rr5@3rs7b5mkehpx>
References: <1701246516-11626-1-git-send-email-quic_cang@quicinc.com>
 <1701246516-11626-3-git-send-email-quic_cang@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1701246516-11626-3-git-send-email-quic_cang@quicinc.com>

On Wed, Nov 29, 2023 at 12:28:27AM -0800, Can Guo wrote:
> In ufs_qcom_pwr_change_notify(), host_params.hs_rate has been set to
> PA_HS_MODE_B by ufshcd_init_host_param(), hence remove the duplicated line
> of work. Meanwhile, removed the macro UFS_QCOM_LIMIT_HS_RATE as it is only
> used here.
> 
> Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 1 -
>  drivers/ufs/host/ufs-qcom.h | 2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 197c5a5..c21ff2c 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -909,7 +909,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  	switch (status) {
>  	case PRE_CHANGE:
>  		ufshcd_init_host_params(&host_params);
> -		host_params.hs_rate = UFS_QCOM_LIMIT_HS_RATE;
>  
>  		/* This driver only supports symmetic gear setting i.e., hs_tx_gear == hs_rx_gear */
>  		host_params.hs_tx_gear = host_params.hs_rx_gear = ufs_qcom_get_hs_gear(hba);
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 9950a00..82cd143 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -27,8 +27,6 @@
>  #define SLOW 1
>  #define FAST 2
>  
> -#define UFS_QCOM_LIMIT_HS_RATE		PA_HS_MODE_B
> -
>  /* QCOM UFS host controller vendor specific registers */
>  enum {
>  	REG_UFS_SYS1CLK_1US                 = 0xC0,
> -- 
> 2.7.4
> 
> 

