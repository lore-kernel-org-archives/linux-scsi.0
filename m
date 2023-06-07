Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA772C7EE25
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 16:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjFGQjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 12:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjFGQja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 12:39:30 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCB01BFE;
        Wed,  7 Jun 2023 09:39:28 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b0201d9a9eso6443115ad.0;
        Wed, 07 Jun 2023 09:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686155968; x=1688747968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=luNT/INyKsFl9KSShF42us3zzE8nFAUkhlKdA1zIJKw=;
        b=IOr/a71S7Lv8QlnsMiqVlXO7a5VDottrCzomLTUIrhQV+ba33XndxpmvH4CNP5u9aQ
         Y7NnwOsRnG+gOdhjgukSxsZjGm/DZp/JtxXh7XyTqiE0S2rmhHExFBqqknND8H8Aewhx
         pHtjoxDtl7P34KHmUYWNTH0+XgAm5L+sqJb2ViyvtOId7C7ULQdL3KOgnAOltjdt63TY
         Crm3oxB/QPW7RvI/0zmmsyYapqOOGmx7F4IaMJRy3jrUzqEGgPFHX1cfQ90kpIAPTatW
         M8mSxxOV0Pd6Xu0d5o+/NQ4a49qdEMJigTcnY5A698GKcADTrzU+SzynLgX39a1uKs45
         lb5A==
X-Gm-Message-State: AC+VfDwK3os2fY56VfLnOn7ZTvjiuYGozt3aNSXPr5TeGugqDl1k9bkz
        nr/ECQh2RclMV2GYEe4I3sE=
X-Google-Smtp-Source: ACHHUZ7/Wm4lKhfqh2pnikDu4qrN3RFyFpgghV91bwBl4bf2a0efhjJeZfcMUkOTPE7WiSUH3VW+EA==
X-Received: by 2002:a17:902:dac4:b0:1b0:62e2:1f84 with SMTP id q4-20020a170902dac400b001b062e21f84mr19498370plx.5.1686155967638;
        Wed, 07 Jun 2023 09:39:27 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902760400b001b02df0ddbbsm10658443pll.275.2023.06.07.09.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:39:26 -0700 (PDT)
Message-ID: <c9f55fc9-3c60-5a6c-be2d-0c313c345bb2@acm.org>
Date:   Wed, 7 Jun 2023 09:39:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230606193845.9627-1-mwilck@suse.com>
 <20230606193845.9627-4-mwilck@suse.com> <20230607052710.GC20052@lst.de>
 <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
 <903c7222-c95e-fda1-9b90-b59e184944cf@acm.org>
 <7ee70331d921854e2b27de3d072d0d8f8ce97f3b.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7ee70331d921854e2b27de3d072d0d8f8ce97f3b.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/23 08:38, Martin Wilck wrote:
> On Wed, 2023-06-07 at 07:05 -0700, Bart Van Assche wrote:
>> On 6/7/23 02:26, Martin Wilck wrote:
>>> On Wed, 2023-06-07 at 07:27 +0200, Christoph Hellwig wrote:
>>>> On Tue, Jun 06, 2023 at 09:38:45PM +0200, mwilck@suse.com wrote:
>>>>>    scsi_target_block(struct device *dev)
>>>>>    {
>>>>> +       struct Scsi_Host *shost = dev_to_shost(dev);
>>>>> +
>>>>>           if (scsi_is_target_device(dev))
>>>>>                   starget_for_each_device(to_scsi_target(dev),
>>>>> NULL,
>>>>>                                           device_block);
>>>>>           else
>>>>>                   device_for_each_child(dev, NULL,
>>>>> target_block);
>>>>> +
>>>>> +       /* Wait for ongoing scsi_queue_rq() calls to finish. */
>>>>> +       if (!WARN_ON_ONCE(!shost))
>>>>
>>>> How could host ever be NULL here?  I can't see why we'd want this
>>>> check.
>>>
>>> The reason is simple: I wasn't certain if dev_to_shost() could
>>> return
>>> NULL, and preferred skipping the wait over an Oops. I hear you say
>>> that
>>> dev_to_shost() can't go wrong, so I'll remove the NULL test.
>>
>> I propose to pass shost as the first argument to scsi_target_block()
>> instead of using dev_to_shost() inside scsi_target_block(). Except in
>> __iscsi_block_session(), shost is already available as a local
>> variable.
> 
> If we do this, it might actually be cleaner to just pass the tag set to
> wait for.

Wouldn't that be close to a layering violation? Shouldn't SCSI APIs accept
pointers to SCSI objects instead of pointers to block layer abstractions?

Thanks,

Bart.

