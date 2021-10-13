Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3D4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 22:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D76610CE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 22:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJMWCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:02:14 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:45921 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhJMWCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 18:02:13 -0400
Received: by mail-pl1-f181.google.com with SMTP id s1so929464plg.12
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 15:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bn5eBt3RZxAzYiobI7fZ4i/kcZaEO1UTtNhXWy7d4SM=;
        b=Yz6p6V9d2F5/EyTrBT0ieECWANmbLvVIHQ6g44V6D1uatFqbl7ShFkzafT4Ul6+JUD
         NF5bRMF+IRRS9odeIEWzLSuEO9Yayz19jlEc6bEd/Dq0cHPWfM+nNgW5AXTm61qlFfY8
         9RGpOtJPrFhj2g2v06ij4mHwrJqwT45hgZu3prqBebOapSRa+Q6EDJj5vG2goXJERdhs
         lCYo9Y26dc/eBpQWormq2FipTszXH6Db0yIwScALuy+1NzbtHzsbLaYmY/4BBs5GY7NR
         nA7cDbHRapk9bu7RuLizzwvAM7BJ/TieK/QhJMvkI9UuLCBFLcsNnpgj8O/XuUAD2oqn
         RZyA==
X-Gm-Message-State: AOAM5328cwrEEP5l32/p+vcgI3JHY91W4yZ2solvMGnZLlVSHcugyZaG
        2hCpLJajAUtFJm7qSpWaZMFzyjfMh7A=
X-Google-Smtp-Source: ABdhPJxO5Wgpg85nJQLsBMjLXtRWcn2iWE1Dm4c/KhI9GgBHTdplVibGdwTI6AFh75OQrhXOGG+haw==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr150868pjb.177.1634162409189;
        Wed, 13 Oct 2021 15:00:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae3:1dc1:f2a3:9c06])
        by smtp.gmail.com with ESMTPSA id z17sm423282pfa.148.2021.10.13.15.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:00:08 -0700 (PDT)
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
 <20211012144906.790579d0@songyl>
 <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
 <20211013065012.02b76336@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
Date:   Wed, 13 Oct 2021 15:00:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013065012.02b76336@songyl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 11:50 PM, Yanling Song wrote:
> On Tue, 12 Oct 2021 09:59:30 -0700
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Why is it that SG_IO is not sufficient? This is something that should
>> have been explained in the patch description.
> 
> There are two cases that there are no SG devices and SG_IO cannot work.
> 1. To access raid controller:
> a. Raid controller is a scsi host, not a scsi device, so there
> is no SG device associated with it.
> b. Even there is a scsi device for raid controller, SG_IO
> cannot work when something wrong with IO queue and only admin queue can
> work;
> 2. To access the physical disks behinds raid controller:
> raid controller only reports VDs to OS and only VDs have SG devices. OS
> has no idea about physical disks behinds raid controller and there is no
> SG devices associated with physical disks.

Please take a look at the bsg_setup_queue() call in ufs_bsg_probe(). 
That call associates a BSG queue with the UFS host. That queue supports 
requests of type struct ufs_bsg_request. The Fibre Channel transport 
driver does something similar. I believe that this is a better solution 
than introducing entirely new ioctls.

>>>> Additionally, mixing driver-internal and user space definitions in
>>>> a single header file is not OK. Definitions of data structures and
>>>> ioctls that are needed by user space software should occur in a
>>>> header file in the directory include/uapi/scsi/.
>>>
>>> Sounds reasonable. But after checking the directory
>>> include/uapi/scsi/, there are only several files in it. It is
>>> expected that there should be many files if developers follow the
>>> rule. Do you know why?
>>
>> If this rule is not followed, that will be a red flag for the SCSI
>> maintainer and something that will probably delay upstream acceptance
>> of this patch.
> 
> Since there are not much examples in include/uapi/scsi/, what' your
> suggestion on how to put the definitions into the folder? for example,
> what's the file name? spraid_ioctrl.h?

How about include/uapi/scsi/spraid.h, since I assume that that header 
file will cover all user space interfaces for interaction with the 
spraid driver?

Thanks,

Bart.

