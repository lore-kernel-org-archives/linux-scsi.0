Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215FAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 23:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiGAXo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAXo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 19:44:56 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA3B36141
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 16:44:55 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id o18so2563297pgu.9
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 16:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8ftWunTxSVnuCarGBhkqp0O2ja3mqaFP/oDCUvRqaI4=;
        b=HWkl/+Slo67oYMOPk1kAtlfNAfBoqmgNM20knsUF3D+O/HLDuadoFO/1HK7KP4328R
         zoWAUeDK4AUUk3nITwFix9JEPpESzXvLNV8f5J107a9TvnIM/tV9Je7l+qoS5bq/43T+
         js+e0N9/DEbPZzHqrGMdbKuJD4hIec3DeWX8aMz0QxMuWAtmVW5geLSOtOxzxvUSICQC
         2cPFu2pntT1IxdR0B1nCdx49KD+jJHrIY+J7EHszyo9GqpGrq8o07Xz9DbTw5oBXiPXq
         cHIS6vbs6f/RWnMtJv3VVFEnQ9zQCzFp/9Ze6ZTGQxYHPclzXXD9qbRWTXkPzw0vZh5j
         4V8w==
X-Gm-Message-State: AJIora9gSYHoAtFuYJHbLtx88qDGuWpHhNHE9e4TtnH+p/ChnwE/cX4R
        7HTh3o6cdC0fGLKpTDkwWxLmixFF2Nc=
X-Google-Smtp-Source: AGRyM1sWnPIbD9NncKl7VSGLbf8lgspINvQbmwJgXmiX2TFCE3HxD7bFJPs9xXrYS4poyPW2DgeRkA==
X-Received: by 2002:a63:8741:0:b0:411:6ef8:18ec with SMTP id i62-20020a638741000000b004116ef818ecmr14830179pge.258.1656719095237;
        Fri, 01 Jul 2022 16:44:55 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y11-20020a63de4b000000b0040c644e82efsm15859041pgi.43.2022.07.01.16.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 16:44:54 -0700 (PDT)
Message-ID: <70c4df8c-a0f3-3ed2-66be-fa5d46f40ed8@acm.org>
Date:   Fri, 1 Jul 2022 16:44:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 2/3] scsi: Make scsi_forget_host() wait for request
 queue removal
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-3-bvanassche@acm.org>
 <af96e766-69bd-4aab-812b-59de10286d9e@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <af96e766-69bd-4aab-812b-59de10286d9e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/22 09:25, Mike Christie wrote:
> On 6/30/22 4:37 PM, Bart Van Assche wrote:
>>   	struct scsi_device *sdev;
>> @@ -1970,8 +1980,21 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>    restart:
>>   	spin_lock_irq(shost->host_lock);
>>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
>> -		if (sdev->sdev_state == SDEV_DEL)
>> +		if (sdev->sdev_state == SDEV_DEL &&
>> +		    blk_queue_dead(sdev->request_queue)) {
>>   			continue;
>> +		}
>> +		if (sdev->sdev_state == SDEV_DEL) {
>> +			get_device(&sdev->sdev_gendev);
>> +			spin_unlock_irq(shost->host_lock);
>> +
>> +			while (!blk_queue_dead(sdev->request_queue))
>> +				msleep(10);
>> +
>> +			spin_lock_irq(shost->host_lock);
>> +			put_device(&sdev->sdev_gendev);
>> +			goto restart;
>> +		}
>>   		spin_unlock_irq(shost->host_lock);
>>   		__scsi_remove_device(sdev);
>>   		goto restart;
> 
> Are there 2 ways to hit your issue?
> 
> 1. Normal case. srp_remove_one frees srp_device. Then all refs
> to host are dropped and we call srp_exit_cmd_priv which accesses
> the freed srp_device?
> 
> You don't need the above patch for this case right.
> 
> 2. Are you hitting a race? Something did a scsi_remove_device. It
> set the device state to SDEV_DEL. It's stuck in blk_cleanup_queue
> blk_freeze_queue. Now we do the above code. Without your patch
> we just move on by that device. Commands could still be accessed.
> With your patch we wait for for that other thread to complete the
> device destruction.
> 
> 
> Could you also solve both issues by adding a scsi_host_template
> scsi_host release function that's called from scsi_host_dev_release. A
> new srp_host_release would free structs like the srp device from there.
> Or would we still have an issue for #2 where we just don't know how
> far blk_freeze_queue has got so commands could still be hitting our
> queue_rq function when we are doing scsi_host_dev_release?
> 
> I like how your patch makes it so we know after scsi_remove_host
> has returned that the device is really gone. Could we have a similar
> race as in #2 with someone doing a scsi_remove_device and transport
> doing scsi_remove_target?
> 
> We would not hit the same use after free from the tag set exit_cmd_priv
> being called. But, for example, if we wanted to free some transport level
> resources that running commands reference after scsi_target_remove could
> we hit a use after free? If so maybe we want to move this wait/check to
> __scsi_remove_device?

Hi Mike,

Although I'm not sure that I completely understood the above: my goal 
with this patch is to make sure that all activity on the host tag set 
has stopped by the time scsi_forget_host() returns. I do not only want 
to cover the case where scsi_remove_host() is called by the ib_srp 
driver but also the case where a SCSI device that was created by the 
ib_srp driver is removed before scsi_remove_host() is called. Users can 
trigger this scenario by writing into /sys/class/scsi_device/*/*/delete.

Adding a new callback into scsi_host_dev_release() would not help 
because the scsi_host_dev_release() call may happen long after 
scsi_forget_host() returned.

Does this answer your question?

Bart.

