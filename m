Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EA1C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 16:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 984BD61029
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 16:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhHSRAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:00:14 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:45029 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhHSRAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 13:00:09 -0400
Received: by mail-pf1-f180.google.com with SMTP id k19so6076316pfc.11
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 09:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBzcmc8uUNU4adTJV2ySRYVXZA14RE80e+8NUrKeHdU=;
        b=XmPSaD6k9va/wA36b38S5mDD/yC23JAMvVzjl/6aVpD89I00V3s4+hhL2h/UeoBggZ
         MIStsN4HeqWAfVaBXDKYDGjf0aDzuZYmbto1NacUhUUwHgKmDy53L3Kk3GEP62Bin5Iq
         zFg+7TTAQEk36EGp/xm21VXjmXm0Guie7XBUAqosWm2aQqJusPCMUp8ulXEOx3X7VRKV
         hZzzYAf4wsd87+p5hgMLczOOZJvoaTQH32Q6uxisKCtbGFFznAQY7RbxWK2dNfIP9X4Q
         OLLjtn1WqUzEEL4c/CHoC+kakHmQhmZUMUwL+xHStE52ejZLNZGmVY+kscRQLwxs41mS
         jFiA==
X-Gm-Message-State: AOAM533gNeJwBraU+P8RvqEtv2zW7pZqNioBDbZuUJV97DqUzlipG+Xp
        BkoAMC0mvy7m1iFW8fJiNIvxtWwnn/0=
X-Google-Smtp-Source: ABdhPJzF6OLDdGLsAnsmaNGSLH+VVgCGrXxURQsjTCcYX8yu7QxoNnWfni9nZJob/HlotlEq3gpeTA==
X-Received: by 2002:a62:1616:0:b029:3e0:3447:59dd with SMTP id 22-20020a6216160000b02903e0344759ddmr15355364pfw.26.1629392371859;
        Thu, 19 Aug 2021 09:59:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id q18sm4175981pfj.178.2021.08.19.09.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:59:31 -0700 (PDT)
Subject: Re: [PATCH 1/4] scsi: Introduct scsi_cmd_to_tag()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210819084007.79233-1-hare@suse.de>
 <20210819084007.79233-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dffab055-b9ad-cfc7-1d8e-bffdcb18d3c1@acm.org>
Date:   Thu, 19 Aug 2021 09:59:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819084007.79233-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 1:40 AM, Hannes Reinecke wrote:
> +static inline u32 scsi_cmd_to_tag(struct scsi_cmnd *cmd)
> +{
> +	struct request *rq = scsi_cmd_to_rq(cmd);
> +
> +	return rq->tag;
> +}

Do we really need this function? If so, please change "Introduct" in the 
subject into "Introduce". Additionally, how about renaming this function 
into scsi_cmd_tag()? How about changing the function body into "return 
scsi_cmd_to_rq(cmd)->tag"?

Thanks,

Bart.
