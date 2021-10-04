Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640ABC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41675613AC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhJDQyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 12:54:41 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33661 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbhJDQyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 12:54:40 -0400
Received: by mail-pg1-f180.google.com with SMTP id a73so14193795pge.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 09:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uL9XUKQ5GuuLCnruZsHJYrq6oODtVyV7Cb+1b8Y8MxA=;
        b=eCzFtCRDEuiCVINB1Kn8Api4vMrvoBpJthw8ne/aIW+ocMRBdEGPdysh96oAVLPnu4
         UyP3bJGN7HDrq6bc/4KHS+M1Yta1oxOZlm3foKftUgR95PpUr1mNio8viBnxRRpePjbt
         2Rht/KYbismqMCs86BIWaVVFXoZOMJT2EKeLqkVAFy78qyhKxujHshsR4H/HEpjXcthm
         +w/+nw92fMA8jG28/RW4FjcqVdDaJwf7LafOhXi+bDf8P0iiHktvIjQxU/xi5CXKUkDR
         8AttY2k0K83KkreJp/MCXSY+XVplKGCYyfXfrklEV5g0nA8Ob8+dfWBkV9Nf19byy/Yb
         wQyw==
X-Gm-Message-State: AOAM5327CEvKNGkazqqMsm6xb7Z/VEJV0JqdCyCB6SveYvduWrdyq5UV
        +JAKgtv1aPndwwYgCkNb1zPXdR/+u4M=
X-Google-Smtp-Source: ABdhPJx5UbdBrJioMl0I+bJUhFcCX4tLi8XleEuJGG54lgL+4NMpABafV8tRjv2CrGq0fljbfXLKjg==
X-Received: by 2002:aa7:92d2:0:b0:44b:566e:ec5 with SMTP id k18-20020aa792d2000000b0044b566e0ec5mr25754479pfa.30.1633366371091;
        Mon, 04 Oct 2021 09:52:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:1e3d:a218:87c6:1612])
        by smtp.gmail.com with ESMTPSA id t3sm15042590pgo.51.2021.10.04.09.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:52:50 -0700 (PDT)
Subject: Re: [PATCH RFC 2/6] scsi: ufs: Rename clk_scaling_lock to host_rw_sem
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211004120650.153218-1-adrian.hunter@intel.com>
 <20211004120650.153218-3-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <453b33d4-4e53-3b31-ef9a-3a63989de7a8@acm.org>
Date:   Mon, 4 Oct 2021 09:52:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004120650.153218-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/21 5:06 AM, Adrian Hunter wrote:
> To fit its new purpose as a more general purpose sleeping lock for the
> host.
> 
> [ ... ]
 >
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 9b1ef272fb3c..495e1c0afae3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -897,7 +897,7 @@ struct ufs_hba {
>   	enum bkops_status urgent_bkops_lvl;
>   	bool is_urgent_bkops_lvl_checked;
>   
> -	struct rw_semaphore clk_scaling_lock;
> +	struct rw_semaphore host_rw_sem;
>   	unsigned char desc_size[QUERY_DESC_IDN_MAX];
>   	atomic_t scsi_block_reqs_cnt;

Hi Adrian,

It seems to me that this patch series goes in another direction than the
direction the JEDEC UFS committee is going into. The UFSHCI 4.0 specification
will support MCQ (Multi-Circular queue). We will benefit most from the v4.0
MCQ support if there is no contention between the CPUs that submit UFS commands
to different queues. I think the intention of this patch series is to make a
single synchronization object protect all submission queues. I'm concerned that
this will prevent to fully benefit from multiqueue support. Has it been
considered to eliminate the clk_scaling_lock and instead to use RCU to
serialize clock scaling against command processing? One possible approach is to
use blk_mq_freeze_queue() and blk_mq_unfreeze_queue() around the clock scaling
code. A disadvantage of using RCU is that waiting for an RCU grace period takes
some time - about 10 ms on my test setup. I have not yet verified what the
performance and time impact would be of using an expedited RCU grace period
instead of a regular RCU grace period.

Bart.
