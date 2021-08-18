Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AF3C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFBF26104F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHRQgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhHRQgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 12:36:39 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3C2C0613CF
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:36:04 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 17so2809818pgp.4
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxnuSHDgxiZeQAJnir3BVlDOHh31F/ItkqmVnN8W/Ng=;
        b=ZrZjVBPr7y1CLe0yHZcJtuBV5PAW6n/9LYU4PGgnxazPybFD2mjrx9qRmGGCjdIGUn
         o05Ct/RoiHl1IQIIXFUBCSH0OxHxZ1EhzONu62XOiNGWGJfVF/Z9xiZVnqChCLm+aQlL
         YnevYTD4VYnNy3UzMF7ye7P/eNuPBW640cQR3T+gWsw5+YCdu3ybdiRWu+H4Pxfz79QU
         JK7FAmYN0xRUURlCnQ5Uh5HtgFm6tluTolYQfIr8lGnU3fF5UvC2/iZkdEbDGrDa1LIP
         7vUyvPoUMuQBX6C6mzdcuBa1xeFcsqcU6rQkACOA3iS3Yl6hUma+5R1X9lKoxwTxhMek
         wCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxnuSHDgxiZeQAJnir3BVlDOHh31F/ItkqmVnN8W/Ng=;
        b=oi9f0sEDO05/WPe3+TsApizgyjNcAsBnyQlkz3ckp9Nauw+O11IG0ddSvMUPRtub8p
         iTxLGHSvWLUCih2/rG5iflZ27qJ3QxYSTlXmCnTEFhKziXyGud26COOMqSMoeiGsc/dG
         bY5gm1ZumsQQ34yPp7b3uAt3rxMT+B7oxQ3NqH/lQS1viWKOM6efjgOulCMFEqepQiik
         3PWEVZc8+eBbYYNC3IkTEQyjwbRv+vkzGlQeIl7nJnnEm4XA643X0SvfwxXoomEEIweG
         9PMv7f6+xbHskPoYiluCTZVn+Ua/vi5go6YYQpt0aJgEXdYMxP0ViO7zXHzTjzfmiotA
         5dCw==
X-Gm-Message-State: AOAM531gkrGWWmaWmF5TsTMLQwB+LIz/KwMRAgVqxWezKy3YxIFEOeoo
        xpcihAby5tPO2GnlB9I/0fs=
X-Google-Smtp-Source: ABdhPJz8YKz8r5wSYbKUUJ3ONnEFCnDFqg9Bk1IS23VG+Q9ONYycBZ29Hk8tVq5YsMVDTnF1RVFqtQ==
X-Received: by 2002:a05:6a00:1c5d:b029:3e0:6fb9:1de4 with SMTP id s29-20020a056a001c5db02903e06fb91de4mr10455662pfw.21.1629304564202;
        Wed, 18 Aug 2021 09:36:04 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d3sm266083pfa.51.2021.08.18.09.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 09:36:03 -0700 (PDT)
Subject: Re: [PATCH 26/51] lpfc: use rport as argument for
 lpfc_send_taskmgmt()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-27-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <2b84a650-9514-1379-2c5d-e486c36362d7@gmail.com>
Date:   Wed, 18 Aug 2021 09:35:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-27-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> Instead of passing in a scsi device we should be using the rport;
> we already have the target and lun id as parameters, so there's
> no need to pass the scsi device, too.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 

looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


