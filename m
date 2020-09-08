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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00358C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B200A2087C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyS6OBFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgIHRKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731354AbgIHRKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:10:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEEFC061573;
        Tue,  8 Sep 2020 10:10:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b17so52419pji.1;
        Tue, 08 Sep 2020 10:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJ84Dco6eLoIv+QhaZ1+EKy5WcV+FPbruhEJbqApu5k=;
        b=NyS6OBFC5QJRqQC59Ilw2MrC0TVowdh91k+YvAcGb0TVyRKHAjoPUaY0KKQIGKc9lS
         QBW4s/5u4gKcMOnKrAx11MTo+CtcvPsaBVRTevRZZc/Coh9/iUIaGuCce5ElF4XSA4rD
         Sm0Umjyk/Nu/gEBCythZlr0LRjrisaoKeULzuI1qH9iSrlUnSeyNvV5IOYbz3Dtu37px
         G5UrEGN4tAWR3a/llp/eq5GE7FqwdAqF6MTWVIN5Y0JI7pH5pZm8hg8y0f9QdsUzl7xm
         RrZZs04Jl9J35y7g6LO09Oeq5UL02+WY7sWoGbwLJwLnKLyXDZvkMgHU87eWEFsSQAmy
         VDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJ84Dco6eLoIv+QhaZ1+EKy5WcV+FPbruhEJbqApu5k=;
        b=Sy5QYZKHdYQ5iQBtFr5mDUV3B65C0YJYcsnOCWdpa2kgxJoay40UjV2UAZQkLCwlJz
         B9qiez4Yt+hVLfdb9LI2qm8COJ4M2bv2TruZM/2/c8OHdkacSBZwk7anbonE2/1jruqX
         ffZsqowh3UNLUnbVwErt6dzPn3A1fUngmgFXI6v4dnjWpCZaFXij6fSvTpqR5Q0pZjdp
         0JWHkmQxFGYiupO75SJFIo6EROaZmJI4pTzrqaulKYyIw+BXmZTTn/qWR6fCjwAEnVVZ
         G6hdIAqhkrVZzJ8lV/r7m2YN0Qjaei4XYmPe1YRLrA8bYIJpbYJH4bqLIDPhbkpp2mpI
         ewhA==
X-Gm-Message-State: AOAM532noY7MpILI0mikUEiogxMW+viXi+08Xz0zWKJQA1safGJSN6aL
        Xkzpa5Wqza3wsObwhGIg8uc=
X-Google-Smtp-Source: ABdhPJz+LupikwcXi8+L56pMv9pV+9q6l24UCCc9Ms4+oqhlRGluDntBU1vjkieR70cpz6FydIqR3w==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr73628pjb.221.1599585012676;
        Tue, 08 Sep 2020 10:10:12 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id x140sm552pfc.211.2020.09.08.10.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:10:12 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:38:16 +0530
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
Subject: Re: [PATCH v2 15/15] scsi: pmcraid: use generic power management
Message-ID: <20200908170816.GP9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-16-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-16-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:28PM +0530, Vaibhav Gupta wrote:
> Drivers using legacy PM have to manage PCI states and device's PM states
> themselves. They also need to take care of configuration registers.
> 
> With improved and powerful support of generic PM, PCI Core takes care of
> above mentioned, device-independent, jobs.
> 
> This driver makes use of PCI helper functions like
> pci_save/restore_state(), pci_enable/disable_device(),
> pci_set_power_state() and to do required operations. In generic mode, they
> are no longer needed.
> 
> Change function parameter in both .suspend() and .resume() to
> "struct device*" type. Use to_pci_dev() to get "struct pci_dev*" variable.
> 
> In function pmcraid_resume(), earlier, the variable "rc" was set by
> pci_enable_device() which is now removed. Since PCI core does the required
> job, initialize "rc" with 0 value when declaring it.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/pmcraid.c | 44 +++++++++++-------------------------------
>  1 file changed, 11 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index aa9ae2ae8579..b6b70ac2e2ee 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -5237,54 +5237,39 @@ static void pmcraid_remove(struct pci_dev *pdev)
>  	return;
>  }
>  
> -#ifdef CONFIG_PM
>  /**
>   * pmcraid_suspend - driver suspend entry point for power management
> - * @pdev:   PCI device structure
> - * @state:  PCI power state to suspend routine
> + * @dev:   Device structure
>   *
>   * Return Value - 0 always
>   */
> -static int pmcraid_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused pmcraid_suspend(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
>  
>  	pmcraid_shutdown(pdev);
>  	pmcraid_disable_interrupts(pinstance, ~0);
>  	pmcraid_kill_tasklets(pinstance);
> -	pci_set_drvdata(pinstance->pdev, pinstance);
>  	pmcraid_unregister_interrupt_handler(pinstance);
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
>  
>  	return 0;
>  }
>  
>  /**
>   * pmcraid_resume - driver resume entry point PCI power management
> - * @pdev: PCI device structure
> + * @dev: Device structure
>   *
>   * Return Value - 0 in case of success. Error code in case of any failure
>   */
> -static int pmcraid_resume(struct pci_dev *pdev)
> +static int __maybe_unused pmcraid_resume(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
>  	struct Scsi_Host *host = pinstance->host;
> -	int rc;
> -
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -
> -	rc = pci_enable_device(pdev);
> -
> -	if (rc) {
> -		dev_err(&pdev->dev, "resume: Enable device failed\n");
> -		return rc;
> -	}
> +	int rc = 0;
>  
> -	pci_set_master(pdev);
> +	device_wakeup_disable(dev);
>  
>  	if (sizeof(dma_addr_t) == 4 ||
>  	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
> @@ -5337,18 +5322,10 @@ static int pmcraid_resume(struct pci_dev *pdev)
>  	scsi_host_put(host);
>  
>  disable_device:
> -	pci_disable_device(pdev);
>  
>  	return rc;
>  }
>  
> -#else
> -
> -#define pmcraid_suspend NULL
> -#define pmcraid_resume  NULL
> -
> -#endif /* CONFIG_PM */
> -
>  /**
>   * pmcraid_complete_ioa_reset - Called by either timer or tasklet during
>   *				completion of the ioa reset
> @@ -5836,6 +5813,8 @@ static int pmcraid_probe(struct pci_dev *pdev,
>  	return -ENODEV;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(pmcraid_pm_ops, pmcraid_suspend, pmcraid_resume);
> +
>  /*
>   * PCI driver structure of pmcraid driver
>   */
> @@ -5844,8 +5823,7 @@ static struct pci_driver pmcraid_driver = {
>  	.id_table = pmcraid_pci_table,
>  	.probe = pmcraid_probe,
>  	.remove = pmcraid_remove,
> -	.suspend = pmcraid_suspend,
> -	.resume = pmcraid_resume,
> +	.driver.pm = &pmcraid_pm_ops,
>  	.shutdown = pmcraid_shutdown
>  };
>  
> -- 
> 2.27.0
> 
.
