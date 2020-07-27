Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8756AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 20:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608AD2074F
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 20:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/nKDXU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgG0U1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:27:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22263 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgG0U1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 16:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595881668;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CwKmubcIReo7OG/Ru61MF52rixv+ulVEz8sMP+mOKY8=;
        b=G/nKDXU9Pz7uzV9XBOy+8malhC2Q5Le8shQhD+BD6XGAhJ3S+QlCfe9yw/LVLvpLS/cUGX
        7FxaicRqBKFU8nFmAAZ7AQziaRJE/h/UHcEnWhX+SEtx9pCnn60RFm3vHKKVTlmQY8/egg
        liYdswjyBcgEhgFeBNBZ9DPoDkrepag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-T1zP8mhaNziATfke2YsjeA-1; Mon, 27 Jul 2020 16:27:44 -0400
X-MC-Unique: T1zP8mhaNziATfke2YsjeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC5A79EC0;
        Mon, 27 Jul 2020 20:27:42 +0000 (UTC)
Received: from [10.3.128.8] (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2F866842F;
        Mon, 27 Jul 2020 20:27:40 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
To:     dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200726151035.GC20628@infradead.org>
 <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
 <bd1fb6dc-9fc1-0ee2-13a4-d221f28442c6@suse.de>
 <a67a11dc-1a5a-648a-7ef1-cf36d3a56518@redhat.com>
 <90798655-0ee1-330f-cae4-937c4981563a@interlog.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <6973893a-eda8-6128-b484-7c89c1dc5070@redhat.com>
Date:   Mon, 27 Jul 2020 15:27:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <90798655-0ee1-330f-cae4-937c4981563a@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 2:17 PM, Douglas Gilbert wrote:
> On 2020-07-27 1:42 p.m., Tony Asleson wrote:
>> On 7/27/20 11:46 AM, Hannes Reinecke wrote:
>>> On 7/27/20 5:45 PM, Tony Asleson wrote:
>>>> On 7/26/20 10:10 AM, Christoph Hellwig wrote:
>>>>> FYI, I think these identifiers are absolutely horrible and have no
>>>>> business in dmesg:
>>>>
>>>> The identifiers are structured data, they're not visible unless you go
>>>> looking for them.
>>>>
>>>> I'm open to other suggestions on how we can positively identify storage
>>>> devices over time, across reboots, replacement, and dynamic
>>>> reconfiguration.
>>>>
>>>> My home system has 4 disks, 2 are identical except for serial number.
>>>> Even with this simple configuration, it's not trivial to identify which
>>>> message goes with which disk across reboots.
>>>>
>>> Well; the more important bits would be to identify the physical location
>>> where these disks reside.
>>> If one goes bad it doesn't really help you if have a persistent
>>> identification in the OS; what you really need is a physical indicator
>>> or a physical location allowing you to identify which disk to pull.
>>
>> In my use case I have no slot information.  I have no SCSI enclosure
>> services to toggle identification LEDs or fault LEDs for the drive sled.
>>   For some users the device might be a virtual one in a storage server,
>> vpd helps.
>>
>> In my case the in kernel vpd (WWN) data can be used to correlate with
>> the sticker on the disk as the disks have the WWN printed on them.  I
>> would think this is true for most disks/storage devices, but obviously I
>> can't make that statement with 100% certainty as I have a small sample
>> size.
>>
>>> Which isn't addressed at all with this patchset (nor should it; the
>>> physical location it typically found via other means).
>>>
>>> And for the other use-cases: We do have persistent device links, do we
>>> not?
>>
>> How does /dev/disk/by-* help when you are looking at the journal from 1
>> or more reboots ago and the only thing you have in your journal is
>> something like:
>>
>> blk_update_request: critical medium error, dev sde, sector 43578 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>>
>> The links are only valid for right now.
> 
> Does:
>    lsscsi -U
> or
>    lsscsi -UU
> 
> solve your problem, or come close?
> 
> Example:
> # lsscsi -UU
> [1:0:0:0]    disk    naa.5000cca02b38d0b8  /dev/sda
> [1:0:1:0]    disk    naa.5000c5003011cb2b  /dev/sdb
> [1:0:2:0]    enclosu naa.5001b4d516ecc03f  -
> [N:0:1:1]    disk    eui.e8238fa6bf530001001b448b46bd5525    /dev/nvme0n1
> 
> The first two (SAS SSDs) NAAs are printed on the disk labels. I don't
> think either that enclosure or the M2 NVMe SSD have their numbers
> visible (i.e. the last two lines of output).
> 
> If it is what you want, then perhaps you could arrange for its output
> to be sent to the log when the system has stabilized after a reboot. That
> would only leave disk hotplug events exposed.

Yes, if we write a new udev rule or script we could place bread crumbs
in the journal so we can correlate
sda == naa.5000cca02b38d0b8 at the time of the error.  However, none of
the existing tooling will allow you to see all the log messages that
pertain to the device easily.  The user is still left with a bunch of
log messages that have different ways to refer to the same device
attachment eg. sda, ata1.00, sd 0:0:0:0.  For them to understand which
messages go with which device is not trivial.  Even if someone writes a
tool to parse the messages, looking for the string that contains the ID
and has the needed decoder information to associate it with the correct
piece of hardware, it's only good until the message changes in the kernel.

If we stuff the defacto ID into the message itself when it occurs, the
ambiguity of what device is associated with a message is removed.

I would like to know, why this is so horrible?  Is it processing time in
an error path?  Stack usage holding the data in flight, wasted disk
space on disk?  Unique identifiers are just too long and terse?

The only valid reason I can think of is someone working with very
sensitive data and not wanting the unique ID of a removable or network
storage device to be in their logs.  Of course we could add a disable
boot time option for that or make the default off for those that don't
want/care.

> Faced with the above medium error I would try:
>    dd if=<all_possibles> bs=512 skip=43578 iflag=direct of=/dev/null
> count=1
> and look for noise in the logs. Change 'bs=512' up to 4096 if that is
> the logical block size. For <all_possibles> use /dev/sde (and /dev/sdf and
> /dev/dev/sdg or whatever) IOWs the _whole_ disk device name.

Assuming the error reproduces, this would work.  However, I think this
solution speaks volumes for how difficult it is to simply identify what
device an error originated from.

-Tony

