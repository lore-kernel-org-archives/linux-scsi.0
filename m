Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C449EC4741F
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 10:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7723822202
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 10:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKd1/Bot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgKGKIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Nov 2020 05:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgKGKH7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2020 05:07:59 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF01C0613CF;
        Sat,  7 Nov 2020 02:07:59 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id g21so677885pjv.2;
        Sat, 07 Nov 2020 02:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nmFU5sed5ZyqmQs5C3BIA0ekbw6XYoQtkasRnTVWhAc=;
        b=nKd1/BotcNl4LgAUt5dzbxSSovCcNp9oJ9Bwg9GepNPCpV3st+P/K318NHiI9oURBh
         OCgSQsohQzyOC8e/yeY/IpkyqpOIAU8s/8mlaj0qcDEBtUiLzpYdioV41tHLQS9e0ME7
         IREwHP7yMMmRM+ebSKI39doYpOwUXX5cDH+UyS/yNnnJRVq4Ix4k2b2TZLYq/3UQMx5H
         dtWaixk+3UtK8p3ifQTSYo/ktKtv5tHgG+VQPpQ/d0YOcziE7enrXb/NkyIQkpBdPkpu
         WO4OA12x44tffbCGkDnv6mMyMb9cqQw6DyqhRJwrcKJkPgYkWY9djgZUKDDYlb1p+MYf
         8zhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nmFU5sed5ZyqmQs5C3BIA0ekbw6XYoQtkasRnTVWhAc=;
        b=awD7hy274Rx2GQ2gNSHcKDiHFCaeDiLQhB0FIrsB77n41zmnPeCUoY9eYifMD6WwIT
         80raj5TWy/w1v5Yv0gMLDG4NsfiflW4HMu7myd5Dl3xLbkzK/HMlXzqA8fcYLCmnCt3e
         QpeVAUpVUTLjFqMwt5EA2FCKZ5HfaQFJlZidG3nZ72NQc2+u2Mzz3Q265CSk8RXDPI8w
         k70wfWRXSX9uH0tGjka6C8xxVQQ5tnh+lkdI5Lx3wJCq2ycsxYe0Ea1GpwAlxm6hrgFs
         +O8tRbiVDWILrC8h0yPf0PRQidRrLDEl6uFk4Hcoh0IuGhUJMyzMfMNrQc/QjO/OWIPA
         N29g==
X-Gm-Message-State: AOAM531DbaNNS/IPkUxMAvMRve9Dcaps9GW3VdUTy47UR1lr+jUKtsxB
        alj7vyNSltI/wdy8JlkOirQ=
X-Google-Smtp-Source: ABdhPJyMuIWjxP7RQ0FbSXLlnNlqyFv7zFZUZcrrBPSFG1WOpvmrPvwwIfQUTo5IrCiiQL/Rpm9gog==
X-Received: by 2002:a17:90a:8802:: with SMTP id s2mr3635761pjn.149.1604743679303;
        Sat, 07 Nov 2020 02:07:59 -0800 (PST)
Received: from gmail.com ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id h3sm4837559pfo.170.2020.11.07.02.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 02:07:58 -0800 (PST)
Date:   Sat, 7 Nov 2020 15:35:31 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Intel SCU Linux support <intel-linux-scu@intel.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: isci: Don't use PCI helper functions
Message-ID: <20201107100531.GA149641@gmail.com>
References: <20201107100420.149521-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201107100420.149521-1-vaibhavgupta40@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 07, 2020 at 03:34:19PM +0530, Vaibhav Gupta wrote:
> PCI helper functions such as pci_enable/disable_device(),
> pci_save/restore_state(), pci_set_power_state(), etc. were used by the
> legacy framework to perform standard operations related to PCI PM.
> 
> This driver is using the generic framework and thus calls for those
> functions should be dropped as those tasks are now performed by the PCI
> core.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/isci/init.c | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index 93bc9019667f..c452849e7bb4 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -715,10 +715,6 @@ static int isci_suspend(struct device *dev)
>  		isci_host_deinit(ihost);
>  	}
>  
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, PCI_D3hot);
> -
>  	return 0;
>  }
>  
> @@ -726,19 +722,7 @@ static int isci_resume(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct isci_host *ihost;
> -	int rc, i;
> -
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> -
> -	rc = pcim_enable_device(pdev);
> -	if (rc) {
> -		dev_err(&pdev->dev,
> -			"enabling device failure after resume(%d)\n", rc);
> -		return rc;
> -	}
> -
> -	pci_set_master(pdev);
> +	int i;
>  
>  	for_each_isci_host(i, ihost, pdev) {
>  		sas_prep_resume_ha(&ihost->sas_ha);
> -- 
> 2.28.0
> 
The patch is compile-tested only.

--Vaibhav
