Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474C6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 04:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbiCHE6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 23:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiCHE6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 23:58:20 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3812C33A1D
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 20:57:25 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id s1so16003805plg.12
        for <linux-scsi@vger.kernel.org>; Mon, 07 Mar 2022 20:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K8Zj4a+2JTqryLR289plWU8ZHzist07MM6rm8mrgAuY=;
        b=C7a2Zm4bXfZxmABj8/L8HHr20i0s9CvBmbZRK3Mu346S017lxI+m5P9LoYtc66DpOf
         Q2MMETdpH93MbpKsFxo7D/L1gMPaao0FQ1cQmk7SqP3psLZwmWblQZDnUDHh1yqg1ZfS
         9HY24BZwXk167DDWFDeGQbizh6CwSKy4ZQ0DpUH8hGLYl1prhvyAli/4rGYdfQdnkwQ1
         lWjC5KSWnwqbsEB0etw+NfZlDsF42i9JJdXV6WD45WD5ofVhR0F0WKuMjlGO9teO58uY
         19b0006Ag04QYmkYv6djg5tt3PDk8u+m8lyJj+GTRbcdMcK9lmbJl7mRn0MMNSKhG1Aw
         je8A==
X-Gm-Message-State: AOAM530OINzSTStzfoKFqqfs92NPrvva6qO1EQtX2WxtBMWjU1lq2vbD
        9J+VLHIKVXjefPrt1JEaum4yZjiGJ5s=
X-Google-Smtp-Source: ABdhPJydCvuRvkH2Uz2D7icpiwIgMjXevCwbSW+znPW7GaMkkFzse6sGRhGFOjpwB38/OM0+LRs1bA==
X-Received: by 2002:a17:902:7896:b0:151:a6fd:dfb3 with SMTP id q22-20020a170902789600b00151a6fddfb3mr15890203pll.124.1646715444095;
        Mon, 07 Mar 2022 20:57:24 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k23-20020aa790d7000000b004f6c8b7c13bsm12208320pfk.132.2022.03.07.20.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 20:57:23 -0800 (PST)
Message-ID: <0bf6124e-be6c-aa35-2a54-bc1fa5894a2d@acm.org>
Date:   Mon, 7 Mar 2022 20:57:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220308003957.123312-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:39, Mike Christie wrote:
> The software iscsi driver's queuecommand can block and taking the extra
> hop from kblockd to its workqueue results in a performance hit. Allowing
> it to set BLK_MQ_F_BLOCKING and transmit from that context directly
> results in a 20-30% improvement in IOPs for workloads like: [...]

That's impressive!

> @@ -2952,8 +2954,8 @@ scsi_host_block(struct Scsi_Host *shost)
>   	}
>   
>   	/*
> -	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
> -	 * calling synchronize_rcu() once is enough.
> +	 * Drivers that use this helper enable blk-mq's BLK_MQ_F_BLOCKING flag
> +	 * so calling synchronize_rcu() once is enough.
>   	 */
>   	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);

s/enable/do not set/ ?

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 72e1a347baa6..0d106dc9309d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -75,6 +75,10 @@ struct scsi_host_template {
>   	 */
>   	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
>   
> +	/*
> +	 * Set To true if the queuecommand function can block.
> +	 */
> +	bool queuecommand_blocks;
>   	/*
>   	 * The commit_rqs function is used to trigger a hardware
>   	 * doorbell after some requests have been queued with

I'm not sure what the best name is for this new flag. Some function 
names refer to sleeping (e.g. might_sleep()) while the flag 
BLK_MQ_F_BLOCKING has "blocking" in its name. Although I do not have a 
strong opinion about this: has it been considered to use a name like 
queuecommand_sleeps or queuecommand_may_sleep instead of 
queuecommand_blocks?

Thanks,

Bart.
