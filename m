Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7C6C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E2B2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgG0TSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:18:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34887 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbgG0TSL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Jul 2020 15:18:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 68FF3204255;
        Mon, 27 Jul 2020 21:18:09 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3R-2pdETWCgn; Mon, 27 Jul 2020 21:18:02 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 27CFF20415B;
        Mon, 27 Jul 2020 21:18:00 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
To:     tasleson@redhat.com, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200726151035.GC20628@infradead.org>
 <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
 <bd1fb6dc-9fc1-0ee2-13a4-d221f28442c6@suse.de>
 <a67a11dc-1a5a-648a-7ef1-cf36d3a56518@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <90798655-0ee1-330f-cae4-937c4981563a@interlog.com>
Date:   Mon, 27 Jul 2020 15:17:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a67a11dc-1a5a-648a-7ef1-cf36d3a56518@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-27 1:42 p.m., Tony Asleson wrote:
> On 7/27/20 11:46 AM, Hannes Reinecke wrote:
>> On 7/27/20 5:45 PM, Tony Asleson wrote:
>>> On 7/26/20 10:10 AM, Christoph Hellwig wrote:
>>>> FYI, I think these identifiers are absolutely horrible and have no
>>>> business in dmesg:
>>>
>>> The identifiers are structured data, they're not visible unless you go
>>> looking for them.
>>>
>>> I'm open to other suggestions on how we can positively identify storage
>>> devices over time, across reboots, replacement, and dynamic
>>> reconfiguration.
>>>
>>> My home system has 4 disks, 2 are identical except for serial number.
>>> Even with this simple configuration, it's not trivial to identify which
>>> message goes with which disk across reboots.
>>>
>> Well; the more important bits would be to identify the physical location
>> where these disks reside.
>> If one goes bad it doesn't really help you if have a persistent
>> identification in the OS; what you really need is a physical indicator
>> or a physical location allowing you to identify which disk to pull.
> 
> In my use case I have no slot information.  I have no SCSI enclosure
> services to toggle identification LEDs or fault LEDs for the drive sled.
>   For some users the device might be a virtual one in a storage server,
> vpd helps.
> 
> In my case the in kernel vpd (WWN) data can be used to correlate with
> the sticker on the disk as the disks have the WWN printed on them.  I
> would think this is true for most disks/storage devices, but obviously I
> can't make that statement with 100% certainty as I have a small sample size.
> 
>> Which isn't addressed at all with this patchset (nor should it; the
>> physical location it typically found via other means).
>>
>> And for the other use-cases: We do have persistent device links, do we
>> not?
> 
> How does /dev/disk/by-* help when you are looking at the journal from 1
> or more reboots ago and the only thing you have in your journal is
> something like:
> 
> blk_update_request: critical medium error, dev sde, sector 43578 op
> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> 
> The links are only valid for right now.

Does:
    lsscsi -U
or
    lsscsi -UU

solve your problem, or come close?

Example:
# lsscsi -UU
[1:0:0:0]    disk    naa.5000cca02b38d0b8  /dev/sda
[1:0:1:0]    disk    naa.5000c5003011cb2b  /dev/sdb
[1:0:2:0]    enclosu naa.5001b4d516ecc03f  -
[N:0:1:1]    disk    eui.e8238fa6bf530001001b448b46bd5525    /dev/nvme0n1

The first two (SAS SSDs) NAAs are printed on the disk labels. I don't
think either that enclosure or the M2 NVMe SSD have their numbers
visible (i.e. the last two lines of output).

If it is what you want, then perhaps you could arrange for its output
to be sent to the log when the system has stabilized after a reboot. That
would only leave disk hotplug events exposed.

Faced with the above medium error I would try:
    dd if=<all_possibles> bs=512 skip=43578 iflag=direct of=/dev/null count=1
and look for noise in the logs. Change 'bs=512' up to 4096 if that is
the logical block size. For <all_possibles> use /dev/sde (and /dev/sdf and
/dev/dev/sdg or whatever) IOWs the _whole_ disk device name.

Doug Gilbert
