Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF438C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAXT3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjAXT3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:29:14 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A27E4DBDC;
        Tue, 24 Jan 2023 11:29:13 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id 88so4521918pjo.3;
        Tue, 24 Jan 2023 11:29:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YhbYF2J/bB9BQaiD6FrWTJCjwCuOn4dueXWoXgXC1o=;
        b=sL5OUQmQHndpCi+QH7pp+c2Wh0gKoemCm2jQITnmjueitakanw0i0GE7M13av7bD3S
         ewzvmG724jgVH6VJ/0qPHTRdGHSGY1VnjVWSFcUmvS3mmgf0q0cGT393JHEIdRjFzzZW
         X8VR8Y3nYAdjcOQUv4fhdQCyALI6uKKsb6Qk5YkrdVHfF2qxfcebxND1geuLg2C28wJ5
         2OqXvKvK/O4nGXJcyYD125spExzSH74eeVxb2DRxWzMhXcuOX6N4q5qITmD9ycDWAGQj
         fMkYlElQmW4eJhaBZazk6Ejl6VUQp74UpYZYfKN3hhefxISU4m0peRuBl2aFVFbkFDcc
         qR3w==
X-Gm-Message-State: AFqh2kqeS2Q7POtI5XEr+2KyETKy98Wtj48MvY+qsf8tCxv0o7p6x16Y
        F2wE0sdSHuNttLAL7VJkeaEcl6bFVkE=
X-Google-Smtp-Source: AMrXdXtt71aR6ITZ34lcqcPRpUBunq8zg6SG5h/yayvM+En9I/WdBwxiNVa00Iv4meCKr2irm9DjVg==
X-Received: by 2002:a05:6a20:7d98:b0:ad:3ada:c712 with SMTP id v24-20020a056a207d9800b000ad3adac712mr38184624pzj.14.1674588552946;
        Tue, 24 Jan 2023 11:29:12 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id m22-20020a6562d6000000b004d2f5bb9339sm1751272pgv.15.2023.01.24.11.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:29:12 -0800 (PST)
Message-ID: <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
Date:   Tue, 24 Jan 2023 11:29:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-3-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
> report command that failed due to a command duration limit being
> exceeded. This new status is mapped to the ETIME error code to allow
> users to differentiate "soft" duration limit failures from other more
> serious hardware related errors.

What makes exceeding the duration limit different from an I/O timeout 
(BLK_STS_TIMEOUT)? Why is it important to tell the difference between an 
I/O timeout and exceeding the command duration limit?

Thanks,

Bart.

