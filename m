Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434F4C4708F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 06:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD1F61413
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 06:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFDGmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 02:42:08 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:43938 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFDGmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 02:42:07 -0400
Received: by mail-ej1-f44.google.com with SMTP id ci15so12796079ejc.10
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 23:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIji8YMjUfIgB6iCdk7Dyh2lwlauiJwNgt8nTA31SNM=;
        b=LuvR3W24IrOP5ODPiBAsevFFjs8DQ11o1NeVwBtX0LeIj3Ejhoyc2vOVQUHRqGB+hJ
         UrCCN10+dsvRKitnLI52T0MYoIUQMSxX57lmlz8ETqnrpHl5mGwg+aTPC6qAmR4uoQBD
         uGW8MCGMEMqQqG0jAW91k5cabowZBTlquuMQMrWuhSVLpLP5zDSVYLVFtWcUKrfVbJ9M
         DUC4AsZmmUiMnVrj7Zy17eQ+RIpdmxJHsbwrOJO8vwh0kg4TmgDgXLjYR3XAfuWaxIMe
         N10USDcOLOkGKXx9EHvkUDUqeq347fTL2WxQ+IcvG32S0edriJ+u8G5qB2cp6Jy7vjY0
         ZhTw==
X-Gm-Message-State: AOAM533Q//DUlVpzjyAgGH/tdc+Qsmtn7lfsc4+1HoLciuhV7mmRB9K/
        1491A5ac1GTAJBl2IJZwZnBQr735Ljs=
X-Google-Smtp-Source: ABdhPJz2G/BPJGpbS47rdXuGnIKpePkwM0hed1C+uWjTiQQfetXV4s1HKRg/ocVUqV14iCLB1L9vRg==
X-Received: by 2002:a17:906:4111:: with SMTP id j17mr2743584ejk.488.1622788821123;
        Thu, 03 Jun 2021 23:40:21 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id k21sm2372131ejp.23.2021.06.03.23.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 23:40:20 -0700 (PDT)
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
Date:   Fri, 4 Jun 2021 08:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-14-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 21. 10. 19, 11:53, Hannes Reinecke wrote:
> Replace the check for DRIVER_SENSE with a check for
> SAM_STAT_CHECK_CONDITION and audit all callsites to
> ensure the SAM status is set correctly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
...
>   drivers/scsi/virtio_scsi.c                  |  3 +-

A bisection says that this patch breaks virto_scsi for me. The (virtual) 
disk is not found by the kernel.

GOOD:
scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5

BAD:
scsi 0:0:0:0: Power-on or device reset occurred

I cannot revert the patch on the top of -next as there are conflicts...

Any ideas?

thanks,
-- 
js
suse labs
