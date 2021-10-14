Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E119C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A7E611CC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 19:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJNTUc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 15:20:32 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35664 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhJNTUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 15:20:31 -0400
Received: by mail-pl1-f177.google.com with SMTP id w14so4840240pll.2
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 12:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=960KJBY6pbvTz3kJaLIJsCEHhF2aYHUBagjLvCgOM/c=;
        b=r3Qy+Q6h9VQwq1ysRXkgHixnJeEFkmEqnq8TCySaci5L4GyWi58KPqc6/NsRQ8IyBR
         PuRmXeJhLmxvBtN9ah4cHA6s5xxtS+hwtiHOV+EzTF06m9yz0tSNlXiVXntb09jdehrK
         dGZf8NZK+7mwhZBwebINAzI9updeY+ncZSRt/ab5xLzwPnBaLVV7MzZujDvnl0k+DbxW
         iP1EfcpGcpiP4vTphNSXhQcbehMZIskfPPXOQwh0iNa/hdrcAymuZb7PCMqdCdTXKg34
         TygAc6JA3aN/j3VEZTKAPq+if/n4H0gZaJx4URMm05x2p6XhYmd8TVffD+yQpBOOxEIo
         uluQ==
X-Gm-Message-State: AOAM532aCTACd0tWRG4n0U9trlZXbdPJB5SkwD+T8VjCupUXoD4e1Jhu
        OrxadGqFHdbxaGnvJUqhc43gPG7Iu8c=
X-Google-Smtp-Source: ABdhPJznvpNmV6z+e6lr8IUZIw+88EFgfnIZOiQsI3VKpN0Vd0C+PTsbKVPXzJ8ElVuYfL6XK4cd4Q==
X-Received: by 2002:a17:903:24c:b0:13f:2377:ef3a with SMTP id j12-20020a170903024c00b0013f2377ef3amr6825527plh.59.1634239105443;
        Thu, 14 Oct 2021 12:18:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:689a:4b1f:cd10:549b])
        by smtp.gmail.com with ESMTPSA id r7sm3120753pff.112.2021.10.14.12.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 12:18:24 -0700 (PDT)
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix task management completion
 timeout race
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211013150116.31158-1-adrian.hunter@intel.com>
 <20211013150116.31158-2-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <123298f1-13de-9201-ded7-575d00286fd1@acm.org>
Date:   Thu, 14 Oct 2021 12:18:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013150116.31158-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 8:01 AM, Adrian Hunter wrote:
> __ufshcd_issue_tm_cmd() clears req->end_io_data after timing out,
> which races with the completion function ufshcd_tmc_handler() which
> expects req->end_io_data to have a value.
> 
> Note __ufshcd_issue_tm_cmd() and ufshcd_tmc_handler() are already
> synchronized using hba->tmf_rqs and hba->outstanding_tasks under the
> host_lock spinlock.
> 
> It is also not necessary (nor typical) to clear req->end_io_data because
> the block layer does it before allocating out requests e.g. via
> blk_get_request().
> 
> So fix by not clearing it.
> 
> Fixes: f5ef336fd2e4c3 ("scsi: ufs: core: Fix task management completion")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 95be7ecdfe10..f34b3994d1aa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6550,11 +6550,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>   	err = wait_for_completion_io_timeout(&wait,
>   			msecs_to_jiffies(TM_CMD_TIMEOUT));
>   	if (!err) {
> -		/*
> -		 * Make sure that ufshcd_compl_tm() does not trigger a
> -		 * use-after-free.
> -		 */
> -		req->end_io_data = NULL;
>   		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
>   		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
>   				__func__, tm_function);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
