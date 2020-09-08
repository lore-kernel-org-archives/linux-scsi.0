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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8A5C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65EC2087C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 17:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3hF/139"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbgIHRHg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbgIHRHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 13:07:18 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1990C061573;
        Tue,  8 Sep 2020 10:07:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so11472012pfa.10;
        Tue, 08 Sep 2020 10:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IOdsYvuedMqs4VETpiys3IXPYNWGiW6l6USeWyBo5Tw=;
        b=E3hF/139sLDHkufkGEuXu0Q9tGnJAuMoinQNyL1/f1M5ITqMHmhy8VOQW9c2ijlO8J
         45LVWXWWXwmRzEu1Iza+SsIpBUD3A5fNtsjLwCbBkhZEUwZm8UCr+w8qucGys/PaARi3
         pHbYGFycwxvRzYFsAmKoyKgpJ5grAaeFAEKms4+JBCyRo3e6ZG40nKDU2bX+O1VRT5qJ
         XqyldHdQVAYlBLqR0zs3qe/bgBGcTxCY+qCbSIX6pzB8jRcJJUNy2YfYRNZUGUbPRzUy
         0U9duWrfBp97BcOKZBa/ht01rj3bCdryAIHmd06RvcfRdWgzeugwOLf8WsMnPq/MI3OQ
         nIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IOdsYvuedMqs4VETpiys3IXPYNWGiW6l6USeWyBo5Tw=;
        b=ScdtPlF0W98ulEBr7ukNTk/8OyqlqQlSPXr/Q76XCbaqK3Qw/JvLw9P83F/kzmBp8Z
         NxjAnFjLcOuo0Qy316vMgfvumehXRUCP4tt/JpDwA0q0F1n0veZTG8ETA74bHd7RLQU7
         498Sa86nBRQZwPDHOst0BAAZ/SJfgp1xEjLNokrSQY6QjBrcAqQwY5PdtTPlCgtGArEy
         BZohH3jMZChnwhiMllUNIWTGZ8VUWS42RVJdsmDFtEf66np8fD8NsCn68VEnz5bmN5K6
         JCeLejtLrIo23ugW/n/v7S3b/9RL42sUd8708qOblA8X6oXFedqH5l9FJZzjtOMSU3uA
         ZT0Q==
X-Gm-Message-State: AOAM532v5+coaNmIOpRvKlnoy7IdVm4dN0KBEEnN8kx2avenZngaQo/V
        qJxXMrOzG5zXWHfuV2QPKHE=
X-Google-Smtp-Source: ABdhPJyBDsUF+MDMugjzk8GWbvb0LDjNE6l8t+6+RE+TZU51ofLulEyHHUkRKBe/RL/viJ9TXboP4Q==
X-Received: by 2002:a62:1648:: with SMTP id 69mr24979230pfw.127.1599584838112;
        Tue, 08 Sep 2020 10:07:18 -0700 (PDT)
Received: from gmail.com ([106.201.26.241])
        by smtp.gmail.com with ESMTPSA id e27sm16517pfj.62.2020.09.08.10.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 10:07:17 -0700 (PDT)
Date:   Tue, 8 Sep 2020 22:35:24 +0530
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
Subject: Re: [PATCH v2 11/15] scsi: hpsa: use generic power management
Message-ID: <20200908170524.GL9948@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
 <20200720133427.454400-12-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-12-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:24PM +0530, Vaibhav Gupta wrote:
> Drivers using legacy PM have to manage PCI states and device's PM states
> themselves. They also need to take care of configuration registers.
> 
> With improved and powerful support of generic PM, PCI Core takes care of
> above mentioned, device-independent, jobs.
> 
> Change function parameter in both .suspend() and .resume() to
> "struct device*" type. The function body remains unchanged as it was empty.
> Also, bind callbacks with "static const struct dev_pm_ops" variable.
> 
> Compile-tested only.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/scsi/hpsa.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 81d0414e2117..70bdd6fe91ee 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -9070,25 +9070,27 @@ static void hpsa_remove_one(struct pci_dev *pdev)
>  	hpda_free_ctlr_info(h);				/* init_one 1 */
>  }
>  
> -static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
> -	__attribute__((unused)) pm_message_t state)
> +static int __maybe_unused hpsa_suspend(
> +	__attribute__((unused)) struct device *dev)
>  {
>  	return -ENOSYS;
>  }
>  
> -static int hpsa_resume(__attribute__((unused)) struct pci_dev *pdev)
> +static int __maybe_unused hpsa_resume
> +	(__attribute__((unused)) struct device *dev)
>  {
>  	return -ENOSYS;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(hpsa_pm_ops, hpsa_suspend, hpsa_resume);
> +
>  static struct pci_driver hpsa_pci_driver = {
>  	.name = HPSA,
>  	.probe = hpsa_init_one,
>  	.remove = hpsa_remove_one,
>  	.id_table = hpsa_pci_device_id,	/* id_table */
>  	.shutdown = hpsa_shutdown,
> -	.suspend = hpsa_suspend,
> -	.resume = hpsa_resume,
> +	.driver.pm = &hpsa_pm_ops,
>  };
>  
>  /* Fill in bucket_map[], given nsgs (the max number of
> -- 
> 2.27.0
> 
.
