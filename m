Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDC2C3DA7D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 10:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjAEKDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 05:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjAEKCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 05:02:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D5309
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 02:00:52 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a30so9328336pfr.6
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jan 2023 02:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S5vBFARuIRiK64V5wwqFkQ5kzYGu77jWfbY7LeM0ol8=;
        b=gaUFFXLBJ8PxpmBmW3TEwh1Bh7dvc7x8b51VrFeqk/UV1oRAv7DGYCii+Tp1w2gdb+
         moNaPe8ZyZfVPqr7joC6v/1kXLO2chLGNwGG09hcl8F934DBj2+0p5dxma32DpPJgSyV
         zLkTt9/SFjk+1aeTbq49pfAEdGpcpJqtqClgwD4NvQ4jFLsYiaZJrC2pj7pkFKUR+YOv
         u5zYlsaxIj1tgiUKpyRkzQZQkNdURyjqziPtbH1aZPRr9jyEHSXkB3pwCC1OpMQuNsJ8
         JWKZ2zsxIP2frDFCQ7iETLcUCuYFiTYEqi2rNk+C1leadvkM7j5dpar2s3ivKLuif4Px
         sd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S5vBFARuIRiK64V5wwqFkQ5kzYGu77jWfbY7LeM0ol8=;
        b=EzSWIEmpXbUPpGhShrhvZlvWNqysNbuwl8RZ1YpRwYOJLLkcMgqbUDWJ3YaAYmPnMj
         V52HnfUtg66aSSaN97/gyKfdjCnr/C2KI8rPvLAySECzx0XtcaualvIX81Uhv0Ro5zwI
         GdSf7QBiXo4YpO+WbMqb87VRiQwxbewA1goLRGfaNTUFHr25XKHO26LfBO+jatRKVFFv
         VB/cPOp/SUopFlqeLUqtOJJMfyO1hsGxXlUJMzIRGjJudsodSmz/A0emhB8pXwTqxRCL
         PGZRaRAsyqt2V2f87EvvU0TPJt7gFg3jS5MXVzyLoSycL5tcbdv/9AbkDYz34I1p7eh2
         3fEQ==
X-Gm-Message-State: AFqh2kpNM8ahUDLXVft5022Etkqioyb3o29QLIasJ3yr2QueKNXBcocp
        gLK/U3ue7aW3g1pWX+aeTWMD
X-Google-Smtp-Source: AMrXdXuy76CFoqhJHzUdLoYbZsqoqgin0M+AYQcrcUafsVBfHmWvkfzOtigXyuToV0Hxsvl02rix2g==
X-Received: by 2002:a62:5801:0:b0:574:a541:574a with SMTP id m1-20020a625801000000b00574a541574amr48434720pfb.0.1672912851913;
        Thu, 05 Jan 2023 02:00:51 -0800 (PST)
Received: from thinkpad ([27.111.75.153])
        by smtp.gmail.com with ESMTPSA id a14-20020a62d40e000000b00581fddb7495sm11582395pfh.58.2023.01.05.02.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:00:50 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:30:44 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, andersson@kernel.org, vkoul@kernel.org,
        quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org
Subject: Re: [PATCH v5 00/23] ufs: qcom: Add HS-G4 support
Message-ID: <20230105100044.GA4463@thinkpad>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
 <yq17cy84gqc.fsf@ca-mkp.ca.oracle.com>
 <20230102084707.GA16638@thinkpad>
 <yq1r0w91zbw.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1r0w91zbw.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 04, 2023 at 09:37:56PM -0500, Martin K. Petersen wrote:
> 
> Manivannan,
> 
> >> >   scsi: ufs: core: Add reinit_notify() callback
> >> >   scsi: ufs: core: Add support for reinitializing the UFS device
> >> 
> >> I would like to see some reviews of the proposed core changes.
> >> 
> >
> > Both patches are reviewed by Bart now.
> 
> Series applied to 6.3/scsi-staging, thanks!
> 

Thanks Martin! I presume that you have applied only the ufs patches as
mentioned in the cover letter. PHY patches are expected to go through PHY tree.

I cannot see the patches in 6.3/scsi-staging branch yet, so couldn't confirm.

Thanks,
Mani

> -- 
> Martin K. Petersen	Oracle Linux Engineering

-- 
மணிவண்ணன் சதாசிவம்
