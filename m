Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187A6C47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A9D613B8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFCDKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:10:37 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:56037 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhFCDKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 23:10:36 -0400
Received: by mail-pj1-f49.google.com with SMTP id k7so2793996pjf.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 20:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/dM/8tpIVGfPVNbK2a4ypcSeqgM6ruvR/EruAT5qEM=;
        b=kxbd9t94jTT+Z0R5WKHL8mdN83K+A+Kb71YDYn/zdIpB6PuIATZLMCJtHUOkQT3nZU
         TyVWTc07h0FiGSej17tdbY8D3YV9/QUjxwkf7qhUFrxnMI6XRxo6l4FQjqFMH2qPBPxh
         EWgzPLMUfh7oFt7/G1ana1C3eHjvlz2EavRfw3DBCuGvNmSV+PSZqTYWGziEUBsNhZ1w
         U7Oa2v+ZD3dPYZFDR/mlmEwqDK+2OqZ/QmPmw71jbBYkRNDN0yDMKBpmS9K5gO853HL1
         CH+da1+iXlOYTHkyA1HyGnzQAkYF6L7QM2H69zCAiOLMYj1d1eStl+78zKuABQOvPyhw
         sQdQ==
X-Gm-Message-State: AOAM532ujACvSXsrF9SxltuVy74kiiuu3mVee/bMBRuybHVYhTjKWCBQ
        84iI5CPoVQRbfPgHK1IHWXY=
X-Google-Smtp-Source: ABdhPJyK7s2/N9yD/gKojKAdsoWc1bPy/Nt0xHJYmSuSjrblighN3Fv/j5ClsvqJ/aT3jjiFcAUoGQ==
X-Received: by 2002:a17:902:a586:b029:fe:459b:2ce0 with SMTP id az6-20020a170902a586b02900fe459b2ce0mr33937136plb.40.1622689718035;
        Wed, 02 Jun 2021 20:08:38 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id gw21sm644738pjb.41.2021.06.02.20.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 20:08:37 -0700 (PDT)
Subject: Re: [PATCH 4/4] scsi: core: only put parent device if host state
 isn't in SHOST_CREATED
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-5-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <851db5c8-b4c4-790b-0877-eeea9737f2f3@acm.org>
Date:   Wed, 2 Jun 2021 20:08:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 6:30 AM, Ming Lei wrote:
> get_device(shost->shost_gendev.parent) is called after host state is
> changed to SHOST_RUNNING. So scsi_host_dev_release() shouldn't release
> the parent device if host state is still SHOST_CREATED.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 7049844adb6b..34db5be7a562 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -350,7 +350,7 @@ static void scsi_host_dev_release(struct device *dev)
>  
>  	ida_simple_remove(&host_index_ida, shost->host_no);
>  
> -	if (parent)
> +	if (shost->shost_state != SHOST_CREATED)
>  		put_device(parent);
>  	kfree(shost);
>  }

Not sure what others think but I prefer that this patch would also be
merged into patch 2/4.

Thanks,

Bart.


