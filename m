Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E10FC2D0BF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0FE4206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLPRjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 12:39:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:42561 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfLPRjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 12:39:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id o11so3273841pjp.9;
        Mon, 16 Dec 2019 09:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GAc742TonjZK6ZRxRus2d4c7ISXJOCiXeWdsz7woKMk=;
        b=hXKb4kC3sF/z6xC09YeqWx+yKdozq1VG300IAYN5ZeLIg8KCLuXU6EOw0K1T3HJpAE
         wNmOtthd6pQi6t3C2chuFMzl5sv5ZM9KBVI1Acx2o4xE4bfPrKVMPtgf905E+tO1STuX
         rUHBctl4CGuOyJhyQldbJKaRouEq30CO2bQxyAJJ/9HQ961zJSMscSxmF3ACPSkdfVy0
         JYWfV+1tjdktV9e7NtSqP+r8GtKr3h6pko3TVctGPqh7pYLqpgsJadv2B9x70zAy3P8K
         589xf+6PzVQzjdmHgLpa8I454F6yW3jP76n+2Yj7blXjxK0Bg1g8B/DRhZ2r9wpHYyLk
         SSwA==
X-Gm-Message-State: APjAAAV+GYgSBUQuOh+hz+dVPtsBQGw88BMMwt6D6gGqmz/q8NQvubu0
        lwfppIksjKpaIk24TUp134LgAZW69+0=
X-Google-Smtp-Source: APXvYqyEDmrntW66IBtNafJyXSYOxZ/3UEVWMFZFf4MtqKJAJOK+JRyBYqfiylm8i0Nmkz98dUCldA==
X-Received: by 2002:a17:902:d907:: with SMTP id c7mr17395567plz.40.1576517963039;
        Mon, 16 Dec 2019 09:39:23 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 78sm22630854pfu.65.2019.12.16.09.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 09:39:22 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
To:     cang@codeaurora.org
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cf4915df-5ae4-0dfd-5d44-1fe959d141e2@acm.org>
Date:   Mon, 16 Dec 2019 09:39:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/19 6:31 AM, cang@codeaurora.org wrote:
> As SCSI host is allocated in ufshcd_platform_init() during platform
> drive probe, it is much more appropriate if platform driver calls
> ufshcd_dealloc_host() in their own drv->remove() path. How do you
> think if I change it as below? If it is OK to you, please ignore my
> previous mails.
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3d4582e..ea45756 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct platform_device 
> *pdev)
> 
>          pm_runtime_get_sync(&(pdev)->dev);
>          ufshcd_remove(hba);
> +       ufshcd_dealloc_host(hba);
>          return 0;
>   }

Hi Can,

Apparently some UFS drivers call ufshcd_remove() only and others (PCIe) 
call both ufshcd_remove() and ufshcd_dealloc_host(). I think that the 
above change will cause trouble for the PCIe driver unless the 
ufshcd_dealloc_host() call is removed from ufshcd_pci_remove().

Thanks,

Bart.
