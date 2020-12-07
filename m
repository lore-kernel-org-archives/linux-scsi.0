Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75234C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 22:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4575A2395A
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 22:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgLGWNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 17:13:04 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:46701 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLGWNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 17:13:04 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 57DD82EA0BF;
        Mon,  7 Dec 2020 17:12:22 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id G7eYR5PKV6Ue; Mon,  7 Dec 2020 17:01:35 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2ED332EA040;
        Mon,  7 Dec 2020 17:12:20 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
Date:   Mon, 7 Dec 2020 17:12:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-07 9:56 a.m., Hannes Reinecke wrote:
> On 12/7/20 3:11 PM, Christoph Hellwig wrote:
>> So, I'm really worried about:
>>
>>   a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>>      does accelating dm-kcopyd.  I agree with Damien that lifting dm-kcopyd
>>      to common code would also be really nice.  I'm not 100% sure it should
>>      be a requirement, but it sure would be nice to have
>>      I don't think just adding an ioctl is enough of a use case for complex
>>      kernel infrastructure.
>>   b) We had a bunch of different attempts at SCSI XCOPY support form IIRC
>>      Martin, Bart and Mikulas.  I think we need to pull them into this
>>      discussion, and make sure whatever we do covers the SCSI needs.
>>
> And we shouldn't forget that the main issue which killed all previous 
> implementations was a missing QoS guarantee.
> It's nice to have simply copy, but if the implementation is _slower_ than doing 
> it by hand from the OS there is very little point in even attempting to do so.
> I can't see any provisions for that in the TPAR, leading me to the assumption 
> that NVMe simple copy will suffer from the same issue.
> 
> So if we can't address this I guess this attempt will fail, too.

I have been doing quite a lot of work and testing in my sg driver rewrite
in the copy and compare area. The baselines for performance are dd and
io_uring-cp (in liburing). There are lots of ways to improve on them. Here
are some:
    - the user data need never pass through the user space (could
      mmap it out during the READ if there is a good reason). Only the
      metadata (e.g. NVMe or SCSI commands) needs to come from the user
      space and errors, if any, reported back to the user space.
    - break a large copy (or compare) into segments, with each segment
      a "comfortable" size for the OS to handle, say 256 KB
    - there is one constraint: the READ in each segment must complete
      before its paired WRITE can commence
      - extra constraint for some zoned disks: WRITEs must be
        issued in order (assuming they are applied in that order, if
        not, need to wait until each WRITE completes)
    - arrange for READ WRITE pair in each segment to share the same bio
    - have multiple slots each holding a segment (i.e. a bio and
      metadata to process a READ-WRITE pair)
    - re-use each slot's bio for the following READ-WRITE pair
    - issue the READs in each slot asynchronously and do an interleaved
      (io)poll for completion. Then issue the paired WRITE
      asynchronously
    - the above "slot" algorithm runs in one thread, so there can be
      multiple threads doing the same algorithm. Segment manager needs
      to be locked (or use an atomics) so that each segment (identified
      by its starting LBAs) is issued once and only once when the
      next thread wants a segment to copy

Running multiple threads gives diminishing or even worsening returns.
Runtime metrics on lock contention and storage bus capacity may help
choosing the number of threads. A simpler approach might be add more
threads until the combined throughput increase is less than 10% say.


The 'compare' that I mention is based on the SCSI VERIFY(BYTCHK=1) command
(or NVMe NVM Compare command). Using dd logic, a disk to disk compare can
be implemented with not much more work than changing the WRITE to a VERIFY
command. This is a different approach to the Linux cmp utility which
READs in both sides and does a memcmp() type operation. Using ramdisks
(from the scsi_debug driver) the compare operation (max ~ 10 GB/s) was
actually faster than the copy (max ~ 7 GB/s). I put this down to WRITE
operations taking a write lock over the store while the VERIFY only
needs a read lock so many VERIFY operations can co-exist on the same
store. Unfortunately on real SAS and NVMe SSDs that I tested the
performance of the VERIFY and NVM Compare commands is underwhelming.
For comparison, using scsi_debug ramdisks, dd copy throughput was
< 1 GB/s and io_uring-cp was around 2-3 GB/s. The system was Ryzen
3600 based.

Doug Gilbert
