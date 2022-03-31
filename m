Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC04C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 23:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiCaXry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiCaXrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 19:47:46 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F021EDA06
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:45:57 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id e4so1197427oif.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7UtU7gZc+fLOj9uM401yi+smCH3Pg9Y1c/DrcLVN+ds=;
        b=ByCo5dKb27Zzlnhv+lGZyK2HvY9nQCMMrS+RDYgqioFB2y0y7CLqNyOiVurxHPqn6N
         5rfRLPs5mQszFahM73CqNkwo9abviCQWeNaCM89BjCRnid3jukC9ASExE8qRaSNesIyi
         fUo04iAoDBZGILGGhC/vf/1XMP4MK0p8n6I93SyzyG9MLI6Y2FWtEXQ2y5NwpKKJh6wh
         xJt10GPBzwFtCylfn2E8rxQEAYM7OCql9qGtNQ1+ClCdQt8XxsTwt04UsG+BALUKcCS4
         duGuYpOO7k9mmEtLKyaI1Jm6famRUsREOndPcFItPp00NlaAnw83Vt1hbFKko+1smOFn
         nfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UtU7gZc+fLOj9uM401yi+smCH3Pg9Y1c/DrcLVN+ds=;
        b=UkNrcwYpjBLrvkYsDha08cC3+tFImgiBvczJ/6OmBU53iSUprslu6fFt3il/eib5pT
         bQbnZPE93/z0dyYh45qggLJWNOFNkpzQpcjnmVQNzsal9CK47r0hR4nRTz0fNal2vpT4
         +mnA/ejRgJwigu8DKRRm4c2qVxmupO2C96kxdIDlhgfz8k917+PY6Onb4r1fcZ4R0vL9
         YruLQr0pCDuHJWf8G4ncRntL4BbMmzwjcAOvXikhvuDMKu+YjQKBX6yZ+32Ff7m8QRiQ
         xwfXFJ/A9mictPS20mvnKmtjC92V3Rx2/lr/6my1ulcQx4Qs3+KfXoDzFeqJFrvLLZvg
         sTEA==
X-Gm-Message-State: AOAM530PqDfJ6qxadeVq+gss6EuKynafFUJ4ZrCwwOd+/uIcBP4RRnKy
        hz2MB0MUw51U8BiBlkisOLRGcQ==
X-Google-Smtp-Source: ABdhPJyqjniDrNMdWqVzX3w6j2KXh+v1jnBn3qvkk88MtkpVGe7R/aZgVyutnwizMUfTAzfuHDgT7w==
X-Received: by 2002:a05:6808:a1b:b0:2ec:aec1:b010 with SMTP id n27-20020a0568080a1b00b002ecaec1b010mr3718571oij.247.1648770356833;
        Thu, 31 Mar 2022 16:45:56 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id ga14-20020a056870ee0e00b000ddcf36aa56sm345335oab.48.2022.03.31.16.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 16:45:56 -0700 (PDT)
Date:   Thu, 31 Mar 2022 16:48:25 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 14/29] scsi: ufs: Make the config_scaling_param calls
 type safe
Message-ID: <YkY9yRNJkuQtoHo1@ripper>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-15-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331223424.1054715-15-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 31 Mar 15:34 PDT 2022, Bart Van Assche wrote:

> Pass the actual type to config_scaling_param callback as the third
> argment instead of a void pointer. Remove a superfluous NULL pointer
> check from ufs_qcom_config_scaling_param().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 14 ++++----------
>  drivers/scsi/ufs/ufshcd.h   | 10 +++++-----
>  2 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 808b677f6083..f24210652fe9 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1463,23 +1463,17 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
>  
>  #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
>  static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
> -					  struct devfreq_dev_profile *p,
> -					  void *data)
> +		struct devfreq_dev_profile *p,
> +		struct devfreq_simple_ondemand_data *d)

This doesn't look to be properly indended to match the '('?
What does ./scripts/checkpatch.pl --strict say about the patch?


Other than that, the change looks good, so feel free to add my r-b once
you've double checked the indentation.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

>  {
> -	static struct devfreq_simple_ondemand_data *d;
> -
> -	if (!data)
> -		return;
> -
> -	d = (struct devfreq_simple_ondemand_data *)data;
>  	p->polling_ms = 60;
>  	d->upthreshold = 70;
>  	d->downdifferential = 5;
>  }
>  #else
>  static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
> -					  struct devfreq_dev_profile *p,
> -					  void *data)
> +		struct devfreq_dev_profile *p,
> +		struct devfreq_simple_ondemand_data *data)
>  {
>  }
>  #endif
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 107d19e98d52..bb2624aabda2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -348,8 +348,8 @@ struct ufs_hba_variant_ops {
>  	int	(*phy_initialization)(struct ufs_hba *);
>  	int	(*device_reset)(struct ufs_hba *hba);
>  	void	(*config_scaling_param)(struct ufs_hba *hba,
> -					struct devfreq_dev_profile *profile,
> -					void *data);
> +				struct devfreq_dev_profile *profile,
> +				struct devfreq_simple_ondemand_data *data);
>  	int	(*program_key)(struct ufs_hba *hba,
>  			       const union ufs_crypto_cfg_entry *cfg, int slot);
>  	void	(*event_notify)(struct ufs_hba *hba,
> @@ -1360,11 +1360,11 @@ static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
>  }
>  
>  static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
> -						    struct devfreq_dev_profile
> -						    *profile, void *data)
> +		struct devfreq_dev_profile *p,
> +		struct devfreq_simple_ondemand_data *data)
>  {
>  	if (hba->vops && hba->vops->config_scaling_param)
> -		hba->vops->config_scaling_param(hba, profile, data);
> +		hba->vops->config_scaling_param(hba, p, data);
>  }
>  
>  extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
