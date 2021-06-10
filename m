Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9D1C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 00:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F9A61182
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 00:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhFJA4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 20:56:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35265 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFJA4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 20:56:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623286491; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IRiJ5K8YisVDKjZxsTxSkq8Yob/1/IJG4BZVkroF3gA=;
 b=Mq0YTIz5QH5vT2iuAINxCi7/YB+HQVt4mV3lwkghP28haafG5j6iUFGetCeIHsFQmJVxW25e
 p8SA+GBMI4p/mzLlXavmv+RkFO32tlySCfUIoyz0uDT6tCRw1XeV8rw8xCA3iOWsyi48xr7w
 aYd/e49K+kLMgghGNoBuYrufMIQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60c162c7f726fa418886d525 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Jun 2021 00:54:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 680CCC433D3; Thu, 10 Jun 2021 00:54:30 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24325C433F1;
        Thu, 10 Jun 2021 00:54:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Jun 2021 08:54:29 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
In-Reply-To: <YMCfbSj7Ui+fzi2N@mwanda>
References: <YMCfbSj7Ui+fzi2N@mwanda>
Message-ID: <6158235591271fe789dd86f76b360145@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,

On 2021-06-09 19:01, Dan Carpenter wrote:
> Hello Can Guo,
> 
> The patch a45f937110fa: "scsi: ufs: Optimize host lock on transfer
> requests send/compl paths" from May 24, 2021, leads to the following
> static checker warning:
> 
> 	drivers/scsi/ufs/ufshcd.c:2998 ufshcd_exec_dev_cmd()
> 	error: potentially dereferencing uninitialized 'lrbp'.
> 

I uploaded a fix yesterday - 
https://lore.kernel.org/patchwork/patch/1443774/
Thanks for reporting it and sorry for the disturb.

Regards,
Can Guo.

> drivers/scsi/ufs/ufshcd.c
>   2948  static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   2949                  enum dev_cmd_type cmd_type, int timeout)
>   2950  {
>   2951          struct request_queue *q = hba->cmd_queue;
>   2952          struct request *req;
>   2953          struct ufshcd_lrb *lrbp;
>                                    ^^^^
> 
>   2954          int err;
>   2955          int tag;
>   2956          struct completion wait;
>   2957
>   2958          down_read(&hba->clk_scaling_lock);
>   2959
>   2960          /*
>   2961           * Get free slot, sleep if slots are unavailable.
>   2962           * Even though we use wait_event() which sleeps 
> indefinitely,
>   2963           * the maximum wait time is bounded by SCSI request 
> timeout.
>   2964           */
>   2965          req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>   2966          if (IS_ERR(req)) {
>   2967                  err = PTR_ERR(req);
>   2968                  goto out_unlock;
>   2969          }
>   2970          tag = req->tag;
>   2971          WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>   2972          /* Set the timeout such that the SCSI error handler is
> not activated. */
>   2973          req->timeout = msecs_to_jiffies(2 * timeout);
>   2974          blk_mq_start_request(req);
>   2975
>   2976          if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>   2977                  err = -EBUSY;
>   2978                  goto out;
>                         ^^^^^^^^
> 
>   2979          }
>   2980
>   2981          init_completion(&wait);
>   2982          lrbp = &hba->lrb[tag];
> 
> This used to be initialized before the goto
> 
>   2983          WARN_ON(lrbp->cmd);
>   2984          err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>   2985          if (unlikely(err))
>   2986                  goto out_put_tag;
>   2987
>   2988          hba->dev_cmd.complete = &wait;
>   2989
>   2990          ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND,
> lrbp->ucd_req_ptr);
>   2991          /* Make sure descriptors are ready before ringing the
> doorbell */
>   2992          wmb();
>   2993
>   2994          ufshcd_send_command(hba, tag);
>   2995          err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>   2996  out:
>   2997          ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
> UFS_QUERY_COMP,
>   2998                                      (struct utp_upiu_req
> *)lrbp->ucd_rsp_ptr);
> 
> ^^^^^^^^^^^^^^^^^
> 
>   2999
>   3000  out_put_tag:
>   3001          blk_put_request(req);
>   3002  out_unlock:
>   3003          up_read(&hba->clk_scaling_lock);
>   3004          return err;
>   3005  }
> 
> regards,
> dan carpenter
