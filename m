Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4906C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8D622AAD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389456AbhAKRch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:32:37 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:54895 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389452AbhAKRcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 12:32:36 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 245E52EA1A9;
        Mon, 11 Jan 2021 12:31:55 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id yaGzyk10uYa7; Mon, 11 Jan 2021 12:18:48 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E894F2EA088;
        Mon, 11 Jan 2021 12:31:53 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: About scsi device queue depth
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Cc:     chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <2ced546e-809a-20d1-940d-a78548eb0faa@interlog.com>
Date:   Mon, 11 Jan 2021 12:31:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-11 11:40 a.m., James Bottomley wrote:
> On Mon, 2021-01-11 at 16:21 +0000, John Garry wrote:
>> Hi,
>>
>> I was looking at some IOMMU issue on a LSI RAID 3008 card, and
>> noticed that performance there is not what I get on other SAS HBAs -
>> it's lower.
>>
>> After some debugging and fiddling with sdev queue depth in mpt3sas
>> driver, I am finding that performance changes appreciably with sdev
>> queue depth:
>>
>> sdev qdepth	fio number jobs* 	1	10	20
>> 16					1590	1654	1660
>> 32					1545	1646	1654
>> 64					1436	1085	1070
>> 254 (default)				1436	1070	1050
>>
>> fio queue depth is 40, and I'm using 12x SAS SSDs.
>>
>> I got comparable disparity in results for fio queue depth = 128 and
>> num jobs = 1:
>>
>> sdev qdepth	fio number jobs* 	1	
>> 16					1640
>> 32					1618	
>> 64					1577	
>> 254 (default)				1437	
>>
>> IO sched = none.
>>
>> That driver also sets queue depth tracking = 1, but never seems to
>> kick in.
>>
>> So it seems to me that the block layer is merging more bios per
>> request, as averge sg count per request goes up from 1 - > upto 6 or
>> more. As I see, when queue depth lowers the only thing that is really
>> changing is that we fail more often in getting the budget in
>> scsi_mq_get_budget()->scsi_dev_queue_ready().
>>
>> So initial sdev queue depth comes from cmd_per_lun by default or
>> manually setting in the driver via scsi_change_queue_depth(). It
>> seems to me that some drivers are not setting this optimally, as
>> above.
>>
>> Thoughts on guidance for setting sdev queue depth? Could blk-mq
>> changed this behavior?
> 
> In general, for spinning rust, you want the minimum queue depth

"Spinning rust" is starting to wear a bit thin. In power electronics
(almost) pure silicon is on the way out (i.e. becoming 'legacy').
It is being replaced by Silicon Carbide and Gallium Nitride.
What goes around, comes around :-)

Doug Gilbert

> possible for keeping the device active because merging is a very
> important performance enhancement and once the drive is fully occupied
> simply sending more tags won't improve latency.  We used to recommend a
> depth of about 4 for this reason.  A co-operative device can help you
> find the optimal by returning QUEUE_FULL when it's fully occupied so we
> have a mechanism to track the queue full returns and change the depth
> interactively.
> 
> For high iops devices, these considerations went out of the window and
> it's generally assumed (without varying evidence) the more tags the
> better.  SSDs have a peculiar lifetime problem in that when they get
> erase block starved they start behaving more like spinning rust in that
> they reach a processing limit but only for writes, so lowering the
> write queue depth (which we don't even have a knob for) might be a good
> solution.  Trying to track the erase block problem has been a constant
> bugbear.
> 
> I'm assuming you're using spinning rust in the above, so it sounds like
> the firmware in the card might be eating the queue full returns.  I
> could see this happening in RAID mode, but it shouldn't happen in jbod
> mode.
> 
> James
> 
> 

