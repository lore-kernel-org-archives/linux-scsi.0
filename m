Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A87FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 14:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A760610A0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 14:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhJZOfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 10:35:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:19874 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235551AbhJZOfX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 10:35:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="228676436"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="228676436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 07:05:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="494217326"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 26 Oct 2021 07:05:45 -0700
Subject: Re: RE: please revert the UFS HPB support
To:     daejun7.park@samsung.com
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
References: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com>
 <20211021144210.GA28195@lst.de>
 <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
 <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de>
 <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
 <CGME20211023154316epcas2p208f95cf1e4a87a4b61d2daf1a2b3c725@epcms2p3>
 <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <159df0c8-0733-0b38-d907-8c1e632d96e6@intel.com>
Date:   Tue, 26 Oct 2021 17:05:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/10/2021 08:16, Daejun Park wrote:
>> On Thu, 2021-10-21 at 09:22 -0700, Bart Van Assche wrote:
>>> On 10/21/21 8:17 AM, Christoph Hellwig wrote:
>>>> On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
>>>>>>> I just noticed the UFS HPB support landed in 5.15, and just
>>>>>>> as before it is completely broken by allocating another
>>>>>>> request on the same device and then reinserting it in the
>>>>>>> queue.  It is bad enough that we have to live with
>>>>>>> blk_insert_cloned_request for dm-mpath, but this is too big
>>>>>>> of an API abuse to make it into a release.  We need to drop
>>>>>>> this code ASAP, and I can prepare a patch for that.
>>>>>>
>>>>>> That sounds awful, do you have a link to the offending
>>>>>> commit(s)?
>>>>>
>>>>> I'll need to look for it, busy in calls right now, but just grep
>>>>> for blk_insert_cloned_request.
>>>>
>>>> Might as well finish the git blame:
>>>>
>>>> commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
>>>> Author: Daejun Park <daejun7.park@samsung.com>
>>>> Date:   Mon Jul 12 18:00:25 2021 +0900
>>>>
>>>>      scsi: ufs: ufshpb: Add HPB 2.0 support
>>>>          
>>>>      Version 2.0 of HBP supports reads of varying sizes from 4KB to
>>>> 1MB.
>>>>
>>>>      A read operation <= 32KB is supported as single HPB read. A
>>>> read between
>>>>      36KB and 1MB is supported by a combination of write buffer
>>>> command and HPB
>>>>      read command to deliver more PPN. The write buffer commands
>>>> may not be
>>>>      issued immediately due to busy tags. To use HPB read more
>>>> aggressively, the
>>>>      driver can requeue the write buffer command. The requeue
>>>> threshold is
>>>>      implemented as timeout and can be modified with
>>>> requeue_timeout_ms entry in
>>>>      sysfs.
>>>
>>> (+Daejun)
>>>
>>> Daejun, can the HPB code be reworked such that it does not use 
>>> blk_insert_cloned_request()? I'm concerned that if the HPB code is
>>> not reworked that it will be removed from the upstream kernel.
>>  
>> Just to give urgency to Bart's request: we have two or three weeks
>> before the kernel is due to go final.  Can the problems identified by
>> Christoph be fixed within that timeframe?
> 
> I'm checking to see if I can replace blk_execute_rq_nowait with
> blk_insert_cloned_request in the HPB code.

In case it is of any use, there is an example of sending a REQUEST_SENSE
command directly here:

	https://lore.kernel.org/all/20210930124224.114031-2-adrian.hunter@intel.com

> 
>>  
>> Specifically, looking at the paper you reference, it only uses READ
>> BUFFER for the host cache sharing.  Since the JDEC standard appears to
>> be proprietary, I have no method of understanding why the driver now
>> uses WRITE BUFFER as well, but it appears to be a simple optimization. 
>> If you can cut out the WRITE BUFFER code, blk_insert_cloned_request()
>> will also be gone and thus the API abuse.  Can you get us a simple
>> patch doing this ASAP so we don't have to revert the driver?
> 
> If WRITE BUFFER is not used, only READs with a size of 32KB or less can be
> changed to HPB READs. This becomes a limiting factor in how READ
> performance can be improved by the HPB.
> 
> Thanks,
> Daejun
> 

