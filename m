Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABE2C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3AC20829
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByO3yBfH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHQILd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgHQILW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:11:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AB9C061388;
        Mon, 17 Aug 2020 01:11:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s15so7747482pgc.8;
        Mon, 17 Aug 2020 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrc3902/LyjUToaP0T6jczt+Dazk6Byup+Z2y7wGrvo=;
        b=ByO3yBfHuC8Oi3Go9E9JvdznzILTxNU0krXeVns4vevfXHOBzuW8RUC5nPT1Inugth
         EkTLvMFjz9X8Y6qU1Hn2S2f2o1ZjPcTvmc/XO9CMb23IP7QMwR5ThDVv7DJR8gUym87Z
         86TFejRu2JpzV/DNekTLCyl/dYZyduvNe2bvE2YaklYM9x/ZweDQE25z7ZVAuzZnmU3S
         oaiF+2jKHvJvSqXj8jp2DPFVL24k9YUu2S4t5flwPCfY4YLLFWV8rPiYLIT5B+maHsfJ
         5YHP/fNZbAvAG8dyEv+2YSMbf1Ow2mGXtNWmxoOrS8mXzxbY3mT0GE1j6xWlabFlzJcz
         RmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrc3902/LyjUToaP0T6jczt+Dazk6Byup+Z2y7wGrvo=;
        b=MjofrUaN3QLgfI4+omGjRYs7cQQQgaqqDManvmoMYqNC+zTAGuoxGb9bIsWLYnwSs4
         McxbkH8xcrmaQQjT8ZKa1YhG22JwqwjhdGbDw2GZaCPEB1Mhu+v0S6Grl6sdUHf8i/Kb
         9P1V5jIcvBBXLvHbnz+hJy4r5jHtRRWr0EcbTM2XCJ9gaeazbEwipJEYm0GGAHgHnKCA
         udRW320qhNRQeCr6Z1ULe7b9Uh80m4vel4NsX6sQ0YCMvcTtI9NRWu4VAvrchCIfXVAW
         UqOrEa28juedWiSSIC5oy/c01zLHRwgY1EwRYJYeVWrTGjwcPsc/Rz/d6JKHQZ3JlTu0
         9Thw==
X-Gm-Message-State: AOAM532GSvz/RMIuKLH2F8JxyB+mSckfgtdX0RCc5SW2z/uYyrJYj2Mm
        eN/Vg/55LJ9z/YjZdkj1/ME=
X-Google-Smtp-Source: ABdhPJz2ABg60O1CErb8rgafu1jP+kelkm+BlAsIdvNS3iUNr1AU3yojduJMCSyCTuDNrAKMq3eQ1Q==
X-Received: by 2002:a05:6a00:790:: with SMTP id g16mr10469418pfu.312.1597651882145;
        Mon, 17 Aug 2020 01:11:22 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id g7sm16961220pjj.2.2020.08.17.01.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:11:21 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:39:45 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2] scsi: stex: use generic power management
Message-ID: <20200817080945.GG5869@gmail.com>
References: <20200730101658.576205-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200730101658.576205-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 30, 2020 at 03:46:58PM +0530, Vaibhav Gupta wrote:
> Drivers using legacy power management .suspen()/.resume() callbacks
> have to manage PCI states and device's PM states themselves. They also
> need to take care of standard configuration registers.
> 
> Switch to generic power management framework using a single
> "struct dev_pm_ops" variable to take the unnecessary load from the driver.
> This also avoids the need for the driver to directly call most of the PCI
> helper functions and device power state control functions, as through
> the generic framework PCI Core takes care of the necessary operations,
> and drivers are required to do only device-specific jobs.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/stex.c | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index d4f10c0d813c..5ef6f3cbac11 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1972,9 +1972,9 @@ static int stex_choice_sleep_mic(struct st_hba *hba, pm_message_t state)
>  	}
>  }
>  
> -static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int stex_suspend_late(struct device *dev, pm_message_t state)
>  {
> -	struct st_hba *hba = pci_get_drvdata(pdev);
> +	struct st_hba *hba = dev_get_drvdata(dev);
>  
>  	if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
>  		&& hba->supports_pm == 1)
> @@ -1984,9 +1984,24 @@ static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
>  	return 0;
>  }
>  
> -static int stex_resume(struct pci_dev *pdev)
> +static int __maybe_unused stex_suspend(struct device *dev)
>  {
> -	struct st_hba *hba = pci_get_drvdata(pdev);
> +	return stex_suspend_late(dev, PMSG_SUSPEND);
> +}
> +
> +static int __maybe_unused stex_hibernate(struct device *dev)
> +{
> +	return stex_suspend_late(dev, PMSG_HIBERNATE);
> +}
> +
> +static int __maybe_unused stex_freeze(struct device *dev)
> +{
> +	return stex_suspend_late(dev, PMSG_FREEZE);
> +}
> +
> +static int __maybe_unused stex_resume(struct device *dev)
> +{
> +	struct st_hba *hba = dev_get_drvdata(dev);
>  
>  	hba->mu_status = MU_STATE_STARTING;
>  	stex_handshake(hba);
> @@ -2000,14 +2015,24 @@ static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
>  }
>  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
>  
> +static const struct dev_pm_ops stex_pm_ops = {
> +#ifdef CONFIG_PM_SLEEP
> +	.suspend	= stex_suspend,
> +	.resume		= stex_resume,
> +	.freeze		= stex_freeze,
> +	.thaw		= stex_resume,
> +	.poweroff	= stex_hibernate,
> +	.restore	= stex_resume,
> +#endif
> +};
> +
>  static struct pci_driver stex_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= stex_pci_tbl,
>  	.probe		= stex_probe,
>  	.remove		= stex_remove,
>  	.shutdown	= stex_shutdown,
> -	.suspend	= stex_suspend,
> -	.resume		= stex_resume,
> +	.driver.pm	= &stex_pm_ops,
>  };
>  
>  static int __init stex_init(void)
> -- 
> 2.27.0
> 
