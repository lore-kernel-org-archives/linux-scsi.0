Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86408C35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 00:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5485A21569
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 00:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R0Dfs6DQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgAXABu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:01:50 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43171 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgAXABu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 19:01:50 -0500
Received: by mail-il1-f196.google.com with SMTP id v69so289178ili.10
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 16:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=MHEUN+jWgjuLYhWatYEBYMGBlZr/1h19E0RrVeUaIMs=;
        b=R0Dfs6DQcAiry5jrwCbfaJPttuNPYdwVZHTWYXDUC29aAFFOzRf8aUlBeg4jq77ila
         oaMPQxAFdLXvNFlMwNSkcEQcEvnJ+eWv9C9+Uo29zBf2Rte6WTbfbGiT3X76fP6ajpDY
         cEkB+meTPstSlm6THCGkBrzgK8Z9EzZfRdknQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MHEUN+jWgjuLYhWatYEBYMGBlZr/1h19E0RrVeUaIMs=;
        b=MjkS0J9LxeQnK8UOjG4wSG5Aj0udJRSsPYVB0CgsVr78Wo0SIN390Ia8ZL7p/tIeUd
         mlJcAK8iUgr+izNKOVfjrCl/gzpiVPfap3vm/mImez9DdLUCyXa/WmL3VJ6ZswWvMVq3
         8At3YGq0gU9lws7LEqhIePEnajKfcYiQs3LCsEOEsL6VfxUd7aD3vu6NCPYMqdPSKFaJ
         idX82e9sFfomOatk202xns5QsRMsmL2HWmikiipZTQXSWCHb3O2TWJZPb79jmZ39l+tN
         L2VPUPmFb+Q1ggiTMMN69LSIplOOzyJDULOnEFEBDqOon6U/3Yyo99EoFgirzXmcK+Am
         +qjQ==
X-Gm-Message-State: APjAAAXmUTX3216NDY5YxPXpGFCVaU7PPO0bu3fx0STk7vMa1Ecuiw13
        5GsQgO3Jv14EXlDtYKwr8mgarq3wmhw=
X-Google-Smtp-Source: APXvYqwWfd1ja4rXfKu7Foi1LUMlfyLTbLKcEJ81vPO1P9+mbayLHBdEFLrW5ctPJSZ/1rdXVDbYbQ==
X-Received: by 2002:a92:8307:: with SMTP id f7mr767169ild.73.1579824109755;
        Thu, 23 Jan 2020 16:01:49 -0800 (PST)
Received: from [192.168.1.179] (c-67-190-35-197.hsd1.co.comcast.net. [67.190.35.197])
        by smtp.gmail.com with ESMTPSA id f76sm1078648ild.82.2020.01.23.16.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 16:01:48 -0800 (PST)
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD
 when HBA needs
To:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-6-ming.lei@redhat.com> <yq1y2u1if7t.fsf@oracle.com>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Message-ID: <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com>
Date:   Thu, 23 Jan 2020 17:01:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <yq1y2u1if7t.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

 >> A free host tag does not guarantee that the target

Your point is absolutely correct for a single SSD device, and probably 
for some low-end controllers, but not for high-end HBA that has its own 
queuing mechanism.

The high-end controllers might expose a SCSI interface, but can have all 
kind of devices (NVMe/SCSI/SATA) behind it, and has its own capability 
to queue IO and feed to devices as needed. Those devices should not be 
penalized with the overhead of the device_busy counter, just because 
they chose to expose themselves has SCSI devices (for historical and 
backward compatibility reasons). Rather they should be enabled, so that 
they can compete with devices exposing themselves as NVMe devices.
It is those devices that this patch is meant for, and Ming has provided 
a specific flag for it. For the devices that cannot tolerate more 
outstanding IO, they need not set the flag, and will be unaffected.

In my humble opinion, the SCSI stack should be flexible enough to 
support innovation and not limit some controllers, just because others 
might have limited capability, especially when a whitelist flag is 
provided so that such devices are unaffected.

sincerely,
Sumanesh


device can queue the command.

On 1/20/2020 9:52 PM, Martin K. Petersen wrote:
> Ming,
>
>> NVMe doesn't have such per-request-queue(namespace) queue depth, so it
>> is reasonable to ignore the limit for SCSI SSD too.
> It is really not. A free host tag does not guarantee that the target
> device can queue the command.
>
> The assumption that SSDs are somehow special because they are "fast" is
> not valid. Given the common hardware queue depth for a SAS device of
> ~128 it is often trivial to drive a device into a congestion
> scenario. We see it all the time for non-rotational devices, SSDs and
> arrays alike. The SSD heuristic is simply not going to fly.
>
> Don't get me wrong, I am very sympathetic to obliterating device_busy in
> the hot path. I just don't think it is as easy as just ignoring the
> counter and hope for the best. Dynamic queue depth management is an
> integral part of the SCSI protocol, not something we can just decide to
> bypass because a device claims to be of a certain media type or speed.
>
> I would prefer not to touch drivers that rely on cmd_per_lun / untagged
> operation and focus exclusively on the ones that use .track_queue_depth.
> For those we could consider an adaptive queue depth management scheme.
> Something like not maintaining device_busy until we actually get a
> QUEUE_FULL condition. And then rely on the existing queue depth ramp up
> heuristics to determine when to disable the busy counter again. Maybe
> with an additional watermark or time limit to avoid flip-flopping.
>
> If that approach turns out to work, we should convert all remaining
> non-legacy drivers to .track_queue_depth so we only have two driver
> queuing flavors to worry about.
>
