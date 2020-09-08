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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A14C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D922098B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oo63FLR/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgIHREg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731859AbgIHRES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:04:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5423C061573;
        Tue,  8 Sep 2020 10:04:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b16so47176pjp.0;
        Tue, 08 Sep 2020 10:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z5QdpVcmIOCKIvjQyJ2FDGf+30SJdqdaAWTB4XO5kus=;
        b=Oo63FLR//+v/71O0Qc0R0LvWXd7hHS0z0G4yNbov4ZQ2LDQcZzYZSNwtx++ONgepje
         Qd2fbmkyVCxLolyJ8qXVO32/P9GgM82uWujp5uExG7vZ4UJKXbWoGuOHHIkQ9zgOkVXM
         s1Pp1xBsFdcrEF3np0vSZTSXkB4EiPvUI9J7h+AsLhYewsh/wAeJQFt8e1VjW+TMSaoy
         W6ExGd8sMvgSsHDS1+IIcueeywOLjfUrclr2CgKRnFsUedh5xqNe66lwUUFLa3I4eTNg
         f3ITdHxjDmB26IfkdWTtZu0mcaVKDOLzlMcjrplTxDISxLKpVj+BMD8vBFVtSUKDbVXH
         LYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z5QdpVcmIOCKIvjQyJ2FDGf+30SJdqdaAWTB4XO5kus=;
        b=DIOzzILgy8I0Bfu1zG0aAfbI31bfFL2DYLvbHB0H+FF5IG4FFiP0jt6bNsOpAaHqfK
         c42dH6P1/k4w7sKoKL0NzG44/dFeCNNjFUeDd7L6dv0dI2Hy0DZu3UNwYQqaxxHFAFKI
         2mmCUNr06577D44GsnfxS9bWqWr1hCtPEfP9kSPIZIYrEeutqUiQF1TbAekrErIQoYcK
         SNKRBQSQItaYoINUbS0/QC3u0aysjTkOCgsMDKjiFsle76Rpu4191OVAsSYP/r/kY7wc
         RvGCMGFtfoVmxHVzGnE6lCEruAgVGXuFJhB1lSNT5KKpM321iRU5Za50qDDB/mOjSn7c
         5giA==
X-Gm-Message-State: AOAM531n2jowCiIsnxb/EUuqsIYijQXcQO9ZZxBA3uZkbuTL6u4N3SGG
        PyicP7+cLJBJJsnLmcTjMjQ=
X-Google-Smtp-Source: ABdhPJz0e8P/21+6stvBWY+17vhC6Q8qKEq+3oDWZ4WokU+qfQgx82L4fEFGq5UaxujYEo5Z1tQzew==
X-Received: by 2002:a17:90a:29a3:: with SMTP id h32mr65787pjd.135.1599584657379;
        Tue, 08 Sep 2020 10:04:17 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id f5sm7958809pfj.212.2020.09.08.10.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:04:16 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:32:23 +0530
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
Subject: Re: [PATCH v2 07/15] scsi: hisi_sas_v3_hw: use generic power
 management
Message-ID: <20200908170223.GH9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-8-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-8-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:20PM +0530, Vaibhav Gupta wrote:
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
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 32 +++++++++-----------------
>  1 file changed, 11 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 55e2321a65bc..824bfbe1abbb 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3374,13 +3374,13 @@ enum {
>  	hip08,
>  };
>  
> -static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused hisi_sas_v3_suspend(struct device *dev_d)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev_d);
>  	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>  	struct hisi_hba *hisi_hba = sha->lldd_ha;
>  	struct device *dev = hisi_hba->dev;
>  	struct Scsi_Host *shost = hisi_hba->shost;
> -	pci_power_t device_state;
>  	int rc;
>  
>  	if (!pdev->pm_cap) {
> @@ -3406,12 +3406,7 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  	hisi_sas_init_mem(hisi_hba);
>  
> -	device_state = pci_choose_state(pdev, state);
> -	dev_warn(dev, "entering operating state [D%d]\n",
> -			device_state);
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, device_state);
> +	dev_warn(dev, "entering suspend state\n");
>  
>  	hisi_sas_release_tasks(hisi_hba);
>  
> @@ -3419,8 +3414,9 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
>  	return 0;
>  }
>  
> -static int hisi_sas_v3_resume(struct pci_dev *pdev)
> +static int __maybe_unused hisi_sas_v3_resume(struct device *dev_d)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev_d);
>  	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>  	struct hisi_hba *hisi_hba = sha->lldd_ha;
>  	struct Scsi_Host *shost = hisi_hba->shost;
> @@ -3430,16 +3426,8 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
>  
>  	dev_warn(dev, "resuming from operating state [D%d]\n",
>  		 device_state);
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
> -	rc = pci_enable_device(pdev);
> -	if (rc) {
> -		dev_err(dev, "enable device failed during resume (%d)\n", rc);
> -		return rc;
> -	}
> +	device_wakeup_disable(dev_d);
>  
> -	pci_set_master(pdev);
>  	scsi_unblock_requests(shost);
>  	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
>  
> @@ -3447,7 +3435,6 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
>  	rc = hw_init_v3_hw(hisi_hba);
>  	if (rc) {
>  		scsi_remove_host(shost);
> -		pci_disable_device(pdev);
>  		return rc;
>  	}
>  	hisi_hba->hw->phys_init(hisi_hba);
> @@ -3468,13 +3455,16 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
>  	.reset_done	= hisi_sas_reset_done_v3_hw,
>  };
>  
> +static SIMPLE_DEV_PM_OPS(hisi_sas_v3_pm_ops,
> +			 hisi_sas_v3_suspend,
> +			 hisi_sas_v3_resume);
> +
>  static struct pci_driver sas_v3_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= sas_v3_pci_table,
>  	.probe		= hisi_sas_v3_probe,
>  	.remove		= hisi_sas_v3_remove,
> -	.suspend	= hisi_sas_v3_suspend,
> -	.resume		= hisi_sas_v3_resume,
> +	.driver.pm	= &hisi_sas_v3_pm_ops,
>  	.err_handler	= &hisi_sas_err_handler,
>  };
>  
> -- 
> 2.27.0
> 
.
