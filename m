Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D50C4743D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 01:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D6F60FF2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 01:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhFIBNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 21:13:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61962 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbhFIBNH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 21:13:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623201074; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hOY4IY8I46gA8MMjH6W8hGdwOQJifP1exL50IuuC0xA=;
 b=qEpKcrvxBEB2dN9925WULspN09L4zp7tXEsaJDH2S76gzyHJTSvO7Zq2JCQz/8ZzXYR6nYFD
 11MFsusCFxYNAd3HXpahJnZ9g66oFw1lFwTOckOE9M3m0GifDHWMyNTglaKa2RTdwbjTpM8e
 tA+GFa5XcGF0gInKoi80P89OYlQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60c0150fe570c0561986610c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Jun 2021 01:10:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7AF14C43460; Wed,  9 Jun 2021 01:10:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8831CC433F1;
        Wed,  9 Jun 2021 01:10:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Jun 2021 09:10:38 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: scsi: ufs: Optimize host lock on transfer requests send/compl
 paths (uninitialized pointer error)
In-Reply-To: <fa66c94c-3df6-3813-dc2d-572cee16071b@canonical.com>
References: <fa66c94c-3df6-3813-dc2d-572cee16071b@canonical.com>
Message-ID: <c723f68d3bfd535ea0c749fc93d06f32@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Colin,

On 2021-06-08 23:44, Colin Ian King wrote:
> Hi,
> 
> static analysis with Coverity on linux-next has found an issue in
> drivers/scsi/ufs/ufshcd.c introduced by the following commit:
> 
> commit a45f937110fa6b0c2c06a5d3ef026963a5759050
> Author: Can Guo <cang@codeaurora.org>
> Date:   Mon May 24 01:36:57 2021 -0700
> 
>     scsi: ufs: Optimize host lock on transfer requests send/compl paths
> 
> The analysis is as follows:
> 
> 
> 2948 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
> 2949                enum dev_cmd_type cmd_type, int timeout)
> 2950 {
> 2951        struct request_queue *q = hba->cmd_queue;
> 2952        struct request *req;
> 
>     1. var_decl: Declaring variable lrbp without initializer.
> 
> 2953        struct ufshcd_lrb *lrbp;
> 2954        int err;
> 2955        int tag;
> 2956        struct completion wait;
> 2957
> 2958        down_read(&hba->clk_scaling_lock);
> 2959
> 2960        /*
> 2961         * Get free slot, sleep if slots are unavailable.
> 2962         * Even though we use wait_event() which sleeps 
> indefinitely,
> 2963         * the maximum wait time is bounded by SCSI request 
> timeout.
> 2964         */
> 2965        req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> 
>     2. Condition IS_ERR(req), taking false branch.
> 
> 2966        if (IS_ERR(req)) {
> 2967                err = PTR_ERR(req);
> 2968                goto out_unlock;
> 2969        }
> 2970        tag = req->tag;
> 
>     3. Condition !!__ret_warn_on, taking false branch.
>     4. Condition !!__ret_warn_on, taking false branch.
> 
> 2971        WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
> 2972        /* Set the timeout such that the SCSI error handler is not
> activated. */
> 2973        req->timeout = msecs_to_jiffies(2 * timeout);
> 2974        blk_mq_start_request(req);
> 2975
> 
>     5. Condition !!test_bit(tag, &hba->outstanding_reqs), taking true
> branch.
> 
> 2976        if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> 2977                err = -EBUSY;
> 
>     6. Jumping to label out.
> 
> 2978                goto out;
> 2979        }
> 2980
> 2981        init_completion(&wait);
> 2982        lrbp = &hba->lrb[tag];
> 2983        WARN_ON(lrbp->cmd);
> 2984        err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
> 2985        if (unlikely(err))
> 2986                goto out_put_tag;
> 2987
> 2988        hba->dev_cmd.complete = &wait;
> 2989
> 2990        ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND,
> lrbp->ucd_req_ptr);
> 2991        /* Make sure descriptors are ready before ringing the
> doorbell */
> 2992        wmb();
> 2993
> 2994        ufshcd_send_command(hba, tag);
> 2995        err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
> 2996 out:
> 
>     7. Condition err, taking true branch.
> 
>     Uninitialized pointer read (UNINIT)
>     8. uninit_use: Using uninitialized value lrbp.
> 
> 2997        ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
> UFS_QUERY_COMP,
> 2998                                    (struct utp_upiu_req
> *)lrbp->ucd_rsp_ptr);
> 2999
> 3000 out_put_tag:
> 3001        blk_put_request(req);
> 3002 out_unlock:
> 3003        up_read(&hba->clk_scaling_lock);
> 3004        return err;
> 3005 }
> 
> Pointer lrbp is being accessed on the error exit path on line 2989
> because it is no longer being initialized early, the pointer assignment
> was moved to a later point (line 2982) by the commit referenced in the
> top of the email.
> 
> Colin

I will fix it by changing "goto out;" -> "goto out_put_tag;" on line 
#2978
in a new patch.

Thanks,
Can Guo.
