Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873C9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF93610E5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 04:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhJNEQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 00:16:19 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45805 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 00:16:19 -0400
Received: by mail-pg1-f175.google.com with SMTP id f5so4291524pgc.12
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 21:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wdUlcI5xG7df+DxSQuJFk+AS2APitc44ae8L4MBm6ec=;
        b=HceYj79x6/BiUJ0XYainrHCtwNbank9482iMOempwBhdbY5HO5Os1p3R+QL4ZqY9xX
         g/442Lu2/Z9TiqR0Z3i9dNrxVjJ9nqLdu+YZbp9nleI/nVTTxtH2aa2KgW/vff+XSPMU
         aB1bNyMEc61y8GnbJgo+JIfb8t6+TZFjXSMnhi7v7eam62YJZRFEv78BZDfKR6btJ3gd
         m4RUb5HXBmTZ50c+VvqYiFCIjtHqizAQ0y8dKJf6gKCDGGUCR5WZtAxMnwPXnVSfitn+
         H5s652w5KQVTN5Cj59UIqY540TMu4NbPpfvPAYfdmxQ+CyoUQh8SxasgZWoklb6V8t0T
         Ymig==
X-Gm-Message-State: AOAM531guNy1f2NtVfpX0mjBiIy+gIrJV5JTrX7TirWWxmdFlI3GlTC5
        nNF+NZM8auhn5VddVZOFd1w=
X-Google-Smtp-Source: ABdhPJymvsyDWlpURCi/WHbTnJyY8IDxnysTixNjqVn6i4iLoPRAGmRTBrUVREXqE5sFllVUsKsz2Q==
X-Received: by 2002:a63:4d56:: with SMTP id n22mr2560623pgl.414.1634184854564;
        Wed, 13 Oct 2021 21:14:14 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cb9c:9f45:498e:cfd1? ([2601:647:4000:d7:cb9c:9f45:498e:cfd1])
        by smtp.gmail.com with ESMTPSA id t2sm7391151pjf.1.2021.10.13.21.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 21:14:13 -0700 (PDT)
Message-ID: <40259621-aac4-e69f-c230-6376bf4d3e36@acm.org>
Date:   Wed, 13 Oct 2021 21:14:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix task management completion
 timeout race
Content-Language: en-US
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
In-Reply-To: <20211013150116.31158-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 08:01, Adrian Hunter wrote:
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

With this patch applied ufshcd_tmc_handler() can trigger a 
use-after-free of the stack memory used for the 'wait' completion. 
Wouldn't it be better to keep the code that clears req->end_io_data and 
to change complete(c) into if(c) complete(c) in ufshcd_tmc_handler()?

Thanks,

Bart.


