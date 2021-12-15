Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD2DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 03:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhLODwf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 22:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbhLODwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 22:52:35 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A6C061574
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 19:52:35 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso23361459otr.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 19:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ynopo09RI8PrjCz9AeA78ncUw8E1SV50X5DaollUr+U=;
        b=Az885c/t3HUhYcA0V3pjavGfxcFs5WSqzgBDM0zPXcNlv4lSaeHYTmIokqanlegZDq
         MFiICtT3G5xPWs9a8OcwvDPZEv/K2tQrwqIEcKTr2/j2aHT3QaznWyE94S50zMMuo3ou
         tO4b8KOQNS6b67eIpwClq25yqVVqug0YO/iTEwcwOismc9zJh5PbdcNXwP/5lx19NwkZ
         59vLtkd8z7iucbQ147W9h/hmV86nDMth8PdxvP7WdkLABueGZICD9i1MzqS0rziVXkZZ
         GcKj0SQoijf3yoblMzIcToimtFgiELh48G2U/srsE+bHFsQvKurW7C9Vg5FDz3iYM4nU
         SsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ynopo09RI8PrjCz9AeA78ncUw8E1SV50X5DaollUr+U=;
        b=y+Qg4e4hb5e6H2e1CD58dyp3BMyTc/wvHPSajObdxQO/1XbLeUpuJsepv3qpMQ1xx1
         3hZxzhwKN2l/x08Wm3qR2tiyFeYmr0w7Wa2Y9hjCIOXcUvcmlIpxX75Me9sn81USwF8X
         75E+ww+TXeG7TmsZMYbEp3pBN+FHEVZXppJHKhAI6nhBf7Wv9rybw3/t1wtFxt/aIRiL
         Po3vb2ol8MBzUJWW325DL1yo3wS0KpISNAq/9Q5tUS+V1J9PFwvVB1WF4OI46Epe9iiZ
         sPS+xr/R+D+GoS9Vp5ClIYKO/Tbtjl5HhUMJnwxPS5TvNv2foftfblSvtRplE/+fH7vL
         LEfQ==
X-Gm-Message-State: AOAM533J7OAl+p0MPnOFOjxT4x3sva3XHYilyQBE4gsoIa6wkhilj5Du
        L1mKXSpScyD1yxejEUEOUAitWg==
X-Google-Smtp-Source: ABdhPJymxSzQljCj6gzvWDPchnY/4p4Gcm+n3QNp9ZVW4GO4729Fed0dNFqpiQrpJx9gXKwhmfzwSw==
X-Received: by 2002:a05:6830:1544:: with SMTP id l4mr7263304otp.309.1639540354496;
        Tue, 14 Dec 2021 19:52:34 -0800 (PST)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id c41sm203323otu.7.2021.12.14.19.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:52:34 -0800 (PST)
Date:   Tue, 14 Dec 2021 21:52:29 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
Message-ID: <YblmfSDOrxHZ/aW8@yoga>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org>
 <YbgX5qZ4VFXPqnnr@ripper>
 <701e993f-0b74-204a-1b07-306c13820fa9@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701e993f-0b74-204a-1b07-306c13820fa9@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon 13 Dec 22:57 CST 2021, Bart Van Assche wrote:

> On 12/13/21 20:04, Bjorn Andersson wrote:
> > Can you please help me understand what I'm missing? Or how you tested
> > this?
> 
> Hi Bjorn,
> 
> Unfortunately I don't have access to a test setup with a Qualcomm chipset.
> Please help verifying whether this patch is sufficient as a fix (see also https://lore.kernel.org/linux-scsi/101fa5ba-6d74-6c51-aaa2-e6c6d98f6bc7@acm.org/):

Thanks for the proposed fix!

> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6d692aae67ce..244eddf0caf8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1084,7 +1084,9 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
>   	struct scsi_device *sdev;
>   	u32 pending = 0;
> 
> -	shost_for_each_device(sdev, hba->host)
> +	lockdep_assert_held(hba->host->host_lock);
> +
> +	__shost_for_each_device(sdev, hba->host)

I can confirm that this resolves the issue I saw and allow me to boot my
boards again. Can you please spin this in a patch?

Feel free to add my:

Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Thanks,
Bjorn

>   		pending += sbitmap_weight(&sdev->budget_map);
> 
>   	return pending;
> 
> Thanks,
> 
> Bart.
