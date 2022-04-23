Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235DDC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Apr 2022 11:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiDWLto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Apr 2022 07:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbiDWLtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2022 07:49:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35D5FA435
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 04:46:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k4so4919209plk.7
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 04:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0S0S5fuFEbU9yXYTubsjxw2YWpXKUGELZ8mwol2duc=;
        b=bq8q2kzQEI0IEZeJno5JXEsEmtsP2XDtX8a7APwWbw8Bu6I9elN+nstWWF+B3Y0s2m
         pi7xJXoGCbXsysoZ2VmqVW3jxkDWwKZDOc7rRaa4Valv2baAqWC4Qf8xeRWvnXcCu/84
         TdHKR5MScLcIgRyRos+4if64pht/FJhObjCGh4DP/0cNKgCoTDsaHm5LqylisPBGuRS0
         LZURRVR8iERZkDcb8SayTQXPA6j1JcOYw0rYgOxYGrmvTAhnZIPRbNepLh8yT2WKpfL5
         ZMJ/ChqeuIsrJDYyfRidus+ONKG+hdvNCQxSfTZxxrXmgTvnTHAtWRu1mYaoF2U9b/v/
         AYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J0S0S5fuFEbU9yXYTubsjxw2YWpXKUGELZ8mwol2duc=;
        b=AzIIKXSxzM2ZtAGWmJdt7FXADoAWd28vcNtj8m+4KsXz/SdisMeskiSEUl1Y28YK1m
         F+H0h0GdS2/5kcJvy7wQc8XO1+i6+yyXUr5Vp0roEKeXZ9H68C+8Mbl8XOds4pd/NkA2
         sxZbDpkWOAOGs/pWYSAlYeHZpXt1N0jZl8aUCd3BMiNZUGatygQtD0rOJDnwk1B0gU3Z
         eo5D5PpSQ80nnhC4TVyvLhpkeGmrRzs4arfQnhmAmh8+gpMw/pw3Nh0eN7TJMZYd0KtD
         lQPXOW9kX85ErOE8KHALdkW7ILKSUsz4SM4/eB8Opb6xH8/Wap1L//3qYBSuf3TWuIS8
         7K3w==
X-Gm-Message-State: AOAM531m1nm0GX3ITIOSVY9UODuohMT3fTLKO4xJu68K3TQQj4hqt5yj
        acvleH4W75Bj16jymmAVg0U3
X-Google-Smtp-Source: ABdhPJygyj7U3ci2JCo8JtRud845IZLWNNfXjTuuKJYcvw6sZFDL45L1g8kw+xMiMNLDVNOCZ8ysxA==
X-Received: by 2002:a17:90a:5991:b0:1d9:27f3:74cc with SMTP id l17-20020a17090a599100b001d927f374ccmr3694119pji.90.1650714403387;
        Sat, 23 Apr 2022 04:46:43 -0700 (PDT)
Received: from thinkpad ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090a714600b001d7f3bb11d7sm5446077pjs.53.2022.04.23.04.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 04:46:42 -0700 (PDT)
Date:   Sat, 23 Apr 2022 17:16:35 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] scsi: ufs: core: Remove redundant wmb() in
 ufshcd_send_command()
Message-ID: <20220423114635.GC374560@thinkpad>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
 <20220422132140.313390-5-manivannan.sadhasivam@linaro.org>
 <10d7e4a7-4364-b579-fecf-53c953d22b7d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10d7e4a7-4364-b579-fecf-53c953d22b7d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 22, 2022 at 10:19:14PM -0700, Bart Van Assche wrote:
> On 4/22/22 06:21, Manivannan Sadhasivam wrote:
> > The wmb() inside ufshcd_send_command() is added to make sure that the
> > doorbell is committed immediately.
> 
> That's not the purpose of the wmb() call so I think the comment is wrong.
> 
> > This leads to couple of expectations:
> > 
> > 1. The doorbell write should complete before the function return.
> > 2. The doorbell write should not cross the function boundary.
> > 
> > 2nd expectation is fullfilled by the Linux memory model as there is a
> > guarantee that the critical section won't cross the unlock (release)
> > operation.
> 
> I think you meant that the writel() won't cross the unlock operation?
> 

yes!

Thanks,
Mani

> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 9349557b8a01..ec514a6c5393 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -2116,9 +2116,6 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> >   	__set_bit(task_tag, &hba->outstanding_reqs);
> >   	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >   	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> > -
> > -	/* Make sure that doorbell is committed immediately */
> > -	wmb();
> >   }
> 
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
