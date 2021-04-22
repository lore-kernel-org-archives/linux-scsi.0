Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B28CC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 23:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFE860FF1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 23:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbhDVX3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 19:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbhDVX3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 19:29:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD0C061574;
        Thu, 22 Apr 2021 16:29:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso270206pjn.0;
        Thu, 22 Apr 2021 16:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4TtuWRmxd6c7tO7/d2Lj8r80VpNylQlJV6QO2aOBW0E=;
        b=Ls6iOdIHabkazicNCeXQk+1LCdwk/s34fk1+ormyK5yAjiHdDoGMjuEvUzbtaiDxZR
         ojYPu50Ip9tkQjZoD2wwm/mEpYivWZjEv5FYASMuTCCvk6egMXV9eX888lP5wVt3aBeS
         PRQQrSorYTX5bcZaTkyQjG/SwlF9k6mbpHZ1p8muLXPYkjdZtJTwkZw38YBLXimNjbQE
         DCTONXGJ9xKwosXy6+6oRHJpDHeAEtFbco84Ix99ZsSfAS54J4L4hVBnyVJyqgnNcm63
         Q6T2AISvr9Bz+W5kq+vXeLaDtFlrcRON3bhX6n87XxU8sRrjhvpuw7uUv7rsHezncbJB
         c0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4TtuWRmxd6c7tO7/d2Lj8r80VpNylQlJV6QO2aOBW0E=;
        b=h+eyIOPatHOTdMaIx+w9f09+Uyx3TQCv0dl6j9ujHvUoBLodldpOhVBo6yAEXXMfqL
         Vc0FoS7f6I6NaQs46QkE+yLQh6C2jXSNM+SyNUKHAy3nXRx0Nlo6Vc1q0CyfCX0tz/Ka
         1bECgCn1h5FBpgIetyu9OMT9ocOg+AfVMEBNBq3VYl6Ek/mmPbQcAm5XIYH83hxkY380
         D0u94T26IQRV++NtG38vmHWzHqu7lPZPbX3GkYEoAFwTUPrpQA4fqYYPEagea1NzSuhF
         HvGgCgH8m5KbfLCoalXEyVW+u0af3AUFkh0HZwQb8jiTKCmDF4+Sa1Vkn9wvcU2b2W6e
         Hv9Q==
X-Gm-Message-State: AOAM533g4Bd8Ucl+Ii/SuK2AHjetjeBGY8c5F/3HO0RCTFF5t9KarXud
        7G87pnEJfF6/6IieX43Fov4=
X-Google-Smtp-Source: ABdhPJxwPM6t5pY9h03M0se/Wvu4DzAp47uOVtizRJfg5yRIzdI7rmVoAl+6rtTyYGcjGctLUxqHHg==
X-Received: by 2002:a17:90b:a0d:: with SMTP id gg13mr1256054pjb.124.1619134152150;
        Thu, 22 Apr 2021 16:29:12 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm3357917pgx.72.2021.04.22.16.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 16:29:11 -0700 (PDT)
Subject: Re: [PATCH v9 03/13] nvme: Added a newsysfs attribute appid_store
To:     Benjamin Block <bblock@linux.ibm.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Benjamin Block <lkml@mageta.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, tj@kernel.org,
        linux-nvme@lists.infradead.org, hare@suse.de, emilne@redhat.com,
        mkumar@redhat.com, Steffen Maier <maier@linux.ibm.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-4-git-send-email-muneendra.kumar@broadcom.com>
 <YHxRK33kf7OSVlxf@chlorum.ategam.org>
 <a6497bd924795a5a9279b893b0d83baf@mail.gmail.com>
 <YH62VB+SVfnG+GoI@t480-pf1aa2c2.linux.ibm.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <2eec720b-401a-32b4-80e6-900e136939b3@gmail.com>
Date:   Thu, 22 Apr 2021 16:29:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YH62VB+SVfnG+GoI@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/2021 4:09 AM, Benjamin Block wrote:
> On Tue, Apr 20, 2021 at 12:24:41PM +0530, Muneendra Kumar M wrote:
>> Hi Benjamin,
>>
>>>> ---
>>>>   drivers/nvme/host/fc.c | 73
>>>> +++++++++++++++++++++++++++++++++++++++++-
>>>>   1 file changed, 72 insertions(+), 1 deletion(-)
>>
>>> Hmm, I wonder why only NVMe-FC? Or is this just for the moment? We also
>>> have the FC transport class for SCSI; I assume this could feed the same
>>> IDs into the LLDs.
>>
>> At present it supports only for SCSI-FC .
> 
> It does? By adding it to the implementation under `drivers/nvme/host/`?
> I am confused.

Yeah, this is a little odd.

This history is: we know we need to merge the scsi fc transport and the 
nvme fc transport as the two independent things are creating 
difficulties and duplications (devloss is an example). But it's a bit of 
work to change this as it will move where the objects are in the 
topology tree.

As we tried to figure out how to do the interaction with cgroups, we 
wanted to support SCSI and nvme. If you look at how this new attribute 
sets the vmid, it's somewhat generic - it just sets the fc appid field 
on a cgrp id.  There's really nothing that says the cgrp is on a block 
device that is scsi or is nvme.  It should work on devices regardless of 
their underlying protocol type. Which then left the question - where to 
place such an attribute.

Given this is an "fc service" and as we knew the transport will be 
merged eventually we picked to put it under /sys/class/fc point which is 
where we expect to root the common transport. This class point happens 
to be owned/created by the nvme fc host code for requesting nve-fc 
rediscovery events. It is odd that it creates a requirement to load the 
nvme-fc transport in order to set values for scsi fc devices, but we 
deemed it acceptable.  Guess we need to get going on that merged 
transport...

-- james


