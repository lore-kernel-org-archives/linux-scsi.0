Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD7C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 14:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjDROJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjDROJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 10:09:54 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4413861
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:09:51 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso1854441b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826991; x=1684418991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BnN7RUG0/VZdqS8/RMv2LKZHVTElyp1FELAoGQI+ORU=;
        b=bBvfXekgFlhVLQ8XiVURG56JbeEif2qNPH3rrSfeg8+LmhXTZzdAHXEBPESjT/un/s
         K5P89lpiPbFs3UrfJk1Pb6n+YDvjKyzNEyz2HGM1FVELSKNuJvwEQFZr/rOCnscCB7C6
         rbD7U9b4gsTe9Hw5VYgn++sGAsGLeozJuULH1BEvtPfFyI+ASWvxLNnJELbZm8XCIqNO
         EHQohJD86m+4JoW/Tna5XAjyrhxUHqwm44qlrmZHhvt0GYdU5lAYcjolxtWNwUQ+zper
         5VwVHV4sph8Ex82Fkp0Mri2dG0i803smpJelu5sz2fAxe3BeIRngNT2eifHTjJotgvrB
         2yAQ==
X-Gm-Message-State: AAQBX9ei3G5/rTOFOc7IguFGbq98qqrWoRfZyIoGkCLgBtVrnoHl+sFn
        hxvlypmjAtWU9qTKiQODiYg=
X-Google-Smtp-Source: AKy350Zdmw3yoJlW5sDVUVW8xTfud3wJUUaspNnBLSXSDtgtlpQHfNUIogPQLIA0Nu7r4V1IcSl/pA==
X-Received: by 2002:a05:6a00:1306:b0:63b:435f:134a with SMTP id j6-20020a056a00130600b0063b435f134amr23383372pfu.28.1681826990976;
        Tue, 18 Apr 2023 07:09:50 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n25-20020aa78a59000000b006396be36457sm9410887pfa.111.2023.04.18.07.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 07:09:50 -0700 (PDT)
Message-ID: <429be04d-ffc9-3a02-8d60-e4d790b7610e@acm.org>
Date:   Tue, 18 Apr 2023 07:09:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-2-bvanassche@acm.org>
 <ZD4ehvYdkxmESFNB@ovpn-8-16.pek2.redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZD4ehvYdkxmESFNB@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/23 21:37, Ming Lei wrote:
> On Mon, Apr 17, 2023 at 04:06:53PM -0700, Bart Van Assche wrote:
>> System shutdown happens as follows (see e.g. the systemd source file
>> src/shutdown/shutdown.c):
>> * sync() is called.
>> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
>> * If the reboot() system call returns, log an error message.
>>
>> The reboot() system call causes the kernel to call kernel_restart(),
>> kernel_halt() or kernel_power_off(). Each of these functions calls
>> device_shutdown(). device_shutdown() calls sd_shutdown(). After
>> sd_shutdown() has been called the .shutdown() callback of the LLD
>> will be called. Hence, I/O submitted after sd_shutdown() will hang or
>> may even cause a kernel crash.
>>
>> Let sd_shutdown() fail future I/O such that LLD .shutdown() callbacks
>> can be simplified.
> 
> Hi Bart,
> 
> Last time you mentioned the current way may have kernel panic risk, but
> you never explain the panic, can you document the panic in commit log?

Hi Ming,

I removed the references to the risk of a kernel panic since I think 
that shutdown methods should not introduce that risk. From 
include/device/bus.h:

  * @shutdown:	Called at shut-down time to quiesce the device.

That comment says "quiesce the device". It does not say that it is 
allowed to crash the system if more I/O is submitted to the device.

Thanks,

Bart.
