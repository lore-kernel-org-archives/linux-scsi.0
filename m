Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554E5C761AF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 14:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjCaOMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 10:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjCaOMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 10:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B07E1F783
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 07:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680271912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZF6/7UFw/AEgE9yuXCD//qE8UNr7AYOx1w2+NhD94bU=;
        b=TwEk7oY2y2HYXJ/NYu+dkZ+u54liI68csN12HKmwPShIA/XIqnW5xOIuseLaB/73ugfH3Q
        CHzpjKIMpRizFWj/+O3H8JRqoBFvCCnOAT0k9vjT5zkZeFDVOnWkHdwkJXjkUtnsCfsLbf
        Bn0N6gNrRFJQ7sFzx8n86Jz+/APnMSw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-pfVF9HGBMH26TfYgTMsv5A-1; Fri, 31 Mar 2023 10:11:51 -0400
X-MC-Unique: pfVF9HGBMH26TfYgTMsv5A-1
Received: by mail-wm1-f70.google.com with SMTP id j27-20020a05600c1c1b00b003edd2023418so12095975wms.4
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 07:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZF6/7UFw/AEgE9yuXCD//qE8UNr7AYOx1w2+NhD94bU=;
        b=LvM5zSuaDf71oSBUVy/iuTo5dROstLs2CulA0ezO/igCFQMHq9LN2kA+t68MEid+pm
         5GHkjdF7QEaDLdT8SDXx08p+wJ8toxUpLMUqVQGCDliLdqjjqDfjiLXd1/oSBKy9dzgH
         d72P05HhZLlC8t/uv3SadIDXrckwKgsQBD6oRgsBOr4XlQdB/P2QJP0vYNhUxKYnnnJ+
         pAbWkyIgOAvwRnaamLy2cyXUSKeAT6klAfbpHbDOQlqigmngMQ0vifisJYvTiZ23S2wq
         7NBNq9oI43nk7binLPVhYI/+ZA4wpb/CMvwsb7gr6Cn8oX/+KsJgRUMNk947034ru93F
         8A0A==
X-Gm-Message-State: AAQBX9e/eBtVrdVDryaT3Gph4BE/UvUnotsmLfrmpteJv03mT+duDAM8
        lG0h1RMSIqMC047DNsmluv65x58LIOUo92Ge3Qkw/s8xkb0E6QYyTGw5UJQwY8laeUkqB9dHkk0
        PQU0QFSOt5yas0pW5mE5E4Q==
X-Received: by 2002:adf:e443:0:b0:2c7:6bb:fb7a with SMTP id t3-20020adfe443000000b002c706bbfb7amr22179797wrm.54.1680271909956;
        Fri, 31 Mar 2023 07:11:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350aVzbeuj4DkrWma4eNOSa+LInSi0MD9w3uw0fhAgLCcVJ6esHewMOr4CBjpNPBW9Cw/tyzc1g==
X-Received: by 2002:adf:e443:0:b0:2c7:6bb:fb7a with SMTP id t3-20020adfe443000000b002c706bbfb7amr22179783wrm.54.1680271909677;
        Fri, 31 Mar 2023 07:11:49 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id d14-20020a5d4f8e000000b002d1bfe3269esm2303719wru.59.2023.03.31.07.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 07:11:49 -0700 (PDT)
Message-ID: <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
Date:   Fri, 31 Mar 2023 16:11:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
 <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/23 13:48, James Bottomley wrote:
> On Thu, 2023-03-30 at 12:12 -0500, Mike Christie wrote:
>> On 3/30/23 11:49 AM, Tomas Henzl wrote:
>>> Set the state to deleted in sd_shutdown so that the attached LLD
>>> doesn't receive new I/O (can happen when in kexec) later after
>>> LLD's shutdown function has been called.
>>>
>>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>>> ---
>>>  drivers/scsi/sd.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 4f28dd617eca..8095f0302e66 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct
>>> scsi_disk *sdkp, int start)
>>>  static void sd_shutdown(struct device *dev)
>>>  {
>>>         struct scsi_disk *sdkp = dev_get_drvdata(dev);
>>> +       struct scsi_device *sdp;
>>>  
>>>         if (!sdkp)
>>>                 return;         /* this can happen */
>>>  
>>> +       sdp = sdkp->device;
>>> +
>>>         if (pm_runtime_suspended(dev))
>>>                 return;
>>>  
>>> @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
>>>                 sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>>                 sd_start_stop_device(sdkp, 0);
>>>         }
>>> +
>>> +       mutex_lock(&sdp->state_mutex);
>>> +       scsi_device_set_state(sdp, SDEV_DEL);
>>> +       mutex_unlock(&sdp->state_mutex);
>>>  }
>>
>> If this is run for device removal what state will be in here?
>>
>> Are we going to do:
>> 1. __scsi_remove_device sets the state to SDEV_CANCEL at the
>> beginning of the function
> 
> It will also interfere with target and host device removal.  They
> traverse their own lists and assume that anything in DEL is already
> being removed, which won't be the case here.  So basically, after this
> happens it's impossible to clean the device trees.  It also means any
> I/O to the root device wouldn't be allowed.
How will it interfere? After a return from sd_remove or via
device_unregister->__scsi_remove_device the device state is SDEV_DEL
regardless whether this patch has been added or not. Or is sd_shutdown
called directly?

> I assume the contention is that if we get here, we're either going for
> immediate shutdown or all the root device remounting to read only has
> already been done?  If so, could you say that?
I can't say that, quite the opposite (see body of the mail). When the
system goes shutdown the individual device's .shutdown is called. Just
moments after sd shutdown the LLD shutdown is entered and the driver
stops any I/O immediately anyway. With this patch the I/O is stopped
before reaching LLD with a reasonable message and without error
correction mechanism in place.

I also assume that no I/O after sd_shutdown was projected when it was
written as there is a cache sync followed by a device power down.

Tomas

> 
> James
> 

