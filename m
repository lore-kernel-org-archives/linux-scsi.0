Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15865C4727E
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 04:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72B221D7A
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 04:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgIYEzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 00:55:18 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55993 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgIYEzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 00:55:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 15E7420418F;
        Fri, 25 Sep 2020 06:55:16 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y7jVirbaeaYR; Fri, 25 Sep 2020 06:55:09 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id E3BC6204179;
        Fri, 25 Sep 2020 06:55:08 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: lib/scatterlist.c : sgl_alloc_order promises more than it
 delivers
To:     Bart Van Assche <bvanassche@acm.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
References: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
 <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d487005a-ef6c-549f-7006-c7056cf3f36d@interlog.com>
Date:   Fri, 25 Sep 2020 00:55:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-24 10:34 p.m., Bart Van Assche wrote:
> On 2020-09-24 18:46, Douglas Gilbert wrote:
>>          /* Check for integer overflow */
>>          if (length > (nent << (PAGE_SHIFT + order)))
>>                  return NULL;
>>
>> Well _integers_ don't wrap, but that pedantic point aside, 'nent' is an
>> unsigned int which means the rhs expression cannot represent 2^32 or
>> higher. So if length >= 2^32 the function fails (i.e. returns NULL).
>>
>> On 8 GiB and 16 GiB machines I can easily build 6 or 12 GiB sgl_s (with
>> scsi_debug) but only if no single allocation is >= 4 GiB due to the
>> above check.
>>
>> So is the above check intended to do that or is it a bug?
> 
> The above check verifies that nent << (PAGE_SHIFT + order) ==
> (uint64_t)nent << (PAGE_SHIFT + order). So I think it does what the
> comment says it does.

I modified sgl_alloc_order() like this:

         /* Check for integer overflow */
         if (length > (nent << (PAGE_SHIFT + order)))
{
pr_info("%s: (length > (nent << (PAGE_SHIFT + order))\n", __func__);
                 return NULL;
}
	...

Then I tried starting scsi_debug with dev_size_mb=4096

This is what I saw in the log:

scsi_debug:scsi_debug_init: fixing max submit queue depth to host max queue 
depth, 32
sgl_alloc_order: (length > (nent << (PAGE_SHIFT + order))
message repeated 2 times: [sgl_alloc_order: (length > (nent << (PAGE_SHIFT + 
order))]
scsi_debug:sdeb_store_sgat: sdeb_store_sgat: unable to obtain 4096 MiB, last 
element size: 256 kiB
scsi_debug:sdebug_add_store: sgat: user data oom
scsi_debug:sdebug_add_store: sdebug_add_store: failed, errno=12


My code steps down from 1024 KiB elements on failure to 512 KiB and if that
fails it tries 256 KiB. Then it gives up. The log output is consistent with
my analysis. So your stated equality is an inequality when length >= 4 GiB.
There is no promotion of unsigned int nent to uint64_t .

You can write your own test harness if you don't believe me. The test machine
doesn't need much ram. Without the call to sgl_free() corrected, if it really
did try to get that much ram and failed toward the end, then (partially)
freed up what it had obtained, then you would see a huge memory leak ...


Now your intention seems to be that a 4 GiB sgl should be valid. Correct?
Can that check just be dropped?

Doug Gilbert

