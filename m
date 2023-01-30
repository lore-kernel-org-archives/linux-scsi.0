Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95585C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 13:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbjA3Nob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 08:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjA3Noa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 08:44:30 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3063F15552;
        Mon, 30 Jan 2023 05:44:29 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E288621AE7;
        Mon, 30 Jan 2023 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675086267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqdDde2VpNl4ymLDR49F5nUaI943cA15fmxKV7GL+FY=;
        b=edJZGTP1PNJGcNsq6gM5fip7RQwBVj9zU8C56WkbYNt5IFwTcPiPfBml4HubTVNk316kry
        HIzr8nxQ5lZF2CZGF9SdKKJQOPecwkE2MibAiaIsVODvXgX/3c2PJngalyL0KO5YHiwi2Y
        XY7dJpd6G3JYkFmFHJqF7pWunfOpJ2s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675086267;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqdDde2VpNl4ymLDR49F5nUaI943cA15fmxKV7GL+FY=;
        b=QYMr2+44g7gU9zknp2OsTUMIFB1k0HD4zS5gM5M0b2eL8R7CVHOBpJb3UnI1ikh2c/heMq
        udNWPPBZCqWY4fCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CAB9713A06;
        Mon, 30 Jan 2023 13:44:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EYYzMbvJ12MAZgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 30 Jan 2023 13:44:27 +0000
Message-ID: <f58200e2-1652-c726-ceaf-be78feaab1bc@suse.de>
Date:   Mon, 30 Jan 2023 14:44:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
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
 <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
 <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
 <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
 <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
 <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
 <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/29/23 04:52, Damien Le Moal wrote:
> On 1/29/23 05:25, Martin K. Petersen wrote:
[ .. ]
>>
>>     As such, I don't like the "just customize your settings with
>>     cdltools" approach. I'd much rather see us try to define a few QoS
>>     classes that make sense that would apply to every app and use those
>>     to define the application interface. And then have the kernel program
>>     those CDL classes into SCSI/ATA devices by default.
> 
> Makes sense. Though I think it will be hard to define a set of QoS hints that
> are useful for a wide range of applications, and even harder to convert the
> defined hint classes to CDL descriptors. I fear that we may end up with the same
> issues as IO hints/streams.
> 
>>     Having the kernel provide an abstract interface for bio QoS and
>>     configuring a new disk with a sane handful of classes does not
>>     prevent $CLOUD_VENDOR from overriding what Linux configured. But at
>>     least we'd have a generic approach to block QoS in Linux. Similar to
>>     the existing I/O priority infrastructure which is also not tied to
>>     any particular hardware feature.
> 
> OK. See below about this.
> 
>>     A generic implementation also allows us to do fancy things in the
>>     hypervisor where we would like to be able to do QoS across multiple
>>     devices as well. Without having ATA or SCSI with CDL involved. Or
>>     whatever things might look like in NVMe.
> 
> Fair point, especially given that virtio actually already forwards a guest
> ioprio to the host through the virtio block command. Thinking of that particular
> point together with what you said, I came up with the change show below as a
> replacement for this patch 1/18.
> 
> This changes the 13-bits ioprio data into a 3-bits QOS hint + 3-bits of IO prio
> level. This is consistent with the IO prio interface since IO priority levels
> have to be between 0 and 7 (otherwise, errors are returned). So in fact, the
> upper 10-bits of the ioprio data are ignored and we can safely use 3 of these
> bits for an IO hint.
> 
> This hint applies to all priority classes and levels, that is, for the CDL case,
> we can enrich any priority with a hint that specifies the CDL index to use for
> an IO.
> 
> This falls short of actually defining generic IO hints, but this has the
> advantage to not break anything for current applications using IO priorities,
> not require any change to existing IO schedulers, while still allowing to pass
> CDL indexes for IOs down to the scsi & ATA layers (which for now would be the
> only layers in the kernel acting on the ioprio qos hints).
> 
> I think that this approach still allows us to enable CDL support, and on top of
> it, go further and define generic QOS hints that IO scheduler can use and that
> also potentially map to CDL for scsi & ata (similarly to the RT class IOs
> mapping to the NCQ priority feature if the user enabled that feature).
> 
> As mentioned above, I think that defining generic IO hint classes will be
> difficult. But the change below is I think a good a starting point that should
> not prevent working on that.
> 
> Thoughts ?
> 
I like the idea.
QoS is one of the recurring topic always coming up sooner or later when 
talking of storage networks, so having _some_ concept of QoS in the 
linux kernel (for storage) would be beneficial.

Maybe time for a topic at LSF?

Cheers,

Hannes

