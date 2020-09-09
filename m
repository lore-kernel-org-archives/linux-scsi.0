Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FD7C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 17:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A032A206D4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 17:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7Nu/Gdk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIIRQH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbgIIP2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 11:28:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54352C0619CE;
        Wed,  9 Sep 2020 08:23:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md22so1448157pjb.0;
        Wed, 09 Sep 2020 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=noQeIbbfRoQ0vZidOFhwWAtZHlg8KZn5Mi7qKiUoSv0=;
        b=R7Nu/GdkZmEC7TSLlP7R1O7TOyafDUdN6tay9lOSACMBaKb1nIEA9caWMlBIvIwEqg
         RurBwTc+FMV4gdRWQ8bJl3G9VT88ykR+HHjd6z8slJDU9De2K7HpRqzQX3kuaqgR6hYe
         dKFg24ew0Usg/YH1H/W5nCJ/v2vtNS7+SqMuedsfBWHtLNzkR3tm+/xoKIKBYRLuTeau
         ujAKFaMr2va34hxRNKG6vZ1lmb69TUCABv+08mggUQencSE3Ru58Yp5sbvYw7zJvLK8b
         Jjz7BS6emhbrlfTmO9kkfNf4nFZo7r96hXE3g1AnidGnRlJzngcHCMxvAlHKeltpYRIn
         Ozug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=noQeIbbfRoQ0vZidOFhwWAtZHlg8KZn5Mi7qKiUoSv0=;
        b=Nwd5CJLc4vAea/6q7qOlWhSvcPbDYPh+Vsh/E1XFEyNmMeZ+ROu5ilBekgAXqKiwOL
         Y6O2i8mdrF+0DNQRH8S/CQTk1YFY2Nf3xl32eEc8okgBVj+xmVR+ybvIrbdlkO0qCU8l
         hiDjpv/rkJ8K85kXOR8UnUfPTAZ9tbRFRClHaByTzlvF7at3hl4DfWrEpoo94PWoeGKa
         w6Xs9ycSO+ZSVesG2sOSMcVfbiNFxk3xum67wm21izxKm9EvpL9Xq3ldLar2EFEKLme+
         3rvbC+wjVqebj22BiHAvBlW8Q+lnPqfpKvP3u+56dsg/DGz7MGdBV/i8ChM54idBoS3R
         A2uw==
X-Gm-Message-State: AOAM531TNg2q1+BXUkF6TZmoaTOVLSOaPayCdc339SXSJxx10iPEIN0A
        7sqFI+rXwZu1qkJafB6Mz/8=
X-Google-Smtp-Source: ABdhPJxqyDSxATruhior6ZQs2kvioJaM7ed7VFeMTMm6hLUtqFjHtkirT8TP5qyBahgoWiWYiapPww==
X-Received: by 2002:a17:90a:a40d:: with SMTP id y13mr1187741pjp.183.1599664982471;
        Wed, 09 Sep 2020 08:23:02 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id a2sm3014910pfr.104.2020.09.09.08.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 08:23:01 -0700 (PDT)
Date:   Wed, 9 Sep 2020 20:50:58 +0530
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
Message-ID: <20200909152058.GA14223@gmail.com>
References: <20200909100315.GA13015@gmail.com>
 <20200909132332.GA696701@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200909132332.GA696701@bjorn-Precision-5520>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 09, 2020 at 08:23:32AM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 09, 2020 at 03:33:15PM +0530, Vaibhav Gupta wrote:
> > On Tue, Sep 08, 2020 at 12:32:09PM -0500, Bjorn Helgaas wrote:
> > > On Mon, Jul 20, 2020 at 07:04:14PM +0530, Vaibhav Gupta wrote:
> > > > With legacy PM hooks, it was the responsibility of a driver to manage PCI
> > > > states and also the device's power state. The generic approach is to let
> > > > the PCI core handle the work.
> > > > 
> > > > PCI core passes "struct device*" as an argument to the .suspend() and
> > > > .resume() callbacks. As the .suspend() work with "struct instance*",
> > > > extract it from "struct device*" using dev_get_drv_data().
> > > > 
> > > > Driver was also using PCI helper functions like pci_save/restore_state(),
> > > > pci_disable/enable_device(), pci_set_power_state() and pci_enable_wake().
> > > > They should not be invoked by the driver.
> > > > 
> > > > Compile-tested only.
> > > > 
> > > > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> > > > ---
> > > >  drivers/scsi/megaraid/megaraid_sas_base.c | 61 ++++++-----------------
> > > >  1 file changed, 16 insertions(+), 45 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > > index 00668335c2af..4a6ee7778977 100644
> > > > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > > > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > > @@ -7539,25 +7539,21 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
> > > >  	megasas_return_cmd(instance, cmd);
> > > >  }
> > > >  
> > > > -#ifdef CONFIG_PM
> > > >  /**
> > > >   * megasas_suspend -	driver suspend entry point
> > > > - * @pdev:		PCI device structure
> > > > - * @state:		PCI power state to suspend routine
> > > > + * @dev:		Device structure
> > > >   */
> > > > -static int
> > > > -megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> > > > +static int __maybe_unused
> > > > +megasas_suspend(struct device *dev)
> > > >  {
> > > > -	struct megasas_instance *instance;
> > > > -
> > > > -	instance = pci_get_drvdata(pdev);
> > > > +	struct megasas_instance *instance = dev_get_drvdata(dev);
> > > >  
> > > >  	if (!instance)
> > > >  		return 0;
> > > >  
> > > >  	instance->unload = 1;
> > > >  
> > > > -	dev_info(&pdev->dev, "%s is called\n", __func__);
> > > > +	dev_info(dev, "%s is called\n", __func__);
> > > >  
> > > >  	/* Shutdown SR-IOV heartbeat timer */
> > > >  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
> > > > @@ -7579,7 +7575,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
> > > >  
> > > >  	tasklet_kill(&instance->isr_tasklet);
> > > >  
> > > > -	pci_set_drvdata(instance->pdev, instance);
> > > > +	dev_set_drvdata(dev, instance);
> > > 
> > > It *might* be correct to replace "instance->pdev" with "dev", but it's
> > > not obvious and deserves some explanation.  It's true that you can
> > > replace &pdev->dev with dev, but I don't know anything about
> > > instance->dev.
> 
> Sorry, I meant "instance->pdev" here.
> 
> > > I don't think this change is actually necessary, is it?
> > > "instance->pdev" is still a pci_dev pointer, so pci_set_drvdata()
> > > should work fine. ...
> > > 
> > There is no instance->dev . The 'dev' passed dev_set_drvdata() is
> > same &pdev->dev. 
> 
> Yes, it's true that "dev" here is the same as the "&pdev->dev" we had
> previously.  But we passed "instance->pdev" (not "pdev") to
> pci_set_drvdata().  So the question is whether instance->pdev->dev ==
> dev.
> 
> They *might* be the same, but I don't think it's obvious.
> 
Yes, they are same.
driver/pci/pci-driver.c :
'dev' is passed as parameter to both pci_device_probe() and pci_pm_suspend()
From 'dev', pci_device_probe() extracts "struct pci_dev*" and passes it to the
probe callback of this driver.

In the proble function - megasas_probe_one()
:7347	instance->pdev = pdev;
:7386	pci_set_drvdata(pdev, instance);

The proble function is using "struct pci_dev*" variable "pdev" provided by core
and same we replaced &pdev->dev with "struct device *dev".

So the instance->pdev->dev and 'dev' can only differ if 'dev' passed to
pci_device_probe() and pci_pm_suspend() are different.
> > The dev pointer used here, points to same value.
> > 
> > pci_get_drvdata() and pci_set_drvdata() invoke dev_get_drvdata() and
> > dev_set_drvdata() respectively. And they do nothing else. Seems like
> > additional unnecessary function calls and operations.
