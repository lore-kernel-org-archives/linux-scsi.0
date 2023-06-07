Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9565C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 14:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbjFGOFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbjFGOFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 10:05:37 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B762E1BD6;
        Wed,  7 Jun 2023 07:05:36 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-656923b7c81so2185139b3a.1;
        Wed, 07 Jun 2023 07:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686146736; x=1688738736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyXOhVGtezcy+2Fwtyg7FvkmfeJnpSCW0PrGx+GMudU=;
        b=e5/47+EmM4KGU8bs/8d80wcNbLcd51soYK+mA30jl8xOhZRIbGX8b71l83HkuSqobH
         iT4tBGvTExL4f3c1WpajJKp5ldECofklzoczfIDGpoaKNnSUxq24CTqWEGwT4M9AMOw8
         ZA8LipwEpYJY4jka0V4/WK+V322nTPEt9ywqGZcuqXN/rITbliPVfcPg7REHh2+B9zWY
         MxDSSzuRLDBmSq60qSagdF2CMm9Fv+8iu9V3tjlbAI5iZv7jEMGq5bpRyjbZaXTJ4cGm
         xLXc37tiYCNva2Wzi6+kmgkxgSk68f1vMu1M6D6k4OXYeA2cjhQ6mMrOkqCLlMiFHqPs
         WhqA==
X-Gm-Message-State: AC+VfDxA7CNgC9QPjNx0hv+EcPJkaNtLCa5zfZHjzhK3HgQj8WIMUt6C
        ZHMCb5a9EBMSjA4gcJ/dFDg=
X-Google-Smtp-Source: ACHHUZ5RxcxKWVMn4dtCKEttzi1RAE+mOz6wHLb+Ed/NjcMU7bpJmU5tGTcnUdu1AMHCnPtpSeLCmA==
X-Received: by 2002:a17:902:d48e:b0:1b1:b253:5428 with SMTP id c14-20020a170902d48e00b001b1b2535428mr2585254plg.58.1686146736060;
        Wed, 07 Jun 2023 07:05:36 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id c1-20020a170903234100b00199193e5ea1sm10511755plh.61.2023.06.07.07.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 07:05:35 -0700 (PDT)
Message-ID: <903c7222-c95e-fda1-9b90-b59e184944cf@acm.org>
Date:   Wed, 7 Jun 2023 07:05:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/23 02:26, Martin Wilck wrote:
> On Wed, 2023-06-07 at 07:27 +0200, Christoph Hellwig wrote:
>> On Tue, Jun 06, 2023 at 09:38:45PM +0200, mwilck@suse.com wrote:
>>>   scsi_target_block(struct device *dev)
>>>   {
>>> +       struct Scsi_Host *shost = dev_to_shost(dev);
>>> +
>>>          if (scsi_is_target_device(dev))
>>>                  starget_for_each_device(to_scsi_target(dev), NULL,
>>>                                          device_block);
>>>          else
>>>                  device_for_each_child(dev, NULL, target_block);
>>> +
>>> +       /* Wait for ongoing scsi_queue_rq() calls to finish. */
>>> +       if (!WARN_ON_ONCE(!shost))
>>
>> How could host ever be NULL here?  I can't see why we'd want this
>> check.
> 
> The reason is simple: I wasn't certain if dev_to_shost() could return
> NULL, and preferred skipping the wait over an Oops. I hear you say that
> dev_to_shost() can't go wrong, so I'll remove the NULL test.

I propose to pass shost as the first argument to scsi_target_block() 
instead of using dev_to_shost() inside scsi_target_block(). Except in 
__iscsi_block_session(), shost is already available as a local variable.

Bart.

