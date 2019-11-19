Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F40FC43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D2D62245F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSXW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 18:22:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43094 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXW0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 18:22:26 -0500
Received: by mail-pf1-f196.google.com with SMTP id 3so13173648pfb.10;
        Tue, 19 Nov 2019 15:22:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lYMelxTb4rp6JkZGV6eASlzmVfuoka+SjbhRDEASiec=;
        b=OULJ8z6ds9J+xEtxwn6fhdW4R6v4/fU1O1/XgJSCZFfGIQQmUYJcuRIvXenyJoaL3m
         gBUUzwgz09xUS6bVXhyzxyu44DW68QcdgritaqNzarMby772078AkUuUbeqdBc7bkxMP
         y4pazLs5qpyQ/W/EpPz11RwzSRzciMWAY8Yc/TRWEolOXv6eWqKYJV2JUnkWQZ8b/SbW
         QddKyCIoSBizfMVSNhoT/Zi2CL1oC3B3pnb+GUghd4U5+J1Q/wvxxdEyNedTyhk3lXB8
         sAAfwtywETLcR7AiAz7YvWSery60fwHJEostgmicXWWI5ElJ4zL0lI7Dy1U5tIfX5o5F
         8tuQ==
X-Gm-Message-State: APjAAAUyL8LDziYX5XqisVnNnz+FX++pceKQ9v+mrvCYrl2FjRqJBWJt
        W75Q9MeFlabLgUAIUgB0gOQ=
X-Google-Smtp-Source: APXvYqx4YdAcks1LUiVVeLQqCxv0sAPpn2T1bYQeT13hGiAQ0QJrqTS8mn2WNlETGKXxtXWQECU5wg==
X-Received: by 2002:a65:4cc9:: with SMTP id n9mr8815172pgt.426.1574205745973;
        Tue, 19 Nov 2019 15:22:25 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l13sm4536977pjq.18.2019.11.19.15.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 15:22:25 -0800 (PST)
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter for
 SSDs
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com, sathya.prakash@broadcom.com,
        chaitra.basappa@broadcom.com,
        suganath-prabu.subramani@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        emilne@redhat.com, hch@lst.de, hare@suse.de, bart.vanassche@wdc.com
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8357148d-e819-4a3c-9834-25080e036781@acm.org>
Date:   Tue, 19 Nov 2019 15:22:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/19 12:07 PM, Sumanesh Samanta wrote:
> From: root <sumanesh.samanta@broadcom.com>
> 
> Recently a patch was delivered to remove host_busy counter from SCSI mid layer. That was a major bottleneck, and helped improve SCSI stack performance.
> With that patch, bottle neck moved to the scsi_device device_busy counter. The performance issue with this counter is seen more in cases where a single device can produce very high IOPs, for example h/w RAID devices where OS sees one device, but there are many drives behind it, thus being capable of very high IOPs. The effect is also visible when cores from multiple NUMA nodes send IO to the same device or same controller.
> The device_busy counter is not needed by controllers which can manage as many IO as submitted to it. Rotating media still uses it for merging IO, but for non-rotating SSD drives it becomes a major bottleneck as described above.
> 
> A few weeks back, a patch was provided to address the device_busy counter also but unfortunately that had some issues:
> 1. There was a functional issue discovered:
> https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4XC4VHWX5KKDJJI7P36EIGK526/
> 2. There was some concern about existing drivers using the device_busy counter.
> 
> This patch is an attempt to address both the above issues.
> For this patch to be effective, LLDs need to set a specific flag use_per_cpu_device_busy in the scsi_host_template. For other drivers ( who does not set the flag), this patch would be a no-op, and should not affect their performance or functionality at all.
> 
> Also, this patch does not fundamentally change any logic or functionality of the code. All it does is replace device_busy with a per CPU counter. In fast path, all cpu increment/decrement their own counter. In relatively slow path. they call scsi_device_busy function to get the total no of IO outstanding on a device. Only functional aspect it changes is that for non-rotating media, the number of IO to a device is not restricted. Controllers which can handle that, can set the use_per_cpu_device_busy flag in scsi_host_template to take advantage of this patch. Other controllers need not modify any code and would work as usual.
> Since the patch does not modify any other functional aspects, it should not have any side effects even for drivers that do set the use_per_cpu_device_busy flag.

Hi Sumanesh,

Can you have a look at the following patch series and see whether it has 
perhaps the same purpose as your patch?

https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat.com/

Thanks,

Bart.
