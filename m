Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF4CC41604
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637632087D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QysUbag6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgJGUKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728156AbgJGUKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602101428;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVhXhk+iF6o3RlOlKVnrK9GRKRrzsNTDLNFpzDWY1gw=;
        b=QysUbag67WNfOVsexGWZg+8I920WyGJc0UyiZh4HcD+DFsqOVAyil4ZEPhbXMMCD7VDaVv
        DOvheAHc8A7M340v3sF8QJXH3YvxQxzL6Jug/NzRyleh+5VkTAJeP43yS5XMpfrDx0qJo+
        FghL8+8KZyC8iBwzgm+XPq+Ea9wxWVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-FhXR8f0oOuC8yvhwtOO24Q-1; Wed, 07 Oct 2020 16:10:24 -0400
X-MC-Unique: FhXR8f0oOuC8yvhwtOO24Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DD4957050;
        Wed,  7 Oct 2020 20:10:21 +0000 (UTC)
Received: from [10.10.110.48] (unknown [10.10.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09D7F1002C01;
        Wed,  7 Oct 2020 20:10:17 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, pmladek@suse.com,
        David Lehman <dlehman@redhat.com>,
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
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
Date:   Wed, 7 Oct 2020 15:10:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001114832.GC2368232@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/1/20 6:48 AM, Greg Kroah-Hartman wrote:
> On Wed, Sep 30, 2020 at 09:35:52AM -0500, Tony Asleson wrote:
>> On 9/30/20 2:38 AM, Greg Kroah-Hartman wrote:
>>> On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
>>>> I'm trying to figure out a way to positively identify which storage
>>>> device an error belongs to over time.
>>>
>>> "over time" is not the kernel's responsibility.
>>>
>>> This comes up every 5 years or so. The kernel provides you, at runtime,
>>> a mapping between a hardware device and a "logical" device.  It can
>>> provide information to userspace about this mapping, but once that
>>> device goes away, the kernel is free to reuse that logical device again.
>>>
>>> If you want to track what logical devices match up to what physical
>>> device, then do it in userspace, by parsing the log files.
>>
>> I don't understand why people think it's acceptable to ask user space to
>> parse text that is subject to change.
> 
> What text is changing? The format of of the prefix of dev_*() is well
> known and has been stable for 15+ years now, right?  What is difficult
> in parsing it?

Many of the storage layer messages are using printk, not dev_printk.

>>>> Thank you for supplying some feedback and asking questions.  I've been
>>>> asking for suggestions and would very much like to have a discussion on
>>>> how this issue is best solved.  I'm not attached to what I've provided.
>>>> I'm just trying to get towards a solution.
>>>
>>> Again, solve this in userspace, you have the information there at
>>> runtime, why not use it?
>>
>> We usually don't have the needed information if you remove the
>> expectation that user space should parse the human readable portion of
>> the error message.
> 
> I don't expect that userspace should have to parse any human readable
> portion, if they don't want to.  But if you do want it to, it is pretty
> trivial to parse what you have today:
> 
> 	scsi 2:0:0:0: Direct-Access     Generic  STORAGE DEVICE   1531 PQ: 0 ANSI: 6
> 
> If you really have a unique identifier, then great, parse it today:
> 
> 	usb 4-1.3.1: Product: USB3.0 Card Reader
> 	usb 4-1.3.1: Manufacturer: Generic
> 	usb 4-1.3.1: SerialNumber: 000000001531
> 
> What's keeping that from working now?

I believe these examples are using dev_printk.  With dev_printk we don't
need to parse the text, we can use the meta data.

> In fact, I would argue that it does seem to work, as there are many
> commercial tools out there that seem to handle it just fine...

I'm trying to get something that's works for journalctl.

>>>> We've looked at user space quite a bit and there is an inherit race
>>>> condition with trying to fetch the unique hardware id for a message when
>>>> it gets emitted from the kernel as udev rules haven't even run (assuming
>>>> we even have the meta-data to make the association).
>>>
>>> But one moment later you do have the information, so you can properly
>>> correlate it, right?
>>
>> We could have the information if all the storage paths went through
>> dev_printk.  Here is what we get today when we encounter a read error
>> which uses printk in the block layer:
>>
>> {
>>         "_HOSTNAME" : "pn",
>>         "_TRANSPORT" : "kernel",
>>         "__MONOTONIC_TIMESTAMP" : "1806379233",
>>         "SYSLOG_IDENTIFIER" : "kernel",
>>         "_SOURCE_MONOTONIC_TIMESTAMP" : "1805611354",
>>         "SYSLOG_FACILITY" : "0",
>>         "MESSAGE" : "blk_update_request: critical medium error, dev
>> nvme0n1, sector 10000 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0",
>>         "PRIORITY" : "3",
>>         "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
>>         "__REALTIME_TIMESTAMP" : "1601471260802301",
>>         "_BOOT_ID" : "b03ed610f21d46ab8243a495ba5a0058",
>>         "__CURSOR" :
>> "s=a063a22bbb384da0b0412e8f652deabb;i=23c2;b=b03ed610f21d46ab8243a495ba5a0058;m=6bab28e1;t=5b087959e3cfd;x=20528862f8f765c9"
>> }
> 
> Ok, messy stuff, don't do that :)
> 
>> Unless you parse the message text you cannot make the association.  If
>> the same message was changed to dev_printk we would get:
>>
>>
>> {
>>         "__REALTIME_TIMESTAMP" : "1589401901093443",
>>         "__CURSOR" :
>> "s=caac9703b34a48fd92f7875adae55a2f;i=1c713;b=e2ae14a9def345aa803a13648b95429c;m=7d25b4f;t=5a58d77b85243;x=b034c2d3fb853870",
>>         "SYSLOG_IDENTIFIER" : "kernel",
>>         "_KERNEL_DEVICE" : "b259:917504",
>>         "__MONOTONIC_TIMESTAMP" : "131226447",
>>         "_UDEV_SYSNAME" : "nvme0n1",
>>         "PRIORITY" : "3",
>>         "_KERNEL_SUBSYSTEM" : "block",
>>         "_SOURCE_MONOTONIC_TIMESTAMP" : "130941917",
>>         "_TRANSPORT" : "kernel",
>>         "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
>>         "_HOSTNAME" : "pn",
>>         "SYSLOG_FACILITY" : "0",
>>         "_BOOT_ID" : "e2ae14a9def345aa803a13648b95429c",
>>         "_UDEV_DEVLINK" : [
>>                 "/dev/disk/by-uuid/22fc262a-d621-452a-a951-7761d9fcf0dc",
>>                 "/dev/disk/by-path/pci-0000:00:05.0-nvme-1",
>>
>> "/dev/disk/by-id/nvme-nvme.8086-4445414442454546-51454d55204e564d65204374726c-00000001",
>>                 "/dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_DEADBEEF"
>>         ],
>>         "MESSAGE" : "block nvme0n1: blk_update_request: critical medium
>> error, dev nvme0n1, sector 10000 op 0x0:(READ) flags 0x0 phys_seg 1 prio
>> class 0",
>>         "_UDEV_DEVNODE" : "/dev/nvme0n1"
>> }
> 
> Great, you have a udev sysname, a kernel subsystem and a way to
> associate that with a real device, what more are you wanting?

Did you miss in my example where it's currently a printk?  I showed what
it would look like if it was a dev_printk.

Journald is using _KERNEL_DEVICE to add the _UDEV_DEVLINK information to
the journal entry, it's not parsing the prefix of the message.

The above json is outputted from journalctl when you specify "-o
json-pretty".

>> Journald already knows how to utilize the dev_printk meta data.
> 
> And if you talk to the printk developers (which you seem to be keeping
> out of the loop here), they are ripping out the meta data facility as
> fast as possible.  So don't rely on extending that please.

Again, I'm not trying to keep anyone out of the loop.  Last I knew the
meta data capability wasn't being removed, maybe this has changed?

Ref.

https://lore.kernel.org/lkml/20191007120134.ciywr3wale4gxa6v@pathway.suse.cz/


>> One idea that I've suggested along the way is creating a dev_printk
>> function that doesn't change the message text.  We then avoid breaking
>> people that are parsing.  Is this something that would be acceptable to
>> folks?  It doesn't solve early boot where udev rules haven't even run,
>> but it's better.
> 
> I still fail to understand the root problem here.

IMHO one of the root problems is that many storage messages are still
using printk.  Changing messages to dev_printk has been met with resistance.


> Ok, no, I think I understand what you think the problem is, I just don't
> see why it is up to the kernel to change what we have today when there
> are lots of tools out there working just fine without any kernel changes
> needed.
> 
> So try explaining the problem as you see it please, so we all know where
> to work from.

To me the problem today is the kernel logs information to identify how a
storage device is attached, not what is attached.  I think you agree
with this statement.  The log information is not helpful without the
information to correlate to the actual device.  I think you also agree
with this too as you have mentioned it's user space's responsibility to
collect this so that the correlation can be done.

If the following are *both* true, we have a usable message that has the
correlated data with it in the journal.

1. The storage related kernel message goes through dev_printk
2. At the time of the message being emitted the device symlinks are present.

When those two things are both true, journalctl can do the following
(today):

$ journalctl /dev/disk/by-id/wwn-0x5002538844584d30


However, it usually can't because the above two things are rarely both
true at the same time for a given message for journald when it logs to
the journal.

You keep saying this is a user space issue, but I believe we still need
a bit of help from the kernel at the very least by migrating to
dev_printk or something similar that adds the same meta data without
changing the message text.

Yes, my patch series went one step further and added the device ID as
structured data to the log message, but I was also trying to minimize
the race condition between the kernel emitting a message and journald
not having the information to associate it to the hardware device.

If people have other suggestions please let them be known.

> But again, cutting out the developers of the subsystems you were wanting
> to modify might just be making me really grumpy about this whole
> thing...

Again, I'm sorry I didn't reach out to the correct people.  Hopefully
I've CC'd everyone that is appropriate for this discussion.


Thanks,
Tony

