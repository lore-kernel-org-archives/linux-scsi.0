Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4470DC54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 20:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjAXUgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAXUga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 15:36:30 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C233F1BFA;
        Tue, 24 Jan 2023 12:36:29 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso10811635pjp.3;
        Tue, 24 Jan 2023 12:36:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/h5cdpjRST1tl1jAA0QM4pzIDzSKfXSQyvbgQ5V7UI=;
        b=s1JSnH4yxd50ZpzdMNvGJ7vzjcvU94PczcWNfnPReS+wxqUgjwYjidYaSV/yvRZ3/m
         ahIiuqQXr8f5XsPOAYyuwDVKqhKc1U8RjQlan+3BXs5e8vWfIzqTpX6jJrEQ03JZxbTP
         F1CyjFNCA9cbzokC/IMGl9GSmVFO6aAvgzhuvpjmCYIqEH+vfTVAJSG3B5Q2lDpp6uFY
         oybiyKVzSSk+/4RM8JoxyDVWNz9tBwOEROQcWJNQkwgIWG/E00CP/omEpWk1xz/adKCC
         L32wE8ZoSXgq/Yw/QwRoN0y3W2GZILDclEmHBH8tFoFGwXQ2Hx429S5F6pm8skfP0cCI
         cMqA==
X-Gm-Message-State: AFqh2kqWvM46CPRnXT8MIsOTlW0pU3GD7W5OOP9c/zRjUuISk3HRGdUN
        YllAK786Xz4O1tcVvSoXEWc=
X-Google-Smtp-Source: AMrXdXv9U1cKa4blP+iNmUDwB516eP9AOyJE595wNjrwWUujqYf1WecwrsQtbb7MVaYm1DiwxBadrg==
X-Received: by 2002:a17:90b:1b4f:b0:226:d23b:8037 with SMTP id nv15-20020a17090b1b4f00b00226d23b8037mr31670113pjb.33.1674592589250;
        Tue, 24 Jan 2023 12:36:29 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a600100b002262ab43327sm8756762pji.26.2023.01.24.12.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 12:36:28 -0800 (PST)
Message-ID: <bd75a7d8-7664-eff5-d417-a2fa8708fb05@acm.org>
Date:   Tue, 24 Jan 2023 12:36:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
In-Reply-To: <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:27, Bart Van Assche wrote:
> Implementing duration limit support using the I/O priority mechanism 
> makes it impossible to configure the I/O priority for commands that have 
> a duration limit. Shouldn't the duration limit be independent of the I/O 
> priority? Am I perhaps missing something?

(replying to my own e-mail)

In SAM-6 I found the following: "The device server may use the duration 
expiration time to determine the order of processing commands with
the SIMPLE task attribute within the task set. A difference in duration 
expiration time between commands may override other scheduling 
considerations (e.g., different times to access different logical block 
addresses or vendor specific scheduling considerations). Processing of a 
collection of commands with different command duration limit settings 
should cause a command with an earlier duration expiration time to 
complete with status sooner than a command with a later duration 
expiration time."

Do I understand correctly that it is optional for a SCSI device to 
interpret the command duration as a priority and that this is not mandatory?

Thanks,

Bart.

