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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A12DC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 16:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E064F208FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 16:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jx+X8veF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732022AbgIHQ7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731856AbgIHQ7C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 12:59:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13823C061755;
        Tue,  8 Sep 2020 09:59:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so38657pjb.0;
        Tue, 08 Sep 2020 09:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OsDHF9l8KLweJEV4F/UUUN9AsWj6Q1K3HzbgaaqAR+c=;
        b=Jx+X8veFdJOPa0X0J9oKcogx9QwoQksOBY8M2bOMrLsgJCHlinQ/6KLsmsI0BCpcdb
         6zYDjx7hgf5J/7JWlK75dlCWqSULL6JwIAa9Mh0vsu8EaQj+D9Cy6WwXpeW9YuHhj82u
         lvhRFQP+QacUHjn5tHoRSmX4ohlwS5d7tfGfqXrQzw9G3863ccMTWfD7KG72g6YD6nNw
         fN2u4N8aZCQgNss+QauNu0Ko4KYHHd9sldTEuMtsHejcL6bDTooF+X3dqAHMCmW4HxDl
         WIRcdrVrA3unnQ+ysCT5WJOskUfT0Dpxp0Z1skyncyJV3tG0Vi04mv+unGzoJK3b56vj
         yGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OsDHF9l8KLweJEV4F/UUUN9AsWj6Q1K3HzbgaaqAR+c=;
        b=OvjYVIj10+Kp2vUIbybS2QzEnk402ctV8IpHZlxUoahoeP4uEfZPeA9BEjbtp9yP5C
         /yYULUnqyape6vw/Jc7bydAdI+PH6wmYgReFlimWk3xkWgYOs1G0GD3+lwwxegjoSHHH
         +rpo7FxyBrkaRwBWQWa98LGGggM6gonerSWI2gQp86SEVEaC+yxONwOjgH/tGjC/5qkI
         +/BUHPMTmx1E6YP3i0xoXDn9/vySh+29/T2mp6JzabqTXkBl2pTKAtsJA9+VnfdZ1qdk
         QaRDriwUfejiMNEhURAJ5+xHtL9CJrxtqSP7q86HIg5mteSffsofBQ5YlVyf8WcbUOiv
         sU9Q==
X-Gm-Message-State: AOAM5339uak10CpZ+FZitx9zK7BQ4cDHgPtzDUHgV+yrEyqwO1FGDiOq
        2YwkPkfsApD7yx6YlNHReeU=
X-Google-Smtp-Source: ABdhPJw73yuN92T7L31s/Mu5c6yngdnp2uuE+tJOLHPn8pMUo7b77Is0I+rofpf1nrbe69tjZ1uaGg==
X-Received: by 2002:a17:90a:6848:: with SMTP id e8mr32374pjm.221.1599584341427;
        Tue, 08 Sep 2020 09:59:01 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id a20sm3393pfa.59.2020.09.08.09.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 09:59:00 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:27:02 +0530
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
Subject: Re: [PATCH v2 01/15] scsi: megaraid_sas: use generic power management
Message-ID: <20200908165702.GB9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-2-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-2-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:14PM +0530, Vaibhav Gupta wrote:
> With legacy PM hooks, it was the responsibility of a driver to manage PCI
> states and also the device's power state. The generic approach is to let
> the PCI core handle the work.
> 
> PCI core passes "struct device*" as an argument to the .suspend() and
> .resume() callbacks. As the .suspend() work with "struct instance*",
> extract it from "struct device*" using dev_get_drv_data().
> 
> Driver was also using PCI helper functions like pci_save/restore_state(),
> pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
> They should not be invoked by the driver.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 61 ++++++-----------------
>  1 file changed, 16 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 00668335c2af..4a6ee7778977 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7539,25 +7539,21 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
>  	megasas_return_cmd(instance, cmd);
>  }
>  
> -#ifdef CONFIG_PM
>  /**
>   * megasas_suspend -	driver suspend entry point
> - * @pdev:		PCI device structure
> - * @state:		PCI power state to suspend routine
> + * @dev:		Device structure
>   */
> -static int
> -megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused
> +megasas_suspend(struct device *dev)
>  {
> -	struct megasas_instance *instance;
> -
> -	instance = pci_get_drvdata(pdev);
> +	struct megasas_instance *instance = dev_get_drvdata(dev);
>  
>  	if (!instance)
>  		return 0;
>  
>  	instance->unload = 1;
>  
> -	dev_info(&pdev->dev, "%s is called\n", __func__);
> +	dev_info(dev, "%s is called\n", __func__);
>  
>  	/* Shutdown SR-IOV heartbeat timer */
>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
> @@ -7579,7 +7575,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  	tasklet_kill(&instance->isr_tasklet);
>  
> -	pci_set_drvdata(instance->pdev, instance);
> +	dev_set_drvdata(dev, instance);
>  	instance->instancet->disable_intr(instance);
>  
>  	megasas_destroy_irqs(instance);
> @@ -7587,48 +7583,28 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
>  	if (instance->msix_vectors)
>  		pci_free_irq_vectors(instance->pdev);
>  
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -
>  	return 0;
>  }
>  
>  /**
>   * megasas_resume-      driver resume entry point
> - * @pdev:               PCI device structure
> + * @dev:              Device structure
>   */
> -static int
> -megasas_resume(struct pci_dev *pdev)
> +static int __maybe_unused
> +megasas_resume(struct device *dev)
>  {
>  	int rval;
>  	struct Scsi_Host *host;
> -	struct megasas_instance *instance;
> +	struct megasas_instance *instance = dev_get_drvdata(dev);
>  	u32 status_reg;
>  
> -	instance = pci_get_drvdata(pdev);
> -
>  	if (!instance)
>  		return 0;
>  
>  	host = instance->host;
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> +	device_wakeup_disable(dev);
>  
> -	dev_info(&pdev->dev, "%s is called\n", __func__);
> -	/*
> -	 * PCI prepping: enable device set bus mastering and dma mask
> -	 */
> -	rval = pci_enable_device_mem(pdev);
> -
> -	if (rval) {
> -		dev_err(&pdev->dev, "Enable device failed\n");
> -		return rval;
> -	}
> -
> -	pci_set_master(pdev);
> +	dev_info(dev, "%s is called\n", __func__);
>  
>  	/*
>  	 * We expect the FW state to be READY
> @@ -7754,14 +7730,8 @@ megasas_resume(struct pci_dev *pdev)
>  fail_set_dma_mask:
>  fail_ready_state:
>  
> -	pci_disable_device(pdev);
> -
>  	return -ENODEV;
>  }
> -#else
> -#define megasas_suspend	NULL
> -#define megasas_resume	NULL
> -#endif
>  
>  static inline int
>  megasas_wait_for_adapter_operational(struct megasas_instance *instance)
> @@ -7931,7 +7901,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
>  
>  /**
>   * megasas_shutdown -	Shutdown entry point
> - * @device:		Generic device structure
> + * @pdev:		PCI device structure
>   */
>  static void megasas_shutdown(struct pci_dev *pdev)
>  {
> @@ -8508,6 +8478,8 @@ static const struct file_operations megasas_mgmt_fops = {
>  	.llseek = noop_llseek,
>  };
>  
> +static SIMPLE_DEV_PM_OPS(megasas_pm_ops, megasas_suspend, megasas_resume);
> +
>  /*
>   * PCI hotplug support registration structure
>   */
> @@ -8517,8 +8489,7 @@ static struct pci_driver megasas_pci_driver = {
>  	.id_table = megasas_pci_table,
>  	.probe = megasas_probe_one,
>  	.remove = megasas_detach_one,
> -	.suspend = megasas_suspend,
> -	.resume = megasas_resume,
> +	.driver.pm = &megasas_pm_ops,
>  	.shutdown = megasas_shutdown,
>  };
>  
> -- 
> 2.27.0
> 
.
