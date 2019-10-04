Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B0FC47404
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 15:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D88622133F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 15:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389907AbfJDPjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:39:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46667 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389669AbfJDPjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Oct 2019 11:39:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so4091215pfg.13;
        Fri, 04 Oct 2019 08:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LPZcR9vYxD7erJGoUJ+dyEN9GJmt/Kbx5l70ig2hsVA=;
        b=QMVHb/Ho8dnzQM34HvJMiuN4E5Jeann01XFtS7qvjoZMSyCZGkYH6csHtB0Lh9hKVK
         I7H0iKS1Exu0KxgmzizDDvFKQ7zFKwbkNsUESmrHBiFfoWpbJzoDWn/xemZQN5wOIVes
         fB0rIjLHqtxn9jkKuRn5+vlsOOk5IgnSHuhrs5gUd+EF2OMSgo1L0GYkqvbrVtQGM88w
         v2VzpI+m14eYcZQONMQWnTwCOIRy2AzP7TW/gL4+liuqfHNwcCdYagRDHPlb9uNbw2ox
         1l3ik4gpmIuyAvxt3BIORoXLxFTLJGhyAq49kV7Pg+Na58FoqonusxdYQi7I6/+hTVU8
         V4Dw==
X-Gm-Message-State: APjAAAVw4BicL1M9Z08HAERr2bsjphYaFk5TRUJYMX9ePbVz9yz6og9w
        ihlFVTjD86oMlpuc0KkdYkdLpsOQ
X-Google-Smtp-Source: APXvYqzd3JVwgYeuUDq87Aea29aobbNo5xId1PIq8mt65wQzoTkvP+ZRWS9HXmM+IUesHdTAA9ohEQ==
X-Received: by 2002:a17:90a:178d:: with SMTP id q13mr17776886pja.134.1570203543118;
        Fri, 04 Oct 2019 08:39:03 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e127sm7731503pfe.37.2019.10.04.08.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 08:39:02 -0700 (PDT)
Subject: Re: SCSI device probing non-deterministic in 5.3
To:     Randy Dunlap <rdunlap@infradead.org>,
        Bradley LaBoon <blaboon@linode.com>,
        linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <d2ff27ce-67b0-735e-8652-0e925d5f756c@linode.com>
 <f6d6622d-a9a0-d7de-b5af-b7a885ee1b61@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <59eedd28-25d4-7899-7c3c-89fe7fdd4b43@acm.org>
Date:   Fri, 4 Oct 2019 08:39:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f6d6622d-a9a0-d7de-b5af-b7a885ee1b61@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/19 2:19 PM, Randy Dunlap wrote:
> [add linux-scsi mailing list]
> 
> On 10/3/19 1:32 PM, Bradley LaBoon wrote:
>> Hello, LKML!
>>
>> Beginning with kernel 5.3 the order in which SCSI devices are probed and
>> named has become non-deterministic. This is a result of a patch that was
>> submitted to add asynchronous device probing (specifically, commit
>> f049cf1a7b6737c75884247c3f6383ef104d255a). Previously, devices would
>> always be probed in the order in which they exist on the bus, resulting
>> in the first device being named 'sda', the second device 'sdb', and so on.
>>
>> This is important in the case of mass VM deployments where many VMs are
>> created from a single base image. Partition UUIDs cannot be used in the
>> fstab of such an image because the UUIDs will be different for each VM
>> and are not known in advance. Normally you can't rely on device names
>> being consistent between boots, but with QEMU you can set the bus order
>> of each block device and thus we currently use that to control the
>> device order in the guest. With the introduction of the aforementioned
>> patch this is no longer possible and the device ordering is different on
>> every boot, resulting in the guest booting into an emergency shell
>> unless the devices randomly happen to be loaded in the expected order.
>>
>> I have created a patch which reverts back to the previous behavior, but
>> I wanted to open this topic to discussion before posting it. I'm not
>> totally familiar with the low-level details of SCSI device probing, so I
>> don't know if the non-deterministic device order was the intended
>> behavior of the patch or just a side-effect. If that is the intended
>> behavior then is there perhaps some other way to ensure a consistent
>> device ordering for a guest VM?

Have you already had a look at the /dev/disk/by-path directory? An 
example of the contents of that directory:

$ (cd /dev/disk/by-path && ls -l | grep /s)
lrwxrwxrwx 1 root root  9 Oct  3 16:49 pci-0000:00:02.0-ata-1 -> ../../sda
lrwxrwxrwx 1 root root  9 Oct  3 16:49 pci-0000:00:08.0-scsi-0:0:0:1 -> 
../../sr0

Have you considered to use these soft links in /etc/fstab?

In case using these links would be impractical: have you considered to 
add a udev rule that creates H:C:I:L soft links under a subdirectory of 
/dev, that makes these soft links point at the /dev/sd* device nodes and 
to use these soft links in /etc/fstab? That's probably a much more 
elegant solution than what has been proposed above.

As one can see the information that is needed to implement such a udev 
rule is already available in sysfs:

$ (cd /sys/class/scsi_device && ls -ld */device/block/*)
drwxr-xr-x 9 root root 0 Oct  3 16:48 2:0:0:1/device/block/sr0
drwxr-xr-x 9 root root 0 Oct  3 16:48 3:0:0:0/device/block/sda

Bart.
