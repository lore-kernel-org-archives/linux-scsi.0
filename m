Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD436C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 15:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B1861B95
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 15:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhKOQBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 11:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbhKOQBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 11:01:18 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CCDC061570
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 07:58:20 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r8so31586939wra.7
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 07:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0ouopwxSXQ/hEp1sLQ5ldpycqB4AfTED46SpVzEvLms=;
        b=dPz5a7Zyka+oSxiKMuLvWkC4y8hkEJUOgmI1XAehL7+Q5L6ncDQ8rryKOB+L4SdXxK
         ZAo8V9SA6vvdmGUDhTT15iRNGoR9DZaarQLfhUF1bUFJC3TPDR51lYiXEAH4Eq0rwm9D
         UuExHBZ9/pVe4xLBBH4EzAgOyG+cLcVJk1bztuLigPiXJPS5fppH1i1dYgDqL/o8He+S
         pLTfKeJNhWg8ssqz0Xtp38Ju8WdzEihPi/kcJNiWqt5on8Jgmg7fWe3vO8lqaEpOiK6n
         idt0kR5aG8EqQMfciP+q8vLNN6SG+6DDe/S8DNaAYvIDMoHtaa7FKZdKm0vMXepCG9xt
         zEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0ouopwxSXQ/hEp1sLQ5ldpycqB4AfTED46SpVzEvLms=;
        b=yGRO1Q+m+fFmy0HviodtSLsnl7e4odboOPGsFav7mFBCvfIg9Ke1VtO0dLV7xA0ueb
         OyzZr8o+NguTneR064ibd43ty9XukACLbeH61XxTaAucih4NiI7KeVkfVvCS3kS3w7vL
         sy8ZVjML5Ze6VIn6XYN5P+0ot+icDUIqAliQ+vBYTzIiz7K8fhPs4wknvIQkjj8coxcj
         O2YvElEWDhGMuszhrQNqQmuph5v1g07s8jDCfcrj9cLlfSx2hXInXALwAW6hJ9H9rnyJ
         wRe0li/pGpWznJ/A6GTYJ3Gm+xxdnyrt5+yCL5RGZTulZ684JcCp7DmbaP85A6krG+4E
         W5Hg==
X-Gm-Message-State: AOAM53224zlspElDZW8Ej7InTryGGwqRrvRXmxJZ/MxzgTJUPDcI+zW+
        vyHxDlHc7Kv+NyEQU9BbMfo=
X-Google-Smtp-Source: ABdhPJwtbsPIDxhLVnWCM9SJdCP0JaA++2eYtdCe1RpFYbmdG95nwH90PhpyT7Zrtz4nBnW6s5PkWg==
X-Received: by 2002:a5d:6510:: with SMTP id x16mr88165wru.2.1636991898765;
        Mon, 15 Nov 2021 07:58:18 -0800 (PST)
Received: from p200300e94719c9aa08ae94a3b71b78ed.dip0.t-ipconnect.de (p200300e94719c9aa08ae94a3b71b78ed.dip0.t-ipconnect.de. [2003:e9:4719:c9aa:8ae:94a3:b71b:78ed])
        by smtp.googlemail.com with ESMTPSA id t9sm15659122wrx.72.2021.11.15.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 07:58:18 -0800 (PST)
Message-ID: <2db9f0ab3c1e280a3410af6ccb5f78094b7d092d.camel@gmail.com>
Subject: Re: [PATCH 04/11] scsi: ufs: Remove dead code
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Mon, 15 Nov 2021 16:58:17 +0100
In-Reply-To: <20211110004440.3389311-5-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
         <20211110004440.3389311-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-09 at 16:44 -0800, Bart Van Assche wrote:
> Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating
> tag
> conflicts") guarantees that 'tag' is not in use by any SCSI command.
> Remove the check that returns early if a conflict occurs.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dff76b1a0d5d..312e8a5b7733 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6724,11 +6724,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	tag = req->tag;
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>  
> -	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
>  	lrbp = &hba->lrb[tag];
>  	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
> @@ -6796,7 +6791,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
> UFS_QUERY_COMP,
>  				    (struct utp_upiu_req *)lrbp-
> >ucd_rsp_ptr);
>  
> -out:
>  	blk_put_request(req);

Hi Bart,

Doesn't it need to be paired with blk_get_request()?
Kind regards,
Bean

>  out_unlock:
>  	up_read(&hba->clk_scaling_lock);

