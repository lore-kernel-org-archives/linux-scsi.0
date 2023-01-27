Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B65C61D97
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 17:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbjA0RXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 12:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbjA0RX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 12:23:29 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1506227492;
        Fri, 27 Jan 2023 09:23:26 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id m11so5241301pji.0;
        Fri, 27 Jan 2023 09:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yjI2o5+xsSKlMtwASoiHazJkcoTLFI5iI/nAJzHdF+M=;
        b=6QTcDFwb8v9YzX+71/dymVk6Az8o5aym0zSZobKCduqs8k4xL97f7nhMjeR11eFTfD
         8VZeGDZ2yIsDmOl1aKvJDbotQwpJ7KWQcuV2luppWRk4GUa+4oZBxLo71QZjeyIrDX8F
         ez+rHcBtuwdihA9FbGQFPn5yY8BWiBk5dJfe/5xKdj1Pr1U0BUaqEeBs1ny2sEGNiVvL
         pftthPBfCqTjNh2xVKCGQW75+YHmeSVNtc9opbJtT6Wn01/81iYUPx6JC9ff0wmFBo+Q
         Z2giIHIKP8PGI1z2V2qSYVL3btIjoI4Re2u9OiTEZeceOeQZulolWMHfWZLR9xFvHnJO
         7soA==
X-Gm-Message-State: AFqh2kolqDk3fvnQdhWYVaRPKVjdhWDQyW6W29+qX8GrcqOlDie0Nrfk
        qx9gf9VUiN5ZIMJ5U1+8Q98=
X-Google-Smtp-Source: AMrXdXt+PvYMWjU69aaZyBTZ086XLxOPQc0GJGaq8H6ao3qPzun4IE+4JOn2Z+/Y5nDlETpnXaSFyA==
X-Received: by 2002:a17:902:e9cd:b0:194:6627:d7ab with SMTP id 13-20020a170902e9cd00b001946627d7abmr41214554plk.12.1674840205360;
        Fri, 27 Jan 2023 09:23:25 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id c24-20020a170902d91800b00189db296776sm3147226plz.17.2023.01.27.09.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 09:23:24 -0800 (PST)
Message-ID: <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
Date:   Fri, 27 Jan 2023 09:23:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
 <Y9KF5z/v0Qp5E4sI@x1-carbon> <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
 <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
 <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/26/23 17:40, Damien Le Moal wrote:
> On 1/27/23 09:18, Damien Le Moal wrote:
>> On 1/27/23 02:33, Bart Van Assche wrote:
>>> How about only supporting a subset of the standard such that it becomes
>>> easy to map CDLs to host side priority levels?
>>
>> I am opposed to this, for several reasons:
>>
>> 1) We are seeing different use cases from users that cover a wide range of
>> use of CDL descriptors with various definitions.
>>
>> 2) Passthrough commands can be used by a user to change a drive CDL
>> descriptors without the kernel knowing about it, unless we spend our time
>> revalidating the CDL descriptor log page(s)...
>> 3) CDL standard as is is actually very sensible and not overloaded with
>> stuff that is only useful in niche use cases. For each CDL descriptor, you
>> have:
>>   * The active time limit, which is a clean way to specify how much time
>> you allow a drive to deal with bad sectors (mostly read case). A typical
>> HDD will try very hard to recover data from a sector, always. As a result,
>> the HDD may spend up to several seconds reading a sector again and again
>> applying different signal processing techniques until it gets the sector
>> ECC checked to return valid data. That of course can hugely increase an IO
>> latency seen by the host. In applications such as erasure coded
>> distributed object stores, maximum latency for an object access can thus
>> be kept low using this limit without compromising the data since the
>> object can always be rebuilt from the erasure codes if one HDD is slow to
>> respond. This limit is also interesting for video streaming/playback to
>> avoid video buffer underflow (at the expense of may be some block noise
>> depending on the codec).
>>   * The inactive time limit can be used to tell the drive how long it is
>> allowed to let a command stand in the drive internal queue before
>> processing. This is thus a parameter that allows a host to tune the drive
>> RPO optimization (rotational positioning optimization, e.g. HDD internal
>> command scheduling based on angular sector position on tracks withe the
>> head current position). This is a neat way to control max IOPS vs tail
>> latency since drives tend to privilege maximizing IOPS over lowering max
>> tail latency.
>>   * The duration guideline limit defines an overall time limit for a
>> command without distinguishing between active and inactive time. It is the
>> easiest to use (the easiest one to understand from a beginner user point
>> of view). This is a neat way to define an intelligent IO prioritization in
>> fact, way better than RT class scheduling on the host or the use of ATA
>> NCQ high priority, as it provides more information to the drive about the
>> urgency of a particular command. That allows the drive to still perform
>> RPO to maximize IOPS without long tail latencies. Chaining such limit with
>> an active+inactive time limit descriptor using the "next limit" policy
>> (0x1 policy) can also finely define what the drive should if the guideline
>> limit is exceeded (as the next descriptor can define what to do based on
>> the reason for the limit being exceeded: long internal queueing vs bad
>> sector long access time).
> 
> Note that all 3 limits can be used in a single CDL descriptor to precisely
> define how a command should be processed by the device. That is why it is
> nearly impossible to come up with a meaningful ordering of CDL descriptors
> as an increasing set of priority levels.

A summary of my concerns is as follows:
* The current I/O priority levels (RT, BE, IDLE) apply to all block 
devices. IOPRIO_CLASS_DL is only supported by certain block devices 
(some but not all SCSI harddisks). This forces applications to check the 
capabilities of the storage device before it can be decided whether or 
not IOPRIO_CLASS_DL can be used. This is not something applications 
should do but something the kernel should do. Additionally, if multiple 
dm devices are stacked on top of the block device driver, like in 
Android, it becomes even more cumbersome to check whether or not the 
block device supports CDL.
* For the RT, BE and IDLE classes, it is well defined which priority 
number represents a high priority and which priority number represents a 
low priority. For CDL, only the drive knows the priority details. I 
think that application software should be able to select a DL priority 
without having to read the CDL configuration first.

I hope that I have it made it clear that I think that the proposed user 
space API will be very painful to use for application developers.

Bart.

