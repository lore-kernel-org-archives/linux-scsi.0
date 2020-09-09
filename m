Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13614C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 10:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C470621973
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 10:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP9aECFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIIKFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 06:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIIKFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 06:05:21 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD62C061573;
        Wed,  9 Sep 2020 03:05:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kk9so1102315pjb.2;
        Wed, 09 Sep 2020 03:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XB3RLON5qcBthb/U8/A/O+8sQ7Tgn2KHnSYoALIjbSE=;
        b=CP9aECFZyZL9cNPC6KblFfjHnAeIdhRWfiNbIoAx5Bbi0lvpDWFQXeebyLf80tMdzx
         sMXsLSW6Y0qPhAmJjbsIP8Xx7GiprSnRuc83FpiCT3NcsiyETFbsK4OOo12gfCybKKtj
         37eVSUMylMLjGaMgeG4lqDh6DmoQAG8leelQkKYQJ5WwfxKDu9FFz7MrXx/G6yOgwzdx
         BVM0WTwbs5HcmMiG3dlCjDJ3/n2PFzA9nvyGu6V5NakdDsP5TRLRk+K8bU9bCMXXBgvj
         xKisg4nlLlnZM79rB/B/FzOPbFVbvZqRXk1qCmGHFbnqBBQYNwC8g4+5dRvescvPp9Zm
         cBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XB3RLON5qcBthb/U8/A/O+8sQ7Tgn2KHnSYoALIjbSE=;
        b=iG+Qbg3u9nzoNCMLy3LgYMxhaC0eL+o+CqiTvISlk2tFFHtXukIFhEkK6cMoAzP4+w
         4tvpxLl0wVvX/Rq7V4Lngi/ggp/D8UFYtmRGUUVHHjfFTB9HKR6+QvjI/rqwGZ/ClimG
         5o7z15SRIPrWRLYKk9GsIGriGm3HMK64mAdx5y5t23+bQ90IebXtSkG7013U5lejPN0n
         ePigWHQSM75K7gfOAvTa3m8s6IUpJW44/YBqkEW/4YQBcWVMB/2z7/RyzzZ7TAune8gW
         BluIlKMlY+nIfqk5oEz1bU+53Yx2Pn/CFOEY/iRr7otmvD2m0vK0Yoh7WILZbD6HniTJ
         JUmQ==
X-Gm-Message-State: AOAM530p5SaERGloUkSYn78MFkaTgQHwz5NWOnH+cMMQUG3McUzr981R
        XTc+L9bczIoNxZwBXcI0ykc=
X-Google-Smtp-Source: ABdhPJxhipPJcCxZ+k1YRv2vZByYBjQ1zjv+RABOUsx9MSpGzEONZGUieuPo5vYeNuljeYpsEhsgUw==
X-Received: by 2002:a17:90b:1916:: with SMTP id mp22mr170102pjb.132.1599645919622;
        Wed, 09 Sep 2020 03:05:19 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id h1sm1577255pji.52.2020.09.09.03.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:05:19 -0700 (PDT)
Date:   Wed, 9 Sep 2020 15:33:15 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
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
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v2 01/15] scsi: megaraid_sas: use generic power management
Message-ID: <20200909100315.GA13015@gmail.com>
References: <20200720133427.454400-2-vaibhavgupta40@gmail.com>
 <20200908173209.GA607806@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200908173209.GA607806@bjorn-Precision-5520>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 08, 2020 at 12:32:09PM -0500, Bjorn Helgaas wrote:
> On Mon, Jul 20, 2020 at 07:04:14PM +0530, Vaibhav Gupta wrote:
> > With legacy PM hooks, it was the responsibility of a driver to manage PCI
> > states and also the device's power state. The generic approach is to let
> > the PCI core handle the work.
> > 
> > PCI core passes "struct device*" as an argument to the .suspend() and
> > .resume() callbacks. As the .suspend() work with "struct instance*",
> > extract it from "struct device*" using dev_get_drv_data().
> > 
> > Driver was also using PCI helper functions like pci_save/restore_state(),
> > pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
> > They should not be invoked by the driver.
> > 
> > Compile-tested only.
> > 
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 61 ++++++-----------------
> >  1 file changed, 16 insertions(+), 45 deletions(-)
> > 
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 00668335c2af..4a6ee7778977 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -7539,25 +7539,21 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
> >  	megasas_return_cmd(instance, cmd);
> >  }
> >  
> > -#ifdef CONFIG_PM
> >  /**
> >   * megasas_suspend -	driver suspend entry point
> > - * @pdev:		PCI device structure
> > - * @state:		PCI power state to suspend routine
> > + * @dev:		Device structure
> >   */
> > -static int
> > -megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> > +static int __maybe_unused
> > +megasas_suspend(struct device *dev)
> >  {
> > -	struct megasas_instance *instance;
> > -
> > -	instance = pci_get_drvdata(pdev);
> > +	struct megasas_instance *instance = dev_get_drvdata(dev);
> >  
> >  	if (!instance)
> >  		return 0;
> >  
> >  	instance->unload = 1;
> >  
> > -	dev_info(&pdev->dev, "%s is called\n", __func__);
> > +	dev_info(dev, "%s is called\n", __func__);
> >  
> >  	/* Shutdown SR-IOV heartbeat timer */
> >  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
> > @@ -7579,7 +7575,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> >  
> >  	tasklet_kill(&instance->isr_tasklet);
> >  
> > -	pci_set_drvdata(instance->pdev, instance);
> > +	dev_set_drvdata(dev, instance);
> 
> It *might* be correct to replace "instance->pdev" with "dev", but it's
> not obvious and deserves some explanation.  It's true that you can
> replace &pdev->dev with dev, but I don't know anything about
> instance->dev.
> 
> I don't think this change is actually necessary, is it?
> "instance->pdev" is still a pci_dev pointer, so pci_set_drvdata()
> should work fine.
> 
> It looks goofy to use pci_set_drvdata() or dev_set_drvdata() in a
> suspend routine, but I didn't bother trying to figure out what's going
> on here.
> 
There is no instance->dev . The 'dev' passed dev_set_drvdata() is same
&pdev->dev. The dev pointer used here, points to same value.

pci_get_drvdata() and pci_set_drvdata() invoke dev_get_drvdata() and
dev_set_drvdata() respectively. And they do nothing else. Seems like additional
unnecessary function calls and operations.

We can get rid of these PCI helper functions too.
> >  	instance->instancet->disable_intr(instance);
> >  
> >  	megasas_destroy_irqs(instance);
> > @@ -7587,48 +7583,28 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> >  	if (instance->msix_vectors)
> >  		pci_free_irq_vectors(instance->pdev);
> >  
> > -	pci_save_state(pdev);
> > -	pci_disable_device(pdev);
> > -
> > -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> > -
> >  	return 0;
> >  }
> >  
> >  /**
> >   * megasas_resume-      driver resume entry point
> > - * @pdev:               PCI device structure
> > + * @dev:              Device structure
> >   */
> > -static int
> > -megasas_resume(struct pci_dev *pdev)
> > +static int __maybe_unused
> > +megasas_resume(struct device *dev)
> >  {
> >  	int rval;
> >  	struct Scsi_Host *host;
> > -	struct megasas_instance *instance;
> > +	struct megasas_instance *instance = dev_get_drvdata(dev);
> >  	u32 status_reg;
> >  
> > -	instance = pci_get_drvdata(pdev);
> > -
> >  	if (!instance)
> >  		return 0;
> >  
> >  	host = instance->host;
> > -	pci_set_power_state(pdev, PCI_D0);
> > -	pci_enable_wake(pdev, PCI_D0, 0);
> > -	pci_restore_state(pdev);
> > +	device_wakeup_disable(dev);
> 
> Shouldn't there be a corresponding device_wakeup_enable() or similar
> elsewhere?
> 
> Maybe the fact that megasas disables wakeup but never enables it is a
> latent bug?
> 
Yeah, I guess I sent this patch a lot earlier than we figured this out and
didn't notice it later. I will send v3 for it.
> > -	dev_info(&pdev->dev, "%s is called\n", __func__);
> > -	/*
> > -	 * PCI prepping: enable device set bus mastering and dma mask
> > -	 */
> > -	rval = pci_enable_device_mem(pdev);
> > -
> > -	if (rval) {
> > -		dev_err(&pdev->dev, "Enable device failed\n");
> > -		return rval;
> > -	}
> > -
> > -	pci_set_master(pdev);
> > +	dev_info(dev, "%s is called\n", __func__);
> >  
> >  	/*
> >  	 * We expect the FW state to be READY
> > @@ -7754,14 +7730,8 @@ megasas_resume(struct pci_dev *pdev)
> >  fail_set_dma_mask:
> >  fail_ready_state:
> >  
> > -	pci_disable_device(pdev);
> > -
> >  	return -ENODEV;
> >  }
> > -#else
> > -#define megasas_suspend	NULL
> > -#define megasas_resume	NULL
> > -#endif
> >  
> >  static inline int
> >  megasas_wait_for_adapter_operational(struct megasas_instance *instance)
> > @@ -7931,7 +7901,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
> >  
> >  /**
> >   * megasas_shutdown -	Shutdown entry point
> > - * @device:		Generic device structure
> > + * @pdev:		PCI device structure
> 
> Looks like an unrelated typo fix?  I would put this in a separate
> patch.
> 
Okay.
> >   */
> >  static void megasas_shutdown(struct pci_dev *pdev)
> >  {
> > @@ -8508,6 +8478,8 @@ static const struct file_operations megasas_mgmt_fops = {
> >  	.llseek = noop_llseek,
> >  };
> >  
> > +static SIMPLE_DEV_PM_OPS(megasas_pm_ops, megasas_suspend, megasas_resume);
> > +
> >  /*
> >   * PCI hotplug support registration structure
> >   */
> > @@ -8517,8 +8489,7 @@ static struct pci_driver megasas_pci_driver = {
> >  	.id_table = megasas_pci_table,
> >  	.probe = megasas_probe_one,
> >  	.remove = megasas_detach_one,
> > -	.suspend = megasas_suspend,
> > -	.resume = megasas_resume,
> > +	.driver.pm = &megasas_pm_ops,
> >  	.shutdown = megasas_shutdown,
> >  };
> >  
> > -- 
> > 2.27.0
> > 
