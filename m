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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F9C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D3F0216C4
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8/RMlU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbgIHRBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731863AbgIHRBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:01:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C49C061573;
        Tue,  8 Sep 2020 10:01:11 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t14so5010361pgl.10;
        Tue, 08 Sep 2020 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRpbVHynvDS3doIRIHFjhHnaCPKlqwHCLe8ogVJxt1I=;
        b=U8/RMlU9cXz4Z3yJRxldmj8yP2siKjJpVPL/+UGXPlxXRR1OlP/gUPShsct1VxO7lR
         kPozkb5zZO2bsBdcZ7dqsjuLIg9f62auvTXIXNXbZUqRg3MVk9olmUv42FKkTH/P4Rvb
         H7tLgtjsAQP4BplddXaTi27iOc+Ybg+eUYoE2jbHnPItljGHLFdY5sObv1M1ZFUx1rsG
         Z+ZC02jLo73QBVin0oMRk0bh/JEwVSqmyfpot0F68HollnY65/mxbEd46WAKCGsTW7MO
         gMxuHoMsZmfemb/ncdkGbKzGuBWMqoxzuKJbnXNLHBQG0udYG6YHoZTfNJJebO7Ucy6r
         +95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRpbVHynvDS3doIRIHFjhHnaCPKlqwHCLe8ogVJxt1I=;
        b=F03b7HrNKFCZmqVhd24emdHN5xp7HUfmZDZWHovpQvhHMIbZo6BEbbpm81TUx374Mq
         z49EmknNchCtN14EYaUIAEmUOlz46CLb88DrmD6OcwBL98ciKnL3cfrv0wJ8G3WsF3cr
         8jyQNBYbP3PclCAiPetXkOxyPs+qiGDQx9lysh6eBVdSXp8OMJDxKM5aY9rlXDE+zKwf
         +A2lem71ISwl06NDnflyK1USVRSqga4zj/fydVOOzTB3+SjHybRLVSUbJ6kMofTSBH84
         jq9ONHidv1yhMe53YSlyQW4pmU9Sbj+PXFbopJFawwWOdHUGCbOdJZusv5RiRCjAyhuz
         56jA==
X-Gm-Message-State: AOAM532hrtzw+uZrKXV7U4y0TzX4CTqx2UcV0FHmxTtSV91OEgxwLd5n
        ysGnFF9VoGGNBQHJevprto0=
X-Google-Smtp-Source: ABdhPJzLeGaww7r+x1jkJD0JD95WM/W8uIQPEPhZGVVwielyvToQVAuva3KA8dSfITN7K89YL7D7dQ==
X-Received: by 2002:a63:fd0b:: with SMTP id d11mr21093871pgh.21.1599584470769;
        Tue, 08 Sep 2020 10:01:10 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id j26sm10655251pfa.160.2020.09.08.10.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:01:10 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:29:12 +0530
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
Subject: Re: [PATCH v2 03/15] scsi: aic7xxx: use generic power management
Message-ID: <20200908165858.GD9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-4-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-4-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:16PM +0530, Vaibhav Gupta wrote:
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
> Also, .suspend() and .resume() are invoking other functions for PM, which
> were againg bounded by "#ifdef CONFIG_PM" directive. Remove the directive
> and mark those functions as "__maybe_unused".
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/aic7xxx/aic7xxx.h         | 10 ++----
>  drivers/scsi/aic7xxx/aic7xxx_core.c    |  6 ++--
>  drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 46 ++++++--------------------
>  drivers/scsi/aic7xxx/aic7xxx_pci.c     |  4 +--
>  4 files changed, 17 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
> index 88b90f9806c9..11a09798e6b5 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx.h
> +++ b/drivers/scsi/aic7xxx/aic7xxx.h
> @@ -1134,9 +1134,7 @@ const struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
>  int			 ahc_pci_config(struct ahc_softc *,
>  					const struct ahc_pci_identity *);
>  int			 ahc_pci_test_register_access(struct ahc_softc *);
> -#ifdef CONFIG_PM
> -void			 ahc_pci_resume(struct ahc_softc *ahc);
> -#endif
> +void __maybe_unused	 ahc_pci_resume(struct ahc_softc *ahc);
>  
>  /*************************** EISA/VL Front End ********************************/
>  struct aic7770_identity *aic7770_find_device(uint32_t);
> @@ -1160,10 +1158,8 @@ int			 ahc_chip_init(struct ahc_softc *ahc);
>  int			 ahc_init(struct ahc_softc *ahc);
>  void			 ahc_intr_enable(struct ahc_softc *ahc, int enable);
>  void			 ahc_pause_and_flushwork(struct ahc_softc *ahc);
> -#ifdef CONFIG_PM
> -int			 ahc_suspend(struct ahc_softc *ahc); 
> -int			 ahc_resume(struct ahc_softc *ahc);
> -#endif
> +int __maybe_unused	 ahc_suspend(struct ahc_softc *ahc);
> +int __maybe_unused	 ahc_resume(struct ahc_softc *ahc);
>  void			 ahc_set_unit(struct ahc_softc *, int);
>  void			 ahc_set_name(struct ahc_softc *, char *);
>  void			 ahc_free(struct ahc_softc *ahc);
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index 3d4df906fa4f..c7eb238a9599 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -5590,8 +5590,7 @@ ahc_pause_and_flushwork(struct ahc_softc *ahc)
>  	ahc->flags &= ~AHC_ALL_INTERRUPTS;
>  }
>  
> -#ifdef CONFIG_PM
> -int
> +int __maybe_unused
>  ahc_suspend(struct ahc_softc *ahc)
>  {
>  
> @@ -5617,7 +5616,7 @@ ahc_suspend(struct ahc_softc *ahc)
>  	return (0);
>  }
>  
> -int
> +int __maybe_unused
>  ahc_resume(struct ahc_softc *ahc)
>  {
>  
> @@ -5626,7 +5625,6 @@ ahc_resume(struct ahc_softc *ahc)
>  	ahc_restart(ahc);
>  	return (0);
>  }
> -#endif
>  /************************** Busy Target Table *********************************/
>  /*
>   * Return the untagged transaction id for a given target/channel lun.
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> index 9b293b1f0b71..a07e94fac673 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> @@ -121,47 +121,23 @@ static const struct pci_device_id ahc_linux_pci_id_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
>  
> -#ifdef CONFIG_PM
> -static int
> -ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
> +static int __maybe_unused
> +ahc_linux_pci_dev_suspend(struct device *dev)
>  {
> -	struct ahc_softc *ahc = pci_get_drvdata(pdev);
> -	int rc;
> -
> -	if ((rc = ahc_suspend(ahc)))
> -		return rc;
> +	struct ahc_softc *ahc = dev_get_drvdata(dev);
>  
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -
> -	if (mesg.event & PM_EVENT_SLEEP)
> -		pci_set_power_state(pdev, PCI_D3hot);
> -
> -	return rc;
> +	return ahc_suspend(ahc);
>  }
>  
> -static int
> -ahc_linux_pci_dev_resume(struct pci_dev *pdev)
> +static int __maybe_unused
> +ahc_linux_pci_dev_resume(struct device *dev)
>  {
> -	struct ahc_softc *ahc = pci_get_drvdata(pdev);
> -	int rc;
> -
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> -
> -	if ((rc = pci_enable_device(pdev))) {
> -		dev_printk(KERN_ERR, &pdev->dev,
> -			   "failed to enable device after resume (%d)\n", rc);
> -		return rc;
> -	}
> -
> -	pci_set_master(pdev);
> +	struct ahc_softc *ahc = dev_get_drvdata(dev);
>  
>  	ahc_pci_resume(ahc);
>  
>  	return (ahc_resume(ahc));
>  }
> -#endif
>  
>  static void
>  ahc_linux_pci_dev_remove(struct pci_dev *pdev)
> @@ -319,14 +295,14 @@ ahc_pci_write_config(ahc_dev_softc_t pci, int reg, uint32_t value, int width)
>  	}
>  }
>  
> +static SIMPLE_DEV_PM_OPS(ahc_linux_pci_dev_pm_ops,
> +			 ahc_linux_pci_dev_suspend,
> +			 ahc_linux_pci_dev_resume);
>  
>  static struct pci_driver aic7xxx_pci_driver = {
>  	.name		= "aic7xxx",
>  	.probe		= ahc_linux_pci_dev_probe,
> -#ifdef CONFIG_PM
> -	.suspend	= ahc_linux_pci_dev_suspend,
> -	.resume		= ahc_linux_pci_dev_resume,
> -#endif
> +	.driver.pm	= &ahc_linux_pci_dev_pm_ops,
>  	.remove		= ahc_linux_pci_dev_remove,
>  	.id_table	= ahc_linux_pci_id_table
>  };
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> index 656f680c7802..dab3a6d12c4d 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> @@ -2008,8 +2008,7 @@ ahc_pci_chip_init(struct ahc_softc *ahc)
>  	return (ahc_chip_init(ahc));
>  }
>  
> -#ifdef CONFIG_PM
> -void
> +void __maybe_unused
>  ahc_pci_resume(struct ahc_softc *ahc)
>  {
>  	/*
> @@ -2040,7 +2039,6 @@ ahc_pci_resume(struct ahc_softc *ahc)
>  		ahc_release_seeprom(&sd);
>  	}
>  }
> -#endif
>  
>  static int
>  ahc_aic785X_setup(struct ahc_softc *ahc)
> -- 
> 2.27.0
> 
.
