Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23247EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 21:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjGYVx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 17:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjGYVx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 17:53:26 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A64212C
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 14:53:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-563d3e4f73cso520923a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 14:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322005; x=1690926805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FKEGWqR+0CcbBPqsp+sUK+ljfwl+CRQxiq3hvwMVKVA=;
        b=Ezfa2u2HhaeTgeNqBXH8xd9D2MI9qrfjH69Xx0NPM6zHyCWs9yXApqOJjRZsQ2UDbz
         W5bfiOhd1Fb85DDr8JX3eRtQglvAbMRqN3GnL/Ub5AiuUZXguuhlCyAAGo+cPMdCU/+e
         xaU/5GEExeo0ujzemcSnB48J8FP8ET8E5sJ1b8ATpaOKJqBUt4egPXvjvxAwEpMcaZku
         tE8gf9AgqNJGWst37Eld3kg6IjbjwTyiXqocqs20vIJ977nLEJO9d84cPSSSS6vcSPyN
         g8dBcW6QgoMaVclfJ4fQ+sO7HEAjj8N9XOl65pRVUTqID4zH0pi4V8vz3CcGj7r4WGRU
         3eYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322005; x=1690926805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKEGWqR+0CcbBPqsp+sUK+ljfwl+CRQxiq3hvwMVKVA=;
        b=JKvyJLYCxMlumswTEXuYQ8gvxY6msJX4oSt7fNusQ/gyGdjoh/2rAnZISv+ZRjX3s5
         YxG/zi+ZviFeCnIIZj/sPFcSsUS4SzDfMFe0mjWv5LCJW/q5LJARICIiBa3zNxpTJQMD
         qlgAgrGpdheJeNKD/Xs5TVRv3QOae6Z7wVXdqU3M3WEchsz6sWP+crEHBeX8P70MhPq7
         XWJYdMdA9djcZf3tnxrmx52fKMmoEIuvc8/21WzLr3DIpcDU0MeLxtKz4OWmll8Re3d1
         sOpUWr6H+ykeuHBBMNOd6YGyHnOfn+2tYjpLFEt3z7tr88qe0Kzc7GRnY4yk/AVm6/DN
         77qw==
X-Gm-Message-State: ABy/qLawiWPPxC1+0Tx95pX2d2ZESQPPSL2boIV5Edt4fjTZSxJq5R0r
        gZZ5SMNXiVZ5TmoHYsu/OJKIlA==
X-Google-Smtp-Source: APBJJlHquQuuWxLQmV9ZAeTnV8BBjL+QYV6S+sbeqEwRh0gcunK9cb74PhLG1/SldT8Yr7YBeJOujQ==
X-Received: by 2002:a05:6a20:4406:b0:137:3eba:b7fb with SMTP id ce6-20020a056a20440600b001373ebab7fbmr343053pzb.2.1690322004749;
        Tue, 25 Jul 2023 14:53:24 -0700 (PDT)
Received: from google.com ([2620:15c:2d1:203:a7a4:bf67:c9d5:c1b7])
        by smtp.gmail.com with ESMTPSA id i21-20020aa787d5000000b006829b28b393sm10097875pfo.199.2023.07.25.14.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 14:53:24 -0700 (PDT)
Date:   Tue, 25 Jul 2023 14:53:19 -0700
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>, Arnd Bergmann <arnd@arndb.de>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] scsi: ufs: qcom: remove unused variable
Message-ID: <ZMBET5+0ooHfpJbS@google.com>
References: <20230724122029.1430482-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724122029.1430482-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 24, 2023 at 02:19:58PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A recent change removed the only user of a local variable that needs
> to now also be removed:
> 
> drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_mcq_esi_handler':
> drivers/ufs/host/ufs-qcom.c:1652:31: error: unused variable 'host' [-Werror=unused-variable]
> 
> Fixes: 8f2b78652d055 ("scsi: ufs: qcom: Get queue ID from MSI index in ESI handler")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch!
Reported-by: kernelci.org bot <bot@kernelci.org>
Link: https://lore.kernel.org/llvm/64c00cd4.630a0220.6ad79.0eac@mx.google.com/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 3ee5ff905f9a6..5728e94b6527b 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1649,7 +1649,6 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
>  	struct msi_desc *desc = data;
>  	struct device *dev = msi_desc_to_dev(desc);
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> -	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	u32 id = desc->msi_index;
>  	struct ufs_hw_queue *hwq = &hba->uhq[id];
>  
> -- 
> 2.39.2
> 
