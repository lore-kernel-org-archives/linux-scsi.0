Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BD6C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55A52236F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhICrb4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgKTHdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 02:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgKTHdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 02:33:49 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA76C0613CF;
        Thu, 19 Nov 2020 23:33:49 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 62so6569870pgg.12;
        Thu, 19 Nov 2020 23:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=8gfIqp75jBaHwM9ig5NTmcWFQ7CyTISNjc38HowJMQI=;
        b=WhICrb4jK/3I1hYJwBkeWR73xyOGuKmcTMmVEYCu9r2iFfy9dqoA07IIvtkwNq3Cl7
         rdIKfaBnegroG5q27rsP1InhcIYEgMJgoZ2rek2r95TC242r1AMJca10lfrXMGfNu9j1
         AhYM63USaDdyPXBC/j48Hlr1wcDLyGou65FCxdX2tfqWjjnsSQOE3cTbXEfzLrlwJwN9
         HEav04g3xdI3okbLsdXFz0JXsudQAySU/p4yNN0hUWzHJEQPx3VMnqe+JeH2FBERqPki
         gWu+Ii/vL/OK7r50ZBZI7Y2x5xVQrkgH9Wh5VRmW0hAmnae3oa2aateWaA0MfHOp0cLP
         8pTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=8gfIqp75jBaHwM9ig5NTmcWFQ7CyTISNjc38HowJMQI=;
        b=RzNIQ5LPYeISO4NLza9d1AUtJoxis06Juxi8r0jPRuBL+b6d6fCtnnyGwqiegVx/Jc
         V/4IfmzpeLTnav2UnDq0GXecJzZhny98V1QHXUNu+FWeHA8j/Ja6LqPqnOA0iXfpFCOx
         zxof9dzHp1wt6cw8h1w3jd5Nyzg1O1JprW1IF5MYLwvW3yaBf7nUChZcf/VAfi0QA+7P
         NmRPio3e7sSYnbyM3oA34qVDGK0QxMKDKAQ1nfGhNXukQaG5ZlldUpBQQGHNejEl+wko
         gu82RlLOrvas75tGJpj7jOPI724w0rPadMZHToP1GETBfIr675AOfFrrzBnO+D9WjLlO
         vwKg==
X-Gm-Message-State: AOAM5339w+qSZ1tkbWxtCub6fxug3/0dJkAsIK7vDfuAfnv5CiFKH4kN
        aSyHdjyjoKpc+1R7hafZqd9a79c704Q=
X-Google-Smtp-Source: ABdhPJymcBOzJ9BUDme+N+mKKiHgI8f6QNqAO+jc8IeILxjzlDfNd+XuSJwnzaKDhaG1pw52JCGt9g==
X-Received: by 2002:a63:5fc3:: with SMTP id t186mr15754718pgb.187.1605857628945;
        Thu, 19 Nov 2020 23:33:48 -0800 (PST)
Received: from [192.168.1.101] (122-58-181-142-adsl.sparkbb.co.nz. [122.58.181.142])
        by smtp.gmail.com with ESMTPSA id 5sm2580142pfx.63.2020.11.19.23.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2020 23:33:48 -0800 (PST)
Subject: Re: [PATCH] scsi/atari_scsi: Fix race condition between .queuecommand
 and EH
To:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <b54c0f54-0422-dfe5-e66b-cd23a4c83089@gmail.com>
Date:   Fri, 20 Nov 2020 20:33:43 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

thanks for your patch!

Tested on Atari Falcon (with falconide, and pata_falcon modules).

Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

Am 20.11.2020 um 17:39 schrieb Finn Thain:
> It is possible that bus_reset_cleanup() or .eh_abort_handler could
> be invoked during NCR5380_queuecommand(). If that takes place before
> the new command is enqueued and after the ST-DMA "lock" has been
> acquired, the ST-DMA "lock" will be released again. This will result
> in a lost DMA interrupt and a command timeout. Fix this by excluding
> EH and interrupt handlers while the new command is enqueued.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
> Michael, would you please send your Acked-by or Reviewed-and-tested-by?
> These two patches taken together should be equivalent to the one you tested
> recently. I've split it into two as that seemed to make more sense.
> ---
>  drivers/scsi/NCR5380.c    |  9 ++++++---
>  drivers/scsi/atari_scsi.c | 10 +++-------
>  2 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d654a6cc4162..ea4b5749e7da 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -580,11 +580,14 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
>
>  	cmd->result = 0;
>
> -	if (!NCR5380_acquire_dma_irq(instance))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>  	spin_lock_irqsave(&hostdata->lock, flags);
>
> +	if (!NCR5380_acquire_dma_irq(instance)) {
> +		spin_unlock_irqrestore(&hostdata->lock, flags);
> +
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +	}
> +
>  	/*
>  	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
>  	 * commands are added to the head of the queue since any command will
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index a82b63a66635..95d7a3586083 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -376,15 +376,11 @@ static int falcon_get_lock(struct Scsi_Host *instance)
>  	if (IS_A_TT())
>  		return 1;
>
> -	if (stdma_is_locked_by(scsi_falcon_intr) &&
> -	    instance->hostt->can_queue > 1)
> +	if (stdma_is_locked_by(scsi_falcon_intr))
>  		return 1;
>
> -	if (in_interrupt())
> -		return stdma_try_lock(scsi_falcon_intr, instance);
> -
> -	stdma_lock(scsi_falcon_intr, instance);
> -	return 1;
> +	/* stdma_lock() may sleep which means it can't be used here */
> +	return stdma_try_lock(scsi_falcon_intr, instance);
>  }
>
>  #ifndef MODULE
>
