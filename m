Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAA6C11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 21:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B4D6146D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 21:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhF3VgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 17:36:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhF3VgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 17:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625088814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgjM7h6kQ4+JpD+F/rs8RuWpP0R5bL5JOfRbl/HNQIA=;
        b=cpxBToy2Ov43yIYHVvxoygqzR6LPzQFAufguHT/60uS0KMAd7v0NO8XmGQVEM5p0aq5s4A
        CUNDDwmZEeZ832Obl6GPeaCRkXmi+jaEzsG9H7Lcn9sh6w9u139Fb6mwvKK+IdqFqYp+XL
        T6TSOgE7lLyvb1SyW1rAVGeojGJedqA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-Uhypsdb1MEKw6R6x7ZVFSg-1; Wed, 30 Jun 2021 17:33:32 -0400
X-MC-Unique: Uhypsdb1MEKw6R6x7ZVFSg-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so1900982edw.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2021 14:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zgjM7h6kQ4+JpD+F/rs8RuWpP0R5bL5JOfRbl/HNQIA=;
        b=ZwVi54NG93ezPUrXiE4ZDh3HJqt4AIHx+A3APOhU72smCSaO+oWjWZGq8/6kvDQ1oI
         Pma6Qr0Kc1V3bAZG8cRFncCBe/fI7g9FTNjLrp3uMwZjCeCSnd9ROWkA7+ZzBr1nhlOx
         0NTtDm19y9k7wwzCeOTYrPI1GVRKJCkysAEOOmDfDS5dhXUekmTmkfTK62ltSnBcI2g6
         kTn1YRK3JhXOUfT01efkjwzn3vlTPuTzkiNSWWdFurO8ZzxF/nNwhAhFUu0uTxtmuV5y
         jfl5o/7JsRTCKuj6PktDown3ebkxKM5iMOS3mL6XUk8ElNyOgrJ5090FCluUfr2TEggw
         IfXw==
X-Gm-Message-State: AOAM530zAaZOLE9Q2tW5LG4Lqdzeie8K/C/NLKxSLhCDGQzvplCvEzQl
        6ssE4tgD0A1s99fETJAyvcH+AJSyWo45+ko+bGfQNnHjQxSfS50TLCQUxye3pauj1PQmks9O7aE
        oQZahg8Q3sfujA98tPU49sd47SOvUxUIkKlPmwcnRBYoZaxpJn9CVJ0EtwD5kh6+zCDSc7fmX
X-Received: by 2002:a17:906:17c4:: with SMTP id u4mr38277254eje.481.1625088811093;
        Wed, 30 Jun 2021 14:33:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIC1o4hc5k6wIYJm0JjMQtRnRmyp/hhMALjBNNwR6nOwEGuaBm62qZtwkAVC8Ar6LmWVjVmw==
X-Received: by 2002:a17:906:17c4:: with SMTP id u4mr38277240eje.481.1625088810831;
        Wed, 30 Jun 2021 14:33:30 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id mh19sm1476599ejb.24.2021.06.30.14.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:33:30 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: smartpqi cannot change IRQ smp_affinity
To:     Don.Brace@microchip.com, jbrouer@redhat.com, hch@infradead.org
Cc:     don.brace@microsemi.com, linux-scsi@vger.kernel.org
References: <c8ed244c-61d0-eead-8ec3-fe8f2e239d71@redhat.com>
 <SN6PR11MB284870DAB389F96D45B51F05E1019@SN6PR11MB2848.namprd11.prod.outlook.com>
Message-ID: <9db66a3e-25ea-0046-d176-ffdcd47cdbbe@redhat.com>
Date:   Wed, 30 Jun 2021 23:33:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB284870DAB389F96D45B51F05E1019@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 30/06/2021 22.56, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: Jesper Dangaard Brouer [mailto:jbrouer@redhat.com]
> Sent: Wednesday, June 30, 2021 3:17 PM
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Don Brace <don.brace@microsemi.com>; linux-scsi@vger.kernel.org
> Subject: smartpqi cannot change IRQ smp_affinity
>
> Hi Hellwig and Don,
>
>
> On driver smartpqi I cannot change smp_affinity and smp_affinity_list entries.
>
> It was suppose to be fixed by this patch:
> https://patchwork.kernel.org/project/linux-scsi/patch/154422179851.1218.10349207247849277036.stgit@brunhilda/
>
> I can see that Hellwig added back PCI_IRQ_AFFINITY flag in commit 5219822687be ("scsi: smartpqi: switch to pci_alloc_irq_vectors").
>
>
> Is there another way I can control which CPU that process IRQs from the disk controller?
>
> --Jesper
>
> (lspci output below)
>
> b2:00.0 Serial Attached SCSI controller: Adaptec Smart Storage PQI SAS (rev 01)
>
>           Kernel driver in use: smartpqi
>           Kernel modules: smartpqi
>
> Don:
> Can you tell us what OS you are running and the driver version?
> Output from uname -r and /sys/class/scsi_host/host4/driver_version
> My system is using host4, it may be different on your system.
>
Kernel version is v5.11.8 (self compiled from stable tree)

# grep -H . /sys/class/scsi_host/host0/driver_version
/sys/class/scsi_host/host0/driver_version:1.2.16-012

--Jesper


Other info:

# grep -H . /sys/class/scsi_host/host0/* 2> /dev/null
/sys/class/scsi_host/host0/active_mode:Initiator
/sys/class/scsi_host/host0/can_queue:1013
/sys/class/scsi_host/host0/cmd_per_lun:1013
/sys/class/scsi_host/host0/driver_version:1.2.16-012
/sys/class/scsi_host/host0/eh_deadline:off
/sys/class/scsi_host/host0/firmware_version:3.00-0
/sys/class/scsi_host/host0/host_busy:0
/sys/class/scsi_host/host0/lockup_action:[none] reboot panic
/sys/class/scsi_host/host0/model:E208i-a SR Gen10
/sys/class/scsi_host/host0/nr_hw_queues:12
/sys/class/scsi_host/host0/proc_name:smartpqi
/sys/class/scsi_host/host0/prot_capabilities:0
/sys/class/scsi_host/host0/prot_guard_type:0
/sys/class/scsi_host/host0/serial_number:PWDRD0FRHED160
/sys/class/scsi_host/host0/sg_prot_tablesize:0
/sys/class/scsi_host/host0/sg_tablesize:257
/sys/class/scsi_host/host0/state:running
/sys/class/scsi_host/host0/supported_mode:Initiator
/sys/class/scsi_host/host0/unchecked_isa_dma:0
/sys/class/scsi_host/host0/unique_id:156
/sys/class/scsi_host/host0/use_blk_mq:1
/sys/class/scsi_host/host0/vendor:HPE

