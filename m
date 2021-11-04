Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6102C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA01061207
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhKDWXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhKDWXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 18:23:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52B6C061714
        for <linux-scsi@vger.kernel.org>; Thu,  4 Nov 2021 15:20:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t30so10813301wra.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 15:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=W/sQm0xefgpfLaGFS96Kx3/K1SknO2AlssND4EP4Sfg=;
        b=S+Fqdan/leM5Z192AkyefuhhnqV9lT1NsKEYT6IANgmJNk6Q1kOhJmEnzWHU99rsfN
         86WnM7N2QH1z2RdLZGnxrP6GBmoO9nQKfltU8rMGRBvl7ewuiQLEcrz4xK9fTvnMy3N4
         BGVmZv1H3z+hSKe+0+Dy/B1SRwuz/IZ3Scj+6kj28hvi3jxW8iBsCKv6zWqnlrWRTv9L
         8GdOc84si5b5AJvrMFcfveLlkAcVJvINyuil/4SkZalKYrIssFlOVgdXIFsus95ul5S8
         tcEK1NNoVp79agJ2O/ISv85sZQAJdEbAuABH/J4Ul6mv7W9J7bx8R5CLJrsw4b+KNaUq
         abNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=W/sQm0xefgpfLaGFS96Kx3/K1SknO2AlssND4EP4Sfg=;
        b=YJkMjGtMG9LyBsrol1eWlZzVewpEtlu6iquZRkULNmEokEkwzO81RNXMoKuQNGp/OZ
         kNEBF2PibKSvwaOGBY80YmiLCd0g52IH+wpNDq3YmilwsJr+0LuAO0yGvXr3fzQ/q10Z
         0fra2NjsTyK1WrrSm4wlOkx9ehNWqBlc2FPU+KJCM6+na3TYNjSOEl8F+WFPsZnvzdwh
         gtkIEp9LGPZoYo0+ldnq/ydbL90TSnXvfZsmQHBN8AFHQfxrlTQAUHMeUTD3peO02PXt
         7V2UoMPxFFrUr6A+AkAYDDi7V+3dZHCHx4yN+1v9GbWo6YU7/zQ3n2fyfqaeh5hLawjI
         s+Mg==
X-Gm-Message-State: AOAM5326isyAWFTU1XoMPqko3+ytsLUK6VzidrlGX3hTuPyd47pV5x4c
        ro+jqj9j3E5r+oWx5+KctZQ=
X-Google-Smtp-Source: ABdhPJzJn3l/b86sPBbCeC6wQN2oRIqOfIKzCa4qWrbURhKNOztcQhyTFyTTR8egVOgCE5BWI24zzg==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr47708280wrj.84.1636064433238;
        Thu, 04 Nov 2021 15:20:33 -0700 (PDT)
Received: from p200300e94719c94bf62036d25ff0e8a8.dip0.t-ipconnect.de (p200300e94719c94bf62036d25ff0e8a8.dip0.t-ipconnect.de. [2003:e9:4719:c94b:f620:36d2:5ff0:e8a8])
        by smtp.googlemail.com with ESMTPSA id n7sm6135730wra.37.2021.11.04.15.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 15:20:32 -0700 (PDT)
Message-ID: <3904d35bcfa40cd28edfd5f72f0edde68d0f6bf3.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>
Date:   Thu, 04 Nov 2021 23:20:31 +0100
In-Reply-To: <20211104181059.4129537-1-bvanassche@acm.org>
References: <20211104181059.4129537-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-11-04 at 11:10 -0700, Bart Van Assche wrote:
> The following has been observed on a test setup:
> 
> WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737
> ufshcd_queuecommand+0x468/0x65c
> Call trace:
>  ufshcd_queuecommand+0x468/0x65c
>  scsi_send_eh_cmnd+0x224/0x6a0
>  scsi_eh_test_devices+0x248/0x418
>  scsi_eh_ready_devs+0xc34/0xe58
>  scsi_error_handler+0x204/0x80c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
> 
> That warning is triggered by the following statement:
> 
> 	WARN_ON(lrbp->cmd);
> 
> Fix this warning by clearing lrbp->cmd from the abort handler.
> 
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3b4a714e2f68..d8a59258b1dc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7069,6 +7069,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> +	lrbp->cmd = NULL;
>  	err = SUCCESS;
>  
>  release:

