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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3609BC2D0E0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC93521741
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJXs4g3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgIHRCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731797AbgIHRC0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:02:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9AC061573;
        Tue,  8 Sep 2020 10:02:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so11459350pfa.10;
        Tue, 08 Sep 2020 10:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BZmIEpkXHMccerUzS/eWsNfrpJDT5KMzQFld7Ac4EeA=;
        b=nJXs4g3zSYUyvbXvl+pQ9haosLehljosUOdGlxDg+0iVCK5373vpNdkV5f3x9Ujcgx
         iqKQ4AtcAbDvbHx/ATkInbh4Sz7A0dsS105sB24SH49B08HDSo1GNjR6G1TwnAlA5Jo9
         GHsjnDWlnLftb031A/iglbploRQAkr3c8n/4PNqDn4si1d7mvD7dxt9cTnS1Pv6aGq4f
         7XVliTOLTb8zst5rkCTzbOpd2Xzgw+zs4hpOsF1lNKC34z3YbXyPxUgXVEiPu9YY4WAq
         8E/U3ydO45Kw6h61WNCGu0E04M/QcgZpM+kM7rWtaEfKISwmuJ1P3BNicj4pWr0LllGW
         V7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BZmIEpkXHMccerUzS/eWsNfrpJDT5KMzQFld7Ac4EeA=;
        b=nIOk1sOHkYXkFyoz3d8f0Y576dDTrv8YbeJm7G6LJUB6nTxVZAzytAQ6OyVVUOfr/d
         UbiYXyFcMT1YsiScHsPmNKykKdp4z0xQhxEY2kfbZ55xmdNI/IIGFMYoKDfYPSMXcCH/
         SC8UlAunWdDThpnvnSvoXN32sudWbg3Qi95UqgbceNj+zTulyngsrGyVLnlYVEgG8mbT
         DeD6RcxG16ghzBwtRlYogDII147nmTQ75ETiJHzerflwgfHiHHucCypen1mJmtAFjHZL
         KDfUvrYZFQYjTuYk+kwINsvlZcZri3De2TO2JMu3roVz9v2TDGEcdZLC3DqELWXfSzFo
         HOVw==
X-Gm-Message-State: AOAM533+FHpZzMfGjsGUxZqU/05Bu1CusExM42wsz9V9z0yKhE/yuGGU
        +Y1EV0GMA2eJHR8IBQQM1f4=
X-Google-Smtp-Source: ABdhPJysf6/+o9H2e3hKfxDDDNnovTxk3xmwwMf//CV2vPdtw+RF8nXiW+RMWW8MrHLhZ6kAJ2iN+A==
X-Received: by 2002:aa7:8aca:0:b029:13e:d13d:a07d with SMTP id b10-20020aa78aca0000b029013ed13da07dmr99143pfd.20.1599584545076;
        Tue, 08 Sep 2020 10:02:25 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id f3sm15403716pgf.32.2020.09.08.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:02:24 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:30:27 +0530
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
Subject: Re: [PATCH v2 05/15] scsi: arcmsr: use generic power management
Message-ID: <20200908170027.GF9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-6-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-6-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:18PM +0530, Vaibhav Gupta wrote:
> With legacy PM hooks, it was the responsibility of a driver to manage PCI
> states and also the device's power state. The generic approach is to let
> the PCI core handle the work.
> 
> PCI core passes "struct device*" as an argument to the .suspend() and
> .resume() callbacks.
> 
> Driver was also using PCI helper functions like pci_save/restore_state(),
> pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
> They should not be invoked by the driver.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c | 35 ++++++++++++--------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 30914c8f29cc..7e098ddcc4f5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -113,8 +113,8 @@ static int arcmsr_bios_param(struct scsi_device *sdev,
>  static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
>  static int arcmsr_probe(struct pci_dev *pdev,
>  				const struct pci_device_id *id);
> -static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
> -static int arcmsr_resume(struct pci_dev *pdev);
> +static int __maybe_unused arcmsr_suspend(struct device *dev);
> +static int __maybe_unused arcmsr_resume(struct device *dev);
>  static void arcmsr_remove(struct pci_dev *pdev);
>  static void arcmsr_shutdown(struct pci_dev *pdev);
>  static void arcmsr_iop_init(struct AdapterControlBlock *acb);
> @@ -213,13 +213,14 @@ static struct pci_device_id arcmsr_device_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
>  
> +static SIMPLE_DEV_PM_OPS(arcmsr_pm_ops, arcmsr_suspend, arcmsr_resume);
> +
>  static struct pci_driver arcmsr_pci_driver = {
>  	.name			= "arcmsr",
>  	.id_table		= arcmsr_device_id_table,
>  	.probe			= arcmsr_probe,
>  	.remove			= arcmsr_remove,
> -	.suspend		= arcmsr_suspend,
> -	.resume			= arcmsr_resume,
> +	.driver.pm		= &arcmsr_pm_ops,
>  	.shutdown		= arcmsr_shutdown,
>  };
>  /*
> @@ -1065,14 +1066,14 @@ static void arcmsr_free_irq(struct pci_dev *pdev,
>  	pci_free_irq_vectors(pdev);
>  }
>  
> -static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused arcmsr_suspend(struct device *dev)
>  {
> -	uint32_t intmask_org;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *)host->hostdata;
>  
> -	intmask_org = arcmsr_disable_outbound_ints(acb);
> +	arcmsr_disable_outbound_ints(acb);
>  	arcmsr_free_irq(pdev, acb);
>  	del_timer_sync(&acb->eternal_timer);
>  	if (set_date_time)
> @@ -1080,29 +1081,21 @@ static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
>  	flush_work(&acb->arcmsr_do_message_isr_bh);
>  	arcmsr_stop_adapter_bgrb(acb);
>  	arcmsr_flush_adapter_cache(acb);
> -	pci_set_drvdata(pdev, host);
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
>  	return 0;
>  }
>  
> -static int arcmsr_resume(struct pci_dev *pdev)
> +static int __maybe_unused arcmsr_resume(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *)host->hostdata;
>  
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -	if (pci_enable_device(pdev)) {
> -		pr_warn("%s: pci_enable_device error\n", __func__);
> -		return -ENODEV;
> -	}
> +	device_wakeup_disable(dev);
> +
>  	if (arcmsr_set_dma_mask(acb))
>  		goto controller_unregister;
> -	pci_set_master(pdev);
> +
>  	if (arcmsr_request_irq(pdev, acb) == FAILED)
>  		goto controller_stop;
>  	switch (acb->adapter_type) {
> @@ -1137,9 +1130,7 @@ static int arcmsr_resume(struct pci_dev *pdev)
>  	scsi_remove_host(host);
>  	arcmsr_free_ccb_pool(acb);
>  	arcmsr_unmap_pciregion(acb);
> -	pci_release_regions(pdev);
>  	scsi_host_put(host);
> -	pci_disable_device(pdev);
>  	return -ENODEV;
>  }
>  
> -- 
> 2.27.0
> 
.
