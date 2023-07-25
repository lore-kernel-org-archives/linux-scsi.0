Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A3CC001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjGYTbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjGYTbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 15:31:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F12F2139
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 12:31:14 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6686ef86110so3371338b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 12:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690313473; x=1690918273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pJ/uG1DkstZEC0YXswlfcg4mzuHx2dCPosAJ8nyYiKU=;
        b=N4dmGGUd5s7Hnf7BUnXknOffvw5RpCLujs6YXVokTy7O+HKMwVP0BU5FsErUDPuXSv
         B5m4B4qn5zWpnhbLVDHf3/MxJ/0h8i821OvgUw9V4JOnkF/iIGO9pttdJzeIEulyl2hd
         ZakAh0DuQxZbuJ7ezALUYb+8r5+qN3/hXxPpj97JD/80NI6y7OfP/ahBFasL2wO7qiYk
         XNvNPhPpsSztOXvmtvhgQGHGlxzDVxDBBMIjia69p3q46fkANcLfFXi9Dh8pD/oBpLN9
         JqsFFcoub+fBOF0rYBe0ciF8Z7LUvvg8HPYqlC1nHCwagkw0o4eRh1Lb5L3c2k0Sq/6l
         wJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690313473; x=1690918273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJ/uG1DkstZEC0YXswlfcg4mzuHx2dCPosAJ8nyYiKU=;
        b=cx3CDRFMl1sngGZ6SdGv90Crq01ku3ZCE61b4J9hkw8naWoekMiLBooWhl2OI/y/K4
         yvTueLTCuJYeJiNXTjNpi3KS3GSpkWsEA4BbbIJxyCrh+qCi8l/yKHzd65GtB7yISrNB
         +AIIPDOh4dIiyROuHJS21orWPyReKQzg/1J+PzmeVjn8VUrBkjD8+ELOsOuYDu9MZWxK
         xDD/G5H0sAMT705agrTxl21VSuLi8EaWFO1ZGPR8YvW6fain2XWojwkFuu/SvwdKiIdD
         cjdZy2ituGRi/nN3fnt8Cwdg2vOzwqBTqoi+bimTGljgFYVRnIPl4W465vSfANp0J8Qo
         fmgg==
X-Gm-Message-State: ABy/qLbxWOZR9X/f7eLONFZ3cR1Ri1XwXdOSlOBwSVnWzG3d8c8E9KyX
        Ac4KPHpVfR+PxmKbpfOD9OB4PA==
X-Google-Smtp-Source: APBJJlEfiph3z9DO+KiJlO/NzedTyFz4ru8f0+GFAU4bYhlVeMPYwsoE9ZGEbBxIQqIQuL9kxelcfQ==
X-Received: by 2002:a05:6a00:2292:b0:64c:b45f:fc86 with SMTP id f18-20020a056a00229200b0064cb45ffc86mr162622pfe.17.1690313473383;
        Tue, 25 Jul 2023 12:31:13 -0700 (PDT)
Received: from google.com ([2620:15c:2c5:12:97dd:f6a2:bd1a:5c1a])
        by smtp.gmail.com with ESMTPSA id e15-20020aa78c4f000000b00686bef984e2sm93693pfd.80.2023.07.25.12.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 12:31:12 -0700 (PDT)
Date:   Tue, 25 Jul 2023 12:31:08 -0700
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-scsi@vger.kernel.org, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        changyuanl@google.com, pranavpp@google.com
Subject: Re: [PATCH] scsi: pm80xx: fix error return code in pm8001_pci_probe()
Message-ID: <ZMAi/F7ycX+NUzY5@google.com>
References: <20230725125706.566990-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725125706.566990-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2023 at 08:57:06PM +0800, Yang Yingliang wrote:
> If pm8001_init_sas_add() fails, return error code in pm8001_pci_probe().
> 
> Fixes: 14a8f116cdc0 ("scsi: pm80xx: Add GET_NVMD timeout during probe")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

> ---
>  drivers/scsi/pm8001/pm8001_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 2e886c1d867d..4995e1ef4e0e 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1181,7 +1181,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>  		pm80xx_set_thermal_config(pm8001_ha);
>  	}
>  
> -	if (pm8001_init_sas_add(pm8001_ha))
> +	rc = pm8001_init_sas_add(pm8001_ha);
> +	if (rc)
>  		goto err_out_shost;
>  	/* phy setting support for motherboard controller */
>  	rc = pm8001_configure_phy_settings(pm8001_ha);
> -- 
> 2.25.1
> 
