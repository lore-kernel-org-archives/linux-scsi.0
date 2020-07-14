Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254F7C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A7B720890
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGNDlx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:41:53 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36905 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgGNDlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 23:41:53 -0400
Received: by mail-pj1-f67.google.com with SMTP id o22so884210pjw.2;
        Mon, 13 Jul 2020 20:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FIkoYpJoY156GHlaAk/Z9PrJ8CxCxosbs70run2YrjM=;
        b=nJS6RLlihVTrdRIr5nFAJUTDBXqio16yilTPkLc2Bp8bqTekx0ob9iuRmkl2zMVnIi
         2WKIKcATTG9QsPdrS7ZXCUWzPjllfl4su7gR0jBuLztx8LraBw6N283/Dta9VnfdfpFB
         hP3sbe4C/Jo75jvVEQ3ErECwj2Mmxe0wuQX69L8cHKsY6i4tQltOjQNipa+Pghyhg7B4
         myNDjtrxsPx03cskVhG4A5TyDYtEeWfiHEFddxv8mhgh2mzbflFN9nv48Hd1QAD71km5
         63gLSzgQAnpXODZj71I/5kCyyIwOVB9nzstL55vlWnhUAd3FzhHfI7hUL8xL8Zi8kRLV
         sJGA==
X-Gm-Message-State: AOAM532oCwdHYrXi7uvvl5Lxik30Qch6eyoON3oEBWGAdA75nM5E/ycd
        Tf66kg6u96xDw4FFYYkoCi/o3IK4
X-Google-Smtp-Source: ABdhPJzV0zDlFgGwGnecA8mDKdz1bBhuAchtA+8ZGU5FLtvGqIRgsog41df9pB3T3jZp/n6J7DC7Wg==
X-Received: by 2002:a17:90a:d3d7:: with SMTP id d23mr2479430pjw.232.1594698111736;
        Mon, 13 Jul 2020 20:41:51 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x3sm15749338pfn.154.2020.07.13.20.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 20:41:50 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] scsi: ufs: Fix imbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
 <1594693693-22466-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <5470be4c-cfa4-ebe5-a817-e53f26c7eaf6@acm.org>
Date:   Mon, 13 Jul 2020 20:41:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594693693-22466-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-13 19:28, Can Guo wrote:
> The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
> decreased back in ufshcd_ungate_work() in a paired way. However, if
> specific ufshcd_hold/release sequences are met, it is possible that
> scsi_block_reqs_cnt is increased twice but only one ungate work is
> queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() and
> ufshcd_ungate_work() in a paired way, increase it only if queue_work()
> returns true.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ebf7a95..33214bb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1611,12 +1611,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		 */
>  		/* fallthrough */
>  	case CLKS_OFF:
> -		ufshcd_scsi_block_requests(hba);
>  		hba->clk_gating.state = REQ_CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
> -		queue_work(hba->clk_gating.clk_gating_workq,
> -			   &hba->clk_gating.ungate_work);
> +		if (queue_work(hba->clk_gating.clk_gating_workq,
> +			       &hba->clk_gating.ungate_work))
> +			ufshcd_scsi_block_requests(hba);
>  		/*
>  		 * fall through to check if we should wait for this
>  		 * work to be done or not.

Since "ungate_work" involves calling ufshcd_scsi_unblock_requests() and
since this patch changes the order in which ufshcd_scsi_block_requests()
and queue_work() are called, I think this patch introduces a race
condition. Has it been considered to leave the ufshcd_scsi_block_requests()
call where it is and to call ufshcd_scsi_unblock_requests() if
queue_work() fails?

Thanks,

Bart.


