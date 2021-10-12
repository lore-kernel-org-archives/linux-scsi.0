Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7F8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3D060E0C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhJLXrf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:47:35 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:46061 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhJLXrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:47:33 -0400
Received: by mail-pj1-f45.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so847668pjb.4;
        Tue, 12 Oct 2021 16:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3yxPSZTmje6vkClYVtwew04+3BwDgKwstk6LgRrkTYg=;
        b=6ssDimnGxTCVmwC81c8ie189iReg5HIL6YD/woc2br3kfIyuSW1gvlkhDYjIrHDmhA
         CLg03pkDXI19nuAX3bjGc+zXWbH/8j7FeS5l/WOyqztAzauIvjr8FRbATQ2lnuav70XD
         1ypeBPdnFCkG2RDzqFVsj+MFhh6kRuPlZxS8tZWNizUWqaNq703utk1sWFX13llKTSI7
         8Pek+T7lie7PQuhhvPZ+l0Uk7d3o3B3lNJk7IsFwrkcc+heU00ndVLyWhUbyR6JnsfkI
         Y27OMmhl+2BRiZJwhU6LoqhMRWkEl0KNvjJGEsnoxu1QGWDBHdN4mi6qL3Ud/SJesp6t
         PJ4Q==
X-Gm-Message-State: AOAM532T+M7qW3zhr6f6jDksKkLPcR5qrE6SuE4p/xE1yq4vBRPhRqAE
        WkfQ+pd3uD5U6NOgp1Y6dBZ0Ol+nHY4IHg==
X-Google-Smtp-Source: ABdhPJwIcGnO4ZhT7jPpN3rw61+26Y08F4HHzSe7WxWusA1MjD2Bg6IPUqU77BhJLUyAWsQtOwvZ0Q==
X-Received: by 2002:a17:90a:e7c8:: with SMTP id kb8mr9423100pjb.95.1634082330838;
        Tue, 12 Oct 2021 16:45:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id i2sm3113341pjt.19.2021.10.12.16.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 16:45:30 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] acornscsi: remove tagged queuing vestiges
To:     Arnd Bergmann <arnd@kernel.org>, John Garry <john.garry@huawei.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
 <1631696835-136198-3-git-send-email-john.garry@huawei.com>
 <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <81ad7ca3-54c9-0952-e163-c7c05a04f559@acm.org>
Date:   Tue, 12 Oct 2021 16:45:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 12:21 AM, Arnd Bergmann wrote:
> On Wed, Sep 15, 2021 at 11:16 AM John Garry <john.garry@huawei.com> wrote:
>>
>> From: Hannes Reinecke <hare@suse.de>
>>
>> The acornscsi driver has a config option to enable tagged queuing,
>> but this option gets disabled in the driver itself with the comment
>> 'needs to be debugged'.
>> As this is a _really_ old driver I doubt anyone will be wanting to
>> invest time here, so remove the tagged queue vestiges and make
>> our live easier.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> jpg: Use scsi_cmd_to_rq()
>> Signed-off-by: John Garry <john.garry@huawei.com>
> 
> A few thousand randconfig builds later, I actually came across
> building this driver.

Building all SCSI code is nontrivial. The shell script that I am using 
myself to build all SCSI kernel code is available here: 
https://github.com/bvanassche/build-scsi-drivers

Bart.
