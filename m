Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669EEC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F199207DE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUz6BhKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgIHRIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732127AbgIHRId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:08:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A33C061573;
        Tue,  8 Sep 2020 10:08:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so9326021pfn.8;
        Tue, 08 Sep 2020 10:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FPMDkvAk1iaVD1/CfgpOrTqFeHdT/s4HmA4Aa+dW56w=;
        b=VUz6BhKLCRVxV/oCUBanPke25beWlVy7T7usC0n/+MpiMz0voCKBzSAQbTfe9i4eCN
         kRwwhyTS22N/OIP+IxnPFhoRkMTxr2GRhmP7NtcJzFQcj/S3F3gOasmwroELnJrC7/tU
         tzDD7YmHbUxPFktmb54YDPxolANYAYVOY3LyMy5thI5hMhyA6B17XIEXirqOS8FNkisN
         +5YktBbjakzbf5y2e4s6NFrvlVF1L0tRsKKPOdNlcNNUzSZDZjwiWv9OCsJqXP80jf1W
         2alUmUeCttsN3v7RrCNNQyZdg7h+8g1XZ9sZj26I86n7De6sBShliPC474maQWWscEP5
         BU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FPMDkvAk1iaVD1/CfgpOrTqFeHdT/s4HmA4Aa+dW56w=;
        b=J1i0KmRPIyXbDnQPYUNiCUIk9SgwTOGyAYbJI2tajymurXX902cK2THbrjAzqD/jxy
         0XyWg0BX6uwzk/zW2GEfEfhNFSDWdw1376GYIaXPIkSlu1LfMsqehyZj7bdcpxjrctpO
         UO6HuwSTxfr987JXly+cmJ6nPRCOERIfAxa2gEuVwlv1DXEebNVHTSTdqa98P8I+Buzl
         QOMUj8Im9cnbZZUt95TLS5Ec4xAzghOSt6dy8YbtrBPCuj7o+e7rlxo0HITt0MWA25gs
         9kQ+rdcfz2ndwtRWb/mQQfEkzHihZYSR1Xu3NkzvqdjLTBT0TtYrmRjGZyzMMiqKaESP
         ZyPA==
X-Gm-Message-State: AOAM53322r2SPG+mzg7uf+ZEg8hpwinHN7/mLITlFBjsUp/1iVD1Eo1V
        kYPJmEdyk+GGfUAzUjDim9Y=
X-Google-Smtp-Source: ABdhPJyuwDZJQpN1wt5oGKzDbNipkknmAC/uQO+n7ifbMCvdDWvDU7Ep9Ne2YkU8Hf9GOpMdeFhUQw==
X-Received: by 2002:a62:55c5:: with SMTP id j188mr12901555pfb.103.1599584912263;
        Tue, 08 Sep 2020 10:08:32 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id f3sm15412564pgf.32.2020.09.08.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:08:31 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:36:38 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v2 13/15] scsi: 3w-sas: use generic power management
Message-ID: <20200908170626.GN9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-14-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-14-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:26PM +0530, Vaibhav Gupta wrote:
> Drivers using legacy PM have to manage PCI states and device's PM states
> themselves. They also need to take care of configuration registers.
> 
> With improved and powerful support of generic PM, PCI Core takes care of
> above mentioned, device-independent, jobs.
> 
> This driver makes use of PCI helper functions like
> pci_save/restore_state(), pci_enable/disable_device(),
> pci_set_power_state() and pci_set_master() to do required operations. In
> generic mode, they are no longer needed.
> 
> Change function parameter in both .suspend() and .resume() to
> "struct device*" type. Use to_pci_dev() and dev_get_drvdata() to get
> "struct pci_dev*" variable and drv data.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/3w-sas.c | 31 ++++++++-----------------------
>  1 file changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index dda6fa857709..efaba30b0ca8 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1756,11 +1756,10 @@ static void twl_remove(struct pci_dev *pdev)
>  	twl_device_extension_count--;
>  } /* End twl_remove() */
>  
> -#ifdef CONFIG_PM
>  /* This function is called on PCI suspend */
> -static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused twl_suspend(struct device *dev)
>  {
> -	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct Scsi_Host *host = dev_get_drvdata(dev);
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
>  
>  	printk(KERN_WARNING "3w-sas: Suspending host %d.\n", tw_dev->host->host_no);
> @@ -1779,32 +1778,21 @@ static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
>  	/* Clear doorbell interrupt */
>  	TWL_CLEAR_DB_INTERRUPT(tw_dev);
>  
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -
>  	return 0;
>  } /* End twl_suspend() */
>  
>  /* This function is called on PCI resume */
> -static int twl_resume(struct pci_dev *pdev)
> +static int __maybe_unused twl_resume(struct device *dev)
>  {
>  	int retval = 0;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
>  
>  	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
>  
> -	retval = pci_enable_device(pdev);
> -	if (retval) {
> -		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x24, "Enable device failed during resume");
> -		return retval;
> -	}
> +	device_wakeup_disable(dev);
>  
> -	pci_set_master(pdev);
>  	pci_try_set_mwi(pdev);
>  
>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> @@ -1842,11 +1830,9 @@ static int twl_resume(struct pci_dev *pdev)
>  
>  out_disable_device:
>  	scsi_remove_host(host);
> -	pci_disable_device(pdev);
>  
>  	return retval;
>  } /* End twl_resume() */
> -#endif
>  
>  /* PCI Devices supported by this driver */
>  static struct pci_device_id twl_pci_tbl[] = {
> @@ -1855,16 +1841,15 @@ static struct pci_device_id twl_pci_tbl[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, twl_pci_tbl);
>  
> +static SIMPLE_DEV_PM_OPS(twl_pm_ops, twl_suspend, twl_resume);
> +
>  /* pci_driver initializer */
>  static struct pci_driver twl_driver = {
>  	.name		= "3w-sas",
>  	.id_table	= twl_pci_tbl,
>  	.probe		= twl_probe,
>  	.remove		= twl_remove,
> -#ifdef CONFIG_PM
> -	.suspend	= twl_suspend,
> -	.resume		= twl_resume,
> -#endif
> +	.driver.pm	= &twl_pm_ops,
>  	.shutdown	= twl_shutdown
>  };
>  
> -- 
> 2.27.0
> 
.
