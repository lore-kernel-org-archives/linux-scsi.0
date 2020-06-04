Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1C7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561C6207D8
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgFDQMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:12:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbgFDQMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 12:12:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43FF2B23B;
        Thu,  4 Jun 2020 16:12:34 +0000 (UTC)
Subject: Re: [PATCHv4 0/6] scsi: use xarray for devices and targets
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200602113311.121513-1-hare@suse.de>
 <20200603125359.GA12995@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <73f1c9e2-0015-2707-91f0-02e75e2f9a0e@suse.de>
Date:   Thu, 4 Jun 2020 18:12:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603125359.GA12995@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/20 2:53 PM, Christoph Hellwig wrote:
> On Tue, Jun 02, 2020 at 01:33:05PM +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> based on the ideas from Doug Gilbert here's now my take on using
>> xarrays for devices and targets.
>> It revolves around two ideas:
>>
>> - The scsi target 'channel' and 'id' numbers are never ever used
>>    to the full 32 bit range; channels are well below 10, and no
>>    driver is using more than 16 bits for the id. So we can reduce
>>    the type of 'channel' and 'id' to 16 bits, and use the 32 bit
>>    value 'channel << 16 | id' as the index into the target xarray.
>> - Nearly every target only ever uses the first two levels of the
>>    4-level SCSI LUN structure, which means that we can use the
>>    linearized SCSI LUN id as an index into the xarray.
>>    If we ever come across targets utilizing more that 2 levels of
>>    the LUN structure we'll allocate the first unused index and have
>>    to resort to a less efficient lookup instead of direct indexing.
>>
>> With these changes we can implement an efficient lookup mechanism,
>> devolving into direct lookup for most cases. It also allows us to
>> detect duplicate entries or accidental overwrites of existing elements
>> by using xa_cmpxchg().
>> And iteration over targets and devices should be as efficient as the
>> current, list-based, approach.
>>
>> As usual, comments and reviews are welcome.
> 
> I see absolutely no argument for what the point of this series.  It adds
> more code, and I don't really see any indications for it fixing bugs,
> speeding up workloads, or reducing memory usage.
> 
 From my perspective this is a proof-of-concept; using xarrays to store 
targets and LUNs has the benefit that we can directly access the 
elements, and the lookup will be more efficient for larger setups.

But it's not a clear-cut solution, merely replacing one concept with 
some issues with another concept with another set of issues.

Guess the real benefit will come only if we manage to move to explicit 
scsi target removal, and not the implicit model of making the scsi 
target dependent on the underlying scsi devices we have now.
I'll be experimenting with that and will post an update for it.

I _do_ like the xarray for targets, though; they have a fixed location 
where they can go and as such xarray are a far more natural choice.
For LUNs it's less compelling as xarrays can't use 64bits generically as 
index, but still.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
