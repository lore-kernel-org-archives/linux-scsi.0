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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157F5C2D0A7
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D303F20732
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:10:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tG/YUPF7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbgIHRH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731839AbgIHRHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:07:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D67BC061573;
        Tue,  8 Sep 2020 10:07:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v196so11497248pfc.1;
        Tue, 08 Sep 2020 10:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vkm3URthXwvfCz2X/0Dh5umMnxjwLofZTcBfaZl0Z6Y=;
        b=tG/YUPF7peaPAP9CfK209Pn38yxJyOy8OHKCwmmqVxJ0gETyFt5E47yypeNVZlb0WW
         vzSrLbR71gHvWpEnbgdYI1Xjom5ZjiE6euinp+gISUzKn7g9rhYwU/3Gms63brYZ3oP6
         5djflAAHKKiCLS/xeeT7uFxDOasbEPszX6z74lQeQGxDYN3KXOPjMt4w+3FMTmczQc4v
         cO+KrOQTnkS9y3godo4V8gLjVbu5JdYF0mcK5XxdOc4fwUy9Xo2RTMrGfv6ynzKDzXqm
         nlVz4SXWSn0BFDXJQCrMXlZTnfBnhd143sO2H7sxeondeXhdg0bq1xoatGNL7RRJiiAl
         gd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vkm3URthXwvfCz2X/0Dh5umMnxjwLofZTcBfaZl0Z6Y=;
        b=e8MN429gqJhy2uCZTsSQKjxvlib6XK+ntlhy/O5s4iObYy44QiIdhzPubQMboeQ5wc
         fe1lld8wkyVRUE6KCUkipUpQcRvlTG+tILLlLFBda+BW7jmkzSLgcIHQTUzajQGXYdrY
         ScWJ/d0t3xAn3jA5HlT3weKEDwtFEyc2mL1sBW0Iq06fI8HRzJ/qSdv6CD2COwQONX7z
         m4JgC8s/0C1F/tgULUf1Z2Mm9khxMYGH06bJRXrYaeghZlcd2ZxKo13Xn++YyzdOwLby
         uUk0ZZbCMLCwYp0e9lu7RVEkmV+De8RrJ78ha15xKdy4zEA3V8UUHZZGYiWvt0t3VyWK
         sYZQ==
X-Gm-Message-State: AOAM5333tDHJ1ZD7KJRxRJVMgLvJiG2BggW56dbKPfqeYcE57Ywed67t
        3h3vXUMOGoXQ9N+Ywa7i9o4=
X-Google-Smtp-Source: ABdhPJzjf3ma939UXz/wlJ5BHxhf5CnuqeUC1sRoD1AIWGssRazx9QXjeHH5ONg+i+f1WoTcQBDdAA==
X-Received: by 2002:a17:902:70c8:b029:d0:cbe1:e748 with SMTP id l8-20020a17090270c8b02900d0cbe1e748mr2028914plt.35.1599584872526;
        Tue, 08 Sep 2020 10:07:52 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id q71sm41669pja.9.2020.09.08.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:07:52 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:35:59 +0530
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
Subject: Re: [PATCH v2 12/15] scsi: 3w-9xxx: use generic power management
Message-ID: <20200908170559.GM9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-13-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-13-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:25PM +0530, Vaibhav Gupta wrote:
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
>  drivers/scsi/3w-9xxx.c | 30 ++++++++----------------------
>  1 file changed, 8 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 3337b1e80412..c15dcfda3957 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -2191,10 +2191,10 @@ static void twa_remove(struct pci_dev *pdev)
>  	twa_device_extension_count--;
>  } /* End twa_remove() */
>  
> -#ifdef CONFIG_PM
>  /* This function is called on PCI suspend */
> -static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused twa_suspend(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
>  
> @@ -2214,32 +2214,21 @@ static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
>  	}
>  	TW_CLEAR_ALL_INTERRUPTS(tw_dev);
>  
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -
>  	return 0;
>  } /* End twa_suspend() */
>  
>  /* This function is called on PCI resume */
> -static int twa_resume(struct pci_dev *pdev)
> +static int __maybe_unused twa_resume(struct device *dev)
>  {
>  	int retval = 0;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
>  
>  	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
>  
> -	retval = pci_enable_device(pdev);
> -	if (retval) {
> -		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x39, "Enable device failed during resume");
> -		return retval;
> -	}
> +	device_wakeup_disable(dev);
>  
> -	pci_set_master(pdev);
>  	pci_try_set_mwi(pdev);
>  
>  	retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> @@ -2277,11 +2266,9 @@ static int twa_resume(struct pci_dev *pdev)
>  
>  out_disable_device:
>  	scsi_remove_host(host);
> -	pci_disable_device(pdev);
>  
>  	return retval;
>  } /* End twa_resume() */
> -#endif
>  
>  /* PCI Devices supported by this driver */
>  static struct pci_device_id twa_pci_tbl[] = {
> @@ -2297,16 +2284,15 @@ static struct pci_device_id twa_pci_tbl[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
>  
> +static SIMPLE_DEV_PM_OPS(twa_pm_ops, twa_suspend, twa_resume);
> +
>  /* pci_driver initializer */
>  static struct pci_driver twa_driver = {
>  	.name		= "3w-9xxx",
>  	.id_table	= twa_pci_tbl,
>  	.probe		= twa_probe,
>  	.remove		= twa_remove,
> -#ifdef CONFIG_PM
> -	.suspend	= twa_suspend,
> -	.resume		= twa_resume,
> -#endif
> +	.driver.pm	= &twa_pm_ops,
>  	.shutdown	= twa_shutdown
>  };
>  
> -- 
> 2.27.0
> 
.
