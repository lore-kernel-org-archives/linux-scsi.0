Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3AEC64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCGCxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCGCxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:53:34 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097FA30B3E
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:53:34 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so15253262pjh.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 18:53:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678157613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nfw2u2MpApbwltENFVXhiLBZLydgycoWnXoj/fFU+pQ=;
        b=ae07qa2jKRQ528Hma8eSg9Z+WJXUDC8uNJoK/mmBBMjXasy9+WnV1EB4VPZgjyxvMh
         FNwxy/KPgE/qfhGf9qsXMLffduc97Ex8aYkEtGJ8yrNTMyBb/FQI4l3VY17Zm5QeyWd0
         77nhLNoVz1xJLtqSLJtYyM558OXXQ6clURiuMrBiC3pV+8U+zdSKXIp/xN8BF7MhoyWT
         8j9gf5gWt0adaSFijhVG5ybR36fHRLy2F+nA2q2eaZjXauJ3xm1NtIZg6YlNQTSQZv6l
         7C7YkqGltaIcY8+dTa2uMdeKdDi84UWeLQ0maJiEEZoU23zwCteqB13bWCY5lbEW3Fn6
         qL9g==
X-Gm-Message-State: AO0yUKWsRi0Rj2Lsr7o6F1sBrmeWVIzV8wTRywWc+VOAGxzmiwkrh59T
        V8WQkUwvg9paAX97mykh5Fw=
X-Google-Smtp-Source: AK7set9g9nu7qOaJ3WB7wc942XG+D6UIi6C9rOPvd62IDt9K+kqvPm7CEMdmFDC5tGZVq01ZmZ9uyQ==
X-Received: by 2002:a17:902:c94f:b0:19e:73df:b0e9 with SMTP id i15-20020a170902c94f00b0019e73dfb0e9mr16551919pla.21.1678157613303;
        Mon, 06 Mar 2023 18:53:33 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id jz16-20020a170903431000b0019258bcf3ffsm7412647plb.56.2023.03.06.18.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 18:53:32 -0800 (PST)
Message-ID: <9b2a5873-4b9e-cac1-0cf9-7a997beb10a6@acm.org>
Date:   Mon, 6 Mar 2023 18:53:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 04/81] ata: Declare SCSI host templates const
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-5-bvanassche@acm.org>
 <yq1bkl5migf.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1bkl5migf.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 18:00, Martin K. Petersen wrote:
>> Make it explicit that ATA host templates are not modified.
> 
>>   drivers/ata/pata_atiixp.c       |   2 +-
>>   drivers/ata/pata_atp867x.c      |   2 +-
>>   drivers/ata/pata_bk3710.c       | 380 ++++++++++++++++++++++++++++++++
>     ^^^^^^^^^^^^^^^^^^^^^^^^^
> Don't believe you meant to add this...

Hi Martin,

Thanks for having reported this. The above is the result of having 
resolved a rebase conflict incorrectly. I will remove file 
drivers/ata/pata_bk3710.c from this patch.

Thanks,

Bart.
