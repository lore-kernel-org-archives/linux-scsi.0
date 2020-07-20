Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB6EC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C355F22482
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVP/VDVo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGTGeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 02:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTGeS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 02:34:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B05C0619D2;
        Sun, 19 Jul 2020 23:34:17 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so8549613pfm.4;
        Sun, 19 Jul 2020 23:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7GFd7Yku8i+FF1S4CUo1hrbA5Zh0OraFGwFf9HMOIw4=;
        b=mVP/VDVoII2NYltj2o/cI4fLTlW/fCOt78CYJjBWGV3FlC1cg7w1KI0zfcsoirtrHe
         JvbZzVZHR2sXINXqeeAhp+A2yvDPsaqmcWaYJK9TVh1vtyXed+oyhPkBs9lU21w7n0aP
         dwUT3+UKIgLVzg9F7+fC6tFRIys/i902EF85yBj7exUlO6atH0OgZxtlC4nK2ke7/5Bf
         BKDFGs/x2NojAd3JV1QyMpLSgzC6wh/oTwKzRGYGpJqie//kXCGszMeOOJ868KE7zm12
         oRHjiy1/BDf9BqgLxoi1KB9zL7qD3zIBWDnX527KiIslcSBIuVd0Yo25ZcxgP5Tv3iEf
         v3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7GFd7Yku8i+FF1S4CUo1hrbA5Zh0OraFGwFf9HMOIw4=;
        b=ZI+5psT4Tw3zHBg6wlTSYcCDe6yIi5/k7w6vywBFTxy7EPQ9x3vQN+fQvwGUXsQMm0
         7E7dHuSfbx/EP+i5HGNkpzDiglKtTbq4RYr6FV0n5z/0liY8tyygRHOFnCG9dN0y1NQr
         6rEeQfLmwJt2z+xSDAXdeCJvi/2pCiEyNXbGqxHfpA2zBBKiLj1RuVIGoBhS3e+TEWNx
         cZTPfGwrMHIP7zPV7/jpPPbGIyYtNin1AeC88gxYyhMXoqPV87K/Oa1+9zvgEpVloKY3
         O2FMGfURRiWXEV1ugiSCGFxt9Uwok5SzVKmPePgG+ZBWY62mMG4b5EKUaJ89vVG68AD4
         DbcQ==
X-Gm-Message-State: AOAM5311ACZ+4q/dLPlwfTIwYsKp/ftPyYAo6PhXONUs5Gp3EXFJQ/Bb
        iuS59FgTYepfIG7Teeljvlg=
X-Google-Smtp-Source: ABdhPJxQmF5oq+pWAT2xYH05CJxxqZ93CWM8ckA5SEl9IkhpdbaKMKvlrTVaOBfMKylYBl9Qs/PVgA==
X-Received: by 2002:aa7:9a03:: with SMTP id w3mr17729156pfj.228.1595226857292;
        Sun, 19 Jul 2020 23:34:17 -0700 (PDT)
Received: from gmail.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id 195sm7901326pfb.206.2020.07.19.23.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 23:34:16 -0700 (PDT)
Date:   Mon, 20 Jul 2020 12:02:53 +0530
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
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
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v1 07/15] scsi: hisi_sas_v3_hw: use generic power
 management
Message-ID: <20200720063253.GA4237@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
 <20200717063438.175022-8-vaibhavgupta40@gmail.com>
 <367bd5d3-f0a6-2bd7-2945-3095c827dbe6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <367bd5d3-f0a6-2bd7-2945-3095c827dbe6@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 02:16:45PM +0800, chenxiang (M) wrote:
> Hi Vaibhav,
> 
> 在 2020/7/17 14:34, Vaibhav Gupta 写道:
> > With legacy PM, drivers themselves were responsible for managing the
> > device's power states and takes care of register states.
> > 
> > After upgrading to the generic structure, PCI core will take care of
> > required tasks and drivers should do only device-specific operations.
> > 
> > The driver was calling pci_save/restore_state(), pci_choose_state(),
> > pci_enable/disable_device() and pci_set_power_state() which is no more
> > needed.
> > 
> > Compile-tested only.
> > 
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> 
> Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
> Just a small comment, below.
> 
> > ---
> >   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 32 ++++++++------------------
> >   1 file changed, 10 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > index 55e2321a65bc..45605a520bc8 100644
> > --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> > @@ -3374,13 +3374,13 @@ enum {
> >   	hip08,
> >   };
> > -static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
> > +static int __maybe_unused hisi_sas_v3_suspend(struct device *dev_d)
> >   {
> > +	struct pci_dev *pdev = to_pci_dev(dev_d);
> >   	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
> >   	struct hisi_hba *hisi_hba = sha->lldd_ha;
> >   	struct device *dev = hisi_hba->dev;
> >   	struct Scsi_Host *shost = hisi_hba->shost;
> > -	pci_power_t device_state;
> >   	int rc;
> >   	if (!pdev->pm_cap) {
> > @@ -3406,21 +3406,15 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
> >   	hisi_sas_init_mem(hisi_hba);
> > -	device_state = pci_choose_state(pdev, state);
> > -	dev_warn(dev, "entering operating state [D%d]\n",
> > -			device_state);
> 
> Please retain above print to keep consistence with the print in function
> hisi_sas_v3_resume().
>
Okay, Thanks for the review :)
This is will be fixed in v2 patch-series along with other changes.

-- Vaibhav Gupta 
> > -	pci_save_state(pdev);
> > -	pci_disable_device(pdev);
> > -	pci_set_power_state(pdev, device_state);
> > -
> >   	hisi_sas_release_tasks(hisi_hba);
> >   	sas_suspend_ha(sha);
> >   	return 0;
> >   }
> > -static int hisi_sas_v3_resume(struct pci_dev *pdev)
> > +static int __maybe_unused hisi_sas_v3_resume(struct device *dev_d)
> >   {
> > +	struct pci_dev *pdev = to_pci_dev(dev_d);
> >   	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
> >   	struct hisi_hba *hisi_hba = sha->lldd_ha;
> >   	struct Scsi_Host *shost = hisi_hba->shost;
> > @@ -3430,16 +3424,8 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
> >   	dev_warn(dev, "resuming from operating state [D%d]\n",
> >   		 device_state);
> > -	pci_set_power_state(pdev, PCI_D0);
> > -	pci_enable_wake(pdev, PCI_D0, 0);
> > -	pci_restore_state(pdev);
> > -	rc = pci_enable_device(pdev);
> > -	if (rc) {
> > -		dev_err(dev, "enable device failed during resume (%d)\n", rc);
> > -		return rc;
> > -	}
> > +	device_wakeup_disable(dev_d);
> > -	pci_set_master(pdev);
> >   	scsi_unblock_requests(shost);
> >   	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
> > @@ -3447,7 +3433,6 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
> >   	rc = hw_init_v3_hw(hisi_hba);
> >   	if (rc) {
> >   		scsi_remove_host(shost);
> > -		pci_disable_device(pdev);
> >   		return rc;
> >   	}
> >   	hisi_hba->hw->phys_init(hisi_hba);
> > @@ -3468,13 +3453,16 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
> >   	.reset_done	= hisi_sas_reset_done_v3_hw,
> >   };
> > +static SIMPLE_DEV_PM_OPS(hisi_sas_v3_pm_ops,
> > +			 hisi_sas_v3_suspend,
> > +			 hisi_sas_v3_resume);
> > +
> >   static struct pci_driver sas_v3_pci_driver = {
> >   	.name		= DRV_NAME,
> >   	.id_table	= sas_v3_pci_table,
> >   	.probe		= hisi_sas_v3_probe,
> >   	.remove		= hisi_sas_v3_remove,
> > -	.suspend	= hisi_sas_v3_suspend,
> > -	.resume		= hisi_sas_v3_resume,
> > +	.driver.pm	= &hisi_sas_v3_pm_ops,
> >   	.err_handler	= &hisi_sas_err_handler,
> >   };
> 
> 
