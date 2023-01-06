Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D65C3DA7A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Jan 2023 08:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjAFIqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Jan 2023 03:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAFIqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2023 03:46:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C13625E6
        for <linux-scsi@vger.kernel.org>; Fri,  6 Jan 2023 00:46:21 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso4633650pjt.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2023 00:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7704TWGlOT9biW+iIZT64FatF6rRcnjwYUtQOdttF18=;
        b=Qzh6CyLZawj7lAuPdlzvPNtNUN5w5z5tt4rTHip/orgibj8P2fgzdrOvM+qknJF/f3
         1dpfPJj8KGJYSUup4DRVge6N3bG/E6bsrp6Jm2FxD0ATcpgFSXXFR4ta6dlm9RZhj8UV
         G6M26mTdsDNlJYfxPZ7pMMTk3E0BWIOMVD0V1n9R70Gl5pGbXqABi8eJDsNoggJAr8wt
         9iLuNqNeOeY4B68y24cYNLVGc1xBYoSrtH5j7n+juegwoRu2CeAgul6nHUNj9cDoE+Ka
         RmBc7EFIgoxjwxF2F+o7ArJ2pyMW1z3swKkwHlA/0Ee8NX1gBFGEjlR1KLzqjm1+0aMs
         HWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7704TWGlOT9biW+iIZT64FatF6rRcnjwYUtQOdttF18=;
        b=sHiQISA/hh2D1obqJl0Kklb2ZTLQLIvg1uY1YyEOU3br9XAmyVYc/8wy8nXmOJZOPe
         TYuEc3+FR/8nr37sYhZhdB7e8yW4JJK+jQejDAlo2QL7yYzy6cyxU9i3RhXwWN/90ZqN
         MtjxzHxMkPsoJ25RQ4YbbRMFAoINy25iQg8hIylkeuQ2LY4ROqML4g919dnZf2GVv56W
         h7T8jCEebZWW2MWs8wqR/xwq6DV4g2iq0PQRwu50oPjm7MDTWcTiTZUYyWnnezSAMzWz
         kJzhbZaFEqvXGNWxHndU2t19dl02g94da+6YtR+YpjqiZcpzfWgm//qT4hMH9MzccJPo
         LfZA==
X-Gm-Message-State: AFqh2kqYIB0imb76QjNZ3ahZ8SFC3dlxOihn2xKaDTAdK7Ggrrls7IBv
        aqJfCzX6ghW09Xkc0WC14hV/
X-Google-Smtp-Source: AMrXdXtW0CUE+lF0WbXsjMGFILtHeiuFcbzJuPhkma60sHYDBtu5vEHeOWpg/hkqjQQD8ZKvp+PrpQ==
X-Received: by 2002:a05:6a21:33a9:b0:af:8ff3:fc78 with SMTP id yy41-20020a056a2133a900b000af8ff3fc78mr76825245pzb.19.1672994780814;
        Fri, 06 Jan 2023 00:46:20 -0800 (PST)
Received: from thinkpad ([117.217.183.19])
        by smtp.gmail.com with ESMTPSA id h69-20020a638348000000b00473c36ea150sm483422pge.92.2023.01.06.00.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:46:19 -0800 (PST)
Date:   Fri, 6 Jan 2023 14:16:08 +0530
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
Message-ID: <20230106084608.GA5542@thinkpad>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
 <yq17cy84gqc.fsf@ca-mkp.ca.oracle.com>
 <20230102084707.GA16638@thinkpad>
 <yq1r0w91zbw.fsf@ca-mkp.ca.oracle.com>
 <20230105100044.GA4463@thinkpad>
 <yq1y1qgz7wu.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1y1qgz7wu.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 05, 2023 at 10:02:56PM -0500, Martin K. Petersen wrote:
> 
> Manivannan,
> 
> > Thanks Martin! I presume that you have applied only the ufs patches as
> > mentioned in the cover letter. PHY patches are expected to go through
> > PHY tree.
> 
> Correct, I only took the SCSI patches.
> 
> > I cannot see the patches in 6.3/scsi-staging branch yet, so couldn't
> > confirm.
> 
> I did not push my tree to kernel.org as I discovered that one of the
> merges had pulled in a bunch of unrelated commits into staging. Will
> resolve this tomorrow.
> 

Okay. Thanks for confirming!

-Mani

> -- 
> Martin K. Petersen	Oracle Linux Engineering

-- 
மணிவண்ணன் சதாசிவம்
