Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C164AC47095
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 05:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B5021897
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 05:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgJHFzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 01:55:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgJHFzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Oct 2020 01:55:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1BA43B00A;
        Thu,  8 Oct 2020 05:55:02 +0000 (UTC)
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     tasleson@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        pmladek@suse.com, David Lehman <dlehman@redhat.com>,
        sergey.senozhatsky@gmail.com, jbaron@akamai.com,
        James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        martin.petersen@oracle.com, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, akpm@linux-foundation.org, orson.zhai@unisoc.com,
        viro@zeniv.linux.org.uk
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org> <20200929180415.GA1400445@kroah.com>
 <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
 <20200930073859.GA1509708@kroah.com>
 <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
 <20201001114832.GC2368232@kroah.com>
 <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dedb9926-d4fb-af1a-8dc8-2bc0680d971a@suse.de>
Date:   Thu, 8 Oct 2020 07:54:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/20 10:10 PM, Tony Asleson wrote:
> On 10/1/20 6:48 AM, Greg Kroah-Hartman wrote:
>> On Wed, Sep 30, 2020 at 09:35:52AM -0500, Tony Asleson wrote:
>>> On 9/30/20 2:38 AM, Greg Kroah-Hartman wrote:
>>>> On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
>>>>> I'm trying to figure out a way to positively identify which storage
>>>>> device an error belongs to over time.
>>>>
>>>> "over time" is not the kernel's responsibility.
>>>>
>>>> This comes up every 5 years or so. The kernel provides you, at runtime,
>>>> a mapping between a hardware device and a "logical" device.  It can
>>>> provide information to userspace about this mapping, but once that
>>>> device goes away, the kernel is free to reuse that logical device again.
>>>>
>>>> If you want to track what logical devices match up to what physical
>>>> device, then do it in userspace, by parsing the log files.
>>>
>>> I don't understand why people think it's acceptable to ask user space to
>>> parse text that is subject to change.
>>
>> What text is changing? The format of of the prefix of dev_*() is well
>> known and has been stable for 15+ years now, right?  What is difficult
>> in parsing it?
> 
> Many of the storage layer messages are using printk, not dev_printk.
> 
So that would be the immediate angle of attack ...

>>>>> Thank you for supplying some feedback and asking questions.  I've been
>>>>> asking for suggestions and would very much like to have a discussion on
>>>>> how this issue is best solved.  I'm not attached to what I've provided.
>>>>> I'm just trying to get towards a solution.
>>>>
>>>> Again, solve this in userspace, you have the information there at
>>>> runtime, why not use it?
>>>
>>> We usually don't have the needed information if you remove the
>>> expectation that user space should parse the human readable portion of
>>> the error message.
>>
>> I don't expect that userspace should have to parse any human readable
>> portion, if they don't want to.  But if you do want it to, it is pretty
>> trivial to parse what you have today:
>>
>> 	scsi 2:0:0:0: Direct-Access     Generic  STORAGE DEVICE   1531 PQ: 0 ANSI: 6
>>
>> If you really have a unique identifier, then great, parse it today:
>>
>> 	usb 4-1.3.1: Product: USB3.0 Card Reader
>> 	usb 4-1.3.1: Manufacturer: Generic
>> 	usb 4-1.3.1: SerialNumber: 000000001531
>>
>> What's keeping that from working now?
> 
> I believe these examples are using dev_printk.  With dev_printk we don't
> need to parse the text, we can use the meta data.
> So it looks as most of your usecase would be solved by moving to 
dev_printk().
Why not work on that instead?
I do presume this will have immediate benefits for everybody, and will 
have approval from everyone.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
