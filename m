Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49B9C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918656109F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhHSSIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:08:32 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33425 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSSIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 14:08:31 -0400
Received: by mail-pj1-f54.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so7727219pje.0;
        Thu, 19 Aug 2021 11:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AfYnBat8HLe89HP83zngEKr4D0S4PvQLlUEhGzKv+jE=;
        b=QLen/kIWgHdhYD92FuKXRInVsraXjSoLl4lmbpaQX0FzCmj/6NOKGVMegw/Ao7cjBP
         6QgNUtkjrmNdls+3cvt3T4zqTGfDjhldLKt/k2ozzFbHvXfqIkZQWDA9mwZHBwPJjhTW
         tstYn7QzUnj9hA8kI513v4Y7uA8SEgLt2Xl1+s9zufnpU8bnfrUTomp/Fas9XsNWzp3k
         yqaA7KjhRffFokMKqKfcBx0DcxRrH2KGSsDjl44CLXt8h2yR871oYVrSTAb8nsWz1EON
         dZEZ1W9H34RFbv42aB161Y3IKqOBRjJsx2SDe443iLTc1DU7gjvrfDK2BNQIBq3CPxp+
         24bA==
X-Gm-Message-State: AOAM53277N9uAiAHWS4AdT7Uebpo92ADTZYlhz2hr+3UsNJ4WLuiGlm9
        BaxJGA7rjb1mVpRqEzrdU8I=
X-Google-Smtp-Source: ABdhPJw9jzaPLTBC8qVfvVirNvlSIA1Jq9phxj9SttW3sNqLuE7L7AEqtQcvtYwtddM+sUb8/CfPXQ==
X-Received: by 2002:a17:90b:4504:: with SMTP id iu4mr16573217pjb.209.1629396474907;
        Thu, 19 Aug 2021 11:07:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id q3sm5001758pgl.23.2021.08.19.11.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 11:07:54 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation
 issues
To:     John Garry <john.garry@huawei.com>, mdr@sgi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
 <1629365549-190391-3-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7107778e-8e20-22ab-bf94-d26aca09bd93@acm.org>
Date:   Thu, 19 Aug 2021 11:07:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629365549-190391-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 2:32 AM, John Garry wrote:
> The driver does not compile under DEBUG_QLA1280 flag:
> - Debug statements expect an integer for printing a SCSI lun value, but
>    its size is 64b. So change SCSI_LUN_32() to cast to an int, as would be
>    expected from a "_32" function.
> - lower_32_bits() expects %x, as opposed to %lx, so fix that.
> 
> Also delete ql1280_dump_device(), which looks to have never been
> referenced.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/qla1280.c | 27 ++-------------------------
>   1 file changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index b4f7d8d7a01c..9a7e84b49d41 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -494,7 +494,7 @@ __setup("qla1280=", qla1280_setup);
>   #define CMD_HOST(Cmnd)		Cmnd->device->host
>   #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
>   #define SCSI_TCN_32(Cmnd)	Cmnd->device->id
> -#define SCSI_LUN_32(Cmnd)	Cmnd->device->lun
> +#define SCSI_LUN_32(Cmnd)	((int)Cmnd->device->lun)

How about using 'unsigned int' instead of 'int' since LUN numbers are 
positive integers?

Thanks,

Bart.
