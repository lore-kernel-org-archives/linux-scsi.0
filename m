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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B7EC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F30F2137B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oZ179g5D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbgIHRD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732071AbgIHRDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:03:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A66C061573;
        Tue,  8 Sep 2020 10:03:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k15so11450435pfc.12;
        Tue, 08 Sep 2020 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xuJFXsSZhLTn4QTt9AYHjV/t9mROTn+fOq6waSMNYSs=;
        b=oZ179g5DtG+h+chAplPBrXJjuj638S0FCpKhCEGhpvm9VvsWXQPUwYI8HDc1UEmWi6
         a+j/vWhh9LqAWZTjUz/2hFCLZm54OTaNusV/I5bixoPh7ekshrIVMT/Bu+/HRtWu6KQV
         X81IZvECksxQEzu7rN2jEhRFk/b/yV5bkZhAq0MfzLlKM2GB8EFvukwEfbiFoBEONeHa
         unzBJIdc9g/SuIv56GyM9BCmwc5l8hSjJVzWJMzwcY5JPx/MKw9ymT3JNzxYET6VJbH5
         DbCFSsPONl3pp8ucslMne8kOtAS2SaJv8VKckKyYqFXrRjHx87+r6juf0xC6e6A92aOW
         sAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xuJFXsSZhLTn4QTt9AYHjV/t9mROTn+fOq6waSMNYSs=;
        b=lV7MUvUKKrzZMJA4P9B3gp1l5kbwrQ2BdeZmRwyhy3IJ0WBP/pNRo5qg0qozVjsdo/
         8LLpTNPJeVXrwmqQ0Oz1OY3ybE14Yn1SpGbmzpdTwdWcw/zft/Ob+7SmnxUuDj/9nEwg
         /bhxreCQka8f3w0Fso9ZACZdHy1PIDwj1yKwsq02q43/eB5MgMmCBt9QNZN0w/VbFiPW
         ck5W0+HSIw8ulmIq8HuW4h50n2boyJMLC7Tiu15VcCEtdWx+1WKhV7Di2RCN4YBqrwQb
         /VwF3E957OwQtSj7jJ3VT4DXNY+KfpjfBfFxr0ukL/tvAlEa3EmHU7CwRqWrhcKT6ewx
         wRog==
X-Gm-Message-State: AOAM533aNZnBbGkaAf2KNbutONlrD9lQ4+JTN7RYxszWsAyYLvaGtv3O
        lCLpvbyhtbHb3q/j4OHsodA=
X-Google-Smtp-Source: ABdhPJyGcJoQNTrFi39eSyTpTCIiBnDYR1AtM61vOqpau6HB++g0/IWCmYOD3BVolI2a/79HX5yPGQ==
X-Received: by 2002:a05:6a00:1356:b029:13e:d13d:a084 with SMTP id k22-20020a056a001356b029013ed13da084mr64321pfu.27.1599584618337;
        Tue, 08 Sep 2020 10:03:38 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id ie13sm42824pjb.5.2020.09.08.10.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:03:37 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:31:44 +0530
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
Subject: Re: [PATCH v2 06/15] scsi: esas2r: use generic power management
Message-ID: <20200908170058.GG9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-7-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-7-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:19PM +0530, Vaibhav Gupta wrote:
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
>  drivers/scsi/esas2r/esas2r.h      |  5 ++--
>  drivers/scsi/esas2r/esas2r_init.c | 48 +++++++++----------------------
>  drivers/scsi/esas2r/esas2r_main.c |  3 +-
>  3 files changed, 18 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
> index 7f43b95f4e94..6ad3e0871ef0 100644
> --- a/drivers/scsi/esas2r/esas2r.h
> +++ b/drivers/scsi/esas2r/esas2r.h
> @@ -996,8 +996,9 @@ void esas2r_adapter_tasklet(unsigned long context);
>  irqreturn_t esas2r_interrupt(int irq, void *dev_id);
>  irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
>  void esas2r_kickoff_timer(struct esas2r_adapter *a);
> -int esas2r_suspend(struct pci_dev *pcid, pm_message_t state);
> -int esas2r_resume(struct pci_dev *pcid);
> +
> +extern const struct dev_pm_ops esas2r_pm_ops;
> +
>  void esas2r_fw_event_off(struct esas2r_adapter *a);
>  void esas2r_fw_event_on(struct esas2r_adapter *a);
>  bool esas2r_nvram_write(struct esas2r_adapter *a, struct esas2r_request *rq,
> diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
> index eb7d139ffc00..6c5854969791 100644
> --- a/drivers/scsi/esas2r/esas2r_init.c
> +++ b/drivers/scsi/esas2r/esas2r_init.c
> @@ -640,53 +640,31 @@ void esas2r_kill_adapter(int i)
>  	}
>  }
>  
> -int esas2r_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused esas2r_suspend(struct device *dev)
>  {
> -	struct Scsi_Host *host = pci_get_drvdata(pdev);
> -	u32 device_state;
> +	struct Scsi_Host *host = dev_get_drvdata(dev);
>  	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
>  
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "suspending adapter()");
> +	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "suspending adapter()");
>  	if (!a)
>  		return -ENODEV;
>  
>  	esas2r_adapter_power_down(a, 1);
> -	device_state = pci_choose_state(pdev, state);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_save_state() called");
> -	pci_save_state(pdev);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_disable_device() called");
> -	pci_disable_device(pdev);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_set_power_state() called");
> -	pci_set_power_state(pdev, device_state);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "esas2r_suspend(): 0");
> +	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "esas2r_suspend(): 0");
>  	return 0;
>  }
>  
> -int esas2r_resume(struct pci_dev *pdev)
> +static int __maybe_unused esas2r_resume(struct device *dev)
>  {
> -	struct Scsi_Host *host = pci_get_drvdata(pdev);
> +	struct Scsi_Host *host = dev_get_drvdata(dev);
>  	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
> -	int rez;
> +	int rez = 0;
>  
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "resuming adapter()");
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_set_power_state(PCI_D0) "
> +	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "resuming adapter()");
> +	esas2r_log_dev(ESAS2R_LOG_INFO, dev,
> +		       "device_wakeup_disable() "
>  		       "called");
> -	pci_set_power_state(pdev, PCI_D0);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_enable_wake(PCI_D0, 0) "
> -		       "called");
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_restore_state() called");
> -	pci_restore_state(pdev);
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
> -		       "pci_enable_device() called");
> -	rez = pci_enable_device(pdev);
> -	pci_set_master(pdev);
> +	device_wakeup_disable(dev);
>  
>  	if (!a) {
>  		rez = -ENODEV;
> @@ -730,11 +708,13 @@ int esas2r_resume(struct pci_dev *pdev)
>  	}
>  
>  error_exit:
> -	esas2r_log_dev(ESAS2R_LOG_CRIT, &(pdev->dev), "esas2r_resume(): %d",
> +	esas2r_log_dev(ESAS2R_LOG_CRIT, dev, "esas2r_resume(): %d",
>  		       rez);
>  	return rez;
>  }
>  
> +SIMPLE_DEV_PM_OPS(esas2r_pm_ops, esas2r_suspend, esas2r_resume);
> +
>  bool esas2r_set_degraded_mode(struct esas2r_adapter *a, char *error_str)
>  {
>  	set_bit(AF_DEGRADED_MODE, &a->flags);
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 7b49e2e9fcde..aab3ea580e6b 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -346,8 +346,7 @@ static struct pci_driver
>  	.id_table	= esas2r_pci_table,
>  	.probe		= esas2r_probe,
>  	.remove		= esas2r_remove,
> -	.suspend	= esas2r_suspend,
> -	.resume		= esas2r_resume,
> +	.driver.pm	= &esas2r_pm_ops,
>  };
>  
>  static int esas2r_probe(struct pci_dev *pcid,
> -- 
> 2.27.0
> 
.
