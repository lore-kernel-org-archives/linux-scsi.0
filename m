Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BA5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 23:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiCaXtm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiCaXtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 19:49:41 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAC5200967
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:47:53 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id z9-20020a05683020c900b005b22bf41872so972056otq.13
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7YD/h4aSRniUjU0YCShmmJvbKGJasf07UQX1lEPDdUQ=;
        b=xM+R705f0svsaaUVaK4lHGJXJVJ9VspHLZVClB9KMdeFcp6xLTZmAvN4w4lHDKgmA9
         eXVjHzgZQ1NxtO2RpLdXUHWMEaEEw0bstXjgOZYZfmuxbUM/FDNKHjoy+Y55jOm6avs2
         2zkxtUA14mUYEAUqalG03WQryC13TXA7lQma779zLKE1wXdYpaF/QlVMj2xZPU2Mv3Kr
         gDTcuWJ2TRn15gZT6p59kGRJFqxQeMUiGtH9z3XZd46TKIWxk6e/srKcg7kA6Drhi3ML
         lOGYULbG9P33noqWpp89tQ3WN9lq0paJ5hbn0kKZ/qbUasfrgU5iIh/2/jYa513/JYCi
         yZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7YD/h4aSRniUjU0YCShmmJvbKGJasf07UQX1lEPDdUQ=;
        b=geXc34h5r42/xuV/RMKC/SEwWWB4Gpfp7Hbj4HVvKQKN4tTQFVNN5miTBx7P2998eT
         AAwgHI4AyHY7MfByD3JDbieIWBrsz8bn2PBUH0YDeQA3sRBUHEX4rn6Kh1zU9uYy+IKc
         wOLX/clql6YeDlTmyzladlKARhlZdUs6ycNLeCh+9oaa1qPiNE/WIpruPMZ0JDttHNuX
         2R5pPY9+nKG5/lWVf8u1rEa8XqN8GGRQbSCwy6aSHEGUdUep4Y8GZ10gT48noWXRklmQ
         DzIyCqqW6oDdiuoZl+XcE43J+5lii6i00dOW0p8o62pEGhP+YD5Sm72jr0HKq9U6xJ0d
         GUwQ==
X-Gm-Message-State: AOAM532VJwyhoEtJ0iqx2/4Ev3U+XnkByDFc9xRXlDR1I2NBo0YhlJ8E
        FXLpJMwTiQ2f2ny+Cdy6IoveYA==
X-Google-Smtp-Source: ABdhPJwDhlnRRk7rOBVNkqnfkpOy+xDoYX9K26kpTtKYK68qJBnrOfd++ZJEzK+wFxppARYl9SnYsA==
X-Received: by 2002:a05:6830:54c:b0:5cd:b16d:e586 with SMTP id l12-20020a056830054c00b005cdb16de586mr6614817otb.166.1648770473020;
        Thu, 31 Mar 2022 16:47:53 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id o13-20020a4ae58d000000b00324dfcc5bcfsm421612oov.12.2022.03.31.16.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 16:47:52 -0700 (PDT)
Date:   Thu, 31 Mar 2022 16:50:21 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dov Levenglick <dovl@codeaurora.org>
Subject: Re: [PATCH 22/29] scsi: ufs: qcom: Fix ufs_qcom_resume()
Message-ID: <YkY+PVeBavFRATh1@ripper>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-23-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331223424.1054715-23-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 31 Mar 15:34 PDT 2022, Bart Van Assche wrote:

> Clearing hba->is_sys_suspended if ufs_qcom_resume() succeeds is wrong. That
> variable must only be cleared if all actions involved in a resume succeed.
> Hence remove the statement that clears hba->is_sys_suspended from
> ufs_qcom_resume().
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index f24210652fe9..808dae751527 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -640,12 +640,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  			return err;
>  	}
>  
> -	err = ufs_qcom_ice_resume(host);
> -	if (err)
> -		return err;
> -
> -	hba->is_sys_suspended = false;
> -	return 0;
> +	return ufs_qcom_ice_resume(host);
>  }
>  
>  static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
