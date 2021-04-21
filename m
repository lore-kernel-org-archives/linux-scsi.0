Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBA8C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D909C61435
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbhDUVK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:10:58 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33389 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhDUVK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:10:56 -0400
Received: by mail-pg1-f180.google.com with SMTP id t22so31178443pgu.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OAf+uQxByjjSOe9+sLm7klqPE71UpdNz0a6xZ/8wdkM=;
        b=sTGeDOkdcYssIH87e6WAlBbxoeQmvtV8alSeSJ1RVes6BBZrBYhDQjjz2P2yt9Tu/H
         g8Wf0aAWW2M6FAif7VVgzrJEnOObnXMdhKFYHunR51x6tGnzxxikFaCiw1xz87ztYMQ7
         Xrp0S45xestVknx4ULR7649vhG7C29LgHMJHvlXbEn9XDkQBGdskaz/lD/E6AytEpp0E
         MPgzLEiDmCnikOcHsLMEictE/HHwIFXk6bOB1Ti63/v+6+BkQIcjx/ysvv8B3ng1kIm3
         Ol6/SqfGxP2Ko1dZsFhVHLsIfWGN4mTmPNeY6R/LqlR+v1h0iSmkgfiZQkfLjUuhFqIE
         SAng==
X-Gm-Message-State: AOAM530lDJZ7dtF8fOq+y+FvLt1XsJcxzc6uFK7kJbzVkqZqc2IE1xQU
        1IkdmV7Q6lQNNbxrXTWt4n/7IGmd7Y5m7Q==
X-Google-Smtp-Source: ABdhPJzoxYcAE2l6aDByvfDdXGbZSRAseSCADMwFeXGH6YGGLveOETuLasqLU8BJ+9YNd1qprYd4pg==
X-Received: by 2002:a17:90a:c788:: with SMTP id gn8mr72836pjb.60.1619039422403;
        Wed, 21 Apr 2021 14:10:22 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k17sm190232pfa.68.2021.04.21.14.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:10:21 -0700 (PDT)
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-15-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org>
Date:   Wed, 21 Apr 2021 14:10:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-15-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> +static inline bool scsi_result_is_good(struct scsi_cmnd *cmd)
> +{
> +	return (cmd->result == 0);
> +}

Do we really need an inline function to compare an integer with zero? 
How about open-coding this comparison in the callers of this function?

Thanks,

Bart.

