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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D3DC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9101A208FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8Yv3GKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgIHRFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgIHRFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:05:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22377C061573;
        Tue,  8 Sep 2020 10:05:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u13so10320pgh.1;
        Tue, 08 Sep 2020 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rg3cw4uuitsq6scjDERD80b86AFl2u5ct8QVb6GLkrg=;
        b=s8Yv3GKietZ8o4VhnWOmj5ljRDBk16ayc9JF1+OtrbCh+z8MAahjAzrviFSL7Wzfv5
         8k0+JeWagSvFI3syqKE8mYDDSzT7KOCmx4pX0OOMK9Kvup4L6L/76XsvEm+TtzvkO2CY
         tB4XscwN0968Bed+n46tahIHRtPqNm4cGlcoYT6DihH5NicmPgGlOkgfAhty+bIxuX17
         KEWQkV7kRFtpJG5I9W+qh66YXEJrv0acXwMzBVczLLiAETvTNe14OMn2F5RZ8etDTam5
         NwVehJCk3QDNii+SBcy5Vuw4/aqdHwFsZuQTqLd6w5YQT/b3NKeRQy0jUFz0jPDXFZLE
         /Auw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rg3cw4uuitsq6scjDERD80b86AFl2u5ct8QVb6GLkrg=;
        b=ZUxp+YmQppnfXke3RJdZxRWnthxjeHFqt8RB5sruxOkA3j2J4Dit2gH+9gZWBOph2g
         Pwc66pDAvIsq9LMZPgLQ2tJ5rzyoSGatgeJIzDs4SqXLFzHqa641uH2vCJvBw8Ee3wkQ
         XHg74vDK56ODLFx60XesNaAnhCTroLt4s+/w2DNGw83f/MMMq5xUeSzUmkOxxaCWFpLI
         R7qSkACccBZasgTAS5b4BVJegvAw31E+XLuxShD0kaTVB7nrpTd6J6q8M335+6vkLqt9
         d8VfENF10N7ez60Fo5zyJldby15+bGD1dwdJIPz9Zs5uC/vdBR9gezGYihdXZzWDVnJV
         oY1g==
X-Gm-Message-State: AOAM531l0FiUz7dXXb+EodjtOdqihd4hcfvQg4ca2Xzn9Ylib5LKpGpv
        8waSLA8JurAoN+65DCAgv2Aam+IPXXK2p0Kj
X-Google-Smtp-Source: ABdhPJz5M7cV+8W7VlQ6sZ64h62r+ju1LH3Mc1Yo4X312cccG092AqIcPx1aye8EH2R5L4zhvxkNFw==
X-Received: by 2002:a17:902:8c94:: with SMTP id t20mr24262107plo.76.1599584745515;
        Tue, 08 Sep 2020 10:05:45 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id l2sm41865pjy.3.2020.09.08.10.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:05:45 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:33:33 +0530
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
Subject: Re: [PATCH v2 09/15] scsi: lpfc: use generic power management
Message-ID: <20200908170333.GJ9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-10-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-10-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:22PM +0530, Vaibhav Gupta wrote:
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
> 
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
> 
> The driver was calling pci_save/restore_state(), pci_choose_state() and
> pci_set_power_state() which is no more needed.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 100 +++++++++++-----------------------
>  1 file changed, 33 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 6637f84a3d1b..a36309b48144 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12452,8 +12452,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
>  
>  /**
>   * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
> - * @pdev: pointer to PCI device
> - * @msg: power management message
> + * @dev_d: pointer to device
>   *
>   * This routine is to be called from the kernel's PCI subsystem to support
>   * system Power Management (PM) to device with SLI-3 interface spec. When
> @@ -12471,10 +12470,10 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
> +static int __maybe_unused
> +lpfc_pci_suspend_one_s3(struct device *dev_d)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> @@ -12488,16 +12487,12 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
>  	/* Disable interrupt from device */
>  	lpfc_sli_disable_intr(phba);
>  
> -	/* Save device state to PCI config space */
> -	pci_save_state(pdev);
> -	pci_set_power_state(pdev, PCI_D3hot);
> -
>  	return 0;
>  }
>  
>  /**
>   * lpfc_pci_resume_one_s3 - PCI func to resume SLI-3 device for power mgmnt
> - * @pdev: pointer to PCI device
> + * @dev_d: pointer to device
>   *
>   * This routine is to be called from the kernel's PCI subsystem to support
>   * system Power Management (PM) to device with SLI-3 interface spec. When PM
> @@ -12514,10 +12509,10 @@ lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_resume_one_s3(struct pci_dev *pdev)
> +static int __maybe_unused
> +lpfc_pci_resume_one_s3(struct device *dev_d)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  	uint32_t intr_mode;
>  	int error;
> @@ -12525,19 +12520,6 @@ lpfc_pci_resume_one_s3(struct pci_dev *pdev)
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  			"0452 PCI device Power Management resume.\n");
>  
> -	/* Restore device state from PCI config space */
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> -
> -	/*
> -	 * As the new kernel behavior of pci_restore_state() API call clears
> -	 * device saved_state flag, need to save the restored state again.
> -	 */
> -	pci_save_state(pdev);
> -
> -	if (pdev->is_busmaster)
> -		pci_set_master(pdev);
> -
>  	/* Startup the kernel thread for this host adapter. */
>  	phba->worker_thread = kthread_run(lpfc_do_work, phba,
>  					"lpfc_worker_%d", phba->brd_no);
> @@ -13294,8 +13276,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
>  
>  /**
>   * lpfc_pci_suspend_one_s4 - PCI func to suspend SLI-4 device for power mgmnt
> - * @pdev: pointer to PCI device
> - * @msg: power management message
> + * @dev_d: pointer to device
>   *
>   * This routine is called from the kernel's PCI subsystem to support system
>   * Power Management (PM) to device with SLI-4 interface spec. When PM invokes
> @@ -13313,10 +13294,10 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
> +static int __maybe_unused
> +lpfc_pci_suspend_one_s4(struct device *dev_d)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> @@ -13331,16 +13312,12 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
>  	lpfc_sli4_disable_intr(phba);
>  	lpfc_sli4_queue_destroy(phba);
>  
> -	/* Save device state to PCI config space */
> -	pci_save_state(pdev);
> -	pci_set_power_state(pdev, PCI_D3hot);
> -
>  	return 0;
>  }
>  
>  /**
>   * lpfc_pci_resume_one_s4 - PCI func to resume SLI-4 device for power mgmnt
> - * @pdev: pointer to PCI device
> + * @dev_d: pointer to device
>   *
>   * This routine is called from the kernel's PCI subsystem to support system
>   * Power Management (PM) to device with SLI-4 interface spac. When PM invokes
> @@ -13357,10 +13334,10 @@ lpfc_pci_suspend_one_s4(struct pci_dev *pdev, pm_message_t msg)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_resume_one_s4(struct pci_dev *pdev)
> +static int __maybe_unused
> +lpfc_pci_resume_one_s4(struct device *dev_d)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev_d);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  	uint32_t intr_mode;
>  	int error;
> @@ -13368,19 +13345,6 @@ lpfc_pci_resume_one_s4(struct pci_dev *pdev)
>  	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  			"0292 PCI device Power Management resume.\n");
>  
> -	/* Restore device state from PCI config space */
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> -
> -	/*
> -	 * As the new kernel behavior of pci_restore_state() API call clears
> -	 * device saved_state flag, need to save the restored state again.
> -	 */
> -	pci_save_state(pdev);
> -
> -	if (pdev->is_busmaster)
> -		pci_set_master(pdev);
> -
>  	 /* Startup the kernel thread for this host adapter. */
>  	phba->worker_thread = kthread_run(lpfc_do_work, phba,
>  					"lpfc_worker_%d", phba->brd_no);
> @@ -13696,8 +13660,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
>  
>  /**
>   * lpfc_pci_suspend_one - lpfc PCI func to suspend dev for power management
> - * @pdev: pointer to PCI device
> - * @msg: power management message
> + * @dev: pointer to device
>   *
>   * This routine is to be registered to the kernel's PCI subsystem to support
>   * system Power Management (PM). When PM invokes this method, it dispatches
> @@ -13708,19 +13671,19 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
> +static int __maybe_unused
> +lpfc_pci_suspend_one(struct device *dev)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  	int rc = -ENODEV;
>  
>  	switch (phba->pci_dev_grp) {
>  	case LPFC_PCI_DEV_LP:
> -		rc = lpfc_pci_suspend_one_s3(pdev, msg);
> +		rc = lpfc_pci_suspend_one_s3(dev);
>  		break;
>  	case LPFC_PCI_DEV_OC:
> -		rc = lpfc_pci_suspend_one_s4(pdev, msg);
> +		rc = lpfc_pci_suspend_one_s4(dev);
>  		break;
>  	default:
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> @@ -13733,7 +13696,7 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
>  
>  /**
>   * lpfc_pci_resume_one - lpfc PCI func to resume dev for power management
> - * @pdev: pointer to PCI device
> + * @dev: pointer to device
>   *
>   * This routine is to be registered to the kernel's PCI subsystem to support
>   * system Power Management (PM). When PM invokes this method, it dispatches
> @@ -13744,19 +13707,19 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
>   * 	0 - driver suspended the device
>   * 	Error otherwise
>   **/
> -static int
> -lpfc_pci_resume_one(struct pci_dev *pdev)
> +static int __maybe_unused
> +lpfc_pci_resume_one(struct device *dev)
>  {
> -	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct Scsi_Host *shost = dev_get_drvdata(dev);
>  	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
>  	int rc = -ENODEV;
>  
>  	switch (phba->pci_dev_grp) {
>  	case LPFC_PCI_DEV_LP:
> -		rc = lpfc_pci_resume_one_s3(pdev);
> +		rc = lpfc_pci_resume_one_s3(dev);
>  		break;
>  	case LPFC_PCI_DEV_OC:
> -		rc = lpfc_pci_resume_one_s4(pdev);
> +		rc = lpfc_pci_resume_one_s4(dev);
>  		break;
>  	default:
>  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> @@ -13936,14 +13899,17 @@ static const struct pci_error_handlers lpfc_err_handler = {
>  	.resume = lpfc_io_resume,
>  };
>  
> +static SIMPLE_DEV_PM_OPS(lpfc_pci_pm_ops_one,
> +			 lpfc_pci_suspend_one,
> +			 lpfc_pci_resume_one);
> +
>  static struct pci_driver lpfc_driver = {
>  	.name		= LPFC_DRIVER_NAME,
>  	.id_table	= lpfc_id_table,
>  	.probe		= lpfc_pci_probe_one,
>  	.remove		= lpfc_pci_remove_one,
>  	.shutdown	= lpfc_pci_remove_one,
> -	.suspend        = lpfc_pci_suspend_one,
> -	.resume		= lpfc_pci_resume_one,
> +	.driver.pm	= &lpfc_pci_pm_ops_one,
>  	.err_handler    = &lpfc_err_handler,
>  };
>  
> -- 
> 2.27.0
> 
.
