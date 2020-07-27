Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A233AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 16:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 831BB2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 16:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgG0Qq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 12:46:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgG0Qqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Jul 2020 12:46:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFB8AAC1D;
        Mon, 27 Jul 2020 16:47:03 +0000 (UTC)
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
To:     tasleson@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200726151035.GC20628@infradead.org>
 <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bd1fb6dc-9fc1-0ee2-13a4-d221f28442c6@suse.de>
Date:   Mon, 27 Jul 2020 18:46:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 5:45 PM, Tony Asleson wrote:
> On 7/26/20 10:10 AM, Christoph Hellwig wrote:
>> FYI, I think these identifiers are absolutely horrible and have no
>> business in dmesg:
> 
> The identifiers are structured data, they're not visible unless you go
> looking for them.
> 
> I'm open to other suggestions on how we can positively identify storage
> devices over time, across reboots, replacement, and dynamic reconfiguration.
> 
> My home system has 4 disks, 2 are identical except for serial number.
> Even with this simple configuration, it's not trivial to identify which
> message goes with which disk across reboots.
> 
Well; the more important bits would be to identify the physical location 
where these disks reside.
If one goes bad it doesn't really help you if have a persistent 
identification in the OS; what you really need is a physical indicator 
or a physical location allowing you to identify which disk to pull.

Which isn't addressed at all with this patchset (nor should it; the 
physical location it typically found via other means).

And for the other use-cases: We do have persistent device links, do we 
not? They provide even more information that you'd extract with this 
this patchset, and don't require any kernel changes whatsoever.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
