Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724EEC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 14:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30AAF6142A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 14:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhD1OwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhD1OwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 10:52:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7D1C061573
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 07:51:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so754389pjd.4
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 07:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fiJ4ZkgkZjdwDEkXyL7+mcm098hxCoAsqRZ72SMrgS8=;
        b=VVM/kakAG7PmbcQH2cNFmOM/RFTneNgnfhpXQNaQu8CzPQWN69mT29ZnRhP4aNq+ym
         Wcvhp3dqk3ZUsr7VcZaqGgamXFyS9dbL9nsogWpWYsJ1yCsR88EdwaXgh0RGSSU1Bp7D
         LoQGbAmIIgGbaBUVPTuQhvIX3pox6T5siZYrJPes/pD/bTC8ppBemQtj50IRj5qitKdb
         dp83UwPudsOHNoITzT4kmmT09GNmEpGK6czejrTY8VmW+Nv+6IGyTMXi4cnDObbQO9Ye
         G+Sm1BngWVGCzCXUvEbq/3N/BVpWzaAIbdxna34lJIXmStUp/Ksj2TyZZWye5XBjLutQ
         HqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fiJ4ZkgkZjdwDEkXyL7+mcm098hxCoAsqRZ72SMrgS8=;
        b=mNYqpGeORbg6PYP7tOR/hWv5dhQxy3loNKZRut0nvKnntfDMsdv/IBvqS1dWD/u+kY
         nKGxwbEv+olqXTA6BRIphTX2cRev9z2ul4VOpiEXH8YdKKHrB5ncukTcgI/UKp7u8Jqo
         70ujjrKWeJAdK2L0z1TGm3D05axwREajhf1W0zNUnv4ZNBDGlGWyRCYC2wo7059dBMGb
         1ilAqyuDNagKzaMgiRwJyGi8ZG9JmQA4LYiUK/JYVyWV7F6XhC4W3sGaI1CS2T/5klzl
         BwLM9oOPfOXT3ggFvzLXG5u3E+xCfNKFvYCIwO4l2rnaaLCL7YfOwqqeuPmQJ2sOb3+e
         uyQg==
X-Gm-Message-State: AOAM530edsxPiY5MvvAAAmqU2wOH4vu5P6rBOc15lfjoVrtJi/e6vX1S
        ysq1A7BOc0g5WxQNMWNtVKw=
X-Google-Smtp-Source: ABdhPJwqEI3rfTmIpzYfv6Knpgq06uq+XT4DNeryolhBTOTmqR/Q9hZK2KgLBCC24lD/03dZFAtjSA==
X-Received: by 2002:a17:90b:109:: with SMTP id p9mr7709601pjz.12.1619621477920;
        Wed, 28 Apr 2021 07:51:17 -0700 (PDT)
Received: from [192.168.1.27] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z2sm27812pfj.203.2021.04.28.07.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:51:17 -0700 (PDT)
Subject: Re: [EXT] Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
To:     Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        James Smart <james.smart@broadcom.com>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
 <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
 <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <e6800e85-a8c0-efda-6be9-558dc2a5b898@gmail.com>
Date:   Wed, 28 Apr 2021 07:51:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/2021 5:25 PM, Arun Easi wrote:
> Hi Daniel,
> 
> On Tue, 20 Apr 2021, 11:28am, Daniel Wagner wrote:
> 
>> ----------------------------------------------------------------------
>> Hi Roman,
>>
>> On Tue, Apr 20, 2021 at 08:35:10PM +0300, Roman Bolshakov wrote:
>>> + James S.
>>>
>>> Daniel, WRT to your patch I don't think we should add one more approach
>>> to set dev_loss_tmo via kernel module parameter as NVMe adopters are
>>> going to be even more confused about the parameter. Just imagine
>>> knowledge bases populated with all sorts of the workarounds, that apply
>>> to kernel version x, y, z, etc :)
>>
>> Totally agree. I consider this patch just a hack and way to get the
>> discussion going, hence the RFC :) Well, maybe we are going to add it
>> downstream in our kernels until we have a better way for setting the
>> dev_loss_tmo.
>>
>> As explained the debugfs interface is not working (okay, that's
>> something which could be fixed) and it has the big problem that it is
>> not under control by udevd. Not sure if we with some new udev rules the
>> debugfs could automatically discovered or not.
> 
> Curious, which udev script does this today for FC SCSI?
> 
> In theory, the exsting fc nvmediscovery udev event has enough information
> to find out the right qla2xxx debugfs node and set dev_loss_tmo.
> 
>>
>>> What exists for FCP/SCSI is quite clear and reasonable. I don't know why
>>> FC-NVMe rports should be way too different.
>>
>> The lpfc driver does expose the FCP/SCSI and the FC-NVMe rports nicely
>> via the fc_remote_ports and this is what I would like to have from the
>> qla2xxx driver as well. qla2xxx exposes the FCP/SCSI rports but not the
>> FC-NVMe rports.
>>
> 
> Given that FC NVME does not have sysfs hierarchy like FC SCSI, I see
> utility in making FC-NVME ports available via fc_remote_ports. If, though,
> a FC target port is dual protocol aware this would leave with only one
> knob to control both.
> 
> I think, going with fc_remote_ports is better than introducing one more
> way (like this patch) to set this.
> 
> Regards,
> -Arun

Thanks Arun,

I think we're all better off if the qla exports the nvme nodes via the 
scsi-side fc_remote_ports.  In the end - we will commonize a fc 
transport that then sits above scsi and nvme and will definitely be 
compatible with what's there. The registration with scsi was rather 
straight-forward for lpfc, so I assume it will be for qla as well and 
the devloss interface, although kludegy to have the driver propagate the 
scsi callback to nvme, also isn't much.

I also don't think we want to keep creating new mgmt points. it's 
already ugly enough.

-- james

