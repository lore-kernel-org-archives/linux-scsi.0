Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27894C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 13:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjDSNiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 09:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjDSNiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 09:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34794C01
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 06:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681911395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NxFM0uCpkM5WZQwbOoLFODsnTRr+rN7kSoXtBMEcv68=;
        b=jWG6ty4fj+3t2u58Q92z70wGFBzH9Zt34ZmwhfRdtqHSefkuHBH5orct/0PVcfphLdnppO
        eYjFaQU45xeSD4k+DbSKPz5+nfyOLGhbxjyBWL98IiTWMTLCP9F++YfycmACpKGTJqzPr1
        6Yd5cpacx8a43bbgO1mJ1Yc2IRn1RKc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-XKA83tHmNlmHJUv7FbH8zg-1; Wed, 19 Apr 2023 09:36:34 -0400
X-MC-Unique: XKA83tHmNlmHJUv7FbH8zg-1
Received: by mail-ej1-f69.google.com with SMTP id l20-20020a1709065a9400b0094f1a119b2eso4759886ejq.18
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 06:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911392; x=1684503392;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NxFM0uCpkM5WZQwbOoLFODsnTRr+rN7kSoXtBMEcv68=;
        b=RVZ74zybKfgbxnXc29XcPp2ztlDBvd0B+YJisYysmr0dzcVXQ+LNoE0AMEv2nkPZ4o
         HGMlRdHzlGF+kYkKM/7XlpHLAwTER6RIn0BswpZl7F01dIP1AKmTUUT2ZinkB+LNLPcU
         iliz/w1Yv6VVTCMGJkhZuy9VFOMscmvNTnLVjd+17j5mOcn0200CBmC1uyJqINZKPe+p
         orP/6VqHiQBck8wcxKrhCH6q4phbnD8eI2/E7Q8ZV6N8jicHEh5m0F11fDMS1Ab8TWob
         7AY0zls0LaRRs21BPFsaIkYA/L5vYzlT0a5wdmn1F6qNns/+8Nx4NS2wM4ZuIJDGee+2
         q5pw==
X-Gm-Message-State: AAQBX9f+k/T0d9f8ToPl7n1P/MEl8RJwIJcmz8TFHoq4KM+nL33K6rg1
        fr0lTtW20/s7J4txKWH3ZxIRJwwnelsYJyTTkehh1iSXJvYFAyyB3VInmE8Loz8UFfITSfEhEVT
        fObPOHV7JvWeaPAeJ3aPQEFYHLhFTwjBs
X-Received: by 2002:a17:906:80e:b0:947:92c9:6aa4 with SMTP id e14-20020a170906080e00b0094792c96aa4mr14239050ejd.4.1681911392330;
        Wed, 19 Apr 2023 06:36:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y9FwSJS5J/MALldR0npTfAWjnamAI3kmZEE8SlPO+rtQMMbOEqvGWncCmcC8p0rStlTsKG8w==
X-Received: by 2002:a17:906:80e:b0:947:92c9:6aa4 with SMTP id e14-20020a170906080e00b0094792c96aa4mr14239028ejd.4.1681911391995;
        Wed, 19 Apr 2023 06:36:31 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id t16-20020a170906269000b00932ba722482sm9581364ejc.149.2023.04.19.06.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:36:30 -0700 (PDT)
Message-ID: <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
Date:   Wed, 19 Apr 2023 15:36:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
To:     jejb@linux.ibm.com, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-2-bvanassche@acm.org>
 <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
 <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
 <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/23 04:34, James Bottomley wrote:
> On Tue, 2023-04-18 at 11:37 -0700, Bart Van Assche wrote:
>> On 4/18/23 07:36, James Bottomley wrote:
>>> On Mon, 2023-04-17 at 16:06 -0700, Bart Van Assche wrote:
>>>> System shutdown happens as follows (see e.g. the systemd source
>>>> file src/shutdown/shutdown.c):
>>>> * sync() is called.
>>>> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
>>>> * If the reboot() system call returns, log an error message.
>>>>
>>>> The reboot() system call causes the kernel to call
>>>> kernel_restart(), kernel_halt() or kernel_power_off(). Each of
>>>> these functions calls device_shutdown(). device_shutdown() calls
>>>> sd_shutdown(). After sd_shutdown() has been called the
>>>> .shutdown() callback of the LLD will be called. Hence, I/O
>>>> submitted after sd_shutdown() will hang or may even cause a
>>>> kernel crash.
>>>>
>>>> Let sd_shutdown() fail future I/O such that LLD .shutdown()
>>>> callbacks can be simplified.
>>>
>>> What is the actual reason for this?  What is it you think might be
>>> submitting I/O after the system gets into this state?  Current
>>> sd_shutdown is constructed on the premise that it's the last thing
>>> that ever happens to the device before reboot/power off which is
>>> why it flushes the cache if necessary and stops the device if
>>> required, but for most standard devices neither is required because
>>> we don't expect Linux to go down with pending items in the block
>>> queue and for a write through disk cache anything that's completed
>>> on the block queue is safely durable on the device.
>>
>> Hi James,
>>
>> .shutdown() callbacks should quiesce I/O but the sd_shutdown()
>> function doesn't do this. I see this as a bug.
> 
> Why? They're only called on reboot or shutdown.  In orderly cases, the
> queues should have been stopped long ago, so there should be no I/O to
> quiesce, and in the disorderly case, you obviously didn't care about
> the data anyway, so the job of the shutdown routine is to salvage as
> much as it can, which is why we flush the cache and stop the disk if
> necessary.

A kernel panic has been reported caused by I/O arriving after driver's
shutdown (the driver is fixed now so just scsi exception handling is
logged).
All drivers should have a protection against late commands queued, with
a block after sd.shutdown that could be dropped  and so well written
drivers could enjoy a bit easier/faster code and and those not well
written wouldn't be waiting for issues yet to come.

What actually is the downside of blocking further I/O in sd shutdown?

> 
>> Regarding your question, I think that sd_check_events() can be called
>> while sd_shutdown() is in progress or after sd_shutdown() has
>> finished.  sd_check_events() may submit a TEST UNIT READY command.
> 
> If that's true, that would argue that the block layer caller should be
> aware of the shutdown and not do this.  On the other hand, if the TUR
> fails, what is the harm?
> 
>> In pci_device_shutdown() one can see that the PCI core clears the bus
>> master bit for PCI devices during shutdown. In other words, it is not
>> safe to submit I/O or to process completions during invocation of 
>> shutdown callbacks. I think that also shows that this patch fixes a
>> bug.
> 
> I don't think it does: in the orderly case, there should be no I/O
> outstanding, so nothing to trigger and in the disorderly case, you have
> no expectation of the I/O reaching the device, so what would the actual
> bug be that this fixes?


> 
> James
> 

