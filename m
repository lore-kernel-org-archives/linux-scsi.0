Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9728BC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 18:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B2D20734
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 18:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFCSYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 14:24:04 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47315 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCSYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jun 2020 14:24:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DF08F2041E3;
        Wed,  3 Jun 2020 20:24:01 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BaqSqbBBw73T; Wed,  3 Jun 2020 20:23:59 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 3F68C204172;
        Wed,  3 Jun 2020 20:23:57 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCHv4 0/6] scsi: use xarray for devices and targets
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200602113311.121513-1-hare@suse.de>
 <20200603125359.GA12995@lst.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <03657a10-0941-c866-ce0c-ee92635279a9@interlog.com>
Date:   Wed, 3 Jun 2020 14:23:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603125359.GA12995@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-03 8:53 a.m., Christoph Hellwig wrote:
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

Lets take memory usage first. The legacy design (part of which may have
been a later add-on) has three collections where two are needed:
    1) all targets in a host
    2) all sdev_s in a target
    3) all sdev_s in a host

So the third one is redundant and now removed (together with the
complexity of making sure those 3 collections are always in sync, seen
from the users' viewpoint). Each doubly linked collection on 64
bit machines uses 16 bytes (2 eight byte pointers). So that is a
32 byte reduction in each sdev object. The proposed solution adds 0
bytes because it uses the LUN as an index which is already there.
Similar but smaller win in scsi_target objects.

There are also some locks and mutexes in the three level object
tree (host-target-sdev[LU]) that can probably be dispensed with
as xarrays come with their own locks. That has not been done yet
making both my earlier proposal and this one "overlocked". And
locks and mutexes take up space in objects and slow things down.


The speeding up will come in big machine startup and shutdown and
its reaction time to disruptions (e.g. cable disconnected to a disk
array) IMO. xarray and explicit parent pointers give us a faster
way to navigate up and down the object tree. With this patchset we
have an O(ln(n)) lookup in the downward direction where currently we
only have O(n). Very little use is made of the "lookup" functions in
the API because users could see that it was just an iteration
(i.e. O(n)). Hopefully transports will take advantage of faster
lookups and perhaps implement their own xarrays. Even the upward
navigation can be complicated by transports inserting levels between
the host and the target. This is what the SCSI mid-layer object tree
looks like moving upwards from a SAS SSD, connected to an
SAS expander, moving up to its host (a HBA):
     scsi_device, ptr=ffff99d23f513960
     scsi_target, ptr=ffff99d241595c28
     sas_rphy, ptr=ffff99d242519c00
     sas_port, ptr=ffff99d24251ec00
     sas_expander_device, ptr=ffff99d23f4c6438
     sas_port, ptr=ffff99d23f4c7400
     Scsi_Host, ptr=ffff99d2425261f8

There already is a scsi_device::host redundant pointer to bypass the
oft-called and slow-walking dev_to_shost(). I'm proposing another
redundant scsi_target::parent_shost pointer that will bypass seven
dev_to_shost() invocations.

Currently all iterations are done under the host_lock as that is
required for doubly linked list safety. xarray uses rcu read locks
on all non-modifying operations including iterations and if we can
safely rely on them, that will increase the available parallelism
within one host.

Finally the SCSI fast path will usually require the presence the
corresponding sdev object, preferably cached. So making it smaller
will help.

Doug Gilbert


P.S. I sidestepped the "bugs" issue. Surely we will add some but
it is hard to believe when you wade into the complexity of the
currently linked collections and their myriad of locks, that there
aren't subtle bugs in the existing code. I have been working with
xarrays for about 1 year and finding locking issues is easier
with xarrays compared to "roll your own" linked list locking, IMO.

