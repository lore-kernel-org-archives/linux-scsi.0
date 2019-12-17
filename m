Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8945C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82C12072D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfLQBQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 20:16:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39558 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQBQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 20:16:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so6589377pfx.6;
        Mon, 16 Dec 2019 17:16:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lnFICRRWvqMlfifCfXqW5y21+lbROw+2Gffyp/oXtz4=;
        b=qi7YjEbYobMbLF/YMVNolzxw/hZeuoGqqpOokg4Pvodm28fSyTfYLVVVchcAAx1OKF
         ETD0X8hilxjKqlTnMubqb5B9UM/BS5LQG2Jiwqk9aYdxJ0+9jYrvCtu9ekJ0Bd22SPtE
         JmZLgNanr+HmNyeFDVui/h+Me4iwXGhPAVqe5cqkUtVCrasCWahgUhbA2WvQZ8ioZtWx
         MwRCnHRV/hPXQIDDNKwZf6LDJtj+1JRGifcucmT3ytqsSH7nXZL8cj16pNy6A/CrLUBd
         dE2goLEWqG61S8PhemshOVUngNiVV046b5WgnwLOddpOVcp/1WTOOfyB2oolJUQ1QxFG
         965g==
X-Gm-Message-State: APjAAAU0ZFKz1mb4gq5Ctx5pcUi/pMFfjaFHExb50WKKNNiQfyeoHKb0
        IJEDkXGDfSB7sgL8CutvcBrsb6Ftqig=
X-Google-Smtp-Source: APXvYqw22fD1K1guuhtGxO8ryny+Pns/FUQdlNF9Mvb4TN+NZjxaaTEI5kB/FiWj3zZWZZmdo7joMQ==
X-Received: by 2002:a62:5547:: with SMTP id j68mr20166456pfb.6.1576545359890;
        Mon, 16 Dec 2019 17:15:59 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 129sm24020918pfw.71.2019.12.16.17.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 17:15:58 -0800 (PST)
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
 <cf4915df-5ae4-0dfd-5d44-1fe959d141e2@acm.org>
 <0343644f49adee06e6b2f3f631fe1637@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ecef25b7-44c0-6b94-c429-6ee5f9508caf@acm.org>
Date:   Mon, 16 Dec 2019 17:15:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0343644f49adee06e6b2f3f631fe1637@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/19 4:46 PM, cang@codeaurora.org wrote:
> On 2019-12-17 01:39, Bart Van Assche wrote:
>> Apparently some UFS drivers call ufshcd_remove() only and others
>> (PCIe) call both ufshcd_remove() and ufshcd_dealloc_host(). I think
>> that the above change will cause trouble for the PCIe driver unless
>> the ufshcd_dealloc_host() call is removed from ufshcd_pci_remove().
>
> You may get me wrong. I mean we should do like what ufshcd-pci.c does.
> As driver probe routine allocates SCSI host, then driver remove() should
> de-allocate it. Meaning ufs_qcom_remove() should call both ufshcd_remove()
> and ufshcd_dealloc_host().
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3d4582e..ea45756 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct platform_device 
> *pdev)
> 
>            pm_runtime_get_sync(&(pdev)->dev);
>            ufshcd_remove(hba);
>   +       ufshcd_dealloc_host(hba);
>            return 0;
>     }

Hi Can,

If it is possible to move the ufshcd_dealloc_host() into ufshcd_remove() 
then I would prefer to do that. If all UFS transport drivers need that 
call then I think that call should happen from the UFS core instead of 
from the transport drivers.

Thanks,

Bart.
