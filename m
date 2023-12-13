Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHHFgJxa"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E0C9
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 09:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702487844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=frOrOI5WAQiyU9228XLtrpRqeqKgVIZTf5EBEg5217c=;
	b=SHHFgJxaxKhAOP0mtcFF0J44rChU7BymT6io2wPm9fDrf/XG6k9YvzWBhMr8q9Vbh1d7dQ
	Uh6Zpeo3Xij2XuY47X9uthW17NVBSh1BxhQ81Wnbdvs7tOS41hZJwCUxGcW9ajpkNTM9Xd
	3yhaa9aRVY1dQAiHrObQJaxH9msEfaU=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-GnoPMSr0PfOrjUT1zK3QNA-1; Wed, 13 Dec 2023 12:17:22 -0500
X-MC-Unique: GnoPMSr0PfOrjUT1zK3QNA-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b8b07fbc1dso11487547b6e.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 09:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702487842; x=1703092642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frOrOI5WAQiyU9228XLtrpRqeqKgVIZTf5EBEg5217c=;
        b=tWMQDvMLBEy2WaotIZMYigHWj7dyGHRWIDbgnpJlWUE+QWjgrpHcWlr1kSxS0MSurs
         XnC7M1RexP1qOy95SczGfOE/4SBOBO+JIMf3PqAU3CffEFbfaI25/InWYq++tgJ0ivMk
         BRQNNAXKhFEm3kP2rlJljl8ExUHr/TFRhhdzcaYKHbpV8iCEYIuYkRB+0BAlbQ/tb4uT
         cIk0HWmjG0oYgz9FOvMloqWursDEbxn6fIfenzK3QOCbXPkTyn4yKhHAdEvl0PxuEQCq
         aj4B1dj6GqDUTAwL0ob4+8EqsrtAqLhd10L7ocrulhUlP3cbE1B0Vr9E20s6xqCz95oL
         mfYg==
X-Gm-Message-State: AOJu0YxM2lvEAUq/7ovrSSicMG9gqqqOrqGU2tdpgge9FMviDyRDWTh6
	kpkLYGN3ktAERvbx8aWUUiqw9JVAYgrbE6o9+sXHBSQbpE3g6Oej8yBf5xNp1IQe2R1z1ovh3Gg
	+9NvhMwjObgDNSbXpH5fsig==
X-Received: by 2002:a05:6359:4598:b0:170:6ba9:9dac with SMTP id no24-20020a056359459800b001706ba99dacmr12053182rwb.61.1702487841635;
        Wed, 13 Dec 2023 09:17:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFADA7jsklnaZq66yXeVA6CYLawBi0nKvUeaKPssY3KL03nLX9krv923Z/0+HWBTZbiVQpBtg==
X-Received: by 2002:a05:6359:4598:b0:170:6ba9:9dac with SMTP id no24-20020a056359459800b001706ba99dacmr12053164rwb.61.1702487841313;
        Wed, 13 Dec 2023 09:17:21 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id dy7-20020ad44e87000000b0067aa05449cesm5217475qvb.3.2023.12.13.09.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 09:17:20 -0800 (PST)
Date: Wed, 13 Dec 2023 11:17:18 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: mani@kernel.org, agross@kernel.org, andersson@kernel.org, 
	konrad.dybcio@linaro.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, grant.jung@samsung.com, jt77.jang@samsung.com, 
	dh0421.hwang@samsung.com, sh043.lee@samsung.com
Subject: Re: [PATCH] scsi: ufs: qcom: Re-fix for error handling
Message-ID: <m5wjp3yb3qpheyzgipekeagycboifqdpw54nquzqsftufap3yc@kxjwi4y63adj>
References: <CGME20231213022525epcas1p219483a7572a12394c5852cd53a367da4@epcas1p2.samsung.com>
 <20231213022500.9011-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213022500.9011-1-cw9316.lee@samsung.com>

On Wed, Dec 13, 2023 at 11:25:00AM +0900, Chanwoo Lee wrote:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> I modified the code to handle errors.
> 
> The error handling code has been changed from the patch below.
> -'commit 031312dbc695 ("scsi: ufs: ufs-qcom: Remove unnecessary goto statements")'
> 
> What I have confirmed are three cases.
> 1) ufs_qcom_host_reset -> 'reset_control_deassert' error -> return 0;
> 2) ufs_qcom_clk_scale_notify -> 'ufs_qcom_clk_scale_up_/down_pre_change' error -> return 0;
> 3) ufs_qcom_init_lane_clks -> 'ufs_qcom_host_clk_get(tx_lane1_sync_clk)' error -> return 0;
> 
> It is unknown whether the above commit was intended to change error handling.
> However, if it is not an intended fix, a patch may be needed.

I think you're right, these were not intentionally changed. There's a
patch series in flight right now that cleans up some of this driver and
inadvertently tackles some of the problems below.

> 
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 96cb8b5b4e66..8a93d93ab08f 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -313,6 +313,8 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  
>  		err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
>  			&host->tx_l1_sync_clk, true);
> +		if (err)
> +			return err;

This patch cleans this up: https://lore.kernel.org/linux-arm-msm/20231208065902.11006-2-manivannan.sadhasivam@linaro.org/

>  	}
>  
>  	return 0;
> @@ -404,9 +406,11 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
>  	usleep_range(200, 210);
>  
>  	ret = reset_control_deassert(host->core_reset);
> -	if (ret)
> +	if (ret) {
>  		dev_err(hba->dev, "%s: core_reset deassert failed, err = %d\n",
>  				 __func__, ret);
> +		return ret;
> +	}

This patch cleans this up: https://lore.kernel.org/linux-arm-msm/20231208065902.11006-8-manivannan.sadhasivam@linaro.org/#t

>  
>  	usleep_range(1000, 1100);
>  
> @@ -415,7 +419,7 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
>  		hba->is_irq_enabled = true;
>  	}
>  
> -	return 0;
> +	return ret;

If I'm reading right returning ret is pointless here with your change
above (it already returns ret, and it is no longer updated right so the
only possible value here is 0?

>  }
>  
>  static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba)
> @@ -1535,7 +1539,7 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
>  		ufshcd_uic_hibern8_exit(hba);
>  	}
>  
> -	return 0;
> +	return err;
>  }

I think you could move this one up into the PRE_CHANGE block and leave
return 0 here? I believe this is the only case not yet covered by the
patch series I linked. Good catch!

>  
>  static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
> -- 
> 2.29.0
> 
> 

