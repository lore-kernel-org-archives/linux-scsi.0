Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29301C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 00:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11CEE6128E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 00:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhKQBCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 20:02:08 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:39926 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhKQBCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 20:02:06 -0500
Received: by mail-pg1-f180.google.com with SMTP id r5so686231pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 16:59:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=AOVn4bXQQOUN9C8H285cZe2N//nK29a4jjEZ5Un2KUg=;
        b=r4oMmlPpfHP0KXx1G3ieHITQuSnsh31jBzvb1K/uEf62VjmwROkFxeM1ah4L9U8oby
         IFHWmTftL/8+UDbP7KGSeggILcGz5bBLE62LvRupL0/tmWjQM+JzfmyYyMQBHpxnU1Ak
         NffBe9sbGZ194A0el9bAQ6JRIbuaBJkNVojiSZcoCyhFQZFD87S7yPA9G6CC9MXOoPkx
         +o/cII1q/SHCQmatgGSfT9w4Dt7EIex66tV8e60EW7aO7d1Auc4L3A7bMVBR+LajW/ZP
         m+Ph/Pkc6GQC9T3Y1UYxcoQu0ZE8KTXQjUS3CMa0UG+ubyCEuHY7kHoJne7IvSdvUkQD
         KIQw==
X-Gm-Message-State: AOAM532NiVp8YOc7HyvNX08TSf9rKOVRa6YmmazCVUuoCmtMpDsbo1Hg
        QDeteO2MuakMwMzx9RWaR6orDtbigAI=
X-Google-Smtp-Source: ABdhPJxBXzzVeb92CRHxW9v/+OGvwvWw6unHHcgY1p7wOQcP2C7O0Z1MXQHrbhSBOiwJKQ8/mUkC2g==
X-Received: by 2002:aa7:8717:0:b0:4a2:967c:96b with SMTP id b23-20020aa78717000000b004a2967c096bmr26248444pfo.14.1637110748750;
        Tue, 16 Nov 2021 16:59:08 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y10sm3443821pfg.21.2021.11.16.16.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 16:59:07 -0800 (PST)
Message-ID: <48a85d1c-f776-0c9d-aecb-49b0c94af197@acm.org>
Date:   Tue, 16 Nov 2021 16:59:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: ufs: setting "hba" private pointer too late -- oops in
 ufshcd_devfreq_get_dev_status()
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org
References: <YYvYGBuzZzAuNzxp@localhost.localdomain>
 <831b95a6-c097-9425-a6a8-cc599a14614c@acm.org>
 <YY184y876Ghm+7Ly@localhost.localdomain>
Content-Language: en-US
In-Reply-To: <YY184y876Ghm+7Ly@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 12:28, Alexey Dobriyan wrote:
> Not really, my workaround is
> 
> 	if (!hba) {
> 		return -EINVAL;
> 	}
> 
> But it is likely incorrect.

How about the untested patch below?

Thanks,

Bart.

---
  drivers/scsi/ufs/tc-dwc-g210-pci.c | 1 -
  drivers/scsi/ufs/ufshcd-pci.c      | 2 --
  drivers/scsi/ufs/ufshcd-pltfrm.c   | 2 --
  drivers/scsi/ufs/ufshcd.c          | 7 +++++++
  4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 679289e1a78e..7b08e2e07cc5 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -110,7 +110,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  		return err;
  	}

-	pci_set_drvdata(pdev, hba);
  	pm_runtime_put_noidle(&pdev->dev);
  	pm_runtime_allow(&pdev->dev);

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 51424557810d..a673eedb2f05 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -522,8 +522,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  		return err;
  	}

-	pci_set_drvdata(pdev, hba);
-
  	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;

  	err = ufshcd_init(hba, mmio_base, pdev->irq);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index eaeae83b999f..8b16bbbcb806 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -361,8 +361,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
  		goto dealloc_host;
  	}

-	platform_set_drvdata(pdev, hba);
-
  	pm_runtime_set_active(&pdev->dev);
  	pm_runtime_enable(&pdev->dev);

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a7a8d3fbb89d..87b8bd837342 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9608,6 +9608,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
  	 */
  	mb();

+	/*
+	 * dev_set_drvdata() must be called before
+	 * async_schedule(ufshcd_async_scan, hba) since the callbacks registered
+	 * with the devfreq framework use dev_get_drvdata().
+	 */
+	dev_set_drvdata(dev, hba);
+
  	/* IRQ registration */
  	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
  	if (err) {
