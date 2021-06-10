Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3436C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 10:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A4C613FF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 10:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhFJKys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 06:54:48 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:40707 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFJKyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 06:54:47 -0400
Received: by mail-wm1-f54.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so6241589wmd.5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 03:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Se/+f840vWN1hnB8FqABpPi/FVV1wd7BwIPK7BO5yE4=;
        b=eJ3Bi6hekOrxwPjcZ37PCpR4QpY1En3SGPqIeWX+JhWm1UmDdc3z+RBFc6jArVLAqM
         /LN/okEHgIh/rtp4it18icsa7Umbti5261SRGIcr2atoIinkttsKjvXFfyier42Qx2ZB
         spIFPNbgRGfOQouWn0u5xXmvzxxinL+578xZmdN5qgy1si9OQ19cBoD6wQ6WwlBa2e+M
         n7NCV4/1n9Iq90jbDgk3UYRZgDAtBPI4An3QBzQSaSS0fxh8q5IpiEXoURai1Xt9kZnu
         v7tjARHIZHCCnU8d4DznTUKi3tbMQI1CqYMMutpi4AJVbZyBq0t43lN9W9iaeod85DZU
         joHg==
X-Gm-Message-State: AOAM530Xa62lYf1/EmlPmqq4advUZ1e68BlLPne57CgLkSxYZyY89IKE
        hpH+qdSge0j759G0gLjtjMo7cTTsysk=
X-Google-Smtp-Source: ABdhPJyPSx/I01eX8mkePD7V7FNxJbfLM+plulbUJG4ss688altciZucHkcmkmpaXusovL52I7G2Sw==
X-Received: by 2002:a05:600c:1c22:: with SMTP id j34mr14925739wms.166.1623322370517;
        Thu, 10 Jun 2021 03:52:50 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id n42sm8786039wms.29.2021.06.10.03.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 03:52:49 -0700 (PDT)
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
 <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
Date:   Thu, 10 Jun 2021 12:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07. 06. 21, 15:02, Hannes Reinecke wrote:
> On 6/7/21 2:30 PM, Martin K. Petersen wrote:
>>
>> Hannes,
>>
>>>> Any ideas?
>>
>>>> Can you enable SCSI logging via
>>>
>>> scsi.scsi_logging_level=216
>>>
>>> on the kernel commandline and send me the output?
>>
>> You now effectively set SAM_STAT_CHECK_CONDITION if the scsi_cmnd has a
>> sense buffer.
>>
>> The original code only set DRIVER_SENSE if the adapter response actually
>> contained sense information:
>>
>> @@ -161,8 +161,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>>                         min_t(u32,
>>                               virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>>                               VIRTIO_SCSI_SENSE_SIZE));
>> -               if (resp->sense_len)
>> -                       set_driver_byte(sc, DRIVER_SENSE);
>> +               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>>          }
>>
> Oh, I know. But we're checking for a valid sense code during scanning:
> 
> 			if (scsi_status_is_check_condition(result) &&
> 			    scsi_sense_valid(&sshdr)) {
> 
> so if that makes a difference it would mean that the virtio driver has
> some stale sense data which then gets copied over.
> Anyway.
> Can you test with this patch?

Yes, that boots, but is somehow sloooow (hard to tell what is causing this).

Anyway, the new print is still there with the patch:
[   11.549986] sd 0:0:0:0: Power-on or device reset occurred


> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index fd69a03d6137..0cb1182fd734 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -161,7 +161,8 @@ static void virtscsi_complete_cmd(struct virtio_scsi
> *vscsi, void *buf)
>                         min_t(u32,
>                               virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>                               VIRTIO_SCSI_SENSE_SIZE));
> -               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
> +               if (resp->sense_len)
> +                       set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>          }
> 
>          sc->scsi_done(sc);
> 


thanks,
-- 
js
suse labs
