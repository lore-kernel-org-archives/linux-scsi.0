Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40251C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 20:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7592075F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 20:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407433AbgE1U6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 16:58:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:40028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407414AbgE1U6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 16:58:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68345AD12;
        Thu, 28 May 2020 20:58:33 +0000 (UTC)
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
To:     Matthew Wilcox <willy@infradead.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c33c3000-caac-4b51-42fd-d6e13a9fd641@suse.de>
Date:   Thu, 28 May 2020 22:58:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528185402.GP17206@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/28/20 8:54 PM, Matthew Wilcox wrote:
> On Thu, May 28, 2020 at 01:50:02PM -0400, Douglas Gilbert wrote:
>> On 2020-05-28 12:36 p.m., Hannes Reinecke wrote:
>>> Use xarray for device lookup by target. LUNs below 256 are linear,
>>> and can be used directly as the index into the xarray.
>>> LUNs above 256 have a distinct LUN format, and are not necessarily
>>> linear. They'll be stored in indices above 256 in the xarray, with
>>> the next free index in the xarray.
> 
> I don't understand why you think this is an improvement over just
> using an allocating XArray for all LUNs.  It seems like more code,
> and doesn't actually save you any storage space ... ?
> 
The LUN range is 64 bit.
I was under the impression that xarray can only handle up to unsigned 
long; which probably would work for 64bit systems, but there _are_ users 
running on 32 bit, and they get patently unhappy when we have to tell 
them 'sorry, not for you'.

At least I _know_ that I'll get complaints if I try a stunt like this.

If you can make xarray 64 bit on all systems, sure, I'm game.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
