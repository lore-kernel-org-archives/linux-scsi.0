Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D3DC61DA7
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjA1Aru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 19:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjA1Art (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 19:47:49 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCA746BE;
        Fri, 27 Jan 2023 16:47:46 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id k18so6614686pll.5;
        Fri, 27 Jan 2023 16:47:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ryr84wsUJIMZ57kWx2Cs6Q3jzSgpVyG63J+AUfuZris=;
        b=j5Fhbip82VwDXNg/1VnZtWigYOVkTovV9Xt5jiKR/PAqkSYO8jl2giIueeugkWmjR8
         DICfiKrrHsTyMMcU+1Z626zi8IyOE7n6U9HmvW7UEmlkZUhijftRi6eHriDiHcsin5RG
         PoQMHqZFvRx85teYBY2CYus5lBbjdPgFW0koXaeRDek/lcmVYyBXnL7OxP9AHxQrKlVi
         A/4OcounQxHHypaFDHHBpM+CoEcI3w4ooNEx+xW90zpuYQEKBEqHU7Q6cK0uNoq6FcF9
         XU17xaLS3h61LwNu9fbkyoKWLv1AhyYxqfJkT1VSeU+DHTG74thbtV5Y6g/6VIEuIOXb
         maVg==
X-Gm-Message-State: AO0yUKUGydI94ayi6bbdeI9QjsIkPFBbTRWsS5YzSBO0RqVo++h8QItl
        wEmCF1nECJ2uyJqDqCf4/Sw=
X-Google-Smtp-Source: AK7set/uCniHvq1kqtmCrrtwiA5G1QX+e9UIKPItC+M0oDDS4YBbisKOtqTemrfmrhOhagzXUFOJAA==
X-Received: by 2002:a17:902:d4c7:b0:196:1608:d755 with SMTP id o7-20020a170902d4c700b001961608d755mr17343536plg.60.1674866865539;
        Fri, 27 Jan 2023 16:47:45 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5051:6ed0:9022:37aa? ([2620:15c:211:201:5051:6ed0:9022:37aa])
        by smtp.gmail.com with ESMTPSA id e15-20020a170902784f00b00196048cc113sm1877003pln.126.2023.01.27.16.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 16:47:44 -0800 (PST)
Message-ID: <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
Date:   Fri, 27 Jan 2023 16:47:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
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
 <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
 <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/23 16:40, Damien Le Moal wrote:
> On 1/28/23 02:23, Bart Van Assche wrote:
>> I hope that I have it made it clear that I think that the proposed user
>> space API will be very painful to use for application developers.
> 
> I completely disagree. Reusing the prio class/level API made it easy to allow
> applications to use the feature. fio support for CDL requires exactly *one line*
> change, to allow for the CDL class number 4. That's it. From there, one can use
> the --cmdprio_class=4 nd --cmdprio=idx options to exercise a drive. The value of
> "idx" here of course depends on how the descriptors are set on the drive. But
> back to the point above. This depends on the application goals and the
> descriptors are set accordingly for that goal. There is no real discovery needed
> by the application. The application expect a certain set of CDL limits for its
> use case, and checking that this set is the one currently defined on the drive
> is easy to do from an application with the sysfs interface we added.
> 
> Many users out there have deployed and using applications taking advantage of
> ATA NCQ priority feature, using class RT for high priority IOs. The new CDL
> class does not require many application changes to be enabled for next gen
> drives that will have CDL.
  As I mentioned before, the new I/O priority class IOPRIO_CLASS_DL 
makes it impossible to use a single I/O priority class across devices 
that support CDL and devices that do not support CDL. I'm surprised that 
you keep denying that IOPRIO_CLASS_DL is a royal pain for users who have 
to support devices that support CDL and devices that do not support CDL.

Bart.
