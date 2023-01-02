Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DE6C3DA7C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Jan 2023 08:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjABIrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjABIrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2023 03:47:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2966126C3
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2023 00:47:14 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id jl4so22718964plb.8
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jan 2023 00:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tkq2fYPAAfCT6CmgtdbmFTqHCyc6irGoNXfZDkU6fuw=;
        b=p93mZ34atd0r0rIEpm6svkrRZ9FPVeK8Dv9EYEQJHXFoyIEM7K6vf2gGV60goJnIc9
         HevkH6rQ2a+EMePniVp0o2vvM0xSld1KA+S6zcwr1Nzqijv0jpTc9u2vNON/jc0RM2TX
         IgRGoM+k6l4pwYnEABIPni9VfHqCtZFhetDOjA8nbxvJ306OXVIKSSj5UrlgtJhcJK3v
         U7Y1JyH0OO2PGyVm8ZyD9fLPcDxj7G19HzjE469P537WGdBJjYFke8rz+zg9U9hHu/+D
         CEcIS6MDBoo0znvZwNvz6lotdJRJPIqcws6AcGj29i8n8MCQfTafeaku7BXtHTy6LmNP
         oSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkq2fYPAAfCT6CmgtdbmFTqHCyc6irGoNXfZDkU6fuw=;
        b=xM+bImhUyHsjE7Njqj8l7TD45ZUwXi4rEMOrTUVGoSP9RhKffna2vYs4ekbBfAzYhC
         yrr2Nay+xTYQ2u47wyZWfBv/vbn0nv6f01kBklAg535gmJLtNAsSNRWq+vr1A/De7Ixy
         XBYCSzV4E2sIoWfVck7WMs5uXM1BOF8KD0/+1914hxjS69WdDv7y/xmU7PckXo2CwhWd
         FCLTmGDZ3zZWAaMxIWuODaATaWvOqkQ7Zm+TVVBhjgdTvBwnjbj57utoSchXEy8hDhos
         /XaQNLGLnD41JwKvcxvjhtlS/3n6Yl5kXtd0e4CwGjgGUuTXwETKmJn19uc/vszFBwqh
         Pqrg==
X-Gm-Message-State: AFqh2kopJQIG6Uintkl0YEJP10WWBGKY+2u3rdkfkku7iLu/Hufd2SUF
        hndzGlkBnvpcidWKFWvBEP92
X-Google-Smtp-Source: AMrXdXs4EMX0rX34O8k6lqYjXiFN2NlmyBxs4ZAhDFblSqzK9GJaN+YN/7NTn4wtD7Cl5I+616O4mw==
X-Received: by 2002:a17:90a:b10b:b0:225:cc25:802f with SMTP id z11-20020a17090ab10b00b00225cc25802fmr33334186pjq.28.1672649233597;
        Mon, 02 Jan 2023 00:47:13 -0800 (PST)
Received: from thinkpad ([220.158.158.187])
        by smtp.gmail.com with ESMTPSA id q7-20020a17090a430700b0020bfd6586c6sm16618209pjg.7.2023.01.02.00.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 00:47:12 -0800 (PST)
Date:   Mon, 2 Jan 2023 14:17:07 +0530
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
Message-ID: <20230102084707.GA16638@thinkpad>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
 <yq17cy84gqc.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq17cy84gqc.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Fri, Dec 30, 2022 at 06:29:24PM -0500, Martin K. Petersen wrote:
> 
> Manivannan,
> 
> >   scsi: ufs: core: Add reinit_notify() callback
> >   scsi: ufs: core: Add support for reinitializing the UFS device
> 
> I would like to see some reviews of the proposed core changes.
> 

Both patches are reviewed by Bart now.

Thanks,
Mani

> -- 
> Martin K. Petersen	Oracle Linux Engineering

-- 
மணிவண்ணன் சதாசிவம்
