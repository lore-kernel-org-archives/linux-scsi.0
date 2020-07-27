Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD69C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 17:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBC02074F
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 17:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFt4xk3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgG0Rmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 13:42:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731256AbgG0Rmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 13:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595871758;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GPJHj7p2LacY4Ta5KOq4eAi0+Ch16+e8ZHqKKvhaWG4=;
        b=BFt4xk3IRMLJYsT9ePrh1OnUA2IJLKQUZhHBGrdlUjEy32hWuBhv0/AG7sWD60zccK7Lj3
        e1H6VAhGGgrMxcFkKaigNvDSp+tZBCuEBTVs5ChA6tsoGIhqUqJ98UkoJ3uC81yVjNYdEu
        NxGnqgVo20QmLQJJcK+Zn01WOj4rCak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-tb2Dog7AOUOfSPJ-dVwPuA-1; Mon, 27 Jul 2020 13:42:36 -0400
X-MC-Unique: tb2Dog7AOUOfSPJ-dVwPuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74B1E2D0;
        Mon, 27 Jul 2020 17:42:34 +0000 (UTC)
Received: from [10.3.128.8] (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3A2A5C1BD;
        Mon, 27 Jul 2020 17:42:32 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
To:     Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200726151035.GC20628@infradead.org>
 <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
 <bd1fb6dc-9fc1-0ee2-13a4-d221f28442c6@suse.de>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <a67a11dc-1a5a-648a-7ef1-cf36d3a56518@redhat.com>
Date:   Mon, 27 Jul 2020 12:42:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <bd1fb6dc-9fc1-0ee2-13a4-d221f28442c6@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 11:46 AM, Hannes Reinecke wrote:
> On 7/27/20 5:45 PM, Tony Asleson wrote:
>> On 7/26/20 10:10 AM, Christoph Hellwig wrote:
>>> FYI, I think these identifiers are absolutely horrible and have no
>>> business in dmesg:
>>
>> The identifiers are structured data, they're not visible unless you go
>> looking for them.
>>
>> I'm open to other suggestions on how we can positively identify storage
>> devices over time, across reboots, replacement, and dynamic
>> reconfiguration.
>>
>> My home system has 4 disks, 2 are identical except for serial number.
>> Even with this simple configuration, it's not trivial to identify which
>> message goes with which disk across reboots.
>>
> Well; the more important bits would be to identify the physical location
> where these disks reside.
> If one goes bad it doesn't really help you if have a persistent
> identification in the OS; what you really need is a physical indicator
> or a physical location allowing you to identify which disk to pull.

In my use case I have no slot information.  I have no SCSI enclosure
services to toggle identification LEDs or fault LEDs for the drive sled.
 For some users the device might be a virtual one in a storage server,
vpd helps.

In my case the in kernel vpd (WWN) data can be used to correlate with
the sticker on the disk as the disks have the WWN printed on them.  I
would think this is true for most disks/storage devices, but obviously I
can't make that statement with 100% certainty as I have a small sample size.

> Which isn't addressed at all with this patchset (nor should it; the
> physical location it typically found via other means).
> 
> And for the other use-cases: We do have persistent device links, do we
> not?

How does /dev/disk/by-* help when you are looking at the journal from 1
or more reboots ago and the only thing you have in your journal is
something like:

blk_update_request: critical medium error, dev sde, sector 43578 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0

The links are only valid for right now.

-Tony

