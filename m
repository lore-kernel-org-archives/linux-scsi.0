Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B52C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EB6E20936
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acYgkvgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbgIHRAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbgIHRAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:00:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12AFC061573;
        Tue,  8 Sep 2020 10:00:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t7so32935pjd.3;
        Tue, 08 Sep 2020 10:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iKuzfMMNhC5TJ+c7Fua7oTap7vymNcWtBzASKBpHXMA=;
        b=acYgkvgABuHjEKMgfiqkimbPBka+X6yG3/OejaxPCBtLpcyAcsbqyhwvQqlgjDZOA0
         8EvIyY76gDQcmL5FSdZTxH08ZQQCdkoO/ZPM/5KPHr3sL8UoAUz/fAko3p2UsI2wtPDZ
         xo3WEQ66kj9+ies/7OFNVu6Q/CpoW3KVz9IekekMO/3U6YNDz2yLRJMAC06qLPjFe4Qs
         TnFKKIn4TYbvJTMUAtOOJTHYbQA+w9lb3ARvzD4YtpDkyb/1J8kVHIokOFxMa1JeG8Mt
         mb7yzlkuWQ4ia5lDgklbNZmvq/8y3I5Q07XiOGjiA9XzIaQzj3LpsUBtOFYFySK1FvN4
         NiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKuzfMMNhC5TJ+c7Fua7oTap7vymNcWtBzASKBpHXMA=;
        b=mhiq/4pKYeJsNNqIDR9+lxXtMDLk4ZH6sn+stGajsuxh9RIDYetwYyv6Y9yIsK8/wc
         TU4ZuwKdFOQLetUBRgnWx5CfiostX/DtdfIv4X2yJFP966XESnaJRPHxO37R5AOYPmd1
         9Edn6I3YgGKa31JQUc/txv1jbaaRegjP8cc0NB6qHOsFNZkVjkYv70gu+WCr6s7dGe4e
         tbHTGrpsdvX2h7QMk/mWWZx6Mwn1M7wq/XC2ft+XkmRixbw2jX144eT0SJWusNRdnglq
         g7s4U43gXslG/XotuWHWdWny64o8dgn0PaVomK6HG4kHlnshtuhkUAtPI1YFjrikjqX9
         l2XA==
X-Gm-Message-State: AOAM531nswP5pcZpgtdPzc7GTZyRwMBpf0qjVWAPUVSc4c7iIwirNlQr
        +9wWjr8TzqMbWzAAVuPN89E=
X-Google-Smtp-Source: ABdhPJxDDiTHs3utTJZoGKbwiCgqc0v2PDE0cUAb7ZeCzLBsKSuvjEX8RF0+OmgJJ14cK7JfUAlf+w==
X-Received: by 2002:a17:90a:ed8e:: with SMTP id k14mr73895pjy.178.1599584412423;
        Tue, 08 Sep 2020 10:00:12 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id a10sm18845942pfn.219.2020.09.08.09.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:00:11 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:28:04 +0530
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
Subject: Re: [PATCH v2 02/15] scsi: aacraid: use generic power management
Message-ID: <20200908165804.GC9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-3-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-3-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:15PM +0530, Vaibhav Gupta wrote:
> With legacy PM hooks, it was the responsibility of a driver to manage PCI
> states and also the device's power state. The generic approach is to let
> the PCI core handle the work.
> 
> PCI core passes "struct device*" as an argument to the .suspend() and
> .resume() callbacks.
> 
> Driver was using PCI helper functions like pci_save/restore_state(),
> pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
> They should not be invoked by the driver.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/aacraid/linit.c | 34 ++++++++--------------------------
>  1 file changed, 8 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index a308e86a97f1..1e44868ee953 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1910,11 +1910,9 @@ static int aac_acquire_resources(struct aac_dev *dev)
>  
>  }
>  
> -#if (defined(CONFIG_PM))
> -static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused aac_suspend(struct device *dev)
>  {
> -
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev);
>  	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>  
>  	scsi_host_block(shost);
> @@ -1923,29 +1921,16 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  	aac_release_resources(aac);
>  
> -	pci_set_drvdata(pdev, shost);
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -
>  	return 0;
>  }
>  
> -static int aac_resume(struct pci_dev *pdev)
> +static int __maybe_unused aac_resume(struct device *dev)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev);
>  	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
> -	int r;
>  
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -	r = pci_enable_device(pdev);
> +	device_wakeup_disable(dev);
>  
> -	if (r)
> -		goto fail_device;
> -
> -	pci_set_master(pdev);
>  	if (aac_acquire_resources(aac))
>  		goto fail_device;
>  	/*
> @@ -1960,10 +1945,8 @@ static int aac_resume(struct pci_dev *pdev)
>  fail_device:
>  	printk(KERN_INFO "%s%d: resume failed.\n", aac->name, aac->id);
>  	scsi_host_put(shost);
> -	pci_disable_device(pdev);
>  	return -ENODEV;
>  }
> -#endif
>  
>  static void aac_shutdown(struct pci_dev *dev)
>  {
> @@ -2108,15 +2091,14 @@ static struct pci_error_handlers aac_pci_err_handler = {
>  	.resume			= aac_pci_resume,
>  };
>  
> +static SIMPLE_DEV_PM_OPS(aac_pm_ops, aac_suspend, aac_resume);
> +
>  static struct pci_driver aac_pci_driver = {
>  	.name		= AAC_DRIVERNAME,
>  	.id_table	= aac_pci_tbl,
>  	.probe		= aac_probe_one,
>  	.remove		= aac_remove_one,
> -#if (defined(CONFIG_PM))
> -	.suspend	= aac_suspend,
> -	.resume		= aac_resume,
> -#endif
> +	.driver.pm	= &aac_pm_ops,
>  	.shutdown	= aac_shutdown,
>  	.err_handler    = &aac_pci_err_handler,
>  };
> -- 
> 2.27.0
> 
.
