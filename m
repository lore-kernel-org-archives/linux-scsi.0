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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0837FC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83772098B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcpQncCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgIHRGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731932AbgIHRGV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:06:21 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE372C061755;
        Tue,  8 Sep 2020 10:06:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mm21so39894pjb.4;
        Tue, 08 Sep 2020 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AnfV4++qeYNOgdT0ROy0q1s9L3CrCi5xVMUzWVJilp4=;
        b=kcpQncCg9k2mhH5jl/RiR2b3GZFmDxAcNV3VLPkKAglPHCCTivucamWHSZC/NKxc5O
         aaA55gr7lvZfumQEQJQLqS3mUIws0vyF0hYM25P8HKpfbJnburAlI94mFx/5162MCU6+
         /b54aZObkC6o0VfCmT3WPYf+yVeRgQAaat4iae3R2kSOdmdPie5Lq8RUk3lnWBL57dBx
         fX0a/ubFHw6BU8hmyzvoAboekabmJX3tAI6cnpGXENYJ/il2EaR1pkkUoz8Ut7MP3O9N
         H6t3AiyvR8PYxlmTM4XGS/oAlF8wMeTPyN6Rx2oco+zlPyhrkwCZkltNHuVcSdvLILw5
         ttYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AnfV4++qeYNOgdT0ROy0q1s9L3CrCi5xVMUzWVJilp4=;
        b=FzODszaNLKz6CfJya9tTRHp60lOO1e9VhkAqALO5OnpQ9a1/1tseifFLwHncH2rFvr
         VzW1+3+s+lOjcKkIVBr3X/Fne/DggtgIcbZDqmEzV07JGpJoymFUYX+gqho4A6EthXkM
         4ETAAThOXIbDHq0tiM1bjCeka5EtVVKm5V3tCHwN0osOYnumQKBpqURd8N8orl3Y7GIA
         nW7EESBTDaqa4oluU8s1ClW3VgvhXHIqh9kMd/jTkRGqmmuXVjghvGZAoS7Ew+WbMojo
         7/Grk7c5Lz6IbA5clfQssY+6lcvYi7wm1l1qgwbYeVAkPingQuPPLTW8/9W1iicXW5Rw
         QNJQ==
X-Gm-Message-State: AOAM532+xsGPAFuW/rT/DXlQSMVdhb+1cjU5xilYKKpHR5pDVgRzol3W
        Y/RBqNB2GWHUh09h6SM6fd6TSOxFk7ypy/Je
X-Google-Smtp-Source: ABdhPJwyX8LocD+VxFqC4aQKnDsDammaHOlfIYOcVtg+NexiuZMaDsHgWMOePIj2lh7oNOLVT/bkFg==
X-Received: by 2002:a17:90a:fcc:: with SMTP id 70mr85978pjz.220.1599584780350;
        Tue, 08 Sep 2020 10:06:20 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id 25sm19066pfj.35.2020.09.08.10.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:06:19 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:34:27 +0530
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
Subject: Re: [PATCH v2 10/15] scsi: pm_8001: use generic power management
Message-ID: <20200908170427.GK9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-11-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-11-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:23PM +0530, Vaibhav Gupta wrote:
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
> 
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
> 
> The driver was calling pci_save/restore_state(), pci_choose_state(),
> pci_enable/disable_device() and pci_set_power_state() which is no more
> needed.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 46 ++++++++++++-------------------
>  1 file changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9e99262a2b9d..d7d664b87720 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1178,23 +1178,21 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>  
>  /**
>   * pm8001_pci_suspend - power management suspend main entry point
> - * @pdev: PCI device struct
> - * @state: PM state change to (usually PCI_D3)
> + * @dev: Device struct
>   *
>   * Returns 0 success, anything else error.
>   */
> -static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused pm8001_pci_suspend(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
> -	struct pm8001_hba_info *pm8001_ha;
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>  	int  i, j;
> -	u32 device_state;
> -	pm8001_ha = sha->lldd_ha;
>  	sas_suspend_ha(sha);
>  	flush_workqueue(pm8001_wq);
>  	scsi_block_requests(pm8001_ha->shost);
>  	if (!pdev->pm_cap) {
> -		dev_err(&pdev->dev, " PCI PM not supported\n");
> +		dev_err(dev, " PCI PM not supported\n");
>  		return -ENODEV;
>  	}
>  	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
> @@ -1217,24 +1215,21 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
>  			tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
> -	device_state = pci_choose_state(pdev, state);
>  	pm8001_printk("pdev=0x%p, slot=%s, entering "
> -		      "operating state [D%d]\n", pdev,
> -		      pm8001_ha->name, device_state);
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, device_state);
> +		      "suspended state\n", pdev,
> +		      pm8001_ha->name);
>  	return 0;
>  }
>  
>  /**
>   * pm8001_pci_resume - power management resume main entry point
> - * @pdev: PCI device struct
> + * @dev: Device struct
>   *
>   * Returns 0 success, anything else error.
>   */
> -static int pm8001_pci_resume(struct pci_dev *pdev)
> +static int __maybe_unused pm8001_pci_resume(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>  	struct pm8001_hba_info *pm8001_ha;
>  	int rc;
> @@ -1247,17 +1242,8 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  	pm8001_printk("pdev=0x%p, slot=%s, resuming from previous "
>  		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
>  
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -	rc = pci_enable_device(pdev);
> -	if (rc) {
> -		pm8001_printk("slot=%s Enable device failed during resume\n",
> -			      pm8001_ha->name);
> -		goto err_out_enable;
> -	}
> +	device_wakeup_disable(dev);
>  
> -	pci_set_master(pdev);
>  	rc = pci_go_44(pdev);
>  	if (rc)
>  		goto err_out_disable;
> @@ -1318,8 +1304,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  
>  err_out_disable:
>  	scsi_remove_host(pm8001_ha->shost);
> -	pci_disable_device(pdev);
> -err_out_enable:
> +
>  	return rc;
>  }
>  
> @@ -1402,13 +1387,16 @@ static struct pci_device_id pm8001_pci_table[] = {
>  	{} /* terminate list */
>  };
>  
> +static SIMPLE_DEV_PM_OPS(pm8001_pci_pm_ops,
> +			 pm8001_pci_suspend,
> +			 pm8001_pci_resume);
> +
>  static struct pci_driver pm8001_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= pm8001_pci_table,
>  	.probe		= pm8001_pci_probe,
>  	.remove		= pm8001_pci_remove,
> -	.suspend	= pm8001_pci_suspend,
> -	.resume		= pm8001_pci_resume,
> +	.driver.pm	= &pm8001_pci_pm_ops,
>  };
>  
>  /**
> -- 
> 2.27.0
> 
.
