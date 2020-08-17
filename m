Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F641C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 07:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E21E20772
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 07:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2jPb1zN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgHQHlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHQHlA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 03:41:00 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3952CC061388;
        Mon, 17 Aug 2020 00:41:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so7404594pjb.4;
        Mon, 17 Aug 2020 00:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RM7j56GIbY2XZQvIJvFYJfc76JLevpY4j9bfd6IB8PM=;
        b=B2jPb1zNf6ZAsLlmkE35hVF+l8cn20ifAn+x251i5y3n60gsemf0JdE/T5qWJDSEg0
         WZktiFFIKwf9o93dBrsMvzP35J0H3wrl26g8ashCvCw/6EWboyaRAfonP+8Pa8I9Jy5D
         d5DwzgQy81ktHTnEEtYv0hkGeqapPzl4HFcntCKsHLM6QVxJEKXHrT9wO6oqCA/KIqbg
         oHH3cbMvr7sxxoU1QgCRoJ741ofLd2xNWQ5xTT7bwReq+u0c/NIsLAYTZzK1su/GQ8cY
         dcv2UkgF7ybn3xVOkDk9PNBN95puQbkKVcGDVFsZtbXm0y8LONNXuHDmnAw48CRLCZGO
         AvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RM7j56GIbY2XZQvIJvFYJfc76JLevpY4j9bfd6IB8PM=;
        b=O6APeUwWDINN/Zt3Ll4MEJ2gxb/nusjaUXcjtmrF9L88Zaxwd0BHZlHCwK4LPsXITY
         6ceEZtnELIXM0ULBzUhGOJi+ciAgxFdEd3X1wjZWKGw/4aS8E6FTdACZdRCRplDT5z5/
         PYZ+4p8XNeG59r0OLqrM0ukENjigT9fXb/wymp1Qw5PsywSpikF/ZInR7X4hnWHzfIL9
         Q9+A8jqXrBsVr03Sga/EebqSUmHtzZpLRztbb8XV0FYQX9dQ+ZsLprAgteV/OWocUOu+
         1abaEi/4Dc7V/y8LIXT0ooKFtxSwR65eMm8bvqO6/2h3wZNlGnHclgGFem2kw7s7MPq6
         pERw==
X-Gm-Message-State: AOAM531Cchp7byiKbdhZJWy//50MocqvHFwCCSGTTFMMv3fYqZvywYq2
        HHe7ZIRKUDP0lXFTJ+ITR7Gm5cXIiobYEA==
X-Google-Smtp-Source: ABdhPJxSy5/FMM0HJ0/af0ZF1zBcmMyDQxg6J0+q5z0IpnrvbNusAdYb9w/wZu0aF7I3xcbOgAjPvw==
X-Received: by 2002:a17:90b:788:: with SMTP id l8mr11585703pjz.25.1597650059638;
        Mon, 17 Aug 2020 00:40:59 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id q18sm18473566pfn.106.2020.08.17.00.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 00:40:59 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:09:15 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] mptfusion: use generic power management
Message-ID: <20200817073915.GA5869@gmail.com>
References: <20200721142423.304231-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200721142423.304231-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2020 at 07:54:24PM +0530, Vaibhav Gupta wrote:
> Drivers using legacy power management .suspen()/.resume() callbacks
> have to manage PCI states and device's PM states themselves. They also
> need to take care of standard configuration registers.
> 
> Switch to generic power management framework using a single
> "struct dev_pm_ops" variable to take the unnecessary load from the driver.
> This also avoids the need for the driver to directly call most of the PCI
> helper functions and device power state control functions as through
> the generic framework, PCI Core takes care of the necessary operations,
> and drivers are required to do only device-specific jobs.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/message/fusion/mptbase.c  | 36 +++++++++++--------------------
>  drivers/message/fusion/mptbase.h  |  7 +++---
>  drivers/message/fusion/mptfc.c    |  5 +----
>  drivers/message/fusion/mptsas.c   |  5 +----
>  drivers/message/fusion/mptscsih.c | 36 +++++++++++++++----------------
>  drivers/message/fusion/mptscsih.h |  7 +++---
>  drivers/message/fusion/mptspi.c   | 26 +++++++++++++---------
>  7 files changed, 53 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5216487db4fb..13a839c855a1 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2139,23 +2139,19 @@ mpt_detach(struct pci_dev *pdev)
>  /**************************************************************************
>   * Power Management
>   */
> -#ifdef CONFIG_PM
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
>   *	mpt_suspend - Fusion MPT base driver suspend routine.
> - *	@pdev: Pointer to pci_dev structure
> - *	@state: new state to enter
> + *	@dev: Pointer to device structure
>   */
> -int
> -mpt_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused
> +mpt_suspend(struct device *dev)
>  {
> -	u32 device_state;
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
>  
> -	device_state = pci_choose_state(pdev, state);
>  	printk(MYIOC_s_INFO_FMT "pci-suspend: pdev=0x%p, slot=%s, Entering "
> -	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
> -	    device_state);
> +	    "suspend state\n", ioc->name, pdev, pci_name(pdev));
>  
>  	/* put ioc into READY_STATE */
>  	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
> @@ -2174,21 +2170,18 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
>  	if (ioc->msi_enable)
>  		pci_disable_msi(ioc->pcidev);
>  	ioc->pci_irq = -1;
> -	pci_save_state(pdev);
> -	pci_disable_device(pdev);
> -	pci_release_selected_regions(pdev, ioc->bars);
> -	pci_set_power_state(pdev, device_state);
>  	return 0;
>  }
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
>   *	mpt_resume - Fusion MPT base driver resume routine.
> - *	@pdev: Pointer to pci_dev structure
> + *	@dev: Pointer to device structure
>   */
> -int
> -mpt_resume(struct pci_dev *pdev)
> +static int __maybe_unused
> +mpt_resume(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
>  	u32 device_state = pdev->current_state;
>  	int recovery_state;
> @@ -2198,9 +2191,6 @@ mpt_resume(struct pci_dev *pdev)
>  	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
>  	    device_state);
>  
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -	pci_restore_state(pdev);
>  	ioc->pcidev = pdev;
>  	err = mpt_mapresources(ioc);
>  	if (err)
> @@ -2256,7 +2246,9 @@ mpt_resume(struct pci_dev *pdev)
>  	return 0;
>  
>  }
> -#endif
> +
> +SIMPLE_DEV_PM_OPS(mpt_pm_ops, mpt_suspend, mpt_resume);
> +EXPORT_SYMBOL(mpt_pm_ops);
>  
>  static int
>  mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
> @@ -8440,10 +8432,6 @@ mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  EXPORT_SYMBOL(mpt_attach);
>  EXPORT_SYMBOL(mpt_detach);
> -#ifdef CONFIG_PM
> -EXPORT_SYMBOL(mpt_resume);
> -EXPORT_SYMBOL(mpt_suspend);
> -#endif
>  EXPORT_SYMBOL(ioc_list);
>  EXPORT_SYMBOL(mpt_register);
>  EXPORT_SYMBOL(mpt_deregister);
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 813d46311f6a..b4ae350acd6c 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -909,10 +909,9 @@ typedef struct _x_config_parms {
>   */
>  extern int	 mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id);
>  extern void	 mpt_detach(struct pci_dev *pdev);
> -#ifdef CONFIG_PM
> -extern int	 mpt_suspend(struct pci_dev *pdev, pm_message_t state);
> -extern int	 mpt_resume(struct pci_dev *pdev);
> -#endif
> +
> +extern const struct dev_pm_ops mpt_pm_ops;
> +
>  extern u8	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass,
>  		char *func_name);
>  extern void	 mpt_deregister(u8 cb_idx);
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index 4314a3352b96..5aae60bdd6c4 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -1357,10 +1357,7 @@ static struct pci_driver mptfc_driver = {
>  	.probe		= mptfc_probe,
>  	.remove		= mptfc_remove,
>  	.shutdown	= mptscsih_shutdown,
> -#ifdef CONFIG_PM
> -	.suspend	= mptscsih_suspend,
> -	.resume		= mptscsih_resume,
> -#endif
> +	.driver.pm	= &mptscsih_pm_ops,
>  };
>  
>  static int
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 6a79cd0ebe2b..158b59336b8f 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -5376,10 +5376,7 @@ static struct pci_driver mptsas_driver = {
>  	.probe		= mptsas_probe,
>  	.remove		= mptsas_remove,
>  	.shutdown	= mptsas_shutdown,
> -#ifdef CONFIG_PM
> -	.suspend	= mptscsih_suspend,
> -	.resume		= mptscsih_resume,
> -#endif
> +	.driver.pm	= &mptscsih_pm_ops,
>  };
>  
>  static int __init
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 1491561d2e5c..2861e51841da 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -113,10 +113,12 @@ mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
>  				SCSITaskMgmtReply_t *pScsiTmReply);
>  void 		mptscsih_remove(struct pci_dev *);
>  void 		mptscsih_shutdown(struct pci_dev *);
> -#ifdef CONFIG_PM
> -int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
> -int 		mptscsih_resume(struct pci_dev *pdev);
> -#endif
> +
> +static int __maybe_unused
> +mptscsih_suspend(struct device *dev);
> +
> +static int __maybe_unused
> +mptscsih_resume(struct device *dev);
>  
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> @@ -1215,22 +1217,21 @@ mptscsih_shutdown(struct pci_dev *pdev)
>  {
>  }
>  
> -#ifdef CONFIG_PM
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /*
>   *	mptscsih_suspend - Fusion MPT scsi driver suspend routine.
>   *
>   *
>   */
> -int
> -mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused
> +mptscsih_suspend(struct device *dev)
>  {
> -	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> +	MPT_ADAPTER 		*ioc = dev_get_drvdata(dev);
>  
>  	scsi_block_requests(ioc->sh);
>  	flush_scheduled_work();
> -	mptscsih_shutdown(pdev);
> -	return mpt_suspend(pdev,state);
> +	mptscsih_shutdown(to_pci_dev(dev));
> +	return mpt_pm_ops.suspend(dev);
>  }
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> @@ -1239,18 +1240,19 @@ mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
>   *
>   *
>   */
> -int
> -mptscsih_resume(struct pci_dev *pdev)
> +static int __maybe_unused
> +mptscsih_resume(struct device *dev)
>  {
> -	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> +	MPT_ADAPTER 		*ioc = dev_get_drvdata(dev);
>  	int rc;
>  
> -	rc = mpt_resume(pdev);
> +	rc = mpt_pm_ops.resume(dev);
>  	scsi_unblock_requests(ioc->sh);
>  	return rc;
>  }
>  
> -#endif
> +SIMPLE_DEV_PM_OPS(mptscsih_pm_ops, mptscsih_suspend, mptscsih_resume);
> +EXPORT_SYMBOL(mptscsih_pm_ops);
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
> @@ -3236,10 +3238,6 @@ EXPORT_SYMBOL(mptscsih_host_attrs);
>  
>  EXPORT_SYMBOL(mptscsih_remove);
>  EXPORT_SYMBOL(mptscsih_shutdown);
> -#ifdef CONFIG_PM
> -EXPORT_SYMBOL(mptscsih_suspend);
> -EXPORT_SYMBOL(mptscsih_resume);
> -#endif
>  EXPORT_SYMBOL(mptscsih_show_info);
>  EXPORT_SYMBOL(mptscsih_info);
>  EXPORT_SYMBOL(mptscsih_qcmd);
> diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
> index 2baeefd9be7a..57ebb22977ee 100644
> --- a/drivers/message/fusion/mptscsih.h
> +++ b/drivers/message/fusion/mptscsih.h
> @@ -107,10 +107,9 @@ typedef struct _internal_cmd {
>  
>  extern void mptscsih_remove(struct pci_dev *);
>  extern void mptscsih_shutdown(struct pci_dev *);
> -#ifdef CONFIG_PM
> -extern int mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
> -extern int mptscsih_resume(struct pci_dev *pdev);
> -#endif
> +
> +extern const struct dev_pm_ops mptscsih_pm_ops;
> +
>  extern int mptscsih_show_info(struct seq_file *, struct Scsi_Host *);
>  extern const char * mptscsih_info(struct Scsi_Host *SChost);
>  extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index eabc4de5816c..19994d5d034c 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -1321,23 +1321,30 @@ mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
>  	return rc;
>  }
>  
> -#ifdef CONFIG_PM
> +/*
> + * spi module suspend handler
> + */
> +static int __maybe_unused
> +mptspi_suspend(struct device *dev)
> +{
> +	return mptscsih_pm_ops.suspend(dev);
> +}
> +
>  /*
>   * spi module resume handler
>   */
> -static int
> -mptspi_resume(struct pci_dev *pdev)
> +static int __maybe_unused
> +mptspi_resume(struct device *dev)
>  {
> -	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
> +	MPT_ADAPTER 	*ioc = dev_get_drvdata(dev);
>  	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
>  	int rc;
>  
> -	rc = mptscsih_resume(pdev);
> +	rc = mptscsih_pm_ops.resume(dev);
>  	mptspi_dv_renegotiate(hd);
>  
>  	return rc;
>  }
> -#endif
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> @@ -1550,16 +1557,15 @@ static void mptspi_remove(struct pci_dev *pdev)
>  	mptscsih_remove(pdev);
>  }
>  
> +static SIMPLE_DEV_PM_OPS(mptspi_pm_ops, mptspi_suspend, mptspi_resume);
> +
>  static struct pci_driver mptspi_driver = {
>  	.name		= "mptspi",
>  	.id_table	= mptspi_pci_table,
>  	.probe		= mptspi_probe,
>  	.remove		= mptspi_remove,
>  	.shutdown	= mptscsih_shutdown,
> -#ifdef CONFIG_PM
> -	.suspend	= mptscsih_suspend,
> -	.resume		= mptspi_resume,
> -#endif
> +	.driver.pm	= &mptspi_pm_ops,
>  };
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> -- 
> 2.27.0
> 
