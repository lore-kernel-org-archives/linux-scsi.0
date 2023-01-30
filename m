Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55725C54EED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 14:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbjA3Oz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 09:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbjA3Oz0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 09:55:26 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8942B0A5
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 06:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675090518; x=1706626518;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BQHcGmdM4nysgwNS5/yf0zA2YFS7llZYqjrDKqY2Ljc=;
  b=pSVxHavr6GIRT2/mf6PLNj1M5AhcHPJ1SojeEcrTYsmbvJMhnGnaS8mn
   oB574s5UMhGjqsW9Y5EtjqjaIohO5ibwO4IRdG1rKgwYPiBqCM2+Mh04a
   WEtVt29Tb2Bzjg2Nc/0qdQ4PsN8Jq7Wv5JEGzrDRPy8wtvWT7LgsDqrv0
   ULWxPr5g1XrGkchb8CzYHZE+U1Mrzf0/y867tJ9Qf27G0nzw8xkY8lAmG
   ak2ubVbu1jf0SAYTdwbO4gzZXu0ky+WRxkpi3YKnduGBmwKimy5Fapo9r
   TqmrEZlbpMZrtjrERNJBmi3OhPyFYn6g8IEuVZ19Ix1q6gQojvmsYjToC
   A==;
X-IronPort-AV: E=Sophos;i="5.97,258,1669046400"; 
   d="scan'208";a="326379303"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 22:55:10 +0800
IronPort-SDR: AJFGLdzI3oL94Hd60PG+JZfEvyiU6X0YJgrgGfA3g3CCABdmNo7kHCyiwr9DvwgRyDacuKboz3
 3pQpTb6EApJIF6p8ft9/BFRe126AJ05S3nmklNDneQUI3mCyOIe1X0F4IEotd+nKtf6viBWRXD
 AfiGmmbip1TUfAIWqlPW+UbgWvOXtwcqB405PrfNiX2bUX+2GU/9JCPMKUZ0E9S1A5sUN2Hzq/
 xyalqMMoYM/l6i+qROIF4WwoERhJliOHneUQ1u8ILfdjXaxPG+n4sxWg3RA/NJIbJWffdnjsMF
 ArU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2023 06:06:52 -0800
IronPort-SDR: UcZItnGuAZvAtE91g/BcWHz9iJyOYaC/rl0j03RiVncZdzrnj7s2eMhtplF9GNxUOh9eQuAc6w
 HdNn+ISb+oKjoNpw6pPq65a5zNULHoYv5YHj2OlhOIGZx4D2WqPsZY1p4/npsXuPweG021/jEd
 r7mgPWcvBlRqc2YsQ92ikmw0FRWCTaxON4+kFR+xbHusuQZCEkLA232NJl86khWQhMoGdqAuLM
 nox8nz0gLr2mJAnqd8RCDwMRD4CA2cllmB5lwzNajLudJtco15BcUqtQzx34AsrBTqzlKIIyBe
 kws=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2023 06:55:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P5B722tzTz1RwvT
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 06:55:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1675090509; x=1677682510; bh=BQHcGmdM4nysgwNS5/yf0zA2YFS7llZYqjr
        DKqY2Ljc=; b=tFXvLMSfWiO+zVha7KqPjeqtYZl1OJ7gJwuwEkuuprY8NL/iFeh
        GzvlEaUKK57LU4qfzIKslTJbLAfJGJyajj6WOq19Fw+jVIisqHbA2G4HNdYwXIvr
        +9qDvP1sDnOBvPHGk8pAqBvd8+AQNaDSjWrPf+G7pkND+BcnXRwdxx6rGbOrRr82
        GpzU0nQDffMy2s/K4VWgvrasD5gU0uvjFghBchBbm74IDert9btDxPiL8tR0gXMs
        j+zXMdh4XTcOPjF3kBIKvn/f7Avrx6TVFAcfxCJPdowpofupZfxuXPLfdlltnQQg
        /FeViPuNTqk74mEEilzENCTZLZN9MZ4nykA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cqTBW5OIOdBk for <linux-scsi@vger.kernel.org>;
        Mon, 30 Jan 2023 06:55:09 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P5B6z3xLmz1RvLy;
        Mon, 30 Jan 2023 06:55:07 -0800 (PST)
Message-ID: <0a2b9ba7-cc3f-400b-6a8a-c38ba269af75@opensource.wdc.com>
Date:   Mon, 30 Jan 2023 23:55:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
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
 <f58200e2-1652-c726-ceaf-be78feaab1bc@suse.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f58200e2-1652-c726-ceaf-be78feaab1bc@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/30/23 22:44, Hannes Reinecke wrote:
> On 1/29/23 04:52, Damien Le Moal wrote:
>> On 1/29/23 05:25, Martin K. Petersen wrote:
> [ .. ]
>>>
>>>     As such, I don't like the "just customize your settings with
>>>     cdltools" approach. I'd much rather see us try to define a few QoS
>>>     classes that make sense that would apply to every app and use those
>>>     to define the application interface. And then have the kernel program
>>>     those CDL classes into SCSI/ATA devices by default.
>>
>> Makes sense. Though I think it will be hard to define a set of QoS hints that
>> are useful for a wide range of applications, and even harder to convert the
>> defined hint classes to CDL descriptors. I fear that we may end up with the same
>> issues as IO hints/streams.
>>
>>>     Having the kernel provide an abstract interface for bio QoS and
>>>     configuring a new disk with a sane handful of classes does not
>>>     prevent $CLOUD_VENDOR from overriding what Linux configured. But at
>>>     least we'd have a generic approach to block QoS in Linux. Similar to
>>>     the existing I/O priority infrastructure which is also not tied to
>>>     any particular hardware feature.
>>
>> OK. See below about this.
>>
>>>     A generic implementation also allows us to do fancy things in the
>>>     hypervisor where we would like to be able to do QoS across multiple
>>>     devices as well. Without having ATA or SCSI with CDL involved. Or
>>>     whatever things might look like in NVMe.
>>
>> Fair point, especially given that virtio actually already forwards a guest
>> ioprio to the host through the virtio block command. Thinking of that particular
>> point together with what you said, I came up with the change show below as a
>> replacement for this patch 1/18.
>>
>> This changes the 13-bits ioprio data into a 3-bits QOS hint + 3-bits of IO prio
>> level. This is consistent with the IO prio interface since IO priority levels
>> have to be between 0 and 7 (otherwise, errors are returned). So in fact, the
>> upper 10-bits of the ioprio data are ignored and we can safely use 3 of these
>> bits for an IO hint.
>>
>> This hint applies to all priority classes and levels, that is, for the CDL case,
>> we can enrich any priority with a hint that specifies the CDL index to use for
>> an IO.
>>
>> This falls short of actually defining generic IO hints, but this has the
>> advantage to not break anything for current applications using IO priorities,
>> not require any change to existing IO schedulers, while still allowing to pass
>> CDL indexes for IOs down to the scsi & ATA layers (which for now would be the
>> only layers in the kernel acting on the ioprio qos hints).
>>
>> I think that this approach still allows us to enable CDL support, and on top of
>> it, go further and define generic QOS hints that IO scheduler can use and that
>> also potentially map to CDL for scsi & ata (similarly to the RT class IOs
>> mapping to the NCQ priority feature if the user enabled that feature).
>>
>> As mentioned above, I think that defining generic IO hint classes will be
>> difficult. But the change below is I think a good a starting point that should
>> not prevent working on that.
>>
>> Thoughts ?
>>
> I like the idea.
> QoS is one of the recurring topic always coming up sooner or later when 
> talking of storage networks, so having _some_ concept of QoS in the 
> linux kernel (for storage) would be beneficial.
> 
> Maybe time for a topic at LSF?

Yes. I was hoping for a quicker resolution so that we can get the CDL
"mechanical" bits in, but without a nice API for it, we cannot :)
Trying to compile something with Niklas. So far, we are thinking of having
QOS flags + QOS data, the flags determining how (and if) the QOS data is used
and what it means.

Ex of things We could have:
* IOPRIO_QOS_FAILFAST: do not retry the IO if it fails the first time
* IOPRIO_QOS_DURATION_LIMIT: then the QOS data indicates the limit to use
(number). That can be implemented in schedulers and also map to CDL on drives
that support that feature.

That is the difficult part: what else ? For now, considering only our target of
adding scsi & ata CDL support, the above is enough. But is that enough in
general for most users/apps ?

> 
> Cheers,
> 
> Hannes
> 

-- 
Damien Le Moal
Western Digital Research

